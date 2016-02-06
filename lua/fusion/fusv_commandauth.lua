function fusion.sv.CanDo( ply, cmd )
	if fusion.commands[cmd] then	
		local tbl = fusion.commands[cmd]

		if !ply:IsValid() then return true end
		
		if ply.Hierarchy and ply.Hierarchy >= tbl.Hierarchy then
			return true
		end
	end
	return false		
end

function fusion.sv.CanRunOn( ply, targ, cmd )	
	if fusion.commands[cmd] then
		if fusion.commands[cmd].NotSelf and ( ply == targ ) then --or ply.Hierarchy == targ.Hierarchy ) then
			return false
		elseif ply.Hierarchy > targ.Hierarchy and ( ply:IsMod() ) then
			return true
		elseif fusion.commands[cmd].Ignore then
			return true
		elseif ply == targ then
			return true		
		end
	end
	return false
end

-- function fusion.sv.CanMeCommand( ply, cmd, targ )
	-- local cmdhier = fusion.commands[cmd].MeHierarchy
	-- if cmdhier and targ == ply then
		-- if ply.Hierarchy and ply.Hierarchy >= cmdhier then
					
		-- end
	-- end
	-- return false
-- end

function fusion.sv.StringMatches( ply, targ, str )
	local st = string.lower( str )
	local name = string.lower( targ:Name() )
	local sid = string.lower( targ:SteamID() )
	local uid = tostring( targ:UniqueID() )
	if st == "<all>" then
		return true
	elseif st == "<notself>" then
		return ply != targ
	elseif st == "<self>" then
		return ply == targ
	elseif st == "<xhair>" then
		local eye = ply:GetEyeTrace()
		local ent = eye.Entity		
		return ( IsValid( ent ) and ent == targ	)
	elseif targ.Rank and st == "<" .. targ.Rank .. ">" then
		return true
	elseif st == sid then
		return true
	elseif st == uid then
		return true
	elseif st == usid then
		return true	
	elseif string.find( string.lower( name ), string.lower( st ), nil, true ) then
		return true
	-- elseif string.find( st, "," ) then
		-- local strtbl = string.Explode( ",", st )
		-- for k,v in pairs( strtbl ) do
			-- if string.find( string.lower( name ), string.lower( v ), nil, true ) then
				-- return true
			-- end
		-- end		
	elseif string.find( st, "|" ) then
		local utbl = string.Explode( "|", st )
		for k,v in pairs( utbl ) do
			if v == uid then
				return true
			end
		end	
		return false
	else
		return false
	end
end

function fusion.sv.GetPlayers( ply, cmd, str )
	local success = {}
	local failed = {}	
	
	for k,v in pairs( player.GetAll() ) do
		if fusion.sv.StringMatches( ply, v, str ) then
			if !ply:IsValid() or (fusion.sv.CanRunOn(ply, v, cmd) and ( !fusion.commands[cmd].Condition or fusion.commands[cmd].Condition(ply, v) ) ) then
				table.insert( success, v )
			else			
				table.insert( failed, fusion.PlayerMarkup( v ) )
			end	
		end
	end	
	
	local failstring = string.Implode(", ", failed)		
	
	if fusion.sh.TableHasData( failed ) then
		print("|cm|"..cmd.."|/cm| failed on " .. failstring)
		fusion.Message( ply, fusion.CommandMarkup(cmd).." failed on " .. failstring )		
	else
		if !fusion.sh.TableHasData( success ) and !fusion.sh.TableHasData( failed ) then
			fusion.Message(ply, fusion.CommandMarkup(cmd).." found no targets")
		end
	end	
		
	return success	
end	


