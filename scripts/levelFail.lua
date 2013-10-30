-----------------------------------------------------------------------------------------
--
-- levelSelect.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"


--------------------------------------------
local function onLFInstructionsBtnRelease()
	storyboard.hideOverlay("fade",200)
	local options = {
		effect = "fade",
		time = 400,
	}
	storyboard.gotoScene("scripts.instructions",options)
end

local function onLFRetryBtnRelease()
	storyboard.hideOverlay("fade",200)
	reloadLevel()
end

local function onLFSelectBtnRelease()
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
	--stopCueballTrace()
	removeBlueWall()
	local levelFailBack = display.newImageRect("images/levelFailBack.png",570,380)
	levelFailBack:setReferencePoint( display.CenterReferencePoint )
	levelFailBack.x = halfW
	levelFailBack.y = halfH
	group:insert(levelFailBack)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	LFnavBtns = loadLFNavBtns()
	group:insert(LFnavBtns)	
	playFail()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	removeAllLFItems()

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

function loadLFNavBtns()

		local fadeTime = 300
		local btn1x = halfW + 70
		local btn2x = halfW - 70
		local LFnavGroup = display.newGroup()
		
		local LFInstructionsBtn = widget.newButton{
			defaultFile="images/LFInstructionsBtn.png",
			overFile="images/LSInstructionsBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onLFInstructionsBtnRelease
		}
		LFInstructionsBtn:setReferencePoint( display.BottomLeftReferencePoint )
		LFInstructionsBtn.x = 540
		LFInstructionsBtn.y = 310
		transition.to(LFInstructionsBtn,{time=fadeTime,x=btn1x})
		LFnavGroup:insert(LFInstructionsBtn)	
		
		local LFSelectBtn = widget.newButton{
			defaultFile="images/LWSelectBtn.png",
			overFile="images/LWSelectBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onLFSelectBtnRelease
		}
		LFSelectBtn:setReferencePoint( display.BottomRightReferencePoint )
		LFSelectBtn.x = -45
		LFSelectBtn.y = 310
		transition.to(LFSelectBtn,{time=fadeTime,x=btn2x})
		LFnavGroup:insert(LFSelectBtn)	
		
		local LFRetryBtn = widget.newButton{
			defaultFile="images/LWRetryBtn.png",
			overFile="images/LWRetryBtnOver.png",
			width = 118,
			height = 33,
			onRelease = onLFRetryBtnRelease
		}
		LFRetryBtn:setReferencePoint( display.BottomCenterReferencePoint )
		LFRetryBtn.x = halfW
		LFRetryBtn.y = 400
		transition.to(LFRetryBtn,{time=fadeTime,y=200})
		LFnavGroup:insert(LFRetryBtn)
		
		return LFnavGroup
end




function removeAllLFItems()
	if LFnavBtns then
		LFnavBtns:removeSelf()
		LFnavBtns = nil
	end
	
	
	
end	






return scene