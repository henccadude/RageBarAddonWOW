
-- RageBarAddon - Startup status

local addonName = "RageBarAddon"
local version = "1.0"

local statusFrame = CreateFrame("Frame")
statusFrame:RegisterEvent("ADDON_LOADED")

statusFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon ~= addonName then
        return
    end

    self:UnregisterEvent("ADDON_LOADED")

    local missing = {}

    -- Check required components
    if not _G["RageBar"] then
        table.insert(missing, "RageBar")
    end

    if not _G["RageBarLockButton"] then
        table.insert(missing, "LockButton")
    end

    if not _G["RageBarSettingsPanel"] then
        table.insert(missing, "SettingsPanel")
    end

    if not _G["RageBarSettingsButton"] then
        table.insert(missing, "SettingsButton")
    end

    if type(RGB_DBG) ~= "table" then
        table.insert(missing, "DebugSystem")
    end

    if type(RageBarAddonDB) ~= "table" then
        table.insert(missing, "SavedVariables")
    end

    -- Report status
    if #missing == 0 then
        print(
            "|cff00ff00" ..
            addonName .. " v" .. version ..
            " loaded successfully.|r"
        )
    else
        local message = table.concat(missing, ", ")

        print(
            "|cffff0000" ..
            addonName ..
            " failed to initialize: " ..
            message ..
            "|r"
        )

        if RGB_DBG and RGB_DBG.Error then
            RGB_DBG.Error(
                "Initialization failed. Missing: " .. message
            )
        end
    end
end)
