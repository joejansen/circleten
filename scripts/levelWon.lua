-----------------------------------------------------------------------------------------
--
-- levelSelect.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local utilities = require ("scripts.utilities")

--------------------------------------------

local function onLWNextBtnRelease()
	local nextLevel = _G.lobal.currentLevel + 1

		storyboard.hideOverlay("fade",200)
		local options = {
		effect = "fade",
		time = 400,
		}
		storyboard.gotoScene("scripts.levels.level"..nextLevel.."",options)

end

local function onLWRetryBtnRelease()
	storyboard.hideOverlay("fade",200)
	reloadLevel()
end

local function onLWSelectBtnRelease()
	storyboard.hideOverlay("fade",200)
	local options = {
		effect = "fade",
		time = 400,
	}
	storyboard.gotoScene("scripts.levelSelect",options)
end
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	-- stopCueballTrace()
	removeBlueWall()
	local levelWonBack = display.newImageRect("images/levelOverBack.png",570,380)
	levelWonBack:setReferencePoint( display.CenterReferencePoint )
	levelWonBack.x = halfW
	levelWonBack.y = halfH
	group:insert(levelWonBack)
	
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	local LWnavBtns = loadLWNavBtns()
	group:insert(LWnavBtns)	

	local finalScore = event.params.finalScore
	local movesLeft = event.params.movesLeft
	local fadeTime = 200
	local delayTime = 200
	local xPosStart = halfW+35
	local xPosEnd = halfW+5

	local scoreText = display.newText(finalScore,xPosStart,59,200,24,"HelveticaNeue",20)
	scoreText:setTextColor (136,136,136, 255)
	
	group:insert(scoreText)
	scoreText:setReferencePoint(display.TopLeftReferencePoint)
	scoreText.alpha = 0 
	scoreText.xScale = 2
	scoreText.yScale = 2
	transition.to(scoreText,{time=fadeTime,delay=delayTime*0,alpha=1,xScale=1,yScale=1,x=xPosEnd,onComplete=playScore1})
	
	movesScoreText = movesLeft*500
	local movesScore = display.newText(movesScoreText,xPosStart,79,200,24,"HelveticaNeue",20)
	movesScore:setTextColor (136,136,136, 255)
	
	group:insert(movesScore)
	movesScore:setReferencePoint(display.TopLeftReferencePoint)
	movesScore.alpha = 0 
	movesScore.xScale = 2
	movesScore.yScale = 2
	transition.to(movesScore,{time=fadeTime,delay=delayTime*1,alpha=1,xScale=1,yScale=1,x=xPosEnd,onComplete=playScore2})
	
	local levelScoreText = _G.lobal.currentLevel*100
	local levelScore = display.newText(levelScoreText,xPosStart,101,200,24,"HelveticaNeue",20)
	levelScore:setTextColor (136,136,136, 255)
	
	group:insert(levelScore)
	levelScore:setReferencePoint(display.TopLeftReferencePoint)
	levelScore.alpha = 0 
	levelScore.xScale = 2
	levelScore.yScale = 2
	transition.to(levelScore,{time=fadeTime,delay=delayTime*2,alpha=1,xScale=1,yScale=1,x=xPosEnd,onComplete=playScore3})
	
	local totalScoreText = scoreText.text + movesScore.text + levelScore.text
	local totalScore = display.newText(totalScoreText,xPosStart,135,200,28,"HelveticaNeue",24)
	totalScore:setTextColor (50,250,50, 255)
	
	group:insert(totalScore)
	totalScore:setReferencePoint(display.TopLeftReferencePoint)
	totalScore.alpha = 0 
	totalScore.xScale = 2
	totalScore.yScale = 2
	transition.to(totalScore,{time=fadeTime,delay=delayTime*4,alpha=1,xScale=1,yScale=1,x=xPosEnd,onComplete=playScore4})
	
	utilities.loadSavedItems()
	utilities.ifBlankSetDefaultSavedItems()
	utilities.saveSavedItems()
	
	local newHighScore = totalScore.text+0
	local oldHighScore = _G.lobal.highScores[_G.lobal.currentLevel]
	
	if newHighScore < oldHighScore then
		newHighScore = oldHighScore
	elseif newHighScore > oldHighScore then
		newHighScore = totalScore.text
		_G.lobal.highScores[_G.lobal.currentLevel] = totalScore.text+0
		utilities.saveSavedItems()
	end
	
	local highScore = display.newText(newHighScore,xPosStart,170,200,28,"HelveticaNeue",24)
	highScore:setTextColor (250,250,50, 255)
	
	group:insert(highScore)
	highScore:setReferencePoint(display.TopLeftReferencePoint)
	highScore.alpha = 0 
	highScore.xScale = 2
	highScore.yScale = 2
	transition.to(highScore,{time=fadeTime,delay=delayTime*5,alpha=1,xScale=1,yScale=1,x=xPosEnd,onComplete=playScore5})
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	removeAllLWItems()

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

function loadLWNavBtns()

		local fadeTime = 300
		local btn1x = halfW + 70
		local btn2x = halfW - 70
		local LWnavGroup = display.newGroup()
		
		if _G.lobal.currentLevel < 30 then
			local LWNextBtn = widget.newButton{
				defaultFile="images/LSNextBtn.png",
				overFile="images/LSNextBtnOver.png",
				width = 375,
				height = 33,
				onRelease = onLWNextBtnRelease
			}
			LWNextBtn:setReferencePoint( display.BottomLeftReferencePoint )
			LWNextBtn.x = 540
			LWNextBtn.y = 310
			transition.to(LWNextBtn,{time=fadeTime,x=btn1x})
			LWnavGroup:insert(LWNextBtn)	
		else 
			lastLevelAlert()
		end
		
		local LWSelectBtn = widget.newButton{
			defaultFile="images/LWSelectBtn.png",
			overFile="images/LWSelectBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onLWSelectBtnRelease
		}
		LWSelectBtn:setReferencePoint( display.BottomRightReferencePoint )
		LWSelectBtn.x = -45
		LWSelectBtn.y = 310
		transition.to(LWSelectBtn,{time=fadeTime,x=btn2x})
		LWnavGroup:insert(LWSelectBtn)	
		
		local LWRetryBtn = widget.newButton{
			defaultFile="images/LWRetryBtn.png",
			overFile="images/LWRetryBtnOver.png",
			width = 118,
			height = 33,
			onRelease = onLWRetryBtnRelease
		}
		LWRetryBtn:setReferencePoint( display.BottomCenterReferencePoint )
		LWRetryBtn.x = halfW
		LWRetryBtn.y = 400
		transition.to(LWRetryBtn,{time=fadeTime,y=310})
		LWnavGroup:insert(LWRetryBtn)
		
		return LWnavGroup
end




function removeAllLWItems()
	if LWnavGroup then
		LWnavGroup:removeSelf()
		LWnavGroup = nil
	end
end	






return scene