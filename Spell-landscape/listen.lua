local widget = require "widget"
-------------
-- Listen.lua, for listening stage
------------
-- refactor: question, reading, listening(ok)
-- bug: ���ɦW �M ��r�����P (ok)
-- refactor : main status in question.lua (gamedata)
-- bug:audio play oncomplete �i��O�����H(not effected)
-- bug:���F�H��˼��~��(ok)
-- bug:�Ȱ���˼ư��D(��n��ɰ���) (ok)
-- ����listen�^��bgm (ok)
-- generate_new_question_read(sceneGroup, levelName) �ѼƳ] global (ok)
-- bug: read���~�᪽������(ok)
-- bug:���ĤG���᪺ (�ثe�S��)
-- bug:����n���j�p
-- gamedata.lua -- self. �ݭn��
-- add sound player at wrong-answer scene
-- delete all print()
-- score object

-- audio.loadSound �|�N��ӭ��W���J�O����, �A�Ω���u�B�i�୫�ƨϥΪ�����
-- audio.loadStream �@���u���J�@�q���W, �A�Ω�I�����ֳo�ظ���������, ����Y CPU �B���i�ੵ��

local countDownTime = 20

local listenQuestion = {}
local playing_q_button

function generate_new_question_listen() 
	is_generate_question = true

	local q_engligh, q_chinese = getNewQuestionInfo()
	if(q_engligh == nil) then -- no available question 
		return
	end
	
	local listen_button = createSoundButton(screencx-27, screenTop)
	nowSceneGroup:insert(listen_button)
	
	listenQuestion["eng"] = q_engligh
	listenQuestion["chi"] = q_chinese
	listenQuestion["q_button"] = listen_button
	listenQuestion["question_count"] = question_count --id
	listenQuestion["solved"] = false
	listenQuestion["wrong_trial"] = 0
	listenQuestion["count_down"] = countDownTime
	
	fillHint(listenQuestion)
	
	questions[question_count] = listenQuestion
	listen_button.alpha = 1
	
	changeImageAndPlayVocaSound()
	
	print("ans = " .. listenQuestion["eng"])
	select_question_listen(question_count)
	
	countDownText.text = listenQuestion["count_down"]
	countDownTimer = timer.performWithDelay(1000,countDown,-1)
	
	is_generate_question = false
end

function createSoundButton(left, top)
	local listen_button = widget.newButton
	{
		onPress = changeImageAndPlayVocaSound,
		id = question_count,
		left = left,
		top = top,
		defaultFile = "img/no_sound.png",
		overFile = "img/no_sound.png",
		width = 54,
		height = 100,
		alpha = 0
	}
	return listen_button
end

function changeImageAndPlayVocaSound(event)
	if audio.isChannelActive(vocaSoundChannel) then
		print("channel is already playing")
		return
	end
	
	print("changeImageAndPlayVocaSound")
	listenQuestion["q_button"].alpha = 0
	playing_q_button = widget.newButton
	{
		id = question_count,
		left = screencx-23.5,
		top = screenTop,
		defaultFile = "img/sound.png",
		overFile = "img/sound.png",
		width = 95,
		height = 100
	}
	listenQuestion["playing_q_button"] = playing_q_button
	nowSceneGroup:insert(playing_q_button)
	
	playVocaSound(recoverListenButton)
end
function recoverListenButton(event)
	print("recover listen")
	if event.completed == false then
		print("not fully play yet")
		return
	end
	display.remove(playing_q_button)
	listenQuestion["q_button"].alpha = 1
end


function countDown()
	if listenQuestion["count_down"] == nil or check_pause() then
		return
	end
	listenQuestion["count_down"] = listenQuestion["count_down"] - 1
	countDownText.text = listenQuestion["count_down"]
	if(listenQuestion["count_down"] == 0) then
		print("time up")
		timer.cancel(countDownTimer)
		question_failed(listenQuestion)
	end
end

function select_question_listen(id)
	--not use in listen?
	--[[if check_pause() then
		return
	end]]
	if now_qid == id then --no need to update
		return
	end
	prev_qid = now_qid
	now_qid = id
	local q = questions[now_qid]
	--print("select id = ".. now_qid .. " prev = ".. prev_qid .. "eng = " .. q["eng"] .. " chi = " .. q["chi"])
	--current_question["text"].text = q["chi"];
	current_question["ans_sheet"].text = q["now_anschar"];
	
	--[[if prev_qid ~= -1 then -- question need to be hided
		hide_question(questions[prev_qid])
	end]]
	--show_question(q)
end

function finish_question_listen(q, isSuccess)
	-- remove all data relate to this question
	print("finish_question_listen")
	local c = q["chi"]
	local e = q["eng"]
	display.remove(q["q_button"])
	display.remove(q["playing_q_button"])
	for j in pairs(q) do
		while q[j] ~= nil do
			q[j] = nil
		end
	end
	
	prev_qid = now_qid
	now_qid = -1 -- reset
	
	timer.cancel(countDownTimer)
	audio.stop(vocaSoundChannel)
	print("finish listen question")
	if not isSuccess then
		show_correct_ans(c, e)
	end
	generate_new_question_listen()
end