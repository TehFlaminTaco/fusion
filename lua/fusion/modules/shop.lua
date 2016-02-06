fusion.shop_item = {}

-- print("asdasddas")

fusion.points_name = "Coins"

if (SERVER) then
	hook.Add("ShowSpare1", "Shop", function(ply)
		ply:ConCommand("fusion", "shop")
		-- print(1)
	end)
end

titles = {}
table.insert(titles, {"", 0})
table.insert(titles, {"Scrublet", 0})
table.insert(titles, {"Jew", 0})
table.insert(titles, {"Coyboy", 0})
table.insert(titles, {"Little Kid", 0})
table.insert(titles, {"Dumb as a Post", 0})
table.insert(titles, {"Fuckchops", 0})
table.insert(titles, {"Letter from the Council", 0})
table.insert(titles, {"Zomb-man", 0})
table.insert(titles, {"Zomb-girl", 0})
table.insert(titles, {"L-Plater", 0})
table.insert(titles, {"P-Plater", 5})

table.insert(titles, {"Crabgoat", 5})
table.insert(titles, {"Combine Sniper", 5})
table.insert(titles, {"#freeesbos", 5})
table.insert(titles, {"charlie", 5})
table.insert(titles, {"The Grinch", 5})
table.insert(titles, {"Parents Suck", 5})
table.insert(titles, {"Dicksucker", 5})

table.insert(titles, {"hoglog", 10})
table.insert(titles, {"Okelet", 10})
table.insert(titles, {"Milky Spray", 10})
table.insert(titles, {"Keyboard & Mouse", 10})
table.insert(titles, {"WHY IS MY SCREEN RED??!!!", 10})

table.insert(titles, {"Sret", 15})
table.insert(titles, {"Car Centaur", 15})
table.insert(titles, {"Theatre Expert", 15})
table.insert(titles, {"Cheekiest Kunt", 15})
table.insert(titles, {"cumsostroke", 15})
table.insert(titles, {"Selena Xu", 15}) --Selena Xu, San Jose, California, March 29 1995
table.insert(titles, {"Bort", 15})
table.insert(titles, {"Christian", 15})
table.insert(titles, {"dark lird of the siht", 15})
table.insert(titles, {"Buildster", 15})
table.insert(titles, {"Nikon Coolpix L820 16MP L-820 Digital Camera", 15})
table.insert(titles, {"Toking Tom", 15})
table.insert(titles, {"shitnibbles", 15})

table.insert(titles, {"nonfree software", 20})
table.insert(titles, {"hold me", 20})
table.insert(titles, {"feel my silence", 20})
table.insert(titles, {"Big Name No Blanket", 20})
table.insert(titles, {"kawaii like hawaii", 20})
table.insert(titles, {"admin@good-mechs.info", 20})
table.insert(titles, {"Joan C and the C Serpents World Tour", 20})
table.insert(titles, {"Stop, drop and install Gentoo.", 20})
table.insert(titles, {"Johnny B. Goob", 20})
table.insert(titles, {"Gratuitous Bass Battles", 20})
table.insert(titles, {"ninemsn.good.info.good/mechs.tga", 20})
table.insert(titles, {"oh so weed cheggs wy cheggs wy", 20})
table.insert(titles, {"8========D~~~~SEMEN~LMOA~~~~~", 20})
table.insert(titles, {"@iancoult i lov u", 20})
table.insert(titles, {"the baller from gawler", 20})
table.insert(titles, {"#auspol #qanda", 20})
table.insert(titles, {"user disconnected from your channel", 20})

table.insert(titles, {"Form over Function", 30})
table.insert(titles, {"Function over Form", 30})
table.insert(titles, {"The sky calls to us.", 30})
table.insert(titles, {"In an isolated system, entropy can only increase.", 30})
table.insert(titles, {"Science investigates religion interprets.", 30})
table.insert(titles, {"Science does not know its debt to imagination.", 30})
table.insert(titles, {"Fuck science!", 30})
table.insert(titles, {"Ignorant", 30})

