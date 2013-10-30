module(..., package.seeall)

local widget = require "widget"
local storyboard = require( "storyboard" )
local proxy = require("scripts.proxy")



--CREATE BALL BACK
function loadBallBack()
	local ballBackground  = display.newImageRect("images/ballBack.png", floorRoofWidth, maxVisibleY)
	ballBackground:setReferencePoint(display.TopLeftReferencePoint)
	ballBackground.x=display.screenOriginX
	ballBackground.y=display.screenOriginY+25
	return ballBackground
end

--CREATE GOAL,MOVE,SCORE TEXT
function topGameText()
	local topGameText = display.newGroup ()
	local goalText = display.newText ( "GOAL:", display.screenOriginX+10 ,display.screenOriginY+6,native.systemFont, 10)
	goalText:setTextColor (90,90,90, 210)
	topGameText:insert(goalText)
	local movesText = display.newText ( "MOVES:", goalText.x+60 ,display.screenOriginY+6,native.systemFont, 10)
	movesText:setTextColor (90,90,90, 210)
	topGameText:insert(movesText)
	local scoreText = display.newText ( "SCORE:", movesText.x+60 ,display.screenOriginY+6,native.systemFont, 10)
	scoreText:setTextColor (90,90,90, 210)
	topGameText:insert(scoreText)
	return topGameText
end

function createLevelNum(levelNum)
	local levelText = display.newText ( "LEVEL: "..levelNum.."", maxVisibleX-60 ,display.screenOriginY+6,native.systemFont, 10)
	levelText:setReferencePoint( display.CenterRightReferencePoint )
	levelText.x=rightXBound
	levelText:setTextColor (90,90,90, 210)
	return levelText
end	
-- CREATE STAGE WALLS --
function createStageWalls()	
	local walls = display.newGroup ()
	local ballBackground = loadBallBack()
	ballBackground.alpha = 0
	walls:insert(ballBackground)
	local lwall = display.newRect (display.screenOriginX,roofHeight,1, (maxVisibleY) ) ; lwall:setFillColor(255,255,255,0) 
	physics.addBody (lwall, "static", {bounce=.2, density=1.0})
	local rwall = display.newRect (rightXBound,370,1, (maxVisibleY) ) ; rwall:setFillColor(255,255,255,175)
	physics.addBody (rwall, "static", {bounce=.2, density=1.0})
	local floor = display.newRect (display.screenOriginX,maxVisibleY-1,floorRoofWidth, 1 ) ; floor:setFillColor(255,255,255,0)
	physics.addBody (floor, "static", {bounce=.2, density=1.0})
	local roof = display.newRect (-600,roofHeight,floorRoofWidth, 1 ) ; roof:setFillColor(255,255,255,175)
	physics.addBody (roof, "static", {bounce=.2, density=1.0})
	walls:insert(lwall) ; walls:insert(rwall) ; walls:insert(floor) ; walls:insert(roof)
	local ballBackground = loadBallBack()
	ballBackground.alpha = 0
	walls:insert(ballBackground) 
	rwall:setReferencePoint(display.TopLeftReferencePoint)
	transition.to(rwall,{time=300,delay=500,y=display.screenOriginY+25})
	roof:setReferencePoint(display.TopLeftReferencePoint)
	transition.to(roof,{time=300,delay=500,x=display.screenOriginX})
	transition.to(ballBackground,{time=200,delay=800,alpha=1})
	return walls
