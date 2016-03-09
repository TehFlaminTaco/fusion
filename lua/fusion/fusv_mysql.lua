require( "mysqloo" )

local queue = {}

local mysql_data = {}

local mysqlfile = "fusion/mysql.txt"

if file.Exists( mysqlfile, "DATA" ) then
	mysql_data = string.Explode( ",", file.Read( mysqlfile, "DATA" ) )

	print("Fusion: MySQL data file loaded.")
else
	mysql_data = {"address", "user", "password", "database"}
	file.Write(mysqlfile, string.Implode(",", mysql_data), "DATA")
end

local host = mysql_data[1]
local user = mysql_data[2]
local password = mysql_data[3]
local database = mysql_data[4]

-- PrintTable(mysql_data)
-- print(mysql_data[1], mysql_data[2], mysql_data[3], mysql_data[4])


local db = mysqloo.connect(host, user, password, database, 3306 )

function db:onConnected()
	// runQuery("CREATE TABLE IF NOT EXISTS Users(PersonID int,LastName varchar(255),FirstName varchar(255),Address varchar(255),City varchar(255))")

	for k, v in pairs( queue ) do
		runQuery( v[1], v[2] )
	end
	queue = {}

	print("Fusion: Connection to database successful!")

	fusion.sv.RetrieveBans()

	-- timer.Simple(5, function()
		-- for k,v in pairs(player.GetAll()) do
			-- fusion.sv.InitializePlayerData(v)
		-- end
	-- end)
end

function db:onConnectionFailed( err )

    print( "Fusion: Connection to database failed!" )
    print( "Fusion: Error - ", err )

end

db:connect()

fusion.DB = db

function runQuery(sql, callback)

	local q = db:query(sql)

	if !q then
		table.insert( queue, { sql, callback } )
		db:connect()
		print("Fusion: Query errored, nil query?")
		return
	end

	function q:onSuccess( data )
		if callback then
			if data and table.Count(data) > 0 then
				callback(data)
			else
				callback({})
			end
		end
	end

	function q:onError( err, sql )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then

			table.insert( queue, { sql, callback } )
			db:connect()
			return
		end

		print( "Fusion: Query Errored, error:", err, " sql: ", sql )
	end

	q:start()

	-- local data = sql.Query(query)
	-- local err = sql.LastError()

	-- if err then
		-- print( "Query Errored, error:", err, " sql: ", sql )
	-- else
		-- if data then
			-- PrintTable(data)
			-- callback(data)
		-- end

	-- end

end

-- runQuery("CREATE TABLE IF NOT EXISTS Users(ID varchar(64) PRIMARY KEY NOT NULL, name varchar(64), rank varchar(64), sudo varchar(64), title varchar(128), time varchar(128), ratings varchar(128), points int(11))")

-- runQuery("CREATE TABLE IF NOT EXISTS Fusion_Bans(ID varchar(64) PRIMARY KEY NOT NULL, Name varchar(64), Banner varchar(64), Description varchar(128), Unban varchar(128))")


function fusion.sv.SetData( ply, var, data )

	local id = tostring( ply:SteamID() )
	local evar = db:escape( var )
	local edata = db:escape( tostring(data) )

	-- print(evar)

	runQuery("INSERT INTO Users (ID, " .. evar .. ") VALUES ('"..id.."', '"..edata.."') ON DUPLICATE KEY UPDATE " .. evar .. " = '"..edata.."'")

end

function fusion.sv.RemoveData( ply, var )
	local id = tostring( ply:SteamID() )
	local evar = db:escape( var )

	runQuery("UPDATE Users SET " .. evar .. "='' WHERE ID='" .. id .. "'")
end

function fusion.sv.RetrieveData( ply, callback )
	local id = tostring( ply:SteamID() )
	id = db:escape( id )

	runQuery("SELECT * FROM Users WHERE ID = '" .. id .. "'", callback)
end

function fusion.sv.RetrieveBans()
	fusion.Bans = {}

	runQuery("SELECT * FROM Fusion_Bans", function(data)

		print(table.Count(data) .. " players banned.")

		for k,v in pairs( data ) do

			local id = v["ID"]
			local name = v["Name"]
			local banner = v["Banner"]
			local desc = v["Description"]
			local unban = tonumber(v["Unban"]) or 0

			fusion.Bans[id] = { Name = name, Banner = banner, Description = desc, Unban = unban }

			if (unban > 0) then
				local remaining = unban - os.date(os.time())
				if remaining < 0 then
					fusion.sv.RemoveBan(id)
				end
			end
		end

		fusion.sv.SendBans()
	end)

end

function fusion.sv.AddBan( id, name, banner, desc, unban )
	if !fusion.Bans then fusion.Bans = {} end
	if tonumber(unban) == nil then return end
	if string.find( id, "STEAM_%d:%d:%d+" ) then
		if tonumber( unban ) > 0 then
			unban = os.date( os.time() ) + tonumber( unban )
		else
			unban = 0
		end

		name = db:escape( name )
		banner = db:escape( banner )
		desc = db:escape( desc )
		fusion.Bans[id] = { Name = name, Banner = banner, Description = desc, Unban = unban }

		runQuery("INSERT INTO Fusion_Bans (ID, Name, Banner, Description, Unban) VALUES ('"..id.."', '"..name.."', '"..banner.."', '"..desc.."', '"..unban.."') ON DUPLICATE KEY UPDATE Unban = '"..unban.."'", function() fusion.sv.SendBans() print("Ban added.") end)
	end
end

function fusion.sv.RemoveBan( id )
	if !fusion.Bans then return end
	if string.find( id, "STEAM_%d:%d:%d+" ) then
		fusion.Bans[id] = nil
		runQuery("DELETE FROM Fusion_Bans WHERE ID = '" .. id .. "'", function() fusion.sv.SendBans() print("Ban deleted.") end)
	end
end