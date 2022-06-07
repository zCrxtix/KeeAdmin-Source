function GetPlayer(player, args)
	return require(script.Parent.PlayerAPI).getPlayer(player, args)
end
function Notify(player, msg, title)
	game.ReplicatedStorage:WaitForChild("KeeAdminEvents").Notification:FireClient(player, title or "Error", msg)
end

local data = require(script.Parent.Data)
local API  = require(script.Parent.API)
local env  = require(script.Parent.Environment)

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
			for _, v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.WalkSpeed = tonumber(args[3] or 16)
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
			for _, v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.UseJumpPower = true
				v.Character.Humanoid.WalkSpeed = tonumber(args[3] or 50)
			end
		end,
	},
	{
		name = "jump",
		aliases = {},
		prefix = ":",
		description = "Makes the player jump",
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

		execute = function(player, args)		
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

		execute = function(player, args)
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

		execute = function(player, args)for _,v in pairs(GetPlayer(player, args)) do
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

		execute = function(player, args)
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
		description = "Shutdowns the game",
		category = "moderation",
		level = 2,

		execute = function(player, args)
			if not args[2] then
				for i,v in pairs(game.Players:GetPlayers()) do
					v:Kick("Server shutting down.\n\nMessage:\nN/A")
				end
			else
				local message = {}
				for i = 2, #args do
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

		execute = function(player, args)
			for _, v in pairs(GetPlayer(player, args)) do
				if v == player then Notify(player, "Can't kick self") return end
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
	},
	{
		name = "sword",
		aliases = {},
		description = "Gives the player a sword",
		category = "fun",
		level = 1,
		
		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				game.ServerStorage.Tools.Sword:Clone().Parent = player.Backpack
			end
		end,
	},
	{
		name = "backrooms",
		aliases = {},
		description = "Noclips the specified player out of reality",
		category = "fun",
		level = 1,

		execute = function(player, args)
			local origPositions = {}
			local clone
			if not game.Workspace:FindFirstChild("Backrooms") then
				clone = script.Parent.Parent.Assets.Backrooms:Clone()
			else
				clone = script.Parent.Parent.Assets.Backrooms
			end
			clone.Parent = game.Workspace
			for _,v in pairs(GetPlayer(player, args)) do
				origPositions[v.Name] = v.Character.HumanoidRootPart.Position
				v.Character.HumanoidRootPart.Position = clone.Start.Position + Vector3.new(0,2,0)
				clone.Finish.Touched:Connect(function(hit)
					if hit.Parent:FindFirstChild("Humanoid") then
						v.Character.HumanoidRootPart.Position = origPositions[v.Name]
						origPositions[v.Name] = nil
						if #origPositions == 0 then
							clone:Destroy()
						end
					end
				end)
			end
		end,
	},
	{
		name = "play",
		aliases = {"sound", "music"},
		description = "Plays a song 🎶",
		category = "misc",
		level = 1,

		execute = function(player, args)
			if not args[2] then return end
			local sound
			if not game:FindFirstChild("KeeAdminSound") then
				sound = Instance.new("Sound")
				sound.Parent = game.Workspace
				sound.Name = "KeeAdminSound"
			else
				sound = game:FindFirstChild("KeeAdminSound")
			end
			sound.SoundId = "rbxassetid://"..args[2]
			sound.Volume = tonumber(args[3]) or 0.5
			sound.Looped = if args[4] == "true" then true else false
			sound:Play()
		end,
	},
	{
		name = "serverlock",
		aliases = {"slock", "gamelock"},
		description = "Locks the game so no one can join",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			game:SetAttribute("Locked", true)
		end,
	},
	{
		name = "unserverlock",
		aliases = {"unslock", "ungamelock"},
		description = "Locks the game so no one can join",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			game:SetAttribute("Locked", false)
		end,
	},
	{
		name = "mod",
		aliases = {},
		description = "Sets the specified player's rank to Moderator (1)",
		category = "moderation",
		level = 2,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v == player then Notify(player, "Can't update self") return end
				v:SetAttribute("KALVL", 1)
			end
		end,
	},
	{
		name = "admin",
		aliases = {},
		description = "Sets the specified player's rank to Administrator (2)",
		category = "moderation",
		level = 3,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				print(data.get(v))
				if v == player then Notify(player, "Can't update self") return end
				v:SetAttribute("KALVL", 2)
			end
		end,
	},
	{
		name = "unadmin",
		aliases = {"unmod"},
		description = "Sets the specified player's rank to Player (0)",
		category = "moderation",
		level = 2,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v == player then Notify(player, "Can't update self") return end
				v:SetAttribute("KALVL", 0)
			end
		end,
	},
	{
		name = "goto",
		aliases = {"to"},
		description = "Teleports the sender to the specified player",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2)
			end
		end,
	},
	{
		name = "bring",
		aliases = {},
		description = "Teleports the specified player to the sender",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2)
			end
		end,
	},
	{
		name = "teleport",
		aliases = {},
		description = "Teleports specified player 1 to specified player 2",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			local p1 = nil
			local p2 = nil
			for _, v in pairs(game.Players:GetPlayers()) do
				if v.Name:sub(1,string.len(args[2])):lower() == args[2] or v.DisplayName:sub(1,string.len(args[2])):lower() == args[2] then
					p1 = v
				elseif v.Name:sub(1,string.len(args[3])):lower() == args[3] or v.DisplayName:sub(1,string.len(args[3])):lower() == args[3] then
					p2 = v
				end
			end
			if p1 ~= nil and p2 ~= nil then
				p1.Character.HumanoidRootPart.CFrame = p2.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2)
			end
		end,
	},
	{
		name = "god",
		aliases = {},
		description = "Makes the specified users invincible",
		category = "fun",
		level = 1,
		
		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.MaxHealth = math.huge
				v.Character.Humanoid.Health = math.huge
			end
		end,
	},
	{
		name = "ungod",
		aliases = {},
		description = "Sets the specified users' health to 100",
		category = "fun",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.MaxHealth = 100
				v.Character.Humanoid.Health = 100
			end
		end,
	},
	{
		name = "health",
		aliases = {},
		description = "Sets the specified users' health to the said number",
		category = "fun",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.MaxHealth = tonumber(args[3])
				v.Character.Humanoid.Health = tonumber(args[3])
			end
		end,
	},
	{
		name = "sit",
		aliases = {},
		description = "Makes the specified user sit down",
		category = "misc",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character.Humanoid.Sit = true
			end
		end,
	},
	{
		name = "kill",
		aliases = {"oof"},
		description = "Kills the specified user 💀",
		category = "misc",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				v.Character:BreakJoints()
			end
		end,
	},
	{
		name = "rejoin",
		aliases = {},
		description = "Rejoins the game",
		category = "misc",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				game:GetService("TeleportService"):Teleport(game.PlaceId, player)
			end
		end,
	},
	{
		name = "message",
		aliases = {"m", "msg"},
		description = "Sends a message",
		category = "moderation",
		level = 2,

		execute = function(player, args)
			local msg = ""
			local r = {}
			for i = 2,#args do
				table.insert(r, args[i])
			end
			msg = table.concat(r, " ")
			game.ReplicatedStorage:WaitForChild("KeeAdminEvents").Message:FireAllClients("Message", msg, player.Name, "Message from "..player.Name, nil)
		end,
	},
	{
		name = "tempban",
		aliases = {"tban", "serverban", "sban"},
		description = "Temporarily bans the specified user",
		category = "moderation",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v == player then Notify(player, "Can't tempban self") return end
				table.insert(env, v.Name)
				player:Kick("\nKeeAdmin\nYou have been temporarily banned from this server!\n\n")
			end
		end,
	},
	{
		name = "serverlocation",
		aliases = {"sl"},
		description = "Get the server location",
		category = "misc",
		level = 1,

		execute = function(player, args)
			local data = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("http://ip-api.com/json"))
			Notify(player, string.format("Country: %s\nState: %s\nCity: %s\nTime zone: %s", data.country, data.region, data.city, data.timezone), "Server Location")
		end,
	},
	{
		name = "btools",
		aliases = {"f3x"},
		description = "Gives the specified player building tools",
		category = "fun",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				game.ServerStorage.Tools["Building Tools"]:Clone().Parent = player.Backpack
			end
		end,
	},
	{
		name = "changestat",
		aliases = {"change"},
		description = "Changes the specified player's currency",
		category = "fun",
		level = 1,

		execute = function(player, args)
			for _,v in pairs(GetPlayer(player, args)) do
				if v:FindFirstChild("leaderstats") then
					if v.leaderstats:FindFirstChild(args[3]) then
						v[args[3]].Value += tonumber(args[4])
					end
				end
			end
		end,
	}
}

return commands
