path = require 'path'
natural = require 'natural'

lang = (process.env.HUBOT_LANG || 'en')
if lang == "en"
  PorterStemmer = require path.join '..','..','node_modules','natural','lib','natural','stemmers','porter_stemmer.js'
else
  PorterStemmer = require path.join '..','..','node_modules','natural','lib','natural','stemmers','porter_stemmer_' + lang + '.js'

class Brain
  trainConfig = {}
  events = {}
  nodes = {}
  error_count = 0
  err_nodes = 0

  constructor: (trainConfig, autoTrain=false) ->
    @trainConfig = trainConfig

    if not trainConfig.interactions?.length
      throw 'No interactions configured.'
    if not trainConfig.trust
      throw 'No trust level configured.'

    @classifier = new natural.LogisticRegressionClassifier(PorterStemmer)

    # Loading events from events folder
    eventsPath = path.join __dirname, '..', 'events'
    for event in fs.readdirSync(eventsPath).sort()
      events[event.replace /\.coffee$/, ''] = require path.join eventsPath, event

    if autoTrain
        train()

  classifyInteraction = (interaction, classifier) ->
    if Array.isArray interaction.expect
      for doc in interaction.expect
        classifier.addDocument(doc, interaction.name)

      if Array.isArray interaction.next?.interactions
        interaction.next.classifier = new natural.LogisticRegressionClassifier(PorterStemmer)

        for nextInteractionName in interaction.next.interactions

          nextInteraction = trainConfig.interactions.find (n) ->
            return n.name is nextInteractionName

          if not nextInteraction?
            console.log 'No valid interaction for', nextInteractionName
            continue

          classifyInteraction nextInteraction, interaction.next.classifier
        interaction.next.classifier.train()

  train = (retrain=false) ->
    console.log 'Processing interactions'
    console.time 'Processing interactions (Done)'

    if retrain
        @nodes = {}
        @classifier = new natural.LogisticRegressionClassifier(PorterStemmer)

    for interaction in trainConfig.interactions
      {name, classifiers, event} = interaction
      nodes[name] = new events[event] interaction
      # count error nodes
      if name.substr(0,5) == "error"
        err_nodes++
      if interaction.level != 'context'
        classifyInteraction interaction, classifier

    classifier.train()

    console.timeEnd 'Processing interactions (Done)'
