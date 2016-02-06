
// FUSION - by Droke

// Global Tables
fusion = {}
fusion.cl = {}
fusion.sv = {}
fusion.sh = {}
fusion.commands = {}
fusion.module = {}
fusion.version = 5.1



// Fusion Downloads
AddCSLuaFile( "fu_init.lua" )

local framework = file.Find( "fusion/*.lua", "LUA" )
local commands = file.Find( "fusion/commands/*.lua", "LUA" )
local modules = file.Find( "fusion/modules/*.lua", "LUA" )
local menu = file.Find( "fusion/vgui/*.lua", "LUA" )

print( "[Fusion] version " .. fusion.version .. " loading." )

for k,v in pairs(framework) do
	local fi = "fusion/" .. v
	-- print( "[Fusion] initializing framework: " .. v )
	
	if string.Left( v, 5 ) == "fusv_" then 
		include( fi )
	elseif string.Left( v, 5 ) == "fucl_" then 
		AddCSLuaFile( fi )
		if CLIENT then
			include( fi )
		end		
	else	
		AddCSLuaFile( fi )
		include( fi )
	end
end

for k,v in pairs(menu) do
	local fi = "fusion/vgui/" .. v
	AddCSLuaFile( fi )
	if CLIENT then
		include( fi )
	end
end
	
for k,v in pairs(modules) do
	local fi = "fusion/modules/" .. v
	
	if string.Left( v, 3 ) == "sv_" then 
		include( fi )
	elseif string.Left( v, 3 ) == "cl_" then 
		AddCSLuaFile( fi )
		if CLIENT then
			include( fi )
		end
	else	
		AddCSLuaFile( fi )
		include( fi )
	end
end

function AddDir(dir)
	local files, folders = file.Find(dir.."/*", "GAME")
	
	PrintTable(folders)
	for k,v in pairs(folders) do
		AddDir(dir.."/"..v)
	end
 
	for k,v in pairs(files) do
		resource.AddFile(dir.."/"..v)
	end
end

AddDir( "materials/fusion" )
-- AddDir( "sound/fusion" )

if SERVER then
	resource.AddWorkshop( "160250458" ) // wire
	// resource.AddWorkshop( "163806212" ) // adv dupe
	// resource.AddWorkshop( "104815552" ) // smartsnap
	// resource.AddWorkshop( "173482196" ) // sprops
end