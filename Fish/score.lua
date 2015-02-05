local composer = require( "composer" )
local scene = composer.newScene()

local title, rankBoard, rankGroup

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect( sceneGroup, "pic/level_select.png", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2
	rankBoard = display.newImageRect( sceneGroup, "pic/rank_board.png", display.contentWidth*0.8, display.contentHeight*0.7 )
	rankBoard.x, rankBoard.y = display.contentWidth/2, display.contentHeight/2+50
	title = display.newText(sceneGroup, "", display.contentWidth/2, display.contentHeight/9, native.systemFontBold, 60)
	title:setFillColor( 0.2, 0.2, 0.5 )
end

function scene:show( event )
	if event.phase == "will" then
		backscene = "score_board"
		title.text = event.params.title
		rankGroup = display.newGroup()
		local sceneGroup = self.view
		sceneGroup:insert(rankGroup)
		local path = system.pathForFile( "rank/" .. event.params.title )
		local file = io.open( path, "r+" )

		local top = rankBoard.y-rankBoard.height/2
		local bottom = rankBoard.y+rankBoard.height/2
		local left = rankBoard.x-rankBoard.width/2
		for i = 1, 10 do 
			local score = tonumber(file:read())
			if score == nil then
				break
			end
			local rank = display.newText(rankGroup, i, left+100, top+rankBoard.height*i/11, native.systemFontBold, 60)
			rank:setFillColor( 0.2, 0.2, 0.5 )
			local scoreText = display.newText({parent=rankGroup, text=score, x=left+250, y=top+rankBoard.height*i/11, width=400, font=native.systemFont, fontSize=60, align="right"})
			scoreText:setFillColor( 0.2, 0.2, 0.5 )
		end
	end
end

function scene:hide( event )
	if event.phase == "did" then
		rankGroup:removeSelf()
		-- print("in", #rankGroup)
		-- for i=1, #rankGroup do 
		-- 	print("in" .. i)
		-- 	rankGroup[i]:removeSelf()
		-- end
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
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene