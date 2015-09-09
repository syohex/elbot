execFile = require('child_process').execFile;

module.exports = (robot) ->
  robot.respond /eval (.+)/i, (res) ->
    args = ['-s', 'elbot', "-e", res.match[1]]
    opt = {timeout: 5000}
    child = execFile 'emacsclient', args, opt, (err, stdout, stderr) ->
      if err != null
        res.send err
      else
        result = stdout.toString()
        formatted = result.replace(/\\n/g, "\n")
        res.send formatted

  robot.respond /doc (.+)/i, (res) ->
    args = ['-s', 'elbot', "-e", "(elbot-doc '#{res.match[1]})"]
    opt = {timeout: 5000}
    child = execFile 'emacsclient', args, opt, (err, stdout, stderr) ->
      if err != null
        res.send err
      else
        result = stdout.toString()
        formatted = result.replace(/\\n/g, "\n")
        res.send formatted
