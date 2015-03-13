local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"

local common = require "common"
local question = require "question"
local listen = require "listen"
local sceneGroup = display.newGroup()
--------------------------------------------
local create_ans_field, create_score_field, create_pause_buttons, generate_qwerty_button
local gameType, levelName

local function initial_level()
	ispause = false

	questions = {} -- questions that is on screen
	prev_qid = -1
	now_qid = -1
	question_count = 0
	solved_count = 0
	score = 0
	
	question_score = 10
	char_score = 1
	penalty_score = 1
	now_wrong_num = 0
	
	current_question = display.newGroup()
	setting_group = display.newGroup()
	
	create_ans_field(current_question)
	create_score_field()
	create_pause_buttons(setting_group)
	qwerty_btns = generate_qwerty_button()
end
create_ans_field = function (current_question)
	local ans_sheet = display.newText(sceneGroup, "", screency + 10, barH-5, native.systemFont, 30)
	ans_sheet:setFillColor(0, 0, 0)
	local ans_sheet_background = display.newRoundedRect(sceneGroup, screency, barH, 300, 40, 5)
	ans_sheet:toFront()
	
	current_question["background"] = ans_sheet_background
	current_question["ans_sheet"] = ans_sheet
end
create_score_field = function ()
	score_star = display.newImage(sceneGroup, "img/star.png")
	score_star.anchorX = 0.5; score_star.anchorY = 0.5
	score_star.x = screenLeft + barh/2
	score_star.y = barH + barh/2
	
	star_scale_rate = barh/score_star.width
	score_star:scale(star_scale_rate, star_scale_rate)
	
	score_text = display.newText(sceneGroup, score, screenLeft + 40, barH, native.systemFont, 30)
end
create_pause_buttons = function(setting_group) --cannot be paused
	local ctrl_btn_size = 50
	pause_btn = display.newImage(setting_group, "img/pause.png")
	local scale_rate = ctrl_btn_size/pause_btn.width -- original size
	pause_btn:scale(scale_rate, scale_rate)
	pause_btn.x = screenW - ctrl_btn_size
	pause_btn.y = screenBottom - ctrl_btn_size
	pause_btn:addEventListener("tap", pause)
	
	resume_btn = display.newImage(setting_group, "img/retry.png")
	local scale_rate = ctrl_btn_size/resume_btn.width -- original size
	resume_btn.alpha = 0;
	resume_btn:scale(scale_rate, scale_rate)
	resume_btn.x = screenW - ctrl_btn_size
	resume_btn.y = screenBottom - ctrl_btn_size
	resume_btn:addEventListener("tap", resume)
end
generate_qwerty_button = function ()
	local baseh, wordh,intevalh, intevalw
	baseh = 110; wordh = 50; intevalh = 10;  intevalw = 7;--first row interval is only 7...
	-- Apple says that the avg finger tap is 44x44 (from WWDC). All table rows are recommended to be at least that height. It is common for icons to appear 32x32, but have padding to make the touchable area 44x44.
	local qwerty_str = {"qwertyuiop", "asdfghjkl", "zxcvbnm"}
	local qwerty_btns = {}
	
	for row = 1,3 do
		local length = string.len(qwerty_str[row])
		local wordw = (display.viewableContentWidth / length) - intevalw
		if wordw > 45 then
			wordw = 45
		end
		local total_len = length * (wordw + intevalw) - intevalw
		local remain_len = (display.viewableContentWidth - total_len) / 2
		local basew = screenLeft + (remain_len+wordw) /2--weird offset
		
		local col = 1
		for char in string.gmatch(qwerty_str[row], '.') do
			local qwerty_btn =  widget.newButton
			{
				left = basew + ((col-1)%length) * wordw + ((col-1)%length) * intevalw,
				top = baseh + row * wordh + row * intevalh,
				id = char,
				label = char,
				onEvent = check_select_ans,
				-- about shape
				shape = "roundedRect",
				width = wordw,
				height = wordh,
				cornerRadius = 5,
				fontsize = 20,
				labelColor = { default={ 0, 0, 0, 1}, over={ 0,0,0, 1 }},
				fillColor = { default={ 0, 1, 0, 1}, over={ 1, 1, 1, 1} },
			}
			qwerty_btn.anchorX = 0.5
			qwerty_btn.anchorY = 0.5
			sceneGroup:insert(qwerty_btn)
			col = col + 1
			qwerty_btns[char] = qwerty_btn
		end
	end
	return qwerty_btns
end

local function generate_questions()
	if gameType == "Read" then
		generate_new_question(sceneGroup)
		move_timer = Runtime:addEventListener("enterFrame", move_question)
	else -- listening
		audio.pause(mainBGMChannel) -- cancel music
		countDownText = display.newText(sceneGroup, "", screenLeft, screenTop, native.systemFont, 30)-- show countdown time
		sceneGroup:insert(countDownText)
		generate_new_question_listen(sceneGroup, levelName)
	end
end
function scene:create( event ) -- Called when the scene's view does not exist, initialize
	sceneGroup = self.view
	display.setDefault( "anchorX", 0 );	display.setDefault( "anchorY", 0 )
	
	local background = display.newImageRect( "img/star_bg.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0; background.anchorX = 0; background.anchorY = 0
	sceneGroup:insert( background )
	
	gameType = event.params.gametype
	levelName = event.params.category
	
	initial_level()
end
function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then -- Called when the scene is still off screen and is about to move on screen
		print("level: before show" .. event.phase)
		words = read_file("voca/".. levelName .. ".txt")
		dup_question = {}
		dup_question[#words+1] = false
		
		generate_questions()
	elseif phase == "did" then -- Called when the scene is now on scr-- INSERT code here to make the scene come alive. e.g. start timers, begin animation, play audio, etc.
		
	end
end
function scene:hide( event )
	local phase = event.phase
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		
		--pause
		--hide all display object
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

local function destroy_setting_group()
	setting_group:removeSelf()
	setting_group = nil
end
function scene:destroy( event )
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc
	--timer.cancel(question_timer)
	Runtime:removeEventListener("enterFrame", move_question) -- no need to remember move_timer
	if countDownTimer ~= nil then
		timer.cancel(countDownTimer)
	end
	--destroy_all() --needed?
	--ispause = false
	resume()
	destroy_setting_group() -- this is out of level scene! belongs to pause scene
end

-- Listener 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene