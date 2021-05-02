# cutscene-engine
A module that loads cutscenes from a table. It is inspired off of the Persona 3 cutscene debug menu.
Since the only available cutscene maker on the market only manipulates the camera, I figured that additional features (such as manipulating the player's character) would be useful.

## Usage
The Engine module is intended to run locally. Simply require the module and run the load command as such:
```
local cutscene = require(game.ReplicatedStorage.MyCutscene)
local Engine = require(game.ReplicatedStorage.Source.Engine)
engine:Load(cutscene)
```
## Formatting
Files are loaded based on how the table is structured. The repository also contains an example of a cutscene, provided that the assets are in the game.

### Cutscene
Contains a list of all the frames and references that are used in the cutscene.
```
{
  References = {Reference},
  Frames = {Frame}
}
```
### Reference
References are external objects loaded into the cutscene. They will either contain a path or a "special" value (such as %LOCALPLAYER%, more on that later)
```
{
  Type = "ReferenceType",
  Path = "ReplicatedStorage.MyModel"
}
```

### Frame
A frame is a sequence of actions in a cutscene. Every time a cutscene plays, every action will be executed at once. The script will then yield until the Wait Event has fired.
```
{
  Wait = { WaitEvent },
  Actions = { Action } 
}
```

### WaitEvent
A WaitEvent contains data about the type of waiting that the cutscene will do once a frame has finished.
```
{
  Type = "Time",
  Data = 5
}
```

### Action
An action is a type of command that will execute in the frame. This can be anything: camera manipulation, screen effects, character manipulation, etc.
```
{
  Type="Camera"
  Data={ActionData}
}
```
The data for the action will depend on what data the Action type might require. The action types are stored as module scripts under Engine/Components/Actions/.
Generally speaking, there are no rules for the Action data as long as it contains all the fields that the module needs. However, here are some names I tend to use:

* ``ref`` usually pinpoints to a reference in the References table. However, it could also point to a reference in the objects table. This is usually when the Engine script tries to load an Audio or Video asset.

## Engine
For now, it's only able to run a cutscene from a table. Will add more functionality (such as pausing, stopping, etc.) in the near future.

## Plugin
Plugin is being worked on, but it is not released.
