local Scene = {
    References={
        {Type="Character",Path="%LOCALPLAYER%"},
		{Type="Character",Path="ReplicatedStorage.SomeNPC"},
		{Type="Particle",Path="ReplicatedStorage.Particle"},
		{Type="AnimationData",Path="ReplicatedStorage.CameraMovement"}
    },
    Frames={
        -- Frame 1
        { 
			Wait={Type="Time",Data=5},
			
			Actions={
				{
					Type="Camera",
					Data={
						ref = 4,
					}
				},
				{
					Type="ScreenEffects",
					Data={
						ref = 3,
						Effects = {
							Bloom={
								Intensity = 1,
								Size = 56,
								Threshold = 0.8
							},
							ColorCorrection={
								Contrast=0.3,
								Saturation=0.2,
								Brightness=0.3
							}	
						}

					}
				},
				{
					Type="Sound",
					Data={
						Id = "rbxassetid://1843463175",
						ref = 1,
						Looped = true
					}
				},
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
					Type="Particle",
					Data={
						ref=3,
						CFrame=CFrame.new(Vector3.new(20.541, 0.5, 24.615)),
						Time=2,
					}
				},
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
		},
		-- Frame 3
		{
			Wait={Type="Time",Data=5},
			Actions={
				{
					Type="Video",
					Data={
						Id="rbxassetid://5608386285",
						ref=2
					}
				}
			}
		}
    }
}

return Scene