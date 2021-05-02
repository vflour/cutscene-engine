local Dependencies = require(script.Dependencies)
local Settings = require(script.Settings)

local player = game.Players.LocalPlayer 

local CutsceneEngine =  {}
-- CutsceneEngine 0.0.1 by vflour/CrammelApple
-- MIT license 12-4-2021
-- CutsceneEngine creates an object that can load, play or pause currently running cutscenes.

--- Components:
-- CutsceneEngine is designed to have interchangeable components so that it may be compatible for your game. It is intended to be ran locally, and not by the server.
-- These Actions are meant to work out of the box. That is, they don't require the installation of additional Dependencies. However, because of the nature
-- of this program, I recommend thatt you modify the Dependencies, Actions and Wait as you see fit. 

-- Each file consists scenes and references. 
-- Each scene contains actions that are executed asynchronously and will wait for a specific event. When the event is executed, the next scene plays.
-- A reference is data that contains an absolute path to an instance in the game. They are cloned when the engine loads the scene.

-- Actions are modules that are stored in functions. They are denoted by the action type. The script will attempt to require the module of the action.
-- They serve to complete a small task, such as playing a camera animation, playing sound, etc. 

-- Wait is a function that will execute the event whenever it is completed. It is run every time a scene has finished playing


------------------------------------------------- MAIN SCRIPT -------------------------------------------------

function CutsceneEngine:Load(cutsceneData)
    -- Load all assets and references before playing the cutscene
    AddFolders()
    local objects = { 
        References = {}, 
        Assets= {}
    }
    local prLoadSuccess, msg = pcall(function()
        objects.References = LoadReferences(cutsceneData.References)
        objects.Assets = LoadExternalAssets(game.ReplicatedStorage[Settings.TempFolder],cutsceneData)
    end)
    if not prLoadSuccess then
        RemoveTempFolder()
        error("Preload failed: "..msg)
    end

    -- Save the camera properties
    local cameraProperties = SaveCamera()

    -- Load each frame and action, then wait for the event at the end of the frame
    for _,frame in ipairs(cutsceneData.Frames) do
        for _,action in ipairs(frame.Actions) do
            assert(script.Components.Actions:FindFirstChild(action.Type),"ActionType "..action.Type.." is not valid")
            local actionFunction = require(script.Components.Actions[action.Type])
            actionFunction(objects,action.Data)
        end
        WaitForEvent(frame.Wait)
    end

    -- Remove all the temporary objects the cutscene has created
    RemoveObjects(objects)
    RemoveTempFolder()

    -- Reset the camera to normal
    ResetCamera(cameraProperties)
end

-- Wait for an event to trigger when a scene has finished
function WaitForEvent(eventData)
    assert(script.Components.Wait:FindFirstChild(eventData.Type),"WaitEvent "..eventData.Type.." is not valid")
    local event = Instance.new("BindableEvent")
    local eventFunction = require(script.Components.Wait[eventData.Type])
    eventFunction(event,eventData)
    event.Event:Wait()
    event:Destroy()
end

------------------------------------------------- PRELOADING -------------------------------------------------

-- Loads all references into the engine
function LoadReferences(refs)
    local references = {}
    for i,ref in ipairs(refs) do
        if not ref.Path then continue end
        local pathReference = CheckReference(ref.Path)
        local reference

        if typeof(pathReference)=="Instance" then
            pathReference.Archivable = true
            reference = pathReference:Clone()
            reference.Name = i
            reference.Parent = game.ReplicatedStorage[Settings.TempFolder]
            pathReference.Archivable = false
        elseif typeof(pathReference)=="table" then
            reference = pathReference
        end
        references[i] = reference
    end        
    return references
end

-- Load all external content ahead of time.
-- They are stored in a seperate folder with a ref attached to them
function LoadExternalAssets(referenceFolder, cutsceneData)
    local assets = {}
    local assetsToLoad = {}
    local preloadOnly = {}
    -- store preload functions in a table
    -- each index is an action that can be preloaded
    local preloadFunctions = {
        ["CharacterManipulation"]=PreloadCharacterAnim,
        ["ObjectAnimator"]=PreloadControllerAnim,
        ["Sound"] = PreloadSound,
        ["Video"] = PreloadVideo,
        ["ScreenEffects"]=PreloadEffects,
    }
    for _,frame in ipairs(cutsceneData.Frames) do
        for _,action in ipairs(frame.Actions) do
            if preloadFunctions[action.Type] then
                local index, asset = preloadFunctions[action.Type](action.Data)
                
                -- continue if index is not valid or if the index already exists
                if not index then continue end
                if assets[index] then -- you still want to preload it, but don't actually use it.
                    table.insert(preloadOnly, asset) 
                    continue 
                end
                
                assets[index] = asset
                if typeof(asset) == "Instance" then
                    asset.Parent = referenceFolder
                    asset.Name = index
                    table.insert(assetsToLoad,asset)
                elseif typeof(asset) == "table" then -- if it's a list of assets
                    for subIndex,subAsset in ipairs(asset) do
                        subAsset.Parent = referenceFolder
                        subAsset.Name = index.."_"..subIndex
                        table.insert(assetsToLoad,subAsset)
                    end
                end
            end
        end
    end

    -- preload content
    game:GetService("ContentProvider"):PreloadAsync(assetsToLoad)
    game:GetService("ContentProvider"):PreloadAsync(preloadOnly)

    --remove preloadOnly
    for _,instance in ipairs(preloadOnly) do
        instance:Destroy()
    end

    return assets
