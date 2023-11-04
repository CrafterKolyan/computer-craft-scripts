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

blocksWhitelist = Set({
    "minecraft:stone",
    "minecraft:cobblestone",
    "minecraft:dirt",
    "minecraft:gravel",
    "minecraft:sand",
    "minecraft:andesite",
    "minecraft:diorite",
    "minecraft:granite",
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:copper_ore",
    "minecraft:gold_ore",
    "minecraft:redstone_ore",
    "minecraft:lapis_ore",
    "minecraft:emerald_ore",
    "minecraft:diamond_ore",
    "thermal:apatite_ore",
    "thermal:cinnabar_ore",
    "thermal:nickel_ore",
    "thermal:niter_ore",
    "thermal:sulfur_ore",
    "thermal:ruby_ore",
    "create:dolomite",
    "create:zinc_ore",
    "forbidden_arcanus:xpetrified_ore",
    "appliedenergistics2:quartz_ore",
})

blocksDroplist = Set({
    "minecraft:stone",
    "minecraft:cobblestone",
    "minecraft:dirt",
    "minecraft:gravel",
    "minecraft:andesite",
    "minecraft:diorite",
    "minecraft:granite",
    "minecraft:flint",
    "create:dolomite_cobblestone",
    "create:diorite_cobblestone",
    "create:grainte_cobblestone"
})

function refuelIfNeeded()
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        turtle.select(1)
        turtle.refuel(1)
    end
end

function digGenericIfAllowed(inspectFunction, digFunction)
    local success, data = inspectFunction()
    if success then
        local allowed = setContains(blocksWhitelist, data.name)
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

function dropUselessBlocks()
    for i = 1, 16 do
        local data = turtle.getItemDetail(i)
        if data ~= nil and setContains(blocksDroplist, data.name) then
            turtle.select(i)
            turtle.drop()
        end
    end
    turtle.select(1)
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
    dropUselessBlocks()
    turtle.turnRight()
    turtle.turnRight()
    dig()
    if n % 10 == 0 then
        placeTorch()
    end
    turtle.turnLeft()
end

function start()
    local i = 0
    while true do
        step(i)
        i = i + 1
    end
end

start()

