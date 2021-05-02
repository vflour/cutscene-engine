local Settings = require(script.Parent.Parent.Parent.Settings)

--[[
    DATA:
    >> ref (number) Index of the object in the assets table
    >> Id (string) Id of the sound
    >> [Volume] (number) The sound's volume
    >> [Looping] (boolean) whether the sound will be looping or not
]]--

return function(objects, data)
    local sound = objects.Assets[data.ref]
    sound.SoundId = data.Id
    sound.Parent = game.Players.LocalPlayer.PlayerGui[Settings.CutsceneFolder]

    if data.Volume then sound.Volume = data.Volume end
    if data.Looping then sound.Looped = data.Looped end

    sound:Play()
end