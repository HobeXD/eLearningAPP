local widget = require "widget"
-------------
-- reading.lua, for reading stage
------------

questionMoveSpeed = 0.3
speed_scale = 1
radius = 50

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
		generate_new_question()
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
