local builtin = require("telescope.builtin")

vim.keymap.set({"n", "c"}, "<F1>", "<cmd>NvimTreeToggle<cr>") -- [F1]: Open/close NvimTree
vim.keymap.set({"v"}, "<C-c>", "\"+y") -- [CTRL + C]: Copy selection

-- [CTRL + V]: Paste selection
vim.keymap.set({"n", "i"}, "<C-v>", function()
	vim.cmd("stopinsert")
	vim.cmd("normal! p")
end)

vim.keymap.set({"v"}, "<C-x>", "\"+d") -- [CTRL + X]: Cut selection
vim.keymap.set({"n", "i", "c"}, "<C-p>", builtin.find_files, {}) -- [CTRL + P]: Open Telescope
vim.keymap.set({"n", "i", "c"}, "<C-f>", builtin.live_grep, {}) -- [CTRL + F]: Search in files

-- [CTRL + S]: Save file (if it's empty, prompt the user with a file name)
vim.keymap.set({"n", "i", "c"}, "<C-s>", function()
	vim.cmd("stopinsert")

	local fileName = vim.api.nvim_buf_get_name(0)

	if fileName == "" then
		local newFileName

		repeat
			local status, input = pcall(vim.fn.input("(ESC to cancel) Save as: ", "", "file"))

			if not status then
				return
			end

			newFileName = input
		until newFileName ~= ""

		vim.cmd("saveas " .. newFileName)
	else
		vim.cmd("w")
	end
end)

vim.keymap.set({"n", "i", "c"}, "<C-n>", "<cmd>$tabnew<cr>") -- [CTRL + N]: New tab
vim.keymap.set({"n", "i", "c"}, "<C-q>", "<cmd>q!<cr>") -- [CTRL + Q]: Exit file/close tab (forced)

-- [CTRL + D]: Duplicate line
vim.keymap.set({"n", "i", "c"}, "<C-d>", function()
	vim.cmd("normal! yy")
	vim.cmd("normal! p")
end)

vim.keymap.set({"n", "i", "c", "v"}, "<A-Right>", "<cmd>tabnext<cr>") -- [ALT + Right Arrow]: Move to next tab
vim.keymap.set({"n", "i", "c", "v"}, "<A-Left>", "<cmd>tabprevious<cr>") -- [ALT + Left Arrow]: Move to previous tab

