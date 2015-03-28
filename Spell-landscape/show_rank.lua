-- show rank(score)
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
local gamedata = require "gamedata"
--------------------------------------------
local sceneGroup = display.newGroup()

local scoreTexts = {}
local gametype_button, cate_button, back_button
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
	end
end

local category_text, gametype_text
local function createRankText()
	local scoretable = gameData:loadScore(gameData.nowLevelName, gameData.nowGametype) -- should change to two parament
	createScoreButton(scoretable) -- must do in gamedata....
end

local function reloadScore(scoretable)
	for i = 1, 5 do
		scoreTexts[i].text = "" .. i .. ".  " .. scoretable[i][1]
	end
end
local function reloadTitle(nowCategory, nowGametype)
	cate_button:setLabel(nowCategory)
	gametype_button:setLabel(nowGametype)
end
local function reloadRankText(nowCategory, nowGametype)
	defaultCategory = gameData.nowLevelName
	defaultGametype = gameData.nowGametype
	
	reloadTitle(defaultCategory, defaultGametype)
	local scoretable = gameData:loadScore(defaultCategory, defaultGametype) -- should change to two parament
	reloadScore(scoretable)
end

local rankTransitionEffectTime = 300
local select_option = {
	effect = softTransition,
	time = rankTransitionEffectTime,
	params = { 
		caller = "show_rank"
	}
}
local function goSelectedCate()
	composer.gotoScene( "selectLevel", select_option)
end
local function goSelectedGametype()
	composer.gotoScene( "select_gametype", select_option)
end
local function gotoMenu()
	local option = {
		effect = softTransition,
		time = rankTransitionEffectTime,
		params = {}
	}
	composer.gotoScene( "menu", option)
end

local function createButtons()
	back_button = widget.newButton{
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
		onRelease = goSelectedCate, 
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
		onRelease = goSelectedGametype
	}
	gametype_button.anchorX, gametype_button.anchorY = 0, 0
	sceneGroup:insert( gametype_button )
end
function scene:create( event )
	sceneGroup = self.view

	createBackground(sceneGroup)
	createButtons()
	createRankText()
end
function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		reloadRankText()
	elseif phase == "did" then
	end	
end
function scene:hide( event )
	local phase = event.phase
	if event.phase == "will" then
	elseif phase == "did" then
	end	
end
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene