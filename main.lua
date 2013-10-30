-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
storyboard.isDebug = true

local physics = require "physics"
physics.start()
physics.setScale( 45 ) 
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")

maxVisibleX = display.viewableContentWidth + -1* display.screenOriginX
maxVisibleY = display.viewableContentHeight + -1* display.screenOriginY
rightXBound = maxVisibleX - 45
floorRoofWidth = display.viewableContentWidth - 45 - 2*display.screenOriginX
roofHeight = display.screenOriginY+25
middleStageX = (floorRoofWidth )/2 + display.screenOriginX
middleStageY = roofHeight + (maxVisibleY-25)/2

screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

audio.setVolume( .5 )

cueCollision = audio.loadSound("audio/c.mp3") 
function playCueCollision()
	audio.play(cueCollision)
end
failAudio = audio.loadSound("audio/fail.mp3") 
function playFail()
	audio.play(failAudio)
end
addAudio = audio.loadSound("audio/add.mp3") 
function playAdd()
	audio.play(addAudio)
end
subAudio = audio.loadSound("audio/sub.mp3") 
function playSub()
	audio.play(subAudio)
end
tenAudio = audio.loadSound("audio/ten.mp3") 
function playTen()
	audio.play(tenAudio)
end
cueShotAudio = audio.loadSound("audio/shot.mp3") 
function playCueShot()
	audio.play(cueShotAudio)
end
greenWallAudio = audio.loadSound("audio/greenWall.mp3") 
function playGreenWall()
	audio.play(greenWallAudio)
end
blueWallAudio = audio.loadSound("audio/blueWall.mp3") 
function playBlueWall()
	audio.play(blueWallAudio)
end
score1Audio = audio.loadSound("audio/score1.mp3") 
function playScore1()
	audio.play(score1Audio)
end
score2Audio = audio.loadSound("audio/score2.mp3") 
function playScore2()
	audio.play(score2Audio)
end
score3Audio = audio.loadSound("audio/score3.mp3") 
function playScore3()
	audio.play(score3Audio)
end
score4Audio = audio.loadSound("audio/score4.mp3") 
function playScore4()
	audio.play(score4Audio)
end
score5Audio = audio.loadSound("audio/score5.mp3") 
function playScore5()
	audio.play(score5Audio)
end
winAudio = audio.loadSound("audio/win.mp3") 
function playWin()
	audio.play(winAudio)
end
selectAudio = audio.loadSound("audio/win.mp3") 
function playWin()
	audio.play(winAudio)
end
moreAudio = audio.loadSound("audio/more.mp3") 
function playMore()
	audio.play(moreAudio)
end

oneCollision = audio.loadSound("audio/d.mp3")
function playOne()
	audio.play(oneCollision)
end
twoCollision = audio.loadSound("audio/e.mp3")
function playTwo()
	audio.play(twoCollision)
end
threeCollision = audio.loadSound("audio/f.mp3") 
function playThree()
	audio.play(threeCollision)
end
fourCollision = audio.loadSound("audio/g.mp3")
function playFour()
	audio.play(fourCollision)
end
fiveCollision = audio.loadSound("audio/a.mp3") 
function playFive()
	audio.play(fiveCollision)
end
sixCollision = audio.loadSound("audio/b.mp3")
function playSix()
	audio.play(sixCollision)
end
sevenCollision = audio.loadSound("audio/c2.mp3") 
function playSeven()
	audio.play(sevenCollision)
end
eightCollision = audio.loadSound("audio/d2.mp3")
function playEight()
	audio.play(eightCollision)
end
nineCollision = audio.loadSound("audio/e2.mp3") 
function playNine()
	audio.play(nineCollision)
end

function playStageBallCollision(ballValue)
	
	local soundNum = ballValue
	
	if soundNum == 1 then
		playOne()
	elseif 	soundNum == 2 then
		playTwo()
	elseif 	soundNum == 3 then
		playThree()
	elseif 	soundNum == 4 then
		playFour()
	elseif 	soundNum == 5 then
		playFive()
	elseif 	soundNum == 6 then
		playSix()
	elseif 	soundNum == 7 then
		playSeven()
	elseif 	soundNum == 8 then
		playEight()
	elseif 	soundNum == 9 then
		playNine()
	end	
end


local background = display.newImageRect( "images/mainBack.png", 570, 380 )
background.x = display.contentWidth/2
background.y = display.contentHeight/2
background:toBack()

