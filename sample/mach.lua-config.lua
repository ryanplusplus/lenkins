return {
  owner = 'ryanplusplus',
  repo = 'mach.lua',

  builds = {
    {
      trigger = {
        type = 'pull_request'
      },
      jobs = {
        {
          tools = { 'lenv', 'ubuntu' },
          script = 'tdd.sh',
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
          script = 'tdd.sh',
          timeout = 60 * 1000
        }
      }
    }
  }
}
