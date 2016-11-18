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
    expect(@robot.respond).to.have.been.calledWith /(?:github|gh) (?:open|create|new) issue "([^"]+)"(?: (?:about|regarding|re|body|description) "([^"]+)")?(?: in "([\w\d-_]+)(?:\/([\w\d-_]+))?")?(?: (?:with )?(?:tags|tag|labels|label|tagged) "([\w\d,-_]+)")?$/i

  it 'registers a respond listener for showing github issues', ->
    expect(@robot.respond).to.have.been.calledWith /(?:github|gh) show issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)?$/i

  it 'registers a respond listener for closing github issues', ->
    expect(@robot.respond).to.have.been.calledWith /(?:github|gh) close issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)?$/i

  it 'registers a respond listener for commenting on github issues', ->
    expect(@robot.respond).to.have.been.calledWith /(?:github|gh) comment issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)? "(.*)"$/i
