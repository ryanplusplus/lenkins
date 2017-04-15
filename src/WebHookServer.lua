local json = require 'json'

return function(weblit)
  weblit.bind({
    host = '0.0.0.0',
    port = 4000
  })

  weblit.route({
    method = 'POST',
    path = '/hook'
  }, function(req, res, go)
    req.body = json.decode(req.body)

    local stuff = {}
    stuff.event = req.headers['X-GitHub-Event']

    if stuff.event == 'push' then
      stuff.repo = req.body.repository.name
      stuff.owner = req.body.repository.owner.name
      stuff.url = req.body.repository.ssh_url
      stuff.commit = req.body.after
      stuff.branch = req.body.ref:match('refs/heads/(.+)')
    elseif stuff.event == 'pull_request' then
      stuff.repo = req.body.repository.name
      stuff.owner = req.body.repository.owner.login
      stuff.url = req.body.pull_request.head.repo.ssh_url
      stuff.commit = req.body.pull_request.head.sha
      stuff.target = req.body.pull_request.base.ref
    end

    p(stuff)

    res.code = 200
  end)
end