table.insert(titles, {"Smelly Fiend", 45})
table.insert(titles, {"Krazy Kat :3", 45})
table.insert(titles, {"Sly Snake :S", 45})
table.insert(titles, {"Rabadoodle", 45})
table.insert(titles, {"Captain Teemo on duty!", 45})
table.insert(titles, {"Gay Gorilla :P", 45})
table.insert(titles, {"Wanted Dead or Alive", 45})
table.insert(titles, {"#freefla", 45})
table.insert(titles, {"Droko Malphoy", 45})
table.insert(titles, {"Gay Electrician", 45})
table.insert(titles, {"Euphoric Atheist", 45})
table.insert(titles, {"Dragon", 45})
table.insert(titles, {"Guest", 45})
table.insert(titles, {"ratemyqueef.co.nz", 45})
table.insert(titles, {"banned from mufasa from banned", 45})

table.insert(titles, {"16 metric tonnes of hot grandma love", 60})
table.insert(titles, {"Dishwasher", 60})
table.insert(titles, {"emo", 60})
table.insert(titles, {"Straight Edge", 60})
table.insert(titles, {"Foot Cancer", 60})
table.insert(titles, {"Dual Monitor Master Race", 60})
table.insert(titles, {"Not", 60})
table.insert(titles, {"Cadet", 60})
table.insert(titles, {"Seaman", 60})
table.insert(titles, {"Private", 60})

table.insert(titles, {"arseholed caravan", 60})
table.insert(titles, {"super penis bros", 60})
table.insert(titles, {"pull me", 60})
table.insert(titles, {"my little choady", 60})
table.insert(titles, {"Bandalf", 60})
table.insert(titles, {"Bill Gapes", 60})
table.insert(titles, {"Paul Blart: Mall Cop", 60})
table.insert(titles, {"Grape Ape", 60})

table.insert(titles, {"balla balla", 80})
table.insert(titles, {"GAY_WEED_DAD_69", 80})
table.insert(titles, {"y eror", 80})
table.insert(titles, {"/ban <notself> 0 dont laugh", 80})
table.insert(titles, {"Inspector Rex", 80})

table.insert(titles, {"Power Cord", 90})
table.insert(titles, {"fyoozion", 90})
table.insert(titles, {"Metallic Dogman", 90})
table.insert(titles, {"Zipper", 90})


// susslets
table.insert(titles, {"Fucking King CUnt", 110})
table.insert(titles, {"Useless Centrelink", 110})
table.insert(titles, {"rip suss", 110})
table.insert(titles, {"dragon dildo", 110})
table.insert(titles, {"wobb is a homo", 110})
table.insert(titles, {"cuntagonist", 110})
table.insert(titles, {"Elite Hacker 2000", 110})
table.insert(titles, {"WHAT FUCK", 110})
table.insert(titles, {"M 4! fan club", 110})
table.insert(titles, {"trashboolet", 110})

// crona
table.insert(titles, {"queeftard", 115})
table.insert(titles, {"pleb overlord", 115})
table.insert(titles, {"notevenhuman", 115})
table.insert(titles, {"absolute fucking dripfed", 115})
table.insert(titles, {"hatchetcock", 115})
table.insert(titles, {"hammered testicles", 115})
table.insert(titles, {"detached labia", 115})
table.insert(titles, {"jihad for dummies", 115})
table.insert(titles, {"do it yourself noose", 115})
table.insert(titles, {"tardnado", 115})
table.insert(titles, {"taser enthusiast", 115})
table.insert(titles, {"raging alcoholic sociopath", 115})
table.insert(titles, {"[INSERT TITLE HERE]", 115})







