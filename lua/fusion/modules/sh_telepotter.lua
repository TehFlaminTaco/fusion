--[[ 
	Modules:
		Telepotter
	
	Description:
		
 ]]
 
 
fusion.TelepotterLocations = {}

fusion.commands["warp"] = {
	Name = "Warp to Telepotter Location",	
	Hierarchy = 0,
	Category = "telepotter",
	Args = 1,
	Help = "Warps to a telepotter location.",
	Message = "%s warped to '%s'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message

		local name = args[1]
		
		if args[1] then
			-- for k,v in pairs() do
			-- local tp_pos = aimpos
			-- fusion.sv.TeleportEffect( v, tp_pos )
			-- end
			
			local pos, ang = fusion.GetTelepotterPosition(name)
			
			if (pos and ang) then
				fusion.sv.TeleportEffect( ply, pos )
				ply:SetEyeAngles( ang )
			end
			
			
		end

		-- local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		-- fusion.CMDMessage( msg, ply, cmd )			
	end	
}

fusion.commands["addtelepotter"] = {
	Name = "Add Telepotter Location",	
	Hierarchy = 99,
	Category = "telepotter",
	Args = 1,
	Help = "Adds a location to telepotter.",
	Message = "%s added a location to telepotter with the name '%s'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message		

		local name = args[1] or "unknown"
		
		local pos = ply:GetPos()
		local ang = ply:EyeAngles()
		fusion.AddTelepotterLocation(pos, ang, name)

		local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
		fusion.CMDMessage( msg, ply, cmd )			
	end	
}

fusion.commands["removetelepotter"] = {
	Name = "Remove Telepotter Location",	
	Hierarchy = 80,
	Category = "telepotter",
	Args = 1,
	Help = "Removes a location from telepotter.",
	Message = "%s removed a location from telepotter with the name '%s'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message		

		local remove = args[1]
		
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			local data = file.Read( fusion.GetTelepotterFile(), "DATA" )		
			local fi = string.Explode( "|", data)	
			
			local pos = Vector(0,0,0)
			local ang = Angle(0,0,0)
			
			if #fi > 0 then	
				for i = 1, #fi do					
					local split = string.Explode(";", fi[i])
					if #split == 8 then						
						if split[2] == remove then							
							table.remove(fi, i)
						end
					end
				end
			end
			
			local newData = table.concat(fi, "|", 1, #fi)
			
			file.Write( fusion.GetTelepotterFile(), newData)		
		else
			fusion.Message(ply, "Telepotter map file not found.")
			return
		end

		local msg = string.format( message, fusion.PlayerMarkup( ply ), remove )
		fusion.CMDMessage( msg, ply, cmd )			
	end	
}


if SERVER then

	function fusion.GetRandomTelepotter()
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			local data = file.Read( fusion.GetTelepotterFile(), "DATA" )		
			local fi = string.Explode( "|", data)	
			
			local pos = Vector(0,0,0)
			local ang = Angle(0,0,0)
			
			if #fi > 0 then	
				local random = table.Random(fi)					
				local split = string.Explode(";", random)
				if #split == 8 then	
					name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll = split[2], split[3], split[4], split[5], split[6], split[7]
	
					return pos, ang
				end
			end
		end
	end

	function fusion.GetTelepotterPosition(get)

		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			local data = file.Read( fusion.GetTelepotterFile(), "DATA" )		
			local fi = string.Explode( "|", data)	
			
			local pos = Vector(0,0,0)
			local ang = Angle(0,0,0)
			
			if #fi > 0 then	
				for i = 1, #fi do					
					local split = string.Explode(";", fi[i])
					if #split == 8 then	
						name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll = split[2], split[3], split[4], split[5], split[6], split[7]
					
						if name == get then
							return pos, ang
						end
					end
				end
			end
		end
		
		return false
	end

	function fusion.SaveTelepotter()
	
		local data = ""
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			data = file.Read( fusion.GetTelepotterFile(), "DATA" )
		end	
	
		
		local fi = string.Implode( "|", data)	
	
		
	
		-- for i = 1, # do
			-- local data = fusion.TelepotterLocations[i]
			
		-- end
		
		
		
	end

	function fusion.GetTelepotterFile()
		local map = game.GetMap()
		
		return "fusion/telepotter/" .. map .. ".txt"
	end

	function fusion.AddTelepotterLocation(pos, ang, name)		
		-- local fi = {}	
		local data = ""
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			data = file.Read( fusion.GetTelepotterFile(), "DATA" )
		end	
		
		-- local fi = string.Explode( "|", data)	
	
		-- table.insert(fi, string.Implode(";", {"T1", name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll}))
				
		file.Write(fusion.GetTelepotterFile(), data .. "|" .. string.Implode(";", {"T1", name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll})) // string.Implode( "|", fi ) )
				
				
		
		-- table.insert(fusion.TelepotterLocations, {name=name, pos=pos, ang=ang})
		
		-- fusion.UpdateTelepotterLocations()

		return true	
	end	
	
	function fusion.UpdateTelepotterLocations()			
		local fi = {}
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			fi = string.Explode( "|", file.Read( fusion.GetTelepotterFile(), "DATA" ) )
		end	
		
		local type = ""
		local name = ""
		local pos = Vector(0,0,0)
		local ang = Angle(0,0,0)
		
		fusion.TelepotterLocations = {}
		
		if (#fi > 0) then
			for i = 1, #fi do				
				
				local str = fi[i]
				local split = string.Explode(";", str)
				
				-- print("str")
				
				-- type = split[1]
				
				-- if (type == "T1") then
					name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll = split[2], split[3], split[4], split[5], split[6], split[7]
					
					table.insert(fusion.TelepotterLocations, {name=name, pos=pos, ang=ang})
				-- end
				 
			end
		end		
	end
	

	-- fusion.telepotterTimer = 0
	-- fusion.telepotterTimer = 0
	function fusion.SendTelepotterLocations(ply)
		local data = ""
		
		if file.Exists( fusion.GetTelepotterFile(), "DATA" ) then
			data = file.Read( fusion.GetTelepotterFile(), "DATA" )
		end	
			
			
		net.Start( "fusion_telepotter" )
		net.WriteString(data)
		net.Send(ply)
		
	end
	concommand.Add("network_telepotter", fusion.SendTelepotterLocations)

else

	net.Receive( "fusion_telepotter", function( data )
		-- local db = net.ReadTable()
		local data = net.ReadString()
		-- local pos = net.ReadVector()
		-- local ang = net.ReadAngle()	
		
		
		
		local lines = string.Explode("|", data)
		table.Empty(fusion.TelepotterLocations)
		
		-- print(#lines)
		
		for i = 1, #lines do			
			local vars = string.Explode(";", lines[i])
			
			-- ori
			
			if (#vars == 8) then
			
				local type = ""
				local name = ""
				local pos = Vector(0,0,0)
				local ang = Angle(0,0,0)
		
			
				
				-- print()
				
				name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll = vars[2], vars[3], vars[4], vars[5], vars[6], vars[7], vars[8]
				
				-- print(name, pos.x, pos.y, pos.z, ang.pitch, ang.yaw, ang.roll)
				table.insert(fusion.TelepotterLocations, {name=name, pos=pos, ang=ang})
			
			end
		end
		
		
		
		-- PrintTable(db)
		
	end )

	fusion.cl.TelepotterRefreshTime = 0

	
	local warpicon = Material("icon16/telephone.png")
	function fusion.cl.TelepotterInterface()
		
		if (RealTime() >= fusion.cl.TelepotterRefreshTime) then
			fusion.cl.TelepotterRefreshTime = RealTime() + 3
			
			RunConsoleCommand("network_telepotter")
		end
	
		local teleset = fusion.TelepotterLocations or {}

		local paneHeight = math.max(1,#teleset) * 20
		
		// local x,y,w,h = x+30,y + h/2 - paneHeight/2, 250, paneHeight
		
		local w,h = 250, paneHeight
		
		local x,y = ScrW() / 2 - w/2, ScrH() / 2 - paneHeight/2
		
	

		-- print(x,y,w,h)

		draw.RoundedBox(2, x,y,w,h, Color(50,50,50,150))

		
		
		if #teleset < 1 then
			draw.DrawText("Populating location list...", "SBNormal", x + 5+1, y + 2+1, Color( 0, 0, 0, 150 ) )	
			draw.DrawText("Populating location list...", "SBNormal", x + 5, y + 2, Color( 255, 255, 255, 255 ) )	
		else
			 for i = 1, #teleset do
				local loc = teleset[i]
			 
				//local x,y,w,h = x+1,y+1,w-2,18
			 
				draw.RoundedBox(2, x+1,y+1,w-2,18, Color(50,50,50,150)) 
			 
				if loc and loc != "" then
				
					-- PrintTable(loc)
				 
					if (mouseInRegion(x+1,y+1,w-2,18, 60)) then
						draw.RoundedBox(2, x+1,y+1,w-2,18, Color(50,50,50,150)) 
						draw.DrawText("Warp", "SBNormal", x + w - 24+1, y + 2+1, Color( 0, 0, 0, 150 ) , TEXT_ALIGN_RIGHT)
						draw.DrawText("Warp", "SBNormal", x + w - 24, y + 2, Color( 255, 255, 255, 255 ) , TEXT_ALIGN_RIGHT)
						
						surface.SetDrawColor(Color(255,255,255,255))
						surface.SetMaterial(warpicon)	
						surface.DrawTexturedRect(x + w-16 - 4,y+1,16,16)
						
						
						local pos = loc.pos
						local scr = pos:ToScreen()
						
						local buffer = 100
						
						-- scr = Vector(math.Clamp(buffer, ScrW() - buffer, scr.x), math.Clamp(buffer, ScrH() - buffer, scr.y))
						
						surface.SetDrawColor(Color(255,255,255,100))
						surface.DrawLine(scr.x, scr.y, x + w-16 - 4 + 8,y+1 + 8)
						
						draw.RoundedBox(2, scr.x-3, scr.y-3,7,7, Color(255,255,255,100)) 
						
						if (fusion.cl.IsMousePressed(MOUSE_LEFT)) then
							RunConsoleCommand("fusion", "warp", loc.name)
						end
						
						if (fusion.cl.IsMousePressed(MOUSE_RIGHT)) then
							RunConsoleCommand("fusion", "removetelepotter", loc.name)
						end
						
					end
				 
					if (loc.name) then
					draw.DrawText(loc.name, "SBBold", x + 5+1, y + 2+1, Color( 0, 0, 0, 150 ) )	
					draw.DrawText(loc.name, "SBBold", x + 5, y + 2, Color( 255, 255, 255, 255 ) )	
					end		
							
					y = y + 20
				end
			 end
		end	
		
	end
end