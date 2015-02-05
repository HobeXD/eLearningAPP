local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect(sceneGroup, "pic/level_complete.png", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	local function onReturnBtnRelease()		
		composer.gotoScene( "level_selection", "fade", 500 )		
		return true	-- indicates successful touch
	end

	local returnBtn = widget.newButton{
		defaultFile = "pic/return_to_menu.png",
		-- overFile = "pic/button-over.png",
		x = display.contentWidth/2,
		y = display.contentHeight-180,
		onRelease = onReturnBtnRelease
	}
	returnBtn.width, returnBtn.height = 450, 120
	sceneGroup:insert( returnBtn )
end

function scene:show( event )
	if event.phase == "will" then
		backscene = "level_selection"
		if event.params ~= nil then

			local path = system.pathForFile( "rank/" .. event.params.rankFile, system.ResourceDirectory )
			local file = io.open( path, "r+" )
			local score = {}

			for i = 1, 10 do 
				local tmp = tonumber(file:read())
				if tmp == nil then
					break
				end
				score[i] = tmp
			end
			print(#score+1,event.params.score)
			score[#score+1] = event.params.score
			table.sort(score)
			file:seek( "set", 0 )
			for i=1, #score do
				file:write(score[#score+1-i] .. "\n")
				print (score[i])
			end
			file:flush()
		end
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