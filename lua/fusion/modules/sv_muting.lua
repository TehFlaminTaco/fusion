--[[ 
	Modules:
		Muting Commands
	
	Description:
		A collection of muting commands.
 ]]

fusion.commands["mute"] = {
	Name = "Mute",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Mutes a player's chat.",
	Message = "%s muted %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v.TextMute = true
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["unmute"] = {
	Name = "Unmute",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Unmutes a player's chat.",
	Message = "%s unmuted %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v.TextMute = false
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["gag"] = {
	Name = "Gag",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Mutes a player's voice.",
	Message = "%s gagged %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v.VoiceMute = true
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

fusion.commands["ungag"] = {
	Name = "Ungag",	
	Hierarchy = 60,
	Category = "punishment",
	Args = 1,
	Help = "Unmutes a player's voice.",
	Message = "%s ungagged %s",
	Function = function( ply, cmd, args )
		local message = fusion.commands[cmd].Message
		local name = args[1]
		
		local UniqueIDs = {}
		local players = fusion.sv.GetPlayers( ply, cmd, name )
		if players then
			for k,v in pairs( players ) do
				v.VoiceMute = false
				table.insert( UniqueIDs, fusion.PlayerMarkup( v ) )
			end
		end

		if fusion.sh.TableHasData( UniqueIDs ) then		
			local tarstring = string.Implode( ", ", UniqueIDs )
			local msg = string.format( message, fusion.PlayerMarkup( ply ), tarstring, arg1 )
			fusion.CMDMessage( msg, ply, cmd )			
		end	
	end	
}

if SERVER then

	hook.Add( "PlayerCanHearPlayersVoice", "fusion_MuteCheck", function( listener, speaker )
		if !GetConVar("sv_alltalk"):GetBool() then return false end
		return !speaker.VoiceMute
	end )
	
	hook.Add( "PlayerSay", "fusion_MuteCheck", function( ply, str )
		if ply.TextMute then
			return false
		end
	end )
end