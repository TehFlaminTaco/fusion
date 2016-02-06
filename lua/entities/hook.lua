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
		-- self:SetSolid( SOLID_VPHYSICS )
		
		-- self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		self:DrawShadow(true)
		
		-- self:SetNotSolid( true )
		
		self:StartMotionController()
		self.ShadowParams = {}
		
		-- 
		
		-- local mins, maxs = Vector(-1000,-1000,-1000), Vector(1000,1000,1000)
		
		self:SetCustomCollisionCheck(true)
		
		
		
		-- self:PhysicsInitBox(mins, maxs)		
		-- self:SetCollisionBounds(mins,maxs)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(1)
			phys:SetMaterial("metal")
			-- phys:EnableGravity(false)
			-- phys:EnableMotion(true)
		end		
	end
	
	function ENT:Delete()
		local ply = self:GetPlayer()
	
		ply.HookTimer = CurTime() + 0.5
	
		-- 
		
		-- if ply.HookTarget == self then
			-- fusion.SetHookTarget(ply, NULL)
		-- end
		
		if self.Babies and #self.Babies > 0 then
			for k,v in pairs(self.Babies) do
				if v:IsValid() then
					v:Remove()
				end				
			end
		end
		
		
		
		-- print(self.Launcher)
		if self.Launcher and self.Launcher:IsValid() then
			self.Launcher.Sound:Stop()
			-- self.Launcher.Sound2:Stop()
			self.Launcher:Remove()
		end
		
		self:EmitSound("weapons/crossbow/fire1.wav", 90, 255)
		
		self:Remove()
	end
	
	function ENT:SpawnLauncher()
		local ply = self:GetPlayer()
		
		local style = self:GetStyle()
		local style_data = styles[style] or {}
		local scale = style_data.ModelScale
		
		self:SetModelScale(scale * 2, 0)
		
		// LAUNCHER
			local launcher = ents.Create("hook")
			launcher:SetNotSolid(true)
			launcher:SetModel("models/props_lab/tpplug.mdl")
			launcher:SetPos(ply:GetShootPos())
			launcher:SetAngles(ply:EyeAngles())
			launcher:Spawn()
			launcher:SetNotSolid(true)			
			
			launcher:SetStyle(style)
			launcher:SetOffset(Vector(12,0,0))
			launcher:SetRopeTarget(self)
			launcher:SetIsHooked(true)
			launcher:SetPlayer(ply)
			
			launcher:SetParent(ply)
			
			launcher:SetOwner(self)
			
			launcher:GetPhysicsObject():Sleep()
			
			launcher.IsLauncher = true
			
			self.Launcher = launcher
			
			launcher:SetModelScale(0.3, 0)
			
			launcher.Sound = CreateSound(launcher, "npc/turret_wall/turret_loop1.wav")	


			-- local song = "music/hl2_song" .. math.random(1,20) .. ".mp3"
			
			-- launcher.Sound2 = CreateSound(launcher, song)			
		///
	end
	
	function ENT:SpawnBabies(pos, ang, radius, num)		
		local ply = self:GetPlayer()
		
		local style = self:GetStyle()
		local style_data = styles[style] or {}
		local scale = style_data.ModelScale
		
		local moveAngles = self:GetMoveAngles()
		
		if num <= 0 then return end
		
		self.Babies = {}
		
		local slice = 360 / num		
		
		
		-- ang:RotateAroundAxis(ang:Forward(), slice/2)
		

		-- pos = pos
		local start_pos = pos + ang:Forward() * 5
		local pingers = pos + ang:Forward() * -(style_data.BabyHeight)
		for i = 1, num do			
			local baby = ents.Create("hook")
			baby:SetModel(self:GetModel())
			baby:SetPos(start_pos)
			
			baby:Spawn()		
			
			
			
			ang:RotateAroundAxis(ang:Forward(), slice)
			
			-- local myAngle = ang
			-- myAngle:RotateAroundAxis(myAngle:Right(), -45)
			
			local start = fusion.GetHookerPosAng(ply)
			
			local rad = radius
			if i % 2 == 0 and num > 3 then
				rad = rad /2
			end
			local toPos = pingers + ang:Up() * rad
			local dir = (toPos-start_pos):GetNormalized():Angle()
			
			
			
			local posse, myAngles = LocalToWorld( Vector(0,0,0), (style_data.AngleOffset or Angle(0,0,0)) + Angle(180,0,0), start_pos, dir )
			
			baby:SetAngles(myAngles)
			
			
			
			-- local pp, myAngles = LocalToWorld( Vector(0,0,0), (style_data.AngleOffset or Angle(0,0,0)) + Angle(180,0,0), start_pos, dir )
			-- baby:SetAngles(ang)
			
			baby:SetStyle(style)
			baby:SetRopeTarget(self)
			baby:SetMoveAngles(dir)
			baby:SetIsHooked(false)
			baby:SetPlayer(ply)
			
			baby.HasMumma = self
			
			baby:SetOwner(self)			
			baby:SetModelScale(scale, 0)
			
			table.insert(self.Babies, baby)
		end
	end
	
	function ENT:HookPlayer(ply)
		if self.IsPuller then
			local vel = self:GetVelocity()
			ply:SetMoveType(MOVETYPE_WALK)
			fusion.SetHookTarget(ply, self)
			
			self.Launcher.Sound:Play()	
			-- self.Launcher.Sound2:Play()	
		end
	end
	
	function ENT:PhysicsCollide( colData, collider )	
		local style = self:GetStyle()
		local style_data = styles[style] or {}

		ply = self:GetPlayer()		
		
		local model_offset = (style_data.ModelOffset or Vector(0,0,0)) * self:GetModelScale()
		
		
		local phys = self:GetPhysicsObject()				
		phys:EnableMotion(false)
				
		
		
		

		self:SetPos(colData.HitPos)
		
		style_data.HitEffect(self)
		
		
		local hook_pos = self:GetPos()
		local trace = util.TraceLine({
			start = hook_pos + colData.HitNormal * -100, ///self:GetMoveAngles():Forward() * -100, 
			endpos = hook_pos + colData.HitNormal * 100, //self:GetMoveAngles():Forward() * 100, 
			filter = {ply, self}
		})		
		
		local toangles = self:GetAngles()
		
		local waitToParent = false
		
		local ent = colData.HitEntity		
		
		-- if trace.HitSky then
			-- ply:EmitSound("physics/surfaces/underwater_impact_bullet3.wav", 100, 110)
			-- self:Delete()
			
			
			
			-- return
		-- else
		self:EmitSound("physics/metal/metal_sheet_impact_bullet2.wav", 100, math.random(100, 150))

		if trace.Hit then
			
			if (style_data.AlignHooked and self.IsPuller) or (style_data.BabyAlignHooked and !self.IsPuller) then
				local pos, dir = LocalToWorld(Vector(0,0,0), (style_data.AngleOffset or Angle(0,0,0)) + Angle(0,0,0), hook_pos, trace.HitNormal:Angle())								
				self:SetAngles(dir)
			end	
			
			if !self.Babies and self.IsPuller and style_data.NumBabies then

				local hitnorm = trace.HitNormal:Angle()
				
				local ent = trace.Entity
				
				self:SetPos(self:GetPos() + trace.HitNormal * style_data.BabyHeight)	

				-- self:SpawnBabies(self:GetPos(), hitnorm, style_data.BabyRadius, style_data.NumBabies)
				
				
				
			end
			 
			
			self:SetHitNormal(trace.HitNormal)
		end
		
		local ent = colData.HitEntity			
		if !waitToParent then
			
			self:SetIsHooked(true)
			
			if ent and ent:IsValid() then
				if ent:GetClass() == "prop_physics" then //and fusion.EntityGuard.CanTouch( ply, ent )	 then
					self:SetParent(ent)
				else
					ply:EmitSound("physics/surfaces/underwater_impact_bullet1.wav", 65, 150)
					if self.Sound then self.Sound:Stop() end
					self:Delete()
					-- 
					-- self:Delete()
				end
			end
			
			self:HookPlayer(ply)
		end
	
		
		-- return false
		
	end
	
	function ENT:Think()	
		if self.IsLauncher then
			if !self:GetOwner():IsValid() then
				self.Sound:Stop()
				-- self.Sound2:Stop()
				self:Remove()
			end
			
			
		end
		
		-- if self.Launcher and self.Launcher:IsValid() then
			-- local vel = self.Launcher:GetVelocity():Length()
			-- local sin = math.sin(CurTime() * vel)
			-- self.Launcher.Sound2:ChangePitch( 200 + sin * 50, 0 )
			-- self.Launcher.Sound2:ChangeVolume(50, 0 )
		-- end
		
		if !self.GetPlayer or !self:GetPlayer():IsValid() then
			self:Remove()
		else
		
			local isHooked = self:GetIsHooked()
			
			
			
			local style = self:GetStyle()
			local style_data = styles[style] or {}
			
			local alignHooked = style_data.AlignHooked
			local moveAngles = self:GetMoveAngles()
			
			local hook_pos = self:GetPos()
			
			local ply = self:GetPlayer()
			
			if self.HasMumma and self.HasMumma:IsValid() then
				local mummaPos = self.HasMumma:GetPos()
				local dist = mummaPos:Distance(hook_pos)
				if dist > 1000 and !self.Broken then	// break
					self.Broken = true
					self:SetRopeTarget(self)
					
					self.HasMumma:EmitSound("physics/surfaces/underwater_impact_bullet1.wav",65, 150)	
					self:EmitSound("weapons/crossbow/fire1.wav", 70, 255)	
				
				elseif dist < 1000 and self.Broken then // unbreak
					self.Broken = false
					self:SetRopeTarget(self.HasMumma)
					
					self.HasMumma:EmitSound("npc/antlion/shell_impact3.wav",65, 150)	
					self:EmitSound("npc/antlion/shell_impact3.wav", 65, 150)	
				end
			end
			
			
			if (!isHooked) then
				
			elseif self.IsPuller and isHooked then
				local frametime = FrameTime( )	
						
						
				local ply = self:GetPlayer()
				
				
				local ply_pos = ply:GetPos()
				
				
				local specopsforce = 1//0.5
				
				local distance = ply_pos:Distance(hook_pos)
				local dir = (ply_pos - hook_pos):GetNormalized()
				local vel = self:GetVelocity():Length()
				
				kill_when_close = true
				
				local parent = self:GetParent()
				if (parent and parent:IsValid()) then
					kill_when_close = false
					vel = parent:GetVelocity():Length()
				end
				
				if (ply:GetMoveType() != MOVETYPE_WALK) then
					self:Delete()
				else					
					local velmult = 0
					
					local min = 0
					local noForce = false
					
					local tolen = distance
					
					if kill_when_close then // if world hook
						min = 10
						local killDist = ply:GetVelocity():Length() * 0.1 + 50
						if distance < killDist*1.1 and !sticky then
							self:Delete()
						end
					else // if welded entity hook
						min = 300
						-- local walk_range = 400
						if vel > 100 then 
							-- specopsforce = 0.7
							min = 400
							
						else
						
							-- velmult = 0.5
							-- force = 0.2
						end
						-- tolen = min
						if distance <= 400 and vel < 300 then
							noForce = true
							-- tolen = distance
						end
						
					end 
					
					min = min or min_override
					
					self.Length = math.Approach(tolen, min, style_data.RopeRate * frametime * 50) // 100
						
					local topos = hook_pos + dir * self.Length
					local vec = (topos-ply_pos) * specopsforce * 5 // 0.5
					
					if !noForce then
						-- ply:SetLocalVelocity(ply:GetVelocity()*0.5 + vec)
						
						 
						
						-- local myVel = ply:GetVelocity()*0.9 // 0.2 for really tacky feel?
						
						-- ply:SetLocalVelocity(myVel + vec)
						
						-- ply:SetVelocity(-myVel + vec)
					else
						-- ply:SetLocalVelocity(ply:GetVelocity()*0.95)
						-- ply:SetVelocity(-ply:GetVelocity()*0.1)
					end
					
					
				end
				
			end
		end
		-- self:NextThink(CurTime() + 0.1)
		-- return true
	end
	
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
	
	function ENT:PhysicsSimulate( phys, deltatime )		
		
		
		local style = self:GetStyle()
		local style_data = styles[style] or {}
		
		local isHooked = self:GetIsHooked()
		local alignHooked = style_data.AlignHooked
		local moveAngles = self:GetMoveAngles()
		
		local ply = self:GetPlayer()
		
		
		local hook_dir = moveAngles:Forward()
		local hook_pos = self:GetPos()
		
		local speed = style_data.RopeRate
		
		local add = Vector(0,0,0)
		local gravity = 0
		if !self.IsPuller then
			local pov = 100
			local dec = pov * 0.01
		
			self.Poverty = math.max((self.Poverty or pov) - dec, 0)
			speed = self.Poverty
			
			gravity = pov-speed
			
			local mumma = self.HasMumma
			-- print(mumma)
			
			if mumma and mumma:IsValid() then
				local parent = mumma:GetParent()
				if parent and parent:IsValid() then
					mumma = parent
				end
				
				add = mumma:GetVelocity() * 0.05
			end
		end
		
		local topos = hook_pos + hook_dir * speed + Vector(0,0,-gravity) + add
		
		
		local toangles = self:GetAngles()
		
		
		
		-- if trace.Hit then
			
			-- if self.IsPuller then
				-- ply:SetMoveType(MOVETYPE_WALK)	
				-- fusion.SetHookTarget(ply, self)
			-- end
			
			-- local model_offset = (style_data.ModelOffset or Vector(0,0,0)) * self:GetModelScale()
			
			
			-- if !self.overrideToPos then
						
				
				
				-- local phys = self:GetPhysicsObject()				
				-- phys:EnableMotion(false)
				-- phys:Sleep()
				
				-- if alignHooked then
					-- local pos, dir = LocalToWorld(Vector(0,0,0), (style_data.AngleOffset or Angle(0,0,0)) + Angle(0,0,0), self:GetPos(), trace.HitNormal:Angle())								
					-- self:SetAngles(dir)
					
					-- local segs = 10
					
				-- end
				
				-- local hitpos = trace.HitPos	+ self:GetForward() * model_offset.x + self:GetRight() * model_offset.y + self:GetUp() * model_offset.z
				
				-- self.overrideToPos = hitpos	
				-- self:SetPos(hitpos)
			
				-- local phys = self:GetPhysicsObject()
				
				-- style_data.HitEffect(self)
					
				
				-- self:EmitSound("physics/metal/metal_sheet_impact_bullet2.wav", 100, math.random(100, 150))

				-- self:SetIsHooked(true)
				
				-- if trace.Entity and fusion.GetOwner(trace.Entity) then
					-- self:SetParent(trace.Entity)								
				-- end
			-- end			
		-- end
		-- else
			
			
			self.ShadowParams.secondstoarrive = 0.01 // How long it takes to move to pos and rotate accordingly - only if ( it could move as fast as it want - damping and max speed/angular will make this invalid ( Cannot be 0! Will give errors if ( you do )
			self.ShadowParams.pos = self.overrideToPos or topos // Where you want to move to
			self.ShadowParams.angle = toangles // Angle you want to move to
			self.ShadowParams.maxangular = 500 //What should be the maximal angular force applied
			self.ShadowParams.maxangulardamp = 10000 // At which force/speed should it start damping the rotation
			self.ShadowParams.maxspeed = 10000 // Maximal linear force applied
			self.ShadowParams.maxspeeddamp = 10000// Maximal linear force/speed before damping
			self.ShadowParams.dampfactor = 0.8 // The percentage it should damp the linear/angular force if ( it reaches it's max amount
			self.ShadowParams.teleportdistance = 0 // If it's further away than this it'll teleport ( Set to 0 to not teleport )
			self.ShadowParams.deltatime = deltatime // The deltatime it should use - just use the PhysicsSimulate one
			
			phys:ComputeShadowControl( self.ShadowParams )
		-- end
	end
	
