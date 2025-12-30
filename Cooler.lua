-- Cxz Ultra Optimizer | CLOUD+ Auto Preset
-- Cloudphone • Data Saver • Auto Device Mode
-- DELTA SAFE

local OrionLib = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-------------------------------------------------
-- WINDOW
-------------------------------------------------
local Window = OrionLib:MakeWindow({
	Name = "Cxz Optimizer | Cloud+",
	HidePremium = true,
	SaveConfig = true,
	ConfigFolder = "CxzCloudAuto"
})

local CloudTab = Window:MakeTab({Name="Cloud+"})
local AutoTab  = Window:MakeTab({Name="Automatic"})
local FpsTab   = Window:MakeTab({Name="FPS"})
local AfkTab   = Window:MakeTab({Name="AFK"})

-------------------------------------------------
-- CORE OPTIMIZER
-------------------------------------------------
local function optimize(level)
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail")
		or v:IsA("Smoke") or v:IsA("Fire") then
			v.Enabled = false
		end
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
			v.CastShadow = true
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
-- APPLY PRESET
-------------------------------------------------
local function applyPreset(fps, render, level)
	optimize(level)
	setfpscap(fps)
	RunService:Set3dRenderingEnabled(render)
end

-------------------------------------------------
-- CLOUD+ MANUAL
-------------------------------------------------
CloudTab:AddButton({
	Name="☁ Cloud+ Lite (Recommended)",
	Callback=function()
		applyPreset(30, true, 2)
	end
})

CloudTab:AddButton({
	Name="🧊 Cloud+ Ultra Save",
	Callback=function()
		applyPreset(20, false, 3)
	end
})

CloudTab:AddButton({
	Name="💤 AFK Sleep Mode",
	Callback=function()
		setfpscap(10)
		RunService:Set3dRenderingEnabled(false)
	end
})

-------------------------------------------------
-- AUTOMATIC DEVICE MODES
-------------------------------------------------
local function resetAuto()
	-- hanya reset flag, setting akan ditimpa
end

AutoTab:AddToggle({
	Name="📱 Mode Realme (Cool & Stable)",
	Default=false,
	Callback=function(v)
		if v then
			resetAuto()
			applyPreset(30, true, 3)
		end
	end
})

AutoTab:AddToggle({
	Name="📱 Mode Redmi (Balanced)",
	Default=false,
	Callback=function(v)
		if v then
			resetAuto()
			applyPreset(35, true, 2)
		end
	end
})

AutoTab:AddToggle({
	Name="📱 Mode Poco (Performance)",
	Default=false,
	Callback=function(v)
		if v then
			resetAuto()
			applyPreset(45, true, 1)
		end
	end
})

AutoTab:AddToggle({
	Name="📱 Mode iPhone (Smooth)",
	Default=false,
	Callback=function(v)
		if v then
			resetAuto()
			applyPreset(60, true, 1)
		end
	end
})

-------------------------------------------------
-- FPS CAP
-------------------------------------------------
FpsTab:AddDropdown({
	Name="FPS Cap",
	Default="30",
	Options={"10","15","20","30","45","60","90"},
	Callback=function(v)
		setfpscap(tonumber(v))
	end
})

-------------------------------------------------
-- ANTI AFK
-------------------------------------------------
local AntiAFK = false
AfkTab:AddToggle({
	Name="Anti AFK",
	Default=true,
	Callback=function(v)
		AntiAFK = v
	end
})

RunService.RenderStepped:Connect(function()
	if AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-------------------------------------------------
OrionLib:Init()Cooling",
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
