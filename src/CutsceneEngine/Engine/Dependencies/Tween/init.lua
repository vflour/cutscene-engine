local Tween = {}
-- A simple tween animation loader that I use in projects that I'm working on. Feel free to use it for yourself
-- Created by vflour/CrammelApple


local TweenService = game:GetService("TweenService")
local AnimLoader = require(script.AnimLoader)

local loadedTweens = {}

---------------- ANIM LOADER ------------------
-- Load stored animations into an object
function Tween:LoadAnimation(object,keyFrames,destroyOnComplete)
	-- default to true
	if destroyOnComplete == nil then destroyOnComplete = true end
	
	local animator = AnimLoader.new(keyFrames,object)
	animator:Play()
	if destroyOnComplete then
		animator.Complete.Event:Connect(function() DestroyAnimationOnComplete(animator) end)
	end
	return animator
end

-- Removing an animation on completion
function DestroyAnimationOnComplete(animator)
	animator:Destroy()
end

---------------- TWEEN LOADER ------------------
-- for quick animations such as size tweening, etc.

function Tween:BasicAnimation(object,tweenInfo,properties)
	local tween = TweenService:Create(object,tweenInfo,properties)
	-- autodispose the tween when it's done
	tween.Completed:Connect(function() DisposeTweenOnCompletion(tween) end)
	tween:Play()
end

function DisposeTweenOnCompletion(tween)
	tween:Destroy()
end

return Tween
