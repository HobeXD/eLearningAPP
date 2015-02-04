display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"
composer.gotoScene( "menu" )

backscene = nil
function onKeyEvent( event )
	if ( event.keyName == "back" and backscene ~= nil) then
		composer.gotoScene( backscene, "fade", 500 )
		return true
	end
	return false
end

Runtime:addEventListener( "key", onKeyEvent )