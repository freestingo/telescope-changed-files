local has_telescope, telescope = pcall(require, 'telescope')
local custom_actions = require('telescope._extensions.changed-files.actions')

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension {
	exports = {
    actions = {
      find_changed_files = custom_actions.find_changed_files
    }
	},
}
