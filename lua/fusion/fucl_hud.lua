function MyCalcView( ply, pos, angles, fov )
	-- local view = {}

	-- view.origin = pos
	-- view.angles = angles
	-- view.fov = fov
	-- view.znear = 3
	-- view.zfar = 100000

	-- return view
end

hook.Add( "CalcView", "MyCalcView", MyCalcView )


silkicons = file.Find("materials/icon16/*.png", "GAME")

local infotex = surface.GetTextureID( "gui/gradient_down" )
local welcome = surface.GetTextureID( "gui/gradient" )
local sidetext = Material( "fusion/fusion_sidetext.png" )
local timeicon = Material( "icon16/clock.png" )

surface.CreateFont( "FusionSmall", {
	font      = "Calibri",
	size      = 16,
	weight    = 400 }
)

surface.CreateFont( "Fusion", {
	font      = "Calibri",
	size      = 18,
	weight    = 400 }
)

surface.CreateFont( "FusionBold", {
	font      = "Calibri",
	size      = 18,
	weight    = 700 }
)

surface.CreateFont( "FusionThick", {
	font      = "Calibri",
	size      = 18,
	weight    = 700,
	shadow   = true }
)
	
surface.CreateFont( "FusionHuge", {
	font      = "Calibri",
	size      = 26,
	weight    = 700 }
)


-- Table Setup ---

fusion.Ranks = {}
fusion.commands = {}
fusion.Bans = {}

net.Receive( "fusion_Commands", function(len)	
	local cmd = net.ReadString()
	if cmd == "12315512" then
		fusion.commands = {}
	else
		fusion.commands[cmd] = net.ReadTable()
	end
end	)

net.Receive( "fusion_Bans", function(len)
	fusion.Bans = net.ReadTable()	
end	)

net.Receive( "fusion_LogList", function(len)
	fusion.LogFiles = net.ReadTable()
end	)

net.Receive( "fusion_MapList", function(len)
	fusion.MapList = net.ReadTable()
end	)

usermessage.Hook( "fusion_IsVIP", function(data)
	fusion.SelfVIP = true
	print"i am a vip"
end	)

usermessage.Hook( "fusion_IsAdmin", function(data)
	fusion.SelfMod = true
	print"i am an admin"
end	)

concommand.Add( "fusion_openwelcome", function( ply, cmd, args )
	fusion.OpenWelcome = CurTime() + 15	
end )

		
---

fusion.cl.Tilt = 0

local html = http.Fetch( "inervate.com/motd.txt", function(body, length, headers, code) fusion.cl.WelcomeMessageData = body end )

function GetHealthColour( health, maxhealth )
	local num = math.Clamp( ( health * 255 ) / maxhealth, 0, 255 )
	return num
end

local cool = Material("icon16/comments.png")

local font = "coolvetica"

surface.CreateFont( "3dfont1", 
	{
		font      = font,
		size      = 150,
		antialias = true,
		weight    = 700,
		-- blursize = 1
		-- shadow 	  = true
	}
)

surface.CreateFont( "3dfont2", 
	{
		font      = font,
		size      = 70,
		antialias = true,
		weight    = 700,
		-- blursize = 1
		-- shadow 	  = true
	}
)

surface.CreateFont( "3dfont1_blur", 
	{
		font      = font,
		size      = 150,
		antialias = true,
		weight    = 700,
		blursize = 3
		-- shadow 	  = true
	}
)

surface.CreateFont( "3dfont2_blur", 
	{
		font      = font,
		size      = 70,
		antialias = true,
		weight    = 700,
		blursize = 3
		-- shadow 	  = true
	}
)

function fusion.cl.AddChatHead(ply, text)
	ply.HeadText = text
	ply.HeadTextFadeTime = 3
	ply.HeadTextFadeFadeAt = CurTime() + ply.HeadTextFadeTime
end

