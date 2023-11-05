function step()
    if turtle.detect() then
        turtle.suck()
    end
end

function start()
    -- while true do
        step()
    -- end
end

start()
