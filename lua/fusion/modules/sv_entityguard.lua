--[[ 
	Modules:
		Entity Guard
	
	Description:
		An in-built prop protection modifcation for Fusion Admin Mod.
 ]]
 
fusion.EntityGuard = {}

fusion.EntityGuard.HitNormalTools = {
	"wire_winch",
	"wire_hydraulic",
	"slider",
	"hydraulic",
	"winch",
	"muscle",
	"rope"
}

fusion.EntityGuard.DangerTools = {
	"remover",
	"duplicator",
	"adv_duplicator"
}

fusion.commands["superfreeze"] = {
	Name = "Super Freeze",	
	Hierarchy = 60,
	Category = "entityguard",
	Args = 0,
	Help = "Freezes all physics entities on the map.",
	Message = "%s froze everything!",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		
		local phys
		for k,v in pairs( ents.GetAll() ) do
			phys = v:GetPhysicsObject()
			if phys and phys:IsValid() then
				v:GetPhysicsObject():EnableMotion(false)
			end
		end

		local msg = string.format( message, fusion.PlayerMarkup( ply ))
		fusion.CMDMessage( msg, ply, cmd )
	end	
}

fusion.commands["freezeprops"] = {
	Name = "Freeze Props",	
	Hierarchy = 60,
	Category = "entityguard",
	Args = 1,
	Help = "Freezes all of a player's props.",
	Message = "%s froze the entities of %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
				
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				-- fusion.EntityGuard.Cleanup( v )
				
				-- for k,v in pairs
				fusion.EntityGuard.FreezeProps( v )
				
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

fusion.commands["cleanup"] = {
	Name = "Cleanup",	
	Hierarchy = 60,
	Category = "entityguard",
	Args = 1,
	Help = "Removes all of a player's props.",
	Message = "%s removed the entities of %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		if name == "<dc>" then	
			fusion.EntityGuard.CleanupDisconnected( )
			table.insert( UniqueIDs, "|pl|IDDisconnected|/pl|" )
		else				
			local players = fusion.sv.GetPlayers( ply, cmd, name )
			if players then
				for k,v in pairs( players ) do
					fusion.EntityGuard.Cleanup( v )
					table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
				end
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["addbuddy"] = {
	Name = "Add Buddy",	
	Hierarchy = 0,
	Category = "entityguard",
	Args = 1,
	NotSelf = true,
	Help = "Add a buddy, a player that can touch your props.",
	Ignore = true,
	Message = "You added %s to your buddy list",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local add = {}			
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				if !table.HasValue( ply.EG_Buddies, v:UniqueID() ) then
					table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
					table.insert( ply.EG_Buddies, v:UniqueID() )					
				end
			end
		end
		
		net.Start("EG_Buddies")
		net.WriteTable(ply.EG_Buddies)		
		net.Send(ply)
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, tarstring )
			fusion.Message( ply, msg )			
		end	
	end	
}

fusion.commands["removebuddy"] = {
	Name = "Remove Buddy",	
	Hierarchy = 0,
	Category = "entityguard",
	Args = 1,
	NotSelf = true,
	Help = "Removes a buddy.",
	Ignore = true,
	Message = "You removed %s from your buddy list",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		local buddies = ply.EG_Buddies
		local NoBuddies = true
		if players then
			if buddies and fusion.sh.TableHasData( buddies ) then
				for k,v in pairs( ply.EG_Buddies ) do					
					if player.GetByUniqueID( v ) and table.HasValue( players, player.GetByUniqueID( v ) ) then
						table.insert( UniqueIDs, fusion.PlayerMarkup( player.GetByUniqueID( v ) ) )
						table.remove( ply.EG_Buddies, k )
						NoBuddies = false
					end
				end	
				
				if NoBuddies then
					fusion.Message( ply, "Specified player(s) are not in your buddy list" )	
					return
				else			
					net.Start("EG_Buddies")
					net.WriteTable(ply.EG_Buddies)		
					net.Send(ply)
				end	
			else
				fusion.Message( ply, "You have no buddies" )	
				return
			end	
		end			
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, tarstring )
			fusion.Message( ply, msg )			
		end	
	end	
}

