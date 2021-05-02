local Settings = {}

-- Both settings create a new sound and video instance for each id ahead of time.
Settings.PreloadSoundInstance = true
Settings.PreloadVideoInstance = true

-- This is what the temporary reference folder name will be called
Settings.TempFolder = "CutsceneEngine_TEMP"

-- This is what the workspace folder/playergui screen will be called
Settings.CutsceneFolder = "CutsceneEngine_Display"

return Settings