
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local next_timer = 0
local reset_timer = 224
local sleep_time = 0.02

local pos = {{93,160},{280,160},{467,160},{93,267},{280,267},{467,267}}
local size = {180, 100}
local num_pool = {}
local wordTags = {0,0,0,0,0,0}
local wordText = {0,0,0,0,0,0}
local assigned = {0,0,0,0,0,0}
local assignCnt = 0
local image = {0,0,0,0,0,0}
local length = table.maxn(words)
local scoreText
local chosen = 0
local score = 0

local function move_tag(event)
	local sceneGroup = scene.view
	if event.phase == "began" then
		chosen = event.target.id
	elseif event.phase == "moved" then
		event.target.x = event.x
		event.target.y = event.y
	elseif event.phase == "ended" then
		local id = event.target.id
		if math.abs(event.x - pos[id][1]) < 90 and math.abs(event.y - pos[id][2]) < 50 then
			score = score + 1
			scoreText.text = score
			print (score)
			image[id]:removeSelf()
			wordText[id]:removeSelf()
			assigned[id] = 0
			assignCnt = assignCnt - 1
			local num = math.random(length-6)
			local tmp = num_pool[id]
			num_pool[id] = num_pool[num+6]
			num_pool[num+6] = tmp
			print (num_pool[id], words[num_pool[id]])
			image[id] = display.newImage("word/"..words[num_pool[id]]..".jpg")
			sceneGroup:insert(image[id])
			image[id]:scale(size[1] / image[id].contentWidth, size[2] / image[id].contentHeight)
			image[id].x = pos[id][1]
			image[id].y = pos[id][2]
			event.target:removeSelf()
			if assignCnt == 0 then next_timer = 0 end
		end
		chosen = 0
	else
		chosen = 0
	end
			print (chosen, event.target.id, event.phase)
end

local function new_tag()
	local sceneGroup = scene.view
	local x = math.random(6)
	while assigned[x] ~= 0 do
		print (x, assigned[x])
		x = math.random(6)
	end
	assigned[x] = 1
	assignCnt = assignCnt + 1
	wordTags[x] = display.newImage("photo/1.png")
	sceneGroup:insert(wordTags[x])
	wordTags[x]:addEventListener( "touch", move_tag )
	wordTags[x]:scale(1.5,1)
	wordTags[x].nowx = 560
	wordTags[x].nowy = 53
	wordTags[x].id = x
	wordText[x] = display.newText(words[num_pool[x]], 0, 0, nil, 18)
	sceneGroup:insert(wordText[x])
	wordText[x]:setTextColor(0,0,0)
	--composer.gotoScene ("start", "fade", 500)
end



local function stage_loop(event)
	if next_timer <= 0 then
		next_timer = reset_timer
		new_tag()
	end
	for i = 1, 6 do
		if assigned[i] ~= 0 then
			wordTags[i].nowx = wordTags[i].nowx - 1
			if chosen ~= i then
				wordTags[i].x = wordTags[i].nowx
				wordTags[i].y = wordTags[i].nowy
			end
			wordText[i].x = wordTags[i].x
			wordText[i].y = wordTags[i].y
			if wordTags[i].x <= 0 then
				wordTags[i]:removeSelf()
				wordText[i]:removeSelf()
				assigned[i] = 0
				assignCnt = assignCnt - 1
				if assignCnt == 0 then next_timer = 0 end
			end
		end
	end
	next_timer = next_timer - 1
	timer.performWithDelay( 20, stage_loop )
end

function scene:create( event )
	local sceneGroup = self.view
	
	-- display a background image
	local background = display.newImage("photo/background.png")
	sceneGroup:insert(background)
	background:scale(display.contentWidth / background.contentWidth, display.contentHeight / background.contentHeight)
	background.x = background.contentWidth / 2
	background.y = background.contentHeight / 2
		
	local text = display.newText("Score: ", 0, 0, nil, 20)
	sceneGroup:insert(text)
	text.x = 35
	text.y = 20
	text:setTextColor(0,0,0)
	scoreText = display.newText("0", 0, 0, nil, 20)
	sceneGroup:insert(scoreText)
	scoreText.x = 75
	scoreText.y = 20
	scoreText:setTextColor(0,0,0)
	timer.performWithDelay( 1000, stage_loop )
	
	for i = 1, length do
		num_pool[i] = i
	end
	
	for i = 1, 6 do
		local num = math.random(length-i+1)
		local tmp = num_pool[i]
		num_pool[i] = num_pool[num+i-1]
		num_pool[num+i-1] = tmp
		print (num_pool[i], words[num_pool[i]])
		image[i] = display.newImage("word/"..words[num_pool[i]]..".jpg")
		sceneGroup:insert(image[i])
		if image[i] == nil then
			scoreText.text = "NOOO"
		end
		image[i]:scale(size[1] / image[i].contentWidth, size[2] / image[i].contentHeight)
		image[i].x = pos[i][1]
		image[i].y = pos[i][2]
	end
	

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