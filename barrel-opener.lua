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
    for i = 1, 16 do
        local data = turtle.getItemDetail(16)
        print(dump(data))
    end
end

function start()
    -- while true do
        step()
    -- end
end

start()
