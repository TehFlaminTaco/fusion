TOOL.Category           = "Fusion"
TOOL.Name               = "Unprotect"
TOOL.Command            = nil
TOOL.ConfigName         = ""

function TOOL:RightClick(trace)
	if not IsValid(trace.Entity) or CLIENT then return true end

	trace.Entity.Unprotected = false
	
	local ply = self:GetOwner()
	trace.Entity:SetNWBool("unprotected", false)
	-- fusion.Message(ply, "Entity is now unprotected")
	
	return true
end

function TOOL:LeftClick(trace)
	if not IsValid(trace.Entity) or CLIENT then return true end

	trace.Entity.Unprotected = true
	trace.Entity:SetNWBool("unprotected", true)
	
	local ply = self:GetOwner()
	-- fusion.Message(ply, "Entity is now protected.")
	
	
	
	return true
end

if CLIENT then
	language.Add( "tool.unprotect.name", "Unguard" )
	language.Add( "tool.unprotect.desc", "Disable prop protection on an individual entity." )
	language.Add( "tool.unprotect.0", "Left click to disable entity protection. Right click to re-enable entity protection.")
	// language.Add( "tool.unprotect.1", "")

	
	function TOOL:DrawHUD()
		local trace = LocalPlayer():GetEyeTrace()
		local ent = trace.Entity
		
		if ent and ent:IsValid() then
			local unprotected = trace.Entity:GetNWBool("unprotected")

			local pos = ent:LocalToWorld(ent:OBBCenter())
			local scr = pos:ToScreen()
			
			if unprotected then
				draw.SimpleText("UNPROTECTED", "SBNormal", scr.x, scr.y, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("PROTECTED", "SBNormal", scr.x, scr.y, Color(0,255,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			
		end
	end
end