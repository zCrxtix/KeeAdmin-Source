local playerApi = {}

function playerApi.getPlayer(plr : Player, args)
	if string.lower(args[2]) == "me" then
		return {plr}
	elseif string.lower(args[2]) == "others" then
		local t = {}
		for i,v in pairs(game.Players:GetPlayers()) do
			if v ~= plr then
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
		for i,v in pairs(game.Players:GetPlayers()) do
			if string.match(args[2], v.Name, 1) then
				return {v}
			end
		end
	end
	return {}
end

return playerApi
