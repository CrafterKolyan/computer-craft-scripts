function Set(list)
    local set = {}
    for _, v in ipairs(list) do
        set[v] = true
    end
    return set
end

function setContains(set, key)
    return set[key] ~= nil
end

function refuelIfNeeded()
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        turtle.refuel(1)
    end
end

allowedBlocks = Set({"minecraft:stone", "minecraft:dirt", "minecraft:gravel", "minecraft:andesite", "minecraft:diorite", "minecraft:granite"})

function digGenericIfAllowed(inspectFunction, digFunction)
    local success, data = inspectFunction()
    if success then
        local allowed = setContains(allowedBlocks, data.name)
        if allowed then
            digFunction()
        end
    end
end

function dig()
    digGenericIfAllowed(turtle.inspect, turtle.dig)
end

function digUp()
    digGenericIfAllowed(turtle.inspectUp, turtle.digUp)
end

function digDown()
    digGenericIfAllowed(turtle.inspectDown, turtle.digDown)
end

function hasBlockInFront()
    local success, data = turtle.inspect()
    return success
end

function forwardIfPossible()
    if not hasBlockInFront() then
        refuelIfNeeded()
        turtle.forward()
    end
end

function placeTorch()
    local torchSlot = 2
    local data = turtle.getItemDetail(torchSlot)
    if data == nil or data.name ~= "minecraft:torch" then
        return
    end
    turtle.select(torchSlot)
    turtle.place()
    turtle.select(1)
end

function step(n)
    if hasBlockInFront() then
        dig()
    end
    forwardIfPossible()
    digUp()
    digDown()
    turtle.turnLeft()
    dig()
    turtle.turnRight()
    turtle.turnRight()
    dig()
    if n % 10 == 0 then
        placeTorch()
    end
    turtle.turnLeft()
    turtle
end

function start()
    local i = 0
    while true do
        step(i)
        i = i + 1
    end
end

start()

