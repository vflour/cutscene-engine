local Settings = require(script.Parent.Parent.Parent.Settings)
--[[
    DATA:
    >> ref (number) The index to the reference being animated. Must contain an Animator
    >> Animation
        >> ref (number) Reference index pointing to the animation instance in the objects table
        >> Id (string) The id of the animation
]]--

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
    animationTrack:Play()

    -- add the animation track to the assets so that it's removed when the cutscene ends
    objects.Assets[animation.ref.."_TRACK"] = animationTrack
end