local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
-- forward declarations and other locals
local playtext
local teachBtn
local isblink = true
local sceneGroup = display.newGroup()

-- 'onRelease' event listener for playBtn
local function gotoScene(event)
	local option =
		{
			effect = "fromBottom",
			time = 400,
			params = {}
		}
	if event.target.id == "show_rank" then
		option.effect = softTransition
	end
	composer.gotoScene( event.target.id, option)
	return true	-- indicates successful touch
end

local function blink_text(event)
	print("blink!") 
	transition.blink(playtext , {time = 3600, delay = 1800})	
end

local nowbgmnum = 1
local function changebgm()
	nowbgmnum = (nowbgmnum)%4 + 1
	audio.play(bgms[nowbgmnum], { channel=1, onComplete=changebgm } )
end
local function set_bgm()
	bgms = {
		audio.loadStream( "sound/bgm/deep-emerald-short.mp3" ),
		--audio.loadStream( "sound/bgm/happy-inn-short.mp3" ),
		--audio.loadStream( "sound/bgm/icy-town-short.mp3" ),
		--audio.loadStream( "sound/bgm/pinball-three-short.mp3" )
	}
	--audio.play(bgms[nowbgmnum], { channel=1, onComplete=changebgm } )
	if not debugMode then
		audio.play(bgms[nowbgmnum], { channel=1, loops = -1 } )
	end
end

local function createSideButton()
		teachBtn = widget.newButton{
		label="How to Play?",
		labelColor = { default={255}, over={128} },
		id = "tutorial",
		default="button.png",
		over="button-over.png",
		font = native.systemFont,
		width=154, height=40,
		onRelease = gotoScene	-- event listener function
	}
	teachBtn.x = display.contentWidth - 77; teachBtn.y = display.contentHeight - 20
	
	rankBtn = widget.newButton{
		label="Score",
		labelColor = { default={255}, over={128} },
		id = "show_rank",
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = gotoScene	-- event listener function
	}
	rankBtn.x = 77; rankBtn.y = display.contentHeight - 20
	sceneGroup:insert( teachBtn )
	sceneGroup:insert( rankBtn )
end

function scene:create( event )
	sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- initial setup
	audio.setVolume( 0.25, { channel=mainBGMChannel }) -- set the volume on channel 1
	audio.setVolume( 0.75, { channel=vocaSoundChannel }) -- set the volume on channel 1
	audio.setVolume( 0.75, { channel=winLoseSoundChannel }) -- set the volume on channel 1
	
	set_bgm()
	
	Runtime:addEventListener("key", handle_system_key)
	
	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0; background.anchorY = 0;	background.x, background.y = 0, 0
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newText("Collect Stars", 264, 42, native.systemFont, 65)
	titleLogo.x = display.contentWidth * 0.5;	titleLogo.y = 100
	
	
	playtext = display.newText("Touch to play", display.contentWidth*0.5, display.contentHeight - 100, native.systemFont, 30)
	playtext:setFillColor( 0, 1, 0)
	transition.blink(playtext , {time = 3400}) -- 
	--timer_blink = timer.performWithDelay(800, blink_text, 0)
	
	local backgroundOverlay = display.newRect (screenLeft, screenTop, screenW, screenH)
	backgroundOverlay.anchorX = 0; backgroundOverlay.anchorY = 0
	backgroundOverlay:setFillColor( black )
	backgroundOverlay.alpha = 0
	backgroundOverlay.id = "select_gametype"
	backgroundOverlay.isHitTestable = true 
	backgroundOverlay:addEventListener ("tap", gotoScene)
	backgroundOverlay:addEventListener ("touch", gotoScene)

	--加入group的順序會影響上下層關係...
	sceneGroup:insert( backgroundOverlay )
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	createSideButton()
	-- all display objects must be inserted into group
	sceneGroup:insert( playtext )
end

function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		print("show menu")
		-- Called when the scene is still off screen and is about to move on screen
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

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene