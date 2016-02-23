-- print("asdasdasdasdasd")
EFFECT.Mat = Material( "sprites/bluelaser1" )

function EFFECT:Init( data )
	self.ply = data:GetEntity()
	self.StartPos 	= self.ply:GetPos()
	self.EndPos 	= data:GetOrigin()
	self.Dir 	= (self.EndPos - self.StartPos):GetNormalized()
	self.Length 	= data:GetMagnitude()
	
	
	
	self.Emitter = ParticleEmitter(self.EndPos)
	
	self.Entity:SetRenderBoundsWS(Vector(-40000, -40000, -40000), Vector(40000, 40000, 40000))
	
	-- local dist = self.StartPos:Distance(self.EndPos) * 10
	
	self.LifeTime = 0 //dist * 0.00005
	self.DieTime = CurTime() + self.LifeTime
	
	
	-- print(self.LifeTime)
	
		-- print(self.Length)

	local teamColour = team.GetColor(self.ply:Team())

	-- local rel = (self.EndPos - self.StartPos)
	-- local dir = rel:GetNormalized()
	-- local dist = self.EndPos:Distance(self.StartPos)
	
	local pos = self.EndPos
	
	local emitter = self.Emitter
	
	-- local lineparticles = math.Round((self.EndPos - self.StartPos):Length() / 15)
	
	
	-- for i = 1, lineparticles do
		-- local md = self.Length * (i/lineparticles)
		-- local particle = emitter:Add( "sprites/light_glow02_add", (pos + (self.Dir * md)))// + (VectorRand() * math.Rand(0, 5) + Vector(0,0,5)))
		-- if (particle) then
		
			-- particle:SetVelocity(Vector(0,0,0))
			-- particle:SetLifeTime( 0 )
			-- particle:SetDieTime( 10 )
			-- particle:SetStartAlpha(255)
			-- particle:SetEndAlpha( 0 )
			-- particle:SetStartSize( math.Rand(10, 25))
			-- particle:SetEndSize( 0 )
			-- particle:SetRoll( math.Rand(0, 360) )
			-- particle:SetRollDelta( 0 )
			-- particle:SetColor(teamColour.r, teamColour.g, teamColour.b )
			-- particle:SetAirResistance( 100 )
			-- particle:SetGravity(VectorRand() * 10)
			-- particle:SetCollide( true )
			-- particle:SetBounce( 0.3 )
			
		-- end
	-- end
	
	
	for i = 1, 3 do
		local particle = emitter:Add( "particle/particle_smokegrenade1", pos)
		if (particle) then
		
			particle:SetVelocity( (self.ply:GetUp() + VectorRand() * 0.9) * 100 + self.ply:GetVelocity() / 5)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( 50 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize(50)
			particle:SetEndSize( math.Rand(120, 160) )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-1, 1) )
			particle:SetColor( teamColour.r, teamColour.g, teamColour.b )
			particle:SetAirResistance( 100 )
			particle:SetGravity(Vector(0,0,5))
			particle:SetCollide( true )
			particle:SetBounce( 0.3 )
			
			
		end
		
		
		
	end
	
	-- for i = 1, 25 do
	
		-- local particle = emitter:Add( "sprites/light_glow02_add", pos + Vector(math.Rand(-20,20), math.Rand(-20,20), math.Rand(-30,100)))
		-- if (particle) then
		
			-- particle:SetVelocity(Vector(math.Rand(-50,50), math.Rand(-50,50), 50) + self.ply:GetVelocity() / 1)
			-- particle:SetLifeTime( 0 )
			-- particle:SetDieTime( 1 )
			-- particle:SetStartAlpha(255)
			-- particle:SetEndAlpha( 0 )
			-- particle:SetStartSize( math.Rand(50, 100))
			-- particle:SetEndSize( 0 )
			-- particle:SetRoll( math.Rand(0, 360) )
			-- particle:SetRollDelta( 0 )
			-- particle:SetColor(teamColour.r, teamColour.g, teamColour.b )
			-- particle:SetAirResistance( 100 )
			-- particle:SetGravity(VectorRand() * 5)
			-- particle:SetCollide( true )
			-- particle:SetBounce( 0.3 )
			
		-- end
		
	-- end
	
	for i = 1, 25 do
	
		local particle = emitter:Add( "particle/warp1_warp", self.ply:LocalToWorld(self.ply:OBBCenter()))
		if (particle) then
		
			particle:SetVelocity(VectorRand() * 0)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha(255)
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0)
			particle:SetEndSize( 100 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
			particle:SetColor(255,255,255)
			particle:SetAirResistance( 100 )
			particle:SetGravity(VectorRand() * math.Rand(0,300))
			particle:SetCollide( true )
			particle:SetBounce( 0.3 )
			
		end
		
	end
		
	emitter:Finish()

end

function EFFECT:Render( )

	local teamColour = team.GetColor(self.ply:Team())

	local rel = (self.EndPos - self.StartPos)
	local dir = rel:GetNormalized()
	local dist = rel:Length()

	local fDelta = (self.DieTime - CurTime()) / self.LifeTime
	fDelta = 1-math.min(1, fDelta)
			
	render.SetMaterial( self.Mat )
	
	local sinWave = math.sin( fDelta * math.pi )
	
	local curPos = self.StartPos + (dir * dist * fDelta)
	
	-- render.DrawBeam(curPos + dir * 100, 		
					-- curPos + dir * -100,
					-- 10,					
					-- 1,					
					-- 0,				
					-- teamColour )
	
		-- self.ply:SetPos(curPos)
				
	-- render.DrawBeam(self.StartPos, 		
					-- self.EndPos,
					-- 10,					
					-- 1,					
					-- 0,				
					-- Color( 255, 255, 255, 255 ) )				
					 
end
