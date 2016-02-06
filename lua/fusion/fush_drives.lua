
if CLIENT then
	hook.Add("ShouldDrawLocalPlayer", "fusion_drive", function(ply)
		if fusion.cl.Driving then
			-- return true
		end
	end)
end


function fusion.StartDrive(ply, type)
	ply:SendLua("fusion.cl.Driving = true")
	drive.PlayerStartDriving(ply, ply, type)
end

function fusion.StopDrive(ply)
	ply:SendLua("fusion.cl.Driving = false")
	drive.PlayerStopDriving(ply)
	
end

DEFINE_BASECLASS( "drive_base" );

drive.Register( "drive_legend", 
{
	--
	-- Called before each move. You should use your entity and cmd to 
	-- fill mv with information you need for your move.
	--
	StartMove = function( self, mv, cmd )

		--
		-- Update move position and velocity from our entity
		--
		mv:SetOrigin( self.Entity:GetNetworkOrigin() )
		mv:SetVelocity( self.Entity:GetAbsVelocity() )

	end, 

	--
	-- Runs the actual move. On the client when there's 
	-- prediction errors this can be run multiple times.
	-- You should try to only change mv.
	--
	Move = function( self, mv )

		--
		-- Set up a speed, go faster if ( shift is held down
		--
		local speed = 0.005 * FrameTime()
		if ( mv:KeyDown( IN_SPEED ) ) then speed = 0.01 * FrameTime() end

		--
		-- Get information from the movedata
		--
		local ang = mv:GetMoveAngles()
		local pos = mv:GetOrigin()
		local vel = mv:GetVelocity()

		--
		-- Add velocities. This can seem complicated. On the first line
		-- we're basically saying get the forward vector, ) then multiply it
		-- by our forward speed ( which will be > 0 if ( we're holding W, < 0 if ( we're
		-- holding S and 0 if ( we're holding neither ) - and add that to velocity.
		-- We do that for right and up too, which gives us our free movement.
		--
		
		local forward = mv:GetForwardSpeed()
		local right = mv:GetSideSpeed()
		local up = mv:GetUpSpeed()
		
		vel = vel + ang:Forward() * forward * speed
		vel = vel + ang:Right() * right * speed
		vel = vel + ang:Up() * up * speed

		--
		-- We don't want our velocity to get out of hand so we apply
		-- a little bit of air resistance. If no keys are down we apply
		-- more resistance so we slow down more.
		--
		if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) + math.abs( mv:GetUpSpeed() ) < 0.1 ) then
			vel = vel * 0.90
		else
			vel = vel * 0.95
		end

		--
		-- Add the velocity to the position ( this is the movement )
		--
		

		--
		-- We don't set the newly calculated values on the entity itself
		-- we instead store them in the movedata. These get applied in FinishMove.
		--
		
		local movedir = ((pos + vel) - pos):GetNormalized()
		
		local hull = util.TraceHull({
			start = pos,
			endpos = pos + movedir * 48,
			maxs = Vector( 32, 32, 90 ),
			mins = Vector( -32, -32, 0 ),
			filter = self.Entity
		})
		
		if (hull.Hit) then
			pos = hull.HitPos + movedir * -2
			vel = Vector(0,0,0)
			
			ang = Angle(0,ang.y,0)
			vel = vel + ang:Forward() * forward * speed
			vel = vel + ang:Right() * right * speed
			vel = vel + ang:Up() * up * speed
			
			-- print(hull.HitPos)
		end
		
		mv:SetAngles(ang)
		
		pos = pos + vel
		
		mv:SetVelocity( vel )
		mv:SetOrigin( pos )

	end, 

	--
	-- The move is finished. Use mv to set the new positions
	-- on your entities/players.
	--
	FinishMove = function( self, mv )

		--
		-- Update our entity!
		--
		self.Entity:SetNetworkOrigin( mv:GetOrigin() )
		self.Entity:SetAbsVelocity( mv:GetVelocity() )
		self.Entity:SetAngles( mv:GetMoveAngles() )

		--
		-- If we have a physics object update that too. But only on the server.
		--
		if ( SERVER && IsValid( self.Entity:GetPhysicsObject() ) ) then

			self.Entity:GetPhysicsObject():EnableMotion( true )
			self.Entity:GetPhysicsObject():SetPos( mv:GetOrigin() );
			self.Entity:GetPhysicsObject():Wake()
			self.Entity:GetPhysicsObject():EnableMotion( false )

		end

	end, 

	--
	-- Calculates the view when driving the entity
	--
	CalcView = function( self, view )

		--
		-- Use the utility method on drive_base.lua to give us a 3rd person view
		--
		-- local idealdist = math.max( 10, self.Entity:BoundingRadius() ) * 2

		-- view.origin = view.origin + Vector(0,0,0) + view.angles:Forward() * -100
		-- view.h = 200
		
		-- self:CalcView_ThirdPerson( view, idealdist, 2, { self.Entity } )
		
		-- self:CalcView_FirstPerson( view, idealdist, 2, { self.Entity } )
	end, 

}, "drive_base" );