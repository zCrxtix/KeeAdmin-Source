function GetPlayer(player, args)
	return require(script.Parent.Player).getPlayer(player, args)
end

local commands = {
	{
		name = "test",
		aliases = {"test2"},
		prefix = ":",
		description = "Set the player's walkspeed",
		category = "misc",
		level = 0,
		canUseOnSelf = true,

		execute = function(player, args)
			print(args)
		end,
	},
	{
		name = "commands",
		aliases = {"cmds"},
		prefix = ":",
		description = "Opens this UI",
		category = "misc",
		level = 0,
		canUseOnSelf = true,

		execute = function(player, args)
			local interface = require(script.Parent.Interface)
			local clone = script.Parent.Parent.GUIs.CommandUI:Clone()
			interface.FadeOut(clone.Background, 0.001)
			wait()
			clone.Enabled = true
			interface.FadeIn(clone.Background, 0.4)
			clone.Parent = player.PlayerGui
		end,
	},
}

return commands
