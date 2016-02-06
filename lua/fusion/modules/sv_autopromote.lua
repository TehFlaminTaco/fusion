	--[[ 
	Modules:
		Autopromote
	
	Description:
		Automatically promote players based on time spent on the server.
 ]]
 
if SERVER then

	function fusion.sv.doAutoPromote(plr)
		if plr:IsValid() then
			local promoted
			local promoted_hier
			local promoted_team
			
			for k,v in pairs( fusion.Ranks ) do
				if v.TimeReq > 0 then
					if v.Hierarchy and plr.Hierarchy and v.Hierarchy > plr.Hierarchy then
						if plr:GetTime() > v.TimeReq then
							if !promoted_hier or promoted_hier < v.Hierarchy then
								promoted = k	
								promoted_hier = v.Hierarchy
								promoted_team = v.ID
							end	
						end
					end
				end	
			end	

			if promoted then
				fusion.sv.InitializeRank( plr, promoted, true )
				local msg = fusion.PlayerMarkup( plr ) .. " has been automatically promoted to " .. fusion.TeamMarkup( promoted_team )
				fusion.GlobalMessage( msg )
			end
		end
	end
	
	-- hook.Remove("PlayerSpawn", "fusion_AutoPromote")

end