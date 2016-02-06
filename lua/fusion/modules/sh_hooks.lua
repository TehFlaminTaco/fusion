styles = {}
-- styles[1] = {
	-- Model = "models/items/combine_rifle_ammo01.mdl",
	-- NormalRope = true,
	-- EnergyRope = true,
	-- ColourOverride = false,
	-- RopeScale = 2,
	-- HitEffect = function(ent)
		-- local effectdata = EffectData()
		-- effectdata:SetEntity(ent)
		-- effectdata:SetMagnitude(1)
		-- util.Effect( "ropehit", effectdata )
	-- end,
	-- RopeRate = 300,
	-- BabyRadius = 20,
	-- NumBabies = 3,
	-- HookSpeed = 16000,
	-- AccelRate = 300
-- }

-- styles[5] = {
	-- Model = "models/props_junk/cinderblock01a.mdl",
	-- NormalRope = true,
	-- EnergyRope = true,
	-- ColourOverride = false,
	-- RopeScale = 2,	
	-- HitEffect = function(ent)
		-- local effectdata = EffectData()
		-- effectdata:SetEntity(ent)
		-- effectdata:SetMagnitude(2)
		-- util.Effect( "ropehit", effectdata )
	-- end,
	-- RopeRate = 300,
	-- BabyRadius = 25,
	-- NumBabies = 0,
	-- HookSpeed = 3000,
	-- AccelRate = 100
-- }



local mult = 1
local multAdd = 0.3
local base_RopeRate = 2000
local base_HookSpeed = 3000

styles["default"] = {
	Model = "models/props_junk/harpoon002a.mdl",
	NormalRope = true,
	-- EnergyRope = true,
	ColourOverride = false,
	RopeScale = 0.5,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(2)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	-- BabyRadius = 24, //36,
	-- NumBabies = 0, //19,
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = false,
	RopeOffset = Vector(-45,0,0),
	ModelScale = 0.3,
	AngleOffset = Angle(180,0,0),
	Hierarchy = 0
}

mult = mult + multAdd
styles["skulls"] = {
	Model = "models/Gibs/HGIBS.mdl",
	NormalRope = true,
	GlowRope = true,
	-- EnergyRope = true,
	ColourOverride = false,
	RopeScale = 0.3,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(2)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	BabyRadius = 35,
	BabyHeight = 15,
	NumBabies = 8,	
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	BabyAlignHooked = true,
	RopeOffset = Vector(0,0,0),
	ModelScale = 1,
	AngleOffset = Angle(0,0,0),
	Hierarchy = 20
}

mult = mult + multAdd
styles["prongs"] = {
	Model = "models/props_wasteland/panel_leverHandle001a.mdl",
	NormalRope = true,
	-- EnergyRope = true,
	ColourOverride = false,
	RopeScale = 1,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(2)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	-- BabyRadius = 24, //36,
	-- NumBabies = 0, //19,
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	RopeOffset = Vector(2,0,9),
	ModelScale = 1,
	AngleOffset = Angle(90,0,0),
	Hierarchy = 10
}

mult = mult + multAdd
styles["cone"] = {
	Model = "models/props_junk/TrafficCone001a.mdl",
	NormalRope = true,
	-- EnergyRope = true,
	ColourOverride = false,
	RopeScale = 0.4,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(2)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	-- BabyRadius = 12, //36,
	-- NumBabies = 0, //19,
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	RopeOffset = Vector(6,0,-15),
	ModelOffset = Vector(0,0,2),
	ModelScale = 0.2,
	AngleOffset = Angle(-90,0,0),
	Hierarchy = 10
}

-- mult = mult + multAdd
-- styles["lamp"] = {
	-- Model = "models/props_wasteland/prison_lamp001c.mdl",
	-- NormalRope = true,
	-- GlowRope = true,
	-- ColourOverride = false,
	-- RopeScale = 0.3,
	-- HitEffect = function(ent)
		-- local effectdata = EffectData()
		-- effectdata:SetEntity(ent)
		-- effectdata:SetMagnitude(2)
		-- util.Effect( "ropehit", effectdata )
	-- end,
	-- RopeRate = base_RopeRate,
	-- BabyRadius = 12,
	-- BabyHeight = 3,
	-- NumBabies = 3,	
	-- HookSpeed = base_HookSpeed * mult,
	-- AlignHooked = true,
	-- RopeOffset = Vector(0,0,5),
	-- ModelOffset = Vector(0,0,4),
	-- ModelScale = 0.5,
	-- AngleOffset = Angle(90,0,0),
	-- Hierarchy = 10
-- }

