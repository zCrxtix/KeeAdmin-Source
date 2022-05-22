--// Parses the message so its easier to manage in the main script

local parsing = {}

function parsing.parse_arguments(msg : string)
   local r = string.split(msg, " ")
   parsing.command_name = r[1]  
   return r
end

function parsing.remove_prefix(msg : string)
    return string.sub(msg, 2)
end

function parsing.check_prefix(msg : string)
    return string.sub(msg, 1, 1)
end

function parsing.lower_string(msg : string)
    return string.lower(msg)
end

function parsing.get_command_name(msg : string)
    return parsing.command_name
end

return parsing
