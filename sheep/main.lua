-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )

--vocNum = 20
vocNum = 19

question = {
	[0] = "禮物",
	[1] = "尺",
	[2] = "作業本",
	[3] = "教室",
	[4] = "操場",
	[5] = "圖書館",
	[6] = "班級",
	[7] = "黑板",
	[8] = "書",
	[9] = "粉筆",
	[10] = "字典",
	[11] = "信",
	[12] = "地圖",
	--[19] = "筆記本",
	[13] = "橡皮擦",
	[14] = "頁",
	[15] = "紙",
	[16] = "筆",
	[17] = "鉛筆",
	[18] = "圖片"
}

answer = {
	[0] = "present",
	[1] = "ruler",
	[2] = "workbook",
	[3] = "classroom",
	[4] = "playground",
	[5] = "library",
	[6] = "class",
	[7] = "blackboard",
	[8] = "book",
	[9] = "chalk",
	[10] = "dictionary",
	[11] = "letter",
	[12] = "map",
	--[19] = "notebook",
	[13] = "eraser",
	[14] = "page",
	[15] = "paper",
	[16] = "pen",
	[17] = "pencil",
	[18] = "picture"
}