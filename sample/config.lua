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
          tools = { 'lua53', 'ubuntu' },
          script = 'tdd.sh'
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
          tools = { 'lua53', 'ubuntu' },
          script = 'tdd.sh'
        }
      }
    }
  }
}