fusion.commands["cleanupall"] = {
	Name = "Cleanup All",	
	Hierarchy = 80,
	Category = "entityguard",
	Args = 0,
	Help = "Returns the map to how it was when it loaded (removes everything).",
	Message = "%s cleaned the map",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message	
		
		fusion.EntityGuard.CleanupMap( )
		
		local msg = string.format( message, fusion.PlayerMarkup( ply ) )
		fusion.CMDMessage( msg, ply, cmd )
	end	
}

fusion.commands["cleardecals"] = {
	Name = "Clear Decals",	
	Hierarchy = 60,
	Category = "entityguard",
	Args = 0,
	Help = "Removes all decals from the map.",
	Message = "%s cleared all decals",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message	
		
		for k,v in pairs( player.GetAll() ) do
			v:ConCommand( "r_cleardecals" )
		end	
				
		local msg = string.format( message, fusion.PlayerMarkup( ply ) )
		fusion.CMDMessage( msg, ply, cmd )
	end	
}

concommand.Add( "eg_GetOwner", function( ply, cmd, args )
	local id = tonumber( args[1] )	
	local ent = Entity( id )
	
	if IsValid( ent ) then 
		local owner = "World"		
		if fusion.GetOwnerID(ent) then		
			owner = fusion.GetOwnerID(ent)
		end
		
		net.Start("eg_GetOwner")
		net.WriteString( owner )
		-- net.WriteBool( ent.Unprotected)
		net.Send(ply)
	end
end )

if !AddCleanUp then
	AddCleanUp = AddCleanUp or cleanup.Add
end

function fusion.EntityGuard.SetOwner(ent, ply)
	ent.Owner = ply
	ent.OwnerID = ply:UniqueID()		
end

function cleanup.Add( ply, Type, ent )	
	if ent and ent:IsValid() then		
		ent.Owner = ply
		ent.OwnerID = ply:UniqueID()	
		if ent.GetModel and ent:GetModel() then			
			local msg = "(" .. ply:SteamID() .. ") spawned " .. ent:GetClass() .. " with model '" .. ent:GetModel() .. "'"
			fusion.sv.LogMessage( ply, msg )
		end		
	end
	
	AddCleanUp( ply, Type, ent )	
end	

local function CheckTool_Nail( ply, t, v )
			
	local nail = {}
	nail.start = t.HitPos
	nail.endpos = t.HitPos + ( v * 16 )
	nail.filter = { t.Entity }
	local nailRes = util.TraceLine( nail )
	if nailRes.Hit and nailRes.Entity:IsValid() and !nailRes.Entity:IsPlayer() then
		if !fusion.EntityGuard.CanTouch( ply, nailRes.Entity ) then			
			return nailRes.Entity
		end
	end
	
	return false

end

local function CheckTool_HitNormals( ply, t )
	
	if ply:KeyDown( IN_ATTACK2 ) then
	
		local hitnorm = {}
		hitnorm.start = t.HitPos
		hitnorm.endpos = t.HitPos + ( t.HitNormal * ( 16384 * 2 ) )
		hitnorm.filter = { t.Entity }
		local hitnormRes = util.TraceLine( hitnorm )
		
		if hitnormRes.HitSky or hitnormRes.HitWorld then			
			return "World"
		end
		
		if hitnormRes.Hit and hitnormRes.Entity:IsValid() and !hitnormRes.Entity:IsPlayer() then
			if !fusion.EntityGuard.CanTouch( ply, hitnormRes.Entity ) then			
				return hitnormRes.Entity
			end
		end
		
	end
	
	return false

end

