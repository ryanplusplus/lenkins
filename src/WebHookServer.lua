local json = require 'json'

return function(weblit)
  local handler

  weblit.bind({
    host = '0.0.0.0',
    port = 4000
  })

  weblit.route({
    method = 'POST',
    path = '/hook'
  }, function(req, res, go)
    req.body = json.decode(req.body)

    local event = {}
    event.type = req.headers['X-GitHub-Event']

    if event.type == 'push' then
      event.repo = req.body.repository.name
      event.owner = req.body.repository.owner.name
      event.url = req.body.repository.ssh_url
      event.commit = req.body.after
      event.branch = req.body.ref:match('refs/heads/(.+)')
    elseif event.type == 'pull_request' then
      event.repo = req.body.repository.name
      event.owner = req.body.repository.owner.login
      event.url = req.body.pull_request.head.repo.ssh_url
      event.commit = req.body.pull_request.head.sha
      event.target = req.body.pull_request.base.ref
    end

    if handler then
      handler(event)
    end

    res.code = 200
  end)

  return {
    on_event = function(f)
      handler = f
    end
  }
end
