local widget = require "widget"
-------------
-- reading.lua, for reading stage
------------

questionMoveSpeed = 0.3
speed_scale = 1
radius = 50

function generate_new_question_read(sceneGroup) -- random choose a word, which is not solved yet
	is_generate_question = true
	if sceneGroup ~= nil then
		nowSceneGroup = sceneGroup
	end

	local q_engligh, q_chinese = getNewQuestionInfo()
	if(q_engligh == nil) then -- no available question 
		return
	end
	--create qustion button
	local q_button = widget.newButton
	{
		left = screenLeft,
		top = screenTop,
		id = question_count,
		label = q_chinese,
		--onPress = selectQuestion,
		--onRelease = show_select_question,
		onEvent = selectQuestion,
		-- about shape
		shape = "roundedRect",
		width = 100 + (string.len(q_chinese)-5)*10,
		height = 100,
		cornerRadius = 2,
		fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		labelColor = { default={ 1, 1,1,1 }, over={ 1, 0.2, 0.5, 1 } },
		strokeWidth = 4, 
		fontSize = 40, 
		alpha = 0
	}
	nowSceneGroup:insert(q_button)

	local question = {} -- include data about a question
	question["eng"] = q_engligh
	question["chi"] = q_chinese
	question["q_button"] = q_button
	question["question_count"] = question_count --id
	question["solved"] = false
	question["wrong_trial"] = 0
	--question["consume_time"] = 0
	
	fillHint(question)
	
	questions[question_count] = question
	q_button.alpha = 1
	if now_qid == -1 then -- if there is no question selected, select lowest
		select_lowest_question()
	end
	is_generate_question = false
end

function move_question(event) --now fps is 60 (in config.lua)
	if check_pause() then --busy running
		return
	end
	if(questions[now_qid]) then
		questions[now_qid]["q_button"]:setFillColor(0.2, 0.7, 1)
	end
	minx = 1000
	for i in pairs(questions) do
		if questions[i] ~= nil and questions[i]["solved"] == false then
			local xpos = questions[i]["q_button"].x
			if xpos ~= nil then
				xpos = xpos + questionMoveSpeed * speed_scale;
				if ( xpos < minx) then
					minx = xpos
				end
				if ( xpos > screenW - radius) then
					question_failed(questions[i])
				else 
					questions[i]["q_button"]:translate(xpos - questions[i]["q_button"].x, 0)
				end
			end
		end
	end
	if minx > screencx / 2 * 3 and not is_generate_question then
		generate_new_question_read()
	end
end

function selectQuestion( event ) --rename select_c
    if event.phase == "began" then
		select_question_read(event.target.id)
	end
    return true
end
function select_lowest_question() -- find the question that is most likely to make fail
	local lowid, lowv
	lowid = -1; lowv = screenLeft
	for i in pairs(questions) do
		if questions[i]["solved"] == false and lowv <= questions[i]["q_button"].x then
			lowv = questions[i]["q_button"].x
			lowid = i
		end
	end
	
	if lowid ~= -1 then
		print("select lowest " .. lowid)
		select_question_read(lowid)
	else  -- generate new question, reset timer
		--if question_timer ~= nil then
			--timer.cancel(question_timer)
		--end
		if not is_generate_question then	
			generate_new_question_read()
		end
		--question_timer = timer.performWithDelay(generate_question_time, generate_new_question_read, 0)
	end
end
function select_question_read(id)
	if check_pause() then
		return
	end
	if now_qid == id then --no need to update
		return
	end
	prev_qid = now_qid
	now_qid = id
	local q = questions[now_qid]
	--print("select id = ".. now_qid .. " prev = ".. prev_qid .. "eng = " .. q["eng"] .. " chi = " .. q["chi"])
	--current_question["text"].text = q["chi"];
	current_question["ans_sheet"].text = q["now_anschar"];
	
	if prev_qid ~= -1 then -- question need to be hided
		hide_question(questions[prev_qid])
	end
	show_question(q)
end

function show_question(question)
end	
function hide_question(question)
	if question == nil then
		return
	end
	question["q_button"]:setFillColor(1, 0.2, 0.5, 0.7)
end

function finish_question_read(q, isSuccess)
	-- remove all data relate to this question
	print("finish_question_read")
	local c = q["chi"]
	local e = q["eng"]
	display.remove(q["q_button"])
	for j in pairs(q) do
		while q[j] ~= nil do
			q[j] = nil
		end
	end
	
	prev_qid = now_qid
	now_qid = -1 -- reset
	print("finish read question -- select lowest")
	select_lowest_question()	
	if not isSuccess then
		show_correct_ans(c, e)
	end
end
