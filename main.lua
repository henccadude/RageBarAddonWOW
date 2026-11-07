local rageBar = CreateFrame("StatusBar", "RageBar", UIParent)

rageBar:SetWidth(200)
rageBar:SetHeight(20)

-- Temporary position until SavedVariables are loaded
rageBar:SetPoint("CENTER", UIParent, "CENTER", 0, -180)

-- Make Rage Bar movable with Shift + left mouse button
rageBar:SetMovable(true)
rageBar:EnableMouse(true)
rageBar:RegisterForDrag("LeftButton")
rageBar:SetClampedToScreen(true)

rageBar:SetScript("OnDragStart", function(self)
    if RageBarAddonDB
        and not RageBarAddonDB.locked
        and IsShiftKeyDown() then

        self:StartMoving()
    end
end)

rageBar:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()

    local x = self:GetLeft() + self:GetWidth() / 2
    local y = self:GetBottom() + self:GetHeight() / 2

    local screenX = UIParent:GetWidth() / 2
    local screenY = UIParent:GetHeight() / 2

    RageBarAddonDB = RageBarAddonDB or {}

    RageBarAddonDB.position = {
        x = x - screenX,
        y = y - screenY
    }

    if type(RGB_DBG) == "table"
        and type(RGB_DBG.Info) == "function" then

        RGB_DBG.Info(
            "RageBar moved: X=" ..
            tostring(RageBarAddonDB.position.x) ..
            ", Y=" ..
            tostring(RageBarAddonDB.position.y)
        )
    end
end)

-- Bar initialization
rageBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
rageBar:SetStatusBarColor(0.8, 0.1, 0.1)
rageBar:SetMinMaxValues(0, 100)
rageBar:SetValue(0)

-- Background settings
local bg = rageBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(rageBar)
bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
bg:SetVertexColor(0.12, 0.12, 0.12, 0.9)

-- Border settings (without SetBackdrop)
local border = rageBar:CreateTexture(nil, "BORDER")
border:SetPoint("TOPLEFT", rageBar, "TOPLEFT", -2, 2)
border:SetPoint("BOTTOMRIGHT", rageBar, "BOTTOMRIGHT", 2, -2)
border:SetTexture("Interface\\Buttons\\WHITE8X8")
border:SetVertexColor(0, 0, 0, 1)

-- Rage text
local rangeText = rageBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
rangeText:SetPoint("CENTER", rageBar, "CENTER", 0, 0)
rangeText:SetTextColor(1, 1, 1)

-- Update rage
local function UpdateRange()
    local current = UnitPower("player", 1) or 0
    local max = UnitPowerMax("player", 1) or 100

    if max <= 0 then
        max = 100
    end

    rageBar:SetMinMaxValues(0, max)
    rageBar:SetValue(current)
    rangeText:SetText(current .. " / " .. max)
end

-- Update rage every 0.1 seconds
local elapsedTime = 0

rageBar:SetScript("OnUpdate", function(self, elapsed)
    elapsedTime = elapsedTime + elapsed

    if elapsedTime >= 0.1 then
        elapsedTime = 0
        UpdateRange()
    end
end)

-- Initial update
UpdateRange()

-- Restore SavedVariables after ADDON_LOADED
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "RageBarAddon" then
        return
    end

    RageBarAddonDB = RageBarAddonDB or {}

    -- Default position if no saved position exists
    if type(RageBarAddonDB.position) ~= "table" then
        RageBarAddonDB.position = {
            x = 0,
            y = -180
        }
    end

    -- Restore saved position
    rageBar:ClearAllPoints()
    rageBar:SetPoint(
        "CENTER",
        UIParent,
        "CENTER",
        RageBarAddonDB.position.x or 0,
        RageBarAddonDB.position.y or -180
    )

    -- Restore saved lock state
    if RageBarAddonDB.locked == nil then
        RageBarAddonDB.locked = false
    end

    -- Keep movement enabled internally.
    -- OnDragStart prevents dragging while locked.
    rageBar:SetMovable(true)
    rageBar:EnableMouse(true)

    if type(RGB_DBG) == "table"
        and type(RGB_DBG.Info) == "function" then

        RGB_DBG.Info("RageBar position and lock restored")
    end

    self:UnregisterEvent("ADDON_LOADED")
end)