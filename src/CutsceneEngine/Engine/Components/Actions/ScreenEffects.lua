return function(objects, data)
    local effects = objects.Assets[data.ref]
    
    -- loop through each effect key in data
    for name,effectData in pairs(data.Effects) do
        local effect = effects[name]
        effect.Parent = workspace.CurrentCamera
        assert(effect, "Invalid screen effect: "..name)

        -- set the property of the effect
        for property,value in pairs(effectData) do
            local success,msg = pcall(function()
                effect[property] = value
            end)
            if not success then
                warn(string.format("Invalid property %s for %s: %s",property,name))
            end
        end 
        
    end
end

