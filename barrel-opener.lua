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
    return data != nil and data.name == "minecraft:barrel" and data.lore ~= nil and data.lore[1] == "The fabled prize awaits at the bottom..."
end

function step()
    turtle.dig()
    for i = 1, 16 do
        if isBigBarrelInSlot(i) then
            turtle.select(i)
            break
        end
    end
    turtle.place()
end

function start()
    while true do
        step()
    end
end

start()
