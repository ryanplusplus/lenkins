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
          script = '.'
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
          script = '.'
        }
      }
    }
  }
}