table.insert(titles, {"itsagudwinmill", 135})
table.insert(titles, {"#ishamech", 135})
table.insert(titles, {"Thimble", 135})
table.insert(titles, {"Cool Guy", 135})
table.insert(titles, {"queefmeister", 135})
table.insert(titles, {"85 night elf rogue", 135})
table.insert(titles, {"Half-Life 3 Confirmed", 135})

table.insert(titles, {"Help!", 180})
table.insert(titles, {"Ob-La-Di, Ob-La-Da", 180})
table.insert(titles, {"Rocky Raccoon", 180})
table.insert(titles, {"Norwegian Wood", 180})
table.insert(titles, {"Strawberry Fields", 180})
table.insert(titles, {"Something", 180})
table.insert(titles, {"Penny Lane", 180})
table.insert(titles, {"Love Me Do", 180})
table.insert(titles, {"Eleanor Rigby", 180})
table.insert(titles, {"Hey Jude", 180})
table.insert(titles, {"I Am The Walrus", 180})
table.insert(titles, {"Don't Let Me Down", 180})
table.insert(titles, {"The Night Before", 180})
table.insert(titles, {"I Feel Fine", 180})

table.insert(titles, {"M O I S T ;", 210})
table.insert(titles, {"Big Tonga Love Feel", 210})
table.insert(titles, {"{europa}", 210})
table.insert(titles, {"You Only Live Poonse", 210})
table.insert(titles, {"alt.binaries.anime.toddlercon.fisting", 210})
table.insert(titles, {"[[[[[[[Hypersex]]]]]]]", 210})

// crona 2
table.insert(titles, {"Zen terrorist", 275})
table.insert(titles, {"Vortigaunt suicide bomber", 275})
table.insert(titles, {"I'm having fun with this", 275})
table.insert(titles, {"18 litres of human", 275})
table.insert(titles, {"1 x bulk shipment: minced babies", 275})
table.insert(titles, {"glory hole attendant", 275})
table.insert(titles, {"would suck for dupes", 275})
table.insert(titles, {"family friendly gas chamber", 275})
table.insert(titles, {"embarrassing bodies: the musical", 275})
table.insert(titles, {"218lb of stinking tumblrina", 275})
table.insert(titles, {"combed nutsack", 275})
table.insert(titles, {"young, tight, and neckbearded", 275})
table.insert(titles, {"Eyesocket Vaginas", 275})
table.insert(titles, {"Pile of Octogenarians", 275})
table.insert(titles, {"wallet inspector", 275})
table.insert(titles, {"ISIS space program", 275})
table.insert(titles, {"SCRAMJET diarrhea", 275})
table.insert(titles, {"Jewskin wedding dress", 275})
table.insert(titles, {"snapped cock", 275})
table.insert(titles, {"12 inch sub with newborn", 275})
table.insert(titles, {"someone teach me to weld", 275})
table.insert(titles, {"full automatic queef rifle", 275})
table.insert(titles, {"buffet rapist", 275})
table.insert(titles, {"FUPA TROOPER", 275})
table.insert(titles, {"Clover", 275})
table.insert(titles, {"saggy tits", 275})
table.insert(titles, {"hot in a hijab", 275})
table.insert(titles, {"not using TS?", 275})
table.insert(titles, {"Teen angst has leveled up!", 275})
table.insert(titles, {"Extra chunky preused curry", 275})
table.insert(titles, {"cousin fucker", 275})
table.insert(titles, {"literal cum dumpster", 275})
table.insert(titles, {"festering cooch", 275})
table.insert(titles, {"barbed wire condom", 275})
table.insert(titles, {"pepper spray lube", 275})
table.insert(titles, {"Oozing twatmouth", 275})
table.insert(titles, {"fluffy is a fuckwit", 275})
table.insert(titles, {"IT WILL BE DONE", 275})
table.insert(titles, {"cumblush", 275})
table.insert(titles, {"gaping eye socket", 275})
table.insert(titles, {"faaaaaaantastic", 275})
table.insert(titles, {"double ended vibrating shotgun", 275})
table.insert(titles, {"dora the eviscerated explorer", 275})
table.insert(titles, {"minced teletubbies", 275})
table.insert(titles, {"butchered chipmunks", 275})
table.insert(titles, {"Headmistress", 275})
table.insert(titles, {"330ml can of sumo juice", 275})



