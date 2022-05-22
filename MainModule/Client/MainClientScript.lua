--[[
	Runs the client commands and UI
	
	Authors:
		- zCrxtix (crxtix)
		- co_existance (deprecatedbrain)
]]

local parsing   = require(script.Parent:WaitForChild("Modules").Parsing)
local commands  = require(script.Parent:WaitForChild("Modules").Commands)
local Interface = require(script.Parent:WaitForChild("Modules").Interface)

local commandBar = script.Parent.GUIs.CommandBar:Clone()
commandBar.Parent = game.Players.LocalPlayer.PlayerGui

local getPrefix = game.ReplicatedStorage:WaitForChild("KeeAdminEvents"):WaitForChild("GetPrefix")

game.Players.LocalPlayer.Chatted:Connect(function(msg)
	local player = game.Players.LocalPlayer
	
	local args = parsing.parse_arguments(parsing.lower_string(msg))
	local messagePrefix = parsing.check_prefix(msg)
	local command = parsing.remove_prefix(args[1])
	
	if messagePrefix == getPrefix:InvokeServer() then
		for _, v in pairs(commands) do
			if v["name"] == command then
				v.execute(player, args)
			end

			if table.find(v["aliases"], command) then
				v.execute(player, args)
			end
		end
	end
end)
