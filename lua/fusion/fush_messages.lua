if SERVER then	
	function fusion.ConsoleDump( ply, msg )
	
		if IsValid( ply ) then
			ply:PrintMessage( HUD_PRINTCONSOLE, msg )
		else
			print( msg )
		end	
	
	end
	
	function fusion.GlobalMessage( msg, bool, time )
		if time then
			timer.Simple( time, function()
				for k,v in pairs( player.GetAll() ) do
					fusion.Message( v, msg, bool )
				end
			end )
		else
			for k,v in pairs( player.GetAll() ) do
				fusion.Message( v, msg, bool )
			end
		end
		
	end
	
	function fusion.MapChangeBroadcast( map, time )
		if (map and time) then
			net.Start( "fusio-mapchange")
			net.WriteString( map )
			net.WriteDouble( time )
			net.Broadcast()
		else
			net.Start("fusio-cancelmapchange")
			net.Broadcast()
		end
	end
	
	function fusion.Message( ply, msg, bool, pID, prefix )
		if ply:IsValid() then
			if !bool then
				net.Start( "fusio-message")
				net.WriteString( msg )
				if pID then net.WriteString( pID ) end
				if prefix then net.WriteString( prefix ) end
				net.Send(ply)
			else
				net.Start( "fusio-messagechat" )
				net.WriteString( msg )
				
				-- print(pID, prefix)
				
				if pID then net.WriteString( pID ) end
				if prefix then net.WriteString( prefix ) end				
				net.Send(ply)
			end	
		else
			-- fusion.sv.ConsoleMessage( ply, msg )
		end
	end

	function fusion.CMDMessage( msg, ply, cmd )		
		local sudohier
		
		if ply.Sudo then
			sudohier = fusion.Ranks[ply.Sudo].Hierarchy
		end
		
		for k,v in pairs( player.GetAll() ) do			
		if !( ( ( ply.Sudo and sudohier and sudohier < fusion.commands[cmd].Hierarchy ) or fusion.commands[cmd].Hidden ) and !v:IsMod()  ) then				
				fusion.Message( v, msg )
			end
		end			
	end
	
	function fusion.FormattedMessage( ply, format, ... )
		local msg = string.format( format, ... )	
		fusion.Message( ply, msg )
	end	
		
	concommand.Add( "fusion_cl_requestlog", function( ply, cmd, args )
		
		if !args[1] then return end
		if !file.Exists( args[1], "DATA" ) then return end		
		
		local data = file.Read( args[1] )
		
		-- print( CurTime() )
		
		local tbl = string.Explode( "\n", data )
		
		for k,v in pairs( tbl ) do
			net.Start("fusion_menu-logpage")
				net.WriteString( v )
			net.Broadcast()
		end	
		
		-- print( CurTime() )
		
		-- datastream.StreamToClients( ply, ,  )
		
	
	end )
end

