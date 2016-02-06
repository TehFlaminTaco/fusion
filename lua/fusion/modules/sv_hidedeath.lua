--[[ 
	Modules:
		Hide Death Notification Commands
	
	Description:
		
 ]]
 
hook.Add("PlayerDeath", "hide", function( ply, i, k ) fusion.sv.DoDeath( ply, i, k )  return false end )
hook.Add("OnNPCKilled", "hide", function( npc ) return false end )