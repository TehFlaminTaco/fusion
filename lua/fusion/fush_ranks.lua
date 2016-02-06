-- fusion.Settings["rank-tblname"] = "fusion.Rank"
-- fusion.Settings["bans-tblname"] = "fusion.Bans"

fusion.DefaultRanks = {}
fusion.DefaultRanks["owner"] = {
	Name = "Owner",
	ID = 10,
	Hierarchy = 100,
	TimeReq = 0,
	R = 150, 
	G = 50, 
	B = 50, 
	Icon = "icon16/car.png",
	Health = 500,
	Armour = 500,
	Speed = 1000
}

fusion.DefaultRanks["admin"] = {
	Name = "Administrator",
	ID = 15,
	Hierarchy = 70,
	TimeReq = 0,
	R = 200, 
	G = 0, 
	B = 0, 
	Icon = "icon16/shield.png",
	Health = 400,
	Armour = 400,
	Speed = 800
}

fusion.DefaultRanks["mod"] = {
	Name = "Moderator",
	ID = 20,
	Hierarchy = 60,
	TimeReq = 0,
	R = 230, 
	G = 130, 
	B = 30, 
	Icon = "icon16/wrench.png",
	Health = 300,
	Armour = 300,
	Speed = 600
}

fusion.DefaultRanks["vip"] = {
	Name = "Contributor",
	ID = 50,
	Hierarchy = 40,
	TimeReq = 0,
	R = 100, 
	G = 150, 
	B = 20, 
	Icon = "icon16/add.png",
	Health = 150,
	Armour = 50,
	Speed = 550
}

fusion.DefaultRanks["regular"] = {
	Name = "Regular",
	ID = 60,
	Hierarchy = 10,
	TimeReq = 200000,
	R = 10, 
	G = 96, 
	B = 190, 
	Icon = "",
	Health = 120,
	Armour = 0,
	Speed = 500
}
fusion.DefaultRanks["guest"] = {
	Name = "Guest",
	ID = 100,
	Hierarchy = 0,
	TimeReq = 0,
	R = 90, 
	G = 180, 
	B = 220, 
	Icon = "",
	Health = 80,
	Armour = 0,
	Speed = 400
}

if SERVER then
	if !file.Exists("fusion/ranks.txt", "DATA") then
		local savetbl = {}
		for k,v in pairs(fusion.DefaultRanks) do 
			local rankstr = ( k .. "," .. v.Name .. "," .. v.ID .. "," .. v.Hierarchy .. "," .. v.TimeReq .. "," .. v.R .. "," .. v.G .. "," .. v.B .. "," .. v.Icon .. "," .. v.Health .. "," .. v.Armour .. "," .. v.Speed )
			table.insert( savetbl, rankstr )
		end	
		file.Write("fusion/ranks.txt", string.Implode( "\n", savetbl ))	
	end	
	
	function fusion.sv.SaveRanks()
	
		if file.Exists("fusion/ranks.txt", "DATA") then
			
			local savetbl = {}
			for k,v in pairs(fusion.Ranks) do 
				local rankstr = ( k .. "," .. v.Name .. "," .. v.ID .. "," .. v.Hierarchy .. "," .. v.TimeReq .. "," .. v.R .. "," .. v.G .. "," .. v.B .. "," .. v.Icon .. "," .. v.Health .. "," .. v.Armour .. "," .. v.Speed )
				table.insert( savetbl, rankstr )
			end	
			file.Write("fusion/ranks.txt", string.Implode( "\n", savetbl ))	
			
		end	
	
	end
	
	function fusion.LoadTeams()
		for i,v in pairs(fusion.Ranks) do	
			team.SetUp(v.ID, v.Name, Color (v.R, v.G, v.B, 255))
			print( "[Fusion] creating team rank " .. i .. " - " .. v.Name .. "..." )
		end
	end

	function fusion.sv.ServerRanks()	
		fusion.Ranks = {}
		local ranks = string.Explode("\n", file.Read("fusion/ranks.txt", "DATA"))
		for k,v in pairs( ranks ) do		
			local tbl = string.Explode( ",", v )
			local key = tbl[1]			
			local name = tbl[2]
			local id = tbl[3]
			local hierarchy = tbl[4]
			local timereq = tbl[5]
			local r = tbl[6]
			local g = tbl[7]
			local b = tbl[8]
			local icon = tbl[9]
			local health = tbl[10]
			local armour = tbl[11]
			local speed = tbl[12]
			
			fusion.Ranks[key] = {
				Name = name, 
				ID = tonumber(id), 
				Hierarchy = tonumber(hierarchy), 
				TimeReq = tonumber(timereq), 				
				R = tonumber(r), 
				G = tonumber(g), 
				B = tonumber(b), 
				Icon = icon,
				Health = tonumber(health),
				Armour = tonumber(armour),
				Speed = tonumber(speed)
			}
		end	
		fusion.LoadTeams()
	end
	
	fusion.sv.ServerRanks()
	
	function fusion.sv.SetupRanks( ply )		
		net.Start("fusion_Ranks")
		net.WriteTable(fusion.Ranks)		
		net.Send(ply)		
	end	
end

if SERVER then
	function fusion.sv.SetupPlayerTeams( ply )		
		print( "[Fusion] Sending rank data to " .. ply:Name() .. "..." )
		fusion.sv.SetupRanks( ply )			
	end
	hook.Add("PlayerAuthed", "fusion.sv.SetupPlayerTeams", fusion.sv.SetupPlayerTeams)	
end

if CLIENT then
	net.Receive( "fusion_Ranks", function(len)
	
		print"ranksreceived"
		fusion.Ranks = net.ReadTable()
		
		for k,v in pairs( fusion.Ranks ) do		
			team.SetUp(v.ID, v.Name, Color (v.R, v.G, v.B, 255))		
		end
	end )
	
end