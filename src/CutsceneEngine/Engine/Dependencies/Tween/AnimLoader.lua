local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")


---------------- ANIMATION HANDLER ------------------
local Animations = {}
function AnimationQueue()
	local t = RunService.RenderStepped:wait()
	for index,animation in pairs(Animations) do	
		if animation.Playing then AdvanceAnimation(animation,t) end
	end
end
RunService.RenderStepped:connect(AnimationQueue)


function AdvanceAnimation(animation,t)
	-- clear unused keyframes
	ConfigureTweens(animation)
	
	-- stop the anim and exit if theres no further frames
	if not animation.KeyFrames[animation.Frame+1] then 
		if not animation.Looping then 
			animation:Stop()
			animation.Complete:Fire()
			return
		else -- Restart the animation if its looping
			animation.Frame = 1
			animation.Time = 0
		end
	end
	-- Checks if the timestamp is right
	
	local timeDiff = animation.KeyFrames[animation.Frame]["%TIMESTAMP%"] - animation.Time
	if timeDiff <= 0.01 then
		for partName,partFrame in pairs(animation.KeyFrames[animation.Frame]) do
			-- check if the keyname isnt a property, ea %TEST% or %TIMESTAMP%
			local propertyPattern="%%[]%d%u]+%%" 
			if not string.match(partName,propertyPattern) then
				local reference = GetReference(animation.Object,partName)
				if not reference then 
					animation:Destroy()
					return 
				end
				SetProperties(reference,partFrame)
				TweenProperties(reference,animation,partName)
			end 
		end
		-- Increment the frame
		animation.Frame = animation.Frame + 1	
	end
	animation.Time = animation.Time+t
end

function GetReference(object,partName)
	local hierarchy = string.split(partName,".")
	local reference = object
	if partName == "" then -- exit if there is no children, aka root
		return reference
	end
	for _,part in pairs(hierarchy) do
		reference = reference:FindFirstChild(part)
		-- Return missing reference (debug)
		if not reference then
			warn("There is no "..part.." in "..object.Name)
			break
		end
	end
	
	return reference
end
-- Sets the property of the reference
function SetProperties(reference,partFrame)
	for propertyName, propertyValue in pairs(partFrame) do
		local isProperty,errorMsg = pcall(function() return reference[propertyName] end)
		if isProperty then
			reference[propertyName] = propertyValue
		else
			warn(propertyName.." is not a property: "..errorMsg)
		end
	end
end

-- Tweens the remaining property
function TweenProperties(reference,animation,partName)
	-- Check if theres a next KeyFrame Instance to tween to
	local nextFrameInstance,nextPartInstance = GetNextKeyFrame(reference,animation,partName)
	if not nextFrameInstance then return end
	
	-- Try to tween from the first frame to another
	local success, errorMsg =pcall(function()
		local properties = FilterPropertiesToTween(nextPartInstance)
		local currentFrameInstance = animation.KeyFrames[animation.Frame]
		
		local timeDifference = nextFrameInstance["%TIMESTAMP%"]-currentFrameInstance["%TIMESTAMP%"]
		local easingStyle = nextFrameInstance["%EASINGSTYLE%"] or Enum.EasingStyle.Linear
		local easingDirection = nextFrameInstance["%EASINGDIRECTION%"] or Enum.EasingDirection.Out
		
		local tweenSettings = TweenInfo.new(timeDifference,easingStyle,easingDirection)
		local tween = TweenService:Create(reference,tweenSettings,properties)
		tween:Play()
		table.insert(animation.Tweens,tween)
	end)
	if not success then warn(errorMsg) end
end

-- Gets the next instance of a key frame
function GetNextKeyFrame(reference,animation,partName)
	-- Loop through each following frame
	for keyIndex=animation.Frame+1, #animation.KeyFrames do

		-- if theres a next instance of the part in the animation
		local keyFrame = animation.KeyFrames[keyIndex]
		local partFrame = keyFrame[partName]

		if(partFrame) then
			return keyFrame,partFrame
		end
	end
end

-- Filter the properties so they can be tweened
function FilterPropertiesToTween(partTable)
	local properties = {"number","bool","CFrame","Rect","Color3","UDim2","UDim2","Vector2","Vector2int16","Vector3"}
	local propertyTable = {}
	-- if its in the property list then add to the propertyTable
	for propertyName,propertyValue in pairs(partTable) do
		if table.find(properties,typeof(propertyValue)) then
			propertyTable[propertyName] = propertyValue
		end 
	end
	return propertyTable
end

-- Configuring stored tweens, ea unpausing or removing unneeded tweens
function ConfigureTweens(animation)
	for index,tween in pairs(animation.Tweens) do
		-- Destroy completed or cancelled tweens
		if tween.PlaybackState == Enum.PlaybackState.Completed or tween.PlaybackState == Enum.PlaybackState.Cancelled then
			table.remove(animation.Tweens,index)
			tween:Destroy()
		-- Resume paused tweens
		elseif tween.PlaybackState == Enum.PlaybackState.Paused then
			tween:Play()
		end
	end
end


--------------- ANIMATOR OBJECT ----------------------
local Animator = {}
Animator.__index = Animator

function Animator.new(keyFrames,object)
	-- decalare animation
	local animation = setmetatable({},Animator)
	
	-- set data of the animation
	animation.KeyFrames = keyFrames
	animation.Object = object
	animation.Looping = keyFrames[#keyFrames]["%LOOP%"]
	animation.Playing = false
	animation.Frame = 1
	animation.Time = 0
	animation.Tweens = {}
	animation.Complete = Instance.new("BindableEvent")
		
	return animation
end


-- Plays an animation and adds it to queue
function Animator:Play()
	if not table.find(Animations,self) then
		table.insert(Animations,self)
	end
	self.Playing = true
end
-- Stops an animation
function Animator:Stop()
	self.Playing = false
	self.Frame = 1
	
	-- Removing all instances of tweens
	for index,tween in pairs(self.Tweens) do
		tween:Pause()
		table.remove(self.Tweens,index)
		tween:Destroy()
	end
end
-- Pauses an animation
function Animator:Pause()
	self.Playing = false
	
	-- Destroy any tweens just in case
	ConfigureTweens(self)
	-- Pause all existing tweens
	for index,tween in pairs(self.Tweens) do
		tween:Pause()
	end
end
-- Removes an animation
function Animator:Destroy()
	self:Stop()
	self.Complete:Destroy()
	local index = table.find(Animations,self)
	table.remove(Animations,index)	
end

return Animator
