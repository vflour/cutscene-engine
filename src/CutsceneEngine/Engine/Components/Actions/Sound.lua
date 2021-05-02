local Settings = require(script.Parent.Parent.Parent.Settings)
return function(objects, data)
    local sound = objects.Assets[data.ref]
    sound.SoundId = data.Id
    sound.Parent = game.Players.LocalPlayer.PlayerGui[Settings.CutsceneFolder]

    if data.Volume then sound.Volume = data.Volume end
    if data.Looping then sound.Looped = data.Looped end

    sound:Play()
end