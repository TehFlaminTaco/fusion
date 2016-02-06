--[[ 
	Modules:
		Teleportation Commands
	
	Description:
		A collection of teleportation commands.
 ]]

function fusion.sv.RespawnInPlace(v)
	v:UnLock()
	v:GodDisable()
	
	v.Respawned = true
	
	local oldpos = v:GetPos()
	local oldeyes = v:EyeAngles()
	v:Spawn()
	v:SetPos( oldpos )
	v:SetEyeAngles( oldeyes )
	

	fusion.sv.SetTeam( v, v.Sudo or v.Rank )
end
 
function fusion.sv.GetMoveAimPos(ply) 
	local size = Vector( 32, 32, 72 )
			
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = ply:GetShootPos() + ply:GetAimVector() * 100000000
	tr.filter = ply
	local trace = util.TraceEntity( tr, ply )
	
	local EyeTrace = ply:GetEyeTraceNoCursor()
	if (trace.HitPos:Distance(EyeTrace.HitPos) > size:Length()) then
		trace = EyeTrace
		trace.HitPos = trace.HitPos + trace.HitNormal * (size)
	end
	
	return trace.HitPos
end
 
fusion.commands["telejail"] = {
	Name = "Teleport Jail",	
	Hierarchy = 60,
	Category = "punishment",
	Condition = function(ply, v) return !v.Jailed end,
	Args = 1,
	Help = "Teleports a player to your aim position and jails them.",
	Message = "%s tele-jailed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			
			local aimpos = fusion.sv.GetMoveAimPos(ply)
			
			for k,v in pairs( players ) do						

				local tp_pos = aimpos
				
				//fusion.sv.TeleportEffect( v, tp_pos )
				v:ExitVehicle()
				v:SetPos(tp_pos)
				
				v.Jailed = true
				v.JailPos = tp_pos				
				
				local jail_controller = ents.Create( "jail" )
				jail_controller:SetPos( v:LocalToWorld( v:OBBCenter() ) )
				jail_controller.Player = v
				jail_controller:Spawn()
				
				fusion.sv.RespawnInPlace(v)	
				-- fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				
				v:SetMoveType( MOVETYPE_WALK )		
				-- v:GodEnable()
				v:StripWeapons()
			
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )

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

fusion.commands["telejail2"] = {
	Name = "Teleport Jail 2",	
	Hierarchy = 60,
	Category = "punishment",
	Condition = function(ply, v) return !v.Jailed end,
	Args = 1,
	Help = "Teleports a player to your aim position and jails them.",
	Message = "%s tele-jailed %s",	
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local aimpos = fusion.sv.GetMoveAimPos(ply)
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				local tp_pos = aimpos
				fusion.sv.TeleportEffect( v, tp_pos )
				v:ExitVehicle()
				v:SetPos( tp_pos )
				
				v.Jailed = true
				v.JailPos = tp_pos				
				
				local jail_controller = ents.Create( "jail" )
				jail_controller:SetPos( tp_pos)
				jail_controller.Player = v				
				jail_controller.Big = true
				jail_controller:Spawn()
				
				fusion.sv.RespawnInPlace(v)	
				-- fusion.sv.SetTeam( v, v.Sudo or v.Rank )
				
				v:SetMoveType( MOVETYPE_WALK )		
				-- v:GodEnable()
				v:StripWeapons()
			
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
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

-- hook.Add("SetupPlayerVisibility", "hookVis", function(ply, ent)

	-- if ent:GetClass() == "hook" then
		-- AddOriginToPVS( ent:GetPos() )
	-- end

-- end)



fusion.commands["teleport"] = {
	Name = "Teleport",	
	Hierarchy = 20,
	Category = "utility",
	Args = 1,
	Help = "Teleports a player to your aim position.",
	Message = "%s teleported %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]

		-- if (ply.Jailed) then
			-- fusion.Message( ply, "You cannot teleport while jailed!" )
			-- return
		-- end
		
		local aimpos = fusion.sv.GetMoveAimPos(ply)
		local angles = nil
		
		local x,y,z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
		
		if x and y and z then
			aimpos = Vector(x,y,z)
			
			
			local p,y,r = tonumber(args[5]), tonumber(args[6]), tonumber(args[7])		
			if p and y and r then
				angles = Angle(p,y,r)
			end
		end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				local tp_pos = aimpos
				fusion.sv.TeleportEffect( v, tp_pos )
				
				if (angles) then
					v:SetEyeAngles(angles)
				end
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			if tarstring != ( fusion.PlayerMarkup( ply ) ) then
				local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				fusion.CMDMessage( msg, ply, cmd )			
			end	
		end	
	end	
}



fusion.commands["teleport2"] = {
	Name = "Teleport 2",	
	Hierarchy = 20,
	Category = "utility",
	Args = 1,
	Help = "Teleports a player to your aim position and zeroes their velocity.",
	Message = "%s teleported %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]		
				
		local aimpos = fusion.sv.GetMoveAimPos(ply)
		local angles = nil
		
		local x,y,z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
		
		if x and y and z then
			aimpos = Vector(x,y,z)
			
			
			local p,y,r = tonumber(args[5]), tonumber(args[6]), tonumber(args[7])		
			if p and y and r then
				angles = Angle(p,y,r)
			end
		end
		
		
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				local tp_pos = aimpos
				fusion.sv.TeleportEffect( v, tp_pos )
				
				if (angles) then
					v:SetEyeAngles(angles)
				end
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			if tarstring != ( fusion.PlayerMarkup( ply ) ) then
				local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				fusion.CMDMessage( msg, ply, cmd )			
			end	
		end	
	end	
}

fusion.commands["tp"] = fusion.commands["teleport"]
fusion.commands["tp2"] = fusion.commands["teleport2"]

fusion.commands["goto"] = {
	Name = "Goto",	
	Hierarchy = 20,
	Category = "utility",
	Args = 1,
	Help = "Teleports you to a player's position.",
	NotSelf = true,
	Ignore = true,
	Message = "%s went to %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		if (ply.Jailed) then
			fusion.Message( ply, "You cannot teleport while jailed!" )
			return
		end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players and IsValid( players[1] ) then
			for k,v in pairs( players ) do
			-- local v = players[1]	
	
				-- ply:ExitVehicle()
				local tp_pos = v:GetPos()
				fusion.sv.TeleportEffect( ply, tp_pos )
				-- 
				-- ply:SetPos( tp_pos )
				-- fusion.sv.TeleportEffect( ply )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )			
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			-- if tarstring != ply:UniqueID() then
				local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				fusion.CMDMessage( msg, ply, cmd )			
			-- end	
		end	
	end	
}

