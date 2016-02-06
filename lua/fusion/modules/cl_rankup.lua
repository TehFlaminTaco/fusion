

function fusion.cl.CloseRankDialog()
	if (fusion.cl.RankPanel and fusion.cl.RankPanel:IsValid()) then
		fusion.cl.RankPanel:SetVisible(false)
		fusion.cl.RankPanel:SetEnabled(false)
		fusion.cl.RankPanel = nil
	end
end

fusion.cl.CloseRankDialog()

fusion.cl.RankDialogShowTime = 30 // 60

function fusion.cl.ShowRankDialog()

	fusion.cl.CloseRankDialog()

	local w, h = 700, 600

	local panel = vgui.Create( "DPanel", DermaPanel )
	panel:SetPos( ScrW()/2 - w/2, ScrH()/2 - h/2 )
	panel:SetSize( w, h )
	panel.ticker =1
	panel.dietime = CurTime() + fusion.cl.RankDialogShowTime
	panel.Paint = function(panel, w, h)		
		
		local ply = LocalPlayer()
		
		local my_rankname = fusion.GetRankByTeam( ply:Team() )
		local my_rank = fusion.Ranks[my_rankname]
		local my_hierarchy = my_rank.Hierarchy
		
		-- local str =  "Congratulations %s you've just reached the rank of %s, which "
		-- str = str .. "means you're even more badass than ever before! You've also earned "
		-- str = str .. "the respect of others on this server, especially the admins, so make sure you tell everyone you know. "
		-- str = str .. "You know what else this means? It means you have access to super sweet badass superpowers like:"
		-- str = str .. "%s"
		
		local commands = {}
		
		for k,v in pairs(fusion.commands) do
			table.insert(commands, {Name = k, Hierarchy = v.Hierarchy, Help = v.Help})
		end
		
		table.SortByMember(commands, "Hierarchy")
		
		-- str = Format(str, ply:Name(), team.GetName(ply:Team()), "gayness")
		
		-- print(w, h)
		
		local font = "chatbox_Font"
		local header = 100
		local margin = 10
		local max_ticker = 18
		
		-- local page = margin-5
		-- draw.RoundedBox(0, page-1, header, w - page*2 +2, h - header + 2, Color(0, 0, 0, 255))
		-- draw.RoundedBox(0, page, header, w - page*2, h - header, Color(255, 255, 255, 255))
		
		local team_colour = team.GetColor(ply:Team())
		
		draw.SimpleText(team.GetName(ply:Team()), "pacfont!", w/2+1, header/2+1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(team.GetName(ply:Team()), "pacfont!", w/2, header/2, team_colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local time = CurTime()*10 % 360
		for i = 1, 10 do
			local manslaughter = time + 360/i
			local sin = math.sin(manslaughter) * 4
			local cos = math.cos(manslaughter) * 4
			
			draw.SimpleText(team.GetName(ply:Team()), "pacfont!2", w/2 + sin, header/2 + cos, Color(0,0,0, 5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		
		-- draw.RoundedBox(0, 0, header, w, h-header, Color(0, 0, 0, 100))
		-- draw.RoundedBox(0, 1, 1+header, w-2, h-2-header, Color(0, 0, 0, 150))
		
		local x = margin
		local y = header
		
		-- draw.RoundedBox(0, 0, 0, w, h, Color(60,60,60,100))	
		
		draw.RoundedBox(0, 0, y, w, 20, Color(50,50,50,200))		
		draw.SimpleText("Congratulations on the new rank " .. ply:Name() .. "!", "chatbox_Font_Bold", x, y, Color(255,255,255))
		y = y + 20
		
		local weps = ply:GetWeapons()
		local rlweps = {}
		for k,v in pairs(weps) do
			table.insert(rlweps, v:GetClass())
		end
		
		draw.RoundedBox(0, 0, y, w, 20, Color(50,50,50,200))	
		draw.SimpleText("Your weapon loadout now consists of:", "chatbox_Font_Bold", x, y, Color(255,255,255))
		y = y + 20
		local wep_str = string.Implode(", ", rlweps)
		draw.RoundedBox(0, 0, y, w, 20, Color(70,70,70,200))
		surface.SetFont("chatbox_Font")
		local w2, h2 = surface.GetTextSize(wep_str)
		fusion.xdivvy = (fusion.xdivvy or 0) + 0.2*fusion.cl.HUDSpeedMult
		
		if fusion.xdivvy > w then
			fusion.xdivvy = -w2
		end
		
		-- print(xdivvy)
		draw.SimpleText(wep_str, "chatbox_Font", margin + fusion.xdivvy - margin*2, y, Color(255,255,255))
		-- draw.RoundedBox(0, fusion.xdivvy, y, w2, 20, Color(255,50,50,100))
		
		y = y + 20
		
		draw.RoundedBox(0, 0, y, w, 20, Color(50,50,50,200))	
		draw.SimpleText("You now have access to the following commands:", "chatbox_Font_Bold", x, y, Color(255,255,255))
		y = y + 20
		
		team_colour.a = 200		
		 
		for i = 1, math.min(#commands, math.floor(panel.ticker)) do
			
			if (my_hierarchy == commands[i].Hierarchy) then			
		
				local sin = math.abs(math.sin(time*0.5))
				local glow_colour = Color(100*sin + 155, 100*sin + 155, 0)
			
				draw.RoundedBox(0, 0, y, w, 20, team_colour)
				draw.SimpleText("NEW", "chatbox_Font_Bold", x + w - 12, y, glow_colour, TEXT_ALIGN_RIGHT)
				
			else
				if i % 2 == 0 then
				draw.RoundedBox(0, 0, y, w, 20, Color(70,70,70,200))
				else
				draw.RoundedBox(0, 0, y, w, 20, Color(100,100,100,200))
				end
				
			end
			
			
			surface.SetFont("chatbox_Font_Bold")
			local w2, h2 = surface.GetTextSize("/" ..commands[i].Name)
			
			draw.SimpleText("/" .. commands[i].Name, "chatbox_Font_Bold", x+1, y+1, Color(0,0,0))
			draw.SimpleText(" - " .. commands[i].Help, "chatbox_Font", x+w2+1, y+1, Color(0,0,0))
			
			draw.SimpleText("/" .. commands[i].Name, "chatbox_Font_Bold", x, y, Color(255,255,255))
			draw.SimpleText(" - " .. commands[i].Help, "chatbox_Font", x+w2, y, Color(255,255,255))
			
			
			
			y = y + 20
		end
		
		if panel.ticker == max_ticker and #commands > max_ticker then
			draw.RoundedBox(0, 0, y, w, 20, Color(50,50,50,200))
		
			draw.SimpleText("..... (enter 'fusion help' in console to the view remaining " .. #commands - max_ticker .. " commands available to you)", font, x+1, y+1, Color(0,0,0))
			draw.SimpleText("..... (enter 'fusion help' in console to the view remaining " .. #commands - max_ticker .. " commands available to you)", font, x, y, Color(255,255,255))
			
			y = y + 20
		end
		
		
		
		panel.ticker = math.Clamp(panel.ticker + 0.05, 1, max_ticker)
		
		
		
		if (CurTime() > panel.dietime or input.IsKeyDown(KEY_ESCAPE)) then			
			fusion.cl.CloseRankDialog()			
		else
			draw.RoundedBox(0, 0, y, w, 20, Color(50,50,50,200))
		
			draw.SimpleText("Closing in " .. math.Round(panel.dietime - CurTime()) .. " seconds, press escape to close manually.", "chatbox_Font", x + w/2+1, y+1, Color(0,0,0), TEXT_ALIGN_CENTER)
			draw.SimpleText("Closing in " .. math.Round(panel.dietime - CurTime()) .. " seconds, press escape to close manually.", "chatbox_Font", x + w/2, y, Color(255,255,255), TEXT_ALIGN_CENTER)
		end
	end

	fusion.cl.RankPanel = panel

end