mult = mult + multAdd
styles["harpoons"] = {
	Model = "models/props_junk/harpoon002a.mdl",
	NormalRope = true,
	-- EnergyRope = true,
	GlowRope = true,
	-- ColourOverride = Color(0,255,150),
	
	RopeScale = 0.2,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(2)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	BabyRadius = 20,
	BabyHeight = 0,
	NumBabies = 6,	
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	RopeOffset = Vector(-45,0,0),
	ModelScale = 0.2,
	AngleOffset = Angle(180,0,0),
	Hierarchy = 0
}

mult = mult + multAdd
styles["plasma_web"] = {
	Model = "models/props_lab/tpplug.mdl",
	-- NormalRope = true,
	EnergyRope = true,
	ColourOverride = false,
	RopeScale = 1,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(1)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	BabyRadius = 35,
	BabyHeight = 0,
	NumBabies = 4,	
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	-- BabyAlignHooked = true,
	RopeOffset = Vector(0,0,0),
	ModelOffset = Vector(-5,0,0),
	ModelScale = 0.5,
	AngleOffset = Angle(180,0,0),
	Hierarchy = 30
}

mult = mult + multAdd
styles["plasma_web2"] = {
	Model = "models/items/combine_rifle_ammo01.mdl",
	-- NormalRope = true,
	EnergyRope = true,
	ColourOverride = false,
	RopeScale = 0.5,
	HitEffect = function(ent)
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetMagnitude(1)
		util.Effect( "ropehit", effectdata )
	end,
	RopeRate = base_RopeRate,
	BabyRadius = 25,
	BabyHeight = 0,
	NumBabies = 12,	
	HookSpeed = base_HookSpeed * mult,
	AlignHooked = true,
	RopeOffset = Vector(0,0,12),
	-- ModelOffset = Vector(0,0,-35),
	ModelScale = 0.4,
	AngleOffset = Angle(90,0,0),
	Hierarchy = 60
}


if SERVER then
	
	function fusion.CanUseHook(ply, style)
		local data = styles[style]
		
		if data then 
			if data.Hierarchy and ply.Hierarchy and ply.Hierarchy >= data.Hierarchy then
				return true
			end	
			
			-- if ply.HasItem(style) then
				-- return true
			-- end			
			
		end
		
		return false		
	end
	
	
end

-- styles[7] = {
	-- Model = "models/props_lab/tpplug.mdl",
	-- NormalRope = true,
	-- EnergyRope = true,
	-- ColourOverride = false,
	-- RopeScale = 2,
	-- HitEffect = function(ent)
		-- local effectdata = EffectData()
		-- effectdata:SetEntity(ent)
		-- effectdata:SetMagnitude(1)
		-- util.Effect( "ropehit", effectdata )
	-- end,
	-- RopeRate = 200,
	-- BabyRadius = 12,
	-- NumBabies = 0,
	-- HookSpeed = 16000,
	-- AccelRate = 300,
	-- Aligns = true 
-- }


-- styles[8] = {
	-- Model = "models/props_junk/shoe001a.mdl",
	-- NormalRope = true,
	-- EnergyRope = true,
	-- ColourOverride = false,
	-- RopeScale = 2,
	-- HitEffect = function(ent)
		-- local effectdata = EffectData()
		-- effectdata:SetOrigin(ent:GetPos())
		-- effectdata:SetStart(ent:GetPos())
		-- util.Effect( "cball_explode", effectdata )
	-- end,
	-- RopeRate = 100,
	-- BabyRadius = 25,
	-- NumBabies = 3,
	-- HookSpeed = 3000,
	-- AccelRate = 200,
	-- Aligns = false,
	-- Spin = Angle(15,0,0)
-- }

if CLIENT then
	net.Receive( "fusion_HookTarget", function(len)	
		local target = net.ReadEntity()	
		LocalPlayer().HookTarget = target
	end	)
