local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
local sceneGroup = display.newGroup()
local overlayGroup = display.newGroup()
local textGroup = display.newGroup()

local stepnum
local teachtext
local background

local backgroundOverlay1, backgroundOverlay2, backgroundOverlay3
local welcomeText = "Touch the screen to see how to play!"
local teachText = {"Reading", "You can see Chinese words at the top.", "Try to spell out the words in English. Each * means one alphabet.", "Type in a-n-g-r-y to collect stars!", "Listening", "You can rehear the sound by touching this button", "Try to spell out the words in English. Each * means one alphabet.", "Type in correct characters to collect stars!"}

local function showStep()
	if stepnum > 7 then
		backgroundOverlay3.alpha = 1
		composer.gotoScene( "menu", "fromBottom", 500 )
		return
	end
	if stepnum > 3 then -- listening
		background.alpha = 0
		background2.alpha = 1
	end
	teachtext.text = teachText[stepnum+1]
	if stepnum%4 == 0 then
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 1
		teachtext.alpha = 0
		categorytext.text = teachText[stepnum+1]
		categorytext.alpha = 1
	elseif stepnum%4 == 1 then
		teachtext.alpha = 1
		categorytext.alpha = 0
		backgroundOverlay1.alpha = 0
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 1
		teachtext.y = barH
	elseif stepnum%4 == 2 then
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 0
		backgroundOverlay3.alpha = 1
		teachtext.y = screenTop
	elseif stepnum%4 == 3 then
		backgroundOverlay1.alpha = 1
		backgroundOverlay2.alpha = 1
		backgroundOverlay3.alpha = 0
		teachtext.y = barH-40
	end
	stepnum = stepnum + 1 
end

local function createBackgroundOverlay()
	backgroundOverlay1 = display.newRect(overlayGroup,screenLeft, screenTop, screenW, barH)
	backgroundOverlay1:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay1.isHitTestable = true 
	backgroundOverlay1:addEventListener("tap",showStep)
	backgroundOverlay2 = display.newRect(overlayGroup,screenLeft, barH, screenW, barh)
	backgroundOverlay2:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay2.isHitTestable = true 
	backgroundOverlay2:addEventListener("tap",showStep)
	backgroundOverlay3 = display.newRect(overlayGroup,screenLeft, barH+barh, screenW, screenH-barh-barH)
	backgroundOverlay3:setFillColor(0, 0, 0, 0.6)
	backgroundOverlay3.isHitTestable = true 
	backgroundOverlay3:addEventListener("tap",showStep)
end

local function createText()
	local options = 
	{
		parent = textGroup,
		text = welcomeText,     
		x = screenLeft,
		y = barH+30,
		width = screenW,
		font = native.systemFont,
		fontSize = 25,
		align = "left"  --new alignment parameter
	}
	teachtext = display.newText(options)
	
	options.fontSize = 70
	options.x = 0
	options.y = 0
	options.align = "center"
	options.text = "Reading"
	categorytext = display.newText(options)
end

function scene:create( event )
	--sceneGroup = self.view
	display.setDefault( "anchorX", 0 )
	display.setDefault( "anchorY", 0 )

	background = display.newImageRect( "img/full.png", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0
	sceneGroup:insert( background )
	
	background2 = display.newImageRect( "img/full_listen.png", display.contentWidth, display.contentHeight )
	background2.x, background2.y = 0, 0
	background2.alpha = 0
	sceneGroup:insert( background2 )
	
	createText()
	createBackgroundOverlay()
end

function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		sceneGroup.alpha = 1
		overlayGroup.alpha = 1
		textGroup.alpha = 1
		stepnum = 0
		teachtext.text = welcomeText
		categorytext.alpha = 0
		
		background.alpha = 1
		background2.alpha = 0
		
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
		sceneGroup.alpha = 0
		overlayGroup.alpha = 0
		textGroup.alpha = 0
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	display.remove(sceneGroup)
	sceneGroup = nil
	display.remove(overlayGroup)
	overlayGroup = nil
	display.remove(textGroup)
	textGroup = nil
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene