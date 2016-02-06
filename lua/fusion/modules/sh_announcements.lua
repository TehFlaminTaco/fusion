--[[ 
	Modules:
		Announcements
	
	Description:
		Functions and commands related to announcemenets.
 ]]
if SERVER then
	
	
	fusion.commands["announce"] = {
		Name = "Announce",	
		Hierarchy = 80,
		Category = "messages",
		Args = 1,
		Help = "Send a message with the announcements system.",
		Message = "%s announced %s",
		Function = function( ply, cmd, args )
			local message = fusion.commands[cmd].Message
			
			local msg = table.concat( args, " " )
			
			if !msg then
				fusion.Message( ply, "You have not entered a message" )
				return
			end	
			
			fusion.SendGlobalAnnouncement( 10, msg, Color( 255, 255, 255, 255 ), "icon16/user" )					
		end	
	}


	function fusion.PeriodicAnnouncement()
	
		if file.Exists( "fusion/announcements.txt", "DATA" ) then
			
			local alist = string.Explode( "\n", file.Read( "fusion/announcements.txt", "DATA" ) )
	
			local random = table.Random( alist )
			
			fusion.SendAnnouncement( 30, random)
			
		end	
	
	end
	
	timer.Create( "fusion_Announcements", 300, 0, fusion.PeriodicAnnouncement )

	function fusion.SendGlobalAnnouncement(time, text, colour)		
		fusion.GlobalMessage( text, false, false )
	end	
	
	-- function fusion.SendAnnouncement(ply, time, text, colour)	
		-- fusion.Message( text, false, time )		
	-- end
	
	function fusion.SendAnnouncement(time, msg)
		
		net.Start( "fusion_Announcements")
		net.WriteString( time )
		net.WriteString( msg )
		net.Broadcast()
		
	end
	
	
	function fusion.sv.LogMessage( pl, msg, disp, iscmd )		
		if !disp then
			if !iscmd then
				for k,v in pairs( fusion.sv.GetAdmins() ) do
					net.Start("fusion_logMessage")
					net.WriteString( pl:UniqueID() )
					net.WriteString( msg )
					net.Send(v)
				end					
			end	
						
			print( fusion.ReturnMarkup( msg ) )
		end		
	end	
	
else

	fusion.AnnouncementsLog = fusion.AnnouncementsLog or {}
	fusion.Announcements = fusion.Announcements or {}

	maxAnnouncements = 200
	
	local function addToLog(t)
		
		local count = #fusion.AnnouncementsLog
		
		if count >= maxAnnouncements then
			table.remove(fusion.AnnouncementsLog, 1)
		end
		
		table.insert(fusion.AnnouncementsLog, t)
		
	end
	
	net.Receive( "fusion_Announcements", function( data ) 
		local time = tonumber(net.ReadString()) or 0
		local msg = fusion.ReturnMarkup(net.ReadString()) or "ERROR MSG"
		-- msg = fusion.ReturnMarkup(msg)
		-- local b = {Message = msg, TimeRec = CurTime()}		
		-- addToLog(b)
		
		fusion.test_Announcement( parse, time )	
		-- print(msg)
		
		-- 
	end )
	
	net.Receive( "fusion_logMessage", function( data ) 
		local uid = net.ReadString()
		local msg = net.ReadString()
		-- msg = fusion.ReturnMarkup(msg)
		-- local b = {Message = msg, TimeRec = CurTime()}		
		-- addToLog(b)
		
		local pl = player.GetByUniqueID(uid)
		local plname = "*"
		local id = "#"
		local plcolour = Color(255,150,0)
		if pl and pl:IsValid() then
			plname = pl:Name()
			plid = pl:SteamID()
			plcolour = team.GetColor(pl:Team())
		end
		 
		chat.AddText( plcolour, plname, Color( 222,222, 222 ), " " .. msg)
		-- print(plname .. " (" .. plid .. ")" .. msg)
		
		-- print(msg)
		 
		-- 
	end )
	
	function fusion.test_Announcement( parse, time )		
		local t = time or 5
		
		local a = { Message = parse, Time = t, Remove = CurTime() + t }		
		table.insert( fusion.Announcements, a )
		
		local b = {Message = parse, TimeRec = CurTime()}
		
		addToLog(b)		
		
		-- surface.PlaySound("common/bugreporter_succeeded.wav")
		-- surface.PlaySound("Friends/friend_join.wav")
	end

	local gradient = surface.GetTextureID( "gui/gradient" )
	
	surface.CreateFont( "dTimers",
		{
			font      = "Andale Mono",
			size      = 16,
			weight    = 700
		}
	)
	
	surface.CreateFont( "dTimers_glow",
		{
			font      = "Andale Mono",
			size      = 16,
			weight    = 700,
			blursize = 2
		}
	)
	
	surface.CreateFont( "dTimers_shadow",
		{
			font      = "Andale Mono",
			size      = 16,
			weight    = 700,
			blursize = 5
		}
	)
	
	
	
	local function drawMapTimer(scoreboardUp)
		if (fusion.cl.MapChangeTimer and fusion.cl.MapChangeTimer.map and fusion.cl.MapChangeTimer.time) then
			local map = fusion.cl.MapChangeTimer.map
			local time = fusion.cl.MapChangeTimer.time
			
			local w,h = 500, 30	
			
			local mult = math.Clamp(fusion.cl.AlphaMult, 0, 1)
			
			local push = (h+10) * mult
					
			local x,y = ScrW()/2 - 250, ScrH() - push
			
			local barH = 5			
			
			if (scoreboardUp) then
				-- h = 30
				barH = 10
			end
			
			draw.RoundedBox(0,x,y,w,h,Color(50,50,50,255))
			
			draw.RoundedBox(0,x+2,y+2,w-4,h-2,Color(70,70,70,255))
			
			draw.RoundedBox(0,x+2,y+2+(h-2)/2,w-4,(h-2)/2,Color(255,255,255,2))
						
			if (mult > 0) then
				draw.SimpleText("Map Tracker", "fancyfont", x + 5, y - 30, Color(255,255,255,255), TEXT_ALIGN_LEFT )	
				draw.SimpleText("Changing to " .. map .. " in " .. fusion.ConvertTime(math.Round(time-CurTime())) .. " seconds.", "SBNormal", x + (w/2), y+h/2+2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
			end
			
			draw.RoundedBox(0,x-5,ScrH() - barH,w+10,barH,fusion.cl.GetColour(255))
		end
	end
	
	fusion.cl.MapTimerPush = 0
	
	local copyIcon = Material("icon16/note_go.png")
	local msgIcon = Material("icon16/weather_sun.png")

	
	function fusion.cl.paintAnnouncements()
		
		local count = table.Count(fusion.AnnouncementsLog)	
		-- if count > 0 then
			-- local count_F = math.Clamp(count, 0, 7)		
			-- draw.RoundedBox(0, 0, 45-10, 5, count_F*20+20, fusion.cl.GetColour(255))	
		-- end
		
		if table.Count( fusion.Announcements ) > 0 then		
			
			table.SortByMember( fusion.Announcements, "Remove", function( a, b ) return a > b end )
			
			for k,v in pairs( fusion.Announcements ) do
				local i = k
					
				if fusion.Announcements[i-1] and fusion.Announcements[i-1].Remove == v.Remove then
					v.Remove = v.Remove + 0.001
				end
			
				if !v or CurTime() > v.Remove then
					table.remove( fusion.Announcements, i )					
				else
					if 7 >= i then
						local rem = v.Remove - CurTime()
						local time = v.Time
						local outer = 250
						local inner = outer - 6
						
						local perc = math.Clamp( ( rem * inner ) / time, 0, inner )
						
						local up = 0
						
						local tdrop = time - rem
						
						-- local numh = ( ( i - 1 ) * 29 ) + 45
													
						-- local y = numh	
						
						local txt = string.gsub( v.Message or "Error in message, tell Droke!", "#t", tostring( math.Round( rem ) ) )
						-- txt = "<color=255,255,255,255>[</color><color="..fusion.cl.ColorMarkupString(255)..">Fusion</color><color=255,255,255,255>]</color> " .. txt
						
						-- if !table.HasValue({ ".", ",", "!", "-", "=", "%", "&", "*", ")", "(", "+" }, string.Right(txt, 1)) then
							-- txt = txt .. "."
						-- end
						
						local clean = string.gsub(txt, "<[^>]*>", "")
						
						surface.SetFont("dTimers")
						local clean_w = surface.GetTextSize(clean)
						-- draw.RoundedBox(6, 5, 7 + ( 20 * ( i - 1 ) ) - 2, clean_w + 35, 20, Color(80,80,80,100))
						
						local cen_x = ScrW() / 2
						
						surface.SetDrawColor(Color(0,0,0,200))
						surface.SetTexture(fusion.cl.gradient_cen)					
						surface.DrawTexturedRect(cen_x - 250, 0 + ( 20 * ( i - 1 ) ) - 2, 500, 19)
						
						
						draw.SimpleText(clean, "dTimers_glow", cen_x-1, -1 + ( 20 * ( i - 1 ) ), Color(255,255,255, 40), TEXT_ALIGN_CENTER)
						draw.SimpleText(clean, "dTimers", cen_x, -1 + ( 20 * ( i - 1 ) ) + 1, Color(0,0,0,255), TEXT_ALIGN_CENTER)
									
						local parse = markup.Parse( "<font=dTimers>" .. txt .. "</font>")						
						parse:Draw( cen_x, -1 + ( 20 * ( i - 1 ) ) , TEXT_ALIGN_CENTER)
						
						-- draw.SimpleText(clean, "dTimers", 10 + 20, 45 + ( 20 * ( i - 1 ) ), Color(255,255,255,200))
						
						-- draw.SimpleText(clean, "dTimers", 10 + 20, 45 + ( 20 * ( i - 1 ) ), Color(255,255,255, 50))
						
						-- draw.SimpleText(clean, "dTimers_glow", 10 + 20, 45 + ( 20 * ( i - 1 ) ), Color(255,255,255,100))
						
						
						
						-- draw.SimpleText(clean, "dTimers", 10 + 20, 45 + ( 20 * ( i - 1 ) ), Color(255,255,255,50))
						
						-- local parse = markup.Parse( "<font=dTimers>" .. txt .. "</font>" )
						-- parse:Draw( 10 + 20, 45 + ( 20 * ( i - 1 ) ) )
						
						-- local parse = markup.Parse( "<font=dTimers_glow>" .. txt .. "</font>" )
						-- parse:Draw( 10 + 20, 45 + ( 20 * ( i - 1 ) ) )
						
						-- surface.SetDrawColor(Color(255,255,255,255))
						-- surface.SetMaterial(msgIcon)					
						-- surface.DrawTexturedRect(2, 0 + ( 20 * ( i - 1 ) ), 16, 16)
						
						-- draw.RoundedBox(4, 2, 0 + ( 20 * ( i - 1 ) ), 15, 15, fusion.cl.GetColour(255))
						
						if tdrop < 1 then
							-- print(tdrop)
							
							local le = 1 - tdrop
							
							surface.SetDrawColor(fusion.cl.DefaultColour(le*255))
							surface.SetTexture(fusion.cl.gradient_cen)		
							surface.DrawTexturedRect(cen_x - 250, 0 + ( 20 * ( i - 1 ) ) - 2, 500, 19)
						end
						
						//surface.SetDrawColor(Color(255,255,255,255))
						//surface.SetMaterial(msgIcon)					
						//surface.DrawTexturedRect(2, 0 + ( 20 * ( i - 1 ) ), 15, 15)
						
						-- draw.RoundedBox(4, 2, 0 + ( 20 * ( i - 1 ) ), 15, 8, Color(255,255,25,100))
						
					end				
					
				end	
			end
		end	

		drawMapTimer(false)
	end
	
	fusion.logScroll = 1
	
	function fusion.cl.paintAnnouncementsLog()		
		local count = table.Count(fusion.AnnouncementsLog)
				
		if count > 0 then	

			local mult = math.Clamp(fusion.cl.AlphaMult, 0, 1)
			
			local push = 500
			local xtake = push-(push * mult) + 5
		
			local amountShown = 6
			
			local count_F = math.Clamp(count, 0, amountShown+1)
		
			local y = 5
		
			local width = 100
		
			-- draw.RoundedBox(0, 0, 30, 100, 5, fusion.cl.GetColour(255))
			
			local boxh = 20 * count_F 
			
			draw.RoundedBox(0, 0, y+40-5, ScrW(), boxh+10, Color(0,0,0,100 * mult))
			
			-- local text = "Log (" .. count .. " items in log)"
			-- draw.SimpleText(text, "fancyfont", 5+2-xtake, y+2, Color(0,0,0,255))
			-- draw.SimpleText(text, "fancyfont", 5-xtake, y, Color(255,255,255,255))			
			

			
			local y = y + 40
			
				
						
			draw.RoundedBox(0, 10-xtake, y-5, 85, boxh+10, Color(50,50,50,255))
			
			
			local scrollBarX = 95-xtake
			
			draw.RoundedBox(0, scrollBarX, y-5, 5, boxh+10, fusion.cl.GetColour(255))
			draw.RoundedBox(0, 95-xtake, y-5, 5, boxh+10, Color(0,0,0,50))
						
			-- surface.SetDrawColor(Color(0,0,0,100))
			-- surface.SetTexture(fusion.cl.gradient)
			-- surface.DrawTexturedRect(scrollBarX, y-5, 5, boxh+10)
			
				
			
			if count > amountShown then
				-- local defaultH = boxh
				-- local scrollBoxH = math.Clamp(boxh / (count-count_F), boxh*0.1, boxh)
			
				-- local y = y - 8
				-- y = math.Clamp(y + ((fusion.logScroll/count) * (defaultH+20-4)), y, y + (defaultH+20-4) - scrollBoxH)
								
				-- draw.RoundedBox(0, 2-xtake, y, 6, scrollBoxH, Color(255,255,255,255))	

				local scrollMax = count - amountShown
						
				if mouseInRegion(0,0,400,boxh + 40) then
					if fusion.cl.IsMousePressed(1) then
						fusion.logScroll = math.Clamp(fusion.logScroll-1, 1, scrollMax)
					elseif fusion.cl.IsMousePressed(-1) then
						fusion.logScroll = math.Clamp(fusion.logScroll+1, 1, scrollMax)
					end
				end
				
				// manual scroll
				local manual_x, manual_y = scrollBarX - 1, y-5
				local manual_w, manual_h = 7, boxh+10
				
				if mouseInRegion(manual_x, manual_y, manual_w, manual_h) then
					if (input.IsMouseDown(MOUSE_LEFT)) then
						fusion.AnnouncementsScrollManual = true
					end
				end
				
				if (fusion.AnnouncementsScrollManual and !input.IsMouseDown(MOUSE_LEFT)) then
					fusion.AnnouncementsScrollManual = false
				end				
				
				local scrollDiv = (fusion.logScroll-1) / (scrollMax-1)
				
				-- draw.SimpleText("Debug: " .. scrollDiv, "dTimers", 200, 200, Color(255,255,255,255))				
				
				local scrollMaxHeight = boxh+10
				local scrollHeight = math.Clamp(scrollMaxHeight / scrollMax, 10, 400)
				local scrollY = y-5 + ((scrollMaxHeight - scrollHeight) * scrollDiv)
				
				draw.RoundedBox(0, scrollBarX - 1, scrollY, 7, scrollHeight, fusion.cl.GetColour(255))
			
				if (fusion.AnnouncementsScrollManual) then
					local mouseX = gui.MouseX()
					local mouseY = gui.MouseY()

					local take = scrollHeight/2
					
					local diff = -(((y-5) - mouseY) + take)
					
					local div = math.Clamp(diff / (scrollMaxHeight - take), 0, 1)
					
					local newScroll = math.Round(scrollMax * div) + 1
					
					fusion.logScroll = math.Clamp(newScroll, 1, scrollMax)
					
					-- draw.SimpleText("Debug: " .. newScroll, "dTimers", 200, 200, Color(255,255,255,255))	
				end
			
			else
				fusion.logScroll = 1
			end			
			
			local start = math.Clamp(fusion.logScroll, 1, count - amountShown)			
		
			-- if fusion.cl.AlphaMult >= 1 then		
				for i = count, 1, -1 do							
					ir = count - (i-1)
						
					if ir >= start and ir < (start + amountShown + 1) then
						
						local v = fusion.AnnouncementsLog[i]
				
						draw.RoundedBox(0, 15-xtake, y+1, 75, 18, Color(0,0,0,100))							
						
						local bx, by, bw, bh = 105-xtake+2, y+2, 16, 16
						
						if mouseInRegion(bx, by, bw, bh) then	

							bx, by, bw, bh = bx - 2, by - 2, bw + 4, bh + 4
						
							if fusion.cl.IsMousePressed(MOUSE_LEFT) then
								-- print(i)
								
								local clean = string.gsub(v.Message, "%b<>", "")
								
								SetClipboardText(clean)
							end
						end						
						surface.SetDrawColor(Color(255,255,255,255))
						surface.SetMaterial(copyIcon)					
						surface.DrawTexturedRect(bx, by, bw, bh)
							
							
						local outer = 250
						local inner = outer - 6
						
						
						local clean = string.gsub(v.Message, "<[^>]*>", "")						
						
						draw.SimpleText(clean, "dTimers_glow", 105-xtake + 24, y+2, Color(255,255,255, 40))
						draw.SimpleText(clean, "dTimers", 105-xtake + 24 + 1, y+2 + 1, Color(0,0,0,255))
						
						local txt = string.gsub( v.Message or "Error in message, tell Droke!", "#t", "<timer>" )
						local parse = markup.Parse( "<font=dTimers>" .. txt .. "</font>" )
						parse:Draw( 105-xtake + 24, y+2 )
						
						local timeAgo = CurTime() - v.TimeRec
						txt = "<color=200,200,200>" .. fusion.ConvertTime(math.Round(timeAgo)) .. "</color> ago"
						local parse = markup.Parse( "<font=dTimers>" .. txt .. "</font>" )
						parse:Draw( 17-xtake, y+2 )
						
						y = y + 20				
					end
				end				
			-- end
			
			// box left line
			draw.RoundedBox(0, -5 * (1-mult), 45-10, 5, boxh+20, fusion.cl.GetColour(255))
		end

		drawMapTimer(true)
	end
	
			
	net.Receive( "fusion_dtimer", function( data )
		
		local text = net.ReadString()
		local time = net.ReadInt()	

		local r = net.ReadInt()
		local g = net.ReadInt()
		local b = net.ReadInt()
		
		local def = Color( r, g, b )
		
		fusion.cl.DoMessage( text, false, time, def )		
	end )
end	