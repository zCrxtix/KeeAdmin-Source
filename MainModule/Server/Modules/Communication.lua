local communication = {}

function communication.init()
	local KeeAdminEvents = Instance.new("Folder", game.ReplicatedStorage); KeeAdminEvents.Name = "KeeAdminEvents"
	local executeCommand = Instance.new("RemoteEvent", KeeAdminEvents); executeCommand.Name = "ExecuteCommands"
	local getPrefix = Instance.new("RemoteFunction", KeeAdminEvents); getPrefix.Name = "GetPrefix"
	
	return KeeAdminEvents, executeCommand, getPrefix
end

return communication
