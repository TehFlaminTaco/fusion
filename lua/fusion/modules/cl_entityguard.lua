--[[ 
	Modules:
		Entity Guard
	
	Description:
		An in-built prop protection modifcation for Fusion Admin Mod.
 ]]
 
 
 // Buddies
	net.Receive( "EG_Buddies", function(len)
		LocalPlayer().EG_Buddies = net.ReadTable()
	end)
	
	fusion.cl.DisabledWorkshopDupes = false
	
	hook.Add("OnSpawnMenuOpen", "WS_DUPE", function()
		if !fusion.cl.DisabledWorkshopDupes then
			timer.Simple(2, function()
				if ws_dupe then
					function ws_dupe:DownloadAndArm( id )
						fusion.cl.DoMessage( "You cannot spawn dupes from the workshop.", bool )						
					end
					fusion.cl.DisabledWorkshopDupes = true
				end
			end)
			
		end
	end)
	
	// Icon
	fusion.cl.CannotIcon = Material( "icon16/cross.png" ) 
	net.Receive( "EntityGuard", function( data )
		local msg = net.ReadString()
		local ownerid = net.ReadString()
		if !msg or msg == nil or msg == "" then return end		
		if !ownerid then return end	
		
		fusion.EGHUD = { 
			Colour = Color( 255, 0, 0, 255 ), 
			Msg = msg,
			Time = CurTime() + 1,
			Owner = ownerid
		}
	end )
	
	net.Receive( "eg_GetOwner", function( data )
		fusion.EG_TargetOwner = net.ReadString()
		fusion.EG_TargetUnprotected = net.ReadBool()		
	end )
	
	
	local tiddown = Material( "gui/gradient_up" )
	fusion.cl.BoxSize = 0
	
	local function IDBox( top, middle, middle_colour, bottom, ply )
	
		local maxheight = 35
	
		-- if top then
			-- maxheight = 45
		-- end
		
		local max = maxheight
		
		-- if LocalPlayer():GetPos():Distance(ent:GetPos()) > 500 then
			-- max = 0
		-- end
		
		fusion.cl.BoxSize = math.Approach( fusion.cl.BoxSize, max, 2)	
		// WIDTH
			surface.SetFont( "FusionBold" )
			local width1 = ( surface.GetTextSize( middle ) + 16 )
			local width2 = 0
			
			if top then
				surface.SetFont( "Fusion" )
				width2 = ( surface.GetTextSize( top ) + 16 )
			end
			
			local width = width1	
			
			if width2>width1 then
				width = width2
			end
			
			width = math.Clamp( width, 150, 1000 )			
		//		
		
		-- centerpos = ent:LocalToWorld(ent:OBBCenter())
		
		//height = ent:OBBMaxs().z - ent:OBBMins().z
		
		-- tspos = centerpos:ToScreen()
		
		perc = fusion.cl.BoxSize / maxheight
		//tspos2 = centerpos + Vector(0,0,height)
		
		//local tspos = Vector( ScrW() / 2, ScrH() - 30, 0 )
		
		iconSize = 32
		width = width + 30 + 5
		height = iconSize + 10				
		
		
		
		local coolpos = Vector(ScrW()-width-5, 5)
		
		local col = Color(middle_colour.r, middle_colour.g, middle_colour.b, middle_colour.a * perc)
		
		draw.RoundedBox( 0, coolpos.x, coolpos.y, width, height, Color(70,70,70,150 * perc))	
		-- draw.RoundedBox( 0, coolpos.x, coolpos.y, width, height/2, Color(255,255,255,10 * perc))
				
		surface.SetDrawColor(Color(0,0,0,50 * perc))
		surface.SetTexture(fusion.cl.gradient_down)
		surface.DrawTexturedRect(coolpos.x, coolpos.y, width, height)
		
		
		surface.SetDrawColor(fusion.cl.GetColour(100 * perc))
		surface.DrawOutlinedRect(coolpos.x, coolpos.y, width, height)
		
		-- draw.RoundedBox( 0, coolpos.x+2, coolpos.y + 2, width-4, height -4, col)
				
		
		if !fusion.cl.PlayerAvatar then
		
			fusion.cl.PlayerAvatar = vgui.Create( "AvatarImage", Panel )
			fusion.cl.PlayerAvatar:SetSize( iconSize, iconSize )
			fusion.cl.PlayerAvatar:SetPos( ScrW() - iconSize - 10, 10 )
			-- fusion.cl.PlayerAvatar:SetPlayer(  )
			fusion.cl.PlayerAvatar:SetVisible(false)
		
		end	

		if ply and ply:IsValid() and ply:IsPlayer() then			
			fusion.cl.PlayerAvatar:SetVisible(true)
			fusion.cl.PlayerAvatar:SetPlayer(ply)
		else
			fusion.cl.PlayerAvatar:SetVisible(false)
			fusion.cl.PlayerAvatar:SetPlayer()
		end
			
		draw.RoundedBox(0, ScrW() - iconSize-2 - 10, 10-2, iconSize+4, iconSize+4, col)			
		draw.DrawText( middle, "FusionBold", coolpos.x + 5, coolpos.y + 3, Color(255,255,255,255*perc), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )		

		if top then			
			draw.DrawText( top, "Fusion", coolpos.x + 5, coolpos.y + 5 + 16, Color(255,255,255,255*perc), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
		end
	
	end

	
	local function playerID(ply)
		local pos = ply:LocalToWorld( ply:OBBCenter() )
		
		-- local time = ply:GetNWInt("timespent")
		-- local lastupdate = ply:GetNWInt("lastupdate")
		
		-- local predict = time + ( CurTime() - lastupdate )
		-- local timespent = fusion.ConvertTime( predict )
				
		-- local top = false

		-- local good = "<color=%s,%s,%s>%s</color>"
		-- local colour = team.GetColor(ply:Team())
		-- local name = team.GetName(ply:Team())
		-- local top = timespent
		
		IDBox( team.GetName(ply:Team()), ply:Name(), team.GetColor( ply:Team() ), false, ply )
	end
	
	function fusion.EGIDTags()
	
		if fusion.EGHUD and fusion.sh.TableHasData( fusion.EGHUD ) then
			local time = fusion.EGHUD.Time
			local colour = fusion.EGHUD.Colour
			local msg = fusion.EGHUD.Msg
			local owner = fusion.EGHUD.Owner
			if CurTime() > time then fusion.EGHUD = false return end
			
			local posx = ScrW() / 2
			local posy = ScrH() / 2
			
			surface.SetMaterial( fusion.cl.CannotIcon )
			surface.SetDrawColor( 255, 255, 255, 200 )	
			surface.DrawTexturedRect( posx-8, posy-8, 16, 16 )
			
			draw.DrawText( msg, "Default", posx, posy + 12, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	

			local oent = player.GetByUniqueID( owner )
			if owner and oent and oent:IsValid() and oent:IsPlayer() then
				draw.DrawText( oent:Name(), "Default", posx, posy + 30, team.GetColor( oent:Team() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
			elseif owner == "protected" then
				draw.DrawText( "Protected", "Default", posx, posy + 30, Color( 200, 200, 200, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
			elseif owner and owner != "" then
				draw.DrawText( "Disconnected Player", "Default", posx, posy + 30, Color( 200, 200, 200, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
			end	
		end
		
		local trace = LocalPlayer():GetEyeTrace()		
		if trace.HitNonWorld then
			local ent = trace.Entity
			
			if IsValid( ent ) and ent:IsPlayer() then
			
				playerID(ent)
			
			elseif IsValid( ent ) then			
				local ownerid = fusion.EG_TargetOwner

				local pos = ent:GetPos()
				local bottom = ent:GetModel() 
				local class = "[" .. ent:EntIndex() .. "] " .. ent:GetClass()
				
				if ownerid then					
					
					local colour = Color(100,100,100,255)

					local name = "Disconnected Player"		
					
					local owner = player.GetByUniqueID( ownerid )
					if owner and owner:IsValid() and owner:IsPlayer() then
						colour = fusion.cl.GetRankColour(owner)
						name = owner:Name()
					
					elseif ownerid == "World" then
						name = "Protected Entity"
					end
					
					IDBox( name, class, colour, bottom, owner )
				
				end
				
				local checkTime = 0.5
									
				if !fusion.NextOwnerCheck or CurTime() > fusion.NextOwnerCheck then
					RunConsoleCommand( "eg_GetOwner", ent:EntIndex() )					
					fusion.NextOwnerCheck = CurTime() + checkTime
					fusion.OwnerIDTarget = ent
				end		
				
			else
				fusion.cl.BoxSize = 0
				fusion.OwnerIDTarget = nil
			end
		else
			fusion.EG_TargetOwner = nil
			fusion.cl.BoxSize = 0
			
			if fusion.cl.PlayerAvatar then
				fusion.cl.PlayerAvatar:SetVisible(false)
				fusion.cl.PlayerAvatar:SetPlayer()
			end
		end	
	end	