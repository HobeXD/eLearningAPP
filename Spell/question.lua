----------------------------------
-- functions deal with questions
-- todo: select color check
--        reconstruct
--         show alert
--         button size interval
--         remember the wrong word
--         pause event
--         sound

--	--table.remove(questions,now_question_id) -- remove entry will make exist entry -1
	--q = nil -- nil is the way to assure to remove entry, but it is not need
--
----------------------------------
local widget = require( "widget" )
local composer = require( "composer" )

local question_score = 10
local penalty_score = -1
local radius = 45
local speed_scale = 1
local yspeed = 2.0
now_question = {}

function initialize_question()
	questions = {} -- now running questions
	prev_question_id = -1
	now_question_id = -1 -- important work
	question_count = 0
	solved_count = 0
	score = 0
	current_question = display.newGroup()

	local ans_text = display.newText("", 100, 50, native.systemFont, 30)
	ans_text:setFillColor(0, 1, 0)
	local ans_text_background = display.newRoundedRect(100, 50, 200, 40, 5)
	ans_text:toFront()
	
	local q_text = display.newText("", 100, 150, native.systemFont, 30)
	
	current_question["text"] = q_text
	current_question["background"] = ans_text_background
	current_question["ans_text"] = ans_text
	tscore = display.newText("score:"..score, 100, 100, native.systemFont, 30)
end
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
	
	-- make button and show button (dup? effect)
	local char_buttons = {}
	for i in pairs(chars) do 
		local button = generate_character_button(chars[i], i)
		button.alpha = 0
		char_buttons[chars[i]] = button
	end	
	
	--create qustion button
	local qbutton_left = math.random(screenLeft, screenRight-100)
	local q_button = widget.newButton
	{
		left = qbutton_left,
		top = screenTop,
		id = question_count,
		label = q_chinese,
		--onPress = touch_question,
		--onRelease = show_select_question,
		onEvent = touch_question,
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
	questions[question_count] = question
	q_button.alpha = 1
	print("question " .. q_chinese .. " id = " .. question_count)
	if now_question_id == -1 then -- if there is no question selected, select lowest
		select_lowest_question()
	end
end

function move_question(event)
	if(questions[now_question_id]) then
		questions[now_question_id]["q_button"]:setFillColor(0.2, 0.7, 1)
	end
	for i in pairs(questions) do
		if questions[i]["solved"] == false then
			local ypos = questions[i]["q_button"].y
			if ypos ~= nil then
				ypos = ypos + yspeed * speed_scale;
				if ( ypos > screenBottom - radius) then
					finish_stage("failed")
					return
				end
				questions[i]["q_button"]:translate(0, ypos - questions[i]["q_button"].y)
			end
		end
	end
end

--on click event 
function check_select_ans( event )
    if ( "ended" == event.phase ) then
		clickchar = event.target:getLabel()
		local q = questions[now_question_id]
		
		ans_len = string.len(q["now_anschar"])
		-- check correctness --> get character from a string is complicated
		if string.sub(q["eng"], ans_len+1, ans_len+1) ~= clickchar then --if q["eng"][ans_len+1] ~= clickchar then --wrong
			score = score + penalty_score
			tscore.text = "score:"..score
			return
		end
		
		q["now_anschar"] = q["now_anschar"] .. event.target:getLabel()
		current_question["ans_text"].text = q["now_anschar"]
		q["char_num"][clickchar] = q["char_num"][clickchar] - 1
		
		print("now ans text = ".. current_question["ans_text"].text)
		
		if q["char_num"][clickchar] == 0 then -- remove the button
			display.remove(q["char_buttons"][clickchar])
		end
		if q["now_anschar"] == q["eng"] then --complete question
			finish_question(q)
		end
    end
end
function finish_question(q)
	print("finish: " .. q["eng"] .. " id = " .. now_question_id)

	score = score + question_score
	tscore.text = "score:"..score
	
	display.remove(q["q_button"])
	for j in pairs(q["char_buttons"]) do
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
		finish_stage("cleared")
	end
		
	prev_question_id = now_question_id
	now_question_id = -1 -- reset
	select_lowest_question()
	--play the sound of vocabulary ... or something
end

function show_question(question)
	for i in pairs(question["char_buttons"]) do
		question["char_buttons"][i].alpha = 1
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

-- find the question that is most likely to make fail
function select_lowest_question() 
	local lowid, lowv
	lowid = -1; lowv = 0
	for i in pairs(questions) do
		if questions[i]["solved"] == false and lowv < questions[i]["q_button"].y then
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
	if now_question_id == id then --no need to update
		return
	end
	prev_question_id = now_question_id
	now_question_id = id
	local q = questions[now_question_id]
	print("select id = ".. now_question_id .. " prev = ".. prev_question_id .. "eng = " .. q["eng"] .. " chi = " .. q["chi"])
	current_question["text"].text = q["chi"];
	current_question["ans_text"].text = q["now_anschar"];
	
	if prev_question_id ~= -1 then -- question need to be hided
		hide_question(questions[prev_question_id])
	end
	show_question(q)
end
function touch_question( event ) --rename select_c
    if event.phase == "began" then
		select_question(event.target.id)
    elseif event.phase == "ended" then
	end
    return true
end

local baseh, basew, wordh, wordw, intevalh, intevalw
baseh = 300; basew = 30; wordh = 40; wordw = 40; intevalh = 10;  intevalw = 20;
function generate_character_button(label, character_button_num) 
	return widget.newButton
	{
		left = basew + (character_button_num%5) * wordw + (character_button_num%5 - 1) * intevalw,
		top = baseh + (math.floor(character_button_num/5)) * wordh + (math.floor(character_button_num/5) - 1) * intevalh,
		id = character_button_num,
		label = label,
		onEvent = check_select_ans,
		-- about shape
		shape = "roundedRect",
		width = 40,
		height = 40,
		cornerRadius = 2,
		fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
--		strokeColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		strokeWidth = 4
	}
end