end
function createInstructionWalls()	
	local walls = display.newGroup ()
	local lwall = display.newRect (display.screenOriginX,roofHeight,1, (maxVisibleY) ) ; lwall:setFillColor(255,255,255,0) 
	physics.addBody (lwall, "static", {bounce=.5, density=1.0})
	local rwall = display.newRect (rightXBound,370,1, (maxVisibleY) ) ; rwall:setFillColor(255,255,255,175)
	physics.addBody (rwall, "static", {bounce=.5, density=1.0})
	local floor = display.newRect (-600,maxVisibleY-85,floorRoofWidth, 1 ) ; floor:setFillColor(255,255,255,175)
	physics.addBody (floor, "static", {bounce=.5, density=1.0})
	local roof = display.newRect (-600,roofHeight,floorRoofWidth, 1 ) ; roof:setFillColor(255,255,255,175)
	physics.addBody (roof, "static", {bounce=.5, density=1.0})
	walls:insert(lwall) ; walls:insert(rwall) ; walls:insert(floor) ; walls:insert(roof)
	local ballBackground = loadBallBack()
	ballBackground.alpha = 0
	walls:insert(ballBackground) 
	rwall:setReferencePoint(display.TopLeftReferencePoint)
	transition.to(rwall,{time=300,delay=500,y=display.screenOriginY+25})
	roof:setReferencePoint(display.TopLeftReferencePoint)
	transition.to(roof,{time=300,delay=500,x=display.screenOriginX})
	floor:setReferencePoint(display.TopLeftReferencePoint)
	transition.to(floor,{time=300,delay=500,x=display.screenOriginX})	
	return walls
end

-- CREATE MOVES TEXT
-- function checkLevelFail()
-- 
-- 	if levelOverBack == nil then
-- 		
-- 		local vx,vy = cueball:getLinearVelocity()
-- 		if vx == 0 and vy == 0 then
-- 			onLevelFail()
-- 		end
-- 	end
-- end
function createMoves(movesNum)
	moves = display.newText ( movesNum, display.screenOriginX+125 ,display.screenOriginY,native.systemFont, 20)
	-- moves = proxy.get_proxy_for(moves)
	-- 		function moves:propertyUpdate(event)
	-- 			
	-- 			if event.key == "text" then
	-- 				if event.value == 0 then
	-- 					local vx,vy = cueball:getLinearVelocity()
	-- 						if vx == 0 and vy == 0 then
	-- 					 		onLevelFail()
	-- 						end
	-- 				
	-- 				end
	-- 			end
	-- 		end
	-- moves:addEventListener("propertyUpdate")
	moves:setReferencePoint( display.CenterLeftReferencePoint )
	moves:setTextColor (250,80,80, 210)
	return moves
end

-- CREATE SCORE TEXT
function createScore()
	score = display.newText ( 0, display.screenOriginX+205 ,display.screenOriginY,100,25,native.systemFont, 20)
	--score:setReferencePoint( display.TopLeftReferencePoint )
	
	score:setTextColor (50,250,50, 200)
	return score
end

-- CREATE GOAL TEXT
function createGoal(goalNum)
	goal = display.newText ( goalNum, display.screenOriginX+42 ,display.screenOriginY,native.systemFont, 20)
	goal = proxy.get_proxy_for(goal)
	function goal:propertyUpdate(event)
		if event.value == 0 then
			timer.performWithDelay(220,onLevelWon)
		end
	end	
	goal:addEventListener("propertyUpdate")
	goal:setReferencePoint( display.CenterLeftReferencePoint )
	goal:setTextColor (50,50,250, 250)
	return goal
end

--CREATE PAUSE BUTTON

function loadPauseBtn()
	local pauseBtn = widget.newButton{
		defaultFile="images/gamePauseBtn.png",
		overFile="images/gamePauseBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPauseBtnRelease
	}
	pauseBtn:setReferencePoint( display.CenterReferencePoint )
	pauseBtn.x = rightXBound+22.5
	pauseBtn.y = maxVisibleY-95
	pauseBtn.xScale = .9
	pauseBtn.yScale = .9
	return pauseBtn
end


--CREATE POWERUP BUTTON
local function onPowerupBtnRelease()

end
function loadPowerupBtn()
	local powerupBtn = widget.newButton{
		defaultFile="images/gamePowerupBtn.png",
		overFile="images/gamePowerupBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPowerupBtnRelease
	}
	powerupBtn:setReferencePoint( display.CenterReferencePoint )
	powerupBtn.x = rightXBound+22.5
	powerupBtn.y = maxVisibleY-275
	powerupBtn.xScale = .9
	powerupBtn.yScale = .9
	return powerupBtn
end

