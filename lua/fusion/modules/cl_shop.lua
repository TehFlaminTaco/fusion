fusion.cl.showStore = false
fusion.points_icon = Material("icon16/coins.png")

fusion.shop_item_categories = {
	"info",
	"titles",
	"ranks",
	"hooks",
	"other"	
}

local showButtons = true

local rowColours = {}
rowColours["poverty"] = Color(100,100,100,10)
rowColours["common"] = Color(255,255,255,10)
rowColours["uncommon"] = Color(20,255,20,10)
rowColours["rare"] = Color(20,20,255,10)
rowColours["epic"] = Color(160,20,255,10)
rowColours["legendary"] = Color(255,20,20,10)
rowColours["good"] = Color(255,255,20,10)



local function getRowOverlay(price)
	if price > 5000 then
		return rowColours["good"]
	elseif price > 1000 then
		return rowColours["legendary"]
	elseif price > 500 then
		return rowColours["epic"]
	elseif price > 200 then
		return rowColours["rare"]
	elseif price > 50 then
		return rowColours["uncommon"]
	elseif price > 0 then
		return rowColours["common"]	
	else
		return rowColours["poverty"]
	end
end

local function numInCategory(cat)
	local i = 0
	for k,v in pairs(fusion.shop_item) do
		
		if (v.Category == cat) then
			i = i + 1			
		end
	end
	
	return i
end

net.Receive("fusion_SendCoins", function(data)
	local coin = net.ReadDouble()	
	fusion.myCoins = coin
	
	-- print("Coin: " .. coin)
end)

fusion.cl.shopAlphaMult = 0
fusion.cl.shopActive = false

local grabbingScrollBar = false

shop_tooltip = {}
shop_tooltip.title = ""
shop_tooltip.text = ""
shop_tooltip.hideafter = 0

function shop_tooltip.set(title, text, hideafter)
	if title and text and hideafter then
		shop_tooltip.title = title
		shop_tooltip.text = text
		shop_tooltip.hideafter = CurTime() + hideafter
	end	
end

function shop_tooltip.draw()
	if shop_tooltip.hideafter > CurTime() then
		local x = gui.MouseX()
		local y = gui.MouseY()
		
		surface.SetFont("hfmedium")
		local title_w, title_h = surface.GetTextSize(shop_tooltip.title)
		surface.SetFont("SBNormal")		
		local text_w, text_h = surface.GetTextSize(shop_tooltip.text)
		
		local padding = 10
		local space = 5
		
		local w = padding + math.max(title_w, text_w) + padding	
		local h = padding + title_h + space + text_h + padding		
				
		draw.RoundedBox(0, x, y, w, h, Color(0,0,0,100))
		
		draw.SimpleText(shop_tooltip.title, "hfmedium", x + padding, y + padding, Color(255,255,255,255))
		draw.SimpleText(shop_tooltip.text, "SBNormal", x + padding, y + padding + title_h + space, Color(255,255,255,255))
		
		
		
	end
end

if shopPane then
	shopPane:Remove()
	shopPane = nil
end

function fusion.cl.openShop()
	-- fusion.cl.ShopMult = 0
	
	
	if fusion.cl.shopActive then
		shopPane:Remove()
		shopPane = nil
		fusion.cl.shopActive = false
		
	else
		fusion.cl.shopActive = true	
	
		shopPane = vgui.Create( "DPanel" )
		shopPane:SetSize( ScrW(), ScrH() )
		shopPane:SetPos( 0, 0 )		
		shopPane:SetVisible(true)
		shopPane:MouseCapture(false)
		-- fusion.cl.AnnouncementPane:SetMouseInputEnabled(false)
		shopPane.Paint = function(w,h) 
			-- fusion.cl.ShopMult = math.Clamp(fusion.cl.ShopMult + (0.1 * FrameTime()), 0, 1)
			fusion.cl.drawShop()
		end
	end	
end

