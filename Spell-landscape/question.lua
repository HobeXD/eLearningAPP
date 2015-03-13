----------------------------------
-- functions deal with vocabulary questions
----------------------------------
--need more visual design
	--inner alert, pause event, button size interval
	--complete effect 
		-- ans_sheet flip
	-- correct effect
		-- enlarge ans
	-- failed effect
		--like a certain music game(?)
	-- score effect
		--keep-adding effect
	-- (dup? effect)
-- game design    
	--challenge question (bonus)
	--item(tap to collect)(how to use?)
	--remember wrong words
	--add wrong choices
-- code refactor

--	--table.remove(questions,now_qid) -- remove entry will make exist entry -1
	--q = nil -- nil is the way to assure to remove entry, but it is not need
----------------------------------
local widget = require "widget"
local composer = require "composer"
local common = require "common"
nowSceneGroup = display.newGroup()

question_score = 10
char_score = 1
penalty_score = 1
now_wrong_num = 0
countDownTime = 20

local radius = 50
local speed_scale = 1
local speed = 0.3
local finish_question_num = 15
local max_wrong_question_num = 3
local empty_char_num = 5
local alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUWXYZ' -- used in isalpha

local finish_sound = audio.loadSound( "sound/pass.wav" )
local failed_sound = audio.loadSound( "sound/failed.wav" )
local suc_sound = audio.loadSound( "sound/sound_laser.wav" )

now_question = {}
local is_generate_question = false

function isalpha(ch)	
	local is_alpha = false
	for i = 1, #alphabet do
		if alphabet:sub(i, i) == ch then
			is_alpha = true
			break
		end
	end
	return is_alpha
end

-- There are shared functions of reading and listening
function fillHint(question)
	local is_have_nonalpha = 0
	for char in string.gmatch(question["eng"], '.') do
		if not isalpha(char) then
			is_have_nonalpha = is_have_nonalpha + 1
		end
	end
	if string.len(question["eng"]) > empty_char_num or is_have_nonalpha then
		question["withspace"] = true
		question["now_anschar"] = ""
		local isfill = {}
		local isfill_num = is_have_nonalpha
		
		while isfill_num < string.len(question["eng"]) - empty_char_num do
			local tofill = math.random(string.len(question["eng"]))
			while (isfill[tofill] == 1) do
				tofill = math.random(string.len(question["eng"]))
			end
			isfill[tofill] = 1
			isfill_num = isfill_num + 1
		end
		for i = 1, string.len(question["eng"]) do 
			if isfill[i] == nil and isalpha(question["eng"]:sub(i, i)) then
				question["now_anschar"] = question["now_anschar"] .. "*";
			else
				question["now_anschar"] = question["now_anschar"] .. question["eng"]:sub(i, i);
			end
		end
	else 
		question["withspace"] = false
		question["now_anschar"] = ""
	end