--CREATE POWERUP DISABLED BUTTON
local function onPowerupDisabledBtnRelease()	
	playScore1()
	native.showAlert( "Powerups Disabled","This button is disabled on this level.",{ "OK" })	
end
function loadPowerupDisabledBtn()
	local powerupDisabledBtn = widget.newButton{
		defaultFile="images/gamePowerupDBtn.png",
		overFile="images/gamePowerupDBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPowerupDisabledBtnRelease
	}
	powerupDisabledBtn:setReferencePoint( display.CenterReferencePoint )
	powerupDisabledBtn.x = rightXBound+22.5
	powerupDisabledBtn.y = maxVisibleY-275
	powerupDisabledBtn.xScale = .9
	powerupDisabledBtn.yScale = .9
	return powerupDisabledBtn
end





--CREATE MORE BALLS BUTTON
local function onMoreBtnRelease()
	if moves.text+0 > 1 then 
		playMore()
		local moreBalls = createRandStageBalls(3,1,9)
		allball:insert(moreBalls)
		moves.text = moves.text - 1
		score.text = score.text - 100
	else
		playScore1()
		native.showAlert( "Not enough moves","You need more moves to add balls",{ "OK" })
	end
end
function loadMoreBtn()
	local moreBtn = widget.newButton{
		defaultFile="images/gameMoreBtn.png",
		overFile="images/gameMoreBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onMoreBtnRelease
	}
	moreBtn:setReferencePoint( display.CenterReferencePoint )
	moreBtn.x = rightXBound+22.5
	moreBtn.y = maxVisibleY-155
	moreBtn.xScale = .9
	moreBtn.yScale = .9
	return moreBtn
end

--CREATE MORE BALLS DISABLED BUTTON
local function onMoreDisabledBtnRelease()	
	playScore1()
	native.showAlert( "More Balls Disabled","This button is disabled on this level.",{ "OK" })	
end
function loadMoreDisabledBtn()
	local moreDisabledBtn = widget.newButton{
		defaultFile="images/gameMoreDBtn.png",
		overFile="images/gameMoreDBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onMoreDisabledBtnRelease
	}
	moreDisabledBtn:setReferencePoint( display.CenterReferencePoint )
	moreDisabledBtn.x = rightXBound+22.5
	moreDisabledBtn.y = maxVisibleY-155
	moreDisabledBtn.xScale = .9
	moreDisabledBtn.yScale = .9
	return moreDisabledBtn
end

--CREATE PLUS/MINUS BUTTON
function loadPlusBtn()
	
	local plusBtn = widget.newButton{
		defaultFile="images/gamePlusBtn.png",
		overFile="images/gamePlusMinusBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPlusMinusBtnRelease
	}
	plusBtn:setReferencePoint( display.CenterReferencePoint )
	plusBtn.x = rightXBound+22.5
	plusBtn.y = maxVisibleY-215
	plusBtn.xScale = .9
	plusBtn.yScale = .9
	if _G.lobal.mode == "add" then
		plusBtn.isVisible = true
	else
		plusBtn.isVisible = false
	end
	
	return plusBtn
end
function loadMinusBtn()
	
	local minusBtn = widget.newButton{
		defaultFile="images/gameMinusBtn.png",
		overFile="images/gamePlusMinusBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPlusMinusBtnRelease
	}
	minusBtn:setReferencePoint( display.CenterReferencePoint )
	minusBtn.x = rightXBound+22.5
	minusBtn.y = maxVisibleY-215
	minusBtn.xScale = .9
	minusBtn.yScale = .9	
	if _G.lobal.mode == "add" then
		minusBtn.isVisible = false
	else
		minusBtn.isVisible = true
	end	

	return minusBtn
end

--CREATE PLUS MINUS DISABLED BUTTON
local function onPlusMinusDisabledBtnRelease()	
	playScore1()
	native.showAlert( "Plus/Minus Disabled","This button is disabled on this level.",{ "OK" })	