if CLIENT then
	net.Receive( "fusio-message", function( data ) 
		local msg = net.ReadString()
		
		if (string.Left(msg, 4) == "CMD:") then
			
		end
		
		fusion.cl.DoMessage( msg, bool )	
	end )
	
	net.Receive( "fusio-messagechat", function( data ) 
		local msg = net.ReadString()
		
		local pID = net.ReadString()
		local prefix = net.ReadString()
		
		if pID and prefix then
			local ply = player.GetByUniqueID(pID)
			
			if prefix == "IGNORE" then
				
			end
			
			if ply and ply:IsValid() then			
				local line = {}
				
				
				
				line.name = ply:Name()
				line.prefix = prefix
				line.nameColour = team.GetColor(ply:Team())
				line.text = msg
				line.isTeam = false
				line.isDead = false
				line.dieTime = CurTime() + 10
				
				if prefix == "IGNORE" then
					line.text = line.name .. " " .. line.text
					line.name = nil
					line.prefix = nil
					line.colour = line.nameColour
					line.nameColour = nil					
				end
				
				chatbox.AddToTable(line)
				return
			end
		end
		
		fusion.cl.DoMessageChat( msg, bool )	
	end )
	
	net.Receive( "fusio-mapchange", function( data ) 
		local map = net.ReadString()
		local time = net.ReadDouble()

		fusion.cl.MapChangeTimer = {map = map, time = time}
	end )
	
	net.Receive( "fusio-cancelmapchange", function( data ) 
		fusion.cl.MapChangeTimer = nil
	end )
	
	function fusion.cl.DoMessage( msg, bool, time )		
		local parse = fusion.ReturnMarkup( msg )

		fusion.test_Announcement( parse, time )
		
		local test = string.gsub( parse, "%b<>", "" )		
		
		print( test )	
	end
	
	function fusion.cl.DoMessageChat( msg, bool )
		
		local msgtbl = string.Explode( " ", msg )		
		local globcolour = false
		
		sendtbl = {}	
				
		for i,e in ipairs(msgtbl) do
			local id = tostring( string.sub( e, 2, string.len( e ) ) )
			local id2 = tostring( string.sub( e, 3, string.len( e ) ) )
			local findpl = fusion.FindPlayerByData(id)
			local findpl2 = fusion.FindPlayerByData(id2)
			local findra = fusion.Ranks[id]
			if string.Left( e, 1 ) == "@" and string.len( e ) > 1 and findpl then			
				local ply = findpl		
				table.insert( sendtbl, team.GetColor( ply:Team() ) )			
				table.insert( sendtbl,  " " .. ply:Name() )
			
			elseif string.Left( e, 2 ) == "G@" and string.len( e ) > 2 and findpl2 then			
				local ply = findpl2
				globcolour = team.GetColor( ply:Team() )	
				table.insert( sendtbl, team.GetColor( ply:Team() ) )			
				table.insert( sendtbl,  " " .. ply:Name() )	
				
			elseif string.Left( e, 2 ) == "@:" and string.len( e ) > 2 and findpl2 then			
				local ply = findpl2
				table.insert( sendtbl, team.GetColor( ply:Team() ) )		
				table.insert( sendtbl,  " " .. ply:Name() )				
				table.insert( sendtbl, Color( 255, 255, 255, 255 ) )
				table.insert( sendtbl,  ":" )	
				
			elseif string.Left( e, 2 ) == "#:" and string.len( e ) > 2 then			
				table.insert( sendtbl, Color(255,200,0,255) )
				table.insert( sendtbl,  " " .. id2 )
				table.insert( sendtbl, Color(255, 255, 255, 255 ) )
				table.insert( sendtbl,  ":" )				
			elseif e == "@IDConsole" then			
				table.insert( sendtbl, Color(150,150,150,255) )
				table.insert( sendtbl,  " Console")			
			elseif e == "@:IDConsole" then			
				table.insert( sendtbl, Color(150,150,150,255) )
				table.insert( sendtbl,  " Console")				
				table.insert( sendtbl, Color( 255, 255, 255, 255 ) )
				table.insert( sendtbl,  ":" )
				
			elseif e == "@IDDisconnected" then			
				table.insert( sendtbl, Color(200, 200, 200, 255) )
				table.insert( sendtbl,  " Disconnected Players")
				
			elseif string.Left( e, 1 ) == ">" and string.len( e ) > 1 and team.GetName( tonumber(id) ) then			
				local rank = findra	
				table.insert( sendtbl, team.GetColor( tonumber(id) ) )
				table.insert( sendtbl,  " " .. team.GetName( tonumber(id) ) )	
			elseif string.Left( e, 1 ) == "{" and string.len( e ) > 1 and fusion.commands[id] then			
				table.insert( sendtbl, fusion.cl.GetColour(255) )
				table.insert( sendtbl, " " .. fusion.commands[id].Name )	
			
			elseif string.Left( e, 1 ) == "@" and string.len( e ) > 1 then
				table.insert( sendtbl, Color( 200, 200, 200, 255 ) )
				table.insert( sendtbl, " Disconnected Player" )	
				
			elseif string.Left( e, 1 ) == "#" and string.len( e ) > 1 then			
				table.insert( sendtbl, Color(255,200,0,255) )
				table.insert( sendtbl,  " " .. id )	
			elseif e == "," then			
				table.insert( sendtbl, globcolour or def or Color(255,255,255,255) )
				table.insert( sendtbl,  e )	
			else
				table.insert( sendtbl, globcolour or def or Color(255,255,255,255) )
				table.insert( sendtbl, " " .. e )
			end	
		end

		sendtbl[2] = string.Right( sendtbl[2], string.len( sendtbl[2] ) - 1 )
		chat.AddText( unpack( sendtbl ) )		
	
	end
end