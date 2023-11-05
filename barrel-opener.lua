function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function isBigBarrelInSlot(n)
    local data = turtle.getItemDetail(n, true)
    return data ~= nil and data.name == "minecraft:barrel" and data.lore ~= nil and data.lore[1] == "The fabled prize awaits at the bottom..."
end

function dropDownUselessItems()
    for i = 1, 16 do
        if not isBigBarrelInSlot(i) then
            local data = turtle.getItemDetail(i)
            if data ~= nil then
                turtle.select(i)
                turtle.dropDown()
            end
        end
    end
end

function emptySlots()
    local result = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            result = result + 1
        end
    end
    return result
end

function step()
    turtle.select(1)
    turtle.dig()
    local barrelSlot = nil
    for i = 1, 16 do
        if isBigBarrelInSlot(i) then
            barrelSlot = i
            break
        end
    end
    if barrelSlot ~= nil then
        turtle.select(barrelSlot)
        turtle.place()
    end
    if emptySlots() <= 3 then
        dropDownUselessItems()
    end
end

function start()
    while true do
        step()
    end
end

start()