end
function loadPlusMinusDisabledBtn()
	local plusMinusDisabledBtn = widget.newButton{
		defaultFile="images/gamePlusMinusDBtn.png",
		overFile="images/gamePlusMinusDBtnOver.png",
		width = 45,
		height = 45,
		onRelease = onPlusMinusDisabledBtnRelease
	}
	plusMinusDisabledBtn:setReferencePoint( display.CenterReferencePoint )
	plusMinusDisabledBtn.x = rightXBound+22.5
	plusMinusDisabledBtn.y = maxVisibleY-215
	plusMinusDisabledBtn.xScale = .9
	plusMinusDisabledBtn.yScale = .9
	return plusMinusDisabledBtn
end

--CREATE SOUND BUTTON
function loadSoundOnBtn()
	
	local soundOnBtn = widget.newButton{
		defaultFile="images/gameSoundOnBtn.png",
		overFile="images/gameSoundOnBtnOver.png",
		width = 45,
		height = 45,
		onRelease = soundChange
	}
	soundOnBtn:setReferencePoint( display.CenterReferencePoint )
	soundOnBtn.x = rightXBound+22.5
	soundOnBtn.y = maxVisibleY-35
	soundOnBtn.xScale = .9
	soundOnBtn.yScale = .9
	if _G.lobal.soundOn == true then
		soundOnBtn.isVisible = true
		audio.setVolume( .5 )
	else
		soundOnBtn.isVisible = false
		audio.setVolume( 0 )
	end
	return soundOnBtn
end

function loadSoundOffBtn()
	
	local soundOffBtn = widget.newButton{
		defaultFile="images/gameSoundOffBtn.png",
		overFile="images/gameSoundOffBtnOver.png",
		width = 45,
		height = 45,
		onRelease = soundChange
	}
	soundOffBtn:setReferencePoint( display.CenterReferencePoint )
	soundOffBtn.x = rightXBound+22.5
	soundOffBtn.y = maxVisibleY-35
	soundOffBtn.xScale = .9
	soundOffBtn.yScale = .9
	if _G.lobal.soundOn == false then
		soundOffBtn.isVisible = true
	else
		soundOffBtn.isVisible = false
	end
	
	return soundOffBtn
end

-- CREATE ORANGE WALLS --
function createOrangeWall(xStart,yStart,c,d)	
	local orangeWall = display.newRect (xStart,yStart,c,d)
	orangeWall:setFillColor(255,255,255,175)
	physics.addBody (orangeWall, "static", {bounce=.2, density=1.0})
	return orangeWall
end

function createYellowWall(xStart,yStart,c,d)
	local yellowWall = display.newRect (xStart,yStart,c,d)
	yellowWall:setFillColor(255,255,0,175)
	physics.addBody (yellowWall, "dynamic", {bounce=.3, density=1.0})
	return yellowWall
end

function createPurpleWall(xStart,yStart,c,d)
	local purpleWall = display.newRect (xStart,yStart,c,d)
	purpleWall:setFillColor(255,0,255,175)
	physics.addBody (purpleWall, "static", {bounce=.3, density=1.0,friction=1})
	purpleWall.isBullet = true
	purpleWall:setReferencePoint( display.CenterReferencePoint )
	
	return purpleWall
end


-- CREATE BLUE FLASHING WALLS --
function createBlueWall(a,b,c,d)	
			
	local function cycleWall()
		
		if _G.blueWall then
			
			if 	_G.blueWall.isVisible == false then
				playBlueWall()
				_G.blueWall.isVisible = true
				physics.addBody (_G.blueWall, "static", {bounce=.2, density=1.0})

			elseif 	_G.blueWall.isVisible == true then

				_G.blueWall.isVisible = false
				physics.removeBody (_G.blueWall)

			end
			
		else
			_G.blueWall = display.newRect (a,b,c,d)
			_G.blueWall:setFillColor(50,50,250, 250)
			physics.addBody (_G.blueWall, "static", {bounce=.2, density=1.0})
			_G.blueWall.isVisible = true
			
			
		end
		
	end
	
	_G.blueWTimer = timer.performWithDelay(700,cycleWall, -1)
	
	
end

