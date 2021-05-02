local Settings = require(script.Parent.Parent.Parent.Settings)

--[[
    DATA:
    >> ref (number) Index of the object in the assets table
    >> Id (string) Id of the video
    >> [Volume] (number) The video's volume
]]--

return function(objects, data)
    local video = objects.Assets[data.ref]
    video.Video = data.Id
    video.Parent = game.Players.LocalPlayer.PlayerGui[Settings.CutsceneFolder]
    
    if data.Volume then video.Volume = data.Volume end

    video:Play()
end