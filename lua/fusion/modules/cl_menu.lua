--[[ 
	Modules:
		Administration Menu
	
	Description:
		A menu used to administrate the server? derp.
 ]]

fusion.cl.Menu = {}
 
local buttongrad = surface.GetTextureID( "gui/gradient_up" )
local menudown = surface.GetTextureID( "gui/gradient_down" )

concommand.Add( "fusion_menu", function( ply )	
	
	if !fusion.SelfMod then 
		fusion.cl.DoMessage( "You do not have access to the menu" )
		return 
	end
	
	if fusion.cl.Menu.VGUI and fusion.cl.Menu.VGUI:IsValid() then fusion.cl.Menu.VGUI:Close() return end 
		
	if fusion.cl.Menu.CursorX and fusion.cl.Menu.CursorY then
		gui.SetMousePos( fusion.cl.Menu.CursorX, fusion.cl.Menu.CursorY )	
	end
	
	local width = 700
	local height = 600
	
	fusion.cl.Menu.VGUI = vgui.Create( "DFrame" ) --vgui.Create( "FusionFrame" )
	fusion.cl.Menu.VGUI:ShowCloseButton( false )
	fusion.cl.Menu.VGUI:SetTitle( "" )
	fusion.cl.Menu.VGUI:SetVisible( true )	
	fusion.cl.Menu.VGUI:SetSize( width, height)
	fusion.cl.Menu.VGUI:SetPos( ScrW() / 2 - ( width / 2 ), ScrH() / 2 - ( height / 2 ) )
	fusion.cl.Menu.VGUI:SetVisible( true )
	fusion.cl.Menu.VGUI.Paint = function()
		draw.RoundedBox( 0, 0, 0, fusion.cl.Menu.VGUI:GetWide(), fusion.cl.Menu.VGUI:GetTall(), Color(50,50,50,250) )
		
		scoreboardRow(2, 2, fusion.cl.Menu.VGUI:GetWide()-4, 26, Color(100,100,100,100), true)	
		
		scoreboardRow(2, 30, fusion.cl.Menu.VGUI:GetWide()-4, 34, Color(100,100,100,100), true)	
		
		draw.SimpleText( "Administration Menu", "FusionThick", 10, 7, Color(255,255,255,255))		
	end
	fusion.cl.Menu.VGUI:MakePopup()
	
	-- fusion.cl.Menu.VGUI.Think = function()	
		
		-- if input.IsMouseDown( MOUSE_LEFT ) 
			-- if vgui.CursorVisible() and vgui.IsHoveringWorld() then
				
				-- if fusion.cl.Menu.VGUI and fusion.cl.Menu.VGUI:IsValid() then
					-- fusion.cl.Menu.VGUI:Close()
					-- fusion.cl.Menu.VGUI = nil
				-- end
			
			-- end	
		-- end	
	-- end	
	
	local button = vgui.Create( "DButton", fusion.cl.Menu.VGUI )
		button:SetPos( fusion.cl.Menu.VGUI:GetWide() - 40 - 5, 5 )
		button:SetSize( 40, 20 )
		button:SetText( "" )	
		button.DoClick = function()
			fusion.cl.Menu.VGUI:Close()
		end
		button.Paint = function()		
			draw.RoundedBox( 0, 0, 0, button:GetWide(), button:GetTall(), button.Colour or Color( 200, 40, 40, 100 ) )		
		end
		button.OnCursorEntered = function()		
			button.Colour = Color( 255, 40, 40, 200 )
		end
		button.OnCursorExited = function()		
			button.Colour = Color( 200, 40, 40, 100 )
		end
	// close button		
		
	local page = vgui.Create( "DPanelList", fusion.cl.Menu.VGUI )
	page:SetPos( 2, 65 )
	page:SetSize( fusion.cl.Menu.VGUI:GetWide() - 4, fusion.cl.Menu.VGUI:GetTall() - 67 )
	page:SetSpacing( 2 )
	page:SetPadding( 2 )
	page:EnableHorizontal( false )
	page:EnableVerticalScrollbar( true )
	page.Paint = function()
		scoreboardRow(0, 0, page:GetWide(), page:GetTall(), Color(250,250,250,250), true)
		//draw.RoundedBox( 0, 0, 0, page:GetWide(), page:GetTall(), Color(50,50,50,250) )
	end	
	
	if fusion.cl.Menu.LastPage then	
		fusion.cl.Menu.Pages[fusion.cl.Menu.LastPage].Function( page )	
	else	
		fusion.cl.Menu.Pages[1].Function( page )	
	end
	
	local button_x = 4
	for i=1, #fusion.cl.Menu.Pages do		
		local data = fusion.cl.Menu.Pages[i]
		
		
		if data.Condition() then
		
			local button = vgui.Create( "DButton", fusion.cl.Menu.VGUI )
			button:SetText("")
			button.Alpha = 150			
			button:SetSize( 120, 30 )
			button:SetPos( button_x, 32 )
			
			button_x = button_x + 122
			
			button.Paint = function()
				//scoreboardRow(0, 0, button:GetWide(), button:GetTall(), Color(100,100,100,button.Alpha), true)
				draw.RoundedBox( 0, 0, 0, button:GetWide(), button:GetTall(), Color(100,100,100,button.Alpha))
				
				surface.SetDrawColor(fusion.cl.GetColour(BAlpha))
				surface.DrawOutlinedRect(0, 0, button:GetWide(), button:GetTall())
				
				draw.SimpleText( data.Name, "SBNormal", button:GetWide() / 2, button:GetTall() / 2, Color(255,255,255,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				//data.Name
			end	

			button.OnCursorEntered = function()
				button.Alpha = 250
			end
			
			button.OnCursorExited = function()
				button.Alpha = 150
			end
			
			button.DoClick = function()
			
				for k,v in pairs( page:GetItems() ) do
					page:RemoveItem( v )
				end	
				
				data.Function( page )
				
				fusion.cl.Menu.LastPage = i
			end		
		end
	end
	
	
end )

concommand.Add( "-fusion_menu", function( ply )
	-- if fusion.cl.Menu.VGUI and fusion.cl.Menu.LastPage == 2 then
		-- return
	-- end
	
	if fusion.cl.Menu.Focus and fusion.cl.Menu.VGUI and fusion.cl.Menu.VGUI:IsValid() then
		return false
	end	
	
	if fusion.cl.Menu.VGUI and fusion.cl.Menu.VGUI:IsValid() then 
		fusion.cl.Menu.VGUI:Close() 
		fusion.cl.Menu.VGUI = false
	end
	
	if fusion.cl.Menu.Mouse then
		fusion.cl.Menu.CursorX = gui.MouseX()
		fusion.cl.Menu.CursorY = gui.MouseY()
		-- gui.EnableScreenClicker( false )	
	end	

end )

fusion.cl.Menu.Pages = {}
fusion.cl.Menu.Pages[1] = { 
	Name = "Bans",	
	Condition = function() return true end,
	Function = function(panel)
		
		local tbl = vgui.Create("DListView")
		-- tbl:SetPos(25, 50)
		tbl:SetSize(panel:GetWide() - 4, panel:GetTall() - 4)
		tbl:SetMultiSelect(false)
		tbl:AddColumn("ID")
		tbl:AddColumn("Name")
		tbl:AddColumn("Banner")
		tbl:AddColumn("Description")
		tbl:AddColumn("Unbanned")	
		tbl.Paint = function()
			draw.RoundedBox( 0, 0, 0, tbl:GetWide(), tbl:GetTall(), Color(40,40,40,200) )
	
			surface.SetDrawColor( Color( 255, 255, 255, 40 ) )
			surface.SetTexture( buttongrad )
			surface.DrawTexturedRect( 0, 0, tbl:GetWide(), tbl:GetTall() )
		end	
		
		if fusion.Bans then
			for k,v in pairs( fusion.Bans ) do
				local unban = tonumber( v.Unban )
				-- RunConsoleCommand( "say", v.Name )
				-- RunConsoleCommand( "say", tostring( unban ) )
				
				local rem = ( unban - os.date( os.time() ) )
				local show = true
				
				if !unban or unban == 0 then
					unban = "Never"					
				elseif rem < 0 then
					show = false					
				else
					unban = fusion.ConvertTime( rem )
				end
				
				-- RunConsoleCommand( "say", tostring( unban ) )
				if show then
					local line = tbl:AddLine( k, v.Name, v.Banner, v.Description, unban )
					line.OnMouseReleased = function()					
						local menu = DermaMenu()
							menu:AddOption("Remove Ban",function() 
								Derma_Query("Confirm Ban Removal", k,
								"Confirm", function() RunConsoleCommand( "fusion", "removeban", k ) end,
								"Cancel", function() end)	 
							end)
							menu:AddOption("Edit Ban Length",function() 								 
								Derma_StringRequest(k, "Edit Ban Length", 0, function( text ) RunConsoleCommand( "fusion", "editban", k, text ) end)
							end)
						menu:Open()					
					end
				end
							
			end
		end
		
		panel:AddItem( tbl )

	end 
}
fusion.cl.Menu.Pages[2] = { 
	Name = "Ranks",	
	Condition = function() return true end,
	Function = function(panel)
		if fusion.Ranks then
				
			local tbl = vgui.Create( "DListView" )
			tbl:SetMultiSelect(false)
			tbl:AddColumn("Rank")
			tbl:SetSize(panel:GetWide() - 4, 100)				
		
			local create = vgui.Create( "DButton" )			
			create:SetText( "Create" )
			create:SetSize(panel:GetWide() - 4, 20)
			create.DoClick = function()
				if tbl:GetSelectedLine() then
					local copy = tbl:GetLine(tbl:GetSelectedLine()):GetValue(1)
					Derma_StringRequest( "New Rank", "Basing on " .. copy .. ".", "Unique ID", 
					function( text ) 
					RunConsoleCommand( "fusion", "createrank", text, copy ) 
					end )
				end				
			end	
			
			panel:AddItem( tbl )
			panel:AddItem( create )
			
			fusion.cl.Menu.SelectRank( fusion.cl.Menu.SelectedRank or "guest", panel )
			
			local ranks = fusion.Ranks
			
			for k,v in pairs( ranks ) do
				local line = tbl:AddLine( k )	
				line.OnMouseReleased = function()
					fusion.cl.Menu.SelectRank( k, panel )
					fusion.cl.Menu.SelectedRank = k
					fusion.cl.Menu.Focus = true
				end					
			end			
			
		end
	end 
}

function fusion.cl.Menu.SelectRank( rank, panel )
	
	if fusion.Ranks and fusion.Ranks[rank] then
	
		if fusion.cl.Menu.RankPanel and fusion.cl.Menu.RankPanel:IsValid() then
		
			fusion.cl.Menu.RankPanel:Remove()
		
		end
		
		fusion.cl.Menu.RankPanel = vgui.Create("DPanelList")
		fusion.cl.Menu.RankPanel:SetSize(panel:GetWide() - 4, panel:GetTall() - 115 - 15)
		fusion.cl.Menu.RankPanel:SetSpacing( 2 )
		fusion.cl.Menu.RankPanel:SetPadding( 2 )
		fusion.cl.Menu.RankPanel:EnableHorizontal( false )
		fusion.cl.Menu.RankPanel:EnableVerticalScrollbar( true )
	
		panel:AddItem( fusion.cl.Menu.RankPanel )
			
			local width = fusion.cl.Menu.RankPanel:GetWide()
			local height = fusion.cl.Menu.RankPanel:GetTall()
			
			local data = fusion.Ranks[rank]			
			
			if !data then return end
			
			local top = vgui.Create("DPanelList", fusion.cl.Menu.RankPanel)
			top:SetSize( fusion.cl.Menu.RankPanel:GetWide() -4, 150)
			top:SetPos( 2, 2 )
			top:SetSpacing( 5 )
			top:SetPadding( 5 )
			top:EnableHorizontal( false )
			top:EnableVerticalScrollbar( false )
			top.Paint = function()
				draw.RoundedBox( 0, 0, 0, top:GetWide(), top:GetTall(), Color(70,70,70,200) )
			end	
			
			local color = vgui.Create( "DColorMixer")
			color:SetSize( top:GetWide() - 10, top:GetTall() - 10)
			color:SetColor( Color( data.R, data.G, data.B, 255 ) )
			
			top:AddItem( color )
			
			local left = vgui.Create("DPanelList", fusion.cl.Menu.RankPanel)
			left:SetSize( ( fusion.cl.Menu.RankPanel:GetWide() / 2 ) - 3, fusion.cl.Menu.RankPanel:GetTall() - 120)
			left:SetPos( 2, 154 )
			left:SetSpacing( 2 )
			left:SetPadding( 2 )
			left:EnableHorizontal( false )
			left:EnableVerticalScrollbar( false )
			left.Paint = function()
				draw.RoundedBox( 0, 0, 0, left:GetWide(), left:GetTall(), Color(70,70,70,200) )
			end			
			
			local right = vgui.Create("DPanelList", fusion.cl.Menu.RankPanel)
			right:SetSize( ( fusion.cl.Menu.RankPanel:GetWide() / 2 ) - 3, fusion.cl.Menu.RankPanel:GetTall() - 120)
			right:SetPos( 2 + left:GetWide() + 2, 154)
			right:SetSpacing( 2 )
			right:SetPadding( 2 )
			right:EnableHorizontal( false )
			right:EnableVerticalScrollbar( false )
			right.Paint = function()
				draw.RoundedBox( 0, 0, 0, right:GetWide(), right:GetTall(), Color(70,70,70,200) )
			end			
			
			// NAME
			local labnam = vgui.Create("DLabel")
			labnam:SetText( "Name:" )			
			local name = vgui.Create("DTextEntry")
			name:SetText( data.Name )
			name.OnMouseReleased = function()			
				name:RequestFocus()			
			end
			
			left:AddItem( labnam )
			left:AddItem( name )
			
			// HIERARCHY			
			local labhier = vgui.Create("DLabel")
			labhier:SetText( "Hierarchy:" )			
			local hier = vgui.Create("DTextEntry")
			hier:SetText( data.Hierarchy )
			
			left:AddItem( labhier )
			left:AddItem( hier )
			
			// WEIGHT		
			local labwei = vgui.Create("DLabel")
			labwei:SetText( "Weighting:" )			
			local wei = vgui.Create("DTextEntry")
			wei:SetText( data.ID )
			
			left:AddItem( labwei )
			left:AddItem( wei )		
				
			// TIME
			local labtime = vgui.Create("DLabel")
			labtime:SetText( "Time required:" )			
			local timere = vgui.Create("DTextEntry")
			timere:SetText( data.TimeReq )			
			local labtime2 = vgui.Create("DLabel")
			labtime2.Think = function()
				local time = tonumber( timere:GetValue() )
				
				if !time then
					labtime2:SetText( "Invalid number." )
				elseif time > 10000000 then
					labtime2:SetText( "Number too long, cannot exceed 10 million!" )
				else
					labtime2:SetText( fusion.ConvertTime( time ) )
				end
			end
			
			left:AddItem( labtime )
			left:AddItem( timere )
			left:AddItem( labtime2 )	
				
			
			// HP
			local labhp = vgui.Create("DLabel")
			labhp:SetText( "Health:" )			
			local hp = vgui.Create("DTextEntry")
			hp:SetText( data.Health )
			
			right:AddItem( labhp )
			right:AddItem( hp )
			
			// ARMOUR
			local labarm = vgui.Create("DLabel")
			labarm:SetText( "Armour:" )			
			local arm = vgui.Create("DTextEntry")
			arm:SetText( data.Armour )
			
			right:AddItem( labarm )
			right:AddItem( arm )
			
			// SPEED
			local labspe = vgui.Create("DLabel")
			labspe:SetText( "Speed:" )			
			local spe = vgui.Create("DTextEntry")
			spe:SetText( data.Speed )
			
			right:AddItem( labspe )
			right:AddItem( spe )
			
			// ICON			
			local labicon = vgui.Create("DLabel")
			labicon:SetText( "Icon:" )			
			
			local location = "icon16/"
			local selected
			
			local temp = ""
			
			local icon = vgui.Create("DButton")
			icon:SetText("Icon Selection")
			icon.DoClick = function( btn )			
				Derma_StringRequest( "New Icon", "Enter an icon for this rank.", "", 
				function( text ) 
					temp = text .. ".png"
				end)
			end
			
			local ico = ""
			
			local labicon2 = vgui.Create("DLabel")
			labicon2:SetText( "" )	
			labicon2.Paint = function()
				draw.RoundedBox( 4, 0, 0, 16, 16, Color(0,0,0,255) )	
				if temp != "" then				
					if table.HasValue(silkicons, temp) then						
						ico = temp	
						-- print(ico)
						surface.SetMaterial(Material("icon16/" .. ico))
						surface.SetDrawColor( 255, 255, 255, 255 )	
						surface.DrawTexturedRect( 0, 0, 16, 16 )	
					else
						ico = ""
					end	
				else
					ico = fusion.Ranks[rank].Icon
				end
			end
				
			right:AddItem( labicon )
			right:AddItem( icon )
			right:AddItem( labicon2 )
			
			local update = vgui.Create( "DButton" )			
			update:SetText( "Update" )	
			update.DoClick = function()				
				local colour = color:GetColor()
				RunConsoleCommand( "fusion", "updaterank", 
				rank, 
				wei:GetValue(),
				hier:GetValue(),
				timere:GetValue(),
				colour.r,
				colour.g,
				colour.b,
				ico,
				hp:GetValue(),
				arm:GetValue(),
				spe:GetValue(),
				name:GetValue()) 		
			end
			
			local remove = vgui.Create( "DButton" )			
			remove:SetText( "Remove" )	
			remove.DoClick = function()				
				RunConsoleCommand( "fusion", "removerank", rank ) 		
			end
			
			left:AddItem( update )
			right:AddItem( remove )
			
			////////gfjhfgjh

			
			-- fusion.cl.Menu.RankPanel:AddItem( left )
			-- fusion.cl.Menu.RankPanel:AddItem( right )
			-- fusion.cl.Menu.RankPanel:AddItem( top )
			
	
	end
end

-- fusion.cl.Menu.Pages[3] = { 
	-- Name = "Logs",	
	-- Condition = function() return fusion.LogFiles end,
	-- Function = function(panel)

		-- local tbl = vgui.Create( "DListView" )
		-- tbl:SetSize(panel:GetWide() - 4, 100)
		-- tbl:SetMultiSelect(false)		
		
		-- fusion.cl.Menu.LogPage = vgui.Create("DListView")
		-- fusion.cl.Menu.LogPage:SetSize(panel:GetWide() - 10, panel:GetTall() - 106)
		-- fusion.cl.Menu.LogPage:SetMultiSelect(false)
		-- fusion.cl.Menu.LogPage:AddColumn("Log")			
		
		-- table.SortByMember( fusion.LogFiles, 1, function(a, b) return a > b end )
		
		-- for i=1, #fusion.LogFiles do
			-- local line = tbl:AddLine( "fusion/logs/" .. fusion.LogFiles[i] )
			-- line.OnMouseReleased = function()
				-- if tbl:GetSelectedItems() and tbl:GetSelectedItems()[1] then
					-- fusion.cl.Menu.LogPage:Clear()
					-- RunConsoleCommand( "fusion_cl_requestlog", tbl:GetSelectedItems()[1]:GetValue() )
				-- end
			-- end		
		-- end
		
		-- panel:AddItem( tbl )
		-- panel:AddItem( fusion.cl.Menu.LogPage )		
		
	-- end 
-- }

-- datastream.Hook( "fusion_menu-logpage", function( handler, id, encoded, decoded )
net.Receive( "fusion_menu-logpage", function( data )

	if fusion.cl.Menu.LogPage and fusion.cl.Menu.LogPage:IsValid() then

		str = net.ReadString()

		-- for i=1, #fusion.cl.Menu.LogData do
			fusion.cl.Menu.LogPage:AddLine( str )
		-- end
		
	end	
	
	-- print( CurTime() )

end )

fusion.cl.Menu.Pages[3] = { 
	Name = "Maps",	
	Condition = function() return true end,
	Function = function(panel)

		local tbl = vgui.Create("DListView")
		-- tbl:SetPos(25, 50)
		tbl:SetSize(panel:GetWide() - 4, panel:GetTall() - 4)
		tbl:SetMultiSelect(false)
		tbl:AddColumn("Map")
		
		if fusion.MapList then
			for k,v in pairs( fusion.MapList ) do
				
				local line = tbl:AddLine( v )
				line.OnMouseReleased = function()
			
					local menu = DermaMenu()
					
					menu:AddOption("Change to...",function() 
						Derma_Query("Confirm Map Change?", v,
						"Confirm", function() RunConsoleCommand( "fusion", "map", v ) end,
						"Cancel", function() end)	 
					end)
					menu:Open()
					
				end				
			end
		end
		
		panel:AddItem( tbl )

	end 
}