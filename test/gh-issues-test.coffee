chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'gh-issues', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/gh-issues')(@robot)

  it 'registers a respond listener for opening github issues', ->
    expect(@robot.respond).to.have.been.calledWith  /(?:github|gh) (?:open|create|new) issue "([^"]+)"(?: (?:about|regarding|re|body|description) "([^"]+)")?(?: in "([\w\d-_]+)(?:\/([\w\d-_]+))?")?(?: (?:with )?(?:tags|tag|labels|label|tagged) "([\w\d,-_]+)")?$/i
