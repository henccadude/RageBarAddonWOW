
-- RageBarAddon - Settings panel

local rageBar = _G["RageBar"]

if not rageBar then
    print("RageBarAddon: RageBar not found!")
    return
end

-- Default settings
local defaults = {
    width = 200,
    height = 20,
    red = 0.8,
    green = 0.1,
    blue = 0.1,
    showButtons = true
}

-- Apply settings to Rage Bar
local function ApplySettings()
    if not RageBarAddonDB then return end

    local settings = RageBarAddonDB.settings
    if not settings then return end

    rageBar:SetWidth(settings.width or defaults.width)
    rageBar:SetHeight(settings.height or defaults.height)

    rageBar:SetStatusBarColor(
        settings.red or defaults.red,
        settings.green or defaults.green,
        settings.blue or defaults.blue
    )
end

-- Show or hide both buttons
local function UpdateButtonVisibility()
    if not RageBarAddonDB or not RageBarAddonDB.settings then
        return
    end

    local visible = RageBarAddonDB.settings.showButtons

    local lockBTN = _G["RageBarLockButton"]
    local settingsBTN = _G["RageBarSettingsButton"]

    if lockBTN then
        if visible then
            lockBTN:Show()
        else
            lockBTN:Hide()
        end
    end

    if settingsBTN then
        if visible then
            settingsBTN:Show()
        else
            settingsBTN:Hide()
        end
    end
end

-- Create settings panel
local panel = CreateFrame("Frame", "RageBarSettingsPanel", UIParent)

panel:SetWidth(340)
panel:SetHeight(330)
panel:SetPoint("CENTER", UIParent, "CENTER")
panel:SetFrameStrata("DIALOG")
panel:EnableMouse(true)

-- Background
local background = panel:CreateTexture(nil, "BACKGROUND")
background:SetAllPoints(panel)
background:SetTexture("Interface\\Buttons\\WHITE8X8")
background:SetVertexColor(0.06, 0.06, 0.06, 0.95)

-- Title
local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", panel, "TOP", 0, -20)
title:SetText("RageBarAddon Settings")

-- Slider helper
local function CreateSlider(name, label, y, minValue, maxValue, step)
    local slider = CreateFrame("Slider", name, panel, "OptionsSliderTemplate")

    slider:SetPoint("TOP", panel, "TOP", 0, y)
    slider:SetWidth(240)
    slider:SetHeight(18)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step)

    _G[name .. "Text"]:SetText(label)
    _G[name .. "Low"]:SetText(tostring(minValue))
    _G[name .. "High"]:SetText(tostring(maxValue))

    return slider
end

-- Width
local widthSlider = CreateSlider(
    "RageBarWidthSlider", "Width", -70, 100, 400, 10
)

-- Height
local heightSlider = CreateSlider(
    "RageBarHeightSlider", "Height", -135, 10, 50, 2
)

-- Color presets
local colors = {
    { name = "Red", red = 0.8, green = 0.1, blue = 0.1 },
    { name = "Blue", red = 0.1, green = 0.4, blue = 0.9 },
    { name = "Green", red = 0.1, green = 0.8, blue = 0.2 }
}

-- Set color
local function SetColor(color)
    if not RageBarAddonDB or not RageBarAddonDB.settings then
        return
    end

    local settings = RageBarAddonDB.settings

    settings.red = color.red
    settings.green = color.green
    settings.blue = color.blue

    ApplySettings()
end

-- Color buttons
for i, color in ipairs(colors) do
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")

    button:SetWidth(85)
    button:SetHeight(25)
    button:SetPoint(
        "TOPLEFT",
        panel,
        "TOPLEFT",
        25 + (i - 1) * 100,
        -195
    )

    button:SetText(color.name)

    button:SetScript("OnClick", function()
        SetColor(color)
    end)
end

-- Width callback
widthSlider:SetScript("OnValueChanged", function(self, value)
    if not RageBarAddonDB or not RageBarAddonDB.settings then
        return
    end

    value = math.floor(value / 10 + 0.5) * 10
    RageBarAddonDB.settings.width = value

    ApplySettings()
end)

-- Height callback
heightSlider:SetScript("OnValueChanged", function(self, value)
    if not RageBarAddonDB or not RageBarAddonDB.settings then
        return
    end

    value = math.floor(value / 2 + 0.5) * 2
    RageBarAddonDB.settings.height = value

    ApplySettings()
end)

-- Show Buttons checkbox
local showButtonsCheck = CreateFrame(
    "CheckButton",
    "RageBarShowButtonsCheck",
    panel,
    "UICheckButtonTemplate"
)

showButtonsCheck:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -240)

local showButtonsLabel = showButtonsCheck:CreateFontString(
    nil,
    "OVERLAY",
    "GameFontNormal"
)

showButtonsLabel:SetPoint("LEFT", showButtonsCheck, "RIGHT", 5, 0)
showButtonsLabel:SetText("Show Buttons")

showButtonsCheck:SetScript("OnClick", function(self)
    if not RageBarAddonDB or not RageBarAddonDB.settings then
        return
    end

    RageBarAddonDB.settings.showButtons =
        self:GetChecked() and true or false

    UpdateButtonVisibility()
end)

-- Close button
local closeButton = CreateFrame(
    "Button",
    nil,
    panel,
    "UIPanelButtonTemplate"
)

closeButton:SetWidth(100)
closeButton:SetHeight(25)
closeButton:SetPoint("BOTTOM", panel, "BOTTOM", 0, 15)
closeButton:SetText("Close")

closeButton:SetScript("OnClick", function()
    panel:Hide()
end)

panel:Hide()

-- Load saved settings
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "RageBarAddon" then
        return
    end

    RageBarAddonDB = RageBarAddonDB or {}

    if type(RageBarAddonDB.settings) ~= "table" then
        RageBarAddonDB.settings = {}
    end

    local settings = RageBarAddonDB.settings

    -- Validate size
    settings.width = tonumber(settings.width) or defaults.width
    settings.height = tonumber(settings.height) or defaults.height

    settings.width = math.max(100, math.min(400, settings.width))
    settings.height = math.max(10, math.min(50, settings.height))

    -- Validate colors
    settings.red = tonumber(settings.red) or defaults.red
    settings.green = tonumber(settings.green) or defaults.green
    settings.blue = tonumber(settings.blue) or defaults.blue

    settings.red = math.max(0, math.min(1, settings.red))
    settings.green = math.max(0, math.min(1, settings.green))
    settings.blue = math.max(0, math.min(1, settings.blue))

    -- Validate button visibility
    if type(settings.showButtons) ~= "boolean" then
        settings.showButtons = defaults.showButtons
    end

    -- Restore sliders
    widthSlider:SetValue(settings.width)
    heightSlider:SetValue(settings.height)

    -- Restore checkbox
    showButtonsCheck:SetChecked(settings.showButtons)

    -- Apply saved settings
    ApplySettings()
    UpdateButtonVisibility()

    self:UnregisterEvent("ADDON_LOADED")
end)
