local Dependencies = require(script.Parent.Parent.Parent.Dependencies)

return function(objects, data)
    local animationData = objects.References[data.Animation]
    Dependencies.Tween:LoadAnimation(workspace.CurrentCamera,animationData)
end