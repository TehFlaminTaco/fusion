--[[ 
	Modules:
		Administration Commands
	
	Description:
		A collection of administration commands.
 ]]

fusion.commands["setrank"] = {
	Name = "Set Rank",	
	Hierarchy = 90,
	Category = "administration",
	Args = 2,
	Help = "Sets a player's rank.",
	NotSelf = true,
	Message = "%s set the rank of %s to %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = args[2]
		
		if !fusion.Ranks[arg1] then fusion.Message( ply, "That rank does not exist" ) return end
		if IsValid( ply ) and ( fusion.Ranks[arg1].Hierarchy > ply.Hierarchy ) then fusion.Message( ply, "That rank is higher than your own in the hierarchy." ) return end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				fusion.sv.InitializeRank( v, arg1, true )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		local id = fusion.Ranks[arg1].ID
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, fusion.TeamMarkup( id ) )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}


fusion.commands["settime"] = {
	Name = "Set Time",	
	Hierarchy = 90,
	Category = "administration",
	Args = 2,
	Hidden = true,
	Help = "Sets a player's time (to fix droke's mistakes).",
	Message = "%s set the time of %s to %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = args[2]
		
		local time = nil
		if arg1 and tonumber(arg1) then
			time = tonumber(arg1)
		else
			fusion.Message( ply, "That's not a number" ) return
		end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetTime( time )
				fusion.sv.UpdateDBTime( v )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, time )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["sudohelp"] = {
	Name = "Sudo Help",	
	Hierarchy = 60,
	Category = "administration",
	Args = 0,
	Help = "Gives help on the sudo system.",
	Message = "* SUDO *\n\nHelp: \nPossible ranks:\n%s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message

		local ranks = {}
		for k,v in pairs(fusion.Ranks) do
			if v.Hierarchy < ply.Hierarchy then
				table.insert(ranks, " * " .. k .. " = " .. v.Name )
			end
		end		

		fusion.Message(ply, "Check your console")
		
		fusion.ConsoleDump(ply, "* SUDO *\n")
		fusion.ConsoleDump(ply, "Help:\n")
		fusion.ConsoleDump(ply, "Allows you to appear as a rank below your real rank, any commands you run\nwhile in a sudo rank that would not normally be able to be ran by the sudo\nrank will have their messages hidden from non admins.\n")
		fusion.ConsoleDump(ply, "\nPossible ranks:\n")
		fusion.ConsoleDump(ply, string.Implode("\n", ranks))
		
	end	
}

fusion.commands["sudo"] = {
	Name = "Sudo",	
	Hierarchy = 60,
	Category = "administration",
	Hidden = true,
	Args = 1,
	Help = "Appear as another rank.",
	Message = "%s is now appearing as %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local arg1 = args[1]
		
		if table.HasValue( { "none", "None", "Stop", "stop", "normal" }, arg1 ) then
		
			fusion.sv.RemoveData( ply, "sudo" )
			fusion.CMDMessage( fusion.PlayerMarkup( ply ) .. " is no longer appearing as another rank", ply, cmd )
			fusion.sv.InitializeRank( ply, ply.Rank, true )
			ply.Sudo = nil
			
			return
			
		end
		
		if !fusion.Ranks[arg1] then fusion.Message( ply, "That rank does not exist" ) return end
		if fusion.Ranks[arg1].Hierarchy >= ply.Hierarchy then fusion.Message( ply, "You cannot appear as a rank higher than your own" ) return end
		
		fusion.sv.SetData( ply, "sudo", arg1 )
		
		fusion.sv.SetTeam( ply, arg1 )
		ply.Sudo = arg1
		
		local id = fusion.Ranks[arg1].ID
		local msg = string.format( message, fusion.PlayerMarkup( ply ), fusion.TeamMarkup( id ) )
		fusion.CMDMessage( msg, ply, cmd )			
	end	
}

