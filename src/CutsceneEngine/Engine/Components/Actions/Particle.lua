local Settings = require(script.Parent.Parent.Parent.Settings)

return function(objects, data)
    local object = objects.References[data.ref]
    object.Parent = workspace[Settings.CutsceneFolder]
    object.CFrame = data.CFrame

    coroutine.wrap(function()
        wait(data.Time)
        object:Destroy()
    end)()
end