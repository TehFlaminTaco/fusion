net_ids = {
	"fusion_Ranks",
	"fusion_Bans",
	"fusion_Commands",
	"fusion_LogList",
	"fusion_MapList",
	"fusion_Voting",
	"EG_Buddies",
	"fusion_Spawnpoint",
	"fusion_dtimer",
	"eg_GetOwner",
	"EntityGuard",
	"fusio-message",
	"fusio-logMessage",
	"fusio-messagechat",
	"fusion_menu-logpage",
	"fusion_SendRatings",
	"fusion_Voting_IncrementOption",
	"fusio-mapchange",
	"fusio-cancelmapchange",
	"fusion_Timespent",
	"fusion_SendCoins",
	"fusion_HookTarget",
	"fusion_DeathmatchPlayerJoins",
	"fusion_DeathmatchPlayerLeaves",
	"fusion_DeathmatchPlayerDeath",
	"fusion_DeathmatchPlayerMVP",
	"fusion_logMessage",
	"fusion_telepotter",
	"fusion_Announcements"
}

for i=1,#net_ids do
	util.AddNetworkString(net_ids[i])
end

 

hook.Add("PlayerShouldTakeDamage", "fusion_PlayerShouldTakeDamage", function(target, attacker)	
	
	if target:IsValid() and target:IsPlayer() and attacker:IsValid() and attacker:IsPlayer() and attacker != target then
		
		
		
		if target.Godded then		
			-- fusion.Message(attacker, fusion.PlayerMarkup(target) .. " is godded and cannot be harmed.")
		end
		
		if attacker.Godded and !target.Godded then
			fusion.SendAnnouncement(5, fusion.PlayerMarkup(attacker) .. " has been ungodded for attacking " .. fusion.PlayerMarkup(target))
			attacker.Godded = false
			-- attacker:GodDisable()
			local time = 10
			
			if (attacker.SelfGodInfractions) then
				time = time * attacker.SelfGodInfractions				
			end
			
			attacker.SelfGodInfractions = math.min((attacker.SelfGodInfractions or 0) + 1, 12)
			
			attacker.SelfGodCooldown = CurTime() + time
		else
			attacker.SelfGodCooldown = CurTime() + 5
		end
		
		if !target.Godded and attacker:IsValid() and attacker:IsPlayer() and attacker:GetMoveType() == MOVETYPE_NOCLIP then
			attacker:SetMoveType(MOVETYPE_WALK)
			fusion.Message(attacker, "Noclipping while RDMing is weak brother.")
		end
		
	end
	
	if target.Godded then 
		-- if attacker and attacker:IsValid() and attacker:IsPlayer() and attacker:IsAdmin() then 
			-- target.Godded = false
		-- else
			return false 
		-- end
	end
	
end)

hook.Add("InitPostEntity", "fusion_Initialization", function()			
	-- local map_file = "fusion/default_map.txt"
	
	-- if file.Exists(map_file, "DATA") then		
		-- local default_map = file.Read(map_file, "DATA")
		-- local cur = tostring(game.GetMap())
		
		-- if cur != default_map then
			-- fusion.ChangeMap(default_map, 0)
		-- end
	-- end
end )

-- hook.Add( "PlayerInitialSpawn", "fusion.sv.SetupPlayer", fusion.sv.InitializePlayerData)

function fusion.sv.InitializePlayerData( ply )
	fusion.sv.RetrieveData( ply, function( data )				
		// rank		
		
		PrintTable(data)
		
		local player_data = data[1] or data
		
		local drank = fusion.Settings["default-rank"]
		local rank = player_data.rank
		local rdata = fusion.Ranks[rank or drank]
		
		ply.NewPlayer = false
		if !rank or !rdata then
			rank = drank
			ply.NewPlayer = true
		end	
		ply.Hierarchy = rdata.Hierarchy
		ply.Rank = rank
		local sudo = player_data.sudo		

		if player_data.title then
			ply.fTitle = player_data.title
		end
				
		fusion.sv.InitializeRank( ply, rank, ply.NewPlayer, false )
		
		if fusion.sv.CanDo( ply, "sudo" ) then			
			if sudo and fusion.Ranks[sudo] then
				fusion.sv.SetTeam( ply, sudo )
				ply.Sudo = sudo				
				-- return
			end	
		end
		
		fusion.sv.SetData(ply, "name", ply:Name())
		
		if (player_data.ratings) then
			local ratings = player_data.ratings
			local r = string.Explode(",", ratings)
		
			if #r != #fusion.Ratings then
				ply.Ratings = defaultRatings()
				fusion.sv.SetData(ply, "ratings", string.Implode(",", ply.Ratings))
			else
				local array = {}
				for i = 1, #r do				
					table.insert(array, r[i])
				end
				ply.Ratings = array				
			end
		else
			ply.Ratings = defaultRatings()		
			fusion.sv.SetData( ply, "ratings", string.Implode(",", ply.Ratings))
		end
		
		-- print(player_data.points)
		
		if (player_data.points) then
			-- print(player_data.points)
			fusion.sv.setPoints(ply, tonumber(player_data.points), false)			
		end
		

		ply.HookType = player_data.hook or "default"
		fusion.NetworkVar(ply, "hook", ply.HookType)

		
		timer.Simple(1, function()
			fusion.GlobalMessage(fusion.PlayerMarkup( ply ) .. " has entered the server", false, 1)
			
			for k,v in pairs( player.GetAll() ) do
				fusion.sv.SendTitle( v )
			end	
			
			ply:SetTime(tonumber( player_data.time ) or 0) 
			ply:ResetLastUpdate()
			
			fusion.SendAllTimes(ply)
			
			if (player_data.points) then
				fusion.sv.setPoints(ply, tonumber(player_data.points), false)			
			end
		end)
	end )	
