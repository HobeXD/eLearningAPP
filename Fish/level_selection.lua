local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect( sceneGroup, "pic/level_select.png", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	level_name = {"school", "place_location", "transportation", "personal_characteristics", "time"}
	rank_file = {"School", "Place&Location", "Transportation", "Personal&Characteristics", "Time"}

	local function onBtnRelease(level, rank_file)
		local options = {
			effect = "fade",
			time = 500,
			params = {word = level, rankFile = rank_file}
		}
		composer.gotoScene( "game", options )
		return true	-- indicates successful touch
	end

	for i=1, #level_name do 
		local btn = widget.newButton{
			defaultFile = "pic/level_" .. level_name[i] .. ".png",
			-- overFile = "button-over.png",
			x = display.contentWidth/2,
			y = display.contentHeight*i/6,
			onRelease = function() return onBtnRelease(level_name[i], rank_file[i]) end
		}
		btn.width, btn.height = 500, 130
		sceneGroup:insert( btn )
	end

	local function onScoreBoardBtnRelease()
		composer.gotoScene( "score_board", "fade", 500)
		return true	-- indicates successful touch
	end

	local scoreBoradBtn = widget.newButton{
			defaultFile = "pic/medal.png",
			-- overFile = "button-over.png",
			x = display.contentWidth-80,
			y = display.contentHeight-80,
			onRelease = onScoreBoardBtnRelease
		}
	scoreBoradBtn.width, scoreBoradBtn.height = 80, 120
	sceneGroup:insert( scoreBoradBtn )
end

function scene:show( event )
	if event.phase == "will" then
		backscene = "menu"
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	for i=1, #sceneGroup do 
		sceneGroup[i]:removeSelf()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
return scene