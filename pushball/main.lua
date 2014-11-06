display.setStatusBar (display.HiddenStatusBar)
--> Hides the status bar

local director = require ("director")
--> Imports director

local mainGroup = display.newGroup()
--> Creates a main group
name = "Anonymous"
function chname(n)
	name = n
end


local path = system.pathForFile( "score.txt", system.DocumentsDirectory )
print(path)
local file

function nL( event )
	if ( event.isError ) then
        print( "Network error!")
    else
		print ( "RESPONSE: " .. event.response )
		if event.response == "Accept" then
			file = io.open( path, "w" )
			io.close(file)
		end
	end
end
function nL2( event )
	if ( event.isError ) then
        print( "Network2 error!")
    else
		print ( "RESPONSE2: " .. event.response )
	end
end

local musicOpen = 1
stageNumStage = 1
stageNumQuest = 1
maxStage = 1
maxQuest = 1
globlex = 0
score = {}
totleScore = {0,0,0,0,0}
scoreGate = {15,15,20,20, 0}

local params = {}
local params2 = {}
function store(value)
	file = io.open( path, "a" )
	file:write(value)
	io.close(file)
	file = io.open( path, "r" )
	local con = file:read("*a")
	io.close(file)
	params.body = "value="..con
	--network.request( "http://w.csie.org/~b99902113/work/pushball.php", "POST", nL, params)
	network.request( "http://web.ntnu.edu.tw/~699210745/app/app.php", "POST", nL, params)
	local nowProc = maxStage*100 + maxQuest
	if maxQuest == 99 then
	nowProc = nowProc - 89
	end
	local nowStar = totleScore[1]+totleScore[2]+totleScore[3]+totleScore[4]+totleScore[5]
	params2.body = "name="..name.."&proc="..nowProc.."&star="..nowStar
	network.request( "http://web.ntnu.edu.tw/~699210745/app/saveRank.php", "POST", nL2, params2)
end

store("")

rankStr = ""
function chRank(x)
	rankStr = x
end

function save()
	local savePath = system.pathForFile( name..".sav", system.DocumentsDirectory )
	local savFile = io.open( savePath, "w" )

	savFile:write(maxStage, "\n", maxQuest, "\n")
	for i = 1, 5 do
		totleScore[i] = 0
		for j = 1, 10 do
			totleScore[i] = totleScore[i] + score[i*100 + j]
			if not score[i*100 + j] then score[i*100 + j] = 0 end
			savFile:write(score[i*100 + j], "\n")
		end
	end
	io.close(savFile)
	
	savePath = system.pathForFile( "system", system.DocumentsDirectory )
	savFile = io.open( savePath, "w" )

	savFile:write(name, "\n", musicOpen, "\n")
	io.close(savFile)
	if maxQuest == 99 and totleScore[maxStage] >= scoreGate[maxStage] then
		maxStage = maxStage + 1
		maxQuest = 1
		save()
	end
end

function saveSys()	
	local savePath = system.pathForFile( "system", system.DocumentsDirectory )
	local savFile = io.open( savePath, "w" )

	savFile:write(name, "\n", musicOpen, "\n")
	io.close(savFile)
	
end

function load()
	local savePath = system.pathForFile( "system", system.DocumentsDirectory )
	local savFile = io.open( savePath, "r" )
	
	if savFile then
		name = savFile:read("*l")
		musicOpen =  savFile:read("*n")
		io.close(savFile)
		if not musicOpen then
			musicOpen = 1
		end
	end
	
	savePath = system.pathForFile( name..".sav", system.DocumentsDirectory )
	savFile = io.open( savePath, "r" )
	
	if savFile then
		maxStage = savFile:read("*n")
		maxQuest = savFile:read("*n")
		
		if not maxStage then
			maxStage = 1
			maxQuest = 1
			for i = 1, 5 do
				totleScore[i] = 0
				for j = 1, 10 do
					score[i*100 + j] = 0
				end
			end
			save()
		else
			for i = 1, 5 do
				totleScore[i] = 0
				for j = 1, 10 do
					score[i*100 + j] = savFile:read("*n")
					totleScore[i] = totleScore[i] + score[i*100 + j]
				end
			end
		end
		
		io.close(savFile)
	else 
		maxStage = 1
		maxQuest = 1
		for i = 1, 5 do
			totleScore[i] = 0
			for j = 1, 10 do
				score[i*100 + j] = 0
			end
		end
		save()
	end
	
end

function upstage(n)
	local tmpStage = n.stage
	local tmpQuest = n.quest
	if (tmpStage * 100 + tmpQuest) > (maxStage*100 + maxQuest) then
		maxStage = tmpStage
		maxQuest = tmpQuest
		save()
	end
end

function chstage(n)
	stageNumStage = n.stage
	stageNumQuest = n.quest
end

function chX(n)
	globlex = n
end

function upScore(n)
	local tmp = stageNumStage * 100 + stageNumQuest
	if n > score[tmp] then 
		score[tmp] = n 
		save()
	end
end

local backgroundMusic = audio.loadStream("music.mp3")
backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )
function chMusic()
	musicOpen = (musicOpen+1)%2
	if musicOpen == 1 then
		audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )
	else
		audio.stop()
	end
	save()
end

function getMusic()
	return musicOpen
end

winSound = media.newEventSound( "win.mp3" )
lostSound = media.newEventSound( "lost.mp3" )

local function main()
--> Adds main function
	load()
	save()
	
	if musicOpen == 0 then
		audio.stop()
	end
	mainGroup:insert(director.directorView)
	--> Adds the group from director
	
	director:changeScene("start")
	--> Change the scene, no effects
	
	return true
end

quests = {
	[101] = {1, 1, "impressions", "make", "build"},
	[102] = {1, 1, "rumors", "spread", "make"},
	[103] = {1, 1, "attempts", "make", "try"},
	[104] = {1, 1, "judgments", "make", "do"}, 
	[105] = {1, 1, "funds", "raise", "make"}, 
	[106] = {1, 1, "comments", "make", "do"},
	[107] = {1, 1, "contributions", "make", "do"},
	[108] = {2, 1, "hopes", "arouse", "raise", "produce"} ,
	[109] = {2, 1, "decisions", "make", "reach", "do"},
	[110] = {2, 1, "progress", "make", "achieve", "create"},


	[201] = {1, 1, "apologies", "make", "pass"},
	[202] = {1, 1, "options", "weigh", "measure"},
	[203] = {1, 1, "spirits", "lift", "heighten"},
	[204] = {1, 1, "motivation", "enhance", "lift"},
	[205] = {1, 1, "reasons", "give", "say"},
	[206] = {2, 1, "depth", "increase", "expand", "deepen"},
	[207] = {2, 1, "one's breath", "catch", "recover", "smooth"},
	[208] = {2, 1, "duties", "do", "fulfill", "keep"},
	[209] = {2, 1, "records", "beat", "break", "defeat"},
	[210] = {2, 1, "minds", "broaden", "stretch", "widen" },


	[301] = {1, 1, "signals", "send", "convey"},
	[302] = {1, 1, "memories", "erase", "delete"},
	[303] = {1, 1, "actions", "take", "do"},
	[304] = {1, 1, "roots", "take", "start"},
	[305] = {1, 1, "questions", "take", "receive"}, 
	[306] = {1, 1, "one's temperature", "take", "measure"},
	[307] = {2, 1, "promoises", "keep", "fulfill", "do"},  
	[308] = {2, 1, "measures", "take", "adopt", "do"},
	[309] = {2, 1, "revenge", "take", "get", "make"},
	[310] = {3, 1, "suggestions", "make", "give", "offer", "say"},


	[401] = {1, 1, "competitions", "lose", "fail"}, 
	[402] = {1, 1, "experiences", "get", "learn"}, 
	[403] = {1, 1, "origins", "trace", "chase"}, 
	[404] = {1, 1, "a chance", "take", "use"},
	[405] = {2, 1, "damage", "cause", "do", "make"}, 
	[406] = {2, 1, "outrage", "express", "voice", "release"},
	[407] = {2, 1, "relationship", "repair", "fix", "remedy"},
	[408] = {2, 1, "differences", "see", "spot", "watch"},
	[409] = {3, 1, "a speech", "deliver", "give", "make", "show"},
	[410] = {3, 1, "aims", "achieve", "accomplish", "reach", "hit" },


	[501] = {1, 1, "makeup", "wear", "bring"}, 
	[502] = {1, 1, "stress","relieve", "lose"},
	[503] = {2, 1, "defects", "repair", "remedy", "improve"},
	[504] = {2, 1, "efforts", "intensify", "renew", "add"}, 
	[505] = {2, 1, "knowledge", "gain", "accumulate", "learn"},
	[506] = {2, 1, "conclusions", "draw", "reach", "strike"},
	[507] = {2, 1, "difficulties", "overcome", "resolve", "cross"},
	[508] = {2, 1, "belief", "adhere to", "stick to", "insist on" },
	[509] = {3, 1, "misunderstandings", "overcome", "resolve", "clarify", "untie"  },
	[510] = {3, 1, "passion", "stir", "arouse", "inspire", "push" },
}

