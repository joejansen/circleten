
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local gameLogic = require( "scripts.gameLogic" )
local widget = require ("widget")
local utilities = require ("scripts.utilities")

-- forward declarations

function soundChange (event)
	if _G.lobal.soundOn == true then
		_G.lobal.soundOn = false
		utilities.saveSavedItems()
		soundOnBtn.isVisible = false
		soundOffBtn.isVisible = true
		audio.setVolume( 0 )
	elseif _G.lobal.soundOn == false then
		_G.lobal.soundOn = true
		utilities.saveSavedItems()
		soundOffBtn.isVisible = false
		soundOnBtn.isVisible = true
		audio.setVolume( .5 )
	end
end

function onPlusMinusBtnRelease ( event )

	if plusBtn.isVisible == true then
		_G.lobal.mode = "subtract"
		utilities.saveSavedItems()
		playAdd()
		minusBtn.isVisible = true
		plusBtn.isVisible = false
	elseif minusBtn.isVisible == true then
		_G.lobal.mode = "add"
		utilities.saveSavedItems()
		playSub()
		minusBtn.isVisible = false
		plusBtn.isVisible = true
	end
end
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.setGravity( 0, 0 )
	
	local levelNum = 17
	local movesNum = 11
	local goalNum = 2
	local cueBallStartX = middleStageX
	local cueBallStartY = middleStageY
	local cueBallStartValue = 0
	local canUseMoreBallBtn = false
	local canUsePlusMinusBtn = false
	local canUsePowerups = false
	
	_G.lobal.mode = "add"
	_G.lobal.currentLevel = levelNum
	utilities.saveSavedItems()
	-------------------------------------------------
	--DEFAULT STAGE ITEMS----------------------------
	-------------------------------------------------
	allball = display.newGroup()
		
	topScreenItems = display.newGroup()
	
	local topGameText = gameLogic.topGameText()
	topScreenItems:insert( topGameText )

	moves = gameLogic.createMoves(movesNum)
	topScreenItems:insert(moves)
	
	score = gameLogic.createScore()
	topScreenItems:insert(score)
	
	local goal = gameLogic.createGoal(goalNum)
	topScreenItems:insert(goal.raw)
	
	local levelNumText = gameLogic.createLevelNum(levelNum)
	topScreenItems:insert(levelNumText)
	
	topScreenItems.x = -500
	transition.to(topScreenItems,{time=2500,x=0})
	group:insert(topScreenItems)
	
	sideScreenItems = display.newGroup()
	
	pauseBtn = gameLogic.loadPauseBtn()
	sideScreenItems:insert(pauseBtn)

	if canUsePowerups == true then
		local powerupBtn = gameLogic.loadPowerupBtn()
		sideScreenItems:insert(powerupBtn)
	else
		local powerupDisabledBtn = gameLogic.loadPowerupDisabledBtn()
		sideScreenItems:insert(powerupDisabledBtn)
	end

	if canUseMoreBallBtn == true then
		local moreBtn = gameLogic.loadMoreBtn()
		sideScreenItems:insert(moreBtn)
	else
		local moreDisabledBtn = gameLogic.loadMoreDisabledBtn()
		sideScreenItems:insert(moreDisabledBtn)
	end	
	
	if canUsePlusMinusBtn == true then
		plusBtn = gameLogic.loadPlusBtn()
		sideScreenItems:insert(plusBtn)
		minusBtn = gameLogic.loadMinusBtn()
		sideScreenItems:insert(minusBtn)
	else
		local plusMinusDBtn = gameLogic.loadPlusMinusDisabledBtn()
		sideScreenItems:insert(plusMinusDBtn)
	end	
	
	soundOnBtn = gameLogic.loadSoundOnBtn()
	sideScreenItems:insert(soundOnBtn)
	
	soundOffBtn = gameLogic.loadSoundOffBtn()
	sideScreenItems:insert(soundOffBtn)	
	
	sideScreenItems.x = 60
	transition.to(sideScreenItems,{time=500,x=0})
	group:insert(sideScreenItems)
	
	-------------------------------------------------
	--PHYSICS ITEMS----------------------------
	-------------------------------------------------

	physicsGroup = display.newGroup()
	wallGroup = display.newGroup()
	
	walls = gameLogic.createStageWalls()
	physicsGroup:insert(walls)

	cueball = gameLogic.loadCueball(cueBallStartX,cueBallStartY,cueBallStartValue)
	physicsGroup:insert(cueball)