fusion.commands["bring"] = {
	Name = "Bring",	
	Hierarchy = 60,
	Category = "utility",
	Args = 1,
	Help = "Teleports a player to your position.",
	NotSelf = true,
	Message = "%s brought %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		if (ply.Jailed) then
			fusion.Message( ply, "You cannot teleport while jailed!" )
			return
		end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players and IsValid( players[1] ) then
			for k,v in pairs( players ) do
				local tp_pos = ply:GetPos()
				fusion.sv.TeleportEffect( v, tp_pos )
				-- v:ExitVehicle()
				-- v:SetPos( tp_pos )
				-- fusion.sv.TeleportEffect( v )
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )			
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			-- if tarstring != ply:UniqueID() then
				local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				fusion.CMDMessage( msg, ply, cmd )			
			-- end	
		end	
	end	
}

if SERVER then

	function fusion.sv.TeleportEffect( ply, destination )
		
		local pos = ply:GetPos()	
		
		
		ply:ExitVehicle()
		
		local effectdata = EffectData()
		effectdata:SetEntity( ply )
		effectdata:SetOrigin( destination )
		effectdata:SetStart(destination - ply:GetPos())
		effectdata:SetMagnitude((destination - ply:GetPos()):Length() )
		util.Effect( "teleport", effectdata, true, true )
		
		-- local StartPos 	= ply:LocalToWorld(ply:OBBCenter())
		-- local dist = StartPos:Distance(destination)
	
		local LifeTime = 0//dist * 0.00005
		
		-- timer.Simple(0.1, function()
			
			ply:SetPos( destination )
		-- end)
		-- end)
		
		-- local effectdata = EffectData()
		-- effectdata:SetStart( pos )
		-- effectdata:SetOrigin( pos )
		-- effectdata:SetScale( 1 )
		-- effectdata:SetEntity( ply )
		-- util.Effect( "teleport", effectdata, true, true )
		
		-- ply:SetColor( 255, 255, 255, 0 )
		-- timer.Simple( 0.5, function()		
			-- if IsValid( ply ) then
				-- DoPropSpawnedEffect( ply )
				-- ply:SetColor( 255, 255, 255, 255 )
			-- end		
		-- end )	
		
		-- DoPropSpawnedEffect( ply )
		
		-- local weapon = ply:GetActiveWeapon()
		-- if IsValid( weapon ) then
			-- local pos = weapon:GetPos()
			-- local effectdata = EffectData()
			-- effectdata:SetStart( pos )
			-- effectdata:SetOrigin( pos )
			-- effectdata:SetScale( 1 )
			-- effectdata:SetEntity( weapon )
			-- util.Effect( "entity_remove", effectdata, true, true )
		-- end	
	end

end