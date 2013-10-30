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

local function onLSNextBtnRelease()

	_G.lobal.currentLevelGroup = _G.lobal.currentLevelGroup + 1
	if _G.lobal.currentLevelGroup == 2 then
		removeLevelGroups()
		levelGroup2 = loadLSGroup(16,30)
	elseif 	_G.lobal.currentLevelGroup == 3 then
		playScore1()
		_G.lobal.currentLevelGroup = 2
	end
	utilities.saveSavedItems()
end
local function onLSPreviousBtnRelease()
	_G.lobal.currentLevelGroup = _G.lobal.currentLevelGroup - 1
	if _G.lobal.currentLevelGroup == 1 then
		removeLevelGroups()
		levelGroup1 = loadLSGroup(1,15)
	elseif 	_G.lobal.currentLevelGroup == 0 then
		playScore1()
		_G.lobal.currentLevelGroup = 1
	end
	utilities.saveSavedItems()
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

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	utilities.loadSavedItems()
	utilities.ifBlankSetDefaultSavedItems()
	utilities.saveSavedItems()

	
	if _G.lobal.currentLevel < 16 then
		_G.lobal.currentLevelGroup = 1
	elseif _G.lobal.currentLevel > 15 and _G.lobal.currentLevel < 31 then
		_G.lobal.currentLevelGroup = 2
	end
	utilities.saveSavedItems()
	
	navBtns = loadLSNavBtns()
	group:insert(navBtns)	
	
	if _G.lobal.currentLevelGroup == 1 then
		levelGroup1 = loadLSGroup(1,15)
		group:insert(levelGroup1)
	elseif _G.lobal.currentLevelGroup == 2 then
		levelGroup2 = loadLSGroup(16,30)
		group:insert(levelGroup2)
	end
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	clearLSStage()

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

function loadLSNavBtns()

		local fadeTime = 300
		local btn1x = halfW + 70
		local btn2x = halfW - 70
		local navGroup = display.newGroup()
		
		local LSNextBtn = widget.newButton{
			defaultFile="images/LSNextBtn.png",
			overFile="images/LSNextBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onLSNextBtnRelease
		}
		LSNextBtn:setReferencePoint( display.BottomLeftReferencePoint )
		LSNextBtn.x = 540
		LSNextBtn.y = 310
		transition.to(LSNextBtn,{time=fadeTime,x=btn1x})
		navGroup:insert(LSNextBtn)	
		
		local LSInstructionsBtn = widget.newButton{
			defaultFile="images/LSInstructionsBtn.png",
			overFile="images/LSInstructionsBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToInstructions
		}
		LSInstructionsBtn:setReferencePoint( display.TopLeftReferencePoint )
		LSInstructionsBtn.x = 540
		LSInstructionsBtn.y = 10
		transition.to(LSInstructionsBtn,{time=fadeTime,x=btn1x})
		navGroup:insert(LSInstructionsBtn)	
		
		local LSMenuBtn = widget.newButton{
			defaultFile="images/LSMenuBtn.png",
			overFile="images/LSMenuBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToMenu
		}
		LSMenuBtn:setReferencePoint( display.TopRightReferencePoint )
		LSMenuBtn.x = -45
		LSMenuBtn.y = 10
		transition.to(LSMenuBtn,{time=fadeTime,x=btn2x})
		navGroup:insert(LSMenuBtn)	
		
		local LSPreviousBtn = widget.newButton{
			defaultFile="images/LSPreviousBtn.png",
			overFile="images/LSPreviousBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onLSPreviousBtnRelease
		}
		LSPreviousBtn:setReferencePoint( display.BottomRightReferencePoint )
		LSPreviousBtn.x = -45
		LSPreviousBtn.y = 310
		transition.to(LSPreviousBtn,{time=fadeTime,x=btn2x})
		navGroup:insert(LSPreviousBtn)	
		
		-- local LSPurchaseBtn = widget.newButton{
		-- 	defaultFile="images/LSPurchaseBtn.png",
		-- 	overFile="images/LSPurchaseBtnOver.png",
		-- 	width = 118,
		-- 	height = 33,
		-- 	--onRelease = onLWRetryBtnRelease
		-- }
		-- LSPurchaseBtn:setReferencePoint( display.BottomCenterReferencePoint )
		-- LSPurchaseBtn.x = halfW
		-- LSPurchaseBtn.y = 400
		-- transition.to(LSPurchaseBtn,{time=fadeTime,y=310})
		-- navGroup:insert(LSPurchaseBtn)
		
		local LSTitle = display.newImageRect("images/LSTitle.png",104,33)
		LSTitle:setReferencePoint( display.TopCenterReferencePoint )
		LSTitle.x = halfW
		LSTitle.y = 10
		LSTitle.alpha = 0
		transition.to(LSTitle,{time=fadeTime,alpha=1})
		navGroup:insert(LSTitle)
		
		return navGroup
end


-------------------------------------------------------------------
----CREATE LEVEL SELECT ITEMS
-----------------------------------------------------------

