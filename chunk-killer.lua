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

function Position(x, y, z, facing)
    local position = {}
    position.x = x
    position.y = y
    position.z = z
    position.facing = facing
    return position
end

function positionForward(position)
    if position.facing == "north" then
        position.x = position.x + 1
    elseif position.facing == "south" then
        position.x = position.x - 1
    elseif position.facing == "east" then
        position.z = position.z - 1
    elseif position.facing == "west" then
        position.z = position.z + 1
    end
    return position
end

function positionDown(position)
    position.y = position.y - 1
    return position
end

function positionRotateLeft(position)
    if position.facing == "north" then
        position.facing = "west"
    elseif position.facing == "south" then
        position.facing = "east"
    elseif position.facing == "east" then
        position.facing = "north"
    elseif position.facing == "west" then
        position.facing = "south"
    end
    return position
end

function positionRotateRight(position)
    if position.facing == "north" then
        position.facing = "east"
    elseif position.facing == "south" then
        position.facing = "west"
    elseif position.facing == "east" then
        position.facing = "south"
    elseif position.facing == "west" then
        position.facing = "north"
    end
    return position
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
    "minecraft:oak_planks",
    "minecraft:oak_fence",
    "minecraft:cobweb",
    "minecraft:rail",
    "minecraft:torch",
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
    "thermal:lead_ore",
    "thermal:sapphire_ore",
    "create:dolomite",
    "create:gabbro",
    "create:zinc_ore",
    "create:dolomite_cobblestone",
    "create:diorite_cobblestone",
    "create:granite_cobblestone",
    "create:andesite_cobblestone",
    "create:gabbro_cobblestone",
    "forbidden_arcanus:xpetrified_ore",
    "forbidden_arcanus:runestone",
    "appliedenergistics2:quartz_ore",
    "appliedenergistics2:charged_quartz_ore",
    "buddycards:luminis_ore",
    "randomium:randomium_ore",
    "extcaves:brokenstone",
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
    "extcaves:brokenstone",
    "minecraft:oak_planks",
    "minecraft:oak_fence",
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

function moveIfPossible(position, detectFunction, moveFunction, positionFunction)
    if not detectFunction() then
        refuelIfNeeded()
        local result = moveFunction()
        if result then
            positionFunction(position)
        end
    else
        error("Unexpected state. Can't move after digging")
    end
end

function forwardIfPossible(position)
    moveIfPossible(position, turtle.detect, turtle.forward, positionForward)
end

function downIfPossible(position)
    moveIfPossible(position, turtle.detectDown, turtle.down, positionDown)
end

function turnLeft(position)
    turtle.turnLeft()
    positionRotateLeft(position)
end

function turnRight(position)
    turtle.turnRight()
    positionRotateRight(position)
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

function step(position)
    if turtle.detect() then
        dig()
    end
    if turtle.detectDown() then
        digDown()
    end
    forwardIfPossible(position)
end

function start()
    local SIZE = 16
    local position = Position(0, 0, 0, "north")
    while true do
        step(position)
        print("Position: " .. position.x .. " " .. position.y .. " " .. position.z .. " " .. position.facing)
        if position.z == SIZE - 1 and position.x == 0 then
            dropUselessBlocks()
            if turtle.detectDown() then
                digDown()
            end
            downIfPossible(position)
            if turtle.detectDown() then
                digDown()
            end
            downIfPossible(position)
            turnLeft(position)
            position = Position(0, 0, 0, "north")
        elseif position.x == SIZE - 1 then
            turnLeft(position)
        elseif position.x == 0 and position.z ~= 0 then
            turnRight(position)
        end
    end
end

start()

