// Shared functions

fusion.Settings = {}
fusion.Settings["teams"] = true
fusion.Settings["prefix"] = {"/", "!", ".", "@"}
fusion.Settings["hierarchy"] = true
fusion.Settings["pointname"] = "Coins" --"Inervates"

-- ranks
fusion.Settings["superadmin-rank"] = "owner"
fusion.Settings["headadmin-rank"] = "headadmin"
fusion.Settings["admin-rank"] = "admin"
fusion.Settings["default-rank"] = "guest"

function fusion.GetRankByTeam( id )
	if !fusion.Ranks then return false end
	for k,v in pairs( fusion.Ranks ) do
		if v.ID == id then return k	end
	end
	return false
end

-- function fusion.FormatMessage( format, ... )
	-- return string.gsub( format, "/p/{(%d+)/}", function( i ) return arg[ tostring( i ) + 1 ] end )
-- end	

function fusion.FindPlayerByData( data )
	for k,v in pairs( player.GetAll() ) do
		if string.find( string.lower(v:Name()), string.lower(data), nil, true ) then
			return v
		elseif string.lower(v:SteamID()) == string.lower(data) then
			return v
		elseif data == v:UniqueID() then
			return v
		end
	end
	return false
end

-- function fusion.GetKeyByMember( tbl, var, data )
	-- for k,v in pairs( tbl ) do
		-- if v[var] == data then
			-- return k
		-- end
	-- end
-- end

function fusion.sh.TableHasData( tbl )
	if table.Count( tbl ) > 0 then
		return true
	end
end
		
function fusion.sh.GetMaps()
	local maps = file.Find( "maps/*", "GAME" )
	local tbl = {}
	for k,v in pairs( maps ) do
		if string.Right( v, 4 ) == ".bsp" then
			local len = string.len( v )
			local map = string.Left( v, len - 4 )
			table.insert( tbl, map )
		end	
	end
	return tbl
end

function fusion.PlayerMarkup( ply )	
	local id = ply:UniqueID()
	
	return "|pl|" .. id .. "|/pl|"
end

function fusion.PlayerMarkupRecieve( ply )	
	local t = ply:Team()
	local c = team.GetColor( t )
	local n = ply:Name()
	
	n = string.gsub(n, '<', "(")
	n = string.gsub(n, '>', ")")
	
	n = string.gsub(n, ">", "'>'")
	
	local c_markup = c.r..","..c.g..","..c.b..","..c.a
	
	return ( "<color=" .. c_markup .. ">" .. n .. "</color>" )	
end

function fusion.TeamMarkup( t )	
	local c = team.GetColor( t )
	local n = team.GetName( t )
	
	local c_markup = c.r..","..c.g..","..c.b..","..c.a
	
	return ( "<color=" .. c_markup .. ">" .. n .. "</color>" )	
end

function fusion.CommandMarkup(c)	
	local cmd = fusion.commands[c] 
	if cmd then
		return ( "#{" .. cmd.Name .. "}#" )
	end
end

function fusion.cl.ColorMarkupString(a)

	if (fusion.cl and fusion.cl.GetColour) then
		local primary = fusion.cl.GetColour(alp)
		return primary.r..","..primary.g..","..primary.b..","..a	
	else
		return "255,255,255,255"
	end
end

fusion.Tags = {}
fusion.Tags["pl"] = function(s)
	if s == "IDConsole" then return "<color=150,150,150,150>Console</color>" end
	if s == "IDDisconnected" then return "<color=150,150,150,150>Disconnected Players</color>" end
	
	local ob = player.GetByUniqueID( s )
	if IsValid( ob ) then
		return fusion.PlayerMarkupRecieve( ob )	
	end
	local ob = player.GetByUniqueID( s )
	if IsValid( ob ) then
		return fusion.PlayerMarkupRecieve( ob )	
	end
	return ( "<color=150,150,150,150>Disconnected Player</color>" )	
end

fusion.Tags["tm"] = function(s)
	return fusion.TeamMarkup(s)
end

fusion.Tags["cm"] = function(s)
	local cmd = fusion.commands[s] 
	if cmd then
		return ( "<color="..fusion.cl.ColorMarkupString(255)..">" .. cmd.Name .. "</color>" )
	end
end

function fusion.ReturnMarkup( msg )

	parse = ""	
	parse = parse .. msg
		
	parse = string.gsub( parse, "#{", "<color="..fusion.cl.ColorMarkupString(255)..">" )		
	parse = string.gsub( parse, "}#", "</color>" )
		
	-- parse = string.gsub( parse, "%b{}", function( s ) -- players
	
	for k,v in pairs(fusion.Tags) do
		parse = string.gsub( parse, "|" .. k .. "|(.-)|/" .. k .. "|", v )
	end
	
	-- parse = string.gsub( parse, "%b--", function( s )  -- teams
		-- s = TrimString( s, 1 )
		-- if cmd then
			-- return fusion.TeamMarkup( t )
		-- end
	-- end )
	
	-- parse = string.gsub( parse, "%b||", function( s )
		-- s = TrimString( s, 1 )
		-- local cmd = fusion.commands[s] 
		-- if cmd then
			-- return ( "<color="..fusion.cl.ColorMarkupString(255)..">" .. cmd.Name .. "</color>" )
		-- end
	-- end )	
					
	-- local last = string.Right( parse, 1 )
	-- local endchars = { ".", ",", "!", "-", "=", "%", "&", "*", ")", "(", "+" }
	-- if !table.HasValue( endchars, last ) then
		-- parse = parse .. "<color=255,255,255,255>.</color>"
	-- end
	
	if (SERVER) then
		parse = string.gsub( parse, "%b<>", "")
	end
	
	return parse

end

function TrimString( str, trim )

	str = string.Right( str, string.len( str ) - trim )
	str = string.Left( str, string.len( str ) - trim )
	
	return str	
end


-- local superadmin = fusion.Ranks[fusion.Settings["superadmin-rank"]]
-- local headadmin = fusion.Ranks[fusion.Settings["headadmin-rank"]]
-- local admin = fusion.Ranks[fusion.Settings["admin-rank"]]



if CLIENT then	
	local plr = debug.getregistry().Player
	-- local console = debug.getregistry().Entity

	function plr:IsSuperAdmin() 
		local my_rank = fusion.Ranks[fusion.GetRankByTeam(self:Team())]
		local my_hierarchy = my_rank.Hierarchy
		return my_hierarchy and my_hierarchy >= 80
	end	
	
	function plr:IsAdmin() 
		local my_rank = fusion.Ranks[fusion.GetRankByTeam(self:Team())]
		local my_hierarchy = my_rank.Hierarchy
		return my_hierarchy and my_hierarchy >= 70
	end
	
	function plr:IsMod() 
		local my_rank = fusion.Ranks[fusion.GetRankByTeam(self:Team())]
		local my_hierarchy = my_rank.Hierarchy
		return my_hierarchy and my_hierarchy >= 60
	end
	
	function plr:IsVIP() 
		local my_rank = fusion.Ranks[fusion.GetRankByTeam(self:Team())]
		local my_hierarchy = my_rank.Hierarchy
		return my_hierarchy and my_hierarchy >= 40
	end
	
	function plr:IsRegular() 
		local my_rank = fusion.Ranks[fusion.GetRankByTeam(self:Team())]
		local my_hierarchy = my_rank.Hierarchy
		return my_hierarchy and my_hierarchy >= 10
	end
end