local function protected_ToolCheck( ply, trace, tool )

	local ent = trace.Entity

	local hitNormTool = table.HasValue( fusion.EntityGuard.HitNormalTools, tool )
	
	if hitNormTool and ( trace.HitSky or trace.HitWorld ) then		
		return false
	end	
	
	-- if ent:IsPlayer() then 
		-- return false
	-- end
	
	if IsValid( ent ) then
		-- local runCheck = ent.OwnerID and ent != GetWorldEntity()

		-- if runCheck then
		
			if !fusion.EntityGuard.CanTouch( ply, ent ) then
				local id = fusion.GetOwnerID(ent) or "protected"
				if id then
					fusion.EntityGuard.Message( ply, id, "You cannot use " .. tool .. " on this entity." )
				end
				return false
			end					
			
			if tool == "nail" then				
				local nailHit = CheckTool_Nail( ply, trace, ply:GetAimVector() )
				if nailHit then
					local id = fusion.GetOwnerID(nailHit) or "protected"
					if id then
						fusion.EntityGuard.Message( ply, id, "You cannot use " .. tool .. " on this entity." )
					end
					return false
				end	
			
			elseif hitNormTool then			
							
				local hitnorm = CheckTool_HitNormals( ply, trace )
				
				if hitnorm == "World" then
					return false
				elseif hitnorm and IsValid( hitnorm ) then					
					local id = fusion.GetOwnerID(hitnorm) or "protected"
					if id then
						fusion.EntityGuard.Message( ply, id, "You cannot use " .. tool .. " on this entity." )
					end
					return false
				end
			end
			
		-- end
	-- else
		-- return false
	end
	
	-- local msg = ply:Name() ..  "<" .. ply:SteamID() .. "> used '" .. tool .. "'."
	-- fusion.sv.LogMessage( msg )
	
	return true

end

hook.Add( "CanTool", "EntityGuard_Tools", function( ply, trace, tool )	
	if !ply then return false end
	if !trace then return false end
	if !tool then return false end
	
	if trace.Entity and trace.Entity:IsValid() and !fusion.EntityGuard.CanTouch( ply, trace.Entity ) then
		return false
	end
	
	-- if tool == "duplicator" then return false end
	
	if !protected_ToolCheck( ply, trace, tool ) then return false end
	
	-- local ent = trace.Entity
	-- local msg = "(" .. ply:SteamID() .. ") used tool " .. tool
	-- if ent and ent:IsValid() then
		-- msg = msg .. " on entity '" .. tostring(ent) .. "' with model '" .. ent:GetModel() .. "'"
	-- end
	
	-- fusion.sv.LogMessage( ply, msg )
end )

function fusion.ModelRestriction( ply, mdl )

	local f = "fusion/restricted.txt"
	if file.Exists(f, "DATA") then
		local r = file.Read( f, "DATA" )
		local t = string.Explode( "\n", r )
		
		if table.HasValue( t, mdl ) then
			fusion.Message( ply, "#{" .. mdl .. "}# is restricted" )
			return false
		end	
	end	

end

hook.Add( "PlayerSpawnProp", "fusion_ModelRestriction", fusion.ModelRestriction )
hook.Add( "PlayerSpawnEffect", "fusion_ModelRestriction", fusion.ModelRestriction )
hook.Add( "PlayerSpawnRagdoll", "fusion_ModelRestriction", fusion.ModelRestriction )

function fusion.EntityGuard.Message( ply, owner, msg )	
	net.Start("EntityGuard")
		net.WriteString( msg )
		net.WriteString( owner )
	net.Send(ply)
	
	net.Start("eg_GetOwner")
		net.WriteString( owner )
	net.Send(ply)
end

function fusion.EntityGuard.GetOwnerFromID( id )	
	return player.GetByUniqueID( id )
end

function fusion.GetOwner(ent)
	if (ent:GetOwner() and ent:GetOwner():IsValid()) then
		return ent:GetOwner()
	elseif (ent.Owner and ent.Owner:IsValid()) then
		return ent.Owner
	elseif (ent.GetPlayer and ent:GetPlayer() and ent:GetPlayer():IsValid()) then
		return ent:GetPlayer()	
	elseif (ent.OwnerID and player.GetByUniqueID( ent.OwnerID )) then
		return player.GetByUniqueID( ent.OwnerID )
	elseif (ent.FounderIndex and player.GetByUniqueID( ent.FounderIndex )) then
		return player.GetByUniqueID( ent.FounderIndex )	
	end
	
	return false