hints = {
	[101] = {"? + an impression\n留下印象"},
	[102] = {"? + rumors\n散播謠言"},
	[103] = {"? + attemtps\n試圖"},
	[104] = {"? + judgments\n做判斷"},
	[105] = {"? + funds\n募款"},
	[106] = {"? + comments\n評論"},
	[107] = {"? + contribution\n產生貢獻"},
	[108] = {"? + hopes\n使有希望"},
	[109] = {"? + decisions\n做決定"},
	[110] = {"? + progress\n進步"},

	[201] = {"? + apologies\n道歉"},
	[202] = {"? + options\n權衡可能的選擇"},
	[203] = {"? + spirit\n提振精神"},
	[204] = {"? + motivation\n提升動機"},
	[205] = {"? + reasons\n說明理由"},
	[206] = {"? +depth\n增加深度"},
	[207] = {"? + one's breath\n喘口氣"},
	[208] = {"? + duties\n盡義務"},
	[209] = {"? + records\n打破紀錄"},
	[210] = {"? + minds\n拓展心智"},

	[301] = {"? + signals\n發出信號"},
	[302] = {"? + memories\n刪除記憶"},
	[303] = {"? + actions\n採取行動"},
	[304] = {"? + roots\n生根"},
	[305] = {"? + questions\n接受提問"},
	[306] = {"? + one's temperature\n量體溫"},
	[307] = {"? + promises\n履行承諾"},
	[308] = {"? + measures\n採取措施"},
	[309] = {"? + revenge\n報復"},
	[310] = {"? + suggestions\n提出建議"},

	[401] = {"? + a competition\n輸掉比賽"},
	[402] = {"? + experiecnes\n學經驗"},
	[403] = {"? + origins\n追蹤起源"},
	[404] = {"? + a chance\n放手一搏"},
	[405] = {"? + damage\n造成損害"},
	[406] = {"? + outrage\n表示憤慨"},
	[407] = {"? + relationship\n修補關係"},
	[408] = {"? + differences\n看出差異"},
	[409] = {"? + a speech\n發表演說"},
	[410] = {"? + aims\n達成目標"},
	 
	[501] = {"? + makeup\n臉上有妝"},
	[502] = {"? + stress\n釋放壓力"},
	[503] = {"? + defects\n改善缺陷"},
	[504] = {"? + efforts\n加強努力"},
	[505] = {"? + knowledge\n學知識"},
	[506] = {"? + conclusions\n推得結論"},
	[507] = {"? + difficulties\n克服困難"},
	[508] = {"? + beliefs\n堅信"},
	[509] = {"? + misunderstandings\n解開誤會"},
	[510] = {"? + passion\n激發熱情"},
}

main()
--> Starts our app