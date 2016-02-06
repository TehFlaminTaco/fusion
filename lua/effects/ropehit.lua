


-- EFFECT.Mat = Material( "cable/cable2" )

EFFECT.SplodeMat = Material( "sprites/light_glow02_add" )
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.Hook = data:GetEntity()
	
	local ent = self.Hook
	local ent2 = ent
	
	if ent:IsValid() and ent:GetPlayer() then
		ent2 = ent:GetPlayer()
	end
	
	self.Magnitude = math.Round(data:GetMagnitude())
		
	if ent:IsValid() and ent2:IsValid() then
	
		self.Scale = ent:GetModelScale()	
	
		local pos = ent:LocalToWorld(Vector(0,0,0))
		local pos2 = ent2:LocalToWorld(Vector(0,0,0))
		
		local teamColour = Color(255,255,255,255)
		
		if self.Magnitude == 2 then
			teamColour = Color(100,100,100)
		else
		
			if ent2:IsPlayer() then
				teamColour = team.GetColor(ent2:Team())
			elseif ent2:GetPlayer() and ent2:GetPlayer():IsPlayer() then
				teamColour = team.GetColor(ent2:GetPlayer():Team())
			end
		
		end
		
		local emitter = ParticleEmitter( pos )
		
		if emitter then
			if self.Magnitude != 2 then
				for i = 1, 4 do
					local particle = emitter:Add( "sprites/light_glow02_add", pos)
					if (particle) then
					
						particle:SetVelocity( VectorRand() * 25 *self.Scale)
						particle:SetLifeTime( 0 )
						particle:SetDieTime( math.Rand( 0.5, 1 ) )
						particle:SetStartAlpha( 0 )
						particle:SetEndAlpha( 255 )
						particle:SetStartSize( math.Rand(5, 10) *self.Scale)
						particle:SetEndSize( 0 )
						particle:SetRoll( math.Rand(0, 360) )
						particle:SetRollDelta( 0 )
						particle:SetColor( teamColour.r, teamColour.g, teamColour.b )
						particle:SetAirResistance( 100 )
						particle:SetGravity(Vector(0,0,0))
						particle:SetCollide( true )
						particle:SetBounce( 0.3 )
					end
				end				
			else
				for i = 1, 6 do
					local particle = emitter:Add( "effects/spark", pos + VectorRand() * 5)
					if (particle) then
					
						particle:SetVelocity( VectorRand() * 50 *self.Scale)
						particle:SetLifeTime( 0 )
						particle:SetDieTime( math.Rand( 0.1, 0.2 ) )
						particle:SetStartAlpha( 255 )
						particle:SetEndAlpha( 0 )
						particle:SetStartSize( 1 *self.Scale)
						particle:SetEndSize( 0  )
						particle:SetRoll( math.Rand(0, 360) )
						particle:SetRollDelta( 1 )
						particle:SetColor(255,255,255)
						particle:SetAirResistance( 25 )
						particle:SetGravity(Vector(0,0,0))
						particle:SetCollide( true )
						particle:SetBounce( 0.3 )
					end
				end
				
				for i = 1, 4 do
					local particle = emitter:Add( "particle/particle_smokegrenade1", pos)
					if (particle) then
					
						particle:SetVelocity(VectorRand() * 5 *self.Scale)
						particle:SetLifeTime( 0 )
						particle:SetDieTime( math.Rand( 3, 9 ) )
						particle:SetStartAlpha( 255 )
						particle:SetEndAlpha( 0 )
						particle:SetStartSize( math.Rand(3, 7)  *self.Scale * 2)
						particle:SetEndSize( 0 )
						particle:SetRoll( math.Rand(0, 360) )
						particle:SetRollDelta( math.Rand(-1, 1) )
						particle:SetColor(5,5,5)
						particle:SetAirResistance( 50 )
						particle:SetGravity(Vector(0,0,2))
						particle:SetCollide( true )
						particle:SetBounce( 0.3 )
					end
				end
			end
			
			for i = 1, 4 do
				local particle = emitter:Add( "particle/particle_smokegrenade1", pos)
				if (particle) then
				
					particle:SetVelocity(VectorRand() * 20 *self.Scale)
					particle:SetLifeTime( 0 )
					particle:SetDieTime( math.Rand( 3, 9 ) )
					particle:SetStartAlpha( 100 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand(5, 6)  *self.Scale * 2)
					particle:SetEndSize( 0 )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetRollDelta( math.Rand(-1, 1) )
					particle:SetColor( teamColour.r, teamColour.g, teamColour.b )
					particle:SetAirResistance( 100 )
					particle:SetGravity(Vector(0,0,2))
					particle:SetCollide( true )
					particle:SetBounce( 0.3 )
				end
			end
			
			//particle/Particle_Glow_03_Additive
			//particle/warp1_warp
			//particle/warp4_warp
			
			for i = 1, 2 do
				local particle = emitter:Add( "sprites/heatwave", pos)
				if (particle) then
				
					
				
					particle:SetVelocity( (ent:GetUp() + VectorRand() * 0.9) * 5 *self.Scale)
					particle:SetLifeTime( 0 )
					particle:SetDieTime( math.Rand(0.1, 0.4) )
					particle:SetStartAlpha( 5 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand(20, 50) *self.Scale)
					particle:SetEndSize( math.Rand(20, 50) *self.Scale )
					particle:SetEndSize( 0 )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetRollDelta( math.Rand(-4, 4) )
					particle:SetColor( 255,255,255)
					particle:SetAirResistance( 100 )
					particle:SetGravity(VectorRand() * 5)
					particle:SetCollide( true )
					particle:SetBounce( 0.3 )
				end
				
			end
			
			emitter:Finish()
			
		end
		
	end	
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	-- if !(self.Hook:IsValid() and self.Target:IsValid()) then
		-- return false 
	-- end
	
	return false

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )
	
	
				 
end

