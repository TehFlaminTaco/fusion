// ANTISPAM BY TACO
// :D


function PreventSpam(ply, model, ent)
	if (ply.Hierachy or 0) >= 60 then // Administrative Staff have a get out of spam free card.
		return
	end
	ply.SpamCounter = ply.SpamCounter || 0
	
	if (string.lower(type(model)) == "string") then
		enti = ent
	else
		enti = model
	end
	
	if ply.SpamCounter > 20 then // They're really going at it, stop them from spawning things for a while.
		enti:Remove()
		fusion.FormattedMessage(ply, "Your entity has been removed due to spam protection! Slow down!")
		return false;
	elseif ply.SpamCounter > 10 then // They've started spawning too many big things, stop their physics.
		enti:GetPhysicsObject():EnableMotion(false)
		fusion.FormattedMessage(ply, "Your entity has been frozen due to spam protection.")
	end
	
	// We do this last, this allows -any- model to be spawned atleast once, but they do have to wait after it.
	ply.SpamCounter = math.min(40, ply.SpamCounter+(math.max(enti:OBBMaxs().x, enti:OBBMaxs().y, enti:OBBMaxs().z)/math.min(20, ply.Hierachy or 20))) // Devide by Hierachy postion, so more trusted you are, the faster you can spam. If you're into that.
end

function AntiSpamReduction()
	if (NextTicker or 0)<CurTime() then
		NextTicker = CurTime()+0.5
		for k, v in pairs(player.GetAll()) do
			if v.SpamCounter and v.SpamCounter > 0 then
				if (v.SpamCounter > 20 and v.SpamCounter - 1 <= 20) then
					fusion.FormattedMessage(ply, "You can now spawn entities again!")
				end
				v.SpamCounter = v.SpamCounter - 1
			end
		end
	end
end

hook.Add("Think", "TacoPropUnspam", AntiSpamReduction)
hook.Add("PlayerSpawnedProp", "TacoPropUnspam", PreventSpam)
hook.Add("PlayerSpawnedRagdoll", "TacoPropUnspam", PreventSpam)
hook.Add("PlayerSpawnedSENT", "TacoPropUnspam", PreventSpam)