else

	

	function ENT:Initialize()
		self.RopeMat = Material( "cable/rope" )
		self.BeamMat = Material( "sprites/physbeam" )
		self.SplodeMat = Material( "sprites/light_glow02_add" )
		self.SplodeMat2 = Material( "sprites/animglow02" )
		self.WarpMat = Material( "particle/Particle_Ring_Sharp_Additive" )
		self.DistortedMat = Material( "sprites/physgbeamb" )
		
		self.GlowBeamMat = Material( "sprites/rollermine_shock" )
		
		self.SmokeMat = Material("particle/particle_smokegrenade1" )
		
		-- self:SetRenderBounds(Vector(-10000, -10000, -10000), Vector(10000, 10000, 10000))
		-- self:SetRenderBoundsWS(Vector(-40000,-40000,-40000), Vector(40000,40000,40000))
	end
	
	function ENT:Think()
	
		-- local target = self:GetRopeTarget()
		-- if target and target:IsValid() then
			-- self:SetRenderBoundsWS(self:GetPos()*1.1, target:GetPos()*1.1)
		-- end
	
		local parent = self:GetParent()
		if parent and parent:IsValid() and parent:IsPlayer() then
						
			local pos, ang = fusion.GetHookerPosAng(parent)
			
			self:SetPos(pos)
			self:SetAngles(ang)
		end
		
		if !self:GetIsHooked() then
			local frametime = FrameTime( )
			local moveAngles = self:GetMoveAngles()
			local hook_pos = self:GetPos()
			local hook_dir = moveAngles:Forward()
			
			-- local topos = hook_pos + hook_dir * (-10000*frametime)
			
			-- self:SetPos(topos)
			
			self:SetVelocity(hook_dir * (100000*frametime))
		end
	
	end

	function ENT:DrawRope()
	
		local style = self:GetStyle()
		local style_data = styles[style]
	
		local ply = self:GetPlayer()		
		local target = self:GetRopeTarget()	
		
		
		
		if self and self:IsValid() and ply and ply:IsValid() and target and target:IsValid() and style and style_data then
		
			local myOffset = style_data.RopeOffset			
			local pos1 = self:LocalToWorld(myOffset * self:GetModelScale())
			local pos2 = target:LocalToWorld(myOffset * target:GetModelScale())
			
			
			if self:GetOffset() and self:GetOffset() != Vector(0,0,0) then
				pos1 = self:LocalToWorld(self:GetOffset() * self:GetModelScale())
			end
			
			
			
			
			
			-- cam.Start3D2D(EyePos(), EyeAngles(), 1)
			
			-- PrintTable(style_data)
			
			local dir = (pos2-pos1):GetNormalized()
			
			if style_data.NormalRope then
				render.SetMaterial(self.RopeMat)
				fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, 2 * style_data.RopeScale, Color(40,55,90, 255), Color(40,55,90, 255), 1, 5, 0, 0, 0)
				fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, 2 * style_data.RopeScale, Color(40,55,90, 255), Color(40,55,90, 255), 1, 5, 0, 0, 0)
			end
			
			if style_data.GlowRope then
				local teamColour = style_data.ColourOverride or team.GetColor(ply:Team())
				
			
				local offset =  EyeAngles():Forward() * -0.05
			
				teamColour.a = 200
				render.SetMaterial(self.DistortedMat)
				fusion.cl.DrawBeam(pos1 + offset, pos2 + offset, -dir, dir, 0, 4, 2.5 * style_data.RopeScale, teamColour, teamColour, 1, 10, CurTime() * 10, 0, 0)
				
				teamColour.a = 100
				render.SetMaterial(self.BeamMat)
				fusion.cl.DrawBeam(pos1 + offset, pos2 + offset, -dir, dir, 0, 4, 50 * style_data.RopeScale, teamColour, teamColour, 1, 10, CurTime() * 10, 0, 0)
				
				teamColour.a = 12
				render.SetMaterial(self.SplodeMat)
				render.DrawSprite(pos1, style_data.RopeScale * 12, style_data.RopeScale * 12, teamColour)				
				render.DrawSprite(pos2, style_data.RopeScale * 12, style_data.RopeScale * 12, teamColour)
				
				-- fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, 2 * style_data.RopeScale, Color(40,55,90, 255), Color(40,55,90, 255), 1, 5, 0, 0, 0)
			end
			
			if style_data.EnergyRope then

				local teamColour = style_data.ColourOverride or team.GetColor(ply:Team())
			
				-- teamColour.a = 100 * style_data.RopeScale
				-- render.SetMaterial(self.BeamMat)
				-- fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, style_data.RopeScale * 20, teamColour, teamColour, 1, 10, 0, 0, 0)
				
				-- teamColour.a = 255 * style_data.RopeScale
				-- render.SetMaterial(self.BeamMat)
				-- fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, style_data.RopeScale * 10, teamColour, teamColour, 1, 10, 0, 0, 0)
				
				
				-- render.SetMaterial(self.SplodeMat2)
				-- fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 12, style_data.RopeScale * 3, teamColour, teamColour, 1, 3, CurTime() * 30, 0, 0)		
				
				teamColour.a = 50
				render.SetMaterial(self.DistortedMat)
				fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, style_data.RopeScale * 4, teamColour, teamColour, 1, 10, CurTime() * 5, 0, 0)
				
				
				teamColour.a = 255
				render.SetMaterial(self.DistortedMat)
				fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, style_data.RopeScale * 2, teamColour, teamColour, 1, 10, CurTime() * 10, 0, 0)
				
				-- teamColour.a = 255
				-- render.SetMaterial(self.SmokeMat)
				-- fusion.cl.DrawBeam(pos1, pos2, -dir, dir, 0, 4, style_data.RopeScale * 200, teamColour, teamColour, 1, 10, 0, 0, 0)
				
				
				
				teamColour.a = 255
				render.SetMaterial(self.SplodeMat2)
				render.DrawSprite(pos1, style_data.RopeScale * 7, style_data.RopeScale * 7, teamColour)
				
				teamColour.a = 12 * style_data.RopeScale
				render.SetMaterial(self.SplodeMat)
				render.DrawSprite(pos1, style_data.RopeScale * 46, style_data.RopeScale * 46, teamColour)
				
			end
			
			
			if self.GetIsMumma and self:GetIsMumma() and self:GetHitNormal() then
				local pos = self:GetPos()
				local hitNormal = self:GetHitNormal()
				
				cam.Start3D2D(pos, EyeAngles(), 1)
				
					
				
				cam.End3D2D()
			end
		
		end
				
	end
	
	function ENT:Draw()
	
	
		self:DrawModel(true)
		
		-- draw_me(self)
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