fusion.commands["kick"] = {
	Name = "Kick",	
	Hierarchy = 60,
	Category = "administration",
	Args = 1,
	Help = "Kick a player with an optional reason (default: 'No reason').",
	Message = "%s kicked %s (%s)",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = table.concat( args, " ", 2 )
		
		if !arg1 or arg1 == nil or arg1 == "" then
			arg1 = "No reason"
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
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
		
		if players then
			timer.Simple( 0.5, function()
				for k,v in pairs( players ) do
					local kickMinutes = math.Round( 1 * 60 )
					fusion.sv.AddBan( v:SteamID(), v:Name(), ply:Name(), "You were automatically banned for " .. kickMinutes .. " minutes as the results of being kicked.", kickMinutes )
					fusion.sv.DropPlayer( v, "[Fusion]: Kicked by admin - '" .. arg1 .. "'" )
				end
			end )
		end				
	end	
}

fusion.commands["cexec"] = {
	Name = "Execute on Player",	
	Hierarchy = 80,
	Category = "administration",
	Args = 1,
	Hidden = true,
	Help = "Executes a command in a player's console.",
	Message = "%s executed '%s' on %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local run = table.concat( args, " ", 2 )
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SendLua( "LocalPlayer():ConCommand( '" .. run .. "')" )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )				
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), run, tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end
						
	end	
}

fusion.commands["map"] = {
	Name = "Changemap",	
	Hierarchy = 80,
	Category = "administration",
	Args = 1,
	Help = "Changes the map with an optional timer (default: '2').",
	Message = "%s changed the map to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local maps = fusion.sh.GetMaps()
		
		if !table.HasValue( maps, name ) then 
			fusion.Message( ply, "#{" .. name .. "}# does not exist" )	
			return
		end
		
		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.ChangeMap( name, tonumber( args[2] ) or 2 )
		fusion.CMDMessage( msg, ply, cmd )			
		
	end	
}

-- fusion.commands["defaultmap"] = {
	-- Name = "Change Default Map",	
	-- Hierarchy = 95,
	-- Category = "administration",
	-- Args = 1,
	-- Help = "Changes the default map.",
	-- Message = "%s changed the default map to #{%s}#",
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
		-- local name = args[1]
		-- local maps = fusion.sh.GetMaps()
		
		-- if !table.HasValue( maps, name ) then 
			-- fusion.Message( ply, "#{" .. name .. "}# does not exist" )	
			-- return
		-- end
		
		-- local map_file = "fusion/default_map.txt"			
		
		-- file.Write(map_file, name)
		
		-- local msg = string.format(message, fusion.PlayerMarkup( ply ), name)
		-- fusion.CMDMessage( msg, ply, cmd )
		
	-- end	
-- }

fusion.commands["createrank"] = {
	Name = "Create Rank",	
	Hierarchy = 90,
	Category = "administration",
	Args = 2,
	Hidden = true,
	Help = "Creates a new rank.",
	Message = "%s created the rank #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local copy = args[2]
		
		if fusion.Ranks[name] then
			fusion.Message( ply, "#{" .. name .. "}# already exists" )	
			return
		end
		
		if !fusion.Ranks[copy] or fusion.Ranks[copy].Hierarchy > ply.Hierarchy then
			copy = "guest"
		end

		local data = fusion.Ranks[copy]		
		
		fusion.Ranks[name] = table.Copy( data )		
		fusion.Ranks[name].ID = math.random( 500, 2000 )
		
		net.Start("fusion_Ranks")
		net.WriteTable(fusion.Ranks)		
		net.Broadcast()
	
		team.SetUp(data.ID, data.Name, Color (data.R, data.G, data.B, 255))	
		
		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.CMDMessage( msg, ply, cmd )
		fusion.sv.SaveRanks()
	end	
}

