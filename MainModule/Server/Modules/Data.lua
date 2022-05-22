local Data = {}
local cache = {}

local DSS = game:GetService("DataStoreService")
local players = game:GetService("Players")

local TEMPLATE = {
	Ban = {
		Banned = false,
		Reason = "N/A",
		Moderator = nil
	},
	Level = 0,
}

function Data.setKey(key)
	Data["key"] = key
end

function Data.onJoin(player)
	local data = nil
	
	local success, err = pcall(function() 
		data = DSS:GetDataStore(Data["key"] or "KeeAdminData"):GetAsync("UID_"..player.UserId)
		data = data or TEMPLATE
	end)
	
	if not success then
		warn("[KeeAdmin] Failed to load data for UID_"..player.UserId..". Kicking now.")
		player:Kick("\n[KeeAdmin]\n\nFailed to load data. Please rejoin. If the problem persists, please contact the game owner or zCrxtix via the devforum.")
	end
	
	for index, value in pairs(TEMPLATE) do
		if not data[index] then
			data[index] = value
		end
	end

	cache[player] = data
end

function Data.get(player)
	return cache[player] or TEMPLATE
end

function Data.set(player)
	local success, err = pcall(function() DSS:GetDataStore(Data['key'] or "KeeAdminData"):SetAsync("UID_"..player.UserId, cache[player]) end)
	if not success then
		warn('[KeeAdmin] Failed to set data for UID_'..player.UserId..".\n"..err)
	end
end

return Data