end

function fusion.GetOwnerID(ent)
	local owner = fusion.GetOwner(ent)
	
	if ent.OwnerID then 
		return ent.OwnerID 
	end
	
	if owner and owner:IsValid() and owner:IsPlayer() then
		return owner:UniqueID()
	else
		return false
	end
end

function fusion.EntityGuard.CanTouch( ply, ent )		
	if ent.BlockPickup then return false end
	if !fusion.GetOwnerID(ent) then return false end
	local owner = fusion.GetOwner(ent)	
	if owner and IsValid( owner ) and owner:IsPlayer() then				
		if owner == ply then return true end
		if owner.EG_Buddies and table.HasValue( owner.EG_Buddies, ply:UniqueID() ) then return true end
		if owner.Hierarchy and ply.Hierarchy and ply:IsAdmin() and ply.Hierarchy >= owner.Hierarchy then return true end
		if ent.Unprotected then return true end
	else	
		-- if ply:IsSuperAdmin() then 
			-- ent.Owner = ply
			-- ent.OwnerID = ply:UniqueID()
			-- return true 
		-- end
		if ent == game.GetWorld() then return true end
	end
	return false
end

function fusion.EntityGuard.CheckConstrained( ply, ent )		
	if constraint.GetAllConstrainedEntities( ent ) then	
		for k,v in pairs( constraint.GetAllConstrainedEntities( ent ) ) do			
			if ent != v and v.Owner and !fusion.EntityGuard.CanTouch( ply, v ) then
				return false
			end	
		end
	end
	return true
end	

-- hook.Add( "CanTool", "fusion_EntityGuard_CanTool", function( ply, trace, tool )		
-- end )

//PhysGun	
hook.Add( "OnPhysgunReload", "fusion_EntityGuard_OnPhysgunReload", function( weapon, ply )
	
	local ent = ply:GetEyeTrace().Entity	
	if !ent:IsValid() then return false end	
	if !fusion.EntityGuard.CanTouch( ply, ent ) then
		local id = ent.OwnerID or "protected"
		fusion.EntityGuard.Message( ply, id, "You cannot reload unfreeze this entity." )
		return false
	end		
end )

hook.Add( "PhysgunPickup", "fusion_EntityGuard_PhysgunPickup", function( ply, ent )
	if ent and ent:IsValid() then

		if ent:IsPlayer() then
			if ply:IsAdmin() and ent.Hierarchy and ply.Hierarchy and ply.Hierarchy >= ent.Hierarchy then
				ent:SetMoveType( MOVETYPE_NOCLIP )
				-- ent:ConCommand("+jump")
				return true
			end	
		end
		
		if !fusion.EntityGuard.CanTouch( ply, ent ) then
			local id = ent.OwnerID or "protected"
			fusion.EntityGuard.Message( ply, id, "You cannot pickup this entity." )
			return false
		end
		
	else		
		return false
	end
end )

hook.Add( "CanProperty", "fusion_EntityGuard_CanProperty", function( ply, property, ent )	
	if property == "persist" then 
		local id = ent.OwnerID or "protected"
		fusion.EntityGuard.Message( ply, id, "You cannot make an entity persist." )
		return false 
	end
	
	if !fusion.EntityGuard.CanTouch( ply, ent ) then
		local id = ent.OwnerID or "protected"
		fusion.EntityGuard.Message( ply, id, "You cannot perform property actions on this entity." )
		return false
	end
end )

hook.Add( "CanEditVariable", "fusion_EntityGuard_VariableEdited", function( ent, ply, key, val, editor )
	if !fusion.EntityGuard.CanTouch( ply, ent ) then
		local id = ent.OwnerID or "protected"
		fusion.EntityGuard.Message( ply, id, "You cannot edit the variables of this entity." )
		return false
	end
end )

hook.Add( "CanDrive", "fusion_EntityGuard_CanDrive", function(ply, ent )
	if !fusion.EntityGuard.CanTouch( ply, ent ) then
		local id = ent.OwnerID or "protected"
		fusion.EntityGuard.Message( ply, id, "You cannot drive this entity." )
		return false
	end
end )

