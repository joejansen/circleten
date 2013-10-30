
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local gameLogic = require( "scripts.gameLogic" )
local widget = require ("widget")
local utilities = require ("scripts.utilities")

-- forward declarations
function removeInstText()
	if instructionsText then
		instructionsText:removeSelf()
		instructionsText = nil
	end
end

local instructionNum = 1
function loadInstText()
	local instText = ""
	if instructionNum == 1 then
		instText = "You control the ball with the rainbow border. To move it, touch the ball and drag opposite your target."
	elseif instructionNum == 2 then
		instText = "The farther away you drag, the more force the ball will move with."
	elseif instructionNum == 3 then
		instText = "Your goal is to make combinations of TEN by absorbing other balls. When you get to TEN, your ball resets to zero."
	elseif instructionNum == 4 then
		instText = "You can only absorb a ball if it will add or subtract to TEN or less."
	elseif instructionNum == 5 then
		instText = "You can toggle between addition and subtraction by tapping the plus/minus button."
	elseif instructionNum == 6 then
		instText = "You can add more balls to the level by tapping the button with three circles. This costs one MOVE."
	elseif instructionNum == 7 then
		instText = "Each level has a GOAL for some number of combinations of TEN. You do this with a limited number of MOVES."		
	end
	
	removeInstText()
	
	instructionsText = display.newText(instText,display.screenOriginX+5,maxVisibleY-80,420,60,"HelveticaNeue",15)
	instructionsText:setReferencePoint( display.TopLeftReferencePoint )
	
	--instructionsText.text = instText
	
end	

function onInstructionsNextBtnRelease()
	instructionNum = instructionNum + 1 
	if instructionNum > 7 then
		instructionNum = 1
		playScore5()
	end
	loadInstText()

end

function onInstructionsBackBtnRelease()
	instructionNum = instructionNum - 1 
	if instructionNum < 1 then
		instructionNum = 1
		playScore1()
	end
	loadInstText()

end


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
	
	local levelNum = 0
	local movesNum = 99
	local goalNum = 99
	local cueBallStartX = middleStageX
	local cueBallStartY = middleStageY -50
	local cueBallStartValue = 0
	local canUseMoreBallBtn = true
	local canUsePlusMinusBtn = true
	local canUsePowerups = false
	
	_G.lobal.mode = "add"
	-- _G.lobal.currentLevel = levelNum
	-- utilities.saveSavedItems()
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
	
	local levelNumText = gameLogic.createLevelNum("Instructions")
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

	--CREATE MORE BALLS BUTTON
	local function onInstMoreBtnRelease()
		if moves.text+0 > 1 then 
			playMore()
			local moreBalls = gameLogic.createRandStageBallsXY(3,1,9,display.screenOriginX+20,rightXBound-20,roofHeight+20,maxVisibleY-105)
			allball:insert(moreBalls)
			moves.text = moves.text - 1
			score.text = score.text - 100
		else
			playScore1()
			native.showAlert( "Not enough moves","You need more moves to add balls",{ "OK" })
		end
	end

	local moreBtn = widget.newButton{
			defaultFile="images/gameMoreBtn.png",
			overFile="images/gameMoreBtnOver.png",
			width = 45,
			height = 45,
			onRelease = onInstMoreBtnRelease
		}
		moreBtn:setReferencePoint( display.CenterReferencePoint )
		moreBtn.x = rightXBound+22.5
		moreBtn.y = maxVisibleY-155
		moreBtn.xScale = .9
		moreBtn.yScale = .9
	sideScreenItems:insert(moreBtn)
	
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
	
	local instructionsLSBtn = widget.newButton{
		defaultFile="images/LWSelectBtn.png",
		overFile="images/LWSelectBtnOver.png",
		width = 375,
		height = 33,
		onRelease = goToLevelSelect
	}
	instructionsLSBtn:setReferencePoint( display.BottomRightReferencePoint )
	instructionsLSBtn.x = display.screenOriginX+150
	instructionsLSBtn.y = maxVisibleY-5
	group:insert(instructionsLSBtn)
	
	local instructionsBackBtn = widget.newButton{
		defaultFile="images/instBackBtn.png",
		overFile="images/instBackBtnOver.png",
		width = 118,
		height = 33,
		onRelease = onInstructionsBackBtnRelease
	}
	instructionsBackBtn:setReferencePoint( display.BottomCenterReferencePoint )
	instructionsBackBtn.x = instructionsLSBtn.x + 80
	instructionsBackBtn.y = maxVisibleY-5
	group:insert(instructionsBackBtn)
	
	local instructionsNextBtn = widget.newButton{
		defaultFile="images/instNextBtn.png",
		overFile="images/instNextBtnOver.png",
		width = 118,
		height = 33,
		onRelease = onInstructionsNextBtnRelease
	}
	instructionsNextBtn:setReferencePoint( display.BottomCenterReferencePoint )
	instructionsNextBtn.x = instructionsBackBtn.x + 130
	instructionsNextBtn.y = maxVisibleY-5
	group:insert(instructionsNextBtn)
	
	
	-------------------------------------------------
	--PHYSICS ITEMS----------------------------
	-------------------------------------------------

	physicsGroup = display.newGroup()
	wallGroup = display.newGroup()
	
	walls = gameLogic.createInstructionWalls()
	physicsGroup:insert(walls)

	cueball = gameLogic.loadCueball(cueBallStartX,cueBallStartY,cueBallStartValue)
	physicsGroup:insert(cueball)