end


function fusion.sv.DoInitialSpawn(ply)

	if !fusion.sv.cleanedCommands then
		fusion.sv.cleanedCommands = table.Copy(fusion.commands)
				
		for k,v in pairs(fusion.sv.cleanedCommands) do
			fusion.sv.cleanedCommands[k].Function = nil
			fusion.sv.cleanedCommands[k].Condition = nil
		end
	end

	print( "[Fusion] Setting up player - " .. ply:Name() .. "..." )
		
	fusion.sv.InitializePlayerData( ply )
		
	-- fusion.sv.RetreiveRatings(ply)	
	
	if fusion.Bans then				
		net.Start("fusion_Bans")
			net.WriteTable(fusion.Bans)		
		net.Send(ply)
	end	
	
	if (fusion.sv.MapChangeTimer) then
		local map = fusion.sv.MapChangeTimer.map
		local time = fusion.sv.MapChangeTimer.time
		
		if (map and time) then
			fusion.MapChangeBroadcast( map, time )
		end
	end
end

-- hostnames = {
	-- "Half Empty Glass",
	-- "The Bicky Tin",
	-- "Mud Bucket",
	-- "Crumpled Shoebox",
	-- "Dank Doghouse",
	-- "Munchy Mill"
-- }


-- hook.Add( "InitPostEntity", "fusion.sv.LogStart", function()

	-- //local hostname = "[inervate]"	
	-- //hostname = hostname .. " : "
	-- //hostname = hostname .. table.Random(hostnames)

	-- //game.ConsoleCommand("hostname " .. hostname .. "\n")
	
	-- //fusion.sv.LogMessage("", "Fusion started on map " .. game.GetMap() )	
-- end )

function fusion.sv.SendWelcome( ply )
	-- ply:GodEnable()
	-- ply.InWelcome = true
	-- ply:ConCommand( "fusion_openwelcome" )
end

concommand.Add( "fusion_closewelcome", function( ply, cmd, args )
	-- if ply.InWelcome then
		-- ply:GodDisable()
		-- ply.InWelcome = false
	-- end
end )

-- hook.Add("InitPostEntity", "spawn_sky", function()
	-- env_skypaint = ents.Create('env_skypaint')
    -- env_skypaint:Spawn();
    -- env_skypaint:Activate();
    -- RunConsoleCommand("sv_skyname", "painted")
    -- fog = ents.Create('env_fog_controller');
    -- fog:Spawn();
    -- fog:Activate();
-- end)

hook.Add( "PlayerSpawn", "fusion.sv.SetupPlayer", 
function( ply )
	if ply:IsValid() then
		fusion.sv.GiveWeapons( ply, 1 )
	
		if !ply.InitialSpawned then
			-- fusion.sv.SendWelcome( ply )
			fusion.sv.DoInitialSpawn(ply)
			ply.InitialSpawned = true
		
		elseif ply.Died or ply.Respawned or ply.InitialSpawned then
			local rank = ply.Rank
			local sudo = ply.Sudo
			
			ply.Respawned = false
			ply.Died = false	
			
			if (rank) then
				-- print(rank)
								
				if sudo and ply:IsMod() then
					if fusion.Ranks[sudo] then
						fusion.sv.SetTeam( ply, sudo )
						-- print(sudo)
					else
						fusion.sv.SetTeam( ply, fusion.Settings["default-rank"] )
						ply.Sudo = fusion.Settings["default-rank"]
					end
				elseif ply.Rank and fusion.Ranks[ply.Rank] then
					fusion.sv.SetTeam( ply, ply.Rank )
				end
				
				
				
				-- fusion.sv.doAutoPromote(ply)
			else
				print("what!?")
				//ply.InitialSpawned = true
				fusion.sv.DoInitialSpawn(ply)
			end
		end	
		
		fusion.sv.doSpawnpoint(ply)		
	end
end )

