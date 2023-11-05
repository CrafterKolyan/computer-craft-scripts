function step()
    local success, data = turtle.inspect()
    print(data.name)
    print(data.metadata)
    print(data.state)
end

function start()
    while true do
        step()
    end
end

start()
