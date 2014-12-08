local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local physics = require "physics"
physics.start(); physics.pause()

local common = require "common"
local question = require "question"
--------------------------------------------

local function initial_level(sceneGroup)
	questions = {} -- now running questions
	prev_qid = -1
	now_qid = -1 -- important work
	question_count = 0
	solved_count = 0
	score = 0
	current_question = display.newGroup()
	setting_group = display.newGroup()
	
	
	local ans_sheet = display.newText(sceneGroup, "", 0, 0, native.systemFont, 30)
	ans_sheet:setFillColor(0, 1, 0)
	local ans_sheet_background = display.newRoundedRect(sceneGroup, 0, 0, 200, 40, 5)
	ans_sheet:toFront()
	--local q_text = display.newText(sceneGroup, "", 100, 150, native.systemFont, 30)
	
	--current_question["text"] = q_text
	current_question["background"] = ans_sheet_background
	current_question["ans_sheet"] = ans_sheet
	tscore = display.newText(sceneGroup, "score:"..score, screenLeft, screenTop, native.systemFont, 30)
	
	local ctrl_btn_size = 50
	pause_btn = display.newImage(setting_group, "img/pause.png")
	local scale_rate = ctrl_btn_size/pause_btn.width -- original size
	pause_btn:scale(scale_rate, scale_rate)
	pause_btn.x = screenRight - ctrl_btn_size
	pause_btn.y = screenTop + ctrl_btn_size
	pause_btn:addEventListener("tap", pause)
	
	resume_btn = display.newImage(setting_group, "img/retry.png")
	local scale_rate = ctrl_btn_size/resume_btn.width -- original size
	resume_btn.alpha = 0;
	resume_btn:scale(scale_rate, scale_rate)
	resume_btn.x = screenRight - ctrl_btn_size
	resume_btn.y = screenTop + ctrl_btn_size
	--pause_btn:addEventListener("tap", select_pause)
	resume_btn:addEventListener("tap", resume)
end
local function generate_questions(dtime)
	generate_new_question()
	question_timer = timer.performWithDelay(dtime, generate_new_question, 0) --5sec/
	--move_timer = timer.performWithDelay(1, move_question, 0)
	move_timer = Runtime:addEventListener("enterFrame", move_question)
end

local function destroy_all()
	print("destroy all")
	display.remove(current_question["ans_sheet"])
	current_question["ans_sheet"] = nil
	--display.remove(current_question["text"])
	display.remove(current_question["background"])
		
	tscore:removeSelf()
	tscore = nil
	
	-- display group -> only removeself
	setting_group:removeSelf()
	setting_group = nil
	
	for i in pairs(questions) do
		if questions[i]["solved"] ~= true then		
			questions[i]["q_button"]:removeSelf()
			questions[i]["q_button"] = nil
			-- some char button are nil
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
	display.setDefault( "anchorX", 0 )
	display.setDefault( "anchorY", 0 )

	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	--INSERT code here to initialize the scene
	--e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	-- create a grey rectangle as the backdrop
	local background = display.newRect(sceneGroup, screenLeft , screenTop , screenW, screenH )
	background:setFillColor( .5 )
	
	
	initial_level(sceneGroup) --??
end

function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then -- Called when the scene is still off screen and is about to move on screen
		------------new added ---------------------
		level = event.params.level
		print("level = " .. event.params.level)
		sceneGroup = self.view
		words = read_file("voca".. level .. ".txt") 
		dup_question = {}
		dup_question[#words+1] = false -- change table size == #words +1
		generate_questions(2000)
		------------new added ---------------------
	elseif phase == "did" then -- Called when the scene is now on screen
		-- INSERT code here to make the scene come alive. e.g. start timers, begin animation, play audio, etc.
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
		
		--pause
		--hide all display object
		
		
		--
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
	--timer.cancel(move_timer)
	timer.cancel(question_timer)
	Runtime:removeEventListener(move_timer)
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