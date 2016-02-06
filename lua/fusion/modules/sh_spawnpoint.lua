--[[ 
	Modules:
		Spawnpoint
	
	Description:
		Adds the bility to set the spawnpoint of players, including the ability to set the default spawnpoint for each map.
 ]]
 
 
 
fusion.Spawnpoint = {}
if SERVER then
	
	
	fusion.commands["spawnpoint"] = {
		Name = "Set Spawnpoint",	
		Hierarchy = 0,
		Category = "spawnpoint",
		Args = 0,
		Help = "Set your spawnpoint.",
		Message = "%s set their spawn point",
		Function = function( ply, cmd, args )
			local message = fusion.commands[cmd].Message	
			local optional = args[1]
			
			if optional and optional == "clear" then
				message = "%s cleared their spawnpoint"		
			end
			
			UniqueIDs = {}
		
			if optional and optional == "clear" then
				fusion.Spawnpoint.ClearSpawnpoint( ply )
			else				
				local pos = ply:GetPos()
				local ang = ply:EyeAngles()
				fusion.Spawnpoint.SetSpawnpoint( ply, pos, ang )									
			end
				
				local tarstring = string.Implode( ", ", UniqueIDs )
				local msg = string.format( message, fusion.PlayerMarkup( ply ) )

				fusion.CMDMessage( msg, ply, cmd )		
		end	
	}
	
	

	-- fusion.commands["mapspawnpoint"] = {
		-- Name = "Set Map Spawnpoint",	
		-- Hierarchy = 80,
		-- Category = "spawnpoint",
		-- Args = 0,
		-- Help = "Set the map's spawnpoint.",
		-- Message = "%s set the map spawnpoint",
		-- Function = function( ply, cmd, args )
			-- local message = fusion.commands[cmd].Message		

			-- local optional = args[1]
			
			-- if optional and optional == "clear" then
				-- fusion.sv.RemoveMapSpawnPoint()
				-- local msg = string.format( "%s cleared the map spawnpoint", fusion.PlayerMarkup( ply ) )
				-- fusion.CMDMessage( msg, ply, cmd )	
				-- return 
			-- end			
			
			-- local pos = ply:GetPos()
			-- local ang = ply:EyeAngles()
			-- fusion.sv.SetMapSpawnPoint( pos, ang )	

			-- local msg = string.format( message, fusion.PlayerMarkup( ply ) )
			-- fusion.CMDMessage( msg, ply, cmd )			
		-- end	
	-- }



	function fusion.Spawnpoint.SetSpawnpoint( ply, vector, ang )
		ply.SpawnPoint = { vector, ang }			
		net.Start( "fusion_Spawnpoint" )
		net.WriteVector( vector )
		net.Send(ply)
	end
	
	function fusion.Spawnpoint.ClearSpawnpoint( ply )
		ply.SpawnPoint = false		
		net.Start( "fusion_Spawnpoint" )
			net.WriteInt(1)
		net.Send(ply)
	end
	
	-- function fusion.sv.GetMapSpawnPoint( map )
		-- if !file.Exists( "fusion/spawnpoints.txt", "DATA" ) then
			-- return false
		-- end
		
		-- local tbl = string.Explode( "\n", file.Read( "fusion/spawnpoints.txt", "DATA" ) )
		
		-- for k,v in pairs( tbl ) do
			-- if string.find( v, map, nil, true ) then
				-- local settings = string.Explode( "=", v )
				-- if settings[2] then
					-- local vector = string.Explode( ",", settings[2] )
					-- if vector[1] and vector[2] and vector[3] and vector[4] and vector[5] then
						-- local x = tonumber(vector[1])					
						-- local y = tonumber(vector[2])
						-- local z = tonumber(vector[3])
						
						-- local p = tonumber(vector[4])					
						-- local yaw = tonumber(vector[5])
						-- local r = 0
						
						-- local vec = Vector( x, y, z ) 
						-- local ang = Angle( p, yaw, r )
						
						print( vec )
						print( ang )
						
						-- return { vec, ang }
					-- end	
				-- end
			-- end
		-- end
		-- return false
	
	-- end
	
	-- function fusion.sv.SetMapSpawnPoint( vec, ang )
		-- local map = game.GetMap()
		
		-- if !file.Exists( "fusion/spawnpoints.txt", "DATA" ) then
			-- file.Write( "fusion/spawnpoints.txt", "" )
		-- end
		
		-- local fi = string.Explode( "\n", file.Read( "fusion/spawnpoints.txt", "DATA" ) )
				
		-- for k,v in pairs( fi ) do
			-- if string.find( v, map, nil, true ) then
				-- table.remove( fi, k )
			-- end
		-- end  
		-- table.insert( fi, map .."=".. vec.x ..",".. vec.y ..",".. vec.z .. "," .. ang.p .. "," .. ang.y )
		-- SetGlobalVector( "mapspawnpoint", vec )
		
		-- fusion.MapSpawnAng = Angle( ang.p, ang.y, 0 )
		-- SetGlobalAngle( "mapspawnangle", fusion.MapSpawnAng )
		
		-- file.Write( "fusion/spawnpoints.txt", string.Implode( "\n", fi ) )
	-- end
	
	-- function fusion.sv.RemoveMapSpawnPoint( map )
		-- local map = map or game.GetMap()
		
		-- if !file.Exists( "fusion/spawnpoints.txt", "DATA" ) then
			-- return
		-- end
		
		-- local fi = string.Explode( "\n", file.Read( "fusion/spawnpoints.txt", "DATA" ) )
		
		
		-- for k,v in pairs( fi ) do
			-- if string.find( v, map, nil, true ) then
				-- table.remove( fi, k )
			-- end
		-- end	
		
		-- SetGlobalVector( "mapspawnpoint", Vector( 0, 0, 0 ) )
		-- SetGlobalAngle( "mapspawnangle", Angle(0,0,0) )
		
		-- file.Write( "fusion/spawnpoints.txt", string.Implode( "\n", fi ) )
	-- end
	
	// Spawn Handling
	-- hook.Add( "InitPostEntity", "fusion.sv.MapSpawnPointCheck", function( )
		-- local spawn = fusion.sv.GetMapSpawnPoint( game.GetMap() )
		
		-- if spawn then
			-- SetGlobalVector( "mapspawnpoint", spawn[1] )
			-- SetGlobalAngle( "mapspawnangle", spawn[2] )
			-- fusion.MapSpawnAng = spawn[2]
			-- print( "[Fusion] Spawnpoint for " .. game.GetMap() .. " found." )
		-- end	
		
	-- end )
	
	// Spawn Handling
	function fusion.sv.doSpawnpoint(ply)
		RunConsoleCommand("network_telepotter")
		
		if ply.Jailed and ply.Caged and IsValid( fusion.Prison ) then
			ply:SetPos( fusion.Prison:GetPos() - Vector( 0, 0, ( 189.862854 / 2 ) - 15 ) )
			ply:SetEyeAngles( Angle( 0, 0, 0 ) )
						
			ply:StripWeapons()
			ply:StripAmmo()
			
			ply:Give("weapon_crowbar")
			
		elseif ply.JailPos then		
			ply:SetPos( ply.JailPos )	
			ply:SetEyeAngles( Angle( 0, 0, 0 ) )

			-- ply:GodEnable()
			ply:StripWeapons()
		elseif ply.Nerfed then
			ply:StripWeapons()
			
		elseif ply.SpawnPoint then
			ply:SetPos( ply.SpawnPoint[1] )	
			ply:SetEyeAngles( ply.SpawnPoint[2] )
			
			if ply.Godded then
				-- ply:GodEnable()
			end
		else 
			local pos, ang = fusion.GetRandomTelepotter()
			
			if pos and ang then		
				ply:SetPos(pos)
				ply:SetEyeAngles(ang)				
			end
			
			if ply.Godded then
				-- ply:GodEnable()
			end			
		end	
		
		
		
	end
	