end
function getNewQuestion()
	if question_count > finish_question_num + max_wrong_question_num or question_count == #words then --make some flag
		print("all question generated!, stop generate")
		return
	end
	question_count = question_count + 1
	qindex = math.random(#words) --todo: use list 
	while dup_question[qindex] == true do
		qindex = math.random(#words)
	end

	dup_question[qindex] = true
	return words[qindex][1], words[qindex][2]
end

function generate_new_question(sceneGroup) -- random choose a word, which is not solved yet
	is_generate_question = true
	if sceneGroup ~= nil then
		nowSceneGroup = sceneGroup
	end

	local q_engligh, q_chinese = getNewQuestion()
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
		--onPress = select_char,
		--onRelease = show_select_question,
		onEvent = select_char,
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
				xpos = xpos + speed * speed_scale;
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
		generate_new_question()
	end
end

function show_correct_ans(c, e) -- put at the end to prevent below code do not run
	pause_with_ans(c, e)
end
function check_pause_and_finish()
	if not check_pause() then
		print("user comfirmed ok")
		timer.cancel(comfirm_timer)
		finish_level("Fail")
	else
		print("no ok, wait")
	end
end
function question_failed(q)
	audio.play(failed_sound)
	score = score - question_score
	score_text.text = score
	now_wrong_num = now_wrong_num + 1
	local c = q["chi"]
	local e = q["eng"]
	if now_wrong_num >= max_wrong_question_num then
		show_correct_ans(c, e)
		check_pause_and_finish()
		comfirm_timer = timer.performWithDelay(100, check_pause_and_finish, 0)
		return
	end
	finish_question(q)
	show_correct_ans(c, e)
end
function question_success(q)
	audio.play(finish_sound)
	score = score + question_score
	score_text.text = score

	q["solved"] = true
	solved_count = solved_count + 1
	if solved_count == finish_question_num or question_count == #words then 
		finish_level("Clear!")
		return
	end
	finish_question(q)
end
function finish_question(q)
	display.remove(q["q_button"])
	for j in pairs(q) do
		while q[j] ~= nil do
			q[j] = nil
		end
	end
	
	prev_qid = now_qid
	now_qid = -1 -- reset
	print("finish question -- select lowest")
	select_lowest_question()	
end

function check_pause() 
	if ispause then
		return true
	else
		return false
	end
end
function select_char( event ) --rename select_c
    if event.phase == "began" then
		select_question(event.target.id)
    elseif event.phase == "ended" then
	end
    return true
end
--on click event 

function remove_self()
	
--	target = nil
	--event.target = nil
end
function replace_char(pos, str, r)
    return str:sub(0, pos - 1) .. r .. str:sub(pos + 1, str:len())
end

function check_select_ans( event )
	if check_pause() then
		return
	end
    if ( "ended" == event.phase ) then
		clickchar = event.target:getLabel()
		local q = questions[now_qid]
		
		if q == nil then
			return
		end
		
		if q["withspace"] then
			ans_len = 1
			while q["now_anschar"]:sub(ans_len, ans_len) ~= "*" do
				ans_len = ans_len+1
			end
			ans_len = ans_len - 1
			print ("withspace len = " .. ans_len)
		else
			ans_len = string.len(q["now_anschar"])
		end
		-- if wrong
		if string.sub(q["eng"], ans_len+1, ans_len+1) ~= clickchar and string.lower(string.sub(q["eng"], ans_len+1, ans_len+1)) ~= clickchar then --if q["eng"][ans_len+1] ~= clickchar then 
			doShake(event.target, nil)
			
			char_score = 1
			score = score - penalty_score
			penalty_score = penalty_score + 1
			score_text.text = score
			q["wrong_trial"] = q["wrong_trial"] + 1
			if q["wrong_trial"] >= 3 then
				question_failed(q)
			end
			return
		end
		--after assure to be success
		--update_score(true, )
		penalty_score = 1
		score = score + char_score
		char_score = char_score + 1
		score_text.text = score

		if q["withspace"] then -- ADD correct case(big or small)
			q["now_anschar"] = replace_char(ans_len+1, q["now_anschar"], string.sub(q["eng"], ans_len+1, ans_len+1))
		else
			q["now_anschar"] = q["now_anschar"] .. event.target:getLabel()
		end
		current_question["ans_sheet"].text = q["now_anschar"]
		
		if (correct_star ~= nil) then
			display.remove(correct_star)
		end
		correct_star = display.newImage(nowSceneGroup, "img/star.png", qwerty_btns[clickchar].x, qwerty_btns[clickchar].y)
		correct_star.xScale = 0.00001
		correct_star.yScale = 0.00001
		correct_star.anchorX = 0.5
		correct_star.anchorY = 0.5
		-- trans to screenLeft, barH
		transition.to( correct_star , { time=600, x = screenLeft + barh/2, y = barH + barh/2, xScale=star_scale_rate, yScale=star_scale_rate, alpha = 0.5, transition = outExpo, onComplete = remove_self} )
		
		if q["now_anschar"] == q["eng"] then --complete question
			question_success(q)
		end
    end
end

-- find the question that is most likely to make fail
function select_lowest_question() 
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
		select_question(lowid)
	else  -- generate new question, reset timer
		--if question_timer ~= nil then
			--timer.cancel(question_timer)
		--end
		if not is_generate_question then	
			generate_new_question()
		end
		--question_timer = timer.performWithDelay(generate_question_time, generate_new_question, 0)
	end
end
function select_question(id)
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
