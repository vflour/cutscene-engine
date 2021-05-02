return function(event, eventData)
    coroutine.wrap(function()
        wait(eventData.Data)
        event:Fire()
    end)()
end 