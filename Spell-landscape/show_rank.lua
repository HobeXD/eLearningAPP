-- show score
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
local gamedata = require "gamedata"
--local swipe = require "swipe"
--------------------------------------------
local scoreTexts = {}
local category_text, gametype_text
local gametype_button, cate_button
local sceneGroup = display.newGroup()

local rankTransitionEffectTime = 300

local function gotoMenu()
	local option =
	{
		effect = softTransition,
		time = rankTransitionEffectTime,
		params = {}
	}
	composer.gotoScene( "menu", option)
end

local function createScoreButton(scoretable) 
	local options = 
	{
		parent = sceneGroup,
		text = "",     
		x = screencx+100,
		y = 0,
		width = screenW,     --required for multi-line and alignment
		font = native.systemFont,   
		fontSize = 30,
		align = "center"  --new alignment parameter
	}

	for i = 1, 5 do
		options.text = "" .. i .. ".  " .. scoretable[i][1]
		options.y = 120+(i-1)*40
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
	--category_text.text = nowCategory
	--gametype_text.text = nowGametype
	cate_button:setLabel(nowCategory)
	gametype_button:setLabel(nowGametype)
end

local function createRankText()
	nowCategory = defaultCategory
	nowGametype = defaultGametype
	local scoretable = gameData:loadScore(nowCategory, nowGametype) -- should change to two parament
	createScoreButton(scoretable) -- must do in gamedata....
end
local function reloadRankText(nowCategory, nowGametype)
	if nowCategory == nil then
		nowCategory = defaultCategory end
	defaultCategory = nowCategory
	if nowGametype == nil then
		nowGametype = defaultGametype end
	defaultGametype = nowGametype
	setTitle(nowCategory, nowGametype)
	local scoretable = gameData:loadScore(nowCategory, nowGametype) -- should change to two parament
	setScore(scoretable)
end

local select_option = {
	effect = softTransition,
	time = rankTransitionEffectTime,
	params = { 
		caller = "show_rank"
	}
}

local function getSelectedCate()
	composer.gotoScene( "selectLevel", select_option)
end
local function getSelectedGametype()
	composer.gotoScene( "select_gametype", select_option)
end

function scene:create( event )
	sceneGroup = self.view

	local background = display.newImageRect( "/img/star_bg.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0; 	background.anchorX = 0; background.anchorY = 0
	sceneGroup:insert( background )
	
	--[[category_text = display.newText(sceneGroup, defaultCategory, screencx, 20, native.systemFont, 40)
	category_text:setFillColor(1,1,1)
	gametype_text = display.newText(sceneGroup, defaultGametype, screencx, 55, native.systemFont, 30)	
	gametype_text:setFillColor(0,1,0)]]
	
	local back_button = widget.newButton{
		label = "back",
		id = "back",
		fontSize = 30,
		width=100, height=50,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = gotoMenu
	}
	back_button.x, back_button.y = 20, 250; back_button.anchorX, back_button.anchorY = 0, 0
	sceneGroup:insert( back_button )
	
	cate_button = widget.newButton{
		label = defaultCategory,
		id = "category",
		fontSize = 20,
		width=250, height=60,
		x = 10, y = 20,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 0, 0, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = getSelectedCate, 
		labelAlign = 'center'
	}
	cate_button.anchorX, cate_button.anchorY = 0, 0
	sceneGroup:insert( cate_button )
	
	gametype_button = widget.newButton{
		label = defaultGametype,
		id = "category",
		fontSize = 20,
		width=150, height=60,
		x = 300, y = 20,
		strokeWidth = 0,
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 0, 1, 0, 0.7}, over={ 1,1,1, 1 }}, --transparent
		onRelease = getSelectedGametype
	}
	gametype_button.anchorX, gametype_button.anchorY = 0, 0
	sceneGroup:insert( gametype_button )
	
	createRankText()
end
function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		reloadRankText(event.params.category, event.params.gametype)
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