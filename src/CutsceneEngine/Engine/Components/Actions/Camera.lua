local Dependencies = require(script.Parent.Parent.Parent.Dependencies)

--[[
    DATA:
    >> ref (number) Reference to the tween animation in the References table
]]--

return function(objects, data)
    local animationData = objects.References[data.ref]
    Dependencies.Tween:LoadAnimation(workspace.CurrentCamera,animationData)
end