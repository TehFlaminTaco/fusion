local killModels = {
	"models/props_foliage/tree_deciduous_card_05_skybox.mdl",
	"models/props_foliage/tree_deciduous_card_04_skybox.mdl",
	"models/exor/skybox/forest_big.mdl",
	"models/exor/skybox/forest_patch.mdl",
	"models/exor/skybox/forest_small.mdl"
}

hook.Add("InitPostEntity", "CleanseMap", function()
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() and table.HasValue(killModels, v:GetModel()) then
			v:Remove()
		end
	end
	
	-- RunConsoleCommand("sv_skyname", "painted")
	-- local ent = ents.Create("env_skypaint")
	-- ent:Spawn()
end)

registerFunction("boom", "vnn", "", function(self,args)
    local op1, op2, op3 = args[2], args[3], args[4]
    local rv1, rv2, rv3 = op1[1](self, op1), op2[1](self, op2), op3[1](self, op3)
	local Positionz = Vector( rv1[1], rv1[2], rv1[3] )
	//if (!self.player:IsAdmin() or !util.IsInWorld(Positionz)) then return end
	if (!util.IsInWorld(Positionz)) then return end
	
	util.BlastDamage( self.entity, self.player, Positionz, math.Clamp( rv3, 1, 5000 ), math.Clamp( rv2 / 2, 1, 10000 ) )
	local effectdata = EffectData()
	effectdata:SetOrigin( Positionz )
	util.Effect( "Explosion", effectdata, true, true )
end)