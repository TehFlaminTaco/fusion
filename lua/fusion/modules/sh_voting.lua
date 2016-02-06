--[[ 
	Modules:
		Voting
	
	Description:
		Functions and commands related to voting.
 ]]
 
fusion.commands["vote"] = {
	Name = "Vote",	
	Hierarchy = 0,
	Category = "voting",
	Args = 1,
	Help = "Vote for an option in the currently active vote.",
	Message = "%s voted for %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = tonumber(args[1])
		
		if !name then 
			fusion.Message( ply, "Invalid vote" )
			return
		end	
		
		if fusion.ActiveVote then
			if table.HasValue( fusion.ActiveVote.Voted, ply ) then
				fusion.Message( ply, "You have already voted" )
				return
			end	
			
			if fusion.ActiveVote.Options[name] then
				fusion.ActiveVote.OptionCounts[name] = fusion.ActiveVote.OptionCounts[name] + 1
				fusion.Message( ply, "You have voted for '" .. fusion.ActiveVote.Options[name] .. "'" )
				table.insert( fusion.ActiveVote.Voted, ply )
					
				print(name)
					
				net.Start("fusion_Voting_IncrementOption")
				net.WriteDouble(tonumber(name))
				net.Broadcast()
			else
				fusion.Message( ply, "That option doesn't exist" )
			end
		else
			fusion.Message( ply, "There is currently no active vote" )
		end	
				
	end	
}

fusion.commands["votekick"] = {
	Name = "Votekick",	
	Hierarchy = 60,
	Category = "voting",
	Args = 1,
	Help = "Starts a vote to kick a player.",
	Message = "%s started a vote to kick %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		-- local optional = args[2] or false
		
		if !fusion.ActiveVote then			
			
			local targets
			local UniqueIDs = {}
			local TargetIDs = {}
			local TargetNames = {}
			local players = fusion.sv.GetPlayers( ply, cmd, name )
			if players and table.Count( players ) > 0 then
				for k,v in pairs( players ) do
					table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
					table.insert( TargetIDs, v:UniqueID() )
					table.insert( TargetNames, v:Name() )
				end
						
				local command = string.Implode( "|", TargetIDs )
				-- if optional then
					-- fusion.CreateVote( "Kick " .. string.Implode( ", ", TargetNames ) .. " with reason '" .. reason .. "'?", ( "fusion kick " .. command .. " " .. reason ), 15, true )
				-- else
					fusion.CreateVote( "Kick " .. string.Implode( ", ", TargetNames ) .. "?", ( "fusion kick " .. command ), 15, true )
				-- end
				
				local tarstring = string.Implode( ", ", UniqueIDs )
				for k,v in pairs( player.GetAll() ) do	
					local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring )
					fusion.Message( v, msg )
					-- fusion.sv.ConsoleMessage( ply, msg )
				end				
			end				
		else
			fusion.Message( ply, "There is already an active vote" )
		end	
				
	end	
}

fusion.commands["votemax"] = {
	Name = "Vote Max",	
	Hierarchy = 80,
	Category = "voting",
	Args = 1,
	Help = "Starts a vote to change the maximum number of a type of entity that can be spawned.",
	Message = "%s started a vote to change the #{%s}# limit to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local new = tonumber( args[2] )
		
		if !fusion.ActiveVote then			
			
			if !new then fusion.Message( ply, "You must enter a numerical value to change the convar to" ) return false end
			
			local cvar = "sbox_max" .. name
			
			if !ConVarExists( cvar ) then fusion.Message( ply, "#{" .. cvar .. "}# does not exist" ) return false end
				
			local command = ( cvar .. " " .. new )

			fusion.CreateVote( "Change the " .. name .. " limit to " .. new .. "?", command , 15, true )
			
			for k,v in pairs( player.GetAll() ) do	
				local msg = string.format( message, fusion.PlayerMarkup( ply ), name, new )
				fusion.Message( v, msg )
				-- fusion.sv.ConsoleMessage( ply, msg )
			end				
			
		else
			fusion.Message( ply, "There is already an active vote" )
		end	
				
	end	
}

