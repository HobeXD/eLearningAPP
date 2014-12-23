-----------------------------------------------------------------------------------------
--
-- select.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

--------------------------------------------

local screenW, screenH, halfW , halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local quit, file, reset
local tmp = {}
local tmp2 = {}
local tmp3 = {}
local rankName = {}
local rankScore = {}

local function onQuitRelease( event )
	quit:removeSelf()
	reset:removeSelf()
	for i = 1, 10 do
		tmp[i]:removeSelf()
		tmp2[i]:removeSelf()
		tmp3[i]:removeSelf()
	end
	soundGroup.alpha = 0
	transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
	composer.removeScene("rank")
	composer.gotoScene( "select", "fade", 500 )
	return true
end

local function onResetRelease( event )
	file:seek( "set", 0 )
	for i = 1, 10 do
		file:write("\n")
		file:write("0\n")
		tmp2[i].text = ""
		tmp3[i].text = "0"
	end
	file:flush()
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	menuMusicChannel = audio.play( menuMusic, { loops = -1 } )
	audio.setVolume( 0, { channel = menuMusicChannel } )
	currentChannel = menuMusicChannel
	if (stopFlag== false) then
		audio.fade( { channel = menuMusicChannel, time = 1500, volume = 0.5 } )
	end

	local background = display.newImageRect( "select/background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	local background2 = display.newImageRect( "rank/background.png", display.contentWidth * 0.8, 130 )
	background2.anchorX, background2.anchorY = 0, 0
	background2.x, background2.y = display.contentWidth * 0.1, display.contentHeight * 0.14

	quit = widget.newButton{
		defaultFile="game/quit.png",
		overFile="game/quit-over.png",
		width=30, height=30,
		onRelease = onQuitRelease
	}
	quit.xScale, quit.yScale = 0.9, 0.9
	quit.x = screenW * 0.96
	quit.y = screenH * 0.06

	local title = display.newText({text = class, x = halfW, y = 20, font = "Herculanum", fontSize = 40})
	title:setTextColor( 108/255, 51/255, 101/255 )

	reset = widget.newButton{
		defaultFile="rank/reset.png",
		--overFile="game/quit-over.png",
		width=40, height=40,
		onRelease = onResetRelease
	}
	reset.x = screenW * 0.85
	reset.y = screenH * 0.91

	local path = system.pathForFile( "rank/" .. class, system.ResourceDirectory )
	file = io.open( path, "r+" )

	for i = 1, 10 do 
		rankName[i] = file:read()
		rankScore[i] = file:read()
		rankScore[i] = tonumber(rankScore[i])
	end

	if (fromGame == true) then
		for i = 10, 1, -1 do
			if (rankScore[i] <= userscore and i > 1) then		
				rankName[i] = rankName[i - 1]
				rankScore[i] = rankScore[i - 1]
			elseif (rankScore[i] <= userscore) then
				rankName[1] = username
				rankScore[1] = userscore
			else
				rankName[i + 1] = username
				rankScore[i + 1] = userscore
				break
			end
		end

		file:seek( "set", 0 )
		for i = 1, 10 do
			if (rankName[i] ~= nil) then
				file:write(rankName[i] .. "\n")
			else
				file:write("\n")
			end
			file:write(rankScore[i] .. "\n")
		end
	end
	file:flush()
	--io.close(file)
	--file:close()
	--[[for i = 1, 10 do
		tmp[i] = display.newText({text = i , x = screenW * 0.2, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp2[i] = display.newText({text = rankName[i], x = screenW * 0.3, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp3[i] = display.newText({text = rankScore[i], x = screenW * 0.3 + 100, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp[i]:setFillColor( 162/255, 52/255, 0 )
		tmp2[i]:setFillColor( 108/255, 108/255, 108/255 )
		tmp3[i]:setFillColor( 1, 230/255, 111/255 )
		tmp[i].alpha, tmp2[i].alpha, tmp3[i].alpha = 0, 0, 0
		transition.to(tmp[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp2[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp3[i], {time = 500, delay = 500, alpha = 1})
	end]]

	for i = 1, 5 do
		tmp[i] = display.newText({text = i , x = screenW * 0.2, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp2[i] = display.newText({text = rankName[i], x = screenW * 0.3, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp3[i] = display.newText({text = rankScore[i], x = screenW * 0.3 + 50, y = screenH * 0.11 + i * 25, font = native.systemFont, fontSize = 18})
		tmp[i]:setFillColor( 162/255, 52/255, 0 )
		tmp2[i]:setFillColor( 70/255, 70/255, 70/255 )
		tmp3[i]:setFillColor( 1, 211/255, 6/255 )
		tmp[i].alpha, tmp2[i].alpha, tmp3[i].alpha = 0, 0, 0
		transition.to(tmp[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp2[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp3[i], {time = 500, delay = 500, alpha = 1})
	end

	for i = 6, 10 do
		tmp[i] = display.newText({text = i , x = screenW * 0.6, y = screenH * 0.11 + (i - 5) * 25, font = native.systemFont, fontSize = 18})
		tmp2[i] = display.newText({text = rankName[i], x = screenW * 0.7, y = screenH * 0.11 + (i - 5) * 25, font = native.systemFont, fontSize = 18})
		tmp3[i] = display.newText({text = rankScore[i], x = screenW * 0.7 + 50, y = screenH * 0.11 + (i - 5) * 25, font = native.systemFont, fontSize = 18})
		tmp[i]:setFillColor( 162/255, 52/255, 0 )
		tmp2[i]:setFillColor( 70/255, 70/255, 70/255 )
		tmp3[i]:setFillColor( 1, 211/255, 6/255 )
		tmp[i].alpha, tmp2[i].alpha, tmp3[i].alpha = 0, 0, 0
		transition.to(tmp[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp2[i], {time = 500, delay = 500, alpha = 1})
		transition.to(tmp3[i], {time = 500, delay = 500, alpha = 1})
	end

	sceneGroup:insert( background )
	sceneGroup:insert( background2 )
	sceneGroup:insert( quit )
	sceneGroup:insert( reset )
	sceneGroup:insert( title )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
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
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene