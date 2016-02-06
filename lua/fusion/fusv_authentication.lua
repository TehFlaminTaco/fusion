-- require("gatekeeper")

function tosteamid(cid)
	local steam64=tonumber(cid:sub(2))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.abs(6561197960265728 - steam64 - a) / 2
	local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
	return sid
end

function fusion.sv.PlayerAuth(steam, ip, server_pass, user_pass, name)	
	if fusion.Bans then
		local id = tosteamid(steam)
		if fusion.Bans[id] then
			
			if fusion.Bans[id].Unban and tonumber( fusion.Bans[id].Unban ) > 0 then
				local remaining = fusion.Bans[id].Unban - os.date( os.time() )				
				if remaining > 0 then
					local unban = tostring( fusion.ConvertTime( remaining ) )
					return false, Format("[Fusion] '%s' is banned and will be unbanned in %s.", id, unban)
				else
					fusion.sv.RemoveBan( id )
				end					
			else			
				return false, Format("[Fusion] '%s' is permanently banned.", id)			
			end
			
		end
	end	

	fusion.GlobalMessage( name .. " has connected to the server.", bool, time )
end
hook.Add( "CheckPassword", "PlayerAuthorization", fusion.sv.PlayerAuth )

function fusion.sv.BanDrop( ply )
	local steam = ply:SteamID()
	if steam and fusion.Bans and fusion.Bans[steam].Unban and fusion.Bans[steam].Unban > 0 then
		local remaining = fusion.Bans[steam].Unban - os.date( os.time() )				
		local unban = tostring( fusion.ConvertTime( remaining ) )
		fusion.sv.DropPlayer( ply, Format("[Fusion]: You have been banned and will be unbanned in %s.", unban) )
	else			
		fusion.sv.DropPlayer( ply, Format("[Fusion]: You have been permanently banned.")	)		
	end
end

function fusion.sv.DropPlayer( ply, reason )
	-- local userid = ply:UserID()
	-- gatekeeper.Drop( userid, reason )
	ply:Kick(reason)
end

function fusion.sv.DropSteamID( steamid, reason )

end