end


if CLIENT then

	surface.CreateFont( "test1", 
		{
			font      = "Arial",
			size      = 12,
			weight    = 400 
		}
	)

	surface.CreateFont( "goodFont", 
		{
			font      = "coolvetica",
			size      = 40,
			weight    = 400 
		}
	)
	
	surface.CreateFont( "goodFont2", 
		{
			font      = "Trebuchet",
			size      = 30,
			weight    = 400 
		}
	)
	
	surface.CreateFont( "goodFont3", 
		{
			font      = "Trebuchet",
			size      = 24,
			weight    = 400 
		}
	)

	net.Receive( "fusion_Spawnpoint", function( data )
		local vec = net.ReadVector()
		-- local bool = data:ReadBool() 		
		if vec then
			fusion.SpawnPointPos = vec
		else
			fusion.SpawnPointPos = nil
		end
	end )
	
	fusion.SpawnPointBounce = 0
	fusion.SpawnPointBounceDir = "Up"

	local function drawBillboard(hidePanels, alpMult)
		surface.SetFont("goodFont") 
		local text = "Welcome to " .. GetHostName() .. " kiddo,\nyou're playing " .. gmod.GetGamemode().Name ..  " on " .. game.GetMap( ) .. "!"
		
		local w, h = surface.GetTextSize(text)

		local curtime = CurTime()

		w = w + 50
		h = h + 50			
		
		if !hidePanels then
			draw.RoundedBox(0, -w/2, -25, w, h, Color(0,0,0,200*alpMult))
			
			surface.SetDrawColor(Color(0,0,0,150*alpMult))
			
			surface.DrawOutlinedRect(-w/2 - 5, -25 - 5, w + 10, h + 10, Color(0,0,0,255*alpMult))
			
			
			for i = 1, (w/10) do
				local sine = math.abs(math.sin(curtime + i))
				
				local height = 60 * sine
				
				local colour = Color(0, 255 - 255 * sine, 255 * sine, 200*alpMult)
				
				draw.RoundedBox(0, -w/2 + (i * 10) - 5 + 1, -(35+height) + 1, 5, height, Color(0,0,0,200*alpMult))
				draw.RoundedBox(0, -w/2 + (i * 10) - 5, -(35+height), 5, height, colour)
			end
		end
		
		-- local tbl = chatbox.WordWrap(text, w-50, " ")		
		draw.DrawText(text, "goodFont", -w/2 + 25, 0, Color(255, 255, 255, 255*alpMult), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		
		surface.SetFont("goodFont2")
		-- local text2 = "We're Inervate, a close-knit gaming community that has been on the scene since 2008. Don't be a nasty pasty and we'll get along like a house on fire.\nThanks for playing on our server, be sure to stop by again!"
		local text2 = "We are the boys, this is our place."
		
		
		local tbl = chatbox.WordWrap(text2, w/2 + 25, " ")	
		
		-- text2 = string.Implode("\n", tbl)
		
		-- local w2, h2 = surface.GetTextSize(text2)
		-- local h2 = h2 + 100
		-- w2 = w2 + 100
		
		-- if !hidePanels then
			-- draw.RoundedBox(0, -w/2, h, w, h2, Color(0,0,0,200*alpMult))
			
			-- surface.SetDrawColor(Color(255,255,255,150*alpMult))
			-- surface.DrawOutlinedRect(-w/2 - 5, h - 5, w + 10, h2 + 10, Color(255,255,255,255*alpMult))
		-- end
		
		-- draw.DrawText(text2, "goodFont2", -w/2 + 25, h + 12.5, Color(150, 150, 150, 255*alpMult), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		-- local text3 = "Online admins:\n"
		
		
		
		-- local w3, h3 = surface.GetTextSize(text3)
		-- local h3 = h3 + 50
		-- w3 = w3 + 100
		
		-- if !hidePanels then
			-- draw.RoundedBox(0, -w/2, h + h2 + 25, w, h3, Color(0,0,0,200))
			
			-- surface.SetDrawColor(Color(255,255,255,150))
			-- surface.DrawOutlinedRect(-w/2 - 5, h + h2 + 25 - 5, w + 10, h3 + 10, Color(255,255,255,255))
		-- end
		
		-- draw.DrawText(text3, "goodFont2", -w/2 + 25, h + 50 + h2, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		
		-- local x = 0
		-- local admins = {}
		-- for k,v in pairs(player.GetAll()) do
			-- local t = v:Team()
			
			-- if t < 30 then
				
				-- table.insert(admins, v)
				
			-- end
		-- end
		
		
		-- surface.SetFont("goodFont3") 
		-- for k,v in pairs(admins) do
		
			-- local suff = " "
			
			-- if k != #admins then
				-- suff = ", "
			-- end
		
			-- local t = v:Team()
		
			-- local wn, hn = surface.GetTextSize(v:Name())
			-- draw.DrawText(v:Name(), "goodFont3", -w/2 + 25 + x, h + 50 + h2 + 35, team.GetColor(t), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)			
			-- x = x + wn
			
			-- local wn, hn = surface.GetTextSize(suff)
			-- draw.DrawText(suff, "goodFont3", -w/2 + 25 + x, h + 50 + h2 + 35, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)			
			-- x = x + wn
			
			
		-- end
	end
	
	// TELEPOTTER AZKABAN 5000
	-- if (fusion_telepotter) then what cunt
		
	
		
	-- end
	
	RingMat = surface.GetTextureID("particle/Particle_Ring_Sharp_Additive") // ""
	SpotMat = surface.GetTextureID("particle/Particle_Ring_Wave_Additive") // particle/Particle_Ring_Wave_Additive
	-- fusion.cl.TelepotterModel
	
	hook.Add("PostDrawOpaqueRenderables", "drawSpawnPoint", function()
		
		local telepotter_colour = Color(150,60,200)
		
		if (fusion.TelepotterLocations) then
			local wh = 310
			local time = CurTime() * 2
			for i = 1, (#fusion.TelepotterLocations+1) do
				local data = fusion.TelepotterLocations[i]
				local pos = Vector(0,0,0)
				
				local drawme = false
				
				if i>#fusion.TelepotterLocations and fusion.SpawnPointPos and fusion.SpawnPointPos != Vector( 0, 0, 0 ) then
					pos = fusion.SpawnPointPos
					drawme = true
				elseif data then
					pos = data.pos
					drawme = true
				end
				
				if drawme then				
					local dist = EyePos():Distance(pos)
				
					if dist < 1000 then
					
						-- if dist < 200 then
							-- if !fusion.cl.TelepotterModel then
							
							-- end
							
							
						-- end
					
						cam.Start3D2D( pos, Angle(0,-90,0), 0.2 )
							local me = 250
				
							surface.SetTexture(SpotMat)
							surface.SetDrawColor(Color(telepotter_colour.r,telepotter_colour.g,telepotter_colour.b,100))
							surface.DrawTexturedRect(-me/2, -me/2, me, me)					
							
						cam.End3D2D()
				
						for i = 0, 10 do
						
							local sinful = (math.sin(time + i*0.5) * (i/10))
							
							local up = math.Clamp(sinful * 5, 0, 5)
						
							local colour = Color(telepotter_colour.r,telepotter_colour.g,telepotter_colour.b, math.max(sinful,0)*255)// - up * 50)
						
							cam.Start3D2D( pos + Vector(0,0, 1 + up), Angle(0,-90,0), 0.2 )
						
								local me = wh - i*8

								surface.SetTexture(RingMat)
								surface.SetDrawColor(colour)
								surface.DrawTexturedRect(-me/2, -me/2, me, me)
								
								
								
							cam.End3D2D()
							
							cam.Start3D2D( pos + Vector(0,0, 1 + up), Angle(0,90,0), 0.2 )
						
								local me = wh - i*8
								

								surface.SetTexture(RingMat)
								surface.SetDrawColor(colour)
								surface.DrawTexturedRect(-me/2, -me/2, me, me)
								
							cam.End3D2D()
							
						end	
					
					end
				end
			end
		end
		
		if fusion.cl.ShowSpawnpoint then
			local mapspawn = GetGlobalVector( "mapspawnpoint" )
			local spawnang = GetGlobalAngle( "mapspawnangle" )
				
			if fusion.SpawnPointPos and fusion.SpawnPointPos != Vector( 0, 0, 0 )then
				pos = fusion.SpawnPointPos	
			elseif mapspawn and mapspawn != Vector( 0, 0, 0 ) then
				pos = mapspawn		
			else
				pos = false
			end
		
			if pos then
				local dist = LocalPlayer():GetPos():Distance( pos )
				
				local ang = spawnang
				ang = Angle(0, ang.yaw, 0)
				
				local drawAng = Angle(0, ang.yaw + -90, 90)				
				
				-- if dist < 500 then
					-- cam.Start3D2D( pos + Vector(0,0, 60) + ang:Forward() * 50, drawAng, 0.1 )
							
						-- drawBillboard(false, 1-(dist / 500))	
							
					-- cam.End3D2D()
					
					-- cam.Start3D2D( pos + Vector(0,0, 60) + ang:Forward() * 50, drawAng + Angle(0, 180, 0), 0.1 )
							
						-- drawBillboard(true, 1-(dist / 500))				
							
					-- cam.End3D2D()
				-- end
				
				-- cam.Start3D2D( pos + Vector(0,0, 1), ang + Angle(0,-90,0), 0.2 )
						-- draw.RoundedBox(0, -50, -50, 100, 100, Color(255,255,255,255))
						
						-- surface.DrawOutlinedRect(-60, -60, 120, 120, Color(255,255,255,255))
						
						-- local size = 1
						
						-- for rows = -size, size do
							-- for cols = -size, size do	
								-- local alp = 255
								-- local centre = Vector(rows * 130, cols * 130)
								-- local dist = math.Dist(centre.x, centre.y, 0, 0)
								
								-- local sin_r = 0 //math.abs(math.sin(CurTime() + dist)) * 255
								-- local sin_g = math.abs(math.sin(CurTime() + 50 + dist)) * 255
								-- local sin_b = math.abs(math.sin(CurTime() + 100 + dist)) * 255
							
								-- draw.RoundedBox(0, centre.x - 60, centre.y - 60, 120, 120, Color(sin_r,sin_g,sin_b,alp))
								-- surface.SetDrawColor(Color(0,0,0,200))	
								-- surface.DrawOutlinedRect(centre.x - 60 - 1, centre.y - 60 - 1, 120 + 2, 120 + 2, Color(0,0,0,200))	
							-- end
						-- end	
						
						local wh = 130*(1*3)
						
						
						
						local time = CurTime() * 2
						for i = 0, 20 do
						
							local sinful = (math.sin(time + i*0.5) * (i/20))
							
							local up = math.Clamp(sinful * 5, 0, 5)
						
							cam.Start3D2D( pos + Vector(0,0, 1 + up), ang + Angle(0,-90,0), 0.2 )
						
								local me = wh - i*12
								local colour = Color(255,255,255,255 - up * 50)
								
								-- if up == 0 then
									-- colour = Color(255,255,255,255)
								-- end
								
								surface.SetDrawColor(colour)
								surface.DrawOutlinedRect(-me/2, -me/2, me, me, colour)	
														
								-- surface.DrawCircle(0, 0, 24, colour )
								
								-- for i = -180, 180 do 
									-- local x = math.sin(i) * wh
									-- local y = math.cos(i) * wh
									
									-- draw.RoundedBox(0, x, y, 1, 1, colour)
								-- end
								
							cam.End3D2D()
							
						end	
						
				
				
				-- local size = 1
				-- for i = 1, 5 do
					-- local wh = ((230-(20 * i))*(size*3)) 
					-- cam.Start3D2D( pos + Vector(0,0, 1 + ((i * 5))), ang + Angle(0,-90,0), 0.2 )									
						
						
						-- surface.SetDrawColor(Color(255,255,255,255))
						-- surface.DrawOutlinedRect(-wh/2, -wh/2, wh, wh, Color(255,255,255,255))						
					-- cam.End3D2D()
				-- end
				
			end
		end
	
		if fusion.cl.ShowPlayerNames then
			for k,v in pairs(player.GetAll()) do
				fusion.cl.drawTitle(v)
			end
		end
		
	end)
	
	-- function fusion.cl.drawSpawnPoint()
		-- if fusion.cl.ShowSpawnpoint then	
			-- local pos = Vector( 0, 0, 0 )
			-- local mapspawn = GetGlobalVector( "mapspawnpoint" )
			
			-- if fusion.SpawnPointPos and fusion.SpawnPointPos != Vector( 0, 0, 0 )then
				-- pos = fusion.SpawnPointPos	
			-- elseif mapspawn and mapspawn != Vector( 0, 0, 0 ) then
				-- pos = mapspawn		
			-- else
				-- pos = false
			-- end			
			
			-- if pos and LocalPlayer():GetPos():Distance( pos ) < 255 then
			
				-- local dist = LocalPlayer():GetPos():Distance( pos )
				-- local alpha = math.Round( 255 - math.Clamp( dist, 0, 255 ) )
	
				-- local sp_tspos = pos:ToScreen()
				-- local scale = math.Clamp( ( alpha * 0.1 ) * 10, 0, 20 )
							
				-- local bounce = fusion.SpawnPointBounce
				-- local dir = fusion.SpawnPointBounceDir
				
				-- if dir == "Up" then
					-- fusion.SpawnPointBounce = math.Clamp( fusion.SpawnPointBounce + 0.5, 0, 10 )
				-- else
					-- fusion.SpawnPointBounce = math.Clamp( fusion.SpawnPointBounce - 0.5, 0, 10 )
				-- end	
				
				-- if bounce <= 0 then
					-- fusion.SpawnPointBounceDir = "Up"
				-- elseif bounce >= 10 then
					-- fusion.SpawnPointBounceDir = "Down"
				-- end
				
				-- local ang = Angle( 0, 45, 0 )
				
				-- local point_1 = ( pos + ang:Forward() * scale ):ToScreen()
				-- local point_2 = ( pos + ang:Right() * scale ):ToScreen()	
				-- local point_3 = ( pos + ang:Forward() * -scale ):ToScreen()	
				-- local point_4 = ( pos + ang:Right() * -scale ):ToScreen()					
			
				-- local sp_tspos3 = ( pos + Vector( 0, 0, 10 ) ):ToScreen()
									
				-- surface.SetDrawColor( 255, 255, 255, 255 )	
				-- surface.DrawLine( point_1.x, point_1.y, point_2.x, point_2.y )
				-- surface.DrawLine( point_3.x, point_3.y, point_2.x, point_2.y )
				-- surface.DrawLine( point_3.x, point_3.y, point_4.x, point_4.y )
				-- surface.DrawLine( point_1.x, point_1.y, point_4.x, point_4.y )
				
				-- draw.DrawText( "Spawnpoint", "Default", sp_tspos3.x, sp_tspos3.y + 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
				
			-- end	
		-- end		
	-- end	
end