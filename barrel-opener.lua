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

function step()
    turtle.dig()
    for i = 1, 3 do
        local data = turtle.getItemDetail(i, true)
        print(dump(data))
    end
    turtle.place()
end

function start()
    -- while true do
        step()
    -- end
end

start()
