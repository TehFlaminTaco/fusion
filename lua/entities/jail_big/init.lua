AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

local JailAngles = {	
	Angle( 0, 0, 0 ), //TOP
	Angle( 180, 0, 0 ), //BOTTOM
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
	
	self:SetNotSolid( true )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(false)
	end
	
	local mdl = "models/hunter/blocks/cube4x4x025.mdl" --"models/hunter/plates/plate4x4.mdl"
		
	self.Entity.Walls = {}
	
	for i=1,#JailAngles do 		
		
		if i > 2 then
			for k = -1, 1 do
				
				local ent = ents.Create( "prop_physics" ) 
					
				ent:SetModel( mdl ) 
				ent:SetAngles( JailAngles[i] )
				ent:SetPos( self.Entity:GetPos() + ent:GetForward() * ( ( 189.862854 / 2 ) * 3 ) + ent:GetRight() * ( k * ( 189.862854 ) ) ) 	
				ent:Spawn() 
				
				ent:SetAngles( ent:GetAngles() + Angle( 90, 0, 0 ) )
				

					ent:SetColor( 255, 255, 255, 255 )
					ent:SetMaterial( "models/props_canal/metalwall005b" )
		
				
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:EnableMotion(false)
				end
				
				table.insert( self.Entity.Walls, ent )
				
				ent.BlockPickup = true
				
				ent:GetPhysicsObject():EnableMotion( false )
				
			end
		else
			if i != 2 then
			for forward = -1, 1 do
				for right = -1, 1 do
			
					local ent = ents.Create( "prop_physics" ) 
						
					local f = forward * 189.862854
					local r = right * 189.862854
						
					ent:SetModel( mdl ) 
					ent:SetAngles( JailAngles[i] ) 
					ent:SetPos( self.Entity:GetPos() + ent:GetUp() * ( 189.862854 / 2 ) + ent:GetRight() * r + ent:GetForward() * f ) 	
					ent:Spawn()					
					
					ent:SetColor( 255, 255, 255, 255 )
					
					if i == 2 then
						ent:SetMaterial( "phoenix_storms/metalfloor_2-3" )
					else
						ent:SetMaterial( "models/props_canal/metalwall005b" )
					end
					
					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()
						phys:EnableMotion(false)
					end
					
					table.insert( self.Entity.Walls, ent )
					
					ent.BlockPickup = true
					
					ent:GetPhysicsObject():EnableMotion( false )
					
				end	
			end	
			end
		end	
	end
	
end
	

function ENT:Think()
	if !fusion.Prison or fusion.Prison != self.Entity then	
	
		for k,v in pairs( self.Entity.Walls ) do
			if IsValid( v ) then
				v:Remove()
			end	
		end
		self.Entity:Remove()
	end
end

