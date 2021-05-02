local Settings = require(script.Parent.Parent.Parent.Settings)

--[[
    DATA:
    >> ref (number) Reference index to the character's model
    >> CFrame (CFrame) Starting CFrame position of the character's model
    >> [MoveTo] (Vector3) Vector3 used to call MoveTo() on the character's humanoid, used to make the character walk to a point
    >> [Animation]
        >> ref (number) Reference index pointing to the animation instance in the objects table
        >> Id (string) The id of the animation
]]--

function CharacterManipulation(objects, data)
    local character = objects.References[data.ref]
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then warn(script.Name..": Cannot find Humanoid. This might break things.") end

    character.Parent = workspace[Settings.CutsceneFolder]
    character.PrimaryPart.CFrame = data.CFrame
    if data.MoveTo then -- physically move the character model
        humanoid:MoveTo(data.MoveTo)
    end
    if data.Animation then -- play an animation into the character
        LoadAnimation(objects.Assets, humanoid, data.Animation)
    end
end

--- Loading animations onto a character if necessary
function LoadAnimation(assets, humanoid, animationData)
    local animation = assets[animationData.ref]
    animation.AnimationId = animation.Id

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        local animationTrack = animator:LoadAnimation(animation)
        animationTrack:Play()

        -- add the animation track to the assets so that it's removed when the cutscene ends
        assets[animationData.ref.."_TRACK"] = animationTrack
    end
end

return CharacterManipulation