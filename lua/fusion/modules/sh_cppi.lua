CPPI = CPPI or {}
CPPI.CPPI_DEFER = 102112
CPPI.CPPI_NOTIMPLEMENTED = 7080

function CPPI:GetName()
	return "Fusion EntityGuard"
end

function CPPI:GetVersion()
	return "universal.1"
end

function CPPI:GetInterfaceVersion()
	return 1.3
end

function CPPI:GetNameFromUID(uid)
	return CPPI.CPPI_NOTIMPLEMENTED
end

local PLAYER = FindMetaTable("Player")
function PLAYER:CPPIGetFriends()
	if not self.EG_Buddies then return CPPI.CPPI_DEFER end
	-- local FriendsTable = {}

	-- for k,v in pairs(self.EG_Buddies) do
		-- if not table.HasValue(v, true) then continue end -- not buddies in anything
		-- table.insert(FriendsTable, k)
	-- end

	return self.EG_Buddies
end

local ENTITY = FindMetaTable("Entity")

if CLIENT then
	function ENTITY:CPPIGetOwner()
		return LocalPlayer()
	end
end	

if SERVER then
	function ENTITY:CPPIGetOwner()
		local Owner = fusion.GetOwner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() then return SERVER and Owner or nil, self.OwnerID end
		return Owner, Owner:UniqueID()
	end

	function ENTITY:CPPISetOwner(ply)
		local valid = IsValid(ply) and ply:IsPlayer()
		local steamId = valid and ply:SteamID() or nil
		local canSetOwner = hook.Run("CPPIAssignOwnership", ply, self, valid and ply:UniqueID() or ply)

		if canSetOwner == false then return false end
		
		fusion.EntityGuard.SetOwner(self, ply)

		return true
	end

	function ENTITY:CPPISetOwnerUID(UID)
		local ply = UID and player.GetByUniqueID(tostring(UID)) or nil
		if UID and not IsValid(ply) then return false end
		return self:CPPISetOwner(ply)
	end

	function ENTITY:CPPICanTool(ply, tool, trace)
		protected_ToolCheck( ply, tool, trace )
	end

	function ENTITY:CPPICanPhysgun(ply)
		return fusion.EntityGuard.CanTouch( ply, self )
	end

	function ENTITY:CPPICanPickup(ply)
		return fusion.EntityGuard.CanTouch( ply, self )
	end

	function ENTITY:CPPICanPunt(ply)
		return fusion.EntityGuard.CanTouch( ply, self )
	end

	function ENTITY:CPPICanUse(ply)
		return fusion.EntityGuard.CanTouch( ply, self )
	end

	function ENTITY:CPPICanDamage(ply)
		return fusion.EntityGuard.CanTouch( ply, self )
	end

	function ENTITY:CPPIDrive(ply)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanProperty(ply, property)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanEditVariable(ply, key, val, editTbl)
		return CPPI.CPPI_NOTIMPLEMENTED
	end
end