--------------------------------------------------------------------------
--------------------------------------------------------------------------
----------------OPTIONS

		local orangeWall1 = gameLogic.createOrangeWall(100,70,250,1)
		wallGroup:insert(orangeWall1)
	
		local redWall1 = gameLogic.createRedWall(350,70,1,55)	
		wallGroup:insert(redWall1)
	
		local orangeWall1 = gameLogic.createOrangeWall(100,125,250,1)
		wallGroup:insert(orangeWall1)
		
		local greenWall1 = gameLogic.createGreenWall(100,70,1,55)	
		wallGroup:insert(greenWall1)
		
		local orangeWall2 = gameLogic.createOrangeWall(100,220,250,1)
		wallGroup:insert(orangeWall2)
	
		local redWall2 = gameLogic.createRedWall(350,220,1,55)	
		wallGroup:insert(redWall2)
	
		local orangeWall2 = gameLogic.createOrangeWall(100,275,250,1)
		wallGroup:insert(orangeWall2)
		
		local greenWall2 = gameLogic.createGreenWall(100,220,1,55)	
		wallGroup:insert(greenWall2)


		

	-- 	
	-- 	gameLogic.createBlueWall(display.screenOriginX,halfH,floorRoofWidth,4)
	
	-- local randStageBalls1 = gameLogic.createRandStageBalls(10,1,9)
	-- allball:insert(randStageBalls1)
	-- 
	local specificStageBall1 = gameLogic.createSpecificStageBall(6,320,100)
	allball:insert(specificStageBall1)
	
	local specificStageBall2 = gameLogic.createSpecificStageBall(4,320,250)
	allball:insert(specificStageBall2)
	
	local specificStageBall3 = gameLogic.createSpecificStageBall(7,400,100)
	allball:insert(specificStageBall3)
	
	local specificStageBall4 = gameLogic.createSpecificStageBall(3,400,250)
	allball:insert(specificStageBall4)
	

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------	
	allball.alpha = 0
	transition.to(allball,{time=400,delay=1300,alpha=1})
	
	wallGroup.alpha = 0
	transition.to(wallGroup,{time=400,delay=1300,alpha=1})
	
	group:insert(physicsGroup)
	group:insert(allball)
	group:insert(wallGroup)
	
	local hint = display.newText("You'll have less moves from this level on",display.screenOriginX+15,40,floorRoofWidth-20,100,"HelveticaNeue", 20)
	transition.to(hint,{time=4000,delay=2000,alpha=0})
	group:insert(hint)
	
end

function scene:overlayBegan(event)
	local group = self.view

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
		removeAll()
end

-- Called after scene has moved offscreen:
function scene:didExitScene( event )
	local group = self.view

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

function removeAll()
	if topScreenItems then
		topScreenItems:removeSelf()
		topScreenItems = nil
	end
	if sideScreenItems then
		sideScreenItems:removeSelf()
		sideScreenItems = nil
	end
	if physicsGroup then
		physicsGroup:removeSelf()
		physicsGroup = nil
	end
	if wallGroup then
		wallGroup:removeSelf()
		wallGroup = nil
	end
	if allball then
		allball:removeSelf()
		allball = nil
	end	
	if _G.blueWTimer then
		timer.pause(_G.blueWTimer)
		timer.cancel(_G.blueWTimer)
	end
	if _G.blueWall then
		_G.blueWall:removeSelf()
		_G.blueWall = nil
	end
end

return scene