function loadLevelSelectRow(firstNum,lastNum,yValue,red,green,blue,rDelta,gDelta,bDelta)
	
	local levelBtn = {}
	local startX = 80
	local xSpace = 80
	local LSRow = display.newGroup()
	local n = 1
	local color = {}

	for i = firstNum,lastNum do
		
		color[i] = {red+(n-1)*rDelta,green+(n-1)*gDelta,blue+(n-1)*bDelta}
		
		local stageBeat = false
		local highScore = _G.lobal.highScores[i]
		local previousLevelScore = 1
		if i > 1 then
			previousLevelScore = _G.lobal.highScores[i-1]
		end
		
		local function goToLevelNum()
			playMore()
			storyboard.gotoScene("scripts.levels.level"..i.."", "fade", 250 ) 
		end
		local onLevelBtnRelease = goToLevelNum
		local labelColor = {255,255,255}
		if highScore > 0 then
			stageBeat = true
			labelColor = color[i]
		else
			if previousLevelScore == 0 then
				color[i] = {200,200,200,45}
				onLevelBtnRelease = playScore1
				labelColor = color[i]
			end
		end
		
		
		
		
				
 		levelBtn[i] = widget.newButton{
			label = i,
			labelColor = {default=labelColor,over=color[i]},
			xOffset = -1,
			yOffset = -3,
			width = 50,
			height = 50,
			font = "HelveticaNeue-Bold",
			fontSize = 27,
			cornerRadius = 25,
			defaultFileColor = {0,0,0,0},
			overColor = {0,0,0,255},
			strokeColor =color[i],
			strokeWidth = 1,
			onRelease = onLevelBtnRelease
		}
		levelBtn[i]:setReferencePoint( display.CenterReferencePoint )
		levelBtn[i].goTo = "scripts.level"..i..""
		levelBtn[i].x = n*xSpace
		n = n + 1
		levelBtn[i].y = yValue
		
		local levelBtnGroup = display.newGroup()
		levelBtnGroup:insert(levelBtn[i])
		
		local stageBeat = false
		local highScore = _G.lobal.highScores[i]
		
		if highScore > 0 then
			stageBeat = true
		end
		if stageBeat == true then
			local star = display.newImageRect("images/star.png",20,20)
			star:setReferencePoint( display.CenterReferencePoint )
			star.x= levelBtn[i].x
			star.y= yValue+23
			levelBtnGroup:insert(star)
		end
		
		local randNum = math.random(1,9)
		local soundOnComplete = playScore1
		
		if stageBeat == true then
			if randNum == 1 then
				soundOnComplete = playOne
			elseif randNum == 2 then
				soundOnComplete = playTwo	
			elseif randNum == 3 then
				soundOnComplete = playThree	
			elseif randNum == 4 then
				soundOnComplete = playFour
			elseif randNum == 5 then
				soundOnComplete = playFive
			elseif randNum == 6 then
				soundOnComplete = playSix	
			elseif randNum == 7 then
				soundOnComplete = playSeven	
			elseif randNum == 8 then
				soundOnComplete = playEight
			elseif randNum == 9 then
				soundOnComplete = playNine
			end
		end
			
		levelBtnGroup.alpha = 0.01
		local randNum2 = math.random(1,2)
		if randNum2 ==1 then
			levelBtnGroup.y = 75
		else
			levelBtnGroup.y = -75
		end
		
		levelBtnGroup.xScale = 0.01
		local z = i
		if z > 15 and z < 31 then
			z = z - 15
		elseif 	z > 30 and z < 46 then
			z = z - 30
		end
		transition.to(levelBtnGroup,{time=z*150,y=0,transition=easing.inExpo,alpha=1,xScale=1,onComplete=soundOnComplete})

		LSRow:insert(levelBtnGroup)
	end

	return LSRow
	
end

function loadLSGroup(first,last)

	local LSGroup = display.newGroup()
	local row1Last = first + 4
	local row2First = row1Last + 1
	local row2Last = row2First + 4
	local row3First = row2Last + 1
	local yOne = 90
	local yTwo = halfH
	local yThree = 230

	local row1 = loadLevelSelectRow(first,row1Last,yOne,0,255,0,63,0,0)
	LSGroup:insert(row1)
	local row2 = loadLevelSelectRow(row2First,row2Last,yTwo,255,200,0,0,-50,0)
	LSGroup:insert(row2)
	local row3 = loadLevelSelectRow(row3First,last,yThree,200,0,50,0,0,50)
	LSGroup:insert(row3)
	
	return LSGroup
end
-- 

function removeLevelGroups()
	if levelGroup1 then
		levelGroup1:removeSelf()
		levelGroup1 = nil
	end
	if levelGroup2 then
		levelGroup2:removeSelf()
		levelGroup2 = nil
	end
	if levelGroup3 then
		levelGroup3:removeSelf()
		levelGroup3 = nil
	end
	if levelGroup4 then
		levelGroup4:removeSelf()
		levelGroup4 = nil
	end
	if levelGroup5 then
		levelGroup5:removeSelf()
		levelGroup5 = nil
	end
	if levelGroup5 then
		levelGroup5:removeSelf()
		levelGroup5 = nil
	end
end
function removeAllLSItems()
	if navBtns then
		navBtns:removeSelf()
		navBtns = nil
	end
	removeLevelGroups()

end	

function clearLSStage()
	local fadeTime = 200
	transition.to(navBtns,{time=fadeTime,alpha=0,onComplete=removeAllLSItems})
end	




return scene