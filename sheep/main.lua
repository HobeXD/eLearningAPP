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

vocNum = 20

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
	[13] = "筆記本",
	[14] = "橡皮擦",
	[15] = "頁",
	[16] = "紙",
	[17] = "筆",
	[18] = "鉛筆",
	[19] = "圖片"
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
	[13] = "notebook",
	[14] = "eraser",
	[15] = "page",
	[16] = "paper",
	[17] = "pen",
	[18] = "pencil",
	[19] = "picture"
}