function fusion.sv.DoDeath( ply, i, k )
	
	-- fusion.sv.checkWasCageDeath(ply, i, k )
	
	local msg = fusion.PlayerMarkup( ply )
	
	if IsValid( k ) and k != ply then
		if k:IsPlayer() and k.UniqueID then
			msg = msg .. " was killed by " .. fusion.PlayerMarkup( k )
		elseif IsValid( k.Owner ) then
			msg = msg .. " was killed by " .. fusion.PlayerMarkup( k.Owner )
		else		
			msg = msg .. " was killed"
		end
	else
		msg = msg .. " committed suicide"
	end
	
	local parse = fusion.ReturnMarkup( msg )
	
	ply.Died = true
	
	fusion.SendGlobalAnnouncement( 4, msg, Color( 200, 200, 200 ), "icon16/exclamation.png" )
end	

function fusion.sv.InitializeRank( ply, rank, set, noteam )
	
	if !fusion.Ranks[rank] then
		rank = fusion.Settings["default-rank"]
	end
	
	local tbl = fusion.Ranks[rank]
	
	
	
	if !noteam then
		fusion.sv.SetTeam( ply, rank )	
	end	
	
	if set then
		-- ply:SendLua("fusion.cl.OldCommands = table.Copy(fusion.commands)")
	
		fusion.sv.SetData( ply, "rank", rank )
		fusion.sv.RemoveData( ply, "sudo" )
		ply.Sudo = nil
		
		if rank != ply.Rank and rank != "guest" then
			ply:SendLua("fusion.cl.ShowRankDialog()")
		end
	end
	
	ply.Rank = rank
	ply.Hierarchy = tonumber( tbl.Hierarchy )
	
	if ply:IsVIP() then
		print("vip")
		umsg.Start("fusion_IsVIP", ply)				
		umsg.End()
	end
	
	if ply:IsMod() then
		print("admin")
		umsg.Start("fusion_IsAdmin", ply)				
		umsg.End()
	end
	
	if ply:IsAdmin() then
		-- local logs = file.Find( "fusion/logs/*.txt", "DATA" )		
		-- net.Start("fusion_LogList")
		-- net.WriteTable(logs)		
		-- net.Send(ply)
		
		local maps = fusion.sh.GetMaps()		
		net.Start("fusion_MapList")
		net.WriteTable(maps)		
		net.Send(ply)
	end	

	if fusion.commands then
		net.Start("fusion_Commands")	
		net.WriteString("12315512")		
		net.Send(ply)
		
		for k,v in pairs(fusion.sv.cleanedCommands) do
			if fusion.sv.CanDo(ply, k) then				
				net.Start("fusion_Commands")	
				net.WriteString(k)		
				net.WriteTable(v)		
				net.Send(ply)
			end
		end	
	end	
end

function fusion.sv.SetTeam( ply, rank, override )
	fusion.NetworkVar(ply, "rank", rank)

	if !fusion.Ranks[rank] then	
		rank = fusion.Settings["default-rank"]
	end
	
	local tbl = fusion.Ranks[rank]
	
	ply:SetTeam( tbl.ID )
	
	if rank == "retard" and !ply.Nerfed then
		ply.Nerfed = true
	end
	
	if fusion.sv.GiveWeapons and !ply.Nerfed and !ply.Jailed then
		fusion.sv.GiveWeapons( ply, override or tbl.Hierarchy )
	end
	
	ply:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
		
	timer.Simple(0.2, function()
		if ply:IsValid() then
			ply:SetHealth( tbl.Health )
			ply:SetArmor( tbl.Armour )
			-- ply:SetRunSpeed( tbl.Speed )
		end
	end)
	
	
end
-- Overrides


local plr = debug.getregistry().Player
function plr:IsSuperAdmin() return self.Hierarchy and self.Hierarchy >= 80 end	
function plr:IsAdmin() return self.Hierarchy and self.Hierarchy >= 70 end
function plr:IsMod() return self.Hierarchy and self.Hierarchy >= 60 end
function plr:IsVIP() return self.Hierarchy and self.Hierarchy >= 40 end
function plr:IsRegular() return self.Hierarchy and self.Hierarchy >= 10 end

local console = debug.getregistry().Entity
function console:Name() if !self:IsValid() then return "Console" end end
function console:Nick() if !self:IsValid() then return "Console" end end
function console:UniqueID() if !self:IsValid() then return "IDConsole" end end
function console:SteamID() if !self:IsValid() then return "IDConsole" end end
function console:IsSuperAdmin() if !self:IsValid() then return true end end
function console:IsAdmin() if !self:IsValid() then return true end end
function console:IsConsole() if !self:IsValid() then return true end end
	
function fusion.sv.GetAdmins()
	local admins = {}
	for k,v in pairs( player.GetAll() ) do
		if v:IsMod()  then
			table.insert( admins, v )
		end
	end
	return admins
end		