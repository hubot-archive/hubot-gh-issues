fs = require 'fs'
path = require 'path'

module.exports = (robot, scripts) ->
  scriptsPath = path.resolve(__dirname, 'src')
  fs.exists scriptsPath, (exists) ->
    if exists
      for script in fs.readdirSync(scriptsPath)
        if scripts? and '*' not in scripts
          robot.loadFile(scriptsPath, script) if script in scripts
        else
          robot.loadFile(scriptsPath, script)

  github = require 'octonode'

  githubTokenForUser = (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    token = robot.vault.forUser(user).get(robot.vault.key)
    return token if token?
    msg.reply "I don't know your GitHub token. \nPlease generate one with the \"repo\" scope on https://github.com/settings/tokens and set it in a private message to me with the command: \"github token set <github_personal_access_token>\""

  robot.ghissues =
    openIssue: (msg, title, body, repo, labels) ->
      token = githubTokenForUser msg
      if token?
        client = github.client token
        ghrepo = client.repo repo
        ghrepo.issue { "title": title, "body": body, "labels": labels }
        , (err, data, headers) ->
          unless err?
            msg.reply "Created issue ##{data.number} in #{repo} - #{data.html_url}"
          else
            msg.reply "Error from GitHub API: #{err.body.message}"
            return err

    closeIssue: (msg, id, repo) ->
      token = githubTokenForUser msg
      if token?
        client = github.client token
        issue = client.issue repo, id
        issue.update { state: 'closed' }, (err, data, headers) ->
          unless err?
            msg.reply "Closed issue ##{id} in #{repo} - #{data.html_url}"
          else
            msg.reply "Error from GitHub API: #{err.body.message}"
            return err

    showIssue: (msg, id, repo) ->
      token = githubTokenForUser msg
      if token?
        client = github.client token
        issue = client.issue repo, id
        issue.info (err, data, headers) ->
          unless err?
            msg.reply "Issue ##{id} in #{repo} - #{data.title} - #{data.html_url}"
          else
            msg.reply "Error from GitHub API: #{err.body.message}"
            return err

    commentOnIssue: (msg, comment, id, repo) ->
      token = githubTokenForUser msg
      if token?
        client = github.client token
        issue = client.issue repo, id
        issue.createComment { body: comment }, (err, data, headers) ->
          unless err?
            msg.reply "Added comment to issue ##{id} in #{repo} - #{data.html_url}"
          else
            msg.reply "Error from GitHub API: #{err.body.message}"
            return err

    searchIssues: (msg, query, repo) ->
      token = githubTokenForUser msg
      if token?
        client = github.client token
        ghQueryString = query
        if repo.endsWith "/undefined"
          ghQueryString += "+user:#{repo.replace("/undefined", "")}"
        else
          ghQueryString += "+repo:#{repo}"
        queryObj =
          q: ghQueryString
          sort: "created"
          order: "asc"
        client.search().issues queryObj, (err, data, headers) ->
          unless err?
            robot.logger.info data
            reply = "Found #{data.total_count} issue"
            reply += if data.total_count != 1 then "s\n" else "\n"
            if data.items
              for issue in data.items
                reply += "##{issue.number} #{issue.title}\n"
                reply += "#{issue.html_url}\n"
            msg.reply reply
          else
            msg.reply "Error from GitHub API: #{err.body.message}"
            return err