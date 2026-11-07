
-- RageBarAddon - Debug system

RGB_DBG = RGB_DBG or {}
RGB_DBG.DEBUG = RGB_DBG.DEBUG or false

local MAX_LOGS = 100

local function AddLog(level, message, color)
    if not RageBarAddonDB then
        return
    end

    if type(RageBarAddonDB.logs) ~= "table" then
        RageBarAddonDB.logs = {}
    end

    local entry = {
        level = level,
        message = tostring(message),
        color = color,
        timestamp = date("%Y-%m-%d %H:%M:%S")
    }

    table.insert(RageBarAddonDB.logs, entry)

    if #RageBarAddonDB.logs > MAX_LOGS then
        table.remove(RageBarAddonDB.logs, 1)
    end
end

function RGB_DBG.Debug(message)
    if RGB_DBG.DEBUG then
        AddLog("DEBUG", message, "|cff00ff00")
    end
end

function RGB_DBG.Info(message)
    AddLog("INFO", message, "|cff00ffff")
end

function RGB_DBG.Warn(message)
    AddLog("WARN", message, "|cffffff00")
end

function RGB_DBG.Error(message)
    AddLog("ERROR", message, "|cffff0000")
end