--------------------------------------------------------------------------
--------------------------------------------------------------------------
----------------OPTIONS

	-- local orangeWall1 = gameLogic.createOrangeWall(25,205,100,1)
	-- 	wallGroup:insert(orangeWall1)
	-- 	
		-- local greenWall1 = gameLogic.createGreenWall(display.screenOriginX,middleStageY-100,floorRoofWidth,1)		
		-- wallGroup:insert(greenWall1)
		-- 	
		-- local greenWall2 = gameLogic.createGreenWall(display.screenOriginX,middleStageY+100,floorRoofWidth,1)		
		-- wallGroup:insert(greenWall2)

		-- local redWall1 = gameLogic.createRedWall(display.screenOriginX,middleStageY-135,floorRoofWidth,1)	
		-- 	wallGroup:insert(redWall1)
		-- 	
		-- 	local redWall2 = gameLogic.createRedWall(display.screenOriginX,middleStageY+135,floorRoofWidth,1)	
		-- 	wallGroup:insert(redWall2)
		-- 
		-- gameLogic.createBlueWall(display.screenOriginX,middleStageY,floorRoofWidth,1)
	
	-- local randStageBalls1 = gameLogic.createRandStageBalls(10,1,9)
	-- allball:insert(randStageBalls1)
	-- 
	local specificStageBall1 = gameLogic.createSpecificStageBall(5,middleStageX - 150,middleStageY)
	allball:insert(specificStageBall1)
	
	local specificStageBall2 = gameLogic.createSpecificStageBall(2,middleStageX + 150,middleStageY)
	allball:insert(specificStageBall2)
	
	local specificStageBall3 = gameLogic.createSpecificStageBall(4,middleStageX - 150,55)
	allball:insert(specificStageBall3)
	
	local specificStageBall4 = gameLogic.createSpecificStageBall(1,middleStageX + 150,55)
	allball:insert(specificStageBall4)
	
	local specificStageBall5 = gameLogic.createSpecificStageBall(3,middleStageX - 150,111)
	allball:insert(specificStageBall5)
	-- 
	-- local specificStageBall6 = gameLogic.createSpecificStageBall(6,middleStageX+150,middleStageY+100)
	-- allball:insert(specificStageBall6)
	-- 
	-- local specificStageBall7 = gameLogic.createSpecificStageBall(2,middleStageX+100,middleStageY-100)
	-- allball:insert(specificStageBall7)
	
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------	
	allball.alpha = 0
		transition.to(allball,{time=400,delay=1300,alpha=1})
	
	wallGroup.alpha = 0
		transition.to(wallGroup,{time=400,delay=1300,alpha=1})
	
	group:insert(wallGroup)
	group:insert(physicsGroup)
	group:insert(allball)
	
	
	-- local hint1 = display.newText("Green walls delete after a collision with the main ball",display.screenOriginX+15,middleStageY-98,floorRoofWidth-20,100,"HelveticaNeue", 20)
	-- local function removeHint1()
	-- 	hint1:removeSelf()
	-- end
	-- timer.performWithDelay(3000,removeHint1)
	-- group:insert(hint1)

	loadInstText()
end

function scene:overFilelayBegan(event)
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
	removeInstText()
end

return scene