-- hook.Add( "PostPlayerDraw", "fusion_cl_Names", function( ply ) 
-- hook.Remove( "HUDPaint", "fusion_cl_Names")
	-- for _,ply in pairs(player.GetAll()) do
function fusion.cl.drawTitle(ply) 
	-- if !ply:Alive() then return end
	if !ply:IsValid() then return end
	if ply == LocalPlayer() and !ply:ShouldDrawLocalPlayer() then return end
	-- if !fusion.cl.ShowPlayerNames then return end

	local bone = ply:LookupBone( "ValveBiped.Bip01_Head1" )
	
	local pos = ply:GetPos()	
	pos.z = pos.z + 100
	
	local dist = 100
	
	local eyes = ply:LookupAttachment("eyes")
	
	if eyes then
		eyes = ply:GetAttachment(eyes)
		
		if (eyes and eyes.Pos) then
			dist = ply:GetPos():Distance( eyes.Pos)
			
			pos = eyes.Pos + Vector( 0, 0, dist * 0.3 )	
			-- view.angles = eyes.Ang
		end
	end
	
	
		
	-- end
	
	
	local posa = pos //Vector( pos.x, pos.y, z) 	

	-- local dist = LocalPlayer():GetShootPos():Distance(posa)
	
	-- if (dist < 2000) then
		-- local alph = 1 //-(dist / 2000)
		cam.Start3D2D( posa, Angle(0, EyeAngles().y - 90, 90), 0.07 * (dist/100) )
			-- draw.DrawText( ply:Name(), "3dfont", 3, 3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			
			draw.DrawText( ply:Name(), "3dfont1_blur", 3, 3, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )			
			draw.DrawText( ply:Name(), "3dfont1", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			
			
			local title = ""
			if ply.fTitle and ply.fTitle != "" then
				title = ply.fTitle
			elseif fusion.cl.ShowRankColours then
				title = team.GetName( ply:Team() )
			end
			
			-- draw.DrawText( title, "3dfont2", 3, -87, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			
			-- local copy = fusion.cl.GetRankColour(ply, 25 * alph)
			
			draw.DrawText( title, "3dfont2_blur", 3, -77, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			draw.DrawText( title, "3dfont2", 3, -77, fusion.cl.GetRankColour(ply, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			
			
			if (ply.HeadText and CurTime() < ply.HeadTextFadeFadeAt) then
			
				local rem = ply.HeadTextFadeFadeAt - CurTime()
				local div = rem / ply.HeadTextFadeTime
				
				surface.SetFont("3dfont2")
				local w,h = surface.GetTextSize(ply.HeadText)
				local w2,h2 = w + 20, h + 20
				
				-- draw.RoundedBox(2, -w2/2, -90 - h2/2, w2, h2, Color(50,50,50,150))
				
				draw.RoundedBox(8, -w2/2, -110 - h2/2, w2, h2, Color(50,50,50,100))
				
				surface.SetTexture(fusion.cl.gradient_cen)
				surface.SetDrawColor(fusion.cl.GetRankColour(ply, 50))	

				draw.DrawText( ply.HeadText, "3dfont2_blur", -w/2, -110 - h/2,Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.DrawText( ply.HeadText, "3dfont2", -w/2, -110 - h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				
				draw.DrawText( ply.HeadText, "3dfont2_blur", -w/2, -110 - h/2,fusion.cl.GetRankColour(ply, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			
	
			
			-- if chatbox and ply.ChatBox and ply.ChatBoxDie and string.Left(ply.ChatBox, 4) != "<!--" then			
				-- local w = 300
				
				-- local diff = ply.ChatBoxDie - CurTime()
				-- local text = ply.ChatBox
				
				-- if diff <= 0 then
					-- ply.ChatBox = nil
					-- ply.ChatBoxDie = nil
				-- else
					
					-- local mult = math.Clamp(diff / 5, 0, 1)
					
					-- surface.SetFont("FusionSmall")
					-- local text_w, text_h = surface.GetTextSize(text)
					
					-- local lines = chatbox.WordWrap(text, w, " ", "FusionSmall")	
					
					-- w = 260
					
					-- if #lines <= 1 then w = text_w end
					
					-- local x = -(w/2)
									
					
				
					-- local h = text_h * #lines
					-- local y = -(20 + h)
					
					-- draw.RoundedBox(2, x-5, y-5, w+10, h+10, Color(255,255,255,50 * mult))
						
					-- local colour = Color(255,255,255,255)
					
					-- local flicker = math.sin(CurTime() * 5)
					
					-- for i = 1, #lines do
						-- local line = lines[i]							
							
						-- local exp = string.Explode(" ", line)								
						-- local push = 0
						
						-- y = y + text_h
						
						-- for j = 1, #exp do
							-- local word = exp[j]
						
							-- local myColour = table.Copy(colour)
							-- if string.Left(word, 1) == "#" then						
								-- myColour.r = 200 + (55 * flicker)
								-- myColour.g = 100 + (55 * flicker)
								-- myColour.b = 20
							-- end
						
							-- surface.SetFont("FusionSmall")
							-- local w,h = surface.GetTextSize(word .. " ")									
							
							-- draw.SimpleText(word, "FusionSmall", x + push + 1, y + 1, Color(0,0,0,myColour.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							-- draw.SimpleText(word, "FusionSmall", x + push, y, myColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						
							
							-- push = push + w						
						-- end
						
						
					-- end
				-- end
			-- end
		cam.End3D2D()
	-- end
end
	-- end
-- end)

hook.Add( "HUDDrawTargetID", "Hide_TargetID", function()
     return false
end )

local r,g,b,a = 0,0,0,0

local ax,ay,az = 0,0,0
local bx,by,bz = 0,0,0
local adx,ady,adz = 0,0,0
local bdx,bdy,bdz = 0,0,0

local frac = 0
local wave = 0
local bendmult = 0

local StartBeam = render.StartBeam
local AddBeam = render.AddBeam
local EndBeam = render.EndBeam

local pi = math.pi
local sin = math.sin

local color_white = color_white

local vector = Vector()
local color = Color(255, 255, 255, 255)

local lerp = function(m, a, b) return (b - a) * m + a end

function fusion.cl.DrawBeam(veca, vecb, dira, dirb, bend, res, width, start_color, end_color, frequency, tex_stretch, tex_scroll, width_bend, width_bend_size)
	
	if not veca or not vecb or not dira or not dirb then return end
	
	ax = veca.x; ay = veca.y; az = veca.z
	bx = vecb.x; by = vecb.y; bz = vecb.z
	
	adx = dira.x; ady = dira.y; adz = dira.z
	bdx = dirb.x; bdy = dirb.y; bdz = dirb.z
	
	bend = bend or 10
	res = math.max(res or 32, 2)
	width = width or 10
	start_color = start_color or color_white
	end_color = end_color or color_white
	frequency = frequency or 1
	tex_stretch = tex_stretch or 1
	width_bend = width_bend or 0
	width_bend_size = width_bend_size or 1
	tex_scroll = tex_scroll or 0
	
	StartBeam(res + 1)
				
		for i = 0, res do
		
			frac = i / res
			wave = frac * pi * frequency
			bendmult = sin(wave) * bend
			
			vector.x = lerp(frac, ax, bx) + lerp(frac, adx * bendmult, bdx * bendmult)
			vector.y = lerp(frac, ay, by) + lerp(frac, ady * bendmult, bdy * bendmult)
			vector.z = lerp(frac, az, bz) + lerp(frac, adz * bendmult, bdz * bendmult)
									
			color.r = start_color.r == end_color.r and start_color.r or lerp(frac, start_color.r, end_color.r)
			color.g = start_color.g == end_color.g and start_color.g or lerp(frac, start_color.g, end_color.g)
			color.b = start_color.b == end_color.b and start_color.b or lerp(frac, start_color.b, end_color.b)
			color.a = start_color.a == end_color.a and start_color.a or lerp(frac, start_color.a, end_color.a)
			
			AddBeam(
				vector, 					
				width + ((sin(wave) ^ width_bend_size) * width_bend), 					
				(i / tex_stretch) + tex_scroll, 					
				color
			)
			
		end
				
	EndBeam()
end

hook.Add("PostDrawOpaqueRenderables", "fusion_drawropes", function()

	for k,v in pairs(ents.FindByClass("hook")) do
		v:DrawRope()
	end
end)

-- hook.Add("PrePlayerDraw", "fusion_drawropes", function(ply)

	-- for k,v in pairs(ents.FindByClass("hook")) do
		-- v:DrawRope()
	-- end
-- end)