hook.Add( "PhysgunDrop", "fusion_EntityGuard_PhysgunDrop", function( ply, ent )
	if ent and ent:IsValid() then
		// player drop
		if ent:IsValid() and ent:IsPlayer() then
			if ply:IsAdmin() and ply.Hierarchy >= ent.Hierarchy then
				-- local vel = ent:GetVelocity() * 5
				ent:SetMoveType( MOVETYPE_WALK )
				-- ent:ConCommand("-jump")
				
				-- ent:SetLocalVelocity(vel)
				return true
			end	
		end
	else		
		return false
	end
end )

// GravGun	
hook.Add( "GravGunPickupAllowed", "fusion_EntityGuard_GravGunPickupAllowed", function( ply, ent )
	if ent and ent:IsValid() then
		if !fusion.EntityGuard.CanTouch( ply, ent ) then
			local id = ent.OwnerID or "protected"
			fusion.EntityGuard.Message( ply, id, "You cannot pickup this entity." )
			return false
		end
	else		
		return false
	end
end )

hook.Add( "GravGunPunt", "fusion_EntityGuard_GravGunPunt", function( ply, ent )
	if ent and ent:IsValid() then
		if !fusion.EntityGuard.CanTouch( ply, ent ) then
			local id = ent.OwnerID or "protected"
			fusion.EntityGuard.Message( ply, id, "You cannot punt this entity." )
			return false
		end	
	else		
		return false
	end
end )

function fusion.EntityGuard.Cleanup( ply )
	if ply:IsValid() and ply:IsPlayer() then
		for k,v in pairs( ents.GetAll() ) do
			if ( v.OwnerID ) then
				local owner = fusion.EntityGuard.GetOwnerFromID( v.OwnerID )
				if v:IsValid() and owner and owner == ply then
					v:Remove()
				end
			end	
		end
	end
end

function fusion.EntityGuard.FreezeProps( ply )
	if ply:IsValid() and ply:IsPlayer() then
		for k,v in pairs( ents.GetAll() ) do
			if ( v.OwnerID ) then
				local owner = fusion.EntityGuard.GetOwnerFromID( v.OwnerID )
				if v:IsValid() and owner and owner == ply then
					if v:GetPhysicsObject() then
						v:GetPhysicsObject():EnableMotion(false)
					end
				end
			end	
		end
	end
end


function fusion.EntityGuard.CleanupDisconnected( )
	for k,v in pairs( ents.GetAll() ) do
		if v:IsValid() and v.OwnerID and !IsValid( fusion.EntityGuard.GetOwnerFromID( v.OwnerID ) ) then
			v:Remove()
		end
	end
end

function fusion.EntityGuard.CleanupMap( )
	game.CleanUpMap()
end

hook.Add( "PlayerInitialSpawn", "fusion_EntityGuard_SendBuddies", function( ply )
	ply.EG_Buddies = {}
end )

hook.Add( "AllowPlayerPickup", "DisablePickUp", function( ply, object )	
	return false	
end )

function fusion.EG_RemoveDisconnectedPlayer(ply)
	-- if !ply:IsAdmin() then
		local id = ply:UniqueID()
		local col = team.GetColor(ply:Team())
		local name = Format("<color=%d,%d,%d>" .. ply:Name() .. "</color>", col.r, col.g, col.b)
		
		local time = 500
		
		fusion.GlobalMessage(name .. " has disconnected, their entities will be cleaned up if they do not rejoin within "..fusion.ConvertTime(time).." seconds.")
		timer.Simple(time, function()
			local p = player.GetByUniqueID(id)
			
			
			if !p then			
				for k,v in pairs( ents.GetAll() ) do
					if v:IsValid() and v.OwnerID and v.OwnerID == id then
						v:Remove()
					end
				end
				fusion.GlobalMessage(name .. "'s entities have been cleaned up.")
			end
		end)
	-- end
end

hook.Add( "PlayerDisconnected", "EG_DisconnectedRemover", function(ply)
	fusion.EG_RemoveDisconnectedPlayer(ply)
end)