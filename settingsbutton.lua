
-- RageBarAddon - Settings button

local rageBar = _G["RageBar"]
local lockBTN = _G["RageBarLockButton"]
local panel = _G["RageBarSettingsPanel"]

if not rageBar or not panel then
    print("RageBarAddon: Settings button dependencies missing!")
    return
end

-- Create settings button
local settingsBTN = CreateFrame(
    "Button",
    "RageBarSettingsButton",
    rageBar
)

settingsBTN:SetWidth(24)
settingsBTN:SetHeight(24)

-- Position next to lock button
if lockBTN then
    settingsBTN:SetPoint("LEFT", lockBTN, "RIGHT", 5, 0)
else
    settingsBTN:SetPoint("LEFT", rageBar, "RIGHT", 5, 0)
end

-- Button background
local bg = settingsBTN:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(settingsBTN)
bg:SetTexture("Interface\\Buttons\\WHITE8X8")
bg:SetVertexColor(0.1, 0.1, 0.1, 0.9)

-- Settings button text
local settingsText = settingsBTN:CreateFontString(
    nil,
    "OVERLAY",
    "GameFontNormalLarge"
)

settingsText:SetPoint("CENTER", settingsBTN, "CENTER", 0, 0)
settingsText:SetText("S")
settingsText:SetTextColor(1, 0.82, 0.2)

-- Toggle settings panel
settingsBTN:SetScript("OnClick", function()
    if panel:IsShown() then
        panel:Hide()
    else
        panel:Show()
    end
end)

-- Tooltip
settingsBTN:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("RageBar Settings")
    GameTooltip:AddLine("Click to open settings", 1, 1, 1)
    GameTooltip:Show()
end)

settingsBTN:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
