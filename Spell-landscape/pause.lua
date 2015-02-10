-- Ref: Rolly Bear World Project by Christian Peeters
local composer = require "composer"
local common = require "common"
local widget = require "widget"
local scene = composer.newScene()
local params
 
function catchBackgroundOverlay(event)
	return true 
end

function scene:create( event )
	local group = self.view
	local backgroundOverlay = display.newRect (screenLeft, screenTop, screenW, screenH)
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
	
	local home_btn = widget.newButton
	{
		left = screencx, 
		top = screency,
		width = 150,
		height = 70,
		shape = "roundedRect",
		cornerRadius = 5,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
		--strokeWidth = 4, 
		fontSize = 30, 
		label = "Menu",
		onRelease = go_home
	}
	home_btn.anchorX = 0.5
	home_btn.anchorY = 0.5
	group:insert (home_btn)
end
function scene:show( event )
	local group = self.view
	ispause = true;
end
function scene:hide( event )
	local group = self.view
	ispause = false;
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene