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

getYAMLFiles = (filepath) ->
  listFile = fs.readdirSync filepath
  dataFiles = []
  if listFile.length > 0
    dataFiles = listFile.map (filename) ->
      return yaml.safeLoad fs.readFileSync filepath+'/'+filename, 'utf8'
  else
    console.error('The directory: '+ filepath + ' is empty.')

  return dataFiles

mergeYAMLFiles = (dataFiles) ->
  arrTrust = []
  arrInteractions = []
  mindBot = Object.create(null)

  dataFiles.forEach (element,index) ->
    if index < 1
      arrTrust[index] = element.trust
      arrInteractions = element.interactions

  mindBot['trust'] = Math.min.apply(null,arrTrust)
  mindBot['iteractions'] = arrInteractions

  return mindBot

common.loadConfigfile = (filepath) ->
    try
      contentFiles = getYAMLFiles(filepath)
      d = mergeYAMLFiles(contentFiles)

#      console.log d
#      return d
#      console.log yaml.safeLoad fs.readFileSync filepath+'/corpus.yml', 'utf8'
      return yaml.safeLoad fs.readFileSync filepath+'/corpus.yml', 'utf8'
    catch err
      console.error "An error occurred while trying to load bot's config."
      console.error err
      throw "Error on loading YAML file " + filepath
      console.error "An error occurred while trying to load bot's config."

module.exports = common

