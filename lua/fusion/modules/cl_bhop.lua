--[[ 
	Modules:
		BHopping
	
	Description:
		BHopperz INERVATE YO
 ]]

print("aww shiut")
 
local bhopenabled = false 
 
hook.Add("CreateMove", "fusion_BHopping", function()
	if bhopenabled then
		if LocalPlayer().BHopping and ( LocalPlayer():IsOnGround() or LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP ) then 
			RunConsoleCommand( "+jump" )
		else
			RunConsoleCommand( "-jump" )
		end
	end
end)

hook.Add("PlayerBindPress", "bhop_keys", function( ply, bind, pressed )

	if (bind == "+jump" or bind == "-jump") then
		bhopenabled = false 
	end

end)

concommand.Add("+bhop", function()
	bhopenabled = true 
	LocalPlayer().BHopping = true
end)

concommand.Add("-bhop", function()
	bhopenabled = true 
	LocalPlayer().BHopping = false
end)