traceLayer = display.newGroup()
local display_stage = display.getCurrentStage()
display_stage:insert(background)
display_stage:insert(traceLayer)
display_stage:insert(storyboard.stage)

local transitionOptions = {
	effect = "fade",
	time = 200,
}

function goToMenu()
	
	storyboard.gotoScene( "scripts.menu",transitionOptions )
end

function goToLevelSelect()
	storyboard.gotoScene( "scripts.levelSelect",transitionOptions)	
end	
function goToInstructions()
	storyboard.gotoScene( "scripts.instructions",transitionOptions)	
end
function goToCredits()
	storyboard.gotoScene( "scripts.credits",transitionOptions)	
end
function ratingDisplay()
	
	local rateSettings = {
		iOSAppId = "492137642",
		nookAppEAN = "2940043942326",
		supportedAndroidStores = { "google", "amazon", "nook"},
	}
	
	native.showPopup("rateApp",rateSettings)

end

function ratingListener(event)
	if "clicked" == event.action then
		local i = event.index
		if 1 == i then
			ratingDisplay()
		elseif 2 == i then	
	
		end
	end	
end	

function ratingPrompt()
	native.showAlert("Hope you have enjoyed circleTEN!","Will you leave a rating or review?", {"Sure", "No way"},ratingListener)	
end
function lastAlertListener(event)
		if "clicked" == event.action then
			local i = event.index
			if 1 == i then
				
			elseif 2 == i then	
				ratingDisplay()
			end
		end	
end
function lastLevelAlert()
	native.showAlert("Thats it for now","Watch for more levels in future updates", {"Okay", "Rate App"},lastAlertListener)
end

function reloadLevel()
	
	--add sound
	local currentScene = storyboard.getCurrentSceneName()
	
	print(currentScene)
	storyboard.purgeScene(currentScene)	
	print("purging",currentScene)
	storyboard.gotoScene(currentScene)
	print("loading",currentScene)	
end	
	
function onLevelWon()
	playWin()
	local options = {
		effect = "slideRight",
		time = 500,
		isModal = true,
		params = {
			finalScore = score.text,
			movesLeft = moves.text,
		},
	}
	storyboard.showOverlay( "scripts.levelWon",options)
end

function onLevelFail()
	local options = {
		effect = "slideRight",
		time = 500,
		isModal = true,
	}
	storyboard.showOverlay( "scripts.levelFail",options)
end
function stopCueballTrace()
	if circleTimer then
		timer.pause(circleTimer)
		timer.cancel(circleTimer)
		circleTimer = nil
	end
end
function pauseListener(event)
	if "clicked" == event.action then
		local i = event.index	
		if 1 == i then
			
		elseif 2 == i then	
			goToLevelSelect()
		elseif 3 == i then		
			reloadLevel()
		end
	end	
end	

function onPauseBtnRelease()
stopCueballTrace()
	native.showAlert("Paused","Make your choice", {"Resume","Level Select","Restart Level"},pauseListener)
end

function cueballTRACE(totalForce)
	
	stopCueballTrace()
	
	local r = 255
	local b = 255
	local g = 255
	local cSize = 1
	local t = 10

	if totalForce <= 100 then
		r = 0
		b = 255
		g = math.random(0,255)
		cSize = 3
		t = 20
	elseif totalForce > 100 and totalForce <= 300 then
		r = math.random(50,200)
		b = 0
		g = 255
		cSize = 4
		t = 15
	elseif totalForce > 300 and totalForce <= 500 then
		r = 255
		b = 0
		g = math.random(50,200)
		cSize = 5
		t = 10
	elseif totalForce > 500 then
		r = 255
		b = 0
		g = 0
		cSize = 6
		t = 3
	end
	
	local function createCircle()
		
		local circle = display.newCircle(cueball.x,cueball.y,cSize)
		
		circle:setFillColor(r,g,b,20)
		traceLayer:insert(circle)
		local function circleRemove()
			transition.to(circle,{time=10000,alpha=0,transition=easing.inQuad,onComplete = function() circle:removeSelf() end})
		end	
		
		timer.performWithDelay(100,circleRemove)
	
	end
	
	circleTimer = timer.performWithDelay(t,createCircle,700)
	
end
function removeBlueWall()
	if _G.blueWTimer then
		timer.pause(_G.blueWTimer)
		timer.cancel(_G.blueWTimer)
	end
	if _G.blueWall then
		_G.blueWall:removeSelf()
		_G.blueWall = nil
	end
end

-- load menu screen
storyboard.gotoScene( "scripts.menu")