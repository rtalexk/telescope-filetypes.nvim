return require("telescope").register_extension({
	exports = {
		-- TODO: This doesn't work. Find a way to override the default filetypes picker
		filetypes = require("telescope_filetypes").show_picker,
	},
})
