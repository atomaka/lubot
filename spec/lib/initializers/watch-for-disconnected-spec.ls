describe 'watch-for-disconnected' !->
  include-hubot!

  before-each !->
    require('../../../lib/initializers/mentioned-rooms-referencer') robot
    jasmine.clock!.install!

  after-each !->
    jasmine.clock!.uninstall!

  she 'should not start a timer without a match', (done) !->
    (expect (->
      robot.logger.info 'Some message that we should not trigger on'
      jasmine.clock!.tick 60 * 1000 + 1 * 1000)).not.toThrow!

    done!

  she 'should start a timer when a disconnect is detected', (done) !->

    (expect (->
      robot.logger.info 'Slack client closed, waiting for reconnect'
      jasmine.clock!.tick 60 * 1000 + 1 * 1000)).toThrow new Error 'Force restarting due to disconnect'

    done!

  she 'should cancel a timer that has been started if the client reconnects', (done) !->

    (expect (->
      robot.logger.info 'Slack client closed, waiting for reconnect'
      robot.logger.info 'Slack client now connected'
      jasmine.clock!.tick 60 * 1000 + 1 * 1000)).not.toThrow!

    done!