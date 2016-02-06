--[[ 
	Modules:
		Titles
	
	Description:
		Functions and commands related to titles.
 ]]

fusion.commands["settitle"] = {
	Name = "Set Title",	
	Hierarchy = 70,
	Category = "messages",
	Args = 2,
	Help = "Sets a player's title.",
	Message = "%s set the title of %s to '%s'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		
		local name = args[1]
		local text = table.concat( args, " ", 2 )
		
		if text == "clear" then
			message = "%s cleared the title of %s"
		end
		
		local max = 100
		
		if string.len( text ) > max then
			fusion.Message( ply, "A title cannot be longer than "..max.." characters" )	
			return
		end
		
		-- if string.find( text, "[^s]" ) then
			-- fusion.Message( ply, "A title can only contain alpha-numeric characters" )	
			-- return		
		-- end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				fusion.sv.SetTitle( v, text )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, text )
			fusion.CMDMessage( msg, ply, cmd )			
		end
	end	
}

fusion.commands["mytitle"] = {
	Name = "My Title",	
	Hierarchy = 0,
	Category = "messages",
	Args = 0,
	Help = "Displays your title.",
	Message = "Your title is set to '%s'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message		
		if ply.fTitle then
			fusion.Message( ply, "Your title is: " .. ply.fTitle )			
		else
			fusion.Message( ply, "You do not have a title" )
		end		
	end	
}

if SERVER then

	function fusion.sv.SetTitle( ply, title )
	
		if title == "clear" then			
			ply.fTitle = "clear"
			fusion.sv.RemoveData( ply, "title" )
		else
			fusion.sv.SetData( ply, "title", title )			
			ply.fTitle = title
		end	
			
		fusion.sv.SendTitle( ply )		
	
	end
	
	function fusion.sv.SendTitle( ply )
		
		local title = ply.fTitle
		
		if title then
			umsg.Start( "fusion_title" )
			umsg.Entity( ply )
			umsg.String( title )
			umsg.End()
		end
	end
	

	-- hook.Add("PlayerInitialSpawn", "fusion_GetTitle", function( ply )
	
		-- fusion.sv.ReturnData( ply, "title", 
		-- function( ply, var, dat )		
			-- ply.fTitle = dat
			-- timer.Simple( 1, function()
				-- if IsValid( ply ) then
					-- fusion.sv.SendTitle( ply )
				-- end
			-- end )
		-- end, 
		-- function( ply, var, err )		
		-- end )
	
	-- end )

else

	usermessage.Hook( "fusion_title", function( dat )
	
		local ply = dat:ReadEntity()
		local title = dat:ReadString()
		
		if IsValid( ply ) then		
			
			if title == "clear" then			
				title = nil
			end
			
			ply.fTitle = title
		
		end
	
	end )

end