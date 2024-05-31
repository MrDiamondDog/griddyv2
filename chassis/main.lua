local modem = peripheral.find("modem")
local sg = peripheral.wrap("right")

while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    print(message .. "blocks")
    if channel == 1 then
        sg.move(tonumber(message))
    end

    while sg.isRunning() do
        sleep(0.5)
    end

    print("done")

    modem.transmit(1, 1, "done")
end