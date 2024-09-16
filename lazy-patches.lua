-- Load the necessary modules from lazy.nvim
local lazy = require("lazy")
local Config = require("lazy.core.config")

-- Store the original setup function so we can call it later
local original_setup = lazy.setup

-- Define a custom plugin path resolver
local function resolve_plugin_path(plugin)
	-- Resolve the plugin name: it can either be in plugin[1] or plugin.name
	local pluginName = plugin.name or plugin[1]

	-- If the pluginName is a GitHub short URL (e.g., "folke/todo-comments.nvim"),
	-- extract the repository name ("todo-comments.nvim")
	if type(pluginName) == "string" and pluginName:find("/") then
		local slashPos = pluginName:find("/")
		pluginName = pluginName:sub(slashPos + 1) -- Extract repo name after "/"
	end

	-- If the resolved plugin name exists in pluginPaths, set the dir to the resolved path
	if pluginName and pluginPaths[pluginName] then
		plugin.dir = pluginPaths[pluginName] -- Override the plugin's directory with the resolved path
	end
end

-- Override the setup function of lazy.nvim
lazy.setup = function(plugins, opts)
	-- Iterate over the plugins to resolve their paths
	for _, plugin in ipairs(plugins) do
		resolve_plugin_path(plugin)
	end

	-- Call the original setup function with the modified plugins
	return original_setup(plugins, opts)
end
