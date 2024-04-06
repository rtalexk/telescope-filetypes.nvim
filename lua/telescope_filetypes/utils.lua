local M = {}

M.get_current_filetype = function()
	local syntax = vim.bo.filetype

	if syntax == "" then
		syntax = vim.api.nvim_buf_get_option(0, "syntax")
	end

	return syntax
end

M.get_filetypes = function()
	return vim.fn.getcompletion("", "filetype")
end

M.get_filetypes_current_first = function()
	local current_filetype = M.get_current_filetype()
	local filetypes = M.get_filetypes()
	local results = { current_filetype }

	for _, ft in ipairs(filetypes) do
		if ft ~= current_filetype then
			table.insert(results, ft)
		end
	end

	return results
end

M.set_filetype = function(filetype)
	vim.cmd("set filetype=" .. filetype)
end

return M
