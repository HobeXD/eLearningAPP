local widget = require "widget"
-------------
-- Listen.lua, for listening stage
------------
-- refactor: question, reading, listening
-- add sound player at wrong-answer scene
-- 音檔名 和 單字的不同
-- refactor : main status in question.lua
-- bug:audio play oncomplete 可能是取消？(not effected)
-- bug:錯了以後倒數繼續(ok)
-- bug:玩第二次後的
-- bug:對錯聲音大小
-- bug:暫停後倒數問題(剩n秒時停止) (ok)
-- gamedata.lua -- self. 需要嗎

local countDownTime = 20

local nowVocaSound
local listenQuestion = {}
local playing_q_button
function recoverListenButton()
	print("recover listen")
	display.remove(playing_q_button)
	listenQuestion["q_button"].alpha = 1
end
function playVocaSound(event)
	if audio.isChannelActive(vocaSoundChannel) then
		print("channel is already playing")
		return
	end
	isPlayingSound = true
	print("playsound")
	listenQuestion["q_button"].alpha = 0
	playing_q_button = widget.newButton
	{
		id = question_count,
		left = screencx-80,
		top = screenTop,
		defaultFile = "img/sound.png",
		overFile = "img/sound.png",
		width = 95,
		height = 100
	}
	listenQuestion["playing_q_button"] = playing_q_button
	nowSceneGroup:insert(playing_q_button)
	
	audio.play(nowVocaSound, {channel = vocaSoundChannel, onComplete = recoverListenButton})
	if check_pause() then
		print(" pause, so audio pause")
		audio.pause(vocaSoundChannel)
	end
end
function generate_new_question_listen(sceneGroup, levelName) 
	is_generate_question = true
	if sceneGroup ~= nil then
		nowSceneGroup = sceneGroup
	end
	nowLevelName = levelName

	local q_engligh, q_chinese = getNewQuestionInfo()
	if(q_engligh == nil) then -- no available question 
		return
	end
	
	local q_button = widget.newButton
	{
		onPress = playVocaSound,
		id = question_count,
		left = screencx-80,
		top = screenTop,
		defaultFile = "img/no_sound.png",
		overFile = "img/no_sound.png",
		width = 54,
		height = 100,
		alpha = 0
	}
	nowSceneGroup:insert(q_button)
	
	listenQuestion["eng"] = q_engligh
	listenQuestion["chi"] = q_chinese
	listenQuestion["q_button"] = q_button
	listenQuestion["question_count"] = question_count --id
	listenQuestion["solved"] = false
	listenQuestion["wrong_trial"] = 0
	listenQuestion["count_down"] = countDownTime
	
	fillHint(listenQuestion)
	
	questions[question_count] = listenQuestion
	q_button.alpha = 1
	
	print("pronounce/"  ..levelName  .. "/" .. listenQuestion["eng"] ..".mp3")
	nowVocaSound = audio.loadStream("pronounce/"  ..levelName  .. "/" .. listenQuestion["eng"] ..".mp3")
	playVocaSound()
	
	print("ans = " .. listenQuestion["eng"])
	select_question_listen(question_count)
	
	countDownText.text = listenQuestion["count_down"]
	countDownTimer = timer.performWithDelay(1000,countDown,-1)
	
	is_generate_question = false
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
	generate_new_question_listen(nowSceneGroup, nowLevelName)
end