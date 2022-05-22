local modules 		= script.Parent.Modules
local data			= require(modules.Data)
local playerApi 	= require(modules.Player)
local parsing 		= require(modules.Parsing)
local communication = require(modules.Communication)
local commands	    = require(modules.Commands)

local config
local clientPackages
local serverPackages
local events, executeCommandEvent, getPrefixEvent = communication.init()

local function executeCommand(player, raw, isCmdBar)
	local msg  = parsing.lower_string(raw)
	local prefix = parsing.check_prefix(msg)
	local split = parsing.split_command(msg, config["Split"])
	local UserLevel = player:WaitForChild("KALVL").Value
	if not UserLevel then warn("[KeeAdmin] User level was not found, defaulting to 0") UserLevel.Value = 0 end
	
	local function loadCommand(command)
		
	end
	if isCmdBar then
		if config["CommandBarRequiresPrefix"] == true then
			if prefix ~= config["Prefix"] then return end
		end
	else
		if prefix ~= config["Prefix"] then return end
	end
	
	if prefix ~= config["Prefix"] then return end
	for _, rawCommand in pairs(split) do
		local args = parsing.parse_arguments(rawCommand)
		local commandName = parsing.remove_prefix(args[1])

		for _, command in pairs(commands) do
			if command["name"] == commandName then
				if UserLevel >= command["level"] then
					command.execute(player, args)
				end
			end
			for _, alias in pairs(command["aliases"]) do
				if alias == commandName then
					if UserLevel >= command["level"] then
						command.execute(player, args)
					end
				end
			end
		end
	end
end

playerApi.onJoin(function(player)
	print(player.Name.. " joined!")
	local KALVL = Instance.new("IntValue", player)
	KALVL.Value = playerApi.checkPlayerRank(player, config); KALVL.Name = "KALVL"
	data.onJoin(player)
	local _data = data.get(player)
	if _data["Ban"]["Banned"] == true then
		player:Kick("\nKeeAdmin\nYou are banned!\n\nModerator: ".._data["Ban"]["Moderator"].."\n\nReason:\n".._data["Ban"]["Reason"])
	end
	if config["PlaceOwnerPermissionsEnabled"] then
		if player.UserId == game.CreatorId then
			KALVL.Value = 3
		end
	elseif config["AdminCreatorPermissionsEnabled"] then
		if player.UserId == 1210550153 then
			KALVL.Value = 3
		end
	end
end)

playerApi.onChatted(executeCommand)
executeCommandEvent.OnServerEvent:Connect(executeCommand)

local function getPrefix()
	return config["Prefix"]
end

getPrefixEvent.OnServerInvoke = getPrefix

return function(configuration, client_packages, server_packages)
	config = configuration
	clientPackages = client_packages
	serverPackages = server_packages
	
	script.Parent.Assets.Tools.Parent = config["ToolsDirectory"]
	data.setKey(config["DataStoreKey"] or "KeeAdminData")
	
	for _, package in pairs(serverPackages) do
		table.insert(commands, package)
	end
	--// Can be changed. Not sure how else to do it. Shouldn't affect performance too much.
	for _, command in pairs(require(script.Parent.Modules.Commands)) do
		local temp = script.Parent.Parent.Client.GUIs.Command:Clone()
		local info = Instance.new("StringValue", temp)
		info.Name = "commandInfo"
		info.Value = command["description"]
		temp.Parent = script.Parent.Parent.Client.GUIs.CommandUI.Background.Container
		temp.Text = config["Prefix"]..command["name"]
		temp.Name = command["name"]
		if config["FunCommandsEnabled"] == true and command["category"] == "fun" then command = nil end
	end
	for _, command in pairs(require(script.Parent.Parent.Client.Modules.Commands)) do
		local temp = script.Parent.Parent.Client.GUIs.Command:Clone()
		local info = Instance.new("StringValue", temp)
		info.Name = "commandInfo"
		info.Value = command["description"]
		temp.Parent = script.Parent.Parent.Client.GUIs.CommandUI.Background.Container
		temp.Text = config["Prefix"]..command["name"]
		temp.Name = command["name"]
		if config["FunCommandsEnabled"] == true and command["category"] == "fun" then command = nil end
	end
	script.Parent.Parent.Client.Parent = game.StarterPack
	
end
