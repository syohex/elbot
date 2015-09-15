# Description:
#   Emacs Lisp evaluation bot.
#
# Configuration
#   Nothing
#
# Commands:
#   elbot eval s-expression - Evaluate s-expression
#   elbot doc query         - Show documentation about query

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
        cmd = pidCmd[2]
        if (daemonRe.test cmd) and (/emacs/.test cmd)
          process.kill pid
          removeSocket daemon


runEmacsClient = (res, sexp, daemon) ->
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


runEmacsDaemon = () ->
  removeSocket()
  daemonName = nextDaemonName()
  child.spawn 'emacs', ["-Q", "--daemon=#{daemonName}", "-l", "./elisp/init.el"]
  daemonName


module.exports = (robot) ->
  robot.respond /eval (.+)/i, (res) ->
    sexp = res.match[1]
    name = runEmacsDaemon()
    setTimeout(runEmacsClient, 1000, res, sexp, name)

  robot.respond /doc (.+)/i, (res) ->
    sexp = "(elbot-doc '#{res.match[1]})"
    name = runEmacsDaemon()
    setTimeout(runEmacsClient, 1000, res, sexp, name)
