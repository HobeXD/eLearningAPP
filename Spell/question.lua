----------------------------------
-- functions deal with questions

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
	--question["wrong_trial"] 
	-- question["consume_time"] 
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

local question_score = 10
local penalty_score = -1

local radius = 45
local speed_scale = 1
local yspeed = 1.0

now_question = {}
	
function generate_new_question()
	-- random choose a word, which is not solved yet
	if question_count == #words then --make some flag
		print("all question generated!, stop generate")
		timer.cancel(question_timer) --stop timer
		return
	end
	question_count = question_count + 1
	print("question count =".. question_count)
	
	qindex = math.random(#words)
	while dup_question[qindex] == true do
		qindex = math.random(#words)
	end

	dup_question[qindex] = true
	local q_engligh = words[qindex][1]
	local q_chinese = words[qindex][2]

	--build characters table
	local char_num = {}
	local chars = {}
	for char in string.gmatch(q_engligh, '.') do
		if char_num[char] == nil then
			table.insert(chars, char)
			char_num[char] = 1;
		else  
			char_num[char] = char_num[char] + 1;
		end
	end
	
	-- shuffle chars - Algorithm P
	for i = #chars, 2, -1 do -- if means (i = num of chars, i >= 2, i--)
		local ci = math.random(i) -- from 1 to i
		local tmp = chars[i]
		chars[i] = chars[ci]
		chars[ci] = tmp
	end
	
	-- make button and show button 
	local char_buttons = {}
	for i in pairs(chars) do 
		local button = generate_character_button(chars[i], i)
		button.alpha = 0
		button.anchorX = 0.5
		button.anchorY = 0.5
		char_buttons[chars[i]] = button
		sceneGroup:insert(button)
	end	
	
	--create qustion button
	local qbutton_left = math.random(screenLeft, screenRight-100)
	local q_button = widget.newButton
	{
		left = qbutton_left,
		top = screenTop,
		id = question_count,
		label = q_chinese,
		--onPress = select_char,
		--onRelease = show_select_question,
		onEvent = select_char,
		-- about shape
		shape = "roundedRect",
		width = 100,
		height = 100,
		cornerRadius = 2,
		fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		labelColor = { default={ 1, 1,1,1 }, over={ 1, 0.2, 0.5, 1 } },
		strokeWidth = 4, 
		fontSize = 30, 
		alpha = 0
	}
	sceneGroup:insert(q_button)
	
	print("num of questions = ".. #questions)
	--Runtime:addEventListener("enterFrame", move_question)

	local question = {} -- include data about a question
	question["eng"] = q_engligh
	question["chi"] = q_chinese
	question["char_buttons"] = char_buttons
	question["char_num"] = char_num
	question["chars"] = chars
	question["now_anschar"] = ""
	question["q_button"] = q_button
	question["question_count"] = question_count --id
	question["solved"] = false
	question["wrong_trial"] = 0
	question["consume_time"] = 0
	
	questions[question_count] = question
	q_button.alpha = 1
	print("question " .. q_chinese .. " id = " .. question_count)
	if now_qid == -1 then -- if there is no question selected, select lowest
		select_lowest_question()
	end
end
function move_question(event) --now fps is 60 (in config.lua)
	if check_pause() then --busy running
		return
	end
	if(questions[now_qid]) then
		questions[now_qid]["q_button"]:setFillColor(0.2, 0.7, 1)
	end
	--[[local circle = display.newCircle( 100, 100, 40 )
	circle:setFillColor( 0, 0, 1 )
	transition.to( circle, { time=400, y=200, transition=easing.inExpo } )]]
	--transition.from( current_question["background"], { time=400, y=current_question["background"].y-1, transition=easing.inExpo } )
	
	for i in pairs(questions) do
		if questions[i]["solved"] == false then
			local ypos = questions[i]["q_button"].y
			if ypos ~= nil then
				ypos = ypos + yspeed * speed_scale;
				if ( ypos > screenBottom - radius) then
					finish_level("failed")
					return
				end
				questions[i]["q_button"]:translate(0, ypos - questions[i]["q_button"].y)
			end
		end
	end
end

function finish_question(q)
	print("finish: " .. q["eng"] .. " id = " .. now_qid)

	score = score + question_score
	tscore.text = "score:"..score
	
	display.remove(q["q_button"])
	for j in pairs(q["char_buttons"]) do --feasible?
		while q["char_buttons"][j] ~= nil do
			q["char_buttons"][j]:removeSelf()
			q["char_buttons"][j] = nil
		end
	end			

	for j in pairs(q) do
		while q[j] ~= nil do
			q[j] = nil
		end
	end
	
	q["solved"] = true
	solved_count = solved_count + 1
	if solved_count == #words then 
		finish_level("cleared")
	end
		
	prev_qid = now_qid
	now_qid = -1 -- reset
	select_lowest_question()
	--play the sound of vocabulary ... or something
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
function check_select_ans( event )
	if check_pause() then
		return
	end
    if ( "ended" == event.phase ) then
		clickchar = event.target:getLabel()
		local q = questions[now_qid]
		
		ans_len = string.len(q["now_anschar"])
		-- check correctness --> get character from a string is complicated
		if string.sub(q["eng"], ans_len+1, ans_len+1) ~= clickchar then --if q["eng"][ans_len+1] ~= clickchar then --wrong
			score = score + penalty_score
			tscore.text = "score:"..score
			doShake(event.target, nil)
			-- error sound
			return
		end
		
		local suc_sound = audio.loadSound( "science_fiction_laser_002.mp3" )
		audio.setVolume(0.5)
		audio.play(suc_sound)
		
		q["now_anschar"] = q["now_anschar"] .. event.target:getLabel()
		current_question["ans_sheet"].text = q["now_anschar"]
		q["char_num"][clickchar] = q["char_num"][clickchar] - 1
		
		print("now ans text = ".. current_question["ans_sheet"].text)
		
		if q["char_num"][clickchar] == 0 then -- remove the button
			display.remove(q["char_buttons"][clickchar])
			q["char_buttons"][clickchar] = nil
		end
		if q["now_anschar"] == q["eng"] then --complete question
			finish_question(q)
		end
    end
end

-- find the question that is most likely to make fail
function select_lowest_question() 
	local lowid, lowv
	lowid = -1; lowv = screenTop
	for i in pairs(questions) do
		if questions[i]["solved"] == false and lowv <= questions[i]["q_button"].y then
			lowv = questions[i]["q_button"].y
			lowid = i
		end
	end
	
	if lowid ~= -1 then
		print("select lowest " .. lowid)
		select_question(lowid)
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
	print("select id = ".. now_qid .. " prev = ".. prev_qid .. "eng = " .. q["eng"] .. " chi = " .. q["chi"])
	--current_question["text"].text = q["chi"];
	current_question["ans_sheet"].text = q["now_anschar"];
	
	if prev_qid ~= -1 then -- question need to be hided
		hide_question(questions[prev_qid])
	end
	show_question(q)
end

function show_question(question)
	for i in pairs(question["char_buttons"]) do
		question["char_buttons"][i].alpha = 1
		question["char_buttons"][i]:toFront()
	end
end	
function hide_question(question)
	if question == nil then
		return
	end
	for i in pairs(question["char_buttons"]) do
		question["char_buttons"][i].alpha = 0
	end
	question["q_button"]:setFillColor(1, 0.2, 0.5, 0.7)
end

-- Apple says that the avg finger tap is 44x44 (from WWDC). All table rows are recommended to be at least that height. It is common for icons to appear 32x32, but have padding to make the touchable area 44x44.
local baseh, basew, wordh, wordw, intevalh, intevalw
baseh = 300; basew = 30; wordh = 50; wordw = 50; intevalh = 10;  intevalw = 10;
function generate_character_button(label, character_button_num) -- char btn num start from 1
	return widget.newButton
	{
		left = basew + ((character_button_num-1)%5) * wordw + ((character_button_num-1)%5) * intevalw,
		top = baseh + (math.floor((character_button_num-1)/5)) * wordh + (math.floor((character_button_num-1)/5)) * intevalh,
		id = character_button_num,
		label = label,
		onEvent = check_select_ans,
		-- about shape
		shape = "roundedRect",
		width = 50,
		height = 50,
		cornerRadius = 5,
		fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
--		strokeColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		--strokeWidth = 4
	}
end