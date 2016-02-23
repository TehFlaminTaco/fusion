// word wrap
// capture all characters entered when chat box is open



// check through every key_asdasd, add the letter to ther entered string if it is pressed. if delete key is pressed, delete character in front of current
//     position in the text entry box, backspace, take one off the end, 




// get position of mouse and find out what y vector it is and then get the closest letter, set start position to it

local enabled = true

if enabled then

	local font = "Verdana"
	local size = 18

	surface.CreateFont("chatbox_Font", {
		font = font,
		size = size,
		weight = 400,
		antialias = true,
		shadow = false
	} )

	surface.CreateFont("chatbox_Font_Bold", {
		font = font,
		size = size,
		weight = 700,
		antialias = true,
		shadow = false
	} )

	surface.CreateFont("chatbox_Font_Big", {
		font = font,
		size = size,
		weight = 400,
		antialias = true,
		shadow = false
	} )

	surface.CreateFont("chatbox_Font_NoShadow", {
		font = font,
		size = size,
		weight = 400,
		antialias = true,
		shadow = false
	} )

	surface.CreateFont("chatbox_Font_Blur", {
		font = font,
		size = size,
		weight = 400,
		antialias = true,
		shadow = false,
		blursize = 2
	} )

	local function markupColour(colour)
		
		local r,g,b = colour.r, colour.g, colour.b
		
		return r .. ", " .. g .. ", " .. b
		
	end

	
	
	local function processMarkup(markup, x, y)
		local split = string.Explode("<.+>", markup)
		
		-- PrintTable(split)
	end

	if !chatbox then chatbox = {} end
	if !chatbox.table then chatbox.table = {} end
	-- chatbox = {}
	-- chatbox.frame = nil

	-- chatbox.channels = {}
	-- chatbox.channels["local"] = {Dist = 500}
	
	local fade = 0
	local textDieTime = 10
	local margin = 100

	hook.Add("StartChat", "open", function(isTeam)
		-- LocalPlayer():PrintMessage(HUD_PRINTTALK, "Test Alert")
		
		-- print("open")
		-- chatbox.frame:SetVisible(true)
		chatbox.show = true
		
		chatbox.initFrame()
		
		-- chatbox.start()
		
		return true 
	end)

	hook.Add( "FinishChat", "close", function()
		-- print("close")
		-- chatbox.frame:SetVisible(false)
		chatbox.show = false	
		-- chatbox.close()
	end)

	hook.Add( "ChatTextChanged", "handleTextChanged", function(text)
		chatbox.text = text
	end)

	chatbox.TimedText = {}
	function chatbox.SetTimedText(id, pos, text, colour, life)
		local obj = {}
		obj.id = id
		obj.pos = pos
		obj.text = text
		obj.colour = colour
		obj.life = life												
		obj.dieat = CurTime() + life
		
		chatbox.TimedText[id] = obj
	end

	function chatbox.AddToTable(tbl)
		if (#chatbox.table >= 300) then
			table.remove(chatbox.table, 1)
		end
		
		table.insert(chatbox.table, tbl)
	end

	local function process_at(text)

		local exp = string.Explode(" ", text)
					
		for k,v in pairs(exp) do
			if string.Left(v, 1) == "@" and v != "@admins" then
				local find = string.lower(string.Right(v, string.len(v) - 1))

				for _,p in pairs(player.GetAll()) do
					if string.find(string.lower(p:Name()), find) then
						exp[k] = "@" .. string.gsub(p:Name(), " ", ".")
					end
				end
			end
		end

		return string.Implode(" ", exp)

	end

	hook.Add( "ChatText", "handleChatText", function(index, name, text, type)
		-- print(index, name, text, type)
		
		if !chatbox.table then chatbox.table = {} end	
		
		if ( typ == "joinleave" ) then 
			-- fusion.test_Announcement( text, 5 )
			return false 
		end
		
		local line = {}
		
		local colour = Color(200,255,255)
		
		-- line.strippedName = ""
		
		-- line.name = ""
		
		surface.PlaySound("common/talk.wav")
		
		-- line.text = "<font=chatbox_Font_Bold><color=" .. markupColour(colour) .. ">" .. text .. "</color></font>"
		
		text = string.gsub(text, "\n", "")
		
		line.text = process_at(text)
		line.colour = colour
		line.dieTime = CurTime() + textDieTime
		
		chatbox.AddToTable(line)	
		
		chat.AddText(colour, text)
		
		if !chatbox.show then
			chatbox.scroll = 0
		end
		
		return true
	end)	

	hook.Add( "OnPlayerChat", "handleChatText", function(ply, text, isTeam, isDead)
		-- print(ply, text, isTeam, isDead)
		
		if !chatbox.table then chatbox.table = {} end	
		
		local line = {}
		
		
		
		local teamColour = Color(100,100,100)
		local name = "Server"
		if ply:IsValid() and ply:IsPlayer() then
			fusion.cl.AddChatHead(ply, text)
			
			teamColour = team.GetColor(ply:Team())
			name = ply:Name()
			
			local rank = fusion.GetRankByTeam(ply:Team())			
			local rank_data = fusion.Ranks[rank]
				
			if rank_data then
				line.icon = rank_data.Icon
				
				
			end
		end
		
		-- line.strippedName = name
		-- line.strippedName = string.gsub(line.strippedName, '%b<>', "")		
		-- line.name = "<color=" .. markupColour(teamColour) .. ">" .. name .. "</color>"
		
		surface.PlaySound("common/talk.wav")
			
		text = string.gsub(text, "\n", "")	
			
		-- print(text)	
			
		line.name = name
		line.nameColour = teamColour
		line.text = process_at(text)
		line.isTeam = isTeam
		line.isDead = isDead
		line.dieTime = CurTime() + textDieTime
		
		-- print(line.icon) 
		
		chatbox.AddToTable(line)		
		
		chat.AddText(teamColour, name, Color(255,255,255,255), ": " .. text)
		
		if !chatbox.show then
			chatbox.scroll = 0
		end
		
		return true
	end)

	local gradient_center = surface.GetTextureID("gui/center_gradient")
	local gradient_up = surface.GetTextureID("gui/gradient_up")
	local gradient = surface.GetTextureID("gui/gradient")

	local function outlineGradient(x,y,w,h, fade)
		
		draw.RoundedBox(0,x-1,y-1,w+2,h+2,Color(0,0,0,255 * fade))
		
		draw.RoundedBox(0,x, y, w, h, Color(50,50,50,255 * fade))
		
		surface.SetDrawColor(Color(0,0,0,100 * fade))
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(x,y,w,h)
		
		-- surface.SetDrawColor(Color(0,0,0,255 * fade))
		-- surface.DrawOutlinedRect(x-1,y-1,w+2,h+2)
		
		
	end
	hook.Add("OnChatTab", "OnChatTabFusion", function(text)
		if (chat.replaceWithMe) then
			return chat.replaceWithMe
		end
	end)

	chatbox.scrollNext = 0

	function chatbox.draw(w,h)
		local w,h = 600, 310
		local x,y,w,h = 1, 1, w, h	
		
		-- local x,y = 10, ScrH() - h - 120
		
		local magic = math.abs(math.sin(CurTime() * 5))
		
		local hudmult = 1-(FrameTime() / 300)
		
		-- if hudmult < 1 then print(hudmult) end
		
		if chatbox.show then
			if fade < 1 then fade = math.Clamp(fade + 0.03, 0, 1) end
		else
			if fade > 0 then fade = math.Clamp(fade - 0.03, 0, 1) end
		end	
		
		chatbox.maxLines = math.Round((h - 40 - 10 - 10) / 20)
		
		fade = math.Clamp(fade * hudmult, 0, 1)
		
		
		-- draw.RoundedBox(0,x,y,w,h,Color(0,0,0,150 * fade))	
		outlineGradient(x,y,w,h, fade*0.3 )
		
			
		if chatbox.table and #chatbox.table > 0 then
			if !chatbox.scroll then
				chatbox.scroll = 0
			end
			local start = #chatbox.table - chatbox.scroll
		
			//scroll
				
				local scroll_w = 16	
				local take = math.Clamp(#chatbox.table - chatbox.maxLines, 0, #chatbox.table)
				
				outlineGradient(x + 5 + w, 1, scroll_w, h, fade*0.3)
				
				local div = 1 - (chatbox.scroll / take)
				
				local sbar_h = math.Clamp((1-(#chatbox.table / 50)) * 60, 20, 60)
				
				local sbar_y = div * (sbar_h)
					
				local scrollBoxPos = Vector(x + 5 + w, 1 + 1)	
				local scrollBoxSize = Vector(scroll_w, h - 2)	
					
				draw.RoundedBox(0,scrollBoxPos.x, scrollBoxPos.y, scrollBoxSize.x, scrollBoxSize.y, Color(40,40,40,160 * fade))	

				surface.SetDrawColor(Color(255,255,255,5*fade))
				surface.SetTexture(fusion.cl.gradient_cen)						
				surface.DrawTexturedRect(scrollBoxPos.x, scrollBoxPos.y, scrollBoxSize.x, scrollBoxSize.y)

				local posx, posy = chatbox.frame:GetPos()
				
				local max = #chatbox.table - (chatbox.maxLines or 0)	
				
				local div = 1-((chatbox.scroll or 0) / max)
				
				
				local scrollBarSize = Vector(scrollBoxSize.x - 2, sbar_h - 10 - 2)
				local scrollBarPos = Vector(scrollBoxPos.x + 1, math.Clamp(scrollBoxPos.y + (scrollBoxSize.y * div), 0, scrollBoxPos.y + scrollBoxSize.y - scrollBarSize.y))
							
				draw.RoundedBox(2, scrollBarPos.x, scrollBarPos.y, scrollBarSize.x, scrollBarSize.y, Color(100,100,100,255*fade))
											
				surface.SetDrawColor(Color(255,255,255,50*fade))
				surface.SetTexture(fusion.cl.gradient_cen)						
				surface.DrawTexturedRect(scrollBarPos.x, scrollBarPos.y, scrollBarSize.x, scrollBarSize.y)
				
				local mouseX = gui.MouseX()
				local mouseY = gui.MouseY()
				
				if #chatbox.table > chatbox.maxLines then
					if mouseInRegion(scrollBoxPos.x + posx, scrollBoxPos.y + posy, scrollBoxSize.x, scrollBoxSize.y) then
						if input.IsMouseDown(MOUSE_LEFT) then
							grabbingScrollBar = true					
						end
					end
					
					if grabbingScrollBar and input.IsMouseDown(MOUSE_LEFT) then	
						
						local per = 1-math.Clamp((mouseY - (scrollBoxPos.y + posy)) / (scrollBoxSize.y), 0, 1)
						
						-- draw.SimpleText(per, "pacfont!", ScrW()/2, ScrH() - 100, Color(255,255,255,255))
						
						local mm = take
						chatbox.scroll = math.Round(mm * per)
					else
						grabbingScrollBar = false
					end
				end
				
				-- if (!chatbox.scrollNext or CurTime() > chatbox.scrollNext) and chatbox.table and #chatbox.table > 0 then
					-- print("asdadsdas")
					
					-- local max = #chatbox.table - (chatbox.maxLines or 0)
					
					-- if fusion.cl.IsMousePressed(1) then
						-- print("asasd")
						-- chatbox.scroll = math.Clamp((chatbox.scroll or 0) + 1, 0, max)					
						-- chatbox.scrollNext = CurTime() + 0.05
					-- elseif fusion.cl.IsMousePressed(-1) then
						-- chatbox.scroll = math.Clamp((chatbox.scroll or 0) - 1, 0, max)
						-- chatbox.scrollNext = CurTime() + 0.05
					-- end
				-- else
					
				-- end							
		
			// scroll
		
			-- PrintTable(chatbox.table)
			
			draw.RoundedBox(0,x, y + 5, w, h - 40 - 10, Color(50,50,50,50 * fade))	
			
			
			
			local line_y = y + h - 40 - 25		
			
			-- print(chatbox.maxLines)
			
			local steps = 1
			
			
			
			local chatStep = start
			while (steps <= chatbox.maxLines and chatStep >= 1) do
				-- print(chatStep)			
				local chat = chatbox.table[chatStep]
			
				if chat then		
					chatStep = chatStep - 1
					
					surface.SetFont("chatbox_Font")
					local char = ":"

					local text_fade = true
					if !chatbox.show then
						if chat.dieTime and chat.dieTime > CurTime()  then
							text_fade = true //(chat.dieTime - CurTime()) / textDieTime
						else
							text_fade = false
						end
					end
					
					local name_str = ""
					local sep = ""
					if (chat.name) then				
						name_str = string.gsub(chat.name .. ":", " ", ".")
						sep = " "
					end
						
					-- print(chat.icon)
						
					local str_tbl = chatbox.WordWrap((chat.prefix or "") .. name_str .. sep .. chat.text, w - 5, " ", true)	//120	
					
					
					
					local drawn = false
					
					-- chatbox.inRegion = false
					
					local start_x = x + 5
					local start_y = line_y + 10
					
					if text_fade and steps <= chatbox.maxLines then
						
						for j = #str_tbl, 1, -1 do
							
							if steps <= chatbox.maxLines then
							
								local area_pos = Vector(x - 10, line_y - (20 * (#str_tbl-1)))
								local area_size = Vector(w + 5, 20 * (#str_tbl))
						
								if area_pos.y < y then
									area_size.y = area_size.y - (y-area_pos.y) - 4
									area_pos.y = y + 4
								end
						
								if !drawn then
									draw.RoundedBox(0, x + 2, area_pos.y + 1, w - 4, area_size.y - 2, Color(0,0,0,70))
									
									local colour = chat.nameColour or Color(100, 100, 200)
									
									local grad_colour = Color(colour.r, colour.g, colour.b, 12 + 3 * magic)
									
									surface.SetTexture(fusion.cl.gradient)
									surface.SetDrawColor(grad_colour)	
									surface.DrawTexturedRect(x + 2, area_pos.y + 1, w - 4, area_size.y - 2)
									
									drawn = true 
									 
									if mouseInRegion(area_pos.x + posx, area_pos.y + posy, area_size.x, area_size.y) then																
										surface.SetTexture(fusion.cl.gradient_cen)
										surface.SetDrawColor(Color(150,200,255,10))	
										surface.DrawTexturedRect(area_pos.x, area_pos.y, area_size.x, area_size.y)
										
										
										
										if chatbox.mouseWasPressed(MOUSE_RIGHT) then							
											local text = string.Implode(" ", str_tbl)
										
											-- fusion.test_Announcement("'"..text.."' copied.", 5 )
											SetClipboardText(text) 
											
											surface.PlaySound("friends/friend_join.wav")
											
											chatbox.SetTimedText(1, Vector(area_pos.x + 15, area_pos.y + 10, 0),  "Copied '"..text.."'", Color(255,150,50), 0.5)
										end
									end
									
								end	
								
								local line = str_tbl[j]
								local exp = string.Explode(" ", line)
								
								if chat.icon == "" then chat.icon = nil end
								
								local prev_w = 5
								-- if chat.icon then								
									prev_w = prev_w + 18
								-- end
								

								
								local x, y = x, line_y + 10 - 20 * (#str_tbl-j)	-1					
								
								surface.SetFont("chatbox_Font")
								for b = 1, #exp do								
									local word = exp[b]
									local w, h = surface.GetTextSize(word .. " ")
									
									local colour								
																	
									if chat.prefix then
										-- local w, h = surface.GetTextSize(chat.prefix)								
										-- draw.SimpleText(chat.prefix, "chatbox_Font", x + prev_w, y, chat.colour or colour or Color(230,230,230,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
										-- draw.SimpleText(chat.name, "chatbox_Font_Blur", x + prev_w, y, chat.nameColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
										//prev_w = prev_w + w
									end
									
									if !chat.icon then
										if !fusion.cl.cachedicons then fusion.cl.cachedicons = {} end
										local mat = "icon16/bullet_white.png"
										
										if !fusion.cl.cachedicons[mat] then
											fusion.cl.cachedicons[mat] = Material("icon16/bullet_white.png")
										else
											surface.SetDrawColor(chat.nameColour or chat.colour or Color(230,230,230,255))
											surface.SetMaterial(fusion.cl.cachedicons[mat])
											surface.DrawTexturedRect(x +4, y-7, 16, 16)
										end
									end
						
									if chat.name and (word == name_str) and chat.nameColour then				
										surface.SetFont("chatbox_Font")
										local w, h = surface.GetTextSize(chat.name)							
																	
										local alp = Color(chat.nameColour.r, chat.nameColour.g, chat.nameColour.b, 200)
										
										if chatbox.show then
											alp.a = 50
										end
										
										//word = string.gsub(word, "%.", " ")
										
										word = chat.name
										
										draw.SimpleText(word, "chatbox_Font_Blur", x + prev_w, y, alp, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)											
										draw.SimpleText(word, "chatbox_Font", x + prev_w, y, chat.nameColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
						
										
						
										colour = Color(255,255,255,150)
										
										draw.SimpleText(":", "chatbox_Font", x + prev_w + w, y, colour, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										
										if chat.icon then
											if !fusion.cl.cachedicons then fusion.cl.cachedicons = {} end
											
											if !fusion.cl.cachedicons[chat.icon] then
												fusion.cl.cachedicons[chat.icon] = Material("icon16/" .. chat.icon)
											else
								
												surface.SetDrawColor(Color(255,255,255,255))
												surface.SetMaterial(fusion.cl.cachedicons[chat.icon])
												surface.DrawTexturedRect(x +4, y-7, 16, 16)
											end
										end
									end
									
									local mouseX = gui.MouseX()
									local mouseY = gui.MouseY() //  + posy
									
									-- chatbox.Selection = chatbox.Selection or ""
									
									-- if (input.IsMouseDown(MOUSE_LEFT)) then
										-- local pp = x + posx - mouseX
										-- local ff = pp / w
										
										-- local characterAt = word[math.Round(string.len(word)*ff)]
										
										
										-- print(pp, ff, characterAt)
										
										-- chatbox.Selection
									-- end
									
									-- if mouseInRegion(x + prev_w + posx, y - h/2 + posy, w, h) then
										-- glowy = Color(100, 200, 255, 200)
										
										-- if chatbox.mouseWasPressed(MOUSE_LEFT) then
											
										-- end
									-- end	
								
									if string.Left(word, 1) == "#" then
										colour = Color(255, 150, 0, 255)
										draw.SimpleText(word, "chatbox_Font_Blur", x + prev_w, y, Color(255 * magic, 150 * magic, 0, 150 * magic + 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
									elseif string.Left(word, 1) == "@" then									
										colour = Color(0, 150, 255, 255)
										draw.SimpleText(word, "chatbox_Font_Blur", x + prev_w, y, Color(0 * magic, 150 * magic, 255, 50 * magic + 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									elseif string.find(word, "http") then
										// link
										//print(word)
										//colour = Color(150, 200, 255, 255)
				
										
										local glowy = Color(25 * magic, 55 * magic + 100, 255, 55 * magic + 200, 50)
									
										if mouseInRegion(x + prev_w + posx, y - h/2 + posy, w, h) then
											glowy = Color(100, 200, 255, 200)
											
											if chatbox.mouseWasPressed(MOUSE_LEFT) then
												//fusion.test_Announcement("'"..word.."' copied.", 5 )
												SetClipboardText(word) 
												surface.PlaySound("friends/friend_join.wav")
												
												 
												
												chatbox.SetTimedText(1, Vector(area_pos.x + 15, area_pos.y + 10, 0),  "Copied '"..word.."'", Color(255,150,50), 0.5)
											end

										end
										
										draw.SimpleText(word, "chatbox_Font_Blur", x + prev_w, y, glowy, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									
										//if fusion.cl.IsMousePressed(MOUSE_LEFT) then
											
										//end
									
									else
									
									end
									
									
									
									-- if string.Left(word, 1) == "@" and string.len(word) > 1 then
										-- local name = string.Right(word, string.len(word) - 1)
										
										-- for _,ply in pairs(player.GetAll()) do
											-- if string.find(ply:Name(), name, nil, nil, true) then
												-- colour = team.GetColor(ply:Team())
												-- word = ply:Name()											
											-- end
										-- end
									-- end
									
									-- if (!string.find(word, ".", nil, nil, true)) then
										-- local a = 255
										-- if !chatbox.show then
											-- a = 150									
										-- end
										
										-- draw.SimpleText(word, "chatbox_Font", x + prev_w + 1, y + 1, Color(0,0,0,a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									-- end
									draw.SimpleText(word, "chatbox_Font", x + prev_w + 1, y + 1, Color(0,0,0,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									draw.SimpleText(word, "chatbox_Font", x + prev_w, y, colour or chat.colour or Color(230,230,230,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)																
									
									
									
									if word then prev_w = prev_w + w end						
								end

								
								-- parsed:Draw(, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
							
								steps = steps + 1
							
							end
						end						
						
						line_y = line_y - (20 * #str_tbl)
					
					end
				
				end
			end
		end
		
		-- print(h - 40 - 10)
		
		
		
		local text_pos = Vector(x,y+h-40)
		local text_size = Vector(w,30)
		
		-- render.SetScissorRect(text_pos.x, text_pos.y, text_pos.x + text_size.x, text_pos.y + text_size.y, true)
		
			draw.RoundedBox(0,text_pos.x, text_pos.y, text_size.x, text_size.y, Color(50,50,50,50 * fade))
			draw.RoundedBox(0,text_pos.x, text_pos.y + 5, text_size.x, text_size.y - 10, Color(200,200,200,255 * fade))
			
			surface.SetDrawColor(Color(255,255,255,255 * fade))
			surface.SetTexture(gradient_center)
			surface.DrawTexturedRect(text_pos.x, text_pos.y + 5, text_size.x, text_size.y - 10)
			
			local text = ""
			
			if chatbox.text then
				text = chatbox.text
				
				if table.HasValue(fusion.Settings["prefix"],  string.Left(text, 1)) then
					local exp = string.Explode(" ", text)
					local cmd = exp[1]
					
					if cmd and string.len(cmd) > 1 then
						cmd = string.Right(cmd, string.len(cmd)-1)
						
						local x, y = text_pos.x + 5, text_pos.y + text_size.y/2
						y = y - 10
						
						chat.replaceWithMe = false
						
						-- local isFirst = true
						for k,v in pairs(fusion.commands) do
							if string.Left(k, string.len(cmd)) == cmd then							
								y = y - 20
								
								surface.SetFont("chatbox_Font_NoShadow")
								
								local text = string.Left(text, 1) .. k
								local tw = surface.GetTextSize(text .. " ")
								
								draw.RoundedBox(0,text_pos.x, y, text_size.x, 20, Color(200,200,200,255 * fade))

								draw.SimpleText(text, "chatbox_Font_NoShadow", x, y + 10, Color(0,0,0,255 * fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText("- " .. v.Help, "chatbox_Font_NoShadow", x + tw, y + 10, Color(90,90,90,255 * fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								
								-- if (isFirst) then
									chat.replaceWithMe = text
								-- end
								-- isFirst = false
								
							end
						end
					end
				end
			end
			
			surface.SetFont("chatbox_Font_NoShadow")
			local text_w, text_h = surface.GetTextSize(text)	
			
			if text_w > w then
				draw.SimpleText(text, "chatbox_Font_NoShadow", text_pos.x + text_size.x - 5, text_pos.y + text_size.y/2, Color(0,0,0,255 * fade), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			else	
				draw.SimpleText(text, "chatbox_Font_NoShadow", text_pos.x + 5, text_pos.y + text_size.y/2, Color(0,0,0,255 * fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
			local posx, posy = chatbox.frame:GetPos()
			for _,obj in pairs(chatbox.TimedText) do
				-- chatbox.SetTimedText(id, pos, text, colour, life)
				
				local rem = obj.dieat - CurTime()			
				
				-- print(rem)
				
				//print(obj.pos.x - posx, obj.pos.y - posy)
				
				if (rem < 0) then
					chatbox.TimedText[obj.id] = nil						
				else
					local fade = rem / obj.life
				
					local clip = 64
					local clipped = string.Left(obj.text, clip)
				
					surface.SetFont("chatbox_Font_NoShadow")
					local w, h = surface.GetTextSize(clipped)
				
				
				
					draw.RoundedBox(2, obj.pos.x, obj.pos.y - 9, w, h, Color(0,0,0,200))
				
					draw.SimpleText(clipped, "chatbox_Font_Blur", obj.pos.x, obj.pos.y, Color(obj.colour.r, obj.colour.g, obj.colour.b, 50 * fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(clipped, "chatbox_Font_NoShadow", obj.pos.x, obj.pos.y, Color(obj.colour.r, obj.colour.g, obj.colour.b, 255 * fade), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
			
			
			
		-- render.SetScissorRect(text_pos.x, text_pos.y, text_pos.x + text_size.x, text_pos.y + text_size.y, false)
	end

	hook.Add("Think", "chatbox_start", function()	

		if !chatbox.frame then
			chatbox.start()
		else
			setVisible = true
			
			if fusion and scoreboard_up then
				setVisible = false
			end
		
			if pace and pace.Active then
				setVisible = false
			end
			
			if !setVisible then
				chatbox.frame:SetVisible(false)
			elseif setVisible then
				chatbox.frame:SetVisible(true)		
			end
		end

	end)

	function chatbox.handleScroll(delta)
		-- print(delta)
		
		if chatbox.table and #chatbox.table > 0 then
			
		else
			
		end
	end

	chatbox.MouseCaptures = {}

	function chatbox.handleMousePressed(code)	
		chatbox.MouseCaptures[code] = CurTime() + 0.03
	end

	function chatbox.mouseWasPressed(code)	
		if (chatbox.MouseCaptures[code] and chatbox.MouseCaptures[code] > CurTime()) then
			chatbox.MouseCaptures[code] = nil
			return true
		end
		
		return false
	end

	function chatbox.welcome()
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Welcome to the #inervate Sandbox Server")		
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Come chill with the boys, have a bit of a laugh and build some shit.")	
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "If i'm honest, be a cool dude and don't be a cunt and we'll get along just fine aye.")
	end

	function chatbox.initFrame()
		
		if !chatbox.frame then return end

		chatbox.frame.Paint = function()		
			chatbox.draw(w,h)		
			return true
		end
		chatbox.frame.OnMouseWheeled = function(self, delta)
			chatbox.handleScroll(delta)
			local max = #chatbox.table - (chatbox.maxLines or 0)
			
			if #chatbox.table > chatbox.maxLines then
				if delta > 0 then
					chatbox.scroll = math.Clamp((chatbox.scroll or 0) + 1, 0, max)
				elseif delta < 0 then
					chatbox.scroll = math.Clamp((chatbox.scroll or 0) - 1, 0, max)
				end
			end
			
			return true
		end
		chatbox.frame.OnMousePressed = function(self, code)
			chatbox.handleMousePressed(code)
			return true
		end	
	end

	function chatbox.start()

		-- if chatbox.frame and chatbox.frame:IsValid() then
			-- chatbox.frame = nil
		-- end

		-- local w,h = 600, 315
		-- local x,y = 10, ScrH() - h - 120
		
		local w,h = 600 + 65, 310
		local x,y = 10, ScrH() - h - 120
		
		-- local w,h = ScrW(), ScrH()
		-- local x,y = 10, ScrH(0 - h
		
		chatbox.frame = vgui.Create("DPanel")
		chatbox.frame:SetPos(x-1, y-1)
		chatbox.frame:SetSize(w+2, h+2)
		chatbox.frame:SetVisible(true)
		
		chatbox.initFrame()
				
		local middlex = x+w/2
		local middley = y+h/2
		
		local mousex = x + w - 5
		local mousey = middley
		
		input.SetCursorPos(mousex, mousey)
		
		-- chatbox.welcome()
		
		timer.Simple(1, function()
			hook.Call("StartChat")	
			hook.Call("FinishChat")
		end)		
		
	end

	function chatbox.WordWrap(str, max, delimeter, icon)
		surface.SetFont("chatbox_Font_NoShadow")	
			
		local exp = string.Explode(delimeter, str)
		
		local str_tbl = {}
		
		local buffer = ""
		
		local curPos = 1
		
		local coloured = {}

		while (exp[curPos]) do

			local word = exp[curPos] .. delimeter		
			
			local bufferW = surface.GetTextSize(buffer)
			local wordW = surface.GetTextSize(word)
					
			if curPos == 1 and icon then
				bufferW = bufferW + 20		
			end		
					
			if bufferW + wordW > max then
				if wordW > max then
					local start = 1
					for i = 1, word:len() do
						local sub = word:sub(start, i)
						local subW = surface.GetTextSize(sub)					
						
						if bufferW + subW > max then
							buffer = buffer .. word:sub(start, i-1)
							table.insert(str_tbl, buffer)
							start = i
							buffer = ""
						elseif i == word:len() then
							buffer = buffer .. sub .. delimeter
						end
					end
				else
					table.insert(str_tbl, buffer)
					buffer = word
				end
			else
				buffer = buffer .. word	
			end
			
			
			
			if curPos == #exp then
				table.insert(str_tbl, buffer)			
			end
			
			curPos = curPos + 1		
			
			-- end		
		end
		
		-- PrintTable(str_tbl)
		
		return str_tbl, #str_tbl
		
		-- for j = 1, #exp do	
			-- local word = exp[j]
			-- table.insert(line, word)
			
			-- local so_far = string.Implode(delimeter, line)
			-- local w = surface.GetTextSize(so_far)
			
			-- if (w > width) then
				-- if j == #exp then			
					-- local str, num = chatbox.WordWrap(word, width, "")
					
					-- for i = 1, num do
						-- table.insert(str_tbl, str[i])
					-- end
				-- else	
					-- table.remove(line, #line)			
					-- local imp = string.Implode(delimeter, line)			
					-- imp = string.Trim(imp)			
					-- table.insert(str_tbl, imp)
					
					-- line = {}
					
					-- table.insert(line, word)				
				-- end
				
				
			-- elseif (j == #exp) then
				-- local imp = string.Implode(delimeter, line)
				-- imp = string.Trim(imp)
				-- table.insert(str_tbl, imp)
				
				-- line = {}
			-- end
		-- end
		
		-- return str_tbl, #str_tbl
	end

end
	

-- hook.Add( "HUDShouldDraw", "fusion_ChatHide", function( name )
	-- if (name == "CHudChat") then
		-- return false
	-- end
-- end)