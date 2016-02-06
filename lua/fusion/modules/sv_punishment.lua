--[[ 
	Modules:
		Punishment Commands
	
	Description:
		A collection of punishment commands.
 ]]

fusion.commands["slay"] = {
	Name = "Slay",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Kills a player.",
	Message = "%s slayed %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:Kill()
				v:UnLock()
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

fusion.commands["explode"] = {
	Name = "Explode",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Explodes a player.",
	Message = "%s exploded %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				
				local explode = ents.Create( "env_explosion" )
				explode:SetPos( v:GetPos() )
				explode:SetOwner( ply )
				explode:Spawn()
				explode:SetKeyValue( "iMagnitude", "220" )
				explode:Fire( "Explode", 0, 0 )

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

fusion.commands["rocket"] = {
	Name = "Rocket",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Rockets a player.",
	Message = "%s rocketed %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				
				v.Rocketed = true
				
				v.Trail = ents.Create("env_fire_trail")
				if !v.Trail then return end
				v.Trail:SetKeyValue("spawnrate","3")
				v.Trail:SetKeyValue("firesprite","sprites/firetrail.spr" )
				v.Trail:SetPos(v:GetPos())
				v.Trail:SetParent(v)
				v.Trail:Spawn()
				v.Trail:Activate()
						
				v:ExitVehicle()
				v:SetMoveType(MOVETYPE_WALK)
				v:SetHealth(100)
				-- v:GodDisable(true)
				v.Godded = false
				
				v:SetVelocity(v:GetUp() * 3000 + VectorRand() * 500)
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
					
				timer.Simple(3, function()
				
					if (v:IsValid()) then
					
						v.Trail:Remove()
					
						local explode = ents.Create( "env_explosion" )
						explode:SetPos( v:GetPos() )
						explode:SetOwner( ply )
						explode:Spawn()
						explode:SetKeyValue( "iMagnitude", "500" )
						explode:Fire( "Explode", 0, 0 )
						v.Rocketed = false
					end
				
				end)

				
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["slap"] = {
	Name = "Slap",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Slaps a player with optional damage (default: 0 damage).",
	Message = "%s slapped %s with %s damage",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local optional = false
		
		if args[2] then optional = tonumber( args[2] ) end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				local rvec = VectorRand() * math.random( 100, 200 )
				-- rvec.z = math.random( 300, 600 )
				v:SetVelocity( Vector( rvec.x, rvec.y, math.random( 300, 600 ) ) )
				
				if optional then
					v:TakeDamage( optional )
				end
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, optional or 0 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

-- fusion.commands["startcagefight"] = {
	-- Name = "Start Cage Fight",
	-- Hierarchy = 90,
	-- Category = "punishment",
	-- Args = 0,
	-- Help = "Spawns the cage that players can fight in.",
	-- Message = "%s started the cage fight.",	
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
	
		-- local jail_controller = ents.Create( "jail_big" )
		-- jail_controller:SetPos( ply:GetEyeTrace().HitPos + Vector( 0, 0, ( 189.862854 / 2 ) ) )
		-- jail_controller:Spawn()
		
		-- fusion.Prison = jail_controller
	
		-- local msg = string.format( message, fusion.PlayerMarkup( ply ) )
		
		-- fusion.CMDMessage( msg, ply, cmd )
	
	-- end
-- }

-- fusion.commands["endcagefight"] = {
	-- Name = "Remove Prison",
	-- Hierarchy = 90,
	-- Category = "punishment",
	-- Args = 0,
	-- Help = "Remove the cage.",
	-- Message = "%s ended the cage fight.",	
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
	
		-- fusion.Prison = nil
	
		-- local msg = string.format( message, fusion.PlayerMarkup( ply ) )
		
		-- fusion.CMDMessage( msg, ply, cmd )
		
		
		
		-- local highest = 0
		-- local winner
	
		-- for k,v in pairs(player.GetAll()) do
			-- if v.Caged then
				-- if v.CageKillCount and v.CageKillCount > highest then
					-- highest = v.CageKillCount
					-- winner = v
				-- end
			-- end
		-- end		
		
		-- if IsValid(winner) then
			-- fusion.GlobalMessage(fusion.PlayerMarkup( winner ) .. " is the winner of the cage fight, with " .. winner.CageKillCount .. " kills.")
		-- end
		
		-- for k,v in pairs(player.GetAll()) do
			-- if v.Caged then
				-- v.Caged = false
				-- v.Jailed = false
				-- v.CageKillCount = false
				-- v:Spawn()
				
				-- fusion.sv.SetTeam( v, v.Sudo or v.Rank )
			-- end
		-- end	
	
	-- end
-- }

fusion.commands["jail"] = {
	Name = "Jail",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Condition = function(ply, v) return !v.Jailed end,
	Help = "Locks a player in a cage, stopping them from doing anything.",
	Message = "%s jailed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			
				v:ExitVehicle()		
			
				v.Jailed = true
				v.JailPos = v:GetPos()				
				
				local jail_controller = ents.Create( "jail" )
				jail_controller:SetPos( v:LocalToWorld( v:OBBCenter() ) )
				jail_controller.Player = v
				jail_controller:Spawn()

				fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				-- fusion.sv.RespawnInPlace(v)
				
				v:SetMoveType( MOVETYPE_WALK )		
				-- v:GodEnable()
				v:StripWeapons()				
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			
			if time then
				msg = msg .. " for #{" .. time .. "}# seconds"
			end
			
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["jail2"] = {
	Name = "Jail 2",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Condition = function(ply, v) return !v.Jailed end,
	Help = "Locks a player in a cage, stopping them from doing anything.",
	Message = "%s jailed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			
				v:ExitVehicle()		
			
				v.Jailed = true
				v.JailPos = v:GetPos()				
				
				local jail_controller = ents.Create( "jail" )
				jail_controller:SetPos( v:LocalToWorld( v:OBBCenter() ) )
				jail_controller.Player = v
				jail_controller.Big = true
				jail_controller:Spawn()

				fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				fusion.sv.RespawnInPlace(v)
				
				v:SetMoveType( MOVETYPE_WALK )		
				-- v:GodEnable()
				v:StripWeapons()				
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			
			if time then
				msg = msg .. " for #{" .. time .. "}# seconds"
			end
			
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

-- function fusion.sv.checkWasCageDeath(victim, i, killer)
	
	-- if killer.Caged and IsValid( fusion.Prison ) and victim.Caged then
		-- local highest = 0
	
		-- for k,v in pairs(player.GetAll()) do
			-- if v.Caged then
				-- if v.CageKillCount and v.CageKillCount > highest then
					-- highest = v.CageKillCount
				-- end
			-- end
		-- end		
	
		-- killer.CageKillCount = (killer.CageKillCount or 0) + 1
		
		-- if killer.CageKillCount > highest then
			-- fusion.GlobalMessage(fusion.PlayerMarkup( killer ) .. " is now in the lead of the cage fight, on " .. killer.CageKillCount .. " kills.")
		-- end
	
	-- end

-- end


-- hook.Add("PlayerShouldTakeDamage", "cageDamage", function(victim, killer)

	-- if ((killer.Caged and !victim.Caged) or (!killer.Caged and victim.Caged)) and IsValid( fusion.Prison ) then
		-- return false
	-- end

-- end)

-- fusion.commands["cage"] = {
	-- Name = "Cage",	
	-- Hierarchy = 60,
	-- Category = "punishment",
	-- Args = 1,
	-- Help = "Adds a player to the cage fight.",
	-- Message = "%s added %s to the cage fight",	
	-- Function = function( ply, cmd, args )
		-- local message = fusion.commands[cmd].Message
		-- local name = args[1]
		
		-- local UniqueIDs = {}
		-- local players = fusion.sv.GetPlayers( ply, cmd, name )
		
		-- if IsValid( fusion.Prison ) then
		
			-- if players then
				-- for k,v in pairs( players ) do
					-- v.Jailed = true
					-- v.Caged = true
					
					-- v:Spawn()
					-- v:SetPos( fusion.Prison:GetPos() - Vector( 0, 0, ( 189.862854 / 2 ) - 15 ) )					
					-- v:SetMoveType( MOVETYPE_WALK )					

					-- table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
				-- end
			-- end

			-- if fusion.sh.TableHasData( UniqueIDs ) then		
				-- local tarstring = string.Implode( ", ", UniqueIDs )
				-- local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )				
				
				-- fusion.CMDMessage( msg, ply, cmd )			
			-- end	
		-- else
			-- fusion.Message(ply, "No cage has been spawned.")
		-- end
	-- end	
-- }


fusion.commands["unjail"] = {
	Name = "Unjail",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Condition = function(ply, v) return v.Jailed end,
	Help = "Frees a player from their jail.",
	Message = "%s unjailed %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do		
				-- if v.Jailed then
					v.Jailed = nil
					v.JailPos = nil

					v:UnLock()
					-- v:GodDisable()
					v.Godded = false
					
					local oldpos = v:GetPos()
					local oldeyes = v:EyeAngles()
					-- fusion.sv.RespawnInPlace(v)
					v:SetPos( oldpos )
					v:SetEyeAngles( oldeyes )
				
					fusion.sv.SetTeam( v, v.Sudo or v.Rank )
					
					-- if IsValid( fusion.Prison ) then
						-- v:Spawn()
					-- end
				
					table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
				-- end
				
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["nerf"] = {
	Name = "Nerf",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Condition = function(ply, v) return !v.Nerfed end,
	Help = "Strips a player and prevents them from spawning or noclipping.",
	Message = "%s nerfed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )			
				v:ExitVehicle()
				
				fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				-- fusion.sv.RespawnInPlace(v)				
				v:SetMoveType( MOVETYPE_WALK )
				v:StripWeapons()

				v.Nerfed = true
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			
			if time then
				msg = msg .. " for #{" .. time .. "}# seconds"
			end
			
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["unnerf"] = {
	Name = "Unnerf",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Condition = function(ply, v) return v.Nerfed end,
	Help = "Makes a player normal again.",
	Message = "%s unnerfed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )		
				v.Nerfed = false
				
				fusion.sv.SetTeam( v, v.Sudo or v.Rank )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			
			if time then
				msg = msg .. " for #{" .. time .. "}# seconds"
			end
			
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

function fusion.CheckJailed( ply )
	if ply.Jailed or ply.Rocketed or ply.Nerfed then
		return false
	end
end

hook.Add( "PlayerNoClip", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnObject", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnObject", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnSENT", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnSWEP", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerGiveSWEP", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnNPC", "JailCheck", fusion.CheckJailed )
hook.Add( "PlayerSpawnVehicle", "JailCheck", fusion.CheckJailed )
hook.Add( "CanTool", "JailCheck", fusion.CheckJailed )
hook.Add( "CanPlayerEnterVehicle", "JailCheck", fusion.CheckJailed )

fusion.commands["ignite"] = {
	Name = "Ignite",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Ignites a player for an optional amount of time (default: 60 seconds).",
	Message = "%s ignited %s for %s seconds",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local optional = false
		
		if args[2] then optional = tonumber( args[2] ) end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do

				if optional then
					v:Ignite( optional )
				else
					v:Ignite( 60 )
				end
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, optional or 60 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["extinguish"] = {
	Name = "Extinguish",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Extinguishes the fire on a player (<all> extinguishes everything).",
	Message = "%s extinguished %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		if name == "<all>" then			
			for k,v in pairs( ents.GetAll() ) do
				v:Extinguish()
			end	
			fusion.CMDMessage( fusion.PlayerMarkup( ply ) " extinguished everything", ply, cmd )	
			
			return
		end	
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:Extinguish( )				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["freeze"] = {
	Name = "Freeze",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Freeze a player in place.",
	Message = "%s froze %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]		
				
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:Lock( )				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["unfreeze"] = {
	Name = "Unfreeze",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Message = "%s unfroze %s",
	Help = "Unfreezes a player.",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]		
				
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:UnLock( )				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["strip"] = {
	Name = "Strip",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Message = "%s stripped %s",
	Help = "Strips a player's weapons.",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]		
				
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v:StripWeapons( )
				v:StripAmmo( )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}