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

function step()
    turtle.select(1)
    turtle.dig()
    local barrelSlot = nil
    for i = 1, 16 do
        if isBigBarrelInSlot(i) then
            barrelSlot = i
        else
            local data = turtle.getItemDetail(i)
            if data ~= nil then
                turtle.select(i)
                turtle.dropDown()
            end
        end
    end
    turtle.select(barrelSlot)
    turtle.place()
end

function start()
    while true do
        step()
    end
end

start()
