local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local custom_previewers = require "telescope._extensions.changed-files.previewers"

local M = {}

M.find_changed_files = function(prompt_bufnr)
  local branch_name = action_state.get_selected_entry().value
  local command = "git diff --name-only $(git merge-base HEAD " .. branch_name .. ")"
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	local files = {}
	for token in string.gmatch(result, "[^%s]+") do
	   table.insert(files, token)
	end

  local opts = {} -- TODO: find a way to pass these in
	pickers.new(opts, {
		prompt_title = "Changed files since " .. branch_name,
    previewer = custom_previewers.git_file_diff_from_branch.new({ branch_name = branch_name }),
		finder = finders.new_table {
			results = files
		},
		sorter = conf.generic_sorter(opts),
	}):find()
end

return M