function fusion.sv.PrintCommands( ply, rank )

	local data = fusion.Ranks[rank]
	
	if data then
		local h = data.Hierarchy

		local categories = {}
		for k,v in pairs( fusion.commands ) do	
			if !IsValid( ply ) or h >= v.Hierarchy then
				if !categories[v.Category] then
					categories[v.Category] = { k }
				else
					table.insert( categories[v.Category], k )
				end	
			end	
		end
		
		fusion.ConsoleDump( ply, string.upper( "Command List for " .. data.Name ) )
		for k,v in pairs( categories ) do
			local div = string.rep( "-", string.len( k ) )
			fusion.ConsoleDump( ply, "\n" )
			fusion.ConsoleDump( ply, string.upper( k ) )
			fusion.ConsoleDump( ply, div )
			--fusion.ConsoleDump( ply, string.Implode( "\n", v ) )
			for _,str in pairs( v ) do
				
				local dat = fusion.commands[str]
				fusion.ConsoleDump( ply, "   -  " .. dat.Name .. " - " .. "fusion " .. str .. " " .. string.rep( "<arg> ", dat.Args ) )
				fusion.ConsoleDump( ply, "           " .. dat.Help )
				fusion.ConsoleDump( ply, "\n" )
			end	
			fusion.ConsoleDump( ply, div )		
		end	
	end
end

function fusion.sv.RunCommand( ply, cmd, args )	
	if !args[1] then fusion.sv.PrintCommands( ply.Rank ) return end
	local command = args[1]	
	
	if !fusion.commands[command] then fusion.Message( ply, "That command does not exist" ) return end
	if fusion.sv.CanDo( ply, command ) then		
		
		if !( table.Count( args ) > fusion.commands[command].Args ) then
			fusion.Message( ply, "You need to specify atleast " .. fusion.commands[command].Args .. " argument for this command" ) 
			return false
		end	
		
		local str = table.concat( args, " ", 2, table.Count( args ) )
		local tbl = string.Explode( " ", str )
		
		local status, error = pcall( function() fusion.commands[command].Function( ply, command, tbl ) end ) 
		if error then
			fusion.Message( ply, fusion.CommandMarkup(command) .. " incurred an error" ) 
			fusion.Message( ply, error, true ) 
		end	
		
	else
		fusion.FormattedMessage( ply, "You do not have access to %s", fusion.CommandMarkup(command))		
	end
	return false
	
end
concommand.Add( "fusion", fusion.sv.RunCommand )

function fusion.sv.ChatCommand( ply, str, team )		
	local args = string.Explode( " ", str )
	
	if !args[1] then return end
	local cmd = args[1]		
	local prefix = string.Left( cmd, 1 )
	
	-- print(prefix)
	
	if table.HasValue(fusion.Settings["prefix"], prefix) then
		local command = string.sub( cmd, 2, string.len( cmd ) )		
		if !fusion.commands[command] then  return end // fusion.Message( ply, "That command does not exist" )
		if fusion.sv.CanDo( ply, command ) then		
			
			if !( table.Count( args ) > fusion.commands[command].Args ) then
				fusion.Message( ply, "You need to specify atleast " .. fusion.commands[command].Args .. " argument for this command" ) 
				return false
			end
			
			if table.HasValue( {"?", "--help" }, args[2] ) then
				local data = fusion.commands[command]
				local syntax = ( "/" .. command .. " " .. string.rep( " <arg>", data.Args ) )
				fusion.Message( ply, data.Name .. " - " .. syntax )
				fusion.Message( ply, "- " .. data.Help, true )
				return false
			end	
			
			local str = table.concat( args, " ", 2, table.Count( args ) )
			local tbl = string.Explode( " ", str )			
			local status, error = pcall( function() fusion.commands[command].Function( ply, command, tbl ) end ) 
			if error then
				fusion.Message( ply, fusion.CommandMarkup(command) .. " incurred an error" ) 
				fusion.Message( ply, error, true ) 
			end			
		else
			fusion.FormattedMessage( ply, "You do not have access to %s", fusion.CommandMarkup(command) )
		end
		return false
	end	
end
hook.Add( "PlayerSay", "fusion.sv.ChatCommand", fusion.sv.ChatCommand )
	