-- CREATE GREEN WALLS --
function createGreenWall(xStart,yStart,c,d)	
	local greenWall = display.newRect (xStart,yStart,c,d)	 ; greenWall:setFillColor(50,250,50)
	physics.addBody (greenWall, "static", {bounce=.2, density=1.0})
	local function removegreenWall(event)
		if (event.phase == "ended" )  and event.other == cueball then 
			playGreenWall()
			if greenWall then
				greenWall:removeSelf()
			end	
		end
	end
	greenWall:addEventListener ("collision", removegreenWall)
	return greenWall
end

-- CREATE RED WALLS --
function createRedWall(xStart,yStart,c,d)	
	local redWall = display.newRect (xStart,yStart,c,d)
	redWall:setFillColor(255,0,0)
	physics.addBody (redWall, "static", {bounce=1.5, density=1.0})
	return redWall
end

function onCueballCollision(self,event)
	--print("cueball collides!!!!")
	if (event.phase == "ended" ) then
		playCueCollision()
	end
end

--CREATE CUEBALL
function createCueball (cueballX,cueballY,startingValue)
	local mainball = display.newImageRect ("images/mainball.png", 40,40)
--	mainball:setReferencePoint( display.CenterReferencePoint )
	
	_G.mainballnumber = display.newText ( 0, 0,0,native.systemFontBold, 24)
	mainballnumber.text = 0 + startingValue
	mainballnumber:setReferencePoint( display.CenterReferencePoint )
	mainballnumber.x = 0
	mainballnumber.y = 0

	mainballnumber:setTextColor (255,255,255)

	local cueball = display.newGroup()
	
	cueball:insert ( mainball )
	cueball:insert ( mainballnumber )

	cueball.x = cueballX
	cueball.y = cueballY

	physics.addBody( cueball, {density=1, friction=.2, bounce=.8, radius=19.5} )
	cueball.linearDamping = 0.2
	cueball.isFixedRotation = true
	cueball.isBullet = true
	cueball.xScale=.01
	cueball.yScale=.01
	transition.to(cueball,{time=300,delay=1000,xScale=1,yScale=1})
	
	cueball.collision = onCueballCollision
	cueball:addEventListener ("collision", cueball)
	
	return cueball
end

--CREATE TARGET
function createTarget()
	target = display.newImageRect( "images/target.png",65,65 )
	target.alpha = 0

end

-- CUEBALL MOVE FUNCTION --
function ballShot( event )	
	local t = event.target
	
	local phase = event.phase
	
		if "began" == phase and moves.text <= "0" then
			onLevelFail()
		
	
		elseif "began" == phase then
		stopCueballTrace()	
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		
		-- Stop current cueball motion, if any
		t:setLinearVelocity( 0, 0 )
		t.angularVelocity = 0

		target.x = t.x
		target.y = t.y
		
		startRotation = function()
			target.rotation = target.rotation + 1
		end
		
		Runtime:addEventListener( "enterFrame", startRotation )
		
		local showTarget = transition.to( target, { alpha=0.6, time=250, xScale = 1 , yScale = 1 } )
		myLine = nil

	elseif t.isFocus then
		if "moved" == phase then
		
			
			if ( myLine ) then
				myLine.parent:remove( myLine ) -- erase previous line, if any
			end
				myLine = display.newLine( t.x,t.y, event.x,event.y )
				local lineD = (math.abs(t.x - event.x) +  math.abs(t.y - event.y))
				local r = lineD/4
				if r > 255 then
					r = 255
				elseif r < 20 then
					r = 20
				end
				local b = 9000/lineD
				if b > 255 then
					b = 255
				elseif b < 30 then
					b = 30
				end
				myLine:setColor( r, 0, b, 60 )
				local lineWidth = lineD/45
				if lineWidth < 2
					then lineWidth = 2
				end
				myLine.width = lineWidth
				target.x = cueball.x
				target.y = cueball.y

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end
			
			local hideTarget = transition.to( target, { alpha=0, rotation = 0,xScale=.4, yScale=.4, time=250, onComplete=stopRotation } )
			
			if ( myLine ) then
				myLine.parent:remove( myLine )
			end
			
			-- Strike the ball!
			t:applyForce( (t.x - event.x), (t.y - event.y), t.x, t.y )

			local totalForce = math.abs(t.x - event.x) +  math.abs(t.y - event.y)
			
			cueballTRACE(totalForce)
			playCueShot()
			if moves.text+0 > 0 then
				moves.text = moves.text - 1
			end
		end
	end

	-- Stop further propagation of touch event
	return true
