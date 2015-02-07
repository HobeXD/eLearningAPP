display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"
composer.gotoScene( "menu" )

backscene = nil
function onKeyEvent( event )
	if ( event.keyName == "back" ) then
		if ( backscene ~= nil ) then
			composer.gotoScene( backscene, "fade", 500 )
		else
			local function onComplete( event )
				if "clicked" == event.action then
					local i = event.index
					if 1 == i then
						native.cancelAlert( alert )
					elseif 2 == i then
						native.requestExit()
					end
				end
			end
			local alert = native.showAlert( "EXIT", "ARE YOU SURE?", { "NO", "YES" }, onComplete )
			-- group:insert(alert)
		end
		return true
	end
	return false
end

Runtime:addEventListener( "key", onKeyEvent )