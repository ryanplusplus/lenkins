return {
  owner = 'ryanplusplus',
  repo = 'webhook-test',

  builds = {
    {
      trigger = {
        type = 'pull_request'
      },
      jobs = {
        {
          tools = { 'lenv', 'ubuntu' },
          script = 'test.sh',
          timeout = 60 * 1000
        }
      }
    },
    {
      trigger = {
        type = 'on_change',
        branch = 'master'
      },
      jobs = {
        {
          tools = { 'lenv', 'ubuntu' },
          script = 'test.sh',
          timeout = 60 * 1000
        }
      }
    }
  }
}
