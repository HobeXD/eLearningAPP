----------------------------------
-- functions deal with vocabulary questions
-- I want to change it into OOP code for reading and listening, but it is too time-wasting
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

--	--table.remove(questions,now_qid) -- remove entry will make exist entry -1
	--q = nil -- nil is the way to assure to remove entry, but it is not need
----------------------------------
local widget = require "widget"
local composer = require "composer"
local common = require "common"
nowSceneGroup = display.newGroup()
nowLevelName = ""

question_score = 10
char_score = 1
penalty_score = 1
now_wrong_num = 0
countDownTime = 20



local finish_question_num = 15
local max_wrong_question_num = 3
local empty_char_num = 5

local finish_sound = audio.loadSound( "sound/pass.wav" )
local failed_sound = audio.loadSound( "sound/failed.wav" )

now_question = {}
local is_generate_question = false

-- There are shared functions of reading and listening
local function checkIsHaveNonalpha(question)
	local isfill_num = 0
	for char in string.gmatch(question["eng"], '.') do
		if not isalpha(char) then
			isfill_num = isfill_num + 1
		end
	end
	return isfill_num > 0, isfill_num
end
function fillHint(question)
	local is_have_nonalpha, isfill_num = checkIsHaveNonalpha(question)
	
	question["now_anschar"] = ""
	local isfill = {}
	
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
end
function getNewQuestionInfo()
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

local function updateProblemScore(isCorrect)
	if isCorrect then
		score = score + question_score
		score_text.text = score
	else 
		score = score - question_score
		score_text.text = score
		now_wrong_num = now_wrong_num + 1
	end
end
local function updateScore(isCorrect)
	if isCorrect then
		penalty_score = 1 -- reset penalty score
		score = score + char_score
		char_score = char_score + 1
		score_text.text = score
	else 
		char_score = 1
		score = score - penalty_score
		penalty_score = penalty_score + 1
		score_text.text = score
	end
end

function show_correct_ans(c, e) -- put at the end to prevent below code do not run
	pause_with_ans(c, e)
end
local function check_pause_and_finish() -- for last wrong answer, it should pause instead of goto show score imeediately
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
	updateProblemScore(failed)
	local c = q["chi"]
	local e = q["eng"]
	if now_wrong_num >= max_wrong_question_num then
		show_correct_ans(c, e)
		check_pause_and_finish()
		comfirm_timer = timer.performWithDelay(100, check_pause_and_finish, 0)
		return
	end
	finish_question(q, failed)
end
function question_success(q)
	audio.play(finish_sound)
	updateProblemScore(success)

	q["solved"] = true
	solved_count = solved_count + 1
	if solved_count == finish_question_num or question_count == #words then 
		finish_level("Clear!")
		return
	end
	finish_question(q ,success)
end

local finish_question -- can be overwritten by listen.lua or read.lua

function replace_char(pos, str, r)
    return str:sub(0, pos - 1) .. r .. str:sub(pos + 1, str:len())
end
function showCorrectStar()
	local correct_star = display.newImage(nowSceneGroup, "img/star.png", qwerty_btns[clickchar].x, qwerty_btns[clickchar].y)
	correct_star.xScale = 0.00001; correct_star.yScale = 0.00001; correct_star.anchorX = 0.5; correct_star.anchorY = 0.5
	
	nowSceneGroup:insert(correct_star)
	
	transition.to( correct_star , { time=600, x = screenLeft + barh/2, y = barH + barh/2, xScale=star_scale_rate, yScale=star_scale_rate, alpha = 0.5, transition = outExpo, onComplete = function(obj) display.remove(obj) end} )
end
function check_select_ans( event ) -- qwerty onpress event 
	if check_pause() then
		return
	end
    if ( "ended" == event.phase ) then
		clickchar = event.target:getLabel()
		local q = questions[now_qid]
		
		if q == nil then
			return
		end
	
		ans_len = 1
		while q["now_anschar"]:sub(ans_len, ans_len) ~= "*" do
			ans_len = ans_len+1
		end
		ans_len = ans_len - 1
		print ("withspace len = " .. ans_len)
	
		-- if wrong
		if string.sub(q["eng"], ans_len+1, ans_len+1) ~= clickchar and string.lower(string.sub(q["eng"], ans_len+1, ans_len+1)) ~= clickchar then --if q["eng"][ans_len+1] ~= clickchar then 
			doShake(event.target, nil)
			
			updateScore(failed)
			q["wrong_trial"] = q["wrong_trial"] + 1
			if q["wrong_trial"] >= 3 then
				question_failed(q)
			end
			return
		end
		--after assure to be success
		updateScore(success)
		
		-- ADD correct case(big or small)
		q["now_anschar"] = replace_char(ans_len+1, q["now_anschar"], string.sub(q["eng"], ans_len+1, ans_len+1))

		current_question["ans_sheet"].text = q["now_anschar"]
		
		showCorrectStar()
		
		if q["now_anschar"] == q["eng"] then --complete question
			question_success(q)
		end
    end
end
