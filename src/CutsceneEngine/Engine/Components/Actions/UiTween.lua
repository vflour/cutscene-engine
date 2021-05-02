local Dependencies = require(script.Parent.Parent.Parent.Dependencies)
local Settings = require(script.Parent.Parent.Parent.Settings)

--[[
    DATA:
    >> ref (number) Reference to the ui object in which the tween animation is being applied
    >> Animation (number) Reference to the tween animation in the References table
]]--

return function(objects, data)
    local animationData = objects.References[data.Animation]
    local object = objects.References[data.ref]
    
    object.Parent = game.Players.LocalPlayer.PlayerGui[Settings.CutsceneFolder]
    Dependencies.Tween:LoadAnimation(object,animationData)
end