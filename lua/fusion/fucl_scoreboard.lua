local counts = { // these are the only ones i could be bothered with, enjoy!
	"props",
	"balloons",
	"dynamite",	
	"hoverballs",
	"thrusters",
	"emitters",
	"lamps",
	"lights",
	"wheels",
	"ragdolls",
	"npcs",
	"sents",
	"wire_expressions",
	"wire_egps",
	"gmod_wire_gpulib_controller"	
}


fusion.cl.gradient = surface.GetTextureID( "gui/gradient" )
fusion.cl.gradient_down = surface.GetTextureID( "gui/gradient_down" )
fusion.cl.gradient_cen = surface.GetTextureID( "gui/center_gradient" )

fusion.cl.da_boyz = Material( "fusion/scoreboard.png" )
fusion.cl.da_boyz_blurred = Material( "fusion/scoreboard_blurred.png" )
fusion.cl.da_boyz_shadow = Material( "fusion/scoreboard_shadow.png" )

fusion.cl.upvote = Material( "icon16/tick.png" ) 
fusion.cl.downvote = Material( "icon16/cross.png" )

if !sAvatars then 
	sAvatars = {} 
else
	for i = 1, #sAvatars do
		sAvatars[i]:Remove()
	end
	sAvatars = {} 
end

local add = 0
function fusion.cl.GetRankColour(ply, a)
	local col = team.GetColor(ply:Team())
	
	if !fusion.cl.ShowRankColours then return Color(150,150,150,255) end
	
	col.a = a or 255
	return col
end

-- fusion.cl.MenuColours = {
	-- { Name = "Inervative", Colour = Color( 255,200,60 ) },
	-- { Name = "Darker than Black", Colour = Color( 0,0,0 ) },
	-- { Name = "10%", Colour = Color( 26,26,26 ) },
	-- { Name = "20%", Colour = Color( 51,51,51 ) },
	-- { Name = "30%", Colour = Color( 77,77,77 ) },
	-- { Name = "40%", Colour = Color( 102,102,102 ) },
	-- { Name = "50%", Colour = Color( 128,128,128 ) },
	-- { Name = "60%", Colour = Color( 153,153,153 ) },
	-- { Name = "70%", Colour = Color( 179,179,179 ) },
	-- { Name = "80%", Colour = Color( 204,204,204 ) },
	-- { Name = "90%", Colour = Color( 229,229,229 ) },
	
	-- { Name = "Lighter than White", Colour = Color( 255,255,255 ) },
	
	
	-- { Name = "Match Rank Colour", ColourFunc = function() return fusion.cl.GetRankColour(LocalPlayer()) end },
	-- { Name = "Orange Orange", Colour = Color( 255,100,0 ) },	
	
	
	-- { Name = "Droke the Bloke", Colour = Color( 30, 100, 170 ) },
	-- { Name = "Speed Demon", Colour = Color( 255, 0, 0 ) },
	-- { Name = "Cool Guy Turquoise", Colour = Color( 20, 132, 163 ) },
	-- { Name = "Donny Pink", Colour = Color( 255, 132, 163 ) },
	-- { Name = "Perfect Purple", Colour = Color( 150, 0, 200 ) },
	-- { Name = "Fire Storm", Colour = Color( 211, 10, 85 ) },
	
	-- { Name = "Olive", Colour = Color( 153,180,51 ) },
	-- { Name = "Dark Green", Colour = Color( 30,113,69 ) },
	-- { Name = "Magenta", Colour = Color( 255,0,151 ) },
	-- { Name = "Charcoal", Colour = Color( 29,29,29 ) },
	-- { Name = "Blue", Colour = Color( 45,137,239 ) },
	-- { Name = "Dark Blue", Colour = Color( 43,87,151 ) },
	-- { Name = "Baby Blue", Colour = Color( 159,191,193 ) }
	
	
	
-- }

function fusion.cl.scoreboardPrimary(a)
	return Color( 100, 100, 100, a )
end

function fusion.cl.scoreboardSecondary(a)
	return Color( 50, 50, 50, a )
end

function fusion.cl.ColorMarkupString(a)

	local primary = fusion.cl.GetColour(alp)
	return primary.r..","..primary.g..","..primary.b..","..a

end

BAlpha = 100
GAlpha = 255

-- function fusion.cl.SetMenuColour( h, s, v, set )

	-- if h and set then cookie.Set( "fusion_colour_h", h ) end
	-- if s and set then cookie.Set( "fusion_colour_s", s ) end
	-- if v and set then cookie.Set( "fusion_colour_v", v ) end
	
	-- fusion.cl.CachedColour = HSVToColor(h, s, v)
-- end

function fusion.cl.SetMenuR( r, set )	
	if r and set then cookie.Set( "fusion_colour_r", r ) end	
	fusion.cl.CacheColour()
end

function fusion.cl.SetMenuG( g, set )	
	if g and set then cookie.Set( "fusion_colour_g", g ) end	
	fusion.cl.CacheColour()
end

function fusion.cl.SetMenuB( b, set )	
	if b and set then cookie.Set( "fusion_colour_b", b ) end	
	fusion.cl.CacheColour()
end

local default_col = Color(91,64,65)

function fusion.cl.CacheColour()
	local r,g,b

	r = cookie.GetNumber( "fusion_colour_r" )
	g = cookie.GetNumber( "fusion_colour_g" )
	b = cookie.GetNumber( "fusion_colour_b" )

	if (r and g and b) then	
		fusion.cl.CachedColour = Color(r,g,b)
	else
		fusion.cl.CachedColour = default_col
	end
	
	return fusion.cl.CachedColour
end



function fusion.cl.DefaultColour(alpha)
	return Color(default_col.r, default_col.g, default_col.b, alpha)
end

function fusion.cl.GetColour(alpha)
	-- local cd = fusion.cl.MenuColours[fusion.cl.GMColour]
	-- local col = table.Copy(cd.Colour or cd.ColourFunc())
	
	local c = fusion.cl.CachedColour or fusion.cl.CacheColour()

	return Color(c.r, c.g, c.b, alpha)
end

local font = "Trebuchet MS"

surface.CreateFont( "devilFont", 
	{
		font      = "Chiller",
		size      = 200,
		weight    = 400,
		antialias = 1
	}
)

surface.CreateFont( "logofont", 
	{
		font      = "Impact",
		size      = 28,
		weight    = 400,
		antialias = 1
	}
)

surface.CreateFont( "logofont_bigger", 
	{
		font      = "Impact",
		size      = 42,
		weight    = 400,
		antialias = 1
	}
)

surface.CreateFont( "logofont_blur", 
	{
		font      = "Impact",
		size      = 28,
		weight    = 700,
		blursize  = 5,
		antialias = 1,
		rotary 	  = 1,
		shadow 	  = 10
	}
)

surface.CreateFont( "SBSmall", 
	{
		font      = font,
		size      = 14,
		weight    = 400 
	}
)

surface.CreateFont( "SBNormal", 
	{
		font      = font,
		size      = 16,
		weight    = 400 
	}
)

surface.CreateFont( "SBNormalBlur", 
	{
		font      = font,
		size      = 16,
		weight    = 400,
		blursize = 5
	}
)

surface.CreateFont( "SBUnderlined", 
	{
		font      = font,
		size      = 16,
		weight    = 400,
		italic    = true		
	}
)

surface.CreateFont( "SBUnderlinedBlur", 
	{
		font      = font,
		size      = 16,
		weight    = 400,
		italic    = true,
		blursize = 3		
	}
)

surface.CreateFont( "SBBold", 
	{
		font      = font,
		size      = 16,
		weight    = 700 
	}
)

surface.CreateFont( "hfmedium", 
	{
		font      = font,
		size      = 26,
		weight    = 400 
	}
)

surface.CreateFont( "hflarge", 
	{
		font      = "coolvetica",
		size      = 30,
		weight    = 400 
	}
)

surface.CreateFont( "hflarge2", 
	{
		font      = "coolvetica",
		size      = 30,
		weight    = 400,
		blursize  = 5,
	}
)

-- surface.CreateFont( "hflarge_innerglow", 
	-- {
		-- font      = "coolvetica",
		-- size      = 40,
		-- weight    = 50,
		-- blursize  = 0,
	-- }
-- )

surface.CreateFont( "pacfont!", 
	{
		font      = "coolvetica",
		size      = 100,
		weight    = 400 
	}
)

surface.CreateFont( "pacfont!2", 
	{
		font      = "coolvetica",
		size      = 100,
		weight    = 400,		
		blursize  = 5
	}
)


surface.CreateFont( "fancyfont", 
	{
		font      = "akbar",
		size      = 26,
		weight    = 400 
	}
)


local quick_buttons = 
{
	{FuncName = function(ply)
		if ply.Buddy then
			return "Remove PP Buddy"				
		else
			return "Add PP Buddy"		
		end
	end,	
	OnClick = function(ply) 
		if ply.Buddy then
			RunConsoleCommand( "fusion", "removebuddy", ply:UniqueID() )				
		else
			RunConsoleCommand( "fusion", "addbuddy", ply:UniqueID() )		
		end
	end, 
	allowAll = true},
	
	{FuncName = function(ply)
		if ply:IsMuted() then
			return "Clientside Unmute"				
		else
			return "Clientside Mute"		
		end
	end,	
	OnClick = function(ply) 
		if ply:IsMuted() then
			ply:SetMuted(false);				
		else
			ply:SetMuted(true);		
		end
	end, 
	allowAll = true},
	
	{Name = "Steam Profile",	
	OnClick = function(ply) 
		ply:ShowProfile()
	end, 
	allowAll = true},		
	{Name = "Goto", OnClick = function(ply) RunConsoleCommand("fusion", "goto", ply:UniqueID()) end, Condition = function() return fusion.commands["goto"] end},
	{Name = "Bring", OnClick = function(ply) RunConsoleCommand("fusion", "bring", ply:UniqueID()) end, Condition = function() return fusion.commands["bring"] end},
	{Name = "Spectate", OnClick = function(ply) RunConsoleCommand("fusion", "spectate", ply:UniqueID()) end, Condition = function() return fusion.commands["spectate"] end},
	{Name = "Slay", OnClick = function(ply) RunConsoleCommand("fusion", "slay", ply:UniqueID()) end, Condition = function() return fusion.commands["slay"] end},
	{Name = "Jail", OnClick = function(ply) RunConsoleCommand("fusion", "jail", ply:UniqueID()) end, Condition = function() return fusion.commands["jail"] end},
	{Name = "Kick", OnClick = function(ply) RunConsoleCommand("fusion", "kick", ply:UniqueID()) end, Condition = function() return fusion.commands["kick"] end},
	{Name = "1 Hour Ban", OnClick = function(ply) RunConsoleCommand("fusion", "ban", ply:UniqueID(), "60") end, Condition = function() return fusion.commands["ban"] end},	
	{Name = "Permanent Ban", OnClick = function(ply) RunConsoleCommand("fusion", "ban", ply:UniqueID(), "0") end, Condition = function() return fusion.commands["ban"] end}	
	
}	

local scoreboard_up = false

fusion.cl.current_expanded = false	
fusion.cl.scrollmax = #player.GetAll()
fusion.cl.scroll = 1

-- local config_msgs = {
	-- "Thanks for playing on Inervate bud!",
	-- "Fusion is pretty good aye!!!!??",
	-- "Friendship is golden.",
	-- "Life's like a box of Drokes.",
	-- "Clean my bong and I hope it's clean.",
	-- "Don't you cry no more!"
	-- "Fusion"
-- }


fusion.ChangeToolHelp = true
	
-- hook.Add("InitPostEntity", "checkgmodtoolhelp", function()
	-- local cvar = GetConVar("gmod_drawhelp"):GetInt()
	
	-- if cvar == 0 then
		-- fusion.ChangeToolHelp = false
	-- end
-- end)		
	

-- hook.Add("Think", "click_catcher", function()
	-- if vgui.CursorVisible() and !fusion.cl.ScrollPanel then
		-- fusion.cl.InputControl(true)
	-- elseif !vgui.CursorVisible() and fusion.cl.ScrollPanel then
		
	-- end
	
-- end)

	
fusion.cl.CurrentSettingsMsg = 1

fusion.cl.ScoreboardCursorX = nil 
fusion.cl.ScoreboardCursorY = nil

hook.Add( "ScoreboardShow", "fusion.cl.ScoreboardShow", function()
	fusion.cl.CurrentSettingsMsg = fusion.cl.CurrentSettingsMsg + 1
	
	-- if fusion.cl.CurrentSettingsMsg > #config_msgs then
		-- fusion.cl.CurrentSettingsMsg = 1
	-- end
	
	if fusion.ChangeToolHelp then
		RunConsoleCommand("gmod_drawhelp", 0)
	end
	
	fusion.ScoreboardActive = true	
	
	scoreboard_up = true	
	gui.EnableScreenClicker(true)
	fusion.cl.InputControl(true)
	
	fusion.cl.current_expanded = false	
	fusion.cl.scrollmax = #player.GetAll()
	
	fusion.cl.ColourButtonOpen = true
	fusion.cl.ColourScroll = 1
		
	if !fusion.cl.ScoreboardCursorX then fusion.cl.ScoreboardCursorX = ScrW() * 0.2 end
	if !fusion.cl.ScoreboardCursorY then fusion.cl.ScoreboardCursorY = ScrH() * 0.5 end		
	gui.SetMousePos( fusion.cl.ScoreboardCursorX, fusion.cl.ScoreboardCursorY )	
		
	-- if chatbox.frame then chatbox.frame:SetVisible(false) end
	
	return false
end)

hook.Add( "ScoreboardHide", "fusion.cl.ScoreboardShow", function()
	scoreboard_up = false
	
	fusion.cl.ScoreboardCursorX, fusion.cl.ScoreboardCursorY = gui.MouseX(), gui.MouseY()
	
	gui.EnableScreenClicker(false)
	fusion.cl.InputControl(false)
	
	if fusion.ChangeToolHelp then
		RunConsoleCommand("gmod_drawhelp", 1)
	end
	
	
	
	fusion.ScoreboardActive = false
						
	fusion.cl.ColourButtonOpen = false
	fusion.cl.ColourScroll = 1			
	
	-- if chatbox.frame then chatbox.frame:SetVisible(true) end
	
	-- if (fusion.cl.SBAvatar and fusion.cl.SBAvatar:IsValid()) then
		-- fusion.cl.SBAvatar:SetVisible(false)
		-- fusion.cl.SBAvatar_CurPlayer = nil		
	-- end
	
	return false
end)

local 	hiddenElements = {
	"CHudCrosshair",
	"CHudBattery",
	"CHudHealth",
	"CHudAmmo",
	"CHudSecondaryAmmo"
	-- "CHudChat"
}


hook.Add( "HUDShouldDraw", "HideThings", function(name)
	if table.HasValue(hiddenElements, name) and scoreboard_up then
		return false
	end
	
	-- if name == "CHudChat" then
		-- return false
	-- end
end )

fusion.cl.HUDSpeedMult = 1

local function hudcontrol()
	local x,y,w,h = 0,1,ScrW(),ScrH()-1
	
	
	surface.SetDrawColor(fusion.cl.GetColour(100*fusion.cl.AlphaMult))
	surface.DrawOutlinedRect(x,y,w,h)	
		
	fusion.cl.HUDSpeedMult = 1/((1 / FrameTime()) / 300)
end

fusion.cl.AlphaMult = 0

fusion.cl.RowButtonsSub = 0

local tsar = {
	[0] = Color(255,255,255,255),
	[1] = Color(0, 57, 166,255),
	[2] = Color(213, 43, 30,255)
}

local highlighted = false

local devil_messages = {	
	"YOU DON'T HAVE THE WILL",
	"DEATH!",
	"YOUR ASS IS MINE",
	"MUHAHAHAHAHAHAHAHA",
	"AHAHAHAHAHAHA",
	"XAXAXAXAXAX",
	"DROKEDROKEDROKEDROKE",
	"DEATH TO YOU!",
	"DESPAIR",
	"FAMINE",
	"WAR",
	"PESTILENCE",
	"YOU POSSESS NOTHING",
	"ONLY REGRET",
	"HOPELESSNESS",
	"YOUR PAIN IS NOT AN ILLUSION",
	"YOU ARE BROKEN",
	"FLESH IS MATERIAL, WEAKNESS",
	"YOUR LIFE IS EMPTY",
	"LIFE IS POISON",
	"I AM THE EYE OF LEVIATHAN",
	"FRANTICALLY GASP FOR BREATH",
	"CONDEMNED",
	"IT SPEAKS TO ME",
	"POSRO",
	"POSROPOSRO",
	"POSROPOSROPOSRO",
}

barheight = 26//#34//24 //30

local cur_devil = 1
local next_devil = 0
-- local devil_timer = 0

LevelLocks = {}

function HigherLevelLocked(level)
	-- print(level)
	for k,v in pairs(LevelLocks) do		
		if k > level then
			if CurTime() > v then				
				table.remove(LevelLocks, k)				
			else			
				return true
			end
		end
	end
	return false
end
 
function LockLevel(level)
	-- print(level)
	LevelLocks[level] = CurTime() + 0.1
end

local sin,cos,rad = math.sin,math.cos,math.rad
local function GeneratePoly(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end

function mouseInRegion(x,y,w,h,level)

	level = level or 20

	if HigherLevelLocked(level) then
		return falsed
	end
	
	local mousex = gui.MouseX()
	local mousey = gui.MouseY()
	
	local inRegion = (mousex>x and mousex<(x+w) and mousey>y and mousey<(y+h))
	
	if inRegion then
		LockLevel(level)
	end	
	
	return inRegion	
end

function mouseInRegion2(x,y,w,h)
	
	local mousex = gui.MouseX()
	local mousey = gui.MouseY()
	
	local inRegion = (mousex>x and mousex<(x+w) and mousey>y and mousey<(y+h))
	
	return inRegion	
end

if (fusion.cl.AnnouncementPane) then
	fusion.cl.AnnouncementPane:Remove()
	fusion.cl.AnnouncementPane = nil
end




hook.Add("HUDPaint", "DisplayScoreboard", function()		
	
	-- fusion.cl.drawSpawnPoint()
	local avaSize = 24	
	if #player.GetAll() > #sAvatars then
		local avatar = vgui.Create("AvatarImage")
		avatar:SetSize(avaSize, avaSize)
		avatar:SetPos(0, 0)
		-- avatar:SetPlayer(  )
		avatar:SetVisible(false)
		
		table.insert(sAvatars, avatar)
	elseif #player.GetAll() < #sAvatars then
		sAvatars[#sAvatars]:Remove()
		table.remove(sAvatars, #sAvatars)
	end
	
	if !fusion.cl.AnnouncementPane then
		fusion.cl.AnnouncementPane = vgui.Create( "DPanel" )
		fusion.cl.AnnouncementPane:SetSize( ScrW(), ScrH() )
		fusion.cl.AnnouncementPane:SetPos( 0, 0 )		
		fusion.cl.AnnouncementPane:SetVisible(true)
		fusion.cl.AnnouncementPane:MouseCapture(false)
		fusion.cl.AnnouncementPane:SetMouseInputEnabled(false)
		fusion.cl.AnnouncementPane.Paint = function(w,h) 
			fusion.cl.paintAnnouncements() 
		end
	end
	
	if LocalPlayer():GetMoveType() == MOVETYPE_FLY then
		local vibrate = math.abs(math.sin(CurTime() * 5))
		
		surface.SetTexture(fusion.cl.gradient_cen)
		surface.SetDrawColor(Color(255, 0, 0, 75 + 25 * vibrate))	
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())	

		if CurTime() > next_devil then
			cur_devil = table.Random(devil_messages)
			
			if math.random(1,4) == 1 then
				cur_devil = string.reverse(cur_devil)
			end
			
			next_devil = CurTime() + 1
		end
		
		draw.SimpleText(cur_devil, "devilFont", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 100 + 50 * vibrate), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			
	end
	
	local me = LocalPlayer()	
	
	hudcontrol()
	
	fusion.EGIDTags()
	
	if scoreboard_up then
		if fusion.cl.AlphaMult < 1 then
			fusion.cl.AlphaMult = fusion.cl.AlphaMult + (0.02*fusion.cl.HUDSpeedMult)
		end
		if !vgui.CursorVisible() then
			gui.EnableScreenClicker(true)
			fusion.cl.InputControl(true)
		end
	else
		
		fusion.cl.ShowTelepotter = false
	
		if fusion.cl.AlphaMult > 0 then
			fusion.cl.AlphaMult = fusion.cl.AlphaMult - (0.02*fusion.cl.HUDSpeedMult)
		end
		
		
	end
		
	fusion.cl.AlphaMult = math.Clamp(fusion.cl.AlphaMult, 0, 1)
	
	if fusion.cl.AlphaMult > 0 then	
		
		local players = player.GetAll()
		local num = #player.GetAll()
		
		fusion.cl.scrollmax = num
		
		-- local h = (fusion.cl.scrollmax * barheight) + 100 + add + 4	- 26 + 1
		local h = (fusion.cl.scrollmax * barheight) + 100 + add - 26
		local header_h = 100
		
		if h > ScrH() * 0.7 then
			fusion.cl.scrollmax = math.Clamp(fusion.cl.scrollmax - 1, 5, num)	
		end
		
		if fusion.cl.IsMousePressed(-1) then
			fusion.cl.scroll = math.Clamp(fusion.cl.scroll + 1, 1, num - fusion.cl.scrollmax + 1)
		elseif fusion.cl.IsMousePressed(1) then
			fusion.cl.scroll = math.Clamp(fusion.cl.scroll - 1, 1, num - fusion.cl.scrollmax + 1)
		end
		
		local w = 800
		
		if ScrW() < 1100 then
			w = ScrW() * 0.5
		end
		
		local x = ScrW()/2 - w/2
		local y = ScrH()/2 - h/2		
		
		
		-- simpleSideGradient(x + 1, y - top_height + 1, w-2, h + top_height + bottom_height - 2, Color(0,0,0,100 * fusion.cl.AlphaMult), 200)	
		
		if (fusion.cl.ShowTelepotter) then //or fusion.cl.shopActive) then
			x = -ScrW() * 2
		end
		
		simpleSideGradient(x+1, y, w-2, h, Color(0,0,0,100 * fusion.cl.AlphaMult), 200)	
		
		
		-- for i = 1, 10 do
			-- local w, h = w + i * 2, h + i * 2
			-- local x, y = x - i, y - i
		
			-- local a = 10 - (i) + 1
		
			-- draw.RoundedBox(16, x, y, w, h, fusion.cl.GetColour(a * fusion.cl.AlphaMult))
		-- end
		
		local rowtake = 0
		
		if fusion.cl.scrollmax != num then
			fusion.cl.scrollrequired = true			
			
			
			rowtake = 9
			
			
		else
			fusion.cl.scroll = 1
			fusion.cl.scrollrequired = false	
		end		
			
		-- draw.DrawText( "You're also a cunt.", "fancyfont", x + 4, y-26-4, Color( 255, 255, 255, 255 * fusion.cl.AlphaMult ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
		-- draw.RoundedBox( 0, x, y, w, h, Color(50,50,50,250 * fusion.cl.AlphaMult) )
		
		
		
		-- draw.RoundedBox( 0, x + 1, y + 1, w - 2, h - 2, fusion.cl.GetColour(250 * fusion.cl.AlphaMult) )
		
		local top_height = 5
		local bottom_height = 5
		
		// bg of it all!!!
		draw.RoundedBox( 0, x + 1, y + 1 - top_height, w - 2, h - 2 + top_height + bottom_height, Color(50,50,50,255 * fusion.cl.AlphaMult) )
			
		fusion.cl.SettingsPanel(x + 1, y + 1 - top_height, w - 2, h - 2 + top_height + bottom_height)
	
		
		//draw.SimpleText("Fusion by Droke", "SBBold", x + header_h - 5, y + 5, Color(255,200,60,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)	
			
		local w_list = w - 4
		local h_list = h-header_h-2 + 26
		
		local x_list = x+2
		local y_list = y + 74
		
		local w_bar = w_list - 4 + 4
		local h_bar = barheight// - 2 + 2
		
		local x_bar = x_list + 2 - 2
		local y_bar = y_list + 2 - h_bar - 1 - 2
		
		-- draw.RoundedBox( 0, x_list, y_list, w_list, h_list, Color(0,0,0,150 * fusion.cl.AlphaMult) )
		
		local players_sorted = {}
		for k,v in pairs( players ) do
			local time = v.Time or 0
			local info = { Obj = v, Sort = tonumber( tostring( v:Team() ) .. "0000000000000" ) - time }
			table.insert( players_sorted, info )
		end
		table.SortByMember( players_sorted, "Sort", function(a, b) return a > b end )		
		
		-- scoreboardRow(x_list, y_list, w_list, h_list, Color(100,100,100,255), true, fusion.cl.AlphaMult, fusion.cl.gradient)
		
		surface.SetDrawColor(255,255,255,255 * fusion.cl.AlphaMult)		
		
		local rankPos = 0.45
		
		local kdPos = 0.63
		local entsPos = 0.70
		local timePos = 0.83
		-- local karmaPos = 0.865
		local pingPos = 0.96		
					
		local expanded = 0
		
		for i = fusion.cl.scroll, fusion.cl.scroll + (fusion.cl.scrollmax-1) do
			if players_sorted[i] and players_sorted[i].Obj then
				local ply = players_sorted[i].Obj				
				local avatar = sAvatars[i]
				
				if LocalPlayer().EG_Buddies and table.HasValue(LocalPlayer().EG_Buddies, ply:UniqueID() ) then
					ply.Buddy = true
				else
					ply.Buddy = false
				end	

				y_bar = y_bar + barheight	
				
				local barheight = h_bar
				
				-- local m_x = gui.MouseX()
				-- local m_y = gui.MouseY()
				
				local inRegion = false
				
				if mouseInRegion(x_bar,y_bar,w_bar,h_bar) then
					inRegion = true
					if fusion.cl.IsMousePressed(MOUSE_LEFT) and ply != LocalPlayer() then
						if ply == fusion.cl.current_expanded then
							fusion.cl.current_expanded = false
						else
							fusion.cl.current_expanded = ply							
						end
						fusion.cl.RowButtonsSub = 0
					end
				end
				
				local bwidth = 150	
				local sub = 0
				if ply == fusion.cl.current_expanded then
					fusion.cl.RowButtonsSub = (bwidth + 7) //math.Approach(fusion.cl.RowButtonsSub, bwidth + 7, (bwidth + 7) / 10)
					sub = fusion.cl.RowButtonsSub	
				end
				
				local pteam = ply:Team()
				
				if ply == fusion.cl.current_expanded and sub >= bwidth + 7 then			
				
					local x = x_bar - sub + 4
					local y = y_bar + barheight + 2
					

					-- draw.RoundedBox(4,x - 32 - 4 - 2, y - 32 - 2 + 1, 32 + 4, 32 + 4, Color(50,50,50,255 * fusion.cl.AlphaMult))
					
					-- if fusion.cl.SBAvatar_CurPlayer != ply then						
						-- fusion.cl.SBAvatar:SetPos( x - 32 - 4, y - 32 + 1 )
						
						-- fusion.cl.SBAvatar:SetPlayer(ply)
						-- fusion.cl.SBAvatar_CurPlayer = ply
					-- end
					
									
					local karma_y = y_bar - 22
					draw.RoundedBox(0,x_bar - sub + 2, karma_y, bwidth, 22, Color(50,50,50,255 * fusion.cl.AlphaMult))
					local col = table.Copy(fusion.cl.GetRankColour(ply))
					col.a = 255 * fusion.cl.AlphaMult
					draw.RoundedBox(0,x_bar - sub + 2, karma_y - 5, bwidth, 5, col)					
										
					local icon_x = x_bar - sub + 4
					local icon_y = karma_y + 1
					
					local midX = icon_x + (21 * (#fusion.Ratings/2))
					
					-- local highest = 0
					-- local highest_num = 0
					
					-- for k = 1, #fusion.Ratings do
						-- local rating = fusion.Ratings[k]
						-- local sum = ply.Ratings[k]
						
						-- if tonumber(sum) and tonumber(sum) > highest_num then
							-- highest_num = sum
							-- highest = k
						-- end
					-- end
					
					for k = 1, #fusion.Ratings do
						local x,y,w,h = icon_x, icon_y, 20, 20						
						local rating = fusion.Ratings[k]
						simpleIconButton2(fusion.RatingsIcons[k], x, y, w, h, function()
							RunConsoleCommand("fusion", "rate", ply:UniqueID(), k)	
						end, nil, fusion.NiceRatings[k] .. " x " .. ply.Ratings[k], Vector(midX, icon_y - 21), 255)
						
						if mouseInRegion(x,y,w,h) and ply.Ratings then				
							-- draw.RoundedBox(0,x, y, w, h, Color(0, 0, 0, 200))
							draw.SimpleText(ply.Ratings[k], "SBSmall", x + w/2, y + h/2, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end
						
						-- if highest == k then
							-- surface.DrawOutlinedRect(x, y, w, h, Color(255, 255, 255, 1))
						-- end
						
						icon_x = icon_x + 21
					end					
					
					local btns = #quick_buttons
					
					y = y - 2
					for k = 1, btns do
						local btn = quick_buttons[k]
						if btn.allowAll or (btn.Condition and btn.Condition()) then
							draw.RoundedBox(0,x_bar - sub + 2, y - 1, bwidth, 22, Color(50,50,50,255 * fusion.cl.AlphaMult))
							simpleButton(btn.Name or btn.FuncName(ply), Color(50,50,50,255 * fusion.cl.AlphaMult), x, y+1, bwidth - 4, 16, btn.OnClick, ply)
							y = y + 18
						end
					end
					
					y = y + 1
					
					
						draw.RoundedBox(0,x_bar - sub + 2, y, bwidth, 5, fusion.cl.GetRankColour(ply))
					
				end				
				
				-- scoreboardRow(x_bar - sub, y_bar, w_bar + sub - rowtake, barheight+1, fusion.cl.GetRankColour(ply), false, fusion.cl.AlphaMult)
				
				-- scoreboardRow(x_bar - sub, y_bar, w_bar + sub - rowtake, barheight+1, fusion.cl.GetRankColour(ply), false, fusion.cl.AlphaMult)
				
		
				
		
				draw.RoundedBox(0,x_bar - sub, y_bar, w_bar + sub - rowtake, barheight-2, fusion.cl.GetRankColour(ply, 255 * fusion.cl.AlphaMult))
				
				
				draw.RoundedBox(0,x_bar - sub, y_bar + barheight-1, w_bar + sub - rowtake, 1, Color(255,255,255,25 * fusion.cl.AlphaMult))
				
				-- draw.RoundedBox(0,x_bar - sub, y_bar, w_bar + sub - rowtake, barheight+1, Color(0,0,0, 50 * fusion.cl.AlphaMult))
				
				
				
				surface.SetTexture(fusion.cl.gradient_down)
				surface.SetDrawColor(Color(0,0,0,60 * fusion.cl.AlphaMult))	
				surface.DrawTexturedRect(x_bar - sub + 1, y_bar + 1, w_bar + sub - rowtake - 2, barheight-2)
				
			
				if (inRegion) then
					surface.SetTexture(fusion.cl.gradient_down)
					surface.SetDrawColor(Color(255,255,255,25 * fusion.cl.AlphaMult))	
					surface.DrawTexturedRect(x_bar - sub, y_bar, w_bar + sub - rowtake, 10)
				
				end
				
				
				
								
				local rank = fusion.GetRankByTeam(pteam)
				local add = 5

				local icon = fusion.DefaultIcon				
				if ply.Ratings then					
					local high = 0

					for i = 1, #ply.Ratings do
						local v = tonumber(ply.Ratings[i])
						
						if v > high then
							high = v
							icon = fusion.RatingsIcons[i]
						end
					end					
				end	
				
				
				
				// avatar
		
				-- surface.SetTexture(fusion.cl.gradient)		
				-- surface.SetDrawColor(fusion.cl.GetColour(255 * fusion.cl.AlphaMult))
				-- surface.SetDrawColor(Color(0,0,0,200 * fusion.cl.AlphaMult))
				-- surface.DrawTexturedRect(x_bar+6-sub, y_bar, 500+sub, h_bar-1)
		
				draw.RoundedBox(0,x_bar + 6 + 1 - sub, y_bar, avaSize, avaSize, Color(0,0,0, 50 * fusion.cl.AlphaMult))
		
				avatar:SetPos(x_bar + 6 + 1 - sub, y_bar)
				avatar:SetPlayer(ply)
				avatar:SetVisible(true)
	
				//
				
				surface.SetMaterial(icon)
				surface.SetDrawColor(255, 255, 255, 255 * fusion.cl.AlphaMult)	
				surface.DrawTexturedRect(x_bar + 6 + 5 - sub + avaSize+2, y_bar + h_bar / 2 - 8, 16, 16)
				
		
				add = add + 24
				
				if (ply.Ratings) then
					-- for i = 1, #ply.Ratings do
						-- karma = karma + (fusion.KarmaValues[i] * ply.Ratings[i])
					-- end
				else
					RunConsoleCommand("request_ratings")
				end
				
				local name_colour = Color(255,255,255,255 * fusion.cl.AlphaMult)				
				
				draw.RoundedBox(2, x_bar+1-sub, y_bar+1, 5, barheight-3, Color(0,0,0,100 * fusion.cl.AlphaMult))
				
				
				
				if ply:GetFriendStatus() == "friend" then
					-- surface.SetDrawColor(Color(50,255,50,255 * fusion.cl.AlphaMult))					
				-- elseif ply == LocalPlayer() then	
					-- surface.SetDrawColor(Color(100,100,100,255 * fusion.cl.AlphaMult))

					draw.RoundedBox(2, x_bar+1-sub + 1, y_bar+1 + 1, 5 - 2, barheight-3 - 2, Color(0,255,255,100 * fusion.cl.AlphaMult))
				else
					-- surface.SetDrawColor(Color(100,100,100,255 * fusion.cl.AlphaMult))
					
					draw.RoundedBox(2, x_bar+1-sub + 1, y_bar+1 + 1, 5 - 2, barheight-3 - 2, Color(0,0,0,100 * fusion.cl.AlphaMult))
				end
				
				-- surface.SetTexture(fusion.cl.gradient_cen)
				-- surface.DrawTexturedRect(x_bar+1-sub, y_bar+1, 5, barheight-3)

				local textCol = Color(255,255,255,255 * fusion.cl.AlphaMult)	
				local shadowCol = Color(0,0,0,255 * fusion.cl.AlphaMult)
				
				local lineCol = fusion.cl.GetRankColour(ply)
				local comb = lineCol.r + lineCol.g + lineCol.b
				
				local total = 255*3	
				
				local shadowSize = 2
				
				for i = 1, shadowSize do draw.SimpleText(ply:Name(), "SBNormalBlur", x_bar + 5 + add - sub + avaSize+2, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
				-- draw.SimpleText(ply:Name(), "SBNormal", x_bar + 5 + add - sub + 1, y_bar + h_bar / 2 + 1, Color(0,0,0,fusion.cl.AlphaMult), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:Name(), "SBNormal", x_bar + 5 + add - sub + avaSize+2, y_bar + h_bar / 2, textCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							
				if fusion.cl.ShowRankColours then
					local title = ply.fTitle
					local rank = team.GetName(pteam)
					
					local text = title or rank
					
					local font = "SBNormal"
					
					
					
					surface.SetFont(font)
					local w,h = surface.GetTextSize(text)
					
					if !title or title == "" or mouseInRegion(x_bar + w_bar * rankPos - w/2, y_bar + h_bar / 2 - h/2, w, h) then
						text = rank
					elseif title then					
						-- if title then
							font = "SBUnderlined"
							-- surface.SetDrawColor(Color(255,255,255,150 * fusion.cl.AlphaMult))
							-- surface.DrawLine(x_bar + w_bar * rankPos - w/2, y_bar + h_bar - 7, x_bar + w_bar * rankPos + w/2, y_bar + h_bar - 7) 
							
							-- surface.SetDrawColor(Color(0,0,0,100 * fusion.cl.AlphaMult))
							-- surface.DrawLine(x_bar + w_bar * rankPos - w/2 + 1, y_bar + h_bar - 7 + 1, x_bar + w_bar * rankPos + w/2 + 1, y_bar + h_bar - 7 + 1) 
						-- end					
					end
					
					for i = 1, shadowSize do draw.SimpleText(text, font .. "Blur", x_bar + w_bar * rankPos, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
					draw.SimpleText(text, font, x_bar + w_bar * rankPos, y_bar + h_bar / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
					
				end
				
				-- local x,y,w,h = x_bar + w_bar * 0.68, y_bar + 1, w_bar * 0.32-1, h_bar-1
				
				-- draw.RoundedBox(0,x,y,w,h, Color(50,50,50,200 * fusion.cl.AlphaMult))
				-- surface.SetDrawColor(100, 100, 100, 100 * fusion.cl.AlphaMult)	
				-- surface.DrawOutlinedRect(x,y,w,h)
				
				local time = ply.Time or 0
				local lastupdate = ply.LastUpdate or 0
				
				local predict = time + ( CurTime() - lastupdate )
				local timespent = fusion.ConvertTime( predict )	
				
				for i = 1, shadowSize do draw.SimpleText(timespent, "SBNormalBlur", x_bar + w_bar * timePos, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
				draw.SimpleText(timespent, "SBNormal", x_bar + w_bar * timePos, y_bar + h_bar / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				
				local entscount = 0
				
				for i = 1, #counts do entscount = entscount + ply:GetCount(counts[i]) end				
				for i = 1, shadowSize do draw.SimpleText(entscount, "SBNormalBlur", x_bar + w_bar * entsPos, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
				draw.SimpleText(entscount, "SBNormal", x_bar + w_bar * entsPos, y_bar + h_bar / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				local kd = ply:Frags() .. " / " .. ply:Deaths()
				for i = 1, shadowSize do draw.SimpleText(kd, "SBNormalBlur", x_bar + w_bar * kdPos, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
				draw.SimpleText(kd, "SBNormal", x_bar + w_bar * kdPos, y_bar + h_bar / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				
				
				
				local ping = ply:Ping()
				
				for i = 1, shadowSize do draw.SimpleText(ping .. "  ", "SBNormalBlur", x_bar + w_bar * pingPos, y_bar + h_bar / 2, shadowCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
				draw.SimpleText(ping .. "  ", "SBNormal", x_bar + w_bar * pingPos, y_bar + h_bar / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				
				
			end				
		end
		
		
		
		
		
		// wave
		
		
		//WAVE BG
			-- draw.RoundedBox( 0, x+2, y + 2, w - 4, header_h - 4, Color(0,0,0,150 * fusion.cl.AlphaMult) )
			
			scoreboardRow(x+2, y + 2, w - 4, header_h - 4 - 24 - 2,fusion.cl.GetColour(255 * fusion.cl.AlphaMult), true, fusion.cl.AlphaMult / 1.5)
			
			// gradients
			if true then
				local x = x + 2
				local y = y + 2 
				local w = w - 4
				local h = header_h - 30
				
				local grad_height = 16
				
				surface.SetTexture(fusion.cl.gradient_down)		
				-- surface.SetDrawColor(fusion.cl.GetColour(255 * fusion.cl.AlphaMult))
				surface.SetDrawColor(Color(0,0,0,115 * fusion.cl.AlphaMult))
				
				surface.DrawTexturedRectRotated(x + w/2, y + grad_height/2, w, grad_height, 0)	// top
				surface.DrawTexturedRectRotated(x + w/2, y + (h - grad_height/2), w, grad_height, 180)	// bottom
				

				-- draw.RoundedBox(0, x, y + h/2, w, h/2, Color(0,0,0,30))
			end	
		//
		local wave_seg_width = 6
		local wave_seg_gap = 5
		
		local block_size = wave_seg_width + wave_seg_gap //
		-- block_size = math.Round(block_size / (fusion.cl.HUDSpeedMult/4))
		
		
		local wave_segs = 60//26		
		local wave_height = 66 //66
		
		-- wave_segs = math.Round((w-2) / block_size)
		
		-- draw.SimpleText(wave_segs, "dTimers", 5, 5, Color(255,255,255,255))	
		
		

		local wave_x = x + 2 //2
		local wave_y = y + 2 // 2
		
		local time = -CurTime();
		
		local prev = nil
		
		local hsvsteps = 360 / wave_segs
		
		-- surface.SetDrawColor(Color(255,255,255,255))
		
		local mx = gui.MouseX()
		local my = gui.MouseY()
		
		local orig_wave_x = wave_x
		
		local wavex_add = 0
		
		for i = 1, wave_segs do
			local sine = math.sin(time * fusion.cl.wave_speed + i*fusion.cl.wave_pattern)
			local sine2 = math.abs(sine)	
			
			local height = math.Round(sine2 * wave_height)
			
			if fusion.cl.wave_speed == 0 then
				height = wave_height
			end
			
			height = math.Clamp(height, 5, wave_height)
			
			local myy = wave_y + wave_height - height
						
			local alpha = fusion.cl.wave_alpha//255
			
			if i > 26 then
				alpha = (1-((i - 26) / (wave_segs-26))) * alpha
			end
			
			alpha = alpha * fusion.cl.AlphaMult
			
			wavex_add = wave_seg_width + wave_seg_gap	
			
			if fusion.cl.wave_style == 1 then
				surface.SetDrawColor(Color(0,0,0,alpha/2))
				surface.DrawOutlinedRect(wave_x, wave_y, wave_seg_width, wave_height)
				
				draw.RoundedBox(2, wave_x, wave_y, wave_seg_width, wave_height, Color(0,0,0,alpha/2))
				
				draw.RoundedBox(2, wave_x, myy, wave_seg_width, height, Color(0,0,0,alpha))
			elseif fusion.cl.wave_style == 2 then
				local colour = HSVToColor(sine * 180, 1, 1)
				colour.a = alpha
			
				surface.SetDrawColor(Color(0,0,0,alpha/2))
				surface.DrawOutlinedRect(wave_x, wave_y, wave_seg_width, wave_height)
				
				draw.RoundedBox(2, wave_x, wave_y, wave_seg_width, wave_height, Color(0,0,0,alpha/2))
			
				draw.RoundedBox(2, wave_x, myy, wave_seg_width, height, colour)
			elseif fusion.cl.wave_style == 3 then
				if prev then
					surface.SetDrawColor(Color(0,0,0,alpha))
					surface.DrawLine(wave_x, myy, prev.x, prev.y)
				end
			elseif fusion.cl.wave_style == 4 then
				surface.SetDrawColor(Color(0,0,0,alpha/2))
				surface.DrawOutlinedRect(wave_x, wave_y, wave_seg_width, wave_height)
				
				draw.RoundedBox(2, wave_x, wave_y, wave_seg_width, wave_height, Color(0,0,0,alpha/2))
				
				-- local cool_colour = Color(0,0,0,alpha)
				
				local cen_pos = Vector(wave_x + wave_seg_width /2, myy + height /2)
				
				local dist = math.Dist(cen_pos.x, cen_pos.y, mx, my)
				local float = nil
				
				draw.RoundedBox(2, wave_x, myy, wave_seg_width, height, Color(0,0,0,alpha))
				
				if dist <= 255 then				
					float = 1-(dist/255)	
					
					
					local cool_colour = fusion.cl.GetColour(math.floor(alpha * float))
					draw.RoundedBox(2, wave_x, myy, wave_seg_width, height, cool_colour)
				end
				
				local top_pos = Vector(wave_x + wave_seg_width /2, myy)
				
				draw.RoundedBox(2, top_pos.x-2, top_pos.y+1, 4, 4, Color(200,200,200,alpha))
				
				surface.SetDrawColor(Color(150,150,150,alpha))				
				surface.DrawLine(top_pos.x, top_pos.y, orig_wave_x, top_pos.y)
				
				-- surface.SetDrawColor(fusion.cl.GetColour(20))				
				-- surface.DrawLine(top_pos.x, top_pos.y, orig_wave_x, top_pos.y)				
			elseif fusion.cl.wave_style == 5 then
				local colour = HSVToColor(sine * 180, 1, 1)
				colour.a = alpha			
				draw.RoundedBox(0, wave_x, wave_y, block_size, wave_height, colour)
			
				wavex_add = block_size
			
			elseif fusion.cl.wave_style == 6 then
				-- local h,s,v = ColorToHSV(fusion.cl.GetColour(alpha))
			
				-- print(h,s,v)
			
				-- local colour = HSVToColor(h, sine2, sine2)
				
				local colour = fusion.cl.GetColour(alpha * sine2)
				-- colour.a = alpha			
				draw.RoundedBox(0, wave_x, y + 2, block_size, wave_height, colour)
			
				wavex_add = block_size
			
			elseif fusion.cl.wave_style == 7 then
				local steps = math.Round(wave_height / block_size)
				
				local cur_y = wave_y
				for n = 1, steps do // should be 11?
					
					
					
					local mySine = math.sin(time * fusion.cl.wave_speed + (i + n) * fusion.cl.wave_pattern)
					
					local colour = HSVToColor(mySine * 180, 1, 1)
					colour.a = alpha
					
					-- draw.RoundedBox(0, wave_x, cur_y, wave_seg_width + wave_seg_gap, wave_seg_width + wave_seg_gap, Color(0,0,0,100))
					draw.RoundedBox(0, wave_x, cur_y, block_size, block_size, colour)
					
					cur_y = cur_y + wave_seg_width + wave_seg_gap
				end
				
				wavex_add = block_size
				
			elseif fusion.cl.wave_style == 8 then	
				-- local num = fusion.cl.wave_pattern * 360
			
				-- local h = math.sin(num)
				-- local s = math.sin(num)
				-- local v = 
			
				-- local colour = HSVToColor( * 360 - 180, 1, 1)
				-- colour.a = alpha				
				
				-- draw.RoundedBox(0, wave_x, y + 2, wave_seg_width + wave_seg_gap, wave_height, colour)				
			end
			
			
			
			prev = Vector(wave_x, myy)
			
			
			wave_x = wave_x + wavex_add
		end
		
		// server name
		
		local hostname = GetHostName()
		hostname = hostname:gsub("%b[]", "")
		hostname = string.Trim(hostname)
		
		-- hostname = "The Creation Station"
		
		draw.SimpleText(hostname, "hflarge2", x + 10, y + 6, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_LEFT)
		draw.SimpleText(hostname, "hflarge", x + 10 + 1, y + 6 + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_LEFT)
		draw.SimpleText(hostname, "hflarge", x + 10, y + 6, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_LEFT)
		
		// player count, map, gamemode
		local alp = tostring(math.Round(255 * fusion.cl.AlphaMult))		
				
		local white_str = fusion.cl.ColorMarkupString(alp) //"255,200,200" 
		
		local count = #player.GetAll()
		
		local format = "Playing %s on %s with %d player(s)"
		
		if (count == 1) then
			format = "Playing %s on %s by yourself!"
		end
		
		local test_string = Format(format, gmod.GetGamemode().Name, game.GetMap(), count)
		
		surface.SetFont("SBNormal")
		local tw, th = surface.GetTextSize(test_string)
		
		local pc_y = y + 45
		
		draw.RoundedBox(4, x + 15 - 5, pc_y - 2, tw + 10, th + 4, Color(0,0,0,75))		
				
		draw.SimpleText(test_string, "SBNormalBlur", x + 15, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult))
		draw.SimpleText(test_string, "SBNormal", x + 15 + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult))
		draw.SimpleText(test_string, "SBNormal", x + 15, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult))		
		
		// labels
		 
		if fusion.cl.ShowRankColours then
			draw.SimpleText("Title", "SBNormalBlur", x_bar + w_bar * rankPos, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
			draw.SimpleText("Title", "SBNormal", x_bar + w_bar * rankPos + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
			draw.SimpleText("Title", "SBNormal", x_bar + w_bar * rankPos, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		end
		
		draw.SimpleText("Entities", "SBNormalBlur", x_bar + w_bar * entsPos, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Entities", "SBNormal", x_bar + w_bar * entsPos + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Entities", "SBNormal", x_bar + w_bar * entsPos, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)

		
		draw.SimpleText("K/D", "SBNormalBlur", x_bar + w_bar * kdPos, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("K/D", "SBNormal", x_bar + w_bar * kdPos + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("K/D", "SBNormal", x_bar + w_bar * kdPos, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)

		
		draw.SimpleText("Time Played", "SBNormalBlur", x_bar + w_bar * timePos, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Time Played", "SBNormal", x_bar + w_bar * timePos + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Time Played", "SBNormal", x_bar + w_bar * timePos, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)

		draw.SimpleText("Ping", "SBNormalBlur", x_bar + w_bar * pingPos - 2, pc_y, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Ping", "SBNormal", x_bar + w_bar * pingPos - 2 + 1, pc_y + 1, Color(0,0,0,100 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)
		draw.SimpleText("Ping", "SBNormal", x_bar + w_bar * pingPos - 2, pc_y, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER)				
		///
		
		-- // RATINGS 
		local icon_x = x + w-4-20 // + 2
		local icon_y = y + 2
		
		local midX = icon_x - (21 * (#fusion.Ratings/2)) + 21
		
		if (!fusion.RatingsAlpha) then 
			fusion.RatingsAlpha = 100
		end
		
		if (mouseInRegion(x + w - 300,y,300,70,20)) then
			fusion.RatingsAlpha = math.Clamp(fusion.RatingsAlpha + 25, 100, 255)
		else
			fusion.RatingsAlpha = math.Clamp(fusion.RatingsAlpha - 25, 100, 255)
		end
		
		
		
		if me.Ratings and fusion.Ratings then	
		
			-- local nw = (21 * #fusion.Ratings)
			-- draw.RoundedBox(0,icon_x - nw - 2, icon_y+2 - 2, nw + 4 , 20 + 4, Color(50,50,50,200))
		
			for k = #fusion.Ratings, 1, -1 do
				local x,y,w,h = icon_x, icon_y + 2, 20, 20						
				local rating = fusion.Ratings[k]
				-- draw.RoundedBox(0,x-1, y-1, w+2, h+2, Color(60, 60, 60, fusion.RatingsAlpha * fusion.cl.AlphaMult))
	
				simpleIconButton2(fusion.RatingsIcons[k], x, y, w, h, nil, nil, fusion.NiceRatings[k] .. " x " .. me.Ratings[k], Vector(midX, icon_y - 17), fusion.RatingsAlpha)
				

				
					-- draw.RoundedBox(0,x, y, w, h, Color(0, 0, 0, fusion.RatingsAlpha / 2 * fusion.cl.AlphaMult))
					draw.SimpleText(me.Ratings[k], "SBSmall", x + w/2, y + h/2, Color(255,255,255,fusion.RatingsAlpha * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
				
				icon_x = icon_x -21
			end	
		else
			RunConsoleCommand("request_ratings")
		end
		-- //
			
			
		
		-- for i = 1, 6 do
			-- local circle = GeneratePoly(x + 30 + (i * 20), y + 35, 30 - (i * 2), 24)			
			-- surface.SetTexture(fusion.cl.gradient)
			-- surface.SetDrawColor(255, 255, 255, (50 - 5 * i) * fusion.cl.AlphaMult)
			-- surface.DrawPoly(circle)		
		-- end
		
		
		-- draw.RoundedBox(0, x + 2, y + 35, w - 4, 32, Color(0,0,0,200))
		
		
		
		
		// boyzz
		
		-- surface.SetMaterial(fusion.cl.da_boyz_shadow)		
		-- surface.SetDrawColor(Color(255,255,255,255 * fusion.cl.AlphaMult))	
		-- surface.DrawTexturedRect(x, y-256/2 + 68, 512/2, 256/2)
		
		-- surface.SetMaterial(fusion.cl.da_boyz)		
		-- surface.SetDrawColor(Color(255,255,255,255 * fusion.cl.AlphaMult))	
		-- surface.DrawTexturedRect(x, y-256/2 + 68, 512/2, 256/2)
		
		-- local blur_alpha = math.abs(math.sin(CurTime() * 2)) * 100 + 20		
		
		-- surface.SetMaterial(fusion.cl.da_boyz_blurred)		
		-- surface.SetDrawColor(Color(255,255,255,blur_alpha * fusion.cl.AlphaMult))	
		-- surface.DrawTexturedRect(x, y-256/2 + 68, 512/2, 256/2)
		
			
		-- local boyz = {}
		-- boyz.Droke = {x = x + 128 - 50, y = y - 30, role = "Founder & Code Monkey", id = "STEAM_0:0:13058591"}
		-- boyz["Little Donny"] = {x = x + 128 + 2, y = y - 35, role = "Administrator & Ultimate Warrior", id = "STEAM_0:0:12465782"}
		-- boyz.Vitek = {x = x + 128 + 50 + 7, y = y - 27, role = "Administrator & Receptionist", id = "STEAM_0:1:28352266"}
			
		-- local text = "INERVATE"	
			
		-- local fade = 255	
			
		-- local name = nil
		-- local role = nil
		-- local id = nil
			
		-- for k,v in pairs(boyz) do		
						
			-- if math.Dist(v.x, v.y, gui.MouseX(), gui.MouseY()) < 15 then
				-- name = k
				-- role = v.role
				-- id = v.id
				
				-- fade = 20
			-- end			
		-- end
		
		-- draw.SimpleText(text, "logofont_bigger", x + 128, y + 35, Color(0,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- draw.SimpleText(text, "logofont", x + 128, y + 35, Color(255,255,255,fade * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
		-- if name and role then
			-- local online = false
		
			-- for k,v in pairs(player.GetAll()) do
				-- if v:SteamID() == id then
					-- online = true
					-- name = v:Name()
				-- end
			-- end
			
			-- draw.SimpleText(name, "logofont", x + 128, y + 35, Color(255,255,255,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- draw.SimpleText(role, "SBNormal", x + 128, y + 35 + 20, Color(200,200,200,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
			
			
			-- if online then
				-- draw.SimpleText("ONLINE", "SBNormal", x + 128, y + 35 - 20, Color(0,255,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- else
				-- draw.SimpleText("OFFLINE", "SBNormal", x + 128, y + 35 - 20, Color(255,0,0,255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- end
		-- end
			
		//
		
		
		
		
		-- draw.RoundedBox(0, x + 2, y + 2 + header_h - 34 - 1, w - 4, 1, Color(30, 30, 30, 150 * fusion.cl.AlphaMult))
		
		
		-- draw.RoundedBox(0, x + 2, y + 3 + header_h - 34, w - 4, 3, fusion.cl.GetColour(255 * fusion.cl.AlphaMult))
					
			
		-- surface.SetTexture(fusion.cl.gradient_cen)
		-- surface.SetDrawColor(Color(255,255,255,50))	
		-- surface.SetDrawColor(fusion.cl.GetColour(255 * fusion.cl.AlphaMult))	
		-- surface.DrawTexturedRect(x + 2, y + 3 + header_h - 34, w - 4, 3)	
		
		
		
			

		draw.RoundedBox(0, x + 2, y - top_height + 2, w - 4, top_height - 1, fusion.cl.GetColour(255 * fusion.cl.AlphaMult)) // top bar		
		
		
		draw.RoundedBox(0, x + 1, y + 2 + header_h - 34, w - 2, 5, Color(50,50,50,255 * fusion.cl.AlphaMult)) // middle bear
		draw.RoundedBox(0, x + 2, y + 2 + header_h - 34 + 1, w - 4, 3, fusion.cl.GetColour(255 * fusion.cl.AlphaMult)) // middle bear
		
		
		
		
		draw.RoundedBox(0, x + 2, y + h - 1, w - 4, bottom_height - 1, fusion.cl.GetColour(255 * fusion.cl.AlphaMult)) // bottom bar
		
		
		
		
		
		
		
		// scroll
		
		if (fusion.cl.scrollrequired) then
			local scrollbar_y = y + 100 + 30 + 2
			local scrollbar_h = h - 100 - 30 - 5
			
			local scrollbar_bar_h = scrollbar_h / (num - fusion.cl.scrollmax)
			
			local ymax = scrollbar_y + scrollbar_h - scrollbar_bar_h
			
			local scrollbar_bar_y = scrollbar_y + (((fusion.cl.scroll-1) / ((num - fusion.cl.scrollmax))) * (ymax - scrollbar_y))
			
			local sbw = 6
			local sbx = x+w-sbw-5
			
			draw.RoundedBox( 0, sbx, scrollbar_y-1, sbw+2, scrollbar_h+2, fusion.cl.scoreboardSecondary(255 * fusion.cl.AlphaMult) )
			draw.RoundedBox( 0, sbx+1, scrollbar_y, sbw, scrollbar_h, fusion.cl.scoreboardPrimary(50 * fusion.cl.AlphaMult) )
			
			draw.RoundedBox( 0, sbx+1, scrollbar_bar_y, sbw, scrollbar_bar_h, fusion.cl.scoreboardPrimary(255 * fusion.cl.AlphaMult) )	
			draw.RoundedBox( 0, sbx+1, scrollbar_bar_y, sbw/2, scrollbar_bar_h, fusion.cl.scoreboardSecondary(50 * fusion.cl.AlphaMult) )
		end	
		
		
		
		fusion.cl.ColourPicker() 
	else
		for _, avatar in pairs(sAvatars) do
			-- avatar:SetPos(-1000,0)
			avatar:SetVisible(false)
			-- print(avatar)
		end
	end
	
	fusion.cl.VotePanel()
	
	//fusion.cl.drawShop(fusion.cl.shopAlphaMult)
	
	
		
	if scoreboard_up and fusion.cl.showlogpanel then		
		fusion.cl.paintAnnouncementsLog()		
	else	
		
	end
	
	
		fusion.cl.logActive = false
	
	-- fusion.cl.DoInfoPages()
end )

-- fusion.cl.GMColour = 1

-- fusion.cl.GradStyle = 1

function simpleGradient(x, y, w, h, colour, amult, texture)

	mult = 1
	if amult then
		mult = amult
	end

	
	if colour then
		colour.a = math.Clamp(255 * mult, 0, 255)
	else
		colour = fusion.cl.scoreboardPrimary(150 * mult)								
	end

	draw.RoundedBox(0, x,y,w,h,colour)

	
		
		
end

-- function mouseInRegion(x,y,w,h)
	-- return (gui.MouseX() > x and gui.MouseX() < x + w and gui.MouseY() > y and gui.MouseY() < y + h)
-- end

function simpleSideGradient(x, y, w, h, colour, grad_width)
	surface.SetTexture( fusion.cl.gradient )
	surface.SetDrawColor(colour)	
	surface.DrawTexturedRectRotated(x-grad_width/2,y + h/2,grad_width,h,180)
	surface.DrawTexturedRectRotated(x+w+grad_width/2,y + h/2,grad_width,h,0)
end

function scoreboardRow(x, y, w, h, colour, no_highlight, amult, texture)
	
	x,y,w,h = math.Round(x), math.Round(y), math.Round(w), math.Round(h)
	
	mult = 1
	if amult then
		mult = amult
	end
		
	if colour then
		draw.RoundedBox( 0, x-1,y-1,w+2,h+2, Color(50,50,50,255 * mult))	
	end	
		
	draw.RoundedBox( 0, x,y,w,h, Color(80,80,80,255 * mult))
		
	if colour then	
	
		-- local rank_col_h = 20
	
		local grad_col = table.Copy(colour)
		-- grad_col.a = grad_col.a * mult
		grad_col.a = 255 * mult 
	
		draw.RoundedBox(0, x,y,w,h, Color(80,80,80,255 * mult))
		
		draw.RoundedBox(0, x,y,w,h, grad_col)
		
		-- draw.RoundedBox(0, x,y,w,h/2, grad_col)
		draw.RoundedBox(0, x,y+h/2,w,h/2, Color(0,0,0,25 * mult)) 
		
		-- draw.RoundedBox(8, x,y,w,h-rank_col_h/2, Color(80,80,80,255 * mult))
		
		
	
		
		
		
	
		local comb = colour.r + colour.g + colour.b
		local total = 255*3
		
		-- local highlight_colour = Color(255,255,255,a*3 * mult)
		
		local c
		local p = comb / total
		
		local a = 20		
		
		-- surface.SetTexture(fusion.cl.gradient)
			
		
		if p > 0.5 then	
			c = Color(255,255,255,a * mult)
			-- draw.RoundedBox( 0, , c)
			-- surface.SetDrawColor(c)
			-- surface.DrawTexturedRect(x,y,w,h/2)
		else
			c = Color(0,0,0,a*2 * mult)
			-- draw.RoundedBox( 0, , c)	
			-- surface.SetDrawColor(c)	
			-- surface.DrawTexturedRect(x,y + h/2,w,h/2)
		end	

		
		
	
		if !no_highlight then
			if mouseInRegion(x,y,w,h) then		
				-- draw.RoundedBox(0, x,y,w,h, Color(255,255,255,10 * mult))
				
				-- c = Color(255,255,255,50)
				-- surface.SetTexture(fusion.cl.gradient_cen)
				-- surface.SetDrawColor(c)	
				-- surface.DrawTexturedRect(x, y, w, h)
			else
				//draw.RoundedBox( 0, x,y,w,h, Color(255,255,255,10))
			end
		end
	end
	
	if !colour then
		draw.RoundedBox( 0, x,y,w,h, fusion.cl.scoreboardPrimary(150 * mult))
	
		surface.SetDrawColor(fusion.cl.scoreboardPrimary(BAlpha * mult))
		
		surface.DrawLine(x,y,x+w-1,y) // top left to top right
		
		surface.DrawLine(x+w-1,y,x+w-1,y+h+1) // top right to bottom right
		
		surface.DrawLine(x,y+h,x+w-1,y+h) // bottom left to bottom right
		
		surface.DrawLine(x,y,x,y+h) // top left to bottom left
		
	end
	
	
end

function simpleButton(text, col, x, y, w, h, func, ply, func2)
	local return_val = false
	
	draw.RoundedBox(0,x,y,w,h,col)
	
	simpleGradient(x, y, w, h, Color(80,80,80,150))
	
	local cc = table.Copy(col)
	cc.a = 50		
	draw.RoundedBox(0,x,y,w,h,cc)	
	
	cc.a = 70	
	surface.SetDrawColor(cc)
	surface.SetTexture(fusion.cl.gradient_down)					
	surface.DrawTexturedRect(x,y,w,h)
	
	if gui.MouseX() > x and gui.MouseX() < x + w and gui.MouseY() > y and gui.MouseY() < y + h then
		-- simpleGradient(x, y, w, h, Color(100,100,100,200))
		
		if func then
			if fusion.cl.IsMousePressed(MOUSE_LEFT) then
				func(ply, true)
				surface.PlaySound("buttons/lightswitch2.wav")
				return_val = true
			elseif fusion.cl.IsMousePressed(MOUSE_RIGHT) then
				if func2 then func2(ply, false) else func(ply, false) end
				surface.PlaySound("buttons/lightswitch2.wav")
				return_val = true
			end
		end
		
		surface.SetDrawColor(Color(255, 255, 255, 50))
		surface.SetTexture(fusion.cl.gradient_cen)					
		surface.DrawTexturedRect(x,y,w,h)
		-- 
	end
		
	-- surface.SetTexture(fusion.cl.gradient)		
	-- surface.DrawTexturedRect(x,y,w,h)
	
	
	
	-- surface.SetDrawColor(Color(255,255,255,10))
	-- surface.DrawLine(x,y,x+w-1,y) // top left to top right	
	-- surface.DrawLine(x+w-1,y,x+w-1,y+h+2) // top right to bottom right
	-- surface.DrawLine(x,y+h+1,x+w-1,y+h+1) // bottom left to bottom right	
	-- surface.DrawLine(x,y,x,y+h+1) // top left to bottom left

	draw.SimpleText(text, "SBNormal", x + w/2, y + h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	return return_val
end

function simpleIconButton2(icon, x, y, w, h, func, ply, tooltip, tooltipPos, alpha, rfunc, fromLeft, iconSize)
	-- draw.RoundedBox(0,x,y,w,h, Color(50,50,50,alpha*fusion.cl.AlphaMult))	
	
	local iconSize = 16 or iconSize
	
	if gui.MouseX() > x and gui.MouseX() < x + w and gui.MouseY() > y and gui.MouseY() < y + h then
		surface.SetDrawColor(Color(255,255,255,alpha*fusion.cl.AlphaMult))
		
		-- iconSize = 16
		
		if func then
			if fusion.cl.IsMousePressed(MOUSE_LEFT) then
				func(ply)
			end			
		end
		
		if rfunc then
			if fusion.cl.IsMousePressed(MOUSE_RIGHT) then
				rfunc(ply)
			end			
		end
		
		surface.SetFont("SBNormal")
		local w,h = surface.GetTextSize(tooltip)
		
		local w = w + 10
		local h = h + 10
		
		if (fromLeft) then
			draw.RoundedBox(2, tooltipPos.x, tooltipPos.y - h/2, w, h, Color(50,50,50,200))
			draw.SimpleText(tooltip, "SBNormal", tooltipPos.x+5, tooltipPos.y, Color(255,255,255,alpha*fusion.cl.AlphaMult), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(2, tooltipPos.x - w/2, tooltipPos.y - h/2, w, h, Color(50,50,50,200))
			draw.SimpleText(tooltip, "SBNormal", tooltipPos.x, tooltipPos.y, Color(255,255,255,alpha*fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else		
		surface.SetDrawColor(Color(255,255,255,(alpha/2)*fusion.cl.AlphaMult))
	end
	
	-- surface.SetTexture(fusion.cl.gradient)		
	-- surface.DrawTexturedRect(x,y,w,h)
	
	-- surface.SetDrawColor(fusion.cl.scoreboardPrimary(alpha / 2))
	-- surface.DrawOutlinedRect(x,y,w,h+1)
	
	-- surface.SetDrawColor(Color(255,255,255,alpha*fusion.cl.AlphaMult))
	surface.SetMaterial(icon)	
	surface.DrawTexturedRect(x + w/2 - (iconSize/2),y + h/2 - (iconSize/2),iconSize,iconSize)
	
	if (iconSize == 18) then
		surface.SetDrawColor(Color(0,0,0,(alpha/1.75)*fusion.cl.AlphaMult))
		surface.SetMaterial(icon)	
		surface.DrawTexturedRect(x + w/2 - (iconSize/2),y + h/2 - (iconSize/2),iconSize,iconSize)
	end
end

function simpleIconButton(icon, x, y, w, h, func, ply)
	draw.RoundedBox(0,x,y,w,h, Color(50,50,50,255*fusion.cl.AlphaMult))	
	
	if gui.MouseX() > x and gui.MouseX() < x + w and gui.MouseY() > y and gui.MouseY() < y + h then
		surface.SetDrawColor(Color(100,100,100,255*fusion.cl.AlphaMult))
		if func then
			if fusion.cl.IsMousePressed(MOUSE_LEFT) then
				func(ply)
			end
		end		
	else		
		surface.SetDrawColor(Color(80,80,80,200*fusion.cl.AlphaMult))
	end
	
	surface.SetTexture(fusion.cl.gradient)		
	surface.DrawTexturedRect(x,y,w,h)
	
	surface.SetDrawColor(fusion.cl.scoreboardPrimary(BAlpha))
	surface.DrawOutlinedRect(x,y,w,h+1)
	
	surface.SetDrawColor(Color(255,255,255,255*fusion.cl.AlphaMult))
	surface.SetMaterial(Material(icon))	
	surface.DrawTexturedRect(x + w/2 - 8,y + h/2 - 8,16,16)
end

fusion.cl.MCDown = {}

function fusion.cl.MousePressedFunc( mc )	
	fusion.cl.MousePressed = fusion.cl.MousePressed or {}
	fusion.cl.MousePressed[mc] = CurTime() + 0.01	
	fusion.cl.MCDown[mc] = true
	fusion.cl.MouseTimerCheck = CurTime()
end

function fusion.cl.IsMouseReleased( code )		
	if ( !fusion.cl.NextClick and fusion.cl.MouseReleased and fusion.cl.MouseReleased[code] and fusion.cl.MouseReleased[code] > CurTime() ) then
		fusion.cl.NextClick = true
		return true
	end
	return false
end

function fusion.cl.IsMousePressed( code )

	-- return input.WasMousePressed(code)

	if code == -1 or code == 1 then
		return ( fusion.cl.MousePressed and fusion.cl.MousePressed[code] and fusion.cl.MousePressed[code] > CurTime() )
	else	
		if ( !fusion.cl.NextClick and fusion.cl.MousePressed and fusion.cl.MousePressed[code] and fusion.cl.MousePressed[code] > CurTime() ) then
			fusion.cl.NextClick = true
			return true
		end
	end	
	return false
end

function fusion.cl.IsDown( code )		
	return input.IsMouseDown( code )
end

function fusion.cl.MouseReleasedFunc( mc )
	fusion.cl.NextClick = false
	
	fusion.cl.MouseReleased = fusion.cl.MouseReleased or {}
	fusion.cl.MouseReleased[mc] = CurTime() + 0.02  

	fusion.cl.MCDown[mc] = nil
end

function fusion.cl.InputControl(bool)
	if bool then
		fusion.cl.ScrollPanel = vgui.Create( "DPanel" )
		fusion.cl.ScrollPanel:SetPos( 0, 0 )
		fusion.cl.ScrollPanel:SetSize( ScrW(), ScrH() )
		fusion.cl.ScrollPanel:SetVisible( true )
		fusion.cl.ScrollPanel:MouseCapture(true)
		fusion.cl.ScrollPanel:SetMouseInputEnabled(true)
		
		fusion.cl.ScrollPanel.OnMouseWheeled = function( self, mc )
			local code = 0		
			if mc > 0 then
				code = 1
			elseif mc < 0 then
				code = -1
			end		
			fusion.cl.MousePressedFunc(code)
		end
		
		fusion.cl.ScrollPanel.OnMouseReleased = function( self, mc ) 
			fusion.cl.MouseReleasedFunc(mc)
		end
		fusion.cl.ScrollPanel.OnMousePressed = function( self, mc ) 
			fusion.cl.MousePressedFunc(mc)
		end
		
		fusion.cl.ScrollPanel.Paint = function()
			-- draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255,255,255,100))
		end
	else
		if fusion.cl.ScrollPanel and fusion.cl.ScrollPanel:IsValid() then
			fusion.cl.ScrollPanel:Remove()
			fusion.cl.ScrollPanel = nil
		end
	end
end

fusion.cl.ColourButtonOpen = false
fusion.cl.ColourScroll = 1
fusion.cl.ColourPush = -40

local pushdist = 160
local pushamount = 6 //0.6

local gradtypes = {}
gradtypes[1] = "Left Gradient"
gradtypes[2] = "Center Gradient"
gradtypes[3] = "No Gradient"


fusion.cl.ShowPlayerNames = true
fusion.cl.JumpOn = true
fusion.cl.ShowRankColours = true
fusion.cl.ShowSpawnpoint = false

local function booltonum(bool)
	if bool then return 1 else return 0 end
end

local function numtobool(num)
	if num==0 then return false else return true end
end

local function sendJumpStatusToServer()
	if fusion.cl.JumpOn then
		RunConsoleCommand("enable_superjump")
	else
		RunConsoleCommand("disable_superjump")
	end
end

-- local function sendLocalVoiceStatusToServer()
	-- if fusion.cl.JumpOn then
		-- RunConsoleCommand("enable_localvoice")
	-- else
		-- RunConsoleCommand("disable_localvoice")
	-- end
-- end

local styles = {
	
	"bars",
	"mbars",
	"line",
	"cool",
	"colour",
	"light",
	"squares"
	-- "blank"
	}

local settings = {
	-- {
		-- OnClick = function()
			-- if fusion.cl.shopActive then
				-- fusion.cl.shopActive = false
			-- else 
				-- fusion.cl.openShop()
				-- scoreboard_up = false
			-- end
		-- end,
		-- GetName = function()
			-- if fusion.cl.shopActive then
				-- return "Close Shop"
			-- else
				-- return "Open Shop"
			-- end
		-- end,
		-- Icon = Material("icon16/coins.png"),
		-- Colour = Color(255, 255, 0),
		-- Initialize = function()	end,
		-- IsActive = function() return fusion.cl.shopActive end
	-- },
	
	{
		OnClick = function()
			-- fusion.cl.ShowSpawnpoint = !fusion.cl.ShowSpawnpoint
			-- cookie.Set( "fusion_showspawn", booltonum(fusion.cl.ShowSpawnpoint) )
			
			fusion.cl.ShowTelepotter = !fusion.cl.ShowTelepotter
		end,
		GetName = function()
			if (fusion.cl.ShowTelepotter) then
				return "Hide Telepotter Azkaban 5000"
			else
				return "Show Telepotter Azkaban 5000"
			end
			
		end,
		Icon = Material("icon16/wand.png"),
		Colour = Color(150, 255, 255),
		Initialize = function()
			-- local c = cookie.GetNumber( "fusion_showspawn" )
			-- if c then
				-- fusion.cl.ShowSpawnpoint = numtobool(c)
			-- end
		end,
		IsActive = function() return fusion.cl.ShowTelepotter end
	},
	
	{
		OnClick = function()
			-- fusion.cl.ShowSpawnpoint = !fusion.cl.ShowSpawnpoint
			-- cookie.Set( "fusion_showspawn", booltonum(fusion.cl.ShowSpawnpoint) )
			
			fusion.cl.showlogpanel = !fusion.cl.showlogpanel
		end,
		GetName = function()
			if (fusion.cl.ShowTelepotter) then
				return "Hide Fusion Log"
			else
				return "Show Fusion Log"
			end
			
		end,
		Icon = Material("icon16/application_xp_terminal.png"),
		Colour = Color(150, 255, 255),
		Initialize = function()
			fusion.cl.showlogpanel = false
		end,
		IsActive = function() return fusion.cl.showlogpanel end
	},
	{
		OnClick = function()
			fusion.cl.ShowPlayerNames = !fusion.cl.ShowPlayerNames	
			cookie.Set( "fusion_showplayernames", booltonum(fusion.cl.ShowPlayerNames) )
		end,
		GetName = function()
			if fusion.cl.ShowPlayerNames then
				return "Hide Player Names"
			else
				return "Show Player Names"
			end
		end,
		Icon = Material("icon16/book_open.png"),
		Colour = Color(200, 200, 200),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_showplayernames" )
			if c then
				fusion.cl.ShowPlayerNames = numtobool(c)
			end
		end,
		IsActive = function() return fusion.cl.ShowPlayerNames end
	},
	{
		OnClick = function()
			fusion.cl.JumpOn = !fusion.cl.JumpOn
			cookie.Set( "fusion_superjump", booltonum(fusion.cl.JumpOn) )			
			sendJumpStatusToServer()
		end,
		GetName = function()
			if fusion.cl.JumpOn then
				return "Disable Super Jump"
			else
				return "Enable Super Jump"
			end
		end,
		Icon = Material("icon16/control_eject_blue.png"),
		Colour = Color(200, 200, 200),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_superjump" )
			if c then
				fusion.cl.JumpOn = numtobool(c)
				sendJumpStatusToServer()
			end
		end,
		IsActive = function() return fusion.cl.JumpOn end
	},
	{
		OnClick = function()
			fusion.cl.ShowRankColours = !fusion.cl.ShowRankColours
			cookie.Set( "fusion_showrankcolours", booltonum(fusion.cl.ShowRankColours) )
		end,
		GetName = function()
			if fusion.cl.ShowRankColours then
				return "Hide Ranks"
			else
				return "Display Ranks"
			end
		end,
		Icon = Material("icon16/database_table.png"),
		Colour = Color(200, 200, 200),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_showrankcolours" )
			if c then
				fusion.cl.ShowRankColours = numtobool(c)
			end
		end,
		IsActive = function() return fusion.cl.ShowRankColours end
	},
	{
		OnClick = function(x, y)
			fusion.cl.show_colourpicker = !fusion.cl.show_colourpicker
		end,
		GetName = function()
			
			if fusion.cl.show_colourpicker then
				return "Close Colour Picker"
			else
				return "Open Colour Picker"
			end
		end,
		Colour = Color(200, 200, 200),
		Icon = Material("icon16/color_wheel.png"),	
		Initialize = function()			
		end,
		IsActive = function() return fusion.cl.show_colourpicker end
	},
	{
		OnClick = function()
			local amount = 0.5
			
			if (fusion.cl.wave_speed < 1) then
				amount = 0.1
			end
			
			fusion.cl.wave_speed = fusion.cl.wave_speed + amount
			fusion.cl.wave_speed = math.Round(fusion.cl.wave_speed * 10) / 10
			
			if fusion.cl.wave_speed > 10 then
				fusion.cl.wave_speed = 0
			end			
			cookie.Set( "fusion_wave_speed", fusion.cl.wave_speed )
		end,		
		OnRightClick = function()
			local amount = 0.5
			
			if (fusion.cl.wave_speed <= 1) then
				amount = 0.1
			end
			
			fusion.cl.wave_speed = fusion.cl.wave_speed - amount		
			fusion.cl.wave_speed = math.Round(fusion.cl.wave_speed * 10) / 10
			
			if fusion.cl.wave_speed < 0 then
				fusion.cl.wave_speed = 10
			end			
			cookie.Set( "fusion_wave_speed", fusion.cl.wave_speed )
		end,		
		GetName = function()
			return "Wave Speed: " .. fusion.cl.wave_speed or 0
		end,
		Icon = Material("icon16/shape_flip_horizontal.png"),
		Colour = Color(50, 150, 50),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_wave_speed" )
			if c then
				fusion.cl.wave_speed = c
			end
		end
	},
	{
		OnClick = function()
			fusion.cl.wave_pattern = fusion.cl.wave_pattern + 0.01
			fusion.cl.wave_pattern = math.Round(fusion.cl.wave_pattern * 100) / 100
			
			if fusion.cl.wave_pattern > 1 then
				fusion.cl.wave_pattern = 0
			end			
			cookie.Set( "fusion_wave_pattern", fusion.cl.wave_pattern )
		end,		
		OnRightClick = function()
			fusion.cl.wave_pattern = fusion.cl.wave_pattern - 0.01			
			fusion.cl.wave_pattern = math.Round(fusion.cl.wave_pattern * 100) / 100
			
			if fusion.cl.wave_pattern < 0 then
				fusion.cl.wave_pattern = 1
			end			
			cookie.Set( "fusion_wave_pattern", fusion.cl.wave_pattern )
		end,		
		GetName = function()
			return "Wave Length: " .. fusion.cl.wave_pattern or 0
		end,
		Icon = Material("icon16/shape_square_edit.png"),
		Colour = Color(50, 150, 50),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_wave_pattern" )
			if c then
				fusion.cl.wave_pattern = c
			end
		end
	},
	{
		OnClick = function()
			
			fusion.cl.wave_style = fusion.cl.wave_style + 1
			
			if !styles[fusion.cl.wave_style] then
				fusion.cl.wave_style = 1
			end

			cookie.Set( "fusion_wave_style", fusion.cl.wave_style )
		end,		
		OnRightClick = function()
			fusion.cl.wave_style = fusion.cl.wave_style - 1
			
			if !styles[fusion.cl.wave_style] then
				fusion.cl.wave_style = #styles
			end
			
			cookie.Set( "fusion_wave_style", fusion.cl.wave_style )
		end,		
		GetName = function()
			return "Wave Style: " .. fusion.cl.wave_style or 0
		end,
		Icon = Material("icon16/shape_square_go.png"),
		Colour = Color(50, 150, 50),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_wave_style" )
			if c then
				fusion.cl.wave_style = c
			end
		end
	},
	{
		OnClick = function()
			
			fusion.cl.wave_alpha = fusion.cl.wave_alpha + 10
			
			if fusion.cl.wave_alpha > 250 then
				fusion.cl.wave_alpha = 0
			end

			cookie.Set( "fusion_wave_alpha", fusion.cl.wave_alpha )
		end,		
		OnRightClick = function()
			fusion.cl.wave_alpha = fusion.cl.wave_alpha - 10
			
			if fusion.cl.wave_alpha < 0 then
				fusion.cl.wave_alpha = 250
			end
			
			cookie.Set( "fusion_wave_alpha", fusion.cl.wave_alpha )
		end,		
		GetName = function()
			return "Wave Alpha: " .. fusion.cl.wave_alpha or 0
		end,
		Icon = Material("icon16/shape_ungroup.png"),
		Colour = Color(50, 150, 50),
		Initialize = function()
			local c = cookie.GetNumber( "fusion_wave_alpha" )
			if c then
				fusion.cl.wave_alpha = c
			end
		end		
	}
	-- {
		-- OnClick = function()
			-- RunConsoleCommand("fusion", "rate", "droke", "7")
		-- end,		
		-- OnRightClick = function()
			-- RunConsoleCommand("fusion", "rate", "droke", "7")
		-- end,		
		-- GetName = function()
			-- return ":)"
		-- end,
		-- Colour = Color(50, 50, 50),
		-- Initialize = function()
			
		-- end,
		-- Icon = Material("icon16/emoticon_smile.png")
	-- }	
}

fusion.cl.wave_speed = 0.5
fusion.cl.wave_pattern = 0.03
fusion.cl.wave_style = 7
fusion.cl.wave_alpha = 100

//fusion.cl.wave_speed + i*fusion.cl.wave_pattern

fusion.cl.SettingsPush = 0 
fusion.cl.SettingsMult = 0

function fusion.cl.SettingsPanel(x,y,w,h) // scoreboard x,y,w,h
	
	local time = RealTime()
	
	local myMult = fusion.cl.AlphaMult //* fusion.cl.SettingsMult
	
	-- local colourlist = fusion.cl.MenuColours

	local button_h = 30
	local button_w = 30
	
	-- local iconSize = 36
	
	local total = #settings
	local totalw = total * button_w
	
	draw.RoundedBox(0, x + w - totalw, y + h + 5, totalw, button_h, Color(50,50,50,150 * myMult))
	
	-- local x,y,barW,h = 0,ScrH()/2-(h+10)/2, 5, h + 10 + 3	

	local y,barW,h = y + h + 5, w, button_h
	
	local x = x + w - button_w
	
	-- if fusion.cl.ColourButtonOpen then
		-- fusion.cl.ColourPush = math.Clamp( fusion.cl.ColourPush + pushamount*fusion.cl.HUDSpeedMult, -40, pushdist )		
	-- else
		-- fusion.cl.ColourPush = math.Clamp( fusion.cl.ColourPush - pushamount*fusion.cl.HUDSpeedMult, -40, pushdist )
	-- end
	
	-- fusion.cl.TestColour = nil
	
	-- local push = fusion.cl.ColourPush
	
	
	
	local settings_w, settings_h = button_w + 2, h-10
	local settings_x = barW - ((1-myMult) * settings_w)	
	
	if myMult > 0 then
	
		if (fusion.cl.ShowTelepotter) then
			-- "network_telepotter"		
			-- fusion.SendTelepotterLocation()
			
			fusion.cl.TelepotterInterface()
			
			
		end
	
		-- local settings_x = x - button_w - 5
	
		-- if (fusion.myCoins and fusion.myCoins > 0) then
			-- draw.RoundedBox(0, settings_x, settings_y - 30, settings_w, 28, Color(50,50,50,255 * myMult))
			
			-- draw.DrawText("$" .. fusion.myCoins, "fancyfont", settings_x + 15 + math.max(0, math.sin(time*10%360))*15, settings_y + (25/2), Color( 255, 100, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		
		-- end
	
	
		
		
					
		-- draw.RoundedBox(0, settings_x,settings_y+4,settings_w,settings_h-9, Color(70,70,70,200))
		-- draw.RoundedBox(0, settings_x,settings_y+4,(settings_w) / 2,settings_h-9, Color(255,255,255,2))
		local button_x, button_y = x, y
		
		for i = 1, total do
			local setting_data = settings[total-i + 1]
			
			if setting_data then
				local x,y,w,h = button_x, button_y + 1, button_w, button_h				
				
								
				simpleIconButton2(setting_data.Icon, x, y, w, h, setting_data.OnClick, nil, setting_data.GetName(), Vector(x+(button_w), y + button_h/2 - 1), 255, setting_data.OnRightClick, true)
				
				//simpleButton(setting_data.GetName(), setting_data.Colour or Color(50,50,50,255 * myMult), x,y,w,h, setting_data.OnClick, nil, setting_data.OnRightClick)
				
			end
			
			button_x = button_x - button_w
		end		
	end
	
	
	
	-- draw.RoundedBox(0,-barW * (1-myMult),y,barW,h, fusion.cl.GetColour(255))
end

fusion.cl.VotePush = 0

function fusion.cl.VotePanel()	
	local active = fusion.cl.ActiveVote
	
	if !active or CurTime() > active.VoteTimer then
		fusion.cl.VotePush = math.Clamp( fusion.cl.VotePush - pushamount*fusion.cl.HUDSpeedMult, -40, 9999 )
	else
		local max = 7
		local total = math.Clamp( #active.Options, 1, max + 1 )
		h = total * (23 + 1) + 5	
		
		local w = 300
		local pushdist = w + 4
		
		fusion.cl.VotePush = math.Clamp( fusion.cl.VotePush + pushamount*fusion.cl.HUDSpeedMult, -40, pushdist )
		
		local y = ( ScrH() / 2 ) - h / 2
		
		fusion.cl.TestColour = nil
		
		local push = fusion.cl.VotePush
		if push > 0 then	
		
			local push = ScrW() - push

			surface.SetFont("fancyfont")
			local textW, textH = surface.GetTextSize(active.Question)
			
			local diff = (push+15+textW+5) - ScrW()
			
			local pull = 0
			
			if diff > 0 then
				pull = diff + 5
			end
			
			draw.DrawText( active.Question, "fancyfont", push + 15 - pull, y-26-4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			local settings_x,settings_y,settings_w,settings_h = push, y - 2, pushdist, h + 4
			draw.RoundedBox(0, settings_x,settings_y,settings_w,settings_h, Color(50,50,50,200))
			
			scoreboardRow(settings_x+4,settings_y+4,settings_w-8,settings_h-9, false, true)

			local button_x, button_y, button_w, button_h = settings_x + 5, settings_y + 4, settings_w - 13, 23
			
			local highest = false
			local total = 0
			
			for i = 1, max + 1 do				
				local setting_data = active.Options[i]
				
				if setting_data then
					local count = active.OptionCounts[i]
					total = total + count
					
					if !highest or count > active.OptionCounts[highest] then
						highest = i
					end
				
					local x,y,w,h = button_x + 1, button_y + 2, button_w, button_h-1 - 2
					simpleButton(setting_data, Color(50,50,50,255), x,y+1,w-21,h, function() LocalPlayer():ConCommand( "fusion vote " .. i ) end)
					draw.RoundedBox(0, x+w-21+2,y+1,18,h, Color(50,50,50,200))
					draw.DrawText( count, "Fusion", x+w-21+2 + 9,y+1 + 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )					
				end				
				button_y = button_y + button_h
			end	
			
			local status = markup.Parse("Open your scoreboard (hold tab) and click to vote.")
			
			if highest and active.OptionCounts[highest] > 0 then
				
				local perc = math.Round(active.OptionCounts[highest]/total * 100)
				
			
				if perc == 50 then
					status = markup.Parse("Open your scoreboard (hold tab) and click to vote.\nThe vote is currently tied.")	
				else							
					local primary_str = fusion.cl.ColorMarkupString(255)
					status = markup.Parse("Open your scoreboard (hold tab) and click to vote.\n'<color="..primary_str..">"..active.Options[highest].."</color>' is currently winning. ("..perc.."%)")
				end				
			end

			status:Draw(settings_x + 5, settings_y + settings_h + 5)
			
		end	
	
		local x,y,w,h = 0,ScrH()/2-(h+10)/2, 10, h + 10	
		local boxw = w/2
		x = ScrW() - boxw		

		if fusion.cl.ColourButtonOpen then
			boxw = w
		end
		
		draw.RoundedBox(0,x,y,boxw,h, fusion.cl.GetColour(255))
	
	end
end

function fusion.cl.ColourPicker() 
	if (fusion.cl.show_colourpicker) then
		if (fusion.cl.AlphaMult > 0.1) then
		
			local w, h = 244, 184
			local x, y = ScrW() / 2 - w/2, ScrH() / 2 - h/2 - 1
			
			-- draw.RoundedBox(4, x-1, y-1 - 20, w+2, h+2 + 2 + 40, Color(50, 50, 50, 255 * fusion.cl.AlphaMult))
			
			local resolution = 4
			
			local cols = 3
			local col_width = math.Round((w-4)/cols)
			
			local colour = fusion.cl.GetColour(255)
			local r, g, b = colour.r, colour.g, colour.b
			
			local mouseY = gui.MouseY()
			local diff = math.Clamp((mouseY - (y+1)) * 2, 0, 360) / 360	
			
			// r
				draw.RoundedBox(4, x, y - 20, col_width, h + 40, Color(50, 50, 50, 255 * fusion.cl.AlphaMult))
				for i = 0, h, resolution do
					local r = 255/h * i
					
					local myColour = Color(r,g,b)//HSVToColor((180-i) * 2, saturation, m)
					
					
					-- PrintTable(myColour)
					
					draw.RoundedBox(0, x + 1, y + 1 + i, col_width -2, resolution, Color(myColour.r, myColour.g, myColour.b, 255 * fusion.cl.AlphaMult))		
				end			
				if (mouseInRegion(x, y - 20, col_width, h + 40,45)) then
					if input.IsMouseDown(MOUSE_LEFT) then					
						-- fusion.cl.SetMenuColour(diff * 360, saturation, vibrance, true )	
						fusion.cl.SetMenuR(math.Round(diff * 255) , true)
						
						draw.SimpleText(math.Round(diff * 255), "dTimers", 5, 5, Color(255,255,255,255))					
					end
				end	

				local r_y = y + 1 + ((h+2) * (r/255))
				local center = x + 1 + (col_width - 2)/2
				
				draw.RoundedBox(0, x+2, r_y+1, col_width-4, 1, Color(0, 0, 0, 200 * fusion.cl.AlphaMult))
				draw.RoundedBox(0, x+2, r_y, col_width-4, 1, Color(255, 255, 255, 200 * fusion.cl.AlphaMult))
				
				draw.SimpleText("R", "SBNormal", center + 1, y - 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("R", "SBNormal", center, y - 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.SimpleText(r, "SBNormal", center + 1, y + h + 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(r, "SBNormal", center, y + h + 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			x = x + col_width + 2
			
			// g
				draw.RoundedBox(4, x, y - 20, col_width, h + 40, Color(50, 50, 50, 255 * fusion.cl.AlphaMult))
				
				for i = 0, h, resolution do
					local g = 255/h * i
				
					local myColour = Color(r,g,b)
					draw.RoundedBox(0, x + 1, y + 1 + i, col_width -2, resolution, Color(myColour.r, myColour.g, myColour.b, 255 * fusion.cl.AlphaMult))			
				end
				if (mouseInRegion(x, y - 20, col_width, h + 40,45)) then
					if input.IsMouseDown(MOUSE_LEFT) then									
						fusion.cl.SetMenuG(math.Round(diff * 255), true)		
						draw.SimpleText(math.Round(diff * 255), "dTimers", 5, 5, Color(255,255,255,255))					
					end
				end	

				local g_y = y + 1 + ((h+2) * (g/255))
				local center = x + 1 + (col_width - 2)/2
				
				draw.RoundedBox(0, x+2, g_y+1, col_width-4, 1, Color(0, 0, 0, 200 * fusion.cl.AlphaMult))
				draw.RoundedBox(0, x+2, g_y, col_width-4, 1, Color(255, 255, 255, 200 * fusion.cl.AlphaMult))
				
				
				
				draw.SimpleText("G", "SBNormal", center + 1, y - 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("G", "SBNormal", center, y - 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.SimpleText(g, "SBNormal", center + 1, y + h + 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(g, "SBNormal", center, y + h + 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			x = x + col_width + 2
			
			
			
			// b
				draw.RoundedBox(4, x, y - 20, col_width, h + 40, Color(50, 50, 50, 255 * fusion.cl.AlphaMult))			
				for i = 0, h, resolution do
					local b = 255/h * i
					local myColour = Color(r,g,b)
					draw.RoundedBox(0, x + 1, y + 1 + i, col_width -2, resolution, Color(myColour.r, myColour.g, myColour.b, 255 * fusion.cl.AlphaMult))	
				end		
				if (mouseInRegion(x, y - 20, col_width, h + 40,45)) then
					if input.IsMouseDown(MOUSE_LEFT) then												
						fusion.cl.SetMenuB(math.Round(diff * 255), true)							
						draw.SimpleText(math.Round(diff * 255), "dTimers", 5, 5, Color(255,255,255,255))					
					end
				end
				
				local b_y = y + 1 + ((h+2) * (b/255))
				local center = x + 1 + (col_width - 2)/2
				
				draw.RoundedBox(0, x+2, b_y+1, col_width-4, 1, Color(0, 0, 0, 200 * fusion.cl.AlphaMult))
				draw.RoundedBox(0, x+2, b_y, col_width-4, 1, Color(255, 255, 255, 200 * fusion.cl.AlphaMult))
				
				draw.SimpleText("B", "SBNormal", center + 1, y - 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("B", "SBNormal", center, y - 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				draw.SimpleText(b, "SBNormal", center + 1, y + h + 10 + 1, Color(0, 0, 0, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(b, "SBNormal", center, y + h + 10, Color(255, 255, 255, 255 * fusion.cl.AlphaMult), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			x = x + col_width + 2
		else
			-- print("asdads")
			fusion.cl.show_colourpicker = false
		end
	end
end

local function getSettings()
	fusion.cl.CacheColour()
	
	for i = 1, #settings do
		settings[i].Initialize()
	end
end

hook.Add("InitPostEntity", "GetFusionColour", function()
	getSettings()
end)

getSettings() 


/// OLD COLOUR PICKER


-- surface.SetDrawColor(Color(70,70,70,200))
		-- surface.DrawLine(push-1, settings_y + 5, push-1, settings_y + settings_h - 3)
	
		-- local start = fusion.cl.ColourScroll
		-- local finish = math.Clamp( fusion.cl.ColourScroll + max, 1, #colourlist )		
	
		-- local by = y + 3
		
		-- local somechopped = false
		
		-- for k = 1, #colourlist do		
			-- local v = colourlist[k]	
			
			-- if k >= start and k <= finish then		
					
				-- v.FadeIn = math.Clamp( ( v.FadeIn or 0 ) + 10, 0, 255 )				
				-- local fade = v.FadeIn
				-- local fadeplus = math.Clamp( fade + 50, 0, 255 )
				-- local x = math.Clamp( push, -40, pushdist )	
				
				-- local col = table.Copy(v.Colour or v.ColourFunc())
				
				-- col.a = fadeplus
				
				-- if k == fusion.cl.GMColour then
					-- draw.RoundedBox(0,x + 4-1 - 1, by-1 - 1, 20+2 + 2, 20+2 + 2, Color(255,255,255,255))	
				-- end
				
				-- draw.RoundedBox(0,x + 4-1, by-1, 20+2, 20+2, Color(50,50,50,160))
				-- draw.RoundedBox(0,x + 4, by, 20, 20, col)				
				
				-- if x >= pushdist then		
					-- if mouseInRegion(x + 5, by, 20, 20) then
						
						-- surface.SetFont("Fusion")
						-- local w,h = surface.GetTextSize(v.Name)
						
						-- local lx,ly,lw,lh = x + 23, by+1, w + 20 + 3, 19
						
						-- draw.RoundedBox(0, lx,ly,lw,lh, col)
						-- draw.RoundedBox(0, lx,ly,lw,lh, Color(50,50,50,160))
						-- draw.DrawText( v.Name, "Fusion", x + 26 + 10, by + ( 10 - 9 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						
						
						
						-- surface.SetDrawColor(col)
						-- surface.DrawLine(lx,ly,lx+lw,ly)
						-- surface.DrawLine(lx,ly+lh,lx+lw,ly+lh)
						-- surface.DrawLine(lx+lw,ly,lx+lw,ly+lh+1)
						
						-- if fusion.cl.IsMousePressed(MOUSE_LEFT) then
							-- fusion.cl.SetMenuColour( k, true )
						-- end
					-- end
				-- end	
				
				-- by = by + 25
			-- else
				-- v.FadeIn = 0
			-- end	
		-- end	


		// scroll
		-- local mx, my = gui.MouseX(), gui.MouseY()		
		-- local box_x, box_y, box_w, box_h = 0, y, 200, h
		
		-- if mouseInRegion(box_x, box_y, box_w, box_h) then
		
			-- if fusion.cl.IsMousePressed( 1 ) then
				-- fusion.cl.ColourScroll = math.Clamp( fusion.cl.ColourScroll - 1, 1, #colourlist - max )
			-- elseif fusion.cl.IsMousePressed( -1 ) then
				-- fusion.cl.ColourScroll = math.Clamp( fusion.cl.ColourScroll + 1, 1, #colourlist - max )
			-- end			
		-- end
		
		
		-- local x = math.Clamp( push, -40, pushdist )	
		-- if start > 1 then
			-- local lx,ly,lw,lh = x + 4, ScrH()/2-(h+10)/2 + 5, 20, 4
	
			-- for i = 0, 16, 6 do
				-- ly = ly - 6
				-- lw = 20 - i
				
				-- local diff = 20 - lw
				
				-- draw.RoundedBox(2, lx + diff/2,ly,lw,lh, Color(0,0,0,255))
				
				-- draw.RoundedBox(2, lx + diff/2 + 1,ly + 1,lw - 2,lh - 2, fusion.cl.GetColour(alpha))
			-- end			
			
		-- end
		
		-- if finish < #colourlist then
			-- local lx,ly,lw,lh = x + 4, ScrH()/2+(h+10)/2 - 9, 20, 4
	
			-- for i = 0, 16, 6 do
				-- ly = ly + 6
				-- lw = 20 - i
				
				-- local diff = 20 - lw
				
				-- draw.RoundedBox(2, lx + diff/2,ly,lw,lh, Color(0,0,0,255))
				
				-- draw.RoundedBox(2, lx + diff/2 + 1,ly + 1,lw - 2,lh - 2, fusion.cl.GetColour(alpha))
			-- end
		-- end