table.insert(titles, {"Science!", 280})
table.insert(titles, {"Reckless", 280})
table.insert(titles, {"Heckers", 280})
table.insert(titles, {"Brave", 280})
table.insert(titles, {"Big Fella", 280})
table.insert(titles, {"Saint IGNUcius", 280})

// flux
table.insert(titles, {"Dirty Fucking Wombat", 275})

table.insert(titles, {"barkhebarjela", 345})
table.insert(titles, {"Do you even G'Mod?", 345})
table.insert(titles, {"L2E2", 345})

-- table.insert(titles, {"", 345})
-- table.insert(titles, {"", 345})

table.insert(titles, {"Sleeping Sloth", 405})
table.insert(titles, {"Supreme Commander of the Asgard Fleet", 405})
table.insert(titles, {"Disciple of Droke", 405})
table.insert(titles, {"Legend", 405})
table.insert(titles, {"mufasa mufasa mufasa", 405})

//crona 3
table.insert(titles, {"Star wars episode X: Luke gets his groove back", 410})
table.insert(titles, {"Slayer of framerate", 410})
table.insert(titles, {"Pygmy love queen", 410})
table.insert(titles, {"How to bury yourself Pt.2", 410})
table.insert(titles, {"Invisicock", 410})
table.insert(titles, {"Dick's dishonorable discharge", 410})
table.insert(titles, {"Making a human out of pubes", 410})
table.insert(titles, {"How do I turn off the weather", 410})
table.insert(titles, {"Whats wiremod", 410})
table.insert(titles, {"jesus christ is my nigga", 410})
table.insert(titles, {"creative suicide part 14, pulling out your own spine", 410})
table.insert(titles, {"how do I spell CIA", 410})
table.insert(titles, {"Whats the beatles?", 410})
table.insert(titles, {"who do I talk to for a facebook account?", 410})
table.insert(titles, {"ballsack slingshot", 410})





table.insert(titles, {"Billy Beugson", 420})
table.insert(titles, {"420blzitfgt", 420})
table.insert(titles, {"anal_clench_420", 420})
table.insert(titles, {"420", 420})
table.insert(titles, {"jet lighter enthusiast", 420})
table.insert(titles, {"bonglord", 420})
table.insert(titles, {"I prefer pipes personally, much harsher.", 420})
table.insert(titles, {"hey mate mind if i have a cone?", 420})
table.insert(titles, {"hemp wick hemp oil hemp hemp hemp hemp hemp pants", 420})





table.insert(titles, {"Dirt Fetishists of Wartime Poland", 450})
table.insert(titles, {"Unna bro, unna.", 450})
table.insert(titles, {"I e v t . o", 450})
table.insert(titles, {"s&box", 450})
table.insert(titles, {"Slashban: The Movie", 450})
table.insert(titles, {"<inervate bhoperz>", 450})
table.insert(titles, {"Corn! The Musical", 450})
table.insert(titles, {"We Don't Go To Drokenholm", 450})
table.insert(titles, {"Jake Harrison's Pro Lacrosse 2014", 450})
table.insert(titles, {"Inervation Urination Station", 450})
table.insert(titles, {"Slut Slut Revolution", 450})

table.insert(titles, {"cat /dev/sda1 | grep bad_granny", 600})
table.insert(titles, {"Stick this in your fusebox!", 600})

table.insert(titles, {"Satin Paint", 666})

table.insert(titles, {"King", 700})
table.insert(titles, {"Lord", 700})
table.insert(titles, {"Gaped", 700})
table.insert(titles, {"Zapper", 700})
table.insert(titles, {"One Direction Fan", 700})

