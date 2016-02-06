PANEL = {}

AccessorFunc( PANEL, "m_bDraggable", 		"Draggable", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable", 			"Sizable", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 		"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 	"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_iMinWidth", 		"MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", 		"MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", 	"BackgroundBlur", 	FORCE_BOOL )


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	-- self:SetFocusTopLevel( false )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self:DockPadding( 5, 26, 5, 5 )	
	-- return

end

function PANEL:Close()

	self:SetVisible( false )
	self:Remove()

end

function PANEL:Paint()

	derma.SkinHook( "Paint", "Panel", self )
	
	-- return

end


function PANEL:PerformLayout()

	derma.SkinHook( "Layout", "Panel", self )
	
	-- return

end


vgui.Register( "FusionFrame", PANEL, "Panel" )