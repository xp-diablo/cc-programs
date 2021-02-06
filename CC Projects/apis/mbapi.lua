--[[ Message Board API ]]

MSG_DAT = 'mboard/messages.dat'
MSG_DIR = 'mboard/'

-- Used to make sure the message package is formatted properly
verifyMsg = function (mpkg)

    -- if the user and message vars are empty
    if mpkg.user == nil or mpkg.msg == nil then
        return { result = false, cause = 'Nil objects' }
    -- either the message or user's name have invalid characters
    elseif string.match(mpkg.user, '\t|\r|\n') or string.match(mpkg.user, '\t|\r|\n') then
        return { result = false, cause = 'invalid characters' }
    -- checks if there are more of the splitting delimiter
    elseif #split(to_str(mpkg), "\|\,\|") ~= 2 then
        return { result = false, cause = 'invalid message package' }
    else
        return true
    end
end

-- Used to store the message
storeMessage = function(mpkg)
    -- If the message is verified, then proceed to store the message
    if verifyMsg(mpkg) then
        if fs.exists(MSG_DAT) then
            local file = fs.open(MSG_DAT, 'a')
            file.write('\n'..to_fstr(mpkg))
            file.close()
            return true
        else
            if not fs.isDir(MSG_DIR) then
                fs.makeDir(MSG_DIR)
            end
            local file = fs.open(MSG_DAT, 'w')
            file.write(to_fstr(mpkg))
            file.close()
            return true
        end
    else
        return false
    end
end

-- return all the messages in the messages.dat file
readAllMessages = function()
    -- ensure the messages.dat file is created. otherwise there is no reason to continue
    if fs.exists(MSG_DAT) then
        local file = fs.open(MSG_DAT, 'r')
        local msgs = split(file.readAll(), '\n')
        file.close()
        local messagePackages = {}
        for i = 1, #msgs do
            local splitstr = split(msgs[i], '\|\,\|')
            table.insert(messagePackages, { user = splitstr[1], msg = splitstr[2] })
        end
        return messagePackages
    else
        return nil
    end
end

-- convert a correctly formatted string into a message object
str2msg = function(msgstr)
    local splitstr = split(msgstr, '\|\,\|')
    -- There should ONLY be 2 variables
    if #splitstr ~= 2 then
        return nil
    else
        return { user = splitstr[1], msg = splitstr[2] }
    end
end

-- return the message package as a string (more friendly for debugging)
to_str = function(mpkg)
    if mpkg.user == nil then
        return nil
    else
        return '{user: '..mpkg.user..', message: '..mpkg.msg..'}'
    end
end

-- return the message package as a string (more friendly for writing to files or sending over rednet)
to_fstr = function(mpkg)
    if mpkg.user == nil then
        return nil
    else
        return mpkg.user..'|,|'..mpkg.msg
    end
end

-- simple function to split a string with a regex delimiter
split = function(str, delimiter)
    local t = {}
    local fpattern = '(.-)'..delimiter
    local le = 1
    local s, e, c = str:find(fpattern, 1)
    while s do
        if s ~= 1 or c ~= "" then
            table.insert(t, c)
        end
        le = e+1
        s, e, c = str:find(fpattern, le)
    end
    if le <= #str then
        c = str:sub(le)
        table.insert(t, c)
    end
    return t
end
