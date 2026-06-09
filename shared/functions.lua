-- Shared utility functions

--- Format number with thousands separator
---@param num number
---@return string
function FormatNumber(num)
    if not num then return "0" end
    local formatted = tostring(math.floor(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
    end
    return formatted
end

--- Convert minutes to hours and minutes string
---@param minutes number
---@return string
function MinutesToString(minutes)
    if not minutes then return "0 perc" end
    local hours = math.floor(minutes / 60)
    local mins = minutes % 60
    if hours > 0 then
        return string.format("%d ora %d perc", hours, mins)
    end
    return string.format("%d perc", mins)
end

--- Calculate player level from played minutes (same formula as MTA version)
---@param playedMinutes number
---@return number
function GetLevel(playedMinutes)
    if not playedMinutes or playedMinutes <= 0 then return 1 end
    -- Approximate formula: every 600 minutes (10 hours) = 1 level
    return math.floor(playedMinutes / 600) + 1
end

--- Generate a random invite code
---@return string
function GenerateInviteCode()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXY123456789"
    local code = ""
    for i = 1, 6 do
        local index = math.random(1, #chars)
        code = code .. chars:sub(index, index)
    end
    return code
end

--- Split string by delimiter
---@param str string
---@param delimiter string
---@return table
function SplitString(str, delimiter)
    local result = {}
    if not str then return result end
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end