/*
fusion.commands["votemap"] = {
	Name = "Vote Map",	
	Hierarchy = 80,
	Category = "voting",
	Args = 1,
	Help = "Starts a vote to change the map.",
	Message = "%s started a vote to change the map to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		if !fusion.ActiveVote then			
			
			local maps = fusion.sh.GetMaps()
			
			if !table.HasValue( maps, name ) then 
				fusion.Message( ply, "#{" .. name .. "}# does not exist" )	
			end
			
			local cvar = "fusion map"	
				
			local command = ( cvar .. " " .. name )

			fusion.CreateVote( "Change the map to " .. name .. "?", command , 15, true )
			
			for k,v in pairs( player.GetAll() ) do	
				local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
				fusion.Message( v, msg )
				fusion.sv.ConsoleMessage( ply, msg )
			end				
			
		else
			fusion.Message( ply, "There is already an active vote" )
		end	
				
	end	
}
*/

fusion.commands["dovote"] = {
	Name = "Vote Question",	
	Hierarchy = 40,
	Category = "voting",
	Args = 1,
	Help = "Starts a vote asking a question.",
	Message = "%s started a vote with the question '%s?'",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = string.Implode( " ", args )
		
		if !fusion.ActiveVote then
			fusion.CreateVote(name, false, 15, true)
			
			for k,v in pairs( player.GetAll() ) do	
				local msg = string.format( message, fusion.PlayerMarkup( ply ), name )
				fusion.Message( v, msg )
				-- fusion.sv.ConsoleMessage( ply, msg )
			end	
			
		else
			fusion.Message( ply, "There is already an active vote" )
		end	
				
	end	
}