table.insert(titles, {"Mufasa Flies by Flapping His Loincloth", 800})

table.insert(titles, {"Accidentally the Prolapse", 800})

table.insert(titles, {"Fuck off Clarence", 1000})
table.insert(titles, {"Thumbscrewed Cone", 1000})
table.insert(titles, {"yeah nah yeah nah yeah", 1000})
table.insert(titles, {"Absolute Unit", 1000})

table.insert(titles, {"Faggot", 1215})
table.insert(titles, {"Alien", 1215})
table.insert(titles, {"Good", 1215})
table.insert(titles, {"Water Bottle", 1215})
table.insert(titles, {"The only friendly in Cherno", 1215})

table.insert(titles, {"The Union Jack", 1500})
table.insert(titles, {"Spinner", 1500})

table.insert(titles, {"YouTube Superstar", 1700})

table.insert(titles, {"halloumi toast", 2000})

table.insert(titles, {"Weird and Angry", 3000})

table.insert(titles, {"gmod gmod", 5000})
table.insert(titles, {"Epic Sicklord", 5000})
table.insert(titles, {"Total Badass", 5000})


table.insert(titles, {"Goog", 10000})
table.insert(titles, {"Develooper", 10000})
table.insert(titles, {"Droke... IN SPACE!!!", 10000})


