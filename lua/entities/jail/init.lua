AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

local JailAngles = {	
	Angle( 90, 0, 0 ), //TOP
	Angle( 270, 0, 0 ), //BOTTOM
	Angle( 0, 0, 0 ), //FORWARD
	Angle( 0, 90, 0 ), //LEFT
	Angle( 0, 180, 0 ), //BACK
	Angle( 0, 270, 0 ) //RIGHT
}

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/sawblade001a.mdl" )	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:DrawShadow(false)
	
	self:SetNotSolid( true )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(false)
	end
	
	local mdl = "models/props_wasteland/interior_fence002c.mdl"
		
	self.Entity.Walls = {}
	
	for i=1,#JailAngles do
		
		if self.Big then
			local size = 3
			for rows = -1,1 do
				for cols = -1,1 do
					local ent = ents.Create( "prop_physics" ) 
			
					ent:SetModel( mdl ) 
					ent:SetAngles( JailAngles[i] ) 
					ent:SetPos( self.Entity:GetPos() + ent:GetForward() * (( 128 / 2 ) * size) + (ent:GetRight() * (rows * 128)) + (ent:GetUp() * (cols * 128)) ) 	
					ent:Spawn() 
					
					table.insert( self.Entity.Walls, ent )
					
					ent.BlockPickup = true
					
					ent:GetPhysicsObject():EnableMotion( false )
				end
			end
		else
			local ent = ents.Create( "prop_physics" ) 
			
			ent:SetModel( mdl ) 
			ent:SetAngles( JailAngles[i] ) 
			ent:SetPos( self.Entity:GetPos() + ent:GetForward() * ( 129 / 2 ) ) 	
			ent:Spawn() 
			
			table.insert( self.Entity.Walls, ent )
			
			ent.BlockPickup = true
			
			ent:GetPhysicsObject():EnableMotion( false )
		end
	end
	
end
	

function ENT:Think()
	if IsValid( fusion.Prison ) and IsValid( self.Entity.Player ) then
		for k,v in pairs( self.Entity.Walls ) do
			if IsValid( v ) then
				v:Remove()
			end	
		end
		self.Entity:Remove()
		
		self.Entity.Player:Spawn()		
	end	
	
	if !IsValid( self.Entity.Player ) or !self.Entity.Player.Jailed or ( self.Entity.EndTimer and CurTime() > self.Entity.EndTimer ) then		
		for k,v in pairs( self.Entity.Walls ) do
			if IsValid( v ) then
				v:Remove()
			end	
		end
		self.Entity:Remove()
	
		if IsValid( self.Entity.Player ) and self.Entity.Player.Jailed then
			self.Entity.Player.Jailed = nil
			self.Entity.Player.JailPos = nil
		end
	end
	
	
end

