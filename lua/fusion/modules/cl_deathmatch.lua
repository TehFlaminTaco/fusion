fusion.dm = {}

fusion.dm.player_tbl = {}
	
-- "fusion_DeathmatchPlayerJoins",
-- "fusion_DeathmatchPlayerLeaves",
-- "fusion_DeathmatchPlayerDeath",
-- "fusion_DeathmatchPlayerScores",

function fusion.dm.SortByScores()	
	local oldMVP = fusion.dm.player_tbl[1]	
	fusion.dm.player_tbl = table.SortByMember(fusion.dm.player_tbl, "score");
	
	if oldMVP != fusion.dm.player_tbl[1] then
		// new mvp is fusion.dm.player_tbl[1].player:Name()
	end
end

net.Receive( "fusion_DeathmatchPlayerJoins", function( data ) 
	local id = net.ReadString()
	local pl = player.GetByUniqueID(id)	
	
	if pl and pl:IsValid() then
		// pl:Name() has joined
	end
end )

net.Receive( "fusion_DeathmatchPlayerLeaves", function( data ) 
	local id = net.ReadString()
	local pl = player.GetByUniqueID(id)	
	
	if pl and pl:IsValid() then
		// pl:Name() has left
	end
end )

net.Receive( "fusion_DeathmatchPlayerDeath", function( data ) 
	local id1 = net.ReadString()
	local pl1 = player.GetByUniqueID(id1)	
	
	if pl1 and pl1:IsValid() then
		// notify everyone
		
		local id2 = net.ReadString()
		local pl2 = player.GetByUniqueID(id2)
		
		if pl2 and pl2:IsValid() then
			// player1 was killed by player2
		else
			// player1 has died
		end		
	end	
end )

net.Receive( "fusion_DeathmatchPlayerScore", function( data ) 
	local id = net.ReadString()
	local pl = player.GetByUniqueID(id)	
	
	local score = net.ReadInt()
	
	if pl and pl:IsValid() then
		if pl.fusion_dm then
			pl.fusion_dm.score = score;
		else
			local foundInTbl = false
			for i = 1, #fusion.dm.player_tbl do
				if fusion.dm.player_tbl[i].player == pl then
					foundInTbl = true
					pl.fusion_dm = fusion.dm.player_tbl[i]
					pl.fusion_dm.score = score;
				end
			end
			
			if !foundInTbl then			
				pl.fusion_dm = {player = pl, score = score};
				table.insert(fusion.dm.player_tbl, pl.fusion_dm);
			end
		end
		
				
		fusion.dm.SortByScores()
	end
	
	
end )