fusion.commands["removerank"] = {
	Name = "Remove Rank",	
	Hierarchy = 90,
	Category = "administration",
	Args = 1,
	Hidden = true,
	Help = "Removes a rank.",
	Message = "%s removed the rank #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local copy = args[2]
		
		disallowed = {}
		-- disallowed.loading= fusion.Settings["loading-rank"]
		disallowed.guest = fusion.Settings["default-rank"]
		disallowed.owner = fusion.Settings["superadmin-rank"]
		
		if !fusion.Ranks[name] then
			fusion.Message( ply, "#{" .. name .. "}# doesn't exist" )	
			return
		end
		
		if table.HasValue( disallowed, name ) then
			fusion.Message( ply, "#{" .. name .. "}# cannot be removed" )	
			return
		end		
		
		if fusion.Ranks[name].Hierarchy >= ply.Hierarchy then
			fusion.Message( ply, "You cannot remove a rank with a hierarchy level higher or equal to your own" )	
			return
		end
		
		for k,v in pairs( player.GetAll() ) do				
			if v.Rank == name then	
				fusion.sv.InitializeRank( v, disallowed.guest, true, false )
				fusion.Message( v, "Your rank has been removed, you have been moved to >" .. fusion.Ranks[disallowed.guest].ID )
				
			elseif v.Sudo and v.Sudo == name then
				fusion.sv.SetTeam( v, disallowed.guest )
				v.Sudo = disallowed.guest
				fusion.sv.SetData( v, "sudo", disallowed.guest )
				fusion.Message( v, "The rank you are appearing as has been removed, you are now appearing as a >" .. fusion.Ranks[disallowed.guest].ID )
			
			end
				
		end

		fusion.Ranks[name] = nil
		
		net.Start("fusion_Ranks")
		net.WriteTable(fusion.Ranks)		
		net.Broadcast()
		
		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.CMDMessage( msg, ply, cmd )
		fusion.sv.SaveRanks()
	end	
}

