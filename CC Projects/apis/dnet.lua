--[[
    Diablo-Net (just some easy ways to do some rednet stuff)
]]

-- a RedNet Package is formatted to look like so:
-- { id = i, msg = m, proto = p}

--[[ Start of rednet functionality ]]
open = function(side)
    rednet.open(side)
end
close = function()
    rednet.close()
end
host = function(proto, hostname)
    rednet.host(proto, hostname)
end
unhost = function(proto, hostname)
    rednet.unhost(proto, hostname)
end

lookup = function(proto, hostname)
    return rednet.lookup(proto, hostname)
end

send = function(pc, message, pr)
    if pr == nil then
        rednet.send(pc, message)
    else
        rednet.send(pc, message, pr)
    end
    local i, m, p = rednet.receive(pr, 30)
    local rpkg = {id = i, msg = m, proto = p}
    return rpkg
end

--Fix later
cast = function (message, pr)
    rednet.broadcast(message, pr)
    local i, m, p = rednet.receive(pr, 30)
    local rpkg = {id = i, msg = m, proto = p}
    return rpkg
end

listen = function(pr)
    if pr == nil then
        local i, m, p = rednet.receive(30)
        local rpkg = {id = i, msg = m, proto = p}
        return rpkg
    else
        local i, m, p = rednet.receive(pr, 30)
        local rpkg = {id = i, msg = m, proto = p}
        return rpkg
    end
end

--[[ End of rednet functionality ]]

--[[ Pinging computers ]]

-- Peer-to-Peer Send Ping
p2p_sping = function(pc_id, channel)
    if channel == nil then
        rednet.send(pc_id, 'ping')
        sleep(0)
        local i, m, p = rednet.receive(30)
        sleep(0)
        if i == nil then
            return 'fail'
        else
            rednet.send(pc_id, 'OK')
            local rpkg = {id = i, msg = m, proto = p}
            return rpkg
        end
    else
        rednet.send(pc_id, 'ping', channel)
        sleep(0)
        local i, m, p = rednet.receive(channel)
        sleep(0)
        if i == nil then
            return 'fail'
        else
            rednet.send(pc_id, 'OK', channel)
            local rpkg = {id = i, msg = m, proto = p}
            return rpkg
        end
    end
end

-- Peer-to-Peer Receive Ping
p2p_rping = function(channel)
    if channel == nil then
        local i, m, p = rednet.receive(30)
        sleep(0)
        if i == nil then
            return 'fail ping'
        else
            rednet.send(i, 'accepted-ping')
            sleep(0)
            rednet.receive(30)
            return {id = i, msg = m, proto = p}
        end
    else
        local i, m, p = rednet.receive(channel, 30)
        sleep(0)
        if i == nil then
            return 'fail ping'
        else
            rednet.send(i, 'accepted-ping', channel)
            sleep(0)
            rednet.receive(30)
            return {id = i, msg = m, proto = p}
        end
    end
end

--[[ End of Pinging Computers ]]
-- Format RedNet Package
frnPkg = function(pkg)
    local retstr = ''
    if #pkg > 1 then
        for idx, data in ipairs(pkg) do
            retrstr = retrstr..idx..'\n\t'
            for key, val in pairs(data) do
                retrstr = retrstr..key..'  '..val..'\n'
            end
        end
    else
        for key, val in pairs(pkg) do
            retstr = retstr..key..'   '..val..'\n'
        end
    end
    return retstr
end

--[[ Easy way to confirm some rednet signal ]]

sendConfirm = function(id, channel)
    if channel == nil then
        rednet.send(id, 'OK')
    else
        rednet.send(id, 'OK', channel)
    end
end

waitConfirm = function(id, channel)
    if channel == nil then
        local i, m, p = rednet.receive(30)
        if i == id and m == 'OK' then
            return true
        else
            return false
        end
    else
        local i, m, p = rednet.receive(channel, 30)
        if i == id and m == 'OK' then
            return true
        else
            return false
        end
    end
end