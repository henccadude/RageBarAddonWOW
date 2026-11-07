local rageBar = _G["RageBar"]

if not rageBar then
    print("RageBarAddon: RageBar not found!")
    return
end

local lockBTN = CreateFrame("Button", "RageBarLockButton", rageBar)

lockBTN:SetWidth(24)
lockBTN:SetHeight(24)
lockBTN:SetPoint("LEFT", rageBar, "RIGHT", 5, 0)

-- Button background
local bg = lockBTN:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(lockBTN)
bg:SetTexture("Interface\\Buttons\\WHITE8X8")
bg:SetVertexColor(0.1, 0.1, 0.1, 0.9)

-- Lock status text
local lockText = lockBTN:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
lockText:SetPoint("CENTER", lockBTN, "CENTER", 0, 0)

local function UpdateLockButton()
    if RageBarAddonDB and RageBarAddonDB.locked then
        lockText:SetText("L")
        lockText:SetTextColor(1, 0.2, 0.2) -- Red = Locked
    else
        lockText:SetText("U")
        lockText:SetTextColor(0.2, 1, 0.2) -- Green = Unlocked
    end
end

-- Allow commands.lua to update the icon
lockBTN.UpdateIcon = UpdateLockButton

-- Toggle lock when clicked
lockBTN:SetScript("OnClick", function(self)
    if not RageBarAddonDB then
        return
    end

    RageBarAddonDB.locked = not RageBarAddonDB.locked

    UpdateLockButton()

    if RageBarAddonDB.locked then
        print("RageBar locked")
        if RGB_DBG and RGB_DBG.Info then
            RGB_DBG.Info("Rage Bar locked")
        end
    else
        print("RageBar unlocked")
        if RGB_DBG and RGB_DBG.Info then
            RGB_DBG.Info("Rage Bar unlocked")
        end
    end
end)

-- Restore icon after SavedVariables load
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "RageBarAddon" then
        return
    end

    UpdateLockButton()
    self:UnregisterEvent("ADDON_LOADED")
end)

-- Initial icon
UpdateLockButton()