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

-- Sidebar Divider
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = game:GetService("CoreGui")


---------------------------------------------------------
-- AUTO FIND BUTTON “Auto”
---------------------------------------------------------

local function FindAutoButton()
    local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    for _, v in pairs(pg:GetDescendants()) do
        if v:IsA("TextButton") or v:IsA("ImageButton") then
            local name = string.lower(v.Name)
            local text = v.Text and string.lower(v.Text) or ""

            if name == "auto" or text == "auto" then
                return v
            end
        end
    end

    return nil
end


---------------------------------------------------------
-- ===============  TAB: FARM  =========================
---------------------------------------------------------

local Farm = Window:Tab({Title = "Farm", Icon = "fish"})

Farm:Section({Title = "--- Farm ---"})

-- AUTO FISHING (ON/OFF)
Farm:Toggle({
    Title = "Auto Fishing",
    Desc = "Tekan tombol 'Auto' bawaan game otomatis",
    Value = false,
    Callback = function(state)
        _G.AutoFishing = state

        if state then
            print("[Cxz Gen 1] Auto Fishing ON")

            task.spawn(function()
                while _G.AutoFishing do
                    local btn = FindAutoButton()

                    if btn then
                        pcall(function()
                            btn:Activate()
                        end)
                    end

                    task.wait(0.3)
                end
            end)

        else
            print("[Cxz Gen 1] Auto Fishing OFF")
        end
    end
})

-- ULTRA FISHING (masih kosong)
Farm:Button({
    Title = "Ultra Fishing",
    Desc = "Fast Auto Fishing (Coming Soon)",
    Callback = function()
        print("[Cxz Gen 1] Ultra Fishing (belum dibuat)")
    end
})


---------------------------------------------------------
-- ===============  TAB: UTILITY  ======================
---------------------------------------------------------

local Utility = Window:Tab({Title = "Utility", Icon = "tools"})

Utility:Section({Title = "--- Utility ---"})

Utility:Button({
    Title = "Teleport",
    Desc = "Teleport placeholder",
    Callback = function()
        print("[Cxz Gen 1] Teleport Triggered (belum dibuat)")
    end
})

Utility:Button({
    Title = "Buy",
    Desc = "Auto Buy placeholder",
    Callback = function()
        print("[Cxz Gen 1] Buy Triggered (belum dibuat)")
    end
})


---------------------------------------------------------
-- =============== TAB: SETTINGS  ======================
---------------------------------------------------------

local Settings = Window:Tab({Title = "Settings", Icon = "wrench"})
Settings:Section({Title = "--- Settings ---"})


-- ULTRA LOW GFX
Settings:Toggle({
    Title = "Ultra Low Graphic",
    Desc = "Boost FPS (remove effects)",
    Value = false,
    Callback = function(state)
        print("Ultra Low GFX:", state)

        if state then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
                if v:IsA("ParticleEmitter") or v:IsA("Beam") then
                    v.Enabled = false
                end
            end
        else
            print("GFX reset (basic only)")
        end
    end
})


-- BLACK SCREEN OVERLAY
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
})Farm:Button({
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
