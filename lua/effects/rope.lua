


-- EFFECT.Mat = Material( "cable/cable2" )
EFFECT.Mat = Material( "cable/rope" )
EFFECT.Mat2 = Material( "sprites/physbeam" )




EFFECT.SplodeMat = Material( "sprites/light_glow02_add" )
EFFECT.SplodeMat2 = Material( "particle/sparkles" )
EFFECT.WarpMat = Material( "particle/Particle_Ring_Sharp_Additive" )
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.Hook = data:GetEntity()
	
	if self.Hook:IsValid() then
		self.Target = self.Hook:GetOwner()	
	end
	
	self.EffectScale = data:GetScale()
	
	self.RopeType = math.Round(data:GetMagnitude())
	
	-- self.Mat2:SetString("texturescrollvar", "$basetexturetransform")
	-- self.Mat2:SetFloat("texturescrollrate", 25)
	-- self.Mat2:SetInt("texturescrollangle", -90)
	
	self:SetRenderBoundsWS(Vector(-40000,-40000,-40000), Vector(40000,40000,40000))
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if !self.Hook:IsValid() then

	
		return false 
	end
	
	local target = self.Hook:GetOwner()	
	if !target:IsValid() then
		return false
	end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )
	
	local ent = self.Hook
	local ent2 = ent
	
	if ent:IsValid() and ent:GetOwner() then
		ent2 = ent:GetOwner()
	end

	if ent:IsValid() and ent2:IsValid() then
	
		self.Scale = ent:GetModelScale()	
	
		local pos = ent:LocalToWorld(Vector(0,0,0))
		local pos2 = ent2:LocalToWorld(Vector(0,0,0))
		
		local mdl = ent:GetModel()
		local mdl2 = ent2:GetModel()
		
		-- print(mdl)
		-- PrintTable(fusion.RopeMdlOffsets[mdl .. ""])
		
		if fusion.RopeMdlOffsets[mdl] then
			pos = ent:LocalToWorld(fusion.RopeMdlOffsets[mdl].RopePos * self.Scale)
		end
		
		if fusion.RopeMdlOffsets[mdl2] then
			pos2 = ent2:LocalToWorld(fusion.RopeMdlOffsets[mdl2].RopePos * self.Scale)
		end
		
		if ent:IsPlayer() then
			pos = ent:GetBonePosition(0)
		end
		
		if ent2:IsPlayer() then
			pos2 = ent2:GetBonePosition(0)
		end
		
		-- local emitter = ParticleEmitter( pos )

		-- if emitter and !ent.nextSmoke or CurTime() > ent.nextSmoke then
			-- local particle = emitter:Add( "sprites/glow04_noz", pos)
			-- if (particle) then
			
				-- particle:SetVelocity( (ent:GetUp() + VectorRand() * 0.9) * 25)
				-- particle:SetLifeTime( 0 )
				-- particle:SetDieTime( math.Rand( 0.1,0.3 ) )
				-- particle:SetStartAlpha( math.Rand( 1, 2 ) )
				-- particle:SetEndAlpha( 0 )
				-- particle:SetStartSize( math.Rand(1, 5) )
				-- particle:SetEndSize( 0 )
				-- particle:SetRoll( math.Rand(0, 360) )
				-- particle:SetRollDelta( 0 )
				
				-- particle:SetAirResistance( 100 )
				-- particle:SetGravity(Vector(0,0,-50))
				-- particle:SetCollide( true )
				-- particle:SetBounce( 0.3 )
				
				
				-- ent.nextSmoke = CurTime() * 0.01
			-- end
			
			-- emitter:Finish()
		-- end
		
		local dir = (pos - pos2):GetNormalized()
		local curdist = (pos2 - pos):Length()
		
		local segs = 10 
		local prevpos = pos2
		
		local teamColour = Color(255,255,255,255)
		
		if ent2:IsPlayer() then
			teamColour = team.GetColor(ent2:Team())
		elseif ent2:GetOwner() and ent2:GetOwner():IsPlayer() then
			teamColour = team.GetColor(ent2:GetOwner():Team())
		end
		
		local speed = 40
		local cosstart = curdist * 0.1	
		
		local steel = Color(40,55,90)
		
		-- print(math.Round(self.RopeType))
		
		if (self.RopeType == 2 or self.RopeType == 3) then
			teamColour.a = 255 * self.EffectScale
			render.SetMaterial(self.Mat)
			fusion.cl.DrawBeam(pos, pos2, -dir, dir, 0, 4, 1 * self.EffectScale, steel, steel, 1, 5, 0, 0, 0)
		end
		
		if (self.RopeType == 1 or self.RopeType == 3) then

			teamColour.a = 100 * self.EffectScale
			render.SetMaterial(self.Mat2)
			fusion.cl.DrawBeam(pos, pos2, -dir, dir, 0, 4, 45 * self.EffectScale, teamColour, teamColour, 1, 10, 0, 0, 0)
			
			teamColour.a = 255 * self.EffectScale
			render.SetMaterial(self.Mat2)
			fusion.cl.DrawBeam(pos, pos2, -dir, dir, 0, 4, 2 * self.EffectScale, teamColour, teamColour, 1, 10, 0, 0, 0)
			
			
			render.SetMaterial(self.SplodeMat2)
			fusion.cl.DrawBeam(pos, pos2, -dir, dir, 0, 12, 3 * self.EffectScale, teamColour, teamColour, 1, 3, CurTime() * 30, 0, 0)		
			
			render.SetMaterial(self.SplodeMat)
			render.DrawSprite(pos, 12 * self.EffectScale,12 * self.EffectScale, Color(255,180,25,255))
			teamColour.a = 12 * self.EffectScale
			render.SetMaterial(self.SplodeMat)
			render.DrawSprite(pos, 46 * self.EffectScale,46 * self.EffectScale, teamColour)
			
		end
		
		
		-- cam.End3D2D()
	end	
	
				 
end

