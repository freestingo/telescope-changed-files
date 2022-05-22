# telescope-changed-files
This extension will allow you to select for a branch and browse all changed files between your current branch and the selected branch, while previewing diffs for each file.

# Install
Configure telescope like this:
```
-- Lua
local cf_actions = require('telescope').extensions.changed_files.actions

require('telescope').setup {
  pickers = {
    git_branches = {
      mappings = {
        i = {
          ["<a-c>"] = cf_actions.find_changed_files
        }
      }
    }
  }
}

require('telescope').load_extension('changed_files')
```

This will add a custom mapping only active inside the `git_branches` builtin Telescope picker while in insert-mode
(check `:h telescope.setup` for more info about custom pickers configuration).

# Usage example (following previous config)
- `:Telescope git_branches` (or whatever mapping you already set it to)
- move your selection above the branch you want to reference
- press `<A-c>`
- `git_branches` picker will close, and the custom changed-files picker will open

# General notes
It should be obvious, even after a quick glance at the source code, that I don't really know what the hell I'm doing here.
This is my first ever project in lua, but I can already see some additions that would be good for this project (i.e. better and fancier filename viewing).
As fun as writing this code was, I have neither the time nor the inclination to give it that much thought after the exact moment I will press "Commit changes" (aka 30 seconds from now). So, needless to say PRs are very welcome. 
