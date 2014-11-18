local widget = require( "widget" )

-- initial global variables for solving the problem
buttons = {}
clickword = ""
ans_len = 0
q_engligh = ""
character_button_num = -1
score = 0
problem_count = 0
QuestionGroup = display.newGroup()
--q_content


function initialize_problem()
	ans_text = display.newText(clickword, 100, 50, native.systemFont, 30)
	ans_text:setFillColor( 0,0,0 )

	q_text = display.newText("", 100, 150, native.systemFont, 30)
	q_background = display.newRoundedRect(100, 50, 200, 40, 5)
	
	q_content = display.newGroup()
	q_content:insert(q_background)
	q_content:insert(q_text)
	q_content:insert(ans_text)
	
	tscore = display.newText("score:"..score, 100, 100, native.systemFont, 30)
end

function reset_problem ()
	clickword = ""
	ans_text.text = ""
	q_text.text = ""
	ans_len = 0
	character_button_num = -1
end

function generate_new_problem()
	reset_problem ()
	
	-- random choose a word, which is not solved yet
	problem_count = problem_count + 1
	print("problem count =".. problem_count)
	if problem_count == #words then
		print("all problem solved!")
		display.newText("all problem solved!", 150, 200, native.systemFont, 30)
		native.showAlert( "complete", "score = "..score)
		-- exit
		-- show score board
		return
	end
	qindex = math.random(#words)
	while dup_problem[qindex] == true do
		qindex = math.random(#words)
	end

	dup_problem[qindex] = true
	q_engligh = words[qindex][1]
	q_chinese = words[qindex][2]
	q_text.text = q_chinese
	

	--q_button:addEventListener("enterFrame", move_question)
	--q_button:addEventListener("timer", move_question)
	--timer.performWithDelay( 1000, move_question, 0 )

	--build characters table
	char_num = {}
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
	for i in pairs(chars) do 
		local button = generate_character_button(chars[i])
		buttons[chars[i]] = button
		--print(chars[i])
	end	
	
end

--on click event (change color, new char in ans sheet, vanish on success , wrong event, )
local function click_event( event )
    if ( "ended" == event.phase ) then
	print("add to ans q_engligh = " .. q_engligh)
		clickvalue = event.target:getLabel()
		-- check correctness -- i don't know how to get character from a string...
		if string.sub(q_engligh, ans_len+1, ans_len+1) ~= clickvalue then 
			print("" .. string.sub(q_engligh, ans_len+1, ans_len+1) .. "!=" .. clickvalue .. "not the same!")
			-- add error penalty , like score ....
			score = score -1
			tscore.text = "score:"..score
			return
		end
		clickword = clickword .. event.target:getLabel()
		print(clickword)
		ans_text.text = clickword
		ans_len = ans_len + 1
		char_num[clickvalue] = char_num[clickvalue] - 1
		if char_num[clickvalue] == 0 then -- remove the button
			display.remove(buttons[clickvalue])
		end
		if clickword == q_engligh then
			print("complete" .. q_engligh)
			score = score + 10
			tscore.text = "score:"..score
			--play the sound of vocabulary ... or something
			generate_new_problem()
		end
    end
end

local baseh, basew, wordh, wordw, intevalh, intevalw
baseh = 300; basew = 30; wordh = 40; wordw = 40; intevalh = 10;  intevalw = 20;
function generate_character_button(label) 
	character_button_num = character_button_num + 1
	return widget.newButton
	{
		left = basew + (character_button_num%5) * wordw + (character_button_num%5 - 1) * intevalw,
		top = baseh + (math.floor(character_button_num/5)) * wordh + (math.floor(character_button_num/5) - 1) * intevalh,
		id = character_button_num,
		label = label,
		onEvent = click_event,
		-- about shape
		shape = "roundedRect",
		width = 40,
		height = 40,
		cornerRadius = 2,
		fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		strokeColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
		strokeWidth = 4
	}
end