if SERVER then
	
	function fusion.CreateVote( question, command, time, bool, ... )
		if ( bool or ( #arg > 2 and #arg < 10 ) ) and ( !fusion.ActiveVote or CurTime() > fusion.ActiveVote.Time ) then
			time = math.Clamp( time, 15, 60 )
			
			fusion.ActiveVote = { Question = question, Command = command, Time = CurTime() + time, Options = {}, Voted = {}, OptionCounts = {}, VoteTimer = 0 }			
			
			fusion.GlobalMessage("A vote has started, open the scoreboard to vote!")
			
			if bool then
				fusion.ActiveVote.Options = {"Yes", "No"}
				
				for i=1,2 do
					table.insert(fusion.ActiveVote.OptionCounts, 0)
				end
			else
				for i=1,#arg do
					table.insert(fusion.ActiveVote.OptionCounts, 0)
				end
				
				fusion.ActiveVote.Options = arg				
			end
			
			fusion.ActiveVote.VoteTimer = CurTime() + time
			
			net.Start("fusion_Voting")
			net.WriteTable(fusion.ActiveVote)		
			net.Broadcast()
			
			timer.Simple(time, function()			
			
				if fusion.ActiveVote then
					local data = fusion.ActiveVote					
					
					local highest = false
					local totalvoted = 0
					local duplicate = false
					
					for i = 1, #data.OptionCounts do
						if !highest or data.OptionCounts[i] > data.OptionCounts[highest] then
							highest = i
							duplicate = false
						elseif data.OptionCounts[i] == data.OptionCounts[highest] then 
							duplicate = true
						end	
						
						totalvoted = totalvoted + data.OptionCounts[i]
					end	
					
					if data.Command and !duplicate then
						if bool then
							if highest == 1 then
								game.ConsoleCommand( data.Command .. "\n" )
								print( data.Command )
							end
						else
							game.ConsoleCommand( data.Command .. " " .. winner .. "\n" )
						end					
					end					
					
					local stbl = {}
					
					for i = 1, #data.OptionCounts do
						local d = data.OptionCounts[i]
						local perc = math.Round( d / totalvoted * 100 )
						table.insert( stbl, data.Options[i] .. " - " .. perc .. "% ('" .. data.Options[i] .. "')" )
					end
						
					for k,v in pairs( player.GetAll() ) do
						fusion.Message( v, "Voting concluded for '" .. data.Question .. "'" )
						fusion.Message( v, string.Implode( ", ", stbl ) )
						if data.OptionCounts[highest] == 0 then
							fusion.Message( v, "Nobody voted, no option won" )
						elseif duplicate then
							fusion.Message( v, "The vote was tied, no option won" )
						else			
							fusion.Message( v, "The winner was '" .. data.Options[highest] .. "'" )
						end	
					end
					
					fusion.ActiveVote = nil
				
				end
			
			end )
		else
			return false			
		end	
	end
	
else
	local gradleft = surface.GetTextureID( "gui/center_gradient" )
	
	net.Receive( "fusion_Voting_IncrementOption", function(len)	
		-- print(1)
		local vote = fusion.cl.ActiveVote
		if vote then
			local index = net.ReadDouble()
			-- print(index)
			vote.OptionCounts[index] = vote.OptionCounts[index] + 1			
		end
	end)
	
	net.Receive( "fusion_Voting", function(len)	
		fusion.cl.ActiveVote = net.ReadTable()
		
		-- if fusion.cl.VotePanel and fusion.cl.VotePanel:IsValid() then
			-- fusion.cl.VotePanel:Close()
		-- end
		
		-- local height = ( table.Count( fusion.cl.ActiveVote.Options ) * 25 ) + 40
				
		-- fusion.cl.VotePanel = vgui.Create( "FusionFrame" )
		-- fusion.cl.VotePanel:SetSize( 300, height)
		-- fusion.cl.VotePanel:SetPos( -305, ScrH() / 2 - ( height / 2 ) )
		-- fusion.cl.VotePanel:SetVisible( true )
		-- fusion.cl.VotePanel.Paint = function()
			-- draw.RoundedBox( 0, 0, 0, fusion.cl.VotePanel:GetWide(), fusion.cl.VotePanel:GetTall(), Color(0,0,0,150) )
			-- draw.DrawText( fusion.cl.ActiveVote.Question, "DefaultBold", fusion.cl.VotePanel:GetWide() / 2, 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		-- end
		
		-- local panel = vgui.Create( "DPanelList", fusion.cl.VotePanel )
		-- panel:SetSize( fusion.cl.VotePanel:GetWide() - 10, fusion.cl.VotePanel:GetTall() - 35 )
		-- panel:SetPos( 5, 30 )	
		-- panel:SetSpacing( 4 )
		-- panel:EnableHorizontal( false )
		-- panel:EnableVerticalScrollbar( false )	
		-- panel.Paint = function()			
			-- draw.RoundedBox( 0, 0, 0, panel:GetWide(), panel:GetTall(), Color(50,50,50,200) )
		-- end
		
		-- for k,v in pairs( fusion.cl.ActiveVote.Options ) do
			-- local button = vgui.Create( "DButton" )
			-- button:SetText( k )
			
			-- button.alpha = 50
			
			-- button.Paint = function()			
				-- draw.RoundedBox( 0, 0, 0, button:GetWide(), button:GetTall(), Color(120,120,120,100) )
				
				-- surface.SetDrawColor( Color( 255, 255, 255, button.alpha ) )
				-- surface.SetTexture( gradleft )
				-- surface.DrawTexturedRect( 0, 0, button:GetWide(), button:GetTall() )
			-- end
			
			-- button.OnCursorEntered = function()
				-- button.alpha = 100
			-- end
			
			-- button.OnCursorExited = function()
				-- button.alpha = 50
			-- end
			
			-- button.DoClick = function()
				-- fusion.cl.VotePanel:Close()
				-- fusion.cl.VotePanel = nil
				-- LocalPlayer():ConCommand( "fusion vote " .. k )				
			-- end			
			
			-- panel:AddItem( button )
		-- end	
		
		-- fusion.cl.VotePanel:MoveTo( 10, ScrH() / 2 - ( height / 2 ), 0.5 )
		
	end )

end	