print(#titles .. " titles.")

for i = 1, #titles do
	local title = titles[i]
	table.insert(fusion.shop_item, {
		Name = title[1], 
		Price = math.Round(title[2]), 
		Category = "titles",
		Title = true
	})
end

fusion.rankItems = {}

table.insert(fusion.shop_item, { // 10
	Name = "Human",
	Price = 120,
	Category = "ranks",
	Rank = "shop0",
	Description = "Trustworthy type, you haven't been banned, well done."	
})
local tbl = fusion.shop_item[#fusion.shop_item]
fusion.rankItems[tbl.Rank] = tbl

table.insert(fusion.shop_item, { // 20
	Name = "Regular",
	Price = 480,
	Category = "ranks",
	Rank = "shop1",
	Description = "You've actually become human, good for you."
})
local tbl = fusion.shop_item[#fusion.shop_item]
fusion.rankItems[tbl.Rank] = tbl

table.insert(fusion.shop_item, { // 30
	Name = "Idler",
	Price = 2880,
	Category = "ranks",
	Rank = "shop2",
	Description = "You actually managed to last this long, good for you. Have some more stuff!"
})
local tbl = fusion.shop_item[#fusion.shop_item]
fusion.rankItems[tbl.Rank] = tbl

table.insert(fusion.shop_item, { // 40
	Name = "Legend",
	Price = 8640,
	Category = "ranks",
	Rank = "shop3",
	Description = "You finally made it cowboy."
})
local tbl = fusion.shop_item[#fusion.shop_item]
fusion.rankItems[tbl.Rank] = tbl

table.insert(fusion.shop_item, {
	Name = "Bloody Legend",
	Price = 25920,
	Category = "ranks",
	Rank = "shop4",
	Description = "You finally made it super cowboy. You gain VIP status and can access VIP only commands."
})
local tbl = fusion.shop_item[#fusion.shop_item]
fusion.rankItems[tbl.Rank] = tbl

-- table.insert(fusion.shop_item, {
	-- Name = "Enable God Mode",
	-- Price = 10,
	-- Category = "other",
	-- DoFunc = function(ply)
		-- ply:GodEnable()
	-- end
-- })

table.insert(fusion.shop_item, {
	Name = "(Emote) Dance",
	Price = 30,
	Category = "other",
	DoFunc = function(ply)
		ply:SendLua("RunConsoleCommand('act', 'dance')")
	end
})

table.insert(fusion.shop_item, {
	Name = "(Emote) Salute",
	Price = 30,
	Category = "other",
	DoFunc = function(ply)
		ply:SendLua("RunConsoleCommand('act', 'salute')")
	end
})

table.insert(fusion.shop_item, {
	Name = "(Emote) Wave",
	Price = 30,
	Category = "other",
	DoFunc = function(ply)
		ply:SendLua("RunConsoleCommand('act', 'wave')")
	end
})

table.insert(fusion.shop_item, {
	Name = "(Emote) Cheer",
	Price = 30,
	Category = "other",
	DoFunc = function(ply)
		ply:SendLua("RunConsoleCommand('act', 'cheer')")
	end
})

table.insert(fusion.shop_item, {
	Name = "Jail me!",
	Price = 50,
	Category = "other",
	DoFunc = function(ply)
		if ply.Jailed then
			ply:PrintMessage(HUD_PRINTTALK, "You were already jailed chief, but i'll take that coin of yours.")
		else
			fusion.commands["jail"].Function(NULL, "jail", {ply:UniqueID()})
			ply:PrintMessage(HUD_PRINTTALK, "Why would you do this?")
		end
	
		
	end
})

table.insert(fusion.shop_item, {
	Name = "Super Devil Juice",
	Price = 100,
	Category = "other",
	DoFunc = function(ply)
		//ply:SetRunSpeed(5000)
		ply:SetMoveType(MOVETYPE_FLY)
		ply:SetHealth(666)
		ply:SetMaxHealth(666)	
		ply:PrintMessage(HUD_PRINTTALK, "GIVE ME SOME OF THAT YOU LITTLE GIRL!")
		
		-- ply:EmitSound("fusion/deviljuice.ogg")
		
		-- timer.Simple(60, function()
			-- fusion.sv.RespawnInPlace(ply)
		-- end)
	end
})

fusion.hookItems = {}

table.insert(fusion.shop_item, {
	Name = "Default",	
	Price = 0,
	Category = "hooks",
	NoBroadcast = true,
	DoFunc = function(ply)
		fusion.setHookType(ply, "default")
	end
})
fusion.hookItems["default"] = fusion.shop_item[#fusion.shop_item]

table.insert(fusion.shop_item, {
	Name = "Prongs",
	Price = 100,
	SellPrice = 100,
	Category = "hooks",
	DoFunc = function(ply)
		fusion.setHookType(ply, "prongs")
	end
})
fusion.hookItems["prongs"] = fusion.shop_item[#fusion.shop_item]

table.insert(fusion.shop_item, {
	Name = "Cone",
	Price = 350,
	SellPrice = 350,
	Category = "hooks",
	DoFunc = function(ply)
		fusion.setHookType(ply, "cone")
	end,
	Description = "Pass us the billy bro!"
})
fusion.hookItems["cone"] = fusion.shop_item[#fusion.shop_item]

-- table.insert(fusion.shop_item, {
	-- Name = "Lamp",
	-- Price = 600,
	-- SellPrice = 600,
	-- Category = "hooks",
	-- DoFunc = function(ply)
		-- fusion.setHookType(ply, "lamp")
	-- end,
	-- Description = "Light in an ever darkening world!"
-- })
-- fusion.hookItems["lamp"] = fusion.shop_item[#fusion.shop_item]

table.insert(fusion.shop_item, {
	Name = "Harpoons",
	Price = 1000,
	SellPrice = 1000,
	Category = "hooks",
	DoFunc = function(ply)
		fusion.setHookType(ply, "harpoons")
	end
})
fusion.hookItems["harpoons"] = fusion.shop_item[#fusion.shop_item]

table.insert(fusion.shop_item, {
	Name = "Plasma Web",
	Price = 3000,
	SellPrice = 3000,
	Category = "hooks",
	DoFunc = function(ply)
		fusion.setHookType(ply, "plasma_web")
	end,
	Description = "Contribute to global warming in style with this exotic plasma hook."
})
fusion.hookItems["plasma_web"] = fusion.shop_item[#fusion.shop_item]

table.insert(fusion.shop_item, {
	Name = "Plasma Web the Greater",
	Price = 10000,
	Category = "hooks",
	DoFunc = function(ply)
		fusion.setHookType(ply, "plasma_web2")
	end,
	Description = "Upgrade your plasma_web to contribute even more to global warming, by adding more hooklets!"
})
fusion.hookItems["plasma_web2"] = fusion.shop_item[#fusion.shop_item]

 


local messages = {
	"Fuck me, %s is a fucking top cunt.",
	"%s is a legend.",
	"Coolest guy on the server = %s",
	"If i'm honest, %s is a top bloke.",
	
	"%s got ripped off!",
	"%s just wasted some coin.",
}

table.insert(fusion.shop_item, {
	Name = "Tell everyone how great you are",
	Price = 100,
	Category = "other",
	NoBroadcast = true,
	DoFunc = function(ply)
		fusion.GlobalMessage(Format(table.Random(messages), fusion.PlayerMarkup(ply)))
	end
})

table.insert(fusion.shop_item, {
	Name = "Ask everyone how great you are",
	Price = 200,
	Category = "other",
	NoBroadcast = true,
	DoFunc = function(ply)
		fusion.commands["dovote"].Function(NULL, "dovote", {"Is " .. ply:Name() .. " great?"})
	end
})

table.insert(fusion.shop_item, {
	Name = "Dance Party!",
	Price = 1000,
	Category = "other",
	DoFunc = function(ply)
		for k,v in pairs(player.GetAll()) do
			v:SendLua("RunConsoleCommand('act', 'dance')")
		end
	end
})

table.insert(fusion.shop_item, {
	Name = "Unjail me!",
	Price = 10000,
	Category = "other",
	DoFunc = function(ply)
		if !ply.Jailed then
			ply:PrintMessage(HUD_PRINTTALK, "You weren't jailed chief, but i'll take that coin of yours.")
		else
			fusion.commands["unjail"].Function(NULL, "unjail", {ply:UniqueID()})
			ply:PrintMessage(HUD_PRINTTALK, "Was that REALLY worth it?")
		end		
	end
})

-- table.insert(fusion.shop_item, {
	-- Name = "Enable Good Mode",
	-- Price = 10,
	-- Category = "hooks",
	-- DoFunc = function(ply)
		-- ply:GodEnable()
	-- end
-- })




-- table.SortByMember(fusion.shop_item, "Price", function(a, b) return a > b end)

fusion.commands["buyitem"] = {
	Name = "Buy Item",	
	Hierarchy = 0,
	Category = "fusion shop",
	Args = 1,
	Help = "Buys an item.",
	Message = "You purchased the %s #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local item = tonumber(args[1])
		
		if !item then
			fusion.Message( ply, "No item was given" )	
			return
		end
		
		local data = fusion.shop_item[item]
		
		if !data then 
			fusion.Message( ply, "That item does not exist" )	
			return
		end
		
		local price = data.Price or 0
		
		if (ply.HookType and data.Category == "hooks") then
			local hooktype = ply.HookType
			local hookdata = fusion.hookItems[hooktype]
			
			if (hookdata and hookdata.Price) then
				price = math.max(0, price - hookdata.Price)
			end							
		end
		
		if (ply.Rank and data.Category == "ranks") then
			local ranktype = ply.Rank
			local itemdata = fusion.rankItems[ranktype]
			
			if (itemdata and itemdata.Price) then
				price = math.max(0, price - itemdata.Price)
			end	
		end
		
		if (fusion.sv.getPoints(ply) < price) then
			fusion.Message( ply, "You need more #{" .. fusion.points_name .. "}# to make that purchase" )	
			return
		end
			
		local cat = ""
			
		if data.Title then
			cat = "title"
			if (ply.fTitle == data.Name) then
				fusion.Message(ply, "Your title is already set to #{" .. data.Name .. "}#")
				return
			end
			
			fusion.sv.SetTitle( ply, data.Name )
			local msg = fusion.PlayerMarkup(ply) .. " has purchased the title #{" .. data.Name .. "}#"	 
			
			for k,v in pairs(player.GetAll()) do
				if v != ply then
					if !data.NoBroadcast then fusion.Message(v, msg) end
				end
			end
			
		elseif data.Rank then
			cat = "rank"
			
			fusion.sv.InitializeRank(ply, data.Rank, true)
			local msg = fusion.PlayerMarkup(ply) .. " has purchased the rank of " .. fusion.TeamMarkup(data.Rank)
			for k,v in pairs(player.GetAll()) do
				if v != ply then
					if !data.NoBroadcast then fusion.Message(v, msg) end
				end
			end
			
		elseif data.DoFunc then
			data.DoFunc(ply)
			
			cat = "item"		
			
			local msg = fusion.PlayerMarkup(ply) .. " has purchased the item #{" .. data.Name .. "}#"
			
			if !data.NoBroadcast then
				for k,v in pairs(player.GetAll()) do
					if v != ply then
						fusion.Message(v, msg)
					end
				end
			end
		end
		
		fusion.sv.setPoints(ply, math.max(0,fusion.sv.getPoints(ply) - price), true)
			
		local msg = string.format(message, cat, data.Name)
		if !data.NoBroadcast then fusion.Message(ply, msg) end
		
	end	
}

fusion.commands["givecoins"] = {
	Name = "Give Coins",	
	Hierarchy = 0,
	Category = "fusion shop",
	Args = 2,
	Ignore = true,
	//Condition = function(ply, v) print(v.Hierarchy) print(ply.Hierarchy) return !(ply.Hierarchy and !v.Hierarchy and (v.Hierarchy < ply.Hierarchy)) end,
	Help = "Gives a player X number of coins.",
	NotSelf = true,
	Message = "%s gave #{%s}# coins to %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local points = tonumber(args[2])
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		
		if players then
		
		
			if !points then
				fusion.Message( ply, "You did not enter any coin amount." )	
				return
			end	

			local total = points * #players	
			
			if total < 0 then
				fusion.Message( ply, "Coin amount must be greater than #{0}#." )	
				return
			end
			
			if total > 100000 then
				fusion.Message( ply, "Coin amount must not be greater than #{100000}#." )	
				return
			end
			
			if total > fusion.sv.getPoints(ply) then
				fusion.Message( ply, "Come back when you got more dollar." )	
				return
			end	
			
			fusion.sv.setPoints(ply, fusion.sv.getPoints(ply) - total, true)
			for k,v in pairs( players ) do

				
				fusion.sv.setPoints(v, fusion.sv.getPoints(v) + points, true)
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), points, tarstring )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

if SERVER then
fusion.commands["setcoins"] = {
	Name = "Set Coins",	
	Hierarchy = 80,
	Category = "fusion shop",
	Args = 2,
	Condition = function(ply, v) print(v.Hierarchy) print(ply.Hierarchy) return !(ply.Hierarchy and !v.Hierarchy and (v.Hierarchy < ply.Hierarchy)) end,
	Help = "Set a player's coins.",
	Message = "%s set the coins of %s to #{%s}#",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		local points = tonumber(args[2])
				
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		
		if players then
		
			if !points then
				fusion.Message( ply, "You did not enter any coin amount." )	
				return
			end	
			
			if points < 0 then
				fusion.Message( ply, "Coin amount must be greater than #{0}#." )	
				return
			end
			
			if points > 100000 then
				fusion.Message( ply, "Coin amount must not be greater than #{100000}#." )	
				return
			end
			
			for k,v in pairs( players ) do
				fusion.sv.setPoints(v, points, true)
				
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end
		
		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, points)
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}
end
