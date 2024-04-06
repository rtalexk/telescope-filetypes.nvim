local utils = require("telescope_filetypes.utils")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

local M = {}

local format_entry_display = function(filetype)
	local current_filetype = utils.get_current_filetype()

	local prefix
	if current_filetype == filetype then
		prefix = "* "
	else
		prefix = "  "
	end

	return prefix .. filetype
end

M.show_picker = function()
	pickers
		.new({
			layout_config = {
				width = 0.25,
				mirror = true,
				prompt_position = "top",
			},
		}, {
			prompt_title = "Search Filetype",
			finder = finders.new_table({
				results = utils.get_filetypes_current_first(),
				entry_maker = function(entry)
					return {
						value = entry,
						display = format_entry_display(entry),
						ordinal = entry,
					}
				end,
			}),
			sorter = config.generic_sorter(),
			sorting_strategy = "ascending",
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = actions_state.get_selected_entry(prompt_bufnr)
					if selection == nil then
						print("[Telescope] Nothing selected")
						return
					end

					actions.close(prompt_bufnr)
					utils.set_filetype(selection.value)
				end)

				return true
			end,
		})
		:find()
end

function ShowPicker()
	M.show_picker()
end

M.setup = function()
	vim.cmd("command! -nargs=0 Filetype lua ShowPicker()")
	-- vim.keymap.set("n", "<leader>fs", M.show_picker, { desc = "File type/syntax " })
end

return M
