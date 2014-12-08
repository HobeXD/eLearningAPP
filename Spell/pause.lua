-- Ref: Rolly Bear World Project by Christian Peeters
local composer = require "composer"
local scene = composer.newScene()
local params
 
 function catchBackgroundOverlay(event)
	return true 
end
 
-- Called when the scene's view does not exist:
function scene:create( event )
	print("create scene")
	local group = self.view
	backgroundOverlay = display.newRect (screenLeft, screenTop, screenW, screenH)
	backgroundOverlay:setFillColor( black )
	backgroundOverlay.alpha = 0.6
	group:insert(backgroundOverlay)
	-- Allows an object to continue to receive hit events even if it is not visible. If true, objects will receive hit events regardless of visibility; if false, events are only sent to visible objects. Defaults to false.
	backgroundOverlay.isHitTestable = true 
	--prevent the button event be triggered
	backgroundOverlay:addEventListener ("tap", catchBackgroundOverlay)
	backgroundOverlay:addEventListener ("touch", catchBackgroundOverlay)
	
	overlay = display.newImage ("img/pausemenu.png", screencx, screency)
	overlay.anchorX = 0.5
	overlay.anchorY = 0.5
	group:insert (overlay)
end
 
function scene:show( event )
	local group = self.view
	print("enterscene")
	ispause = true;
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end
 
function scene:hide( event )
	local group = self.view
	ispause = false;
	-- INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks
 
end
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
 
 
	-- INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks
 
end
 
-- "createScene" event is dispatched if scene's view does not exist 
-- "enterScene" event is dispatched whenever scene transition has finished
-- "exitScene" event is dispatched before next scene's transition begins
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene