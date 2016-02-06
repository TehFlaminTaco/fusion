AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Hook"
ENT.Author			= "Cosmodroke"
ENT.Information		= ""
ENT.Category		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

if (SERVER) then

	function ENT:Initialize()	
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		
		self:PhysicsInit( SOLID_VPHYSICS )
		-- self:PhysicsInitSphere(1, "metal")
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_OBB )	
		
		self:SetNotSolid(true)
		
		
		
	end

	
	function ENT:Think()	
		
	end
	
else

	

	function ENT:Initialize()
		self.EventHorizon = GetRenderTarget( string name, number width, number height, boolean additive )
	end
	
	function ENT:Think()	
		local 	
	end
	
	function ENT:Draw()
		GetRenderTarget("dak", 256, 256, 0 )
		UpdateRenderTarget(self.Pair)
		render.SetRenderTarget( ITexture texture )
		return
	end
	

end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Style" )
	self:NetworkVar( "Entity", 0, "RopeTarget" )
	self:NetworkVar( "Entity", 1, "Player" )
	self:NetworkVar( "Angle", 0, "MoveAngles" )	
	self:NetworkVar( "Bool", 0, "IsHooked" )
	self:NetworkVar( "Vector", 0, "Offset" )
	self:NetworkVar( "Bool", 1, "IsMumma" )
	self:NetworkVar( "Vector", 1, "HitNormal" )
	self:NetworkVar( "Int", 0, "HangLength" )
end