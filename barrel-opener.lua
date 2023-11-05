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

function step(n)
    turtle.select(1)
    turtle.dig()
    if n % 10 == 0 then
        dropDownUselessItems()
    end
    local barrelSlot = nil
    for i = 1, 16 do
        if isBigBarrelInSlot(i) then
            barrelSlot = i
            break
        end
    end
    turtle.select(barrelSlot)
    turtle.place()
end

function start()
    local i = 0
    while true do
        step(i)
        i = i + 1
    end
end

start()
