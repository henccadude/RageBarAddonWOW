
local C = COLORS_Colors

RageBarAddonDB = RageBarAddonDB or {}

-- Check debug system
if type(RGB_DBG) ~= "table" or type(RGB_DBG.Error) ~= "function" then
    print("[ERROR] Debug system missing")
end

-- Check color system
if type(C) ~= "table" then
    print("[ERROR] Color system missing")
    C = {}
end

-- Process command arguments
local function ProcessMessage(message)
    local msg = tostring(message or "")
    msg = string.lower(msg)
    msg = string.gsub(msg, "^%s*(.-)%s*$", "%1")
    return msg
end

-- Print colored text
local function PrintColored(color, message)
    message = tostring(message)

    if type(color) ~= "string" or color == "" then
        print(message)
        return
    end

    print(color .. message .. (C.reset or "|r"))
end

-- Update lock button appearance
local function UpdateLockButton()
    local button = _G["RageBarLockButton"]

    if button and button.UpdateIcon then
        button.UpdateIcon()
    end
end

-- DEBUG
SLASH_MYDEBUG1 = "/debug"

SlashCmdList["MYDEBUG"] = function(msg)
    if type(RGB_DBG) ~= "table" then
        print("[ERROR] Debug system unavailable!")
        return
    end

    msg = ProcessMessage(msg)

    if msg == "" or msg == "help" then
        PrintColored(C.green, "Commands: /debug on, /debug off, /debug status")
        return
    end

    if msg == "on" then
        RGB_DBG.DEBUG = true
        PrintColored(C.green, "Debug on")
        return
    end

    if msg == "off" then
        RGB_DBG.DEBUG = false
        PrintColored(C.red, "Debug off")
        return
    end

    if msg == "status" then
        PrintColored(C.yellow, "Debug status: " .. tostring(RGB_DBG.DEBUG))
        return
    end

    PrintColored(C.red, "Unknown command: " .. msg)
end

-- RESET POSITION
SLASH_RGBRESET1 = "/rgbreset"

SlashCmdList["RGBRESET"] = function()
    local bar = _G["RageBar"]

    if not bar then
        PrintColored(C.red, "Rage Bar not found!")
        return
    end

    RageBarAddonDB.position = {
        x = 0,
        y = -180
    }

    bar:ClearAllPoints()
    bar:SetPoint("CENTER", UIParent, "CENTER", 0, -180)

    PrintColored(C.green, "Rage Bar position reset!")

    if RGB_DBG and RGB_DBG.Info then
        RGB_DBG.Info("Rage Bar position reset to default")
    end
end

-- LOCK
SLASH_RGBLOCK1 = "/rgblock"

SlashCmdList["RGBLOCK"] = function()
    local bar = _G["RageBar"]

    if not bar then
        PrintColored(C.red, "Rage Bar not found!")
        return
    end

    RageBarAddonDB.locked = true
    UpdateLockButton()

    PrintColored(C.green, "Rage Bar locked!")

    if RGB_DBG and RGB_DBG.Info then
        RGB_DBG.Info("Rage Bar locked")
    end
end

-- UNLOCK
SLASH_RGBUNLOCK1 = "/rgbunlock"

SlashCmdList["RGBUNLOCK"] = function()
    local bar = _G["RageBar"]

    if not bar then
        PrintColored(C.red, "Rage Bar not found!")
        return
    end

    RageBarAddonDB.locked = false
    UpdateLockButton()

    PrintColored(C.green, "Rage Bar unlocked!")

    if RGB_DBG and RGB_DBG.Info then
        RGB_DBG.Info("Rage Bar unlocked")
    end
end

-- SETTINGS
SLASH_RGBSETTINGS1 = "/rgbsettings"

SlashCmdList["RGBSETTINGS"] = function()
    local panel = _G["RageBarSettingsPanel"]

    if not panel then
        PrintColored(C.red, "Rage Bar settings panel not found!")
        return
    end

    if panel:IsShown() then
        panel:Hide()
    else
        panel:Show()
    end
end
