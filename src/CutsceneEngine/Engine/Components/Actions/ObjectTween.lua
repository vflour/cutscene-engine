local Dependencies = require(script.Parent.Parent.Parent.Dependencies)
local Settings = require(script.Parent.Parent.Parent.Settings)

return function(objects, data)
    local animationData = objects.References[data.Animation]
    local object = objects.References[data.ref]
    
    object.Parent = workspace[Settings.CutsceneFolder]
    Dependencies.Tween:LoadAnimation(object,animationData)
end