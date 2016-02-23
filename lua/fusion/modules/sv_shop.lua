function fusion.sv.setPoints(ply, points, mysql)
	if mysql then fusion.sv.SetData( ply, "points", points) end
	ply.Coin = points
	ply:SendCoin()
	
	-- print(points)
	-- print(fusion.sv.getPoints(ply))
	
end

function fusion.sv.getPoints(ply)
	return ply.Coin or 0
end

local plr = debug.getregistry().Player	

function plr:SendCoin()
	-- `print("sending")

	net.Start("fusion_SendCoins")
	net.WriteDouble(fusion.sv.getPoints(self), 32)
	net.Send(self)
end