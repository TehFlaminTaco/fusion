--[[ 
	Modules:
		Banning
	
	Description:
		Handles banning.
 ]]

if SERVER then
	require("mysqloo")	
	
	function fusion.sv.SendBans()
		if fusion.Bans then				
			net.Start("fusion_Bans")
			net.WriteTable(fusion.Bans)		
			net.Broadcast()
		end
	end	
end
 
fusion.commands["ban"] = {
	Name = "Ban",	
	Hierarchy = 60,
	Category = "administration",
	Args = 2,
	Help = "Bans a player for a length of time in minutes with an optional reason (default: 'No reason').",
	Message = "%s banned %s for %s ( %s )",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber(args[2])
		local arg2 = table.concat( args, " ", 3 )
		local tban = true
		
		if !arg1 or arg1 == nil or arg1 == 0 then
			arg1 = 0
			message = "%s permanently banned %s (%s)"
			tban = false
		else
			arg1 = math.Round( arg1 * 60 )
		end	
		
		if !arg2 or arg2 == nil or arg2 == "" then
			arg2 = "No reason"
		end	
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )			
			local msg
			if !tban then
				msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg2 )
			else
				local time = fusion.ConvertTime( arg1 )
				msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, time, arg2 )
			end
			fusion.CMDMessage( msg, ply, cmd )			
		end	
		
		timer.Simple( 1, function()
			if players then		
				for k,v in pairs( players ) do
					if IsValid( v ) then
						fusion.sv.AddBan( v:SteamID(), v:Name(), ply:Name(), arg2, arg1 )						
						fusion.sv.BanDrop( v, arg2 )
					end	
				end
			end	
		end	)
	end	
}

fusion.commands["editban"] = {
	Name = "Edit Ban",	
	Hierarchy = 70,
	Category = "administration",
	Args = 2,
	Help = "Extend the time of a ban.",
	Message = "%s extended the ban length of #{%s}# to %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber(args[2])		
		
		if !fusion.Bans[name] then
			fusion.Message( v, "A ban does not exist for that id" )		
			return
		end	

		if !arg1 or arg1 < 0 then
			fusion.Message( v, "Ban length must be numeric and not be a negative number" )		
			return
		end
		
		arg1 = math.Round( arg1 * 60 )
		
		local formatted = false
		local time = ( os.date( os.time() ) + arg1 )
		
		if arg1 != 0 then		
			formatted = fusion.ConvertTime( arg1 )--os.date( os.time() ) + arg1 )
		else
			message = "%s changed the ban of #{%s}# to a permanent ban"
			time = 0
		end
		
		msg = string.format( message, fusion.PlayerMarkup( ply ), name, formatted )
		fusion.CMDMessage( msg, ply, cmd )
		
		-- fusion.Bans[name].Unban = time
		fusion.sv.AddBan( name, fusion.Bans[name].Name, fusion.Bans[name].Banner, fusion.Bans[name].Description, arg1 )		
					
	end	
}

fusion.commands["removeban"] = {
	Name = "Remove Ban",	
	Hierarchy = 70,
	Category = "administration",
	Args = 1,
	Help = "Remove a ban.",
	Message = "%s removed the ban of #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
				
		if !fusion.Bans[name] then
			fusion.Message( ply, "A ban does not exist for that id" )		
			return
		end	
		
		msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.CMDMessage( msg, ply, cmd )
		
		fusion.sv.RemoveBan( name )
		
					
	end	
}

fusion.commands["banid"] = {
	Name = "Ban SteamID",	
	Hierarchy = 70,
	Category = "administration",
	Args = 2,
	Help = "Ban a SteamID for X time and Y reason.",
	Message = "%s banned #{%s}# for %s ( %s )",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber(args[2])
		local arg2 = args[3]
		
		if (#args > 3) then
			arg2 = table.concat(table.concat(args, " ", 3, #args))
		end
		
		if !arg1 or arg1 == nil or arg1 == 0 then
			arg1 = 0
			message = "%s permanently banned #{%s}# (%s)"
			tban = false
		else
			arg1 = math.Round( arg1 * 60 )
		end	
		
		if !arg2 or arg2 == nil or arg2 == "" then
			arg2 = "No reason"
		end
		
		local msg
		if !tban then
			msg = string.format( message, fusion.PlayerMarkup( ply ), name, arg2 )
		else
			local time = fusion.ConvertTime( arg1 )
			msg = string.format( message, fusion.PlayerMarkup( ply ), name, time, arg2 )
		end
		fusion.CMDMessage( msg, ply, cmd )			
		
		timer.Simple( 1, function()
			fusion.sv.AddBan( name, name, ply:Name(), arg2, arg1 )		
		end	)		
		
					
	end	
}
