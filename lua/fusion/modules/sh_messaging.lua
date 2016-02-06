--[[ 
	Modules:
		Announcements
	
	Description:
		Functions and commands related to announcemenets.
 ]]
 
if (SERVER) then 
 
fusion.commands["pm"] = {
	Name = "Private Message",	
	Hierarchy = 0,
	Category = "messages",
	Args = 2,
	NotSelf = true,
	Ignore = true,
	Help = "Send a message to another player.",
	Function = function( ply, cmd, args )
		
		local name = args[1]
		local text = table.concat( args, " ", 2 )
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				fusion.Message( v, text, true, ply:UniqueID(), "From " )
				fusion.Message( ply, text, true, v:UniqueID(), "To " )
			end
		end
		
	end	
}

fusion.commands["local"] = {
		Name = "Local",	
		Hierarchy = 0,
		Category = "messages",
		Args = 1,
		Help = "Send a message to the local area.",
		Function = function( ply, cmd, args )
			
			local msg = table.concat( args, " " )
			
			if !msg then
				fusion.Message( ply, "You have not entered a message." )
				return
			end	
			
			for k,v in pairs(player.GetAll()) do
				local dist = v:GetPos():Distance(ply:GetPos())
				
				if (dist < 500) then
					fusion.Message( v, msg, true, ply:UniqueID(), "(local) " )
				end
			end
			
			///ply:ConCommand("fusion local " .. msg)				
		end	
	}

fusion.commands["me"] = {
	Name = "Roleplay",	
	Hierarchy = 0,
	Category = "messages",
	Args = 1,
	NotSelf = true,
	Ignore = true,
	Help = "Send a roleplaying message.",
	Function = function( ply, cmd, args )		
		local text = table.concat( args, " ", 1 )		
		for k,v in pairs( player.GetAll() ) do
			fusion.Message( v, text, true, ply:UniqueID(), "IGNORE" )
		end
		
	end	
}

fusion.commands["ac"] = {
	Name = "Message to Admins",	
	Hierarchy = 10,
	Category = "messages",
	Args = 1,
	Help = "Send a message to online administrators.",
	Message = "%s to #:admins %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		
		local text = table.concat( args, " ", 1 )
		
		for k,v in pairs( player.GetAll() ) do
			if v:IsMod() then
				fusion.Message( v, text, true, ply:UniqueID(), "@admins " )
			end			
		end
		
	end	
}


-- fusion.commands["motd"] = {
	-- Name = "Welcome Message",	
	-- Hierarchy = 0,
	-- Category = "messages",
	-- Args = 0,
	-- Help = "Opens the welcome message.",
	-- Function = function( ply, cmd, args )		
		-- ply:ConCommand( "fusion_openwelcome" )
	-- end	
-- }

end