-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Window
local Window = Library:Window({
    Title = "Cxz Gen 1",
    Desc = "Beginner Lua Project",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Cxz"
    }
})

-- Divider Line (optional)
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = game:GetService("CoreGui")

---------------------------------------------------------
-- ===============  TAB: FARM  =========================
---------------------------------------------------------

local Farm = Window:Tab({Title = "Farm", Icon = "fish"})

Farm:Section({Title = "--- Farm ---"})

Farm:Button({
    Title = "Fishing",
    Desc = "Auto Fishing",
    Callback = function()
        print("[Cxz Gen 1] Fishing Started")
        -- isi script fishing mu nanti
    end
})

Farm:Button({
    Title = "Ultra Fishing",
    Desc = "Fast Auto Fishing",
    Callback = function()
        print("[Cxz Gen 1] Ultra Fishing Started")
        -- script ultra fishing
    end
})

---------------------------------------------------------
-- ===============  TAB: UTILITY  ======================
---------------------------------------------------------

local Utility = Window:Tab({Title = "Utility", Icon = "tools"})

Utility:Section({Title = "--- Utility ---"})

Utility:Button({
    Title = "Teleport",
    Desc = "Teleport to selected area",
    Callback = function()
        print("[Cxz Gen 1] Teleport Triggered")
        -- code teleport nanti
    end
})

Utility:Button({
    Title = "Buy",
    Desc = "Auto Buy Item",
    Callback = function()
        print("[Cxz Gen 1] Buy Triggered")
        -- code buy item
    end
})

---------------------------------------------------------
-- =============== TAB: SETTINGS  ======================
---------------------------------------------------------

local Settings = Window:Tab({Title = "Settings", Icon = "wrench"})

Settings:Section({Title = "--- Settings ---"})

-- Ultra Low GFX
Settings:Toggle({
    Title = "Ultra Low Graphic",
    Desc = "Boost FPS by removing effects",
    Value = false,
    Callback = function(state)
        print("Ultra Low GFX:", state)

        if state then
            -- sangat low gfx
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
                if v:IsA("ParticleEmitter") or v:IsA("Beam") then
                    v.Enabled = false
                end
            end
        else
            -- normal kembali (tanpa restore sepenuhnya)
            print("GFX reset (basic only)")
        end
    end
})

-- Black Screen Overlay
local BlackScreen = Instance.new("ScreenGui")
BlackScreen.IgnoreGuiInset = true
BlackScreen.ResetOnSpawn = false
BlackScreen.Enabled = false

local FrameBlack = Instance.new("Frame", BlackScreen)
FrameBlack.BackgroundColor3 = Color3.new(0,0,0)
FrameBlack.Size = UDim2.new(1,0,1,0)

BlackScreen.Parent = game:GetService("CoreGui")

Settings:Toggle({
    Title = "Black Screen Overlay",
    Desc = "Hide screen but keep UI visible",
    Value = false,
    Callback = function(v)
        BlackScreen.Enabled = v
        print("Black Screen:", v)
    end
})

---------------------------------------------------------
-- NOTIFICATION
---------------------------------------------------------

Window:Notify({
    Title = "Cxz Gen 1",
    Desc = "UI Loaded Successfully!",
    Time = 4
})
