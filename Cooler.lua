-- CxzDev Ultra Optimizer
-- SAME FEATURE & STRUCTURE
-- GUI : Fluent UI
-- No Key | Mobile Friendly

local Fluent = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"
))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-------------------------------------------------
-- WINDOW
-------------------------------------------------
local Window = Fluent:CreateWindow({
    Title = "Cxz Ultra Optimizer",
    SubTitle = "Cooling • FPS • Ping",
    Size = UDim2.fromOffset(520, 440),
    Acrylic = true,
    Theme = "Light"
})

local CoolingTab = Window:AddTab({ Title = "Cooling" })
local FpsTab     = Window:AddTab({ Title = "FPS Cap" })
local PingTab    = Window:AddTab({ Title = "Ping Optimizer" })
local AfkTab     = Window:AddTab({ Title = "AFK" })

-------------------------------------------------
-- CORE COOLING (SAMA)
-------------------------------------------------
local function optimize(level)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire") then
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
-- COOLING MODES (SAMA)
-------------------------------------------------
CoolingTab:AddButton({
    Title = "🟢 Light Cooling",
    Callback = function()
        optimize(1)
        pcall(function() setfpscap(45) end)
    end
})

CoolingTab:AddButton({
    Title = "🟡 Balanced Cooling",
    Callback = function()
        optimize(2)
        pcall(function() setfpscap(30) end)
    end
})

CoolingTab:AddButton({
    Title = "🔴 Extreme Cooling",
    Callback = function()
        optimize(3)
        pcall(function() setfpscap(15) end)
    end
})

CoolingTab:AddButton({
    Title = "⚠ Emergency Mode (MAX SAFE)",
    Callback = function()
        pcall(function() setfpscap(10) end)
    end
})

-------------------------------------------------
-- FPS CAP SELECTOR (SAMA)
-------------------------------------------------
FpsTab:AddDropdown("FPSCAP", {
    Title = "FPS Cap Selector",
    Values = {
        "10 (recommended for cooling)",
        "20 (recommended)",
        "30 (recommended)",
        "40",
        "50",
        "60",
        "90",
        "120",
        "144",
        "240"
    },
    Default = "30 (recommended)",
    Callback = function(Value)
        local fps = tonumber(Value:match("%d+"))
        if fps then
            pcall(function() setfpscap(fps) end)
        end
    end
})

-------------------------------------------------
-- PING OPTIMIZER (TOGGLE SLIDER)
-------------------------------------------------
local PingOptimized = false

PingTab:AddToggle("PingOpt", {
    Title = "⚡ Ping Optimizer",
    Default = false,
    Callback = function(Value)
        PingOptimized = Value

        if Value then
            pcall(function()
                settings().Network.IncomingReplicationLag = 0
            end)
        else
            pcall(function()
                settings().Network.IncomingReplicationLag = 0.1
            end)
        end
    end
})

-------------------------------------------------
-- SMART MODE (AUTO COOLING) SAMA
-------------------------------------------------
local SmartMode = false
local lastPos = nil
local idleTime = 0

PingTab:AddToggle("SmartMode", {
    Title = "🧠 Smart Mode (Auto Cooling)",
    Default = false,
    Callback = function(v)
        SmartMode = v
    end
})

RunService.Heartbeat:Connect(function(dt)
    if not SmartMode
    or not player.Character
    or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local hrp = player.Character.HumanoidRootPart

    if lastPos then
        if (hrp.Position - lastPos).Magnitude < 0.1 then
            idleTime += dt
            if idleTime > 5 then
                pcall(function() setfpscap(15) end)
            end
        else
            idleTime = 0
            pcall(function() setfpscap(30) end)
        end
    end

    lastPos = hrp.Position
end)

-------------------------------------------------
-- ANTI AFK (SAMA)
-------------------------------------------------
local AntiAFK = false

AfkTab:AddToggle("AFK", {
    Title = "Anti AFK",
    Default = false,
    Callback = function(v)
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
Fluent:Notify({
    Title = "Cxz Ultra Optimizer",
    Content = "Loaded • Same Feature • New GUI",
    Duration = 4
})	for _,v in pairs(workspace:GetDescendants()) do
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
-- COOLING MODES
-------------------------------------------------
CoolingTab:CreateButton({
	Name = "🟢 Light Cooling",
	Callback = function()
		optimize(1)
		pcall(function() setfpscap(45) end)
	end
})

CoolingTab:CreateButton({
	Name = "🟡 Balanced Cooling",
	Callback = function()
		optimize(2)
		pcall(function()
			setfpscap(30)
			RunService:Set3dRenderingEnabled(true)
		end)
	end
})

CoolingTab:CreateButton({
	Name = "🔴 Extreme Cooling",
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
FpsTab:CreateDropdown({
	Name = "FPS Cap Selector",
	Options = {
		"10 (Max Cooling)",
		"20 (Very Cool)",
		"30 (Recommended)",
		"40",
		"50",
		"60",
		"90",
		"120",
		"144",
		"240"
	},
	CurrentOption = "30 (Recommended)",
	Callback = function(Value)
		local fps = tonumber(Value:match("%d+"))
		if fps then
			pcall(function() setfpscap(fps) end)
		end
	end
})

-------------------------------------------------
-- PING OPTIMIZER (TOGGLE)
-------------------------------------------------
local PingOptimized = false

PingTab:CreateToggle({
	Name = "⚡ Ping Optimizer",
	CurrentValue = false,
	Callback = function(Value)
		PingOptimized = Value

		if Value then
			pcall(function()
				local ns = settings():GetService("NetworkSettings")
				ns.IncomingReplicationLag = 0
				ns.PhysicsSendRate = 1
				ns.DataSendRate = 1
			end)

			pcall(function()
				sethiddenproperty(player, "SimulationRadius", math.huge)
				sethiddenproperty(player, "MaxSimulationRadius", math.huge)
			end)
		else
			pcall(function()
				local ns = settings():GetService("NetworkSettings")
				ns.IncomingReplicationLag = 0.1
				ns.PhysicsSendRate = 30
				ns.DataSendRate = 30
			end)
		end
	end
})

-------------------------------------------------
-- SMART MODE (AUTO COOLING)
-------------------------------------------------
local SmartMode = false
local lastPos = nil
local idleTime = 0

PingTab:CreateToggle({
	Name = "🧠 Smart Mode (Auto Cooling)",
	CurrentValue = false,
	Callback = function(Value)
		SmartMode = Value
	end
})

RunService.Heartbeat:Connect(function(dt)
	if not SmartMode or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local hrp = player.Character.HumanoidRootPart
	if lastPos then
		if (hrp.Position - lastPos).Magnitude < 0.1 then
			idleTime += dt
			if idleTime > 5 then
				pcall(function()
					setfpscap(15)
					RunService:Set3dRenderingEnabled(false)
				end)
			end
		else
			idleTime = 0
			pcall(function()
				setfpscap(30)
				RunService:Set3dRenderingEnabled(true)
			end)
		end
	end

	lastPos = hrp.Position
end)

-------------------------------------------------
-- ANTI AFK
-------------------------------------------------
local AntiAFK = false

AfkTab:CreateToggle({
	Name = "Anti AFK",
	CurrentValue = false,
	Callback = function(v)
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
-- EMERGENCY MODE
-------------------------------------------------
CoolingTab:CreateButton({
	Name = "⚠️ Emergency Mode (MAX SAFE)",
	Callback = function()
		pcall(function()
			setfpscap(10)
			RunService:Set3dRenderingEnabled(false)
		end)
	end
})		or v:IsA("Smoke") or v:IsA("Fire") then
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
