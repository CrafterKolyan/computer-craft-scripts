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
    "darkerdepths:aridrock",
    "darkerdepths:aridrock_coal_ore",
    "darkerdepths:aridrock_iron_ore",
    "darkerdepths:aridrock_lapis_ore",
    "darkerdepths:aridrock_gold_ore",
    "darkerdepths:aridrock_redstone_ore",
    "darkerdepths:aridrock_diamond_ore",
    "darkerdepths:aridrock_emerald_ore",
    "darkerdepths:aridrock_silver_ore",
    "darkerdepths:limestone",
    "darkerdepths:limestone_coal_ore",
    "darkerdepths:limestone_iron_ore",
    "darkerdepths:limestone_lapis_ore",
    "darkerdepths:limestone_gold_ore",
    "darkerdepths:limestone_redstone_ore",
    "darkerdepths:limestone_diamond_ore",
    "darkerdepths:limestone_emerald_ore",
    "darkerdepths:limestone_silver_ore",
    "thermal:apatite_ore",
    "thermal:cinnabar_ore",
    "thermal:nickel_ore",
    "thermal:niter_ore",
    "thermal:sulfur_ore",
    "thermal:ruby_ore",
    "create:dolomite",
    "create:gabbro",
    "create:zinc_ore",
    "create:dolomite_cobblestone",
    "create:diorite_cobblestone",
    "create:granite_cobblestone",
    "create:andesite_cobblestone",
    "create:gabbro_cobblestone",
    "forbidden_arcanus:xpetrified_ore",
    "appliedenergistics2:quartz_ore",
    "appliedenergistics2:charged_quartz_ore",
    "buddycards:luminis_ore",
    "randomium:randomium_ore",
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
    "create:dolomite",
    "create:gabbro",
    "create:dolomite_cobblestone",
    "create:diorite_cobblestone",
    "create:granite_cobblestone",
    "create:andesite_cobblestone",
    "create:gabbro_cobblestone",
    "darkerdepths:aridrock",
    "darkerdepths:limestone",
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

function forwardIfPossible()
    if not turtle.detect() then
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
    if turtle.detect() then
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

