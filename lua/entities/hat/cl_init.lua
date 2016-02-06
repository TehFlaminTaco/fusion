include('shared.lua')

function ENT:Initialize()
	
end

function ENT:Draw()
	
	local item = self:GetNWString( "fusion_hat" )
	
	local owner = self:GetOwner()
	if !fusion.PointShop[item] then return end
	if owner == LocalPlayer() and GetViewEntity():GetClass() == "player" then return end
	
	-- print("lifecheck?")
	
	local usehead = 0
	
	local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if not attach then attach = owner:GetAttachment(owner:LookupAttachment("head")) usehead = 4 end

	local attach = fusion.PointShop[item].ModPos( self.Entity, attach.Pos, attach.Ang )
	
	-- if self:GetParent() == owner then
		self:SetPos( attach.Pos + attach.Ang:Up() * usehead )
		self:SetAngles( attach.Ang )
	-- end
	
	if owner:Alive() then	
		self.Entity:DrawModel()
	end
	self.Entity:SetModelScale( fusion.PointShop[item].Scale or Vector( 1, 1, 1 ) )

end

