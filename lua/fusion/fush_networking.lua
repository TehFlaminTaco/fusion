if SERVER then

	util.AddNetworkString("fush_net_var")

	function fusion.NetworkVar(ply, var, val)
		net.Start("fush_net_var")
		net.WriteString(var)
		net.WriteString(val)
		net.Send(ply)
	end

else
	fusion.net_vars = {}
	net.Receive( "fush_net_var", function( data )
		
		local var, vel = net.ReadString(), net.ReadString()
		
		fusion.net_vars[var] = vel
		
	end)
end

print("FUSH_NETWORKING INITIALIZED")