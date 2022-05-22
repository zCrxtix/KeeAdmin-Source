function GetPlayer(player, args)
	return require(script.Parent.Player).getPlayer(player, args) :: Player
end

local commands = {
	{
		name = "walkspeed",
		aliases = {"speed", "ws"},
		prefix = ":",
		description = "Set the player's walkspeed",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player, args)
			if not args[2] then warn("[KeeAdmin] Argument 2 not provided") return end
			if not args[3] then warn("[KeeAdmin] Argument 3 not provided") return end
			for _, v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.WalkSpeed = tonumber(args[3])
			end
		end,
	},
	{
		name = "jumppower",
		aliases = {"jpower"},
		prefix = ":",
		description = "Set the player's jumppower",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player, args)
			if not args[2] then warn("[KeeAdmin] Argument 2 not provided") return end
			if not args[3] then warn("[KeeAdmin] Argument 3 not provided") return end
			for _, v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.UserJumpPower = true
				v.Character.Humanoid.WalkSpeed = tonumber(args[3])
			end
		end,
	},
	{
		name = "jump",
		aliases = {},
		prefix = ":",
		description = "Makes the player join",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.Jump = true
			end
		end,
	},
	{
		name = "respawn",
		aliases = {"re", "res", "refresh"},
		prefix = ":",
		description = "Respawns the player",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player, args)	
			for i,v in pairs(GetPlayer(player, args)) do
				local playerPos = v.Character:WaitForChild("HumanoidRootPart").CFrame
				v:LoadCharacter()
				v.CharacterAdded:Connect(function(character)
					character:WaitForChild("HumanoidRootPart").CFrame = playerPos
					return
				end)
			end
		end,
	},
	{
		name = "forcefield",
		aliases = {"ff"},
		prefix = ":",
		description = "Gives the player a forcefield",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player: Player, args)		
			for _,v in pairs(GetPlayer(player, args)) do
				if not v.Character:FindFirstChild("ForceField") then
					Instance.new("ForceField", v.Character)
				end
			end
		end,
	},
	{
		name = "unforcefield",
		aliases = {"unff"},
		prefix = ":",
		description = "Removes a players forcefield",
		category = "misc",
		level = 1,
		canUseOnSelf = true,

		execute = function(player: Player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v.Character:FindFirstChild("ForceField") then
					v.Character.ForceField:Destroy()
				end
			end
		end,
	},
	{
		name = "sparkles",
		aliases = {},
		prefix = ":",
		description = "Gives a player sparkles ✨",
		category = "fun",
		level = 1,
		canUseOnSelf = true,

		execute = function(player: Player, args)for _,v in pairs(GetPlayer(player, args)) do
				if not v.Character:FindFirstChild("Sparkles") then
					Instance.new("Sparkles", v.Character.HumanoidRootPart)
				end
			end
		end,
	},
	{
		name = "unsparkles",
		aliases = {},
		description = "Removes a players sparkles",
		category = "fun",
		level = 1,

		execute = function(player: Player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v.Character:FindFirstChild("Sparkles") then
					v.Character.Sparkles:Destroy()
				end
			end
		end,
	},
	{
		name = "shutdown",
		aliases = {},
		description = "Removes a players sparkles",
		category = "moderation",
		level = 2,

		execute = function(player: Player, args)
			if args[2] then
				for i,v in pairs(game.Players:GetPlayers()) do
					v:Kick("Server shutting down.\n\nMessage:\nN/A")
				end
			else
				local message = {}
				for i = 3, #args do
					table.insert(message, args[i])
				end
				for i, v in pairs(game.Players:GetPlayers()) do
					v:Kick("Server shutting down.\n\nMessage:\n"..table.concat(message, " "))
				end
			end
		end,
	},
	{
		name = "kick",
		aliases = {},
		description = "Remove the player from the game.",
		category = "moderation",
		level = 1,

		execute = function(player: Player, args)
			if not args[2] then warn("[KeeAdmin] Argument 2 not provided") return end
			for _, v in pairs(GetPlayer(player, args)) do
				if v == player then warn("[KeeAdmin] Can't kick self") return end
				local reason = "No reason provided."
				local r = {}
				if args[3] then
					for i = 3,#args do
						table.insert(r, args[i])
					end
					reason = table.concat(r, " ")
				end
				v:Kick(string.format("\nKeeAdmin\nYou were kicked from the game\n\nModerator:%s\n\nReason:%s", v.Name, reason))
			end
		end,
	}
}

return commands
