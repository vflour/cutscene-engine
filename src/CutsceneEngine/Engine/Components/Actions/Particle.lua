local Settings = require(script.Parent.Parent.Parent.Settings)
--[[
    DATA:
    >> ref (number) Reference index to the particle object
    >> CFrame (CFrame) The Cframe position of the particle
    >> Time (number) The duration of the particle
]]--

return function(objects, data)
    local object = objects.References[data.ref]
    object.Parent = workspace[Settings.CutsceneFolder]
    object.CFrame = data.CFrame

    coroutine.wrap(function()
        wait(data.Time)
        object:Destroy()
    end)()
end