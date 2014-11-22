----------------------------------
-- for some common usage in every level
----------------------------------
local question = require "question"
local composer = require "composer"

screenTop = display.screenOriginY
screenBottom = display.viewableContentHeight + display.screenOriginY
screenLeft = display.screenOriginX
screenRight = display.viewableContentWidth + display.screenOriginX

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

function finish_stage(msg)
	native.showAlert( msg, "score = "..score)
	show_alert(msg)
	composer.removeScene("level", false)
	composer.gotoScene( "menu", "flip", 500 )
end
