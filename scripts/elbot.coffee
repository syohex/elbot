child = require('child_process');
fs = require('fs')

daemonIndex = 0

nextDaemonName = () ->
  daemon = daemonIndex & 0xffff
  daemonIndex = ((daemonIndex + 1) & 0xffff)
  "elbot#{daemon}"

removeSocket = (daemon) ->
  try
    fs.unlinkSync "/tmp/emacs#{process.getuid()}/#{daemon}"

killEmacsDaemon = (daemon) ->
  args = ["-eo", "pid,args"]
  ps = child.execFile 'ps', args, (err, stdout, stderr) ->
    if err != null
      return

    daemonRe = new RegExp("#{daemon}")
    lines = stdout.toString().split(/\n/)
    for line in lines
      if pidCmd = /^\s*(\d+) (.*)$/.exec line
        pid = parseInt(pidCmd[1], 10)

        if daemonRe.test pidCmd[2]
          process.kill pid
          removeSocket daemon


runEmacsClient = (res, sexp, emacs, daemon) ->
  clientArgs = ['-s', daemon, "-e", sexp]
  clientOpt  = {timeout: 3000}
  eclient = child.execFile 'emacsclient', clientArgs, clientOpt, (err, stdout, stderr) ->
    if err != null
      if /\*ERROR\*/.test stderr
        res.send stderr
      else
        res.send "Timeout :alarm_clock: client: #{err}"
    else
      result = stdout.toString()
      if matched = /^"\[ELBOT_ERROR\](.+)/.exec result
        errmsg = matched[1]
        formatted = errmsg.replace(/^"/, "").replace(/"\s*$/, "").replace(/\\n/g, "\n")
      else
        formatted = result.replace(/\\n/g, "\n")

      res.send formatted

    setTimeout(killEmacsDaemon, 5000, daemon)


module.exports = (robot) ->
  robot.respond /eval (.+)/i, (res) ->
    sexp = res.match[1]
    removeSocket()

    daemonName = nextDaemonName()
    emacs = child.spawn 'emacs', ["-Q", "--daemon=#{daemonName}", "-l", "./elisp/init.el"]
    setTimeout(runEmacsClient, 1000, res, sexp, emacs, daemonName)

  robot.respond /doc (.+)/i, (res) ->
    args = ['-s', 'elbot', "-e", "(elbot-doc '#{res.match[1]})"]
    opt = {timeout: 5000}
    eclient = child.execFile 'emacsclient', args, opt, (err, stdout, stderr) ->
      if err != null
        res.send err
      else
        result = stdout.toString()
        formatted = result.replace(/^"/g, "").replace(/"\s*$/g, "").replace(/\\n/g, "\n")
        res.send formatted
