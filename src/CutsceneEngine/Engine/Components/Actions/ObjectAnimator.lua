local Settings = require(script.Parent.Parent.Parent.Settings)

function LoadAnimation(assets, humanoid, animationData)
    local animation = assets[animationData.ref]
    animation.AnimationId = animation.Id

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then warn("Could not find animator in humanoid "..humanoid.Name) return end
    
    local animationTrack = animator:LoadAnimation(animation)
    animationTrack:Play()

    -- add the animation track to the assets so that it's removed when the cutscene ends
    assets[animationData.ref.."_TRACK"] = animationTrack
    
end


return function(objects, data)
    local object : Instance = objects.References[data.ref]
    object.Parent = workspace[Settings.CutsceneFolder]

    local animation = objects.Assets[object.animation]
    animation.AnimationId = animation.Id

    local controller = object:FindFirstChildOfClass("AnimationController")
    assert(controller, "Could not find AnimationController in "..object.Name)

    local animator = controller:FindFirstChildOfClass("Animator")
    assert(animator, "Could not find Animator in AnimationController")

    local animationTrack = animator:LoadAnimation(animation)
end