end

-- Preloading functions for animations, sound and video
function PreloadCharacterAnim(data)
    if data.Animation then
        assert(data.Animation.ref,"Missing ref for CharacterManipulation Animation")
        assert(data.Animation.Id,"Missing Id for CharacterManipulation Animation, ref "..data.Animation.ref)

        local animation = Instance.new("Animation")
        animation.AnimationId = data.Animation.Id
        return data.Animation.ref, animation 
    end
end

function PreloadControllerAnim(data)
    assert(data.ref,"Missing ref for ObjectAnimator")
    assert(data.Id,"Missing Id for ObjectAnimator, ref "..data.ref)
    local animation = Instance.new("Animation")
    animation.AnimationId = data.Id

    return data.animation, animation 
end

function PreloadSound(data)
    if not Settings.PreloadSoundInstance then return end
    assert(data.ref,"Missing ref for Sound")
    assert(data.Id,"Missing Id for Sound, ref "..data.ref)

    local sound = Instance.new("Sound")
    sound.SoundId = data.Id

    return data.ref, sound
end

function PreloadVideo(data)
    if not Settings.PreloadVideoInstance then return end
    assert(data.ref,"Missing ref for Video")
    assert(data.Id,"Missing Id for Video, ref "..data.ref)

    local video = Instance.new("VideoFrame")
    video.Size = UDim2.new(1,0,1,0)
    video.Video = data.Id
    
    return data.ref, video
end

function PreloadEffects(data)
    local effects = {}

    effects.Bloom = Instance.new("BloomEffect")
    effects.ColorCorrection = Instance.new("ColorCorrectionEffect")
    effects.Blur = Instance.new("BlurEffect")
    effects.SunRays = Instance.new("SunRaysEffect")

    return data.ref, effects
end

-- Checks if the reference is a valid path. Returns the object that's located at the path.
function CheckReference(path) 
    if path == "%LOCALPLAYER%" then
        return player.Character
    else
        local searchResult = Dependencies.PathSearch(path)
        if searchResult:IsA("ModuleScript") then
            return require(searchResult)
        else 
            return searchResult
        end
    end
end

------------------------------------------------- FOLDER HANDLING -------------------------------------------------
-- Instantiate necessary folders, such as the temporary folder and the cutscene folder.
function AddFolders()
    local referenceFolder = Instance.new("Folder",game.ReplicatedStorage)
    referenceFolder.Name = Settings.TempFolder

    if not workspace:FindFirstChild("CutsceneFolder") then
        local workspaceFolder = Instance.new("Folder",workspace)
        workspaceFolder.Name = Settings.CutsceneFolder
    end
    if not player.PlayerGui:FindFirstChild("CutsceneFolder") then
        local guiScreen = Instance.new("ScreenGui",player.PlayerGui)
        guiScreen.Name = Settings.CutsceneFolder
    end
end

-- Remove the temporary folder if need be
function RemoveTempFolder()
    if game.ReplicatedStorage:FindFirstChild(Settings.TempFolder) then
        game.ReplicatedStorage[Settings.TempFolder]:Destroy()
    end
end

-- Remove all instances stored in references and assets
function RemoveObjects(objects)
    RemoveInstancesFromList(objects.References)
    RemoveInstancesFromList(objects.Assets)
end

-- Search through each entry in a list, check if it's an instance or a list of instances
function RemoveInstancesFromList(list)
    for i, object in pairs(list) do
        if typeof(object)=="Instance" then -- check if object is an instance
            object:Destroy()    
        elseif typeof(object)=="table" and object._t == "list" then -- check if it's a list of objects
            for _,subObject in ipairs(object) do
                subObject:Destroy()
            end
        end
    end
end

------------------------------------------------- CAMERA HANDLING -------------------------------------------------
-- Save all properties for the camera
function SaveCamera()
    local properties = {}
    local camera = workspace.CurrentCamera
    properties["Focus"] = camera.Focus
    properties["CFrame"] = camera.CFrame
    properties["CameraSubject"] = camera.CameraSubject
    properties["CameraType"] = camera.CameraType
    properties["FieldOfView"] = camera.FieldOfView
    properties["FieldOfViewMode"] = camera.FieldOfViewMode
    properties["HeadLocked"] = camera.HeadLocked
    properties["HeadScale"] = camera.HeadScale

    return properties
end

-- Reset the camera to its default settings
function ResetCamera(properties)
    for property, value in pairs(properties) do
        workspace.CurrentCamera[property] = value
    end
end

return CutsceneEngine