function fusion.cl.drawShop()	
	//local mult = mult //fusion.cl.shopAlphaMult
	local barCol = fusion.cl.GetColour(255)
	
	local buffer = 10
	local gap = 1
	local rowheight = 24			
	
	local max = 17
		
	local w = 600
	
	local h = 1 + buffer * 2 + max * (rowheight) - 2 + 9
	
	local x, y = ScrW()/2 - w/2, ScrH()/2 - h/2
		
	if (fusion.cl.shopActive) then
		-- fusion.cl.shopActivated = true
		if fusion.cl.shopAlphaMult < 1 then
			fusion.cl.shopAlphaMult = fusion.cl.shopAlphaMult + (0.02*fusion.cl.HUDSpeedMult)
		end
	else	
		if fusion.cl.shopAlphaMult > 0 then
			fusion.cl.shopAlphaMult = fusion.cl.shopAlphaMult - (0.02*fusion.cl.HUDSpeedMult)
		else
		
			-- shopPane:Close()
			if shopPane then
				shopPane:Remove()
				shopPane = nil	
				
				//if !scoreboard_up then
					//gui.EnableScreenClicker(false)	
					//fusion.cl.InputControl(false)
				//end
			end
			
			
		end
	end	
	
	fusion.cl.shopAlphaMult = math.Clamp(fusion.cl.shopAlphaMult, 0, 1)
		
		
		
	if (fusion.cl.shopAlphaMult > 0) then
	
		local mult = fusion.cl.shopAlphaMult
	
		if (!vgui.CursorVisible() and fusion.cl.shopActive) then
			gui.EnableScreenClicker(true)
			
			fusion.cl.InputControl(true)
		else
		
		end
	
		-- local w, h = 400, 600
		
		-- draw.RoundedBox(0, x-2, y-32, w+4, h+30 + 2, Color(0,0,0,255 * mult))	
		
		if !fusion.cl.CurCategory then fusion.cl.CurCategory = fusion.shop_item_categories[1] end
	 
		local numInCat = numInCategory(fusion.cl.CurCategory)
	 
		draw.RoundedBox(0, x-1, y-1, w+2, h+2, Color(10,10,10,255 * mult))			
		draw.RoundedBox(0, x, y, w, h, Color(50,50,50,255 * mult))
		
		fusion.cl.startfrom = fusion.cl.startfrom or 1
		
		if numInCat > max then
			fusion.cl.startfrom = math.Clamp(fusion.cl.startfrom, 1, numInCat - max + 2)
			
			if !fusion.cl.nextScrollCheck or CurTime() > fusion.cl.nextScrollCheck then
				if fusion.cl.IsMousePressed(1) then				
					fusion.cl.startfrom = math.Clamp(fusion.cl.startfrom - 1, 1, numInCat - max + 1)
					fusion.cl.nextScrollCheck = CurTime() + 0.01
				elseif fusion.cl.IsMousePressed(-1) then
					fusion.cl.startfrom = math.Clamp(fusion.cl.startfrom + 1, 1, numInCat - max + 1)
					fusion.cl.nextScrollCheck = CurTime() + 0.01
				end
			end
		
		else
			fusion.cl.startfrom = 1
		end
		
		-- local underbox_w = 0		
		
		local body_x = x
		local body_w = w
		
		local cat_h = 24
		local cat_y = y - cat_h - 2 - 1
		local cat_x = x
		for i = 1, #fusion.shop_item_categories do
		
			local text = string.upper(fusion.shop_item_categories[i])
			surface.SetFont("SBNormal")
			local text_w, text_h = surface.GetTextSize(text)
			
			local x,y,w,h = cat_x,cat_y,text_w + 10, cat_h
		
			draw.RoundedBox(0, x-1,y-1,w+2 + 10,h+2, Color(10,10,10,255 * mult))	
			
			local colour = Color(70,70,70,255 * mult)
			local inregion = false
			if mouseInRegion(x,y,w,h, 50) then
				colour = Color(100,100,100,255 * mult)
				inregion = true
			end
			
			if fusion.cl.CurCategory == fusion.shop_item_categories[i] then
				-- colour = fusion.cl.GetColour(255)
				
				draw.RoundedBox(0, x-1,y-1 + h+2,w+2 + 10,1, Color(10,10,10,255 * mult))
				
				draw.RoundedBox(0, x,y + h,w + 10,10, colour)
				draw.RoundedBox(0, x,y + h,w + 10,10, Color(255,255,255,5 * mult))
				
				draw.RoundedBox(0, body_x, y + h + 3,body_w,10, colour)
				draw.RoundedBox(0, body_x, y + h + 3,body_w,10, Color(255,255,255,5 * mult))
			end
		
			draw.RoundedBox(0, x,y,w + 10,h, colour)	
			draw.RoundedBox(0, x,y + h/2,w + 10,h/2, Color(255,255,255,5 * mult))
			
			
			draw.SimpleText(text, "SBNormal", x + 10, y + 5, Color(255,255,255,255 * mult))
			
			-- underbox_w = underbox_w + (text_w + 10) + 1
			
			if inregion then
				if fusion.cl.IsMousePressed(MOUSE_LEFT) then
					fusion.cl.CurCategory = fusion.shop_item_categories[i]
					fusion.cl.startfrom = 1
				end
			end
			
			cat_x = x + (w + 10) + 3
		end
		
		-- draw.RoundedBox(0, x-1,cat_y-1,underbox_w, cat_h + 2, Color(50,50,50,255))	
		
		local counter = 0
		
		local scrollbarPull = 0
		
		if (numInCat > max) then
			scrollbarPull = 15
			
			local rem = numInCat - max
			
			local p = (fusion.cl.startfrom-1) / (numInCat - max + 1) 
			
			local x,y,w,h = x+w-scrollbarPull,y+10+1,scrollbarPull,h-11
			draw.RoundedBox(0,x,y,w,h,Color(40,40,40,255 * mult))
			
			local scrollBarSize = math.Clamp((h-2) / rem, 20, h-2)
			
			local minY = (y+1)
			local maxY = minY + (h-2)
			
			-- print(minY + (((h-2) - scrollBarSize) * p))
			
			surface.SetDrawColor(Color(255,255,255,5*mult))
			surface.SetTexture(fusion.cl.gradient_cen)						
			surface.DrawTexturedRect(x,y,w,h)
			
			local scrollBarY = math.Clamp(minY + (((h-2) - scrollBarSize) * p), minY, maxY)
			
			draw.RoundedBox(2, x+1,scrollBarY,w-2,scrollBarSize + 2, Color(100,100,100,255 * mult))
										
			surface.SetDrawColor(Color(255,255,255,50*mult))
			surface.SetTexture(fusion.cl.gradient_cen)						
			surface.DrawTexturedRect(x+1,scrollBarY,w-2,scrollBarSize + 2)
			
			-- draw.RoundedBox(0, x+1,scrollBarY,(w-2)/2,scrollBarSize, Color(0,0,0,50 * mult))
							
			local mouseX = gui.MouseX()
			local mouseY = gui.MouseY()
			
			if mouseInRegion(x,y,w,h, 50) then
				if input.IsMouseDown(MOUSE_LEFT) then
					grabbingScrollBar = true					
				end
			end
			
			if grabbingScrollBar and input.IsMouseDown(MOUSE_LEFT) then								
				local per = math.Clamp((mouseY - y+1) / (h-2), 0, 1)
				
				-- draw.SimpleText(per, "pacfont!", ScrW()/2, ScrH() - 100, Color(255,255,255,255))
				
				local mm = (numInCat - max) + 1
				fusion.cl.startfrom = math.Round(mm * per)
			else
				grabbingScrollBar = false
			end

		end
		
		local oneHook = false
		local oneRank = false
		
		if fusion.cl.CurCategory != "info" then
			local row_y = y + buffer + gap
			for i = 1, #fusion.shop_item do
				local data = fusion.shop_item[i]
				if data and counter < max and i >= fusion.cl.startfrom then			
					if data.Category == fusion.cl.CurCategory then					
						counter = counter + 1
			
						local x,y,w,h = x + gap, row_y, w - gap*2 - scrollbarPull, rowheight
				
						local colour = Color(70,70,70,255 * mult)
						local inregion = false
						if mouseInRegion(x,y,w,h, 40) then
							-- colour = Color(100,100,100,255 * mult)
							inregion = true
							if (data.Description) then
								shop_tooltip.set(data.Name, data.Description, 0.01)
							end
						end
				
						draw.RoundedBox(0, x,y,w,h, colour)	
						draw.RoundedBox(0, x,y + h/2,w,h/2, Color(255,255,255,1 * mult))	
						
						surface.SetTexture(fusion.cl.gradient)
						surface.SetDrawColor(getRowOverlay(data.Price))	
						surface.DrawTexturedRect(x,y,w,h)		
						
						if inregion then
							-- colour = Color(100,100,100,255 * mult)
							
							surface.SetTexture(fusion.cl.gradient_cen)
							surface.SetDrawColor(Color(255,255,255,10 * mult))	
							surface.DrawTexturedRect(x,y,w,h)	
						
							-- inregion = true
						end
						
						draw.SimpleText(data.Name, "SBNormal", x + 5, y + 5, Color(255,255,255,255 * mult))
						-- draw.SimpleText(i, "SBNormal", x + 5, y + 5, Color(255,255,255,255 * mult))
						
						local buy_w, buy_h = 60, h
						local buy_x, buy_y = x + w - buy_w, y
						
						draw.RoundedBox(0, buy_x,buy_y,buy_w,buy_h, Color(25,25,25,100 * mult))
						
						local price = data.Price
						
						if (fusion.net_vars["hook"] and data.Category == "hooks") then	

							
							local hooktype = fusion.net_vars["hook"] or "default"
							local hookdata = fusion.hookItems[hooktype]
							
							if (hookdata and hookdata.Price) then
								
							
								price = math.max(0, price - hookdata.Price)
								
								if !oneHook and price>0 then oneHook = i end
							end		
						end
						
						if (fusion.net_vars["rank"] and data.Category == "ranks") then
							
						
							local ranktype = fusion.net_vars["rank"]
							local itemdata = fusion.rankItems[ranktype]
							local rankdata = fusion.Ranks[ranktype]
							
							if (itemdata and itemdata.Price) then
								
							
								price = math.max(0, price - itemdata.Price)
								
								
								
								-- local rankdata // make ranks that are greater than current rank disabled with red line across??
								
							end	
							
							if !oneRank and price>0 then oneRank = i end
						end
						
						if price > 0 then						
							draw.SimpleText("$" .. price, "SBNormal", buy_x + buy_w/2, buy_y + 5, Color(255,255,255,255 * mult), TEXT_ALIGN_CENTER)
						else
							draw.SimpleText("Free", "SBNormal", buy_x + buy_w/2, buy_y + 5, Color(255,255,255,255 * mult), TEXT_ALIGN_CENTER)
						end
						
						local buy_text = "Purchase"
						local isFree = false
						
						if (data.Category == "hooks" or data.Category == "ranks") then
							buy_text = "Upgrade"
						end
					
						if price == 0 then						
							buy_text = "Use"
							isFree = true
							
							if (data.Category == "hooks" or data.Category == "ranks") then
								buy_text = "Downgrade"
							end
						end
						
						local isCur = false
						if fusion.cl.curPrimaryItem == i then
							isCur = true
						
							draw.RoundedBox(0, buy_x,buy_y,buy_w,buy_h, Color(25,25,25,255 * mult))	
							draw.RoundedBox(0, buy_x,buy_y,buy_w,buy_h, fusion.cl.GetColour(100 * mult))	
							
							
							draw.SimpleText(buy_text, "SBNormal", buy_x + buy_w/2, buy_y + 5, Color(255,255,255,255 * mult), TEXT_ALIGN_CENTER)						
						end
						
						local allowBuy = true
						if (data.Category == "ranks" and oneRank!=i and price>0) then
							draw.RoundedBox(0, x,y,w,h, Color(255,0,0,50 * mult))
							draw.SimpleText("LOCKED", "SBNormal", x+w/2, y+h/2, Color(255,255,255,255 * mult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
							allowBuy = false
							
						elseif (data.Category == "hooks" and oneHook!=i and price>0) then
							draw.RoundedBox(0, x,y,w,h, Color(255,0,0,50 * mult))
							draw.SimpleText("LOCKED", "SBNormal", x+w/2, y+h/2, Color(255,255,255,255 * mult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
							allowBuy = false
					
						end
						
						if mouseInRegion(buy_x,buy_y,buy_w,buy_h, 60) and isCur then						
							-- print(1)
							if fusion.cl.IsMousePressed(MOUSE_LEFT) then
								
								if isFree and data.Category == "titles" then
									Derma_Query("Do you want to use the title " .. data.Name .. "?", 
									"Fusion Shop", 
									"Confirm", function() RunConsoleCommand("fusion", "buyitem", i) end, 
									"Cancel", function() end)
								else
									Derma_Query("Confirm purchase of (" .. string.upper(data.Category) .. ") " .. data.Name .. "?", 
									"Fusion Shop", 
									"Confirm", function() RunConsoleCommand("fusion", "buyitem", i) end, 
									"Cancel", function() end)
								end
								
								
								
								-- RunConsoleCommand("fusion.cl_buyitem", i)
								fusion.cl.curPrimaryItem = nil
							end
						elseif inregion then	
							-- print(2)
							
							
							if allowBuy then
						
								if fusion.cl.IsMousePressed(MOUSE_LEFT) then
									
									if fusion.cl.curPrimaryItem == i then
										fusion.cl.curPrimaryItem = false
									else
										fusion.cl.curPrimaryItem = i
									end
								
								end	
								
							end
								
						end
						
						row_y = row_y + rowheight + gap		
					end	
				end
			end
		else

			local boxCol = Color(50,50,50,255 * mult)
			local textCol = Color(255,255,255,255 * mult)
		
			local box_x, box_y, box_w, box_h = x + 3, y + 14, w - 6, h - 28
			draw.RoundedBox(0, box_x, box_y, box_w, box_h, boxCol)
			
			local font = "SBNormal"
			draw.SimpleText("Fusion Shop", font, box_x + 5, box_y + 5, textCol)
			
			local points = {
				"You gain 5 coin every 5 minutes.",
				"Coin is lost when purchases are made.",
				"Titles purchased will over-write your previous title.",
				"You will need to re-purchase your previous title if you want it back.", 
				"Ranks and hooks work through an upgrade system.", 
				"Your current rank/ hook is refunded when an upgrade is purchased."
			}
			
			local text_gap = 16 + 4
			local text_y = box_y + 5 + text_gap
			
			for i = 1, #points do				
				local str = points[i]
				draw.RoundedBox(0, box_x + 5 + 4, text_y + 4, 16 - 8, 16 - 8, textCol)
				draw.SimpleText(str, font, box_x + 5 + 20, text_y, textCol)
				
				text_y = text_y + text_gap
			end
			
		end
		
		local cont_w = 150
		local cont_x = x + w - 150 + 1
		
		
		draw.RoundedBox(0, cont_x, y - 30, cont_w, 29, Color(0,0,0,255 * mult))
		draw.RoundedBox(0, cont_x + 1, y - 30+1, cont_w-2, 28, Color(50,50,50,255 * mult))
		draw.RoundedBox(0, cont_x + 1, (y - 30+1) + 28/2, cont_w-2, 28/2, Color(0,0,0,20 * mult))
		
		surface.SetFont("SBNormal")
		local pt = string.upper(fusion.points_name) .. ": "
		local text_w, text_h = surface.GetTextSize(pt)
				
		surface.SetDrawColor(Color(255,255,255,255 * mult))
		surface.SetMaterial(fusion.points_icon)
		surface.DrawTexturedRect(cont_x + 5, (y - 30+1) + 28/2 - 8, 16, 16)
		draw.SimpleText(fusion.myCoins or 0, "SBNormal", cont_x + 5 + 20, (y - 30+1) + 28/2, Color(255,255,255,255 * mult), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		if (true) then
			local x,y,w,h = x + w - 20, (y - 30+1) + 28/2 - 8, 16, 16
			draw.RoundedBox(4, x,y,w,h, Color(255,0,0,255 * mult))		
			
			
			
			if mouseInRegion(x,y,w,h, 550) then
				-- colour = Color(100,100,100,255 * mult)
				
				surface.SetTexture(fusion.cl.gradient_cen)
				surface.SetDrawColor(Color(255,255,255,20 * mult))	
				surface.DrawTexturedRect(x,y,w,h)	
			
				if (input.IsMouseDown(MOUSE_LEFT)) then
					fusion.cl.shopActive = false
					
					gui.EnableScreenClicker(false)	
					fusion.cl.InputControl(false)
				end
			else
				surface.SetTexture(fusion.cl.gradient_cen)
				surface.SetDrawColor(Color(0,0,0,100 * mult))	
				surface.DrawTexturedRect(x,y,w,h)
			end
		end
		
		shop_tooltip.draw()
	end
	
	local x,y,w,h = x-5,ScrH()-15, w+10, 15
	
	
	local text = "open"
	
	if fusion.cl.shopActive then
		text = "close"
	end
	
	if !(fusion.cl.AlphaMult > 0) then
		-- x,y,w,h = x,ScrH()-5, w, 5		
		-- fusion.cl.shopActive = false
	else
		
	end
	
	-- draw.RoundedBox(0,x,y,w,h, barCol)
	
	-- if (h == 15) then
		-- local col = fusion.cl.GetColour(255 * mult)
		
		-- local add = col.r + col.g + col.b
		
		-- local textcol = Color(255,255,255,255 * mult)
		
		-- if add > (255 * 1.5) then
			-- textcol = Color(0,0,0,255 * mult)
		-- end
	
		-- draw.SimpleText("Click here to "..text.." the shop.", "SBNormal", x + w/2 + 1, y + h/2 + 1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- draw.SimpleText("Click here to "..text.." the shop.", "SBNormal", x + w/2, y + h/2, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- end
	
	-- if (mouseInRegion(x,y,w,h)) then
		-- if fusion.cl.IsMousePressed(MOUSE_LEFT) then
			-- fusion.cl.shopActive = !fusion.cl.shopActive
		-- end
	-- end

end