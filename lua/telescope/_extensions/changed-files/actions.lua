local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local custom_previewers = require "telescope._extensions.changed-files.previewers"

local M = {}

local get_current_branch = function()
  local handle = io.popen("git branch --show-current")
  local result = handle:read("*a")
  handle:close()

  -- TODO: this next for-loop relies on the above command only returning one line we actually care about.
  -- there's gotta be a better way of extracting the branch name from the result
  for token in string.gmatch(result, "[^%s]+") do
    return token
  end
end

local get_previewer = function(current_branch, selected_branch, opts)
  if current_branch == selected_branch then
    return previewers.git_file_diff.new(opts) -- use builtin previewer (same as for `:Telescope git_status`)
  else
    return custom_previewers.git_file_diff_from_branch.new({ branch_name = selected_branch }) -- use custom previewer
  end
end

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
  local previewer = get_previewer(get_current_branch(), branch_name, opts)
	pickers.new(opts, {
		prompt_title = "Changed files since " .. branch_name,
    previewer = previewer,
		finder = finders.new_table {
			results = files
		},
		sorter = conf.generic_sorter(opts),
	}):find()
end

return M
