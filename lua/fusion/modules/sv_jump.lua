--[[ 
	Modules:
		High Jump
	
	Description:
		Gives a boost to jump height.
 ]]
 
if SERVER then
	
	hook.Add("KeyPress", "fusion_SuperJump", function( ply, key )
	
		if ply.SuperJump and key == IN_JUMP and ply:OnGround() and ply:GetMoveType() == MOVETYPE_WALK then
			local ang = ply:EyeAngles()
			ang.pitch = 0;
			
			ply:SetVelocity(ply:GetVelocity() + Vector(0,0,400))
		end
	
	end )
	
	concommand.Add("enable_superjump", function(ply)
		ply.SuperJump = true
	end)
	
	concommand.Add("disable_superjump", function(ply)
		ply.SuperJump = false
	end)
	
	-- concommand.Add("+superjump", function(ply)
		-- if ply:OnGround() and ply:GetMoveType() == MOVETYPE_WALK then
			-- ply:SetVelocity( ply:GetVelocity() + Vector( 0, 0, 400 ) )
		-- end
	-- end)
	
	-- hook.Add("KeyPress", "fusion_SuperJump", function( ply, key )	
		-- if key == IN_JUMP and ply:OnGround() and ply:GetMoveType() == MOVETYPE_WALK then
			-- ply:SetVelocity( ply:GetVelocity() + Vector( 0, 0, 400 ) )
		-- end	
	-- end 
	
	hook.Add("GetFallDamage", "fusion_handleFallDMG", function( ply, speed )
	
		return false
	
	end )

end