local allowedWeapons = {
	{ "none", 0 },	
	-- { "laserpointer", 0 },	
	-- { "remotecontroller", 0 },	
	{ "weapon_physgun", 0 },	
	{ "gmod_tool", 0 },
	{ "gmod_camera", 0 },
	-- { "weapon_crowbar", 5 },
	-- { "weapon_physcannon", 10 },	
	-- { "weapon_fists", 10 },	
	-- { "weapon_pistol", 20 },
	-- { "weapon_smg1", 20 },	
	-- { "weapon_rpg", 30 },	
	-- { "weapon_shotgun", 30 },	
	-- { "weapon_ar2", 30 },	
	-- { "weapon_crossbow", 40 },
	-- { "weapon_frag", 40 },
	-- { "weapon_357", 40 }
	}

hook.Add( "PlayerSpawnSWEP", "WeaponRestrictCheck", function( ply, class, tbl )
	if !ply:IsVIP() then
		
		return false
	end
end )

hook.Add( "PlayerGiveSWEP", "WeaponRestrictCheck", function( ply, class, tbl )
	//if !ply:IsRegular() then
		-- //fusion.Message(ply, "You must be a person before you can spawn weapons.")
	//	return false
	//end
end )

hook.Add( "PlayerLoadout", "WeaponRestrictCheck", function( ply, class, tbl )
	return false
end )

function fusion.sv.GiveWeapons( p, h )

	p:RemoveAllItems()
	
	for i = 1, #allowedWeapons do	
		local k = allowedWeapons[i][1]
		local v = allowedWeapons[i][2]
		
		if h >= v then
			p:Give( k )
		end
	end
	
	fusion.sv.FillAmmo( p )

end

function fusion.sv.FillAmmo( p )
	p:GiveAmmo( 1000, "Pistol", true )
	p:GiveAmmo( 1000, "SMG1", true )
	p:GiveAmmo( 1000, "AR2", true )
	p:GiveAmmo( 100, "357", true )
	p:GiveAmmo( 100, "XBowBolt", true )
	p:GiveAmmo( 100, "Buckshot", true )
	p:GiveAmmo( 10, "RPG_Round", true )
	p:GiveAmmo( 10, "Grenade", true )
	p:GiveAmmo( 10, "SMG1_Grenade", true )
	p:GiveAmmo( 10, "AR2AltFire", true )	
end