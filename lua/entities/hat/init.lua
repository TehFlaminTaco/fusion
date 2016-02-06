AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:SetupHat( ply, hat )

	self:SetOwner(ply)
	self:DrawShadow(false)
	
	self:SetPos(ply:GetShootPos())
	self:SetParent(ply)
	
	local dat = fusion.PointShop[hat]
	if dat.Colour then
		self:SetColor( dat.Colour.r, dat.Colour.g, dat.Colour.b, dat.Colour.a )
	end	
	self:SetMaterial( dat.Material or "" )
	
	self:SetNotSolid( true )
	
end
	
	
	-- if IsValid( ply ) then
		-- local pos, ang = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) )
		-- pos = pos + ang:Up() * 3
		-- ent:SetPos( pos )
		-- ent:SetAngles( ang + Angle( 0, 0, 90 ) )
		
		-- ent:SetNotSolid( true )
		
		-- ent:SetColor( 255, 255, 255, 255 )
	-- else
		-- ent:Remove()
	-- end
	
-- end

function ENT:Think()

	local ply = self.Entity:GetOwner()
	if !IsValid( ply ) then	
		self.Entity:Remove()
	end
	
	self:SetNotSolid( true )
	
	-- if !ply:Alive() then
		-- self.Entity:SetParent()
	-- elseif self.Entity:GetParent() != ply then
		-- self.Entity:SetParent( ply )
	-- end

end
