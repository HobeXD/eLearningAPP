-- show score
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
local gamedata = require "gamedata"
--local swipe = require "swipe"
--------------------------------------------
local defaultCategory = categoryStr[1]
local defaultGametype = gametypeStr[1]
local scoreTexts = {}
local category_text
local gametype_text
local sceneGroup = display.newGroup()

local function gotoMenu()
	local option =
	{
		effect = defaultPattern,
		time = 500,
		params = {}
	}
	composer.gotoScene( "menu", option)
end

local function showScore(scoretable) 
	local options = 
	{
		parent = sceneGroup,
		text = "",     
		x = screencx,
		y = 0,
		width = screenW,     --required for multi-line and alignment
		font = native.systemFont,   
		fontSize = 35,
		align = "center"  --new alignment parameter
	}

	for i = 1, 5 do
		options.text = "" .. i .. ".  " .. scoretable[i][1]
		options.y = 90+(i-1)*50
		scoreTexts[i] = display.newText(options)
		scoreTexts[i].anchorX = 0.5; scoreTexts[i].anchorY = 0.5
		--sceneGroup:insert(scoreTexts)
	end
end
local function setScore(scoretable)
	for i = 1, 5 do
		scoreTexts[i].text = "" .. i .. ".  " .. scoretable[i][1]
	end
end
local function setTitle(nowCategory, nowGametype)
	category_text.text = nowCategory
	gametype_text.text = nowGametype
end

local function createRankText()
	nowCategory = defaultCategory
	nowGametype = defaultGametype
	local scoretable = gameData:loadScore(nowCategory) -- should change to two parament
	showScore(scoretable) -- must do in gamedata....
end
local function reloadRankText(nowCategory, nowGametype)
	if nowCategory == nil then
		nowCategory = defaultCategory end
	if nowGametype == nil then
		nowGametype = defaultGametype end
	setTitle(nowCategory, nowGametype)
	local scoretable = gameData:loadScore(nowCategory) -- should change to two parament
	setScore(scoretable)
end

local function getSelectedLevel()
	local option =
		{
			effect = defaultPattern,
			time = 500,
			params = {
				caller = "show_rank"
			}
		}
	composer.gotoScene( "selectLevel", option)
end
local function getSelectedCate()
	local option =
	{
		effect = defaultPattern,
		time = 500,
		params = {
			caller = "show_rank"
		}
	}
	composer.gotoScene( "select_gametype", option)
end

function scene:create( event )
	sceneGroup = self.view

	local background = display.newImageRect( "/img/star_bg.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0; 	background.anchorX = 0; background.anchorY = 0
	sceneGroup:insert( background )
	
	category_text = display.newText(sceneGroup, defaultCategory, screencx, 20, native.systemFont, 40)
	category_text:setFillColor(1,1,1)
	gametype_text = display.newText(sceneGroup, defaultGametype, screencx, 55, native.systemFont, 30)	
	gametype_text:setFillColor(0,1,0)
	
	local back_button = widget.newButton{
		label = "back",
		id = "back",
		fontSize = 30,
		width=100, height=60,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = gotoMenu
	}
	back_button.x, back_button.y = 45, 10; back_button.anchorX, back_button.anchorY = 0, 0
	sceneGroup:insert( back_button )
	
	local cate_button = widget.newButton{
		label = "select\ncategory",
		id = "category",
		fontSize = 20,
		width=100, height=60,
		x = 45, y = 100,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = getSelectedLevel
	}
	cate_button.anchorX, cate_button.anchorY = 0, 0
	sceneGroup:insert( cate_button )
	
	local cate_button = widget.newButton{
		label = "select\ngametype",
		id = "category",
		fontSize = 20,
		width=100, height=60,
		x = 45, y = 200,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = getSelectedCate
	}
	cate_button.anchorX, cate_button.anchorY = 0, 0
	sceneGroup:insert( cate_button )
	
	createRankText()
end
function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		reloadRankText(event.params.category, nowGametype)
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
	
	--[[if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end]]
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene