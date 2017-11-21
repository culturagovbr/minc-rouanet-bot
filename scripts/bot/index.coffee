fs = require 'fs'
path = require 'path'
natural = require 'natural'

lang = (process.env.HUBOT_LANG || 'en')
if lang == "en"
  PorterStemmer = require path.join '..','..','node_modules','natural','lib','natural','stemmers','porter_stemmer.js'
else
  PorterStemmer = require path.join '..','..','node_modules','natural','lib','natural','stemmers','porter_stemmer_' + lang + '.js'

debug_mode = ((process.env.HUBOT_NATURAL_DEBUG_MODE == 'true') || false)

{regexEscape, loadConfigfile} = require path.join '..', 'lib', 'common.coffee'

typing = (res, t) ->
  res.robot.adapter.callMethod 'stream-notify-room', res.envelope.user.roomID+'/typing', res.robot.alias, t is true

sendWithNaturalDelay = (msgs, elapsed=0) ->
  if !Array.isArray msgs
    msgs = [msgs]

  keysPerSecond = 50
  maxResponseTimeInSeconds = 2

  msg = msgs.shift()
  if typeof msg isnt 'string'
    cb = msg.callback
    msg = msg.answer

  delay = Math.min(Math.max((msg.length / keysPerSecond) * 1000 - elapsed, 0), maxResponseTimeInSeconds * 1000)
  typing @, true
  setTimeout =>
    @send msg

    if msgs.length
      sendWithNaturalDelay.call @, msgs
    else
      typing @, false
      cb?()
  , delay

# check these
livechatTransferHuman = (res) ->
	setTimeout ->
		res.robot.adapter.callMethod 'livechat:transfer',
			roomId: res.envelope.room
			departmentId: process.env.DEPARTMENT_ID
	, 1000

setUserName = (res, name) ->
	res.robot.adapter.callMethod 'livechat:saveInfo',
		_id: res.envelope.user.id
		name: name
	,
		_id: res.envelope.room
#

setContext = (res, context) ->
  key = 'context_'+res.envelope.room+'_'+res.envelope.user.id
  console.log 'set context', context
  res.robot.brain.set(key, context)

getContext = (res) ->
  key = 'context_'+res.envelope.room+'_'+res.envelope.user.id
  return res.robot.brain.get(key)

isDebugMode = (res) ->
  key = 'configure_debug-mode_'+res.envelope.room+'_'+res.envelope.user.id
  return (res.robot.brain.get(key) == 'true')

getDebugCount = (res) ->
  key = 'configure_debug-count_'+res.envelope.room+'_'+res.envelope.user.id

  return if res.robot.brain.get(key) then res.robot.brain.get(key) - 1 else false

buildClassificationDebugMsg = (res, classifications) ->
  list = ''
  debugCount = getDebugCount(res)

  if debugCount
    classifications = classifications[0..debugCount]

  for classification, i in classifications
    list = list.concat 'Label: ' + classification.label + ' Score: ' + classification.value + '\n'

  newMsg = {
    channel: res.envelope.user.roomID,
    msg: "Classifications considered:",
    attachments: [{
        text: list
    }]
  }

  return newMsg

incErrors = (res) ->
  key = 'errors_'+res.envelope.room+'_'+res.envelope.user.id
  errors = res.robot.brain.get(key) or 0
  errors++
  console.log 'inc errors ', errors
  res.robot.brain.set(key, errors)
  return errors

clearErrors = (res) ->
  console.log 'clear errors'
  key = 'errors_'+res.envelope.room+'_'+res.envelope.user.id
  res.robot.brain.set(key, 0)

module.exports = (_config, _configPath, robot) ->
  config = _config
  configPath = _configPath

  try
    brain = new Brain(config)
  catch error
    console.log error
    return

  brain.train()

  processMessage = (res, msg) ->
    context = getContext(res)
    currentClassifier = classifier
    trust = config.trust
    interaction = undefined
    debugMode = isDebugMode(res)

    console.log 'context ->', context

    if context
      interaction = config.interactions.find (interaction) -> interaction.name is context
      if interaction? and interaction.next?.classifier?
        currentClassifier = interaction.next.classifier

        if interaction.next.trust?
          trust = interaction.next.trust

    classifications = currentClassifier.getClassifications(msg)

    console.log 'classifications ->', classifications[0..4]

    if debugMode
      newMsg = buildClassificationDebugMsg(res, classifications)
      robot.adapter.chatdriver.customMessage(newMsg)

    if classifications[0].value >= trust
      clearErrors res
      [node_name, sub_node_name] = classifications[0].label.split('|')
      console.log({node_name, sub_node_name})
      int = config.interactions.find (interaction) ->
        interaction.name is node_name
      if int.classifier?
        subClassifications = int.classifier.getClassifications(msg)
    else
      if Array.isArray interaction?.next?.error
        error_count = incErrors res
        error_node_name = interaction.next.error[error_count - 1]
        if not error_node_name?
          clearErrors res
          error_node_name = interaction.next.error[0]
      else if interaction?.next?
        setContext(res, undefined)
        return processMessage(res, msg)
      else
        error_count = incErrors res
        if error_count > err_nodes
          clearErrors res
        error_node_name = "error-" + error_count

    currentInteraction = config.interactions.find (interaction) ->
      interaction.name is node_name or interaction.name is error_node_name

    if not currentInteraction?
      clearErrors res
      return console.log 'Invalid interaction ['+node_name+']'

    if currentInteraction.context == 'clear'
      setContext(res, undefined)
    else if node_name?
      setContext(res, node_name)

    currentNode = nodes[node_name or error_node_name]
    currentNode.process.call @, res, msg, subClassifications

  if debug_mode
    robot.respond /bottrain/i, (res) ->
      config = loadConfigfile(configPath)
      brain.train(true)

  robot.hear /(.+)/i, (res) ->
    res.sendWithNaturalDelay = sendWithNaturalDelay.bind(res)
    msg = res.match[0].replace res.robot.name+' ', ''
    msg = msg.replace(/^\s+/, '')
    msg = msg.replace(/\s+&/, '')
    # check if robot should respond
    if res.envelope.user.roomType in ['c','p']
      if (res.message.text.match new RegExp('\\b' + res.robot.name + '\\b', 'i')) or (res.message.text.match new RegExp('\\b' + res.robot.alias + '\\b', 'i'))
        processMessage res, msg
    else if res.envelope.user.roomType in ['d','l']
      processMessage res, msg
