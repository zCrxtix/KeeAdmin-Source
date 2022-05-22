local playerApi = {}

local players = game:GetService("Players")

function playerApi.onJoin(cb)
	return players.PlayerAdded:Connect(cb)
end

function playerApi.onChatted(cb)
	return players.PlayerAdded:Connect(function(player)
		player.Chatted:Connect(function(msg, r)
			cb(player, msg, false)
		end)
	end)
end

function playerApi.checkPlayerRank(player, config) --// Not sure how efficient this is. Can be changed if needed.
	for i,v in pairs(config["Players"]) do
		if type(v) == "number" then
			if player.UserId == v then
				return 0
			end
		elseif type(v) == "string" then
			if player.Name == v then
				return 0
			end
		else
			warn("[KeeAdmin] Players have an invalid value type, "..type(v))
		end
	end
	for i,v in pairs(config["Moderators"]) do
		if type(v) == "number" then
			if player.UserId == v then
				return 1
			end
		elseif type(v) == "string" then
			if player.Name == v then
				return 1
			end
		else
			warn("[KeeAdmin] Moderators have an invalid value type, "..type(v))
		end
	end
	for i,v in pairs(config["Administrators"]) do
		if type(v) == "number" then
			if player.UserId == v then
				return 2
			end
		elseif type(v) == "string" then
			if player.Name == v then
				return 2
			end
		else
			warn("[KeeAdmin] Administrators have an invalid value type, "..type(v))
		end
	end
	for i,v in pairs(config["Owners"]) do
		if type(v) == "number" then
			if player.UserId == v then
				return 3
			end
		elseif type(v) == "string" then
			if player.Name == v then
				return 3
			end
		else
			warn("[KeeAdmin] Owners have an invalid value type, "..type(v))
		end
	end
end

function playerApi.getPlayer(player : Player, args)
	if args[2] == nil then return {player} end
	if string.lower(args[2]) == "me" then
		return {player}
	elseif string.lower(args[2]) == "others" then
		local t = {}
		for i,v in pairs(game.Players:GetPlayers()) do
			if v ~= player then
				table.insert(v)
			end
		end
		return t
	elseif string.lower(args[2]) == "all" then
		local t = {}
		for i,v in pairs(game.Players:GetPlayers()) do
			table.insert(v)
		end
		return t
	else
		for _, v in pairs(game.Players:GetPlayers()) do
			if v.Name:sub(1,string.len(args[2])):lower() == args[2] then
				return {v}
			elseif v.DisplayName:sub(1,string.len(args[2])):lower() == args[2] then
				return {v}
			end
		end
	end
	return {}
end

return playerApi