end



--load cue ball
function loadCueball(cueballX,cueballY,startValue)
	cueball = createCueball(cueballX,cueballY,startValue)
	createTarget()
	cueball:addEventListener( "touch", ballShot )
	cueball.collision = onCueballCollision
	cueball:addEventListener ("collision", cueball)
	return cueball
end
	

-- CREATE STAGE BALLS

function onballCollision (self, event)
	
	local fadeTime = 150
	local function removeSelf()
		self:removeSelf()
	end
	
	--Addition for less than 10
	if (event.phase == "ended" ) and (event.other == cueball) and
		(self.value + _G.mainballnumber.text < 10 ) and _G.lobal.mode == "add" then
		self:removeEventListener ("collision", self)
		cueball:setLinearVelocity (0,0)	
		self:setLinearVelocity (0,0)

		transition.to(self,{time=fadeTime,xScale=0.01,yScale=0.01,onComplete=removeSelf})
		mainballnumber.text = mainballnumber.text + self.value
		score.text = score.text + ( 50 * self.value)
		playAdd()
		stopCueballTrace()

	--Subtraction
	elseif (event.phase == "ended" ) and (event.other == cueball) and 
		(mainballnumber.text - self.value >= 0 ) and _G.lobal.mode == "subtract" then
		self:removeEventListener ("collision", self)
		cueball:setLinearVelocity (0,0)	
		self:setLinearVelocity (0,0)
		transition.to(self,{time=fadeTime,xScale=0.01,yScale=0.01,onComplete=removeSelf})
		mainballnumber.text = mainballnumber.text - self.value
		score.text = score.text + ( 25 * self.value)
		playSub()
		stopCueballTrace()
		
	--Addition to 10
	elseif (event.phase == "ended" ) and (event.other == cueball) and 
		(self.value + mainballnumber.text == 10 ) and _G.lobal.mode == "add" then 
		self:removeEventListener ("collision", self)
		cueball:setLinearVelocity (0,0)	
		self:setLinearVelocity (0,0)
		transition.to(self,{time=fadeTime,xScale=0.01,yScale=0.01,onComplete=removeSelf})
		mainballnumber.text = 0
		score.text = score.text + 250 + ( 100 * self.value)
		-- playAdd()
		-- playSub()
		playTen()
		stopCueballTrace()
		
		if goal.text+0 > 0 then
			goal.text = goal.text - 1
		end
		
	elseif (event.phase == "ended" ) then 
		local ballValue = self.value
		playStageBallCollision(ballValue)
	
	end
end

function createRandStageBallsNoSleeping(a,b,c)
	
	local ball = {}
	local ballv = {}
	local ballc = {}
	
	local randStageBalls = display.newGroup()
		
		for n = 1,a do
		
			ball[n] = {}
			ballc[n] = {}
			ballv[n] = {}
		
	
			ball[n]  = display.newGroup()
			ball[n].value = math.random(b,c)
			
			ballc[n] = display.newImageRect( "images/ball"..ball[n].value..".png", 31,31 )
			ball[n]:insert (ballc[n], false)
	
			ballv[n] = display.newText ( ball[n].value, 0,0,"HelveticaNeue", 19) 
			ballv[n]:setTextColor(255,255,255,205)
			ballv[n]:setReferencePoint( display.CenterReferencePoint )
			ballv[n].x = 0
			ballv[n].y = 0	
			ball[n]:insert (ballv[n], false)
	
			ball[n].x = math.random (display.screenOriginX+20,rightXBound-20)
			ball[n].y = math.random (roofHeight+20,maxVisibleY-20)
	
			physics.addBody( ball[n], {density=1, friction=.15, bounce=.9, radius=15} )
			ball[n].linearDamping = 0.1
			ball[n].angularDamping = 100
			ball[n].isBullet = true
			ball[n].isSleepingAllowed = false

			randStageBalls:insert (ball[n])
	
			ball[n].collision = onballCollision
			ball[n]:addEventListener ("collision", ball[n])
		end
	return randStageBalls
