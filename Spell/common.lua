----------------------------------
-- for some common usage in every level
----------------------------------
local question = require "question"
local composer = require "composer"

screenTop = display.screenOriginY
screenBottom = display.viewableContentHeight + display.screenOriginY
screenLeft = display.screenOriginX
screenRight = display.viewableContentWidth + display.screenOriginX
screenH = display.actualContentHeight
screenW = display.actualContentWidth
screencx = display.contentCenterX
screency = display.contentCenterY

function read_file(filedst)
	local path = system.pathForFile(filedst)
	print("path = " .. path)
	local file = io.open( path, "r" )
	local wordtable = {}
	local lin = file:read( "*l" )
	while lin ~= nil do
		for w,c in string.gmatch(lin, "(%a+) (.+)") do
			local word = {n=2}
			word[1] = w
			word[2] = c
			table.insert(wordtable, word)
		end
		lin = file:read( "*l" )
	end
	
	io.close( file )
	file = nil
	
	return wordtable
end

function show_alert(msg) --customized alert window
	
end 

function pause()
	print("pause")
	--timer.pause(move_timer)
	timer.pause(question_timer)
	transition.pause()  -- pause all
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "fromBottom" , time = 300, params ={levelNum = "level01"}, isModal = true} )
	--disable all buttons(composer helps)
end
function resume()
	print("resume")
	--timer.resume(move_timer)
	timer.resume(question_timer)
	transition.resume() 
	pause_btn.alpha = 1;
	resume_btn.alpha = 0;
	composer.hideOverlay("slideUp", 300)
end

-- ref: http://forums.coronalabs.com/topic/17277-create-a-shake-effect-on-a-object/
function doShake(target, onCompleteDo)
	local thirdTran = function()
		if target.shakeType == "Loop" then
			transition.to(target, {transition = inOutExpo, time = 100, rotation = 0, onComplete = firstTran})
		else
			transition.to(target, {transition = inOutExpo, time = 100, rotation = 0, onComplete = onCompleteDo})
		end
	end
	local secondTran = function()
		transition.to(target, {transition = inOutExpo, time = 100, rotation = -15, onComplete = thirdTran})
	end
	local firstTran = function()
		transition.to(target, {transition = inOutExpo, time = 100, rotation = 15, onComplete = secondTran})
	end

	--Do the first transition
	firstTran()
end 

function finish_level(msg)
	native.showAlert( msg, "score = "..score)
	show_alert(msg)
	
	if msg == "failed" then
		--button
	end
	
	composer.removeScene("level", false)
	composer.gotoScene( "menu", "flip", 500 )
end
