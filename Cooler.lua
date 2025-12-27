-- CxzDev Ultra Cooling & AFK + FPS Selector
-- Rayfield UI | No Key | Mobile Friendly

-- Rayfield Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Window
local Window = Rayfield:CreateWindow({
   Name = "Cxz Ultra Cooling",
   LoadingTitle = "CxzDev",
   LoadingSubtitle = "Performance Script",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CxzCooling",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Cooling / FPS", 4483362458)
local AfkTab = Window:CreateTab("AFK", 4483362458)

-------------------------------------------------
-- CORE OPTIMIZATION FUNCTION
-------------------------------------------------
local function optimize(level)
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail")
		or v:IsA("Smoke") or v:IsA("Fire") then
			v.Enabled = false
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
			if level >= 2 then
				v.CastShadow = false
			end
		end
	end

	Lighting.GlobalShadows = false
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
end

-------------------------------------------------
-- MODE BUTTONS
-------------------------------------------------
MainTab:CreateButton({
	Name = "🟢 Mode 1 - Light Cooling",
	Callback = function()
		optimize(1)
		pcall(function()
			UserSettings():GetService("UserGameSettings").SavedQualityLevel =
				Enum.SavedQualitySetting.QualityLevel1
			setfpscap(45)
		end)
	end
})

MainTab:CreateButton({
	Name = "🟡 Mode 2 - Balanced Cooling",
	Callback = function()
		optimize(2)
		pcall(function()
			setfpscap(30)
			RunService:Set3dRenderingEnabled(true)
		end)
	end
})

MainTab:CreateButton({
	Name = "🔴 Mode 3 - Extreme Cooling",
	Callback = function()
		optimize(3)
		pcall(function()
			setfpscap(15)
			RunService:Set3dRenderingEnabled(false)
		end)
	end
})

-------------------------------------------------
-- FPS CAP SELECTOR
-------------------------------------------------
local infoLabel = MainTab:CreateLabel("Select FPS Cap\n")

local function applyFps(value, text)
    if setfpscap then
        setfpscap(value)
        infoLabel:Set("FPS Cap set to "..value.." FPS\n"..text)
    else
        infoLabel:Set("Executor tidak support setfpscap")
    end
end

local fpsList = {
    {10,  "🧊 Recommended for Cooling (AFK)"},
    {20,  "❄️ Recommended (Very Cool)"},
    {30,  "✅ Recommended (Stable)"},
    {40,  "⚠️ Balanced"},
    {50,  "⚠️ Balanced"},
    {60,  "🎮 Smooth Gameplay"},
    {90,  "🔥 Warm"},
    {120, "🔥🔥 Hot"},
    {144, "❌ Not Recommended (Mobile)"},
    {240, "❌❌ Overkill"}
}

for _, v in ipairs(fpsList) do
    MainTab:CreateButton({
        Name = tostring(v[1]).." FPS",
        Callback = function()
            applyFps(v[1], v[2])
        end
    })
end

-------------------------------------------------
-- ANTI AFK
-------------------------------------------------
local AntiAFK = false

AfkTab:CreateToggle({
	Name = "Anti AFK",
	CurrentValue = false,
	Callback = function(Value)
		AntiAFK = Value
	end
})

RunService.RenderStepped:Connect(function()
	if AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-------------------------------------------------
-- EMERGENCY BUTTON
-------------------------------------------------
MainTab:CreateButton({
	Name = "⚠️ Emergency Cooldown (Max Safe)",
	Callback = function()
		setfpscap(10)
		RunService:Set3dRenderingEnabled(false)
	end
})
