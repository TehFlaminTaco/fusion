function hookToPos(ply, aimpos, normal, hook_type)
	
	local normang = normal:Angle()
	
	local tp_pos = aimpos + normal * -5
	ply:ExitVehicle()
	
	
	local start_pos, orig_direction = fusion.GetHookerPosAng(ply)
	-- local orig_direction = ply:EyeAngles()
	
	
	if aimpos then
		orig_direction = (aimpos-start_pos):GetNormalized():Angle()
	end
	
	
	
	local direction = orig_direction	
	local style = styles[hook_type]

	
	if ply.Harpoon and ply.Harpoon:IsValid() then
		ply.Harpoon:Delete()
	   // ply:EmitSound("physics/surfaces/underwater_impact_bullet3.wav", 100, 110)
		return false
	end
	
	ply.HookTimer = CurTime() + 999
		
	local pos, direction = LocalToWorld( Vector(0,0,0), (style.AngleOffset or Angle(0,0,0)) + Angle(180,0,0), start_pos, direction )

	local harpoon = ents.Create("hook")		

	harpoon:SetModel(style.Model)
	harpoon:SetPos(start_pos)
	harpoon:SetAngles(direction)
	harpoon:Spawn()
	constraint.NoCollide(harpoon, ply)
		-- harpoon:SetNotSolid(true)
	
	harpoon.NumBabies = 5
	
	harpoon:SetStyle(hook_type)
	harpoon:SetRopeTarget(harpoon)
	harpoon:SetMoveAngles(orig_direction)
	harpoon:SetIsHooked(false)
	harpoon:SetPlayer(ply)
	harpoon.IsPuller = true
	
	harpoon:SetIsMumma(true)
	
	 

	
	-- harpoon:SpawnBabies(aimpos, normang, style.BabyRadius, style.NumBabies)
	harpoon:SpawnLauncher()
	
	
	ply.Harpoon = harpoon
	ply:EmitSound("npc/antlion/shell_impact3.wav", 100, 80)	
	
	return true
	
end

function fusion.setHookType(ply, hooktype)
	fusion.sv.SetData(ply, "hook", hooktype)
	ply.HookType = hooktype
	fusion.NetworkVar(ply, "hook", hooktype)
end

fusion.commands["hook"] = {
	Name = "Hook",	
	Hierarchy = 0,
	Category = "utility",
	Args = 0,
	Help = "Hook in son!",
	//Message = "%s hooked %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		-- local name = args[1] or "<self>"
		local style = "default"		
		
		if ply.HookType and styles[ply.HookType] then
			style = ply.HookType
		end		
		local style_data = styles[style]	
		
		if (ply.Jailed) then
			fusion.Message( ply, "You cannot hook while jailed!" )
			return
		end	

		if (ply.Harpoon and ply.Harpoon:IsValid()) then
			ply.Harpoon:Delete()
			return
		end
		
		if (ply.HookTimer and CurTime() < ply.HookTimer) then
			-- fusion.Message( ply, "You cannot hook while jailed!" )
			return
		end

		
		
		local aimpos = ply:GetEyeTrace().HitPos
		local normal = ply:GetEyeTrace().HitNormal
		local hitent = ply:GetEyeTrace().Entity		
		
		aimpos = aimpos
		
		local UniqueIDs = {}
		
		-- fusion.Message(ply, style)
		
		-- local players = fusion.sv.GetPlayers( ply, cmd, name )
		-- if players then			
			-- for k,v in pairs( players ) do
				if !aimpos and util.IsInWorld(aimpos) then return false end
				-- if !normal then return false end
				-- if !hitent or !hitent:IsValid() then return false end
				
				if hookToPos(ply, aimpos, normal, style) then
					
				end
				
				
				-- table.insert( UniqueIDs, fusion.PlayerMarkup( ply ) )
			-- end
		-- end

		-- if fusion.sh.TableHasData( UniqueIDs ) then		
			-- local tarstring = string.Implode( ", ", UniqueIDs )
			-- if tarstring != ( fusion.PlayerMarkup( ply ) ) then
				-- local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				-- fusion.CMDMessage( msg, ply, cmd )			
			-- end	
		-- end	
	end	
}

fusion.commands["unhook"] = {
	Name = "Unhook",	
	Hierarchy = 90,
	Category = "utility",
	Args = 0,
	Help = "I could be a hooker?!",
	Message = "%s unhooked %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1] or "<self>"
		
		if (ply.Jailed) then
			fusion.Message( ply, "You cannot hook while jailed!" )
			return
		end
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				local tp_pos = aimpos
								
				if (v.Harpoon and v.Harpoon:IsValid()) then
					v.Harpoon:Delete()
					-- ply:EmitSound("physics/surfaces/underwater_impact_bullet3.wav", 100, 110)
				end
								
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			if tarstring != ( fusion.PlayerMarkup( ply ) ) then
				local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
				fusion.CMDMessage( msg, ply, cmd )			
			end	
		end	
	end	
}