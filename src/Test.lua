local Scene = {
    References={
        {Name="Player",Type="Character",Path="%LOCALPLAYER%"},
        {Name="Friend",Type="Character",Path="ReplicatedStorage.SomeNPC"}
    },
    Frames={
        -- Frame 1
        { 
            Wait={Type="Time",Data=5},
            Actions={
                {
                    Type="CharacterManipulation",
                    Data={
                        ref=1,
                        CFrame=CFrame.new(Vector3.new(0,2.3,0)),
                        MoveTo=Vector3.new(10,2.3,15)
                    }
                },
                {
                    Type="CharacterManipulation",
                    Data={
                        ref=2,
                        CFrame=CFrame.new(Vector3.new(5,2.3,5)),
                        MoveTo=Vector3.new(20,2.3,20)
                    }
                }
            }
        },
        -- Frame2
        { 
            Wait={Type="Time",Data=3},
            Actions={
                {
                    Type="CharacterManipulation",
                    Data={
                        ref=1,
                        CFrame=CFrame.new(Vector3.new(10,2.3,15)),
                        MoveTo=Vector3.new(6,2.3,6)
                    }
                },
                {
                    Type="CharacterManipulation",
                    Data={
                        ref=2,
                        CFrame=CFrame.new(Vector3.new(20,2.3,20)),
                        MoveTo=Vector3.new(5,2.3,5)
                    }
                }
            }
        }
    }
}

return Scene