end

function createRandStageBalls(a,b,c)
	
	local ball = {}
	local ballv = {}
	local ballc = {}
	
	local randStageBalls = display.newGroup()
		
		for n = 1,a do
		
			ball[n] = {}
			ballc[n] = {}
			ballv[n] = {}
		
	
			ball[n]  = display.newGroup()
			ball[n].value = math.random(b,c)
			
			ballc[n] = display.newImageRect( "images/ball"..ball[n].value..".png", 31,31 )
			ball[n]:insert (ballc[n], false)
	
			ballv[n] = display.newText ( ball[n].value, 0,0,"HelveticaNeue", 19) 
			ballv[n]:setTextColor(255,255,255,205)
			ballv[n]:setReferencePoint( display.CenterReferencePoint )
			ballv[n].x = 0
			ballv[n].y = 0	
			ball[n]:insert (ballv[n], false)
	
			ball[n].x = math.random (display.screenOriginX+20,rightXBound-20)
			ball[n].y = math.random (roofHeight+20,maxVisibleY-20)
	
			physics.addBody( ball[n], {density=1, friction=.15, bounce=.9, radius=15} )
			ball[n].linearDamping = 0.1
			ball[n].angularDamping = 100
			ball[n].isBullet = true

			randStageBalls:insert (ball[n])
	
			ball[n].collision = onballCollision
			ball[n]:addEventListener ("collision", ball[n])
		end
	return randStageBalls
end


function createRandStageBallsXY(a,b,c,d,e,f,g)
	
	local ball = {}
	local ballv = {}
	local ballc = {}
	
	local randStageBalls = display.newGroup()
		
		for n = 1,a do
		
			ball[n] = {}
			ballc[n] = {}
			ballv[n] = {}
		
	
			ball[n]  = display.newGroup()
			ball[n].value = math.random(b,c)
			
			ballc[n] = display.newImageRect( "images/ball"..ball[n].value..".png", 31,31 )
			ball[n]:insert (ballc[n], false)
	
			ballv[n] = display.newText ( ball[n].value, 0,0,"HelveticaNeue", 19) 
			ballv[n]:setTextColor(255,255,255,205)
			ballv[n]:setReferencePoint( display.CenterReferencePoint )
			ballv[n].x = 0
			ballv[n].y = 0	
			ball[n]:insert (ballv[n], false)
	
			ball[n].x = math.random (d,e)
			ball[n].y = math.random (f,g)
	
			physics.addBody( ball[n], {density=1, friction=.15, bounce=.9, radius=15} )
			ball[n].linearDamping = 0.1
			ball[n].angularDamping = 100
			ball[n].isBullet = true

			randStageBalls:insert (ball[n])
	
			ball[n].collision = onballCollision
			ball[n]:addEventListener ("collision", ball[n])
		end
	return randStageBalls
end



function createSpecificStageBall(a,b,c)

	ball = display.newGroup()
	ball.value = a
	
	ballc = display.newImageRect( "images/ball"..ball.value..".png", 31,31 )
	ball:insert (ballc, false)

	ballv = display.newText ( ball.value, 0,0,"HelveticaNeue", 19) 
	ballv:setTextColor(255,255,255,205)
	ballv:setReferencePoint( display.CenterReferencePoint )
	ballv.x = 0
	ballv.y = 0	
	ball:insert (ballv, false)
	
	ball.x = b
	ball.y = c

	physics.addBody( ball, {density=1, friction=.15, bounce=.9, radius=15} )
	ball.linearDamping = 0.1
	ball.angularDamping = 100
	ball.isBullet = true
	ball.isSleepingAllowed = false

	ball.collision = onballCollision
	ball:addEventListener ("collision", ball)

	return ball
end




return gameLogic