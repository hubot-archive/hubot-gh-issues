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
