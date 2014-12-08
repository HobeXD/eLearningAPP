
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local function waitStart (event)
	composer.gotoScene ("stage", "fade", 500)
end

local startOnce = 1
local startbotton = display.newImage("photo/start00.png")

local function gamestart (event)
	local sceneGroup = scene.view
	if event.phase == "ended" and startOnce == 1 then
		startOnce = 0
		local botton2 = display.newImage("photo/start01.png")
		sceneGroup:insert(botton2)
		botton2.x = startbotton.x
		botton2.y = startbotton.y
		timer.performWithDelay( 100, waitStart )
	end
end


local function fieldHandler( getObj )
	
	return function( event )
		if ( "began" == event.phase ) then
				-- This is the "keyboard has appeared" event
				defaultField.text = ""
		elseif ( "ended" == event.phase ) then
				-- This event is called when the user stops editing a field:
				-- for example, when they touch a different field or keyboard focus goes away
				getname = getObj().text
				text.text = getname
		elseif ( "submitted" == event.phase ) then
				-- This event occurs when the user presses the "return" key
				-- (if available) on the onscreen keyboard
				getname = getObj().text
				text.text = getname
				defaultField.isVisible = false
				-- Hide keyboard
				native.setKeyboardFocus( nil )
		else
				getname = getObj().text
				text.text = getname
		end
	end
		
end     -- "return function()"

local function pos(event)
	print(event.x.." "..event.y)
	if event.phase == "ended" then
		local x = event.x
		local y = event.y
		if x >= 175 and x <= 275 and y >= 440 and y <= 460 then
			defaultField.text = "texting your name here"
			defaultField.isVisible = true
		end
	end
end

function scene:create(event)
	local sceneGroup = self.view
	
	local background = display.newImage("photo/background.png")
	sceneGroup:insert(background)

	background:scale(display.contentWidth / background.contentWidth, display.contentHeight / background.contentHeight)
	background.x = background.contentWidth / 2
	background.y = background.contentHeight / 2
	
	sceneGroup:insert(startbotton)
	startbotton.x = 280
	startbotton.y = 280
	startbotton:addEventListener ("touch", gamestart)

	local nameBlock = display.newImage("photo/nameBlock.png")
	sceneGroup:insert(nameBlock)
	nameBlock.x = 280
	nameBlock.y = 200
	
	local defaultField
	local getname = name
	local text = display.newText(getname, 0, 0, nil, 15)
	sceneGroup:insert(text)
	text.x = 338
	text.y = 203
	text:setTextColor(0,0,0)
 
	defaultField = native.newTextField( 20, 120, 280, 40, fieldHandler( function() return defaultField end ) )
	sceneGroup:insert(defaultField)
	defaultField.isVisible = false



	background:addEventListener ("touch", pos)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene