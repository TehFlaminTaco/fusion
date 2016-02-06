--[[ 
	Modules:
		Utility Commands
	
	Description:
		A collection of utility commands.
 ]]
fusion.commands["rankhelp"] = {
	Name = "Rank Help",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Displays the rank upgrade window.",
	Function = function( ply, cmd, args )
		
		ply:SendLua("fusion.cl.ShowRankDialog()")	
	end	
}

fusion.commands["ctpmenu"] = {
	Name = "CTP Menu",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Displays the CTP (Thirdperson) Menu window.",
	Function = function( ply, cmd, args )
		
		ply:ConCommand("ctp_toggle_menu")
	end	
}

fusion.commands["ctp"] = {
	Name = "CTP Thirdperson",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Toggles CTP Thirdperson.",
	Function = function( ply, cmd, args )
		
		ply:ConCommand("ctp")
	end	
}


fusion.commands["help"] = {
	Name = "Command Help",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Prints a rank's command list.",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local arg1 = args[1]
		
		local rank = fusion.Ranks[arg1]
		if rank then			
			fusion.sv.PrintCommands( ply, arg1 )		
		else
			fusion.Message( ply, "Invalid or no rank entered, defaulting command list to your rank." )	
			fusion.sv.PrintCommands( ply, ply.Rank )	
		end
		fusion.Message( ply, "Check your console." )		
	end	
}

fusion.commands["shop"] = {
	Name = "Shop",	
	Hierarchy = 0,
	Category = "fusion shop",
	Args = 0,
	Help = "Opens/ closes the shop.",
	Function = function( ply, cmd, args )
		ply:SendLua("fusion.cl.openShop()")	
	end	
}

