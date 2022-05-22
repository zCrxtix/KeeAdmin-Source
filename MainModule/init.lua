--[[
		Thank you for using
		 _  __          _      _       _      
		| |/ /___ ___  /_\  __| |_ __ (_)_ _  
		| ' </ -_) -_)/ _ \/ _` | '  \| | ' \ 
		|_|\_\___\___/_/ \_\__,_|_|_|_|_|_||_|
		
		Don't touch anything unless you know what you're doing

		MainModule
			Initializes the server
		
		Authors:
			- zCrxtix (crxtix)
			- co_existance (deprecatedbrain)
]]

return function (configuration, client_packages, server_packages)
  require(script.Server.Main)(configuration, client_packages, server_packages)
end
