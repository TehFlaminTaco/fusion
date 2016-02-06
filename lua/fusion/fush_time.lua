function fusion.ConvertTime( seconds )
	local w = math.floor(seconds/604800)
	local d = math.floor(seconds%604800/86400)
	local h = math.floor(seconds%604800%86400/3600)
	local m = math.floor(seconds%604800%86400%3600/60)
	local s = math.floor(seconds%604800%86400%3600%60)
	
	if w != nil and w > 0 then
		return ""..w.."w "..d.."d "..h.."h "..m.."m "..s.."s"
	elseif d != nil and d > 0 then
		return ""..d.."d "..h.."h "..m.."m "..s.."s"
	elseif h != nil and h > 0 then
		return ""..h.."h "..m.."m "..s.."s"	
	elseif m != nil and m > 0 then
		return ""..m.."m "..s.."s"
	elseif s != nil and s > 0 then
		return ""..s.."s"
	else
		return "0s"
	end	
	return "0s"	
end

if SERVER then

	function fusion.sv.UpdateTime( plr )
		if !plr.LastUpdate then return end
		
		local inc = math.Round( CurTime() - plr.LastUpdate )
		plr:SetTime( plr:GetTime() + inc )
		
		fusion.sv.UpdateDBTime( plr )	
	end
	
	function fusion.sv.UpdateDBTime( plr )		
		local time = tostring( plr:GetTime() )
		
		fusion.sv.SetData( plr, "time", time )
		plr:ResetLastUpdate( )
		
	end
	
	fusion.sv.SaveTimer = 0
	fusion.sv.CoinTimer = 0
	
	local pointsPerTick = 5
	
	hook.Add("Think", "saveTimer", function()
	
		if (CurTime() > fusion.sv.SaveTimer) then
			
			-- local pre = SysTime()
			
			for k,v in pairs(player.GetAll()) do
				fusion.sv.UpdateTime(v)
			end	
			
			-- print("Timespent update: " .. (SysTime() - pre) .. " seconds taken.")
			
			fusion.sv.SaveTimer = CurTime() + 400
		end
		
		if (CurTime() > fusion.sv.CoinTimer) then
			
			-- local pre = SysTime()
			
			print("points")
			
			for k,v in pairs(player.GetAll()) do
				fusion.sv.setPoints(v, fusion.sv.getPoints(v) + pointsPerTick, true)
				
			end
			fusion.SendAnnouncement("You have received $#{" .. pointsPerTick .. "}#. Spend this coin at the shop", 15)
			-- fusion.Message( v, , false, 1 )	
			-- print("Coin update: " .. (SysTime() - pre) .. " seconds taken.")
			
			fusion.sv.CoinTimer = CurTime() + 300
		end
		
	end)
	
	local plr = debug.getregistry().Player	
	function plr:GetTime() 
		return self.Time or 0 
	end
	
	function plr:SetTime( time ) 
		self.Time = math.Round( tonumber( time ) )
		fusion.BroadcastTime(self)
	end
		
	function plr:ResetLastUpdate( )
		local time = CurTime()
		self.LastUpdate = time		
	end
		
	function fusion.SendAllTimes(ply)
		for k,v in pairs(player.GetAll()) do
			net.Start("fusion_Timespent")
			net.WriteEntity(v)
			net.WriteString(tostring(v:GetTime()))
			net.Send(ply)			
			-- print("Send: " .. tostring(v))
		end
	end
	
	function fusion.BroadcastTime(ply)
		net.Start("fusion_Timespent")
		net.WriteEntity(ply)
		net.WriteString(tostring(ply:GetTime()))
		net.Broadcast()		
		-- print("Broadcast: " .. tostring(ply))
	end

else

	net.Receive("fusion_Timespent", function(data)
		local plr = net.ReadEntity()
		local time = tonumber(net.ReadString()) or 0
		
		-- print(plr)
		-- print(time)
		
		plr.Time = time
		plr.LastUpdate = CurTime()
	end)
	
end