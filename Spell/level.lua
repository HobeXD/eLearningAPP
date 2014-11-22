local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local physics = require "physics"
physics.start(); physics.pause()

local common = require "common"
local question = require "question"
--------------------------------------------
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function generate_questions(dtime)
	question_timer = timer.performWithDelay(dtime, generate_new_question, 0) --5sec/
	move_timer = timer.performWithDelay(1, move_question, 0)
end

function destroy_all()
	print("current question = " .. current_question.numChildren)
	display.remove(current_question["ans_text"])
	current_question["ans_text"] = nil
	display.remove(current_question["text"])
	display.remove(current_question["background"])
		
	tscore:removeSelf()
	tscore = nil

	for i in pairs(questions) do
		if questions[i]["solved"] ~= true then		
			display.remove(questions[i]["q_button"])
			for j in pairs(questions[i]["char_buttons"]) do
				while questions[i]["char_buttons"][j] ~= nil do
					questions[i]["char_buttons"][j]:removeSelf()
					questions[i]["char_buttons"][j] = nil
				end
			end
		end
	end
	questions = {}
end

function scene:create( event )
	-- Called when the scene's view does not exist.
	--INSERT code here to initialize the scene
	--e.g. add display objects to 'sceneGroup', add touch listeners, etc.
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then -- Called when the scene is still off screen and is about to move on screen
		-- create a grey rectangle as the backdrop
		local background = display.newRect( 0, 0, screenW, screenH )
		background.anchorX = 0
		background.anchorY = 0
		background:setFillColor( .5 )
		
		-- all display objects must be inserted into group
		local sceneGroup = self.view
		sceneGroup:insert( background )
	elseif phase == "did" then -- Called when the scene is now on screen
		-- INSERT code here to make the scene come alive. e.g. start timers, begin animation, play audio, etc.
		------------new added ---------------------
		words = read_file("voca.txt") 
		dup_question = {}
		dup_question[#words+1] = false -- change table size == #words +1
		initialize_question() --??
		generate_questions(2000)
		------------new added ---------------------
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	---------newly add-------
	timer.cancel(move_timer)
	timer.cancel(question_timer)
	destroy_all()
	---------newly add-------
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene