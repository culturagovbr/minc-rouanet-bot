fs = require 'fs'
yaml = require 'js-yaml'

common = {}

common.applyVariable = (string, variable, value, regexFlags = 'i') ->
  string.replace new RegExp("(^|\\W)\\$#{variable}(\\W|$)", regexFlags), (match) ->
    match.replace "$#{variable}", value

common.msgVariables = (message, msg, variables = {}) ->
  message = common.applyVariable message, 'user', msg.envelope.user.name
  message = common.applyVariable message, 'bot', msg.robot.alias
  message = common.applyVariable message, 'room', msg.envelope.room if msg.envelope.room?
  for key, value of variables
    message = common.applyVariable message, key, value
  return message

common.stringElseRandomKey = (variable) ->
  return variable if typeof variable is 'string'
  if variable instanceof Array
    variable[Math.floor(Math.random() * variable.length)]

common.regexEscape = (string) ->
  #http://stackoverflow.com/a/6969486
  string.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

common.loadConfigfile = (filepath) ->
    try
      console.log("Loading corpus: " + filepath)
      data = []
      fs.readdir filepath, (err, files) ->
        data = files.map (filename) ->
          console.log('FILENAMEs')
          console.log(filepath+'/'+filename)
          return yaml.safeLoad fs.readFileSync filepath+'/'+filename, 'utf8'

        console.log 'DATA CONTENT FIRST ELEMENT'
        console.log data[0]

      return yaml.safeLoad fs.readFileSync filepath+'/corpus.yml', 'utf8'
    catch err
      console.error "An error occurred while trying to load bot's config."
      console.error err
      throw "Error on loading YAML file " + filepath
      console.error "An error occurred while trying to load bot's config."

module.exports = common