fusion.commands["updaterank"] = {
	Name = "Update Rank",	
	Hierarchy = 90,
	Category = "administration",
	Args = 12,
	Hidden = true,
	Help = "Updates a rank.",
	Message = "%s updated the rank #{%s}#",
	Function = function( ply, cmd, args )
		
		local message = fusion.commands[cmd].Message
		local uid = args[1]
		local tid = tonumber( args[2] )
		local hierarchy = tonumber( args[3] )
		local timereq = tonumber( args[4] )
		local r = tonumber( args[5] )
		local g = tonumber( args[6] )
		local b = tonumber( args[7] )
		local icon = args[8]
		local health = tonumber( args[9] )
		local armour = tonumber( args[10] )
		local speed = tonumber( args[11] )
		local name = table.concat( args, " ", 12, #args )
	
		if !uid or !tid or !hierarchy or !timereq or !r or !g or !b or !icon or !health or !armour or !speed or !name then		
			fusion.Message( ply, "One or more arguments are invalid" )				
			return		
		end
		
		if hierarchy > ply.Hierarchy then
			fusion.Message( ply, "Updated rank would have a hierarchy level greater than yours" )				
			return			
		end
		
		if fusion.Ranks[uid] then
			local data = fusion.Ranks[uid]
			
			if data.Hierarchy > ply.Hierarchy then
				fusion.Message( ply, "Rank has a hierarchy level greater than yours" )				
				return	
			end
			
			local restricted = false
			if uid == ply.Rank then
				restricted = true			
			end
			
			if !restricted then
				data.ID = tid
				data.Hierarchy = hierarchy
			end

			data.R = r
			data.G = g
			data.B = b
			
			data.TimeReq = timereq
			data.Icon = icon
			data.Speed = speed
			data.Health = health
			data.Armour = armour
			data.Name = name			
			
			fusion.Ranks[uid] = data

			net.Start("fusion_Ranks")
			net.WriteTable(fusion.Ranks)		
			net.Broadcast()
			
			team.SetUp(data.ID, data.Name, Color (data.R, data.G, data.B, 255))	
			
			for k,v in pairs( player.GetAll() ) do				
				if v.Rank == uid and !v.Sudo then	
					fusion.sv.InitializeRank( v, v.Rank )
					fusion.Message( v, "Your rank has been updated, reloading rank" )
					
				elseif v.Sudo and v.Sudo == uid then
					fusion.sv.SetTeam( v, v.Sudo )
					fusion.Message( v, "The rank you are appearing as has been updated, reloading rank" )				
				end
					
			end
			
			local msg = string.format( message, fusion.PlayerMarkup( ply ), uid )
			fusion.CMDMessage( msg, ply, cmd )
			fusion.sv.SaveRanks()
		else
			fusion.Message( ply, "Invalid rank" )	
		end	
	end	
}

fusion.commands["reload"] = {
	Name = "Reload",	
	Hierarchy = 70,
	Category = "administration",
	Args = 0,
	Help = "Reloads the current map with an optional timer (default: '2').",
	Message = "%s reloaded the map",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		
		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.ChangeMap( tostring( game.GetMap() ), tonumber( args[1] ) or 2 )
		fusion.CMDMessage( msg, ply, cmd )			
		
	end	
}

fusion.commands["cancelmap"] = {
	Name = "Cancel Map Change",	
	Hierarchy = 70,
	Category = "administration",
	Args = 0,
	Help = "Cancels the current map change timer.",
	Message = "%s cancelled the map change timer",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		
		fusion.MapChangeBroadcast()	
		fusion.sv.MapChangeTimer = nil

		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.CMDMessage( msg, ply, cmd )	
	end	
}

function fusion.ChangeMap( map, time )

	local max = 60 * 60 * 24 -- day
	if (time > max) then
		time = max
	end

	if time and time > 1 then
		fusion.GlobalMessage( "Map changing to #{" .. map .. "}# in " .. fusion.ConvertTime( time ), false, false )
	
		fusion.MapChangeBroadcast( map, time+CurTime() )	
		fusion.sv.MapChangeTimer = {map = map, time = time+CurTime()}
	else
		game.ConsoleCommand( "changelevel " .. map .. "\n" )
	end
end

hook.Add("Think", "mapChangeHandler", function()	
	if (fusion.sv.MapChangeTimer and fusion.sv.MapChangeTimer.map and fusion.sv.MapChangeTimer.time) then
		if (CurTime() > fusion.sv.MapChangeTimer.time) then
			game.ConsoleCommand( "changelevel " .. fusion.sv.MapChangeTimer.map .. "\n" )
		end
	end
end)

fusion.commands["convar"] = {
	Name = "Set Convar",	
	Hierarchy = 90,
	Category = "administration",
	Args = 2,
	Help = "Sets a serverside convar.",
	Message = "%s set %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric" ) return false end
	
		if !ConVarExists( name ) then fusion.Message( ply, "#{" .. name .. "}# doesn't exist" ) return false end
	
		local msg = string.format( message, fusion.PlayerMarkup( ply ), name, arg1 )
		
		game.ConsoleCommand( name .. " " .. arg1 .. "\n" )
		
		fusion.CMDMessage( msg, ply, cmd )			

	end	
}

fusion.commands["max"] = {
	Name = "Set Entity Limits",	
	Hierarchy = 80,
	Category = "administration",
	Args = 2,
	Help = "Sets the maximum number of a type of entity that can be spawned.",
	Message = "%s set the limit for %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = "sbox_max" .. args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric" ) return false end
	
		if !ConVarExists( name ) then fusion.Message( ply, "#{" .. name .. "}# doesn't exist" ) return false end
	
		local msg = string.format( message, fusion.PlayerMarkup( ply ), args[1], arg1 )
		
		game.ConsoleCommand( name .. " " .. arg1 .. "\n" )
		
		fusion.CMDMessage( msg, ply, cmd )			

	end	
}


fusion.commands["debugtest"] = {
	Name = "Debug Test",	
	Hierarchy = 60,
	Category = "administration",
	Hidden = true,
	Args = 0,
	Help = "Test the command debug system.",
	Function = function( ply, cmd, args )
		TestDebug()			
	end	
}