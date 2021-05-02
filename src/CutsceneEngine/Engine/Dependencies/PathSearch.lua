function SearchPath(path)
    local pathIteration = string.gmatch(path,"[^%.]+")
    local find = game
    for name in pathIteration do
        assert(find:FindFirstChild(name),name.." is not a valid member of "..find.Name)
        find = find:FindFirstChild(name)        
    end
    return find
end

return SearchPath