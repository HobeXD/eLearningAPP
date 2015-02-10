local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
local stepnum
local teachtext = display.object
local backgroundOverlay1, backgroundOverlay2, backgroundOverlay3
local welcomeText = "Touch the screen to see how to play!"
local function showStep()
	if stepnum == 0 then
		backgroundOverlay1.alpha = 0
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 1
		teachtext.y = barH
		teachtext.text = "You can see Chinese words at the top."
	elseif stepnum == 1 then
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 0
		backgroundOverlay3.alpha = 1
		teachtext.y = screenTop
		teachtext.text = "Try to spell out the words in English. Each * means one alphabet."
	elseif stepnum == 2 then
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 0
		teachtext.y = barH-40
		teachtext.text = "Type in a-n-g-r-y to collect stars!"
	else
		composer.gotoScene( "menu", "fromBottom", 500 )
		return
	end
	stepnum = stepnum + 1 
end

function scene:create( event )
	sceneGroup = self.view
	display.setDefault( "anchorX", 0 )
	display.setDefault( "anchorY", 0 )
	
	local background = display.newImageRect( "img/full.png", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0
	sceneGroup:insert( background )
	
	local options = 
	{
		parent = sceneGroup,
		text = welcomeText,     
		x = screenLeft,
		y = barH+30,
		width = screenW,
		font = native.systemFont,
		fontSize = 25,
		align = "left"  --new alignment parameter
	}
	teachtext = display.newText(options)
	
	backgroundOverlay1 = display.newRect(sceneGroup,screenLeft, screenTop, screenW, barH)
	backgroundOverlay1:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay1.isHitTestable = true 
	backgroundOverlay1:addEventListener("tap",showStep)
	backgroundOverlay2 = display.newRect(sceneGroup,screenLeft, barH, screenW, barh)
	backgroundOverlay2:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay2.isHitTestable = true 
	backgroundOverlay2:addEventListener("tap",showStep)
	backgroundOverlay3 = display.newRect(sceneGroup,screenLeft, barH+barh, screenW, screenH-barh-barH)
	backgroundOverlay3:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay3.isHitTestable = true 
	backgroundOverlay3:addEventListener("tap",showStep)
	
	teachtext:toFront()
end

function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		stepnum = 0
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 1
		teachtext.text = welcomeText
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene