--[[ 
	Modules:
		Rating
	
	Description:
		Handles Ratings.
 ]]
 
fusion.Ratings = {1, 2, 3, 4, 5, 6, 7} 

fusion.DefaultIcon = Material("icon16/user.png")

fusion.RatingsIcons = {
	"award_star_gold_3",
	"heart",
	"tux",
	"rainbow",
	"script_code",
	"information",
	"exclamation"
}
for k,v in pairs(fusion.RatingsIcons) do
	fusion.RatingsIcons[k] = Material("icon16/" .. fusion.RatingsIcons[k] .. ".png")
end

fusion.NiceRatings = {
	"Gold Star",
	"Friendly",
	"Classy",
	"Gay",
	"Scripting King",
	"Informative",
	"Douche"
} 

fusion.AdminOnlyRatings = {
	1
} 

-- fusion.KarmaValues = {
	-- 8,
	-- 3,
	-- 4,
	-- 2,
	-- 6,
	-- 3,
	-- -1
-- } 


if CLIENT then
	net.Receive( "fusion_SendRatings", function(len)	
		local ply = net.ReadEntity()
		ply.Ratings = net.ReadTable()		
	end	)
end

if SERVER then
	function fusion.sv.SaveRatings(ply)
		
		local ratings = "0,0,0,0,0,0,0"
		
		if ply.Ratings then						
			ratings = string.Implode(",", ply.Ratings)
		end
		
		-- print(ratings)
		
		fusion.sv.SetData( ply, "ratings", ratings )
		fusion.sv.UpdateRatings(ply)
	end
	
	function defaultRatings()
		local tbl = {}
		for i=1,#fusion.Ratings do
			table.insert(tbl, 0)
		end
		
		return tbl
	end

	-- hook.Add( "PlayerInitialSpawn", "fusion.sv.InitBot", 
	-- function(ply)
		
	-- end) 
	
	-- function fusion.sv.RetreiveRatings(ply)
		-- fusion.sv.ReturnData( ply, "ratings",
		-- function(ply, var, data)
			-- local r = string.Explode(",", data)
		
			-- if #r != #fusion.Ratings then
				-- ply.Ratings = table.Copy(defaultRatings())		
			-- else
				-- local array = {}
				-- for i = 1, #r do				
					-- table.insert(array, r[i])
				-- end
				-- ply.Ratings = array				
			-- end
		-- end,
		-- function(ply, var, err)
			-- ply.Ratings = table.Copy(defaultRatings())
			
			-- fusion.sv.SetData( ply, "ratings", "0,0,0,0,0,0,0" )
		-- end)
		
	-- end
	
	function fusion.sv.SendRatings(ply)			
		for k,v in pairs(player.GetAll()) do			
			if (v and v:IsValid() and v.Ratings) then
				net.Start("fusion_SendRatings")
				net.WriteEntity(v)
				net.WriteTable(v.Ratings)	
				net.Send(ply)
			end			
		end
	end
	
	concommand.Add("request_ratings", function(ply)
		fusion.sv.SendRatings(ply)		
	end)
	
	function fusion.sv.UpdateRatings(ply)			
		
			-- PrintTable(ply.Ratings)
		
			-- if (ply and ply:IsValid() and ply.Ratings) then
				net.Start("fusion_SendRatings")
				net.WriteEntity(ply)
				net.WriteTable(ply.Ratings)
				net.Broadcast()
			-- end

			-- if (ply and ply:IsValid()) then
				-- net.Start("fusion_SendRatings")
				-- net.WriteEntity(ply)
				-- net.WriteTable({})
				-- net.Broadcast()	
			-- end
		
	end
	
	function fusion.sv.AddRating(ply, rating)
		if ply.Ratings then
			for k,v in pairs(ply.Ratings) do
				if k == rating then
					ply.Ratings[k] = ply.Ratings[k] + 1
					fusion.sv.SaveRatings(ply)
					return
				end
			end
		end
	end
	
	function fusion.sv.ResetPlayer(ply)
		ply.Ratings = defaultRatings()
		fusion.sv.SaveRatings(ply)
	end

	fusion.commands["rate"] = {
		Name = "Rate User",	
		Hierarchy = 0,
		Category = "utility",
		Args = 2,
		Help = "Add a rating to a player.",
		NotSelf = true,
		Ignore = true,		
		Function = function( ply, cmd, args )
			local name = args[1]
			local rating = tonumber(args[2])
			
			local msg1 = "You have received a #{%s}# rating"
			local msg2 = "You rated %s with a #{%s}# rating"
			
			-- print(rating)
			
			if !fusion.NiceRatings[rating] then
				fusion.Message( ply, "A rating of that type does not exist" )
				return
			end
			
			local nicerating = fusion.NiceRatings[rating]
			
			if (table.HasValue(fusion.AdminOnlyRatings, rating)) then
				if ply.Hierarchy < 80 then
					fusion.Message( ply, Format("Only administrators can give a #{%s}# rating", nicerating) )		
					return
				else
					msg1 = "You have been given a #{%s}# by %s"
					msg2 = "You have given %s a #{%s}#"
				end
			end
			
			local UniqueIDs = {}
			local players = fusion.sv.GetPlayers( ply, cmd, name )
			ply.RateTimers = ply.RateTimers or {}
			if players and IsValid( players[1] ) then				
				local v = players[1]
				if ply.RateTimers and ply.RateTimers[v] and ply.RateTimers[v] > CurTime() then
					fusion.Message( ply, Format("You cannot rate %s again so quickly", fusion.PlayerMarkup( v )), false )	
				else
					fusion.Message( v, Format(msg1, nicerating, fusion.PlayerMarkup(ply)), false )					
					ply.RateTimers[v] = CurTime() + 120
					fusion.sv.AddRating(v, rating)
					table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )	
				end	
			end
			
			if fusion.sh.TableHasData( UniqueIDs ) then		
				local tarstring = string.Implode( ", ", UniqueIDs )
				fusion.Message( ply, Format(msg2, tarstring, nicerating), false )			
			end					
		end	
	}
end