else
	function fusion.SetHookTarget(ply, target)
		ply.HookTarget = target
		
		net.Start("fusion_HookTarget")
		net.WriteEntity(target)
		net.Send(ply)
	end
end

-- function fusion.GetGravity(ent)
	-- local gravity = physenv.GetGravity()
	 
-- end



hook.Add("Move", "fusion_move", function( ply, mv )

	local frametime = FrameTime()
	-- if ( mv:KeyDown( IN_SPEED ) ) then speed = 0.005 * FrameTime() end


	-- local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	local vel_len = vel:Length()
	if (ply.HookTarget and ply.HookTarget:IsValid() and ply.HookTarget.GetStyle) then
	
		local h = ply.HookTarget
	
		local style = h:GetStyle()
		local style_data = styles[style]
	
		
	
		local pos1 = ply:GetPos()
		local pos2 = h:GetPos()
		
		local dir = (pos2-pos1):GetNormalized()
		local dist = (pos2-pos1):Length()
		
		local roadshow = ply:GetVelocity():Length()
	
		local hang_min =0// 50
		local hang_max =0// 100
	
		
		if SERVER then
			local cur = h:GetHangLength() or hang_min
			-- HangLength
			h.HangLength = (h.HangLength or hang_max)

			-- local snap = ply:KeyDown(IN_FORWARD)
		
			if snap then
				h:SetHangLength(hang_min) //math.Approach(cur, 0, 5))
			else
				h:SetHangLength(hang_max)
			end
		end
		
		-- prEDint(ply.HangLength)
		local stop_dist = h:GetHangLength() or hang_min
		  //roadshow * 0.05 + 5
		local isTowed = false
	
		local parent = h:GetParent()
	
		local addVel = Vector(0,0,0)
		-- local parentVel = 0
		-- local minVel = (3000*frametime)
		
		local speed = 0
		
		local parentVel = 0
		
		if parent and parent:IsValid() then
			-- stop_dist = 150
			isTowed = true	
			parentVel = parent:GetVelocity():Length()
			-- addVel = parent:GetVelocity() * 0.05 //* frametime
		end
		
		local w,s,a,d, shift = ply:KeyDown(IN_FORWARD), ply:KeyDown(IN_BACK), ply:KeyDown(IN_MOVELEFT), ply:KeyDown(IN_MOVERIGHT), ply:KeyDown(IN_SPEED)
		local space, ctrl = ply:KeyDown(IN_JUMP), ply:KeyDown(IN_DUCK)
		
		local temp = nil
		local dot = dir:Dot(ply:GetAimVector())
		
		if dot < 0 then
			-- temp = s
			-- s = w
			-- w = temp
			
			temp = a
			a = d
			d = temp
			
			temp = space
			space = ctrl
			ctrl = temp
		end
		
		
		if (w or s or a or d or space or alt) then

		else
			addVel = addVel + Vector(0,0,-1000)
		end
		
		-- print(dot)
		
		local bounce = false
		if w or s then
			if w then
				speed = speed + style_data.HookSpeed * 0.07
			end
			
			if s then
				speed = speed - style_data.HookSpeed * 0.07
			end
			
			bounce = true
		elseif isTowed and dist > 200 and parentVel > 0 then
			speed = speed + (style_data.HookSpeed * 0.07 * math.min(1, (dist-500)/1000))
			bounce = true
		end
		
		if shift then
			speed = speed * 1.5
		end
		
		
		
		-- if (dist < 200) then
			-- speed = 0
		-- end
		
		local mu = 0.5
		
		local dirang = dir:Angle()
		if d then			
			addVel = addVel + dirang:Right() * (style_data.HookSpeed * mu)
			bounce = true
		end
		
		if a then			
			addVel = addVel + dirang:Right() * -(style_data.HookSpeed * mu)
			bounce = true
		end
		
		if space then			
			addVel = addVel + dirang:Up() * (style_data.HookSpeed * mu)
			bounce = true	
		end
		
		if ctrl then			
			addVel = addVel + dirang:Up() * -(style_data.HookSpeed * mu)
			bounce = true
		end
	
		-- local decel = (vel*0.5) * (frametime * 60) // 0.7
		-- local decel = (vel*1) * math.min(frametime * 25) // 0.7
		
		local decel = mv:GetVelocity() * 0.98 
		
		-- if dist < 50 then
			-- decel = mv:GetVelocity() *  0
		-- end
		
		local bump = Vector(0,0,0)
		
		
		
		
		
		
		
		-- local parent_pos = parent:GetPos()
		local dir = (pos2-pos):GetNormalized()
		local toPos = pos2 + (dir * -stop_dist)
		-- local dist = toPos:Distance(pos)
		
		
		-- vel = (toPos-pos) * frametime * (speed*0.01) * 2

		local len = decel:Length()
		-- local m = 10
		local mul = 8//math.min(len / m, 1) * m
		
		-- if dist < 100 then
			-- mul = 5
		-- end
		
		-- if dist < stop_dist*1.5 then
			-- mul = mul * 0.05
		-- if dist < stop_dist*1.1 then
			-- toPos = pos2 + Vector(0,0,-stop_dist)
		-- end
				
		local dir = (toPos-pos):GetNormalized()	// * 0.2	
		local dist2 = toPos:Distance(pos)
		
		local amount = (math.Clamp(dist2/10,0, 1) * frametime * speed * mul )
		
		
		vel = dir * amount + decel
		
		
		local bopDist = math.abs(style_data.HookSpeed * 0.1)
		
		if ply:IsOnGround() and (bounce) then //and dist > stop_dist then
			bump = ply:GetUp() * bopDist * 30 * frametime
			-- print("asdads")
		elseif roadshow < 100 and dist > stop_dist  then
			bump = ply:GetUp() * bopDist * 1 * frametime
		end

		
		
		local dist = pos2:Distance(pos)
		if dist2 < stop_dist then //and !snap then
			-- vel = dir * amount * 0.1 + mv:GetVelocity() * 0.95 //0.95
		end
		
		if dist < stop_dist * 2 then
			vel = dir * amount * 0.1 + mv:GetVelocity() * 0.99 //+ Vector(0,0,-1000*frametime)
		end
		
		if dist < stop_dist then
			-- vel = dir * amount*3 + mv:GetVelocity() * 0.1 //0.95
			
			-- local div = dist2 / 100
			
			-- vel = mv:GetVelocity()
			
			vel =  mv:GetVelocity() * 0.99
		end
		
		-- if dist2 < 2 then
			-- vel = dir * amount * 10 + mv:GetVelocity() * 0 //0.95
		-- end
		
		//local gravity_real = -physenv.GetGravity() * frametime * 0//0.999
		
		local vel = vel + addVel*frametime + bump //+ gravity_real
		
		-- if ply:IsOnGround() then
			-- vel = vel * 2
		-- end
		
		mv:SetVelocity( vel )//+ Vector(0,0,-1000 * frametime) )
	
		
		if SERVER then
			local launcher = ply.HookTarget.Launcher
			local pitch = math.min(5 + roadshow * 0.05, 255)
			
			if dist2 < stop_dist then
				pitch = 0
			end
			
			launcher.Sound:ChangePitch(pitch, 0)
			
			-- ply:SetVelocity(vel)
		end
	end

end)

function fusion.GetHookerPosAng(ply)
	-- local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local pos, ang = ply:GetBonePosition(0)
	
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Right(), 90)
	
	return pos + ang:Forward() * 2, ang //+ ang:Up() * -3 + ang:Right() * -3, ang
end

local function shouldHookCollide(ent1, ent2)
	local class1 = ent1:GetClass()
	local class2 = ent2:GetClass()
	
	if (class1 == "hook" and class2 == "player") or (class2 == "hook" and class1 == "player") then
		return false
	end
end

hook.Add("ShouldCollide", "HookCollision", function(ent1, ent2)
	-- local class1 = ent1:GetClass()
	-- local class2 = ent2:GetClass()
	
	-- if class1 == "hook" then
		-- if !shouldHookCollide(ent1, ent2) then
			-- return false
		-- end
		return shouldHookCollide(ent1, ent2)
	-- elseif class2 == "hook" then
		-- if !shouldHookCollide(ent2, ent1) then
			-- return false
		-- end
		-- return shouldHookCollide(ent2, ent1)
	-- end
end)