fusion.commands["health"] = {
	Name = "Set Health",	
	Hierarchy = 60,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's health.",
	Message = "%s set the health of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetHealth( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["armour"] = {
	Name = "Set Armour",	
	Hierarchy = 60,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's armour.",
	Message = "%s set the armour of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetArmor( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["speed"] = {
	Name = "Set Walk Speed",	
	Hierarchy = 40,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's walk speed.",
	Message = "%s set the walk speed of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetWalkSpeed( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["runspeed"] = {
	Name = "Set Runspeed",	
	Hierarchy = 40,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's run speed.",
	Message = "%s set the run speed of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetRunSpeed( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["god"] = {
	Name = "Enable Godmode",	
	Hierarchy = 60,
	Category = "utility",
	Args = 1,
	Help = "Enables godmode on a player.",
	Message = "%s enabled god mode on %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				-- v:GodEnable()
				v.Godded = true
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["ungod"] = {
	Name = "Disable Godmode",	
	Hierarchy = 60,
	Category = "utility",
	Args = 1,
	Help = "Disables godmode on a player.",
	Message = "%s disabled god mode on %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				-- v:GodDisable()
				v.Godded = false
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["selfgod"] = {
	Name = "Self God",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Toggle god mode on yourself.",
	//Message = "%s enabled god mode",
	Function = function( ply, cmd, args )
		local message = ""//fusion.commands[cmd].Message
				
		if ply.Godded then
			message = "%s disabled god mode"
			ply.Godded = false
			-- ply:GodDisable()
		else
		
			if (ply.SelfGodCooldown and CurTime() < ply.SelfGodCooldown) then
				fusion.Message(ply, "You cannot selfgod again for another " .. (math.Round((ply.SelfGodCooldown - CurTime()) * 100)/100) .. " seconds")
				return
			end
		
			message = "%s enabled god mode"
			ply.Godded = true
			-- ply:GodEnable()
		end
	
		local msg = string.format(message, fusion.PlayerMarkup( ply ) )
		fusion.CMDMessage( msg, ply, cmd )
	end	
}

-- fusion.commands["selfungod"] = {
	-- Name = "Self Ungod",	
	-- Hierarchy = 0,
	-- Category = "utility",
	-- Args = 0,
	-- Help = "Disable god mode on yourself.",
	-- Message = "%s disabled god mode",
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
		
		-- ply:GodDisable()
	
		-- local msg = string.format(message, fusion.PlayerMarkup( ply ) )
		-- fusion.CMDMessage( msg, ply, cmd )
	-- end	
-- }

fusion.commands["respawn"] = {
	Name = "Respawn",	
	Hierarchy = 10,
	Category = "utility",
	Args = 1,
	Help = "Respawns a player.",
	Message = "%s respawned %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				-- local oldpos = v:GetPos()
				-- local oldeyes = v:EyeAngles()
				-- v.Respawned
				
				-- v:Spawn()
				-- v:SetPos( oldpos )
				-- v:SetEyeAngles( oldeyes )
				
				fusion.sv.RespawnInPlace(v)
				
				-- fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["frags"] = {
	Name = "Set Frags",	
	Hierarchy = 60,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's frags/ kills.",
	Message = "%s set frags of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetFrags( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["deaths"] = {
	Name = "Set Deaths",	
	Hierarchy = 60,
	Category = "utility",
	Args = 2,
	Help = "Sets a player's deaths.",
	Message = "%s set deaths of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local arg1 = tonumber( args[2] )
		
		if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:SetDeaths( arg1 )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["spectate"] = {
	Name = "Spectate",	
	Hierarchy = 50,
	Category = "utility",
	Args = 1,
	Help = "Spectates a player.",
	NotSelf = true,
	Ignore = true,
	Hidden = true,
	Message = "%s is now spectating %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			-- for k,v in pairs( players ) do
			local v = players[1]
			
			if (#players > 1) then
				fusion.Message(ply, "You cannot spectate multiple players!")
				return false
			end
			
			if v and v:IsValid() then
				ply.SavedPos = ply:GetPos()
				ply.SavedAng = ply:EyeAngles()
				ply.SavedMoveType = ply:GetMoveType()
				
				-- ply:SetPos(v:GetPos())
				
				-- ply:SetRenderMode( RENDERMODE_NONE )
				-- ply:SetColor( Color( 255, 255, 255, 0 ) )
				ply:StripWeapons()
				
				ply:Spectate(OBS_MODE_CHASE)
				ply:SpectateEntity(v)	
				ply:SetMoveType( MOVETYPE_OBSERVER )		

				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["unspectate"] = {
	Name = "Stop Spectating",	
	Hierarchy = 50,
	Category = "utility",
	Args = 0,
	Help = "Stops spectating a player.",
	Hidden = true,
	Message = "%s has stopped spectating.",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		ply:UnSpectate( )
		fusion.sv.RespawnInPlace(ply)
		
		ply:SetPos( ply.SavedPos )
		ply:SetEyeAngles( ply.SavedAng )
		ply:SetMoveType(ply.SavedMoveType)
		
		-- ply:SetRenderMode( RENDERMODE_NORMAL )
		-- ply:SetColor( Color( 255, 255, 255, 255 ) )
		-- if fusion.sh.TableHasData( UniqueIDs ) then		
			-- local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ) )
			fusion.CMDMessage( msg, ply, cmd )			
		-- end	
	end	
}

-- fusion.commands["ghost"] = {
	-- Name = "Ghost",	
	-- Hierarchy = 60,
	-- Category = "utility",
	-- Args = 2,
	-- Hidden = true,
	-- Help = "Ghosts a player.",
	-- Message = "%s set deaths of %s to #{%s}#",
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
		-- local name = args[1]
		-- local arg1 = tonumber( args[2] )
		
		-- if !arg1 or arg1 < 0 then fusion.Message( ply, "Amount must be numeric and greater than 0" ) return false end
		
		-- local UniqueIDs = {}
		-- local players = fusion.sv.GetPlayers( ply, cmd, name )
		-- if players then
			-- for k,v in pairs( players ) do
				-- v:SetDeaths( arg1 )
				-- table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			-- end
		-- end

		-- if fusion.sh.TableHasData( UniqueIDs ) then		
			-- local tarstring = string.Implode( ", ", UniqueIDs )
			-- local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			-- fusion.CMDMessage( msg, ply, cmd )			
		-- end	
	-- end	
-- }

