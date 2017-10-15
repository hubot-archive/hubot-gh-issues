# Description
#   Hubot interface for GitHub issues
#
# Configuration:
#   HUBOT_GH_ISSUES_DEFAULT_OWNER
#   HUBOT_GH_ISSUES_DEFAULT_REPO
#
# Dependencies:
#   hubot-gh-token
#   octonode
#
# Commands:
#   hubot github open issue "<title>" (about "<body>") (in "(<owner>/)<repo>") (with labels "<label1>,<label2>,..") - Opens a new issue
#   hubot github show issue #<issue_number> (in (<owner>/)<repo>)
#   hubot github close issue #<issue_number> (in (<owner>/)<repo>)
#   hubot github comment issue #<issue_number> (in (<owner>/)<repo>) "<comment>"
#   hubot github search issues "<query>" (in "(<owner>/)<repo>") (with labels "<label1>,<label2>,..") - Search issues
#
# Author:
#   @benwtr

DEFAULT_OWNER = process.env.HUBOT_GH_ISSUES_DEFAULT_OWNER
DEFAULT_REPO = process.env.HUBOT_GH_ISSUES_DEFAULT_REPO

module.exports = (robot) ->

  robot.respond /(?:github|gh) (?:open|create|new) issue "([^"]+)"(?: (?:about|regarding|re|body|description) "([^"]+)")?(?: in "([\w\d-_]+)(?:\/([\w\d-_]+))?")?(?: (?:with )?(?:tags|tag|labels|label|tagged) "([\w\d,-_]+)")?$/i, id: 'gh-issues.open', (msg) ->
    title = msg.match[1]
    body = msg.match[2] || ''
    repo = if msg.match[3]? and msg.match[4]?
      "#{msg.match[3]}/#{msg.match[4]}"
    else if msg.match[3]?
      "#{DEFAULT_OWNER}/#{msg.match[3]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    labels = if msg.match[5]? then msg.match[5].split(',') else []
    robot.ghissues.openIssue msg, title, body, repo, labels

  robot.respond /(?:github|gh) show issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)?$/i, id: 'gh-issues.show', (msg) ->
    id = msg.match[1]
    repo = if msg.match[2]? and msg.match[3]?
      "#{msg.match[2]}/#{msg.match[3]}"
    else if msg.match[2]?
      "#{DEFAULT_OWNER}/#{msg.match[2]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    robot.ghissues.showIssue msg, id, repo

  robot.respond /(?:github|gh) close issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)?$/i, id: 'gh-issues.close', (msg) ->
    id = msg.match[1]
    repo = if msg.match[2]? and msg.match[3]?
      "#{msg.match[2]}/#{msg.match[3]}"
    else if msg.match[2]?
      "#{DEFAULT_OWNER}/#{msg.match[2]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    robot.ghissues.closeIssue msg, id, repo

  robot.respond /(?:github|gh) comment issue #?(\d+)(?: in ([\w\d-_]+)(?:\/([\w\d-_]+))?)? "(.*)"$/i, id: 'gh-issues.comment', (msg) ->
    id = msg.match[1]
    repo = if msg.match[2]? and msg.match[3]?
      "#{msg.match[2]}/#{msg.match[3]}"
    else if msg.match[2]?
      "#{DEFAULT_OWNER}/#{msg.match[2]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    comment = msg.match[4]
    robot.ghissues.commentOnIssue msg, comment, id, repo

  robot.respond /(?:github|gh) search issues "([^"]+)"(?: in "([\w\d-_]+)(?:\/([\w\d-_]+))?")?$/i, id: 'gh-issues.search', (msg) ->
    query = msg.match[1]
    repo = if msg.match[2]? and msg.match[3]?
      "#{msg.match[2]}/#{msg.match[3]}"
    else if msg.match[2]?
      "#{DEFAULT_OWNER}/#{msg.match[2]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    robot.ghissues.searchIssues msg, query, repo