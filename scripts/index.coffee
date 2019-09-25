path = require 'path'

{loadConfigfile} = require path.join path.join __dirname, 'lib', 'common.coffee'
chatbot = require path.join __dirname, 'bot', 'index.coffee'

hubotPath = module.parent.filename
hubotPath = path.dirname hubotPath for [1..4]
corpus = (process.env.HUBOT_CORPUS || 'duvidas_fac.yml')
configPath = path.join hubotPath, 'training_data', corpus
dictPath = path.join hubotPath, 'training_data'

try
  config = loadConfigfile dictPath

catch err
  process.exit()

chatbot = chatbot.bind null, config, configPath

module.exports = chatbot
