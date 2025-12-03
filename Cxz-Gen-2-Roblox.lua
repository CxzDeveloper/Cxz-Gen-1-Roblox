--========================================--
-- CxzDev Beginner Lua Project ( Still Learning )
-- Webhook UI + Auto Detector + Stats + Persistence
--========================================--

-- NOTE:
-- This script tries to persist config to file using common exploit functions:
-- writefile/readfile/isfile (supported by many executors).
-- If not available, config will fallback to _G (non-persistent across sessions).

-- ======= DEPENDENCIES & SERVICES =======
local ok, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()
end)
if not ok or not Library then
    warn("[CxzDev] Failed to load UI library. Script may still run but UI won't appear.")
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ======= DEFAULT SETTINGS =======
local CONFIG_FILE = "cxz_webhook_config.json"
local DEFAULT_THUMBNAIL = "https://i.ibb.co/V03J3PCh/757jpg.jpg"

local SETTINGS = {
    WebhookURL = "",
    SendOnCatch = true,
    SendInventory = true,
    Send30MinReport = true,
    OnlyRareAndAbove = false,
    STATS_INTERVAL = 1800, -- 30 min
    ENABLE_THUMBNAILS = true,
    ThumbnailURL = DEFAULT_THUMBNAIL,
    LoggerLimit = 12
}

-- ======= FILE IO HELPERS (multi-executor safe) =======
local function fileWrite(path, content)
    if writefile then
        pcall(writefile, path, content); return true
    end
    if write_file then
        pcall(write_file, path, content); return true
    end
    if syn and syn.write_file then
        pcall(syn.write_file, path, content); return true
    end
    if (KRNL or krnl) and KRNL.WriteFile then
        pcall(function() KRNL.WriteFile(path, content) end); return true
    end
    return false
end

local function fileRead(path)
    if readfile then
        local ok, r = pcall(readfile, path)
        if ok then return r end
    end
    if read_file then
        local ok, r = pcall(read_file, path)
        if ok then return r end
    end
    if syn and syn.read_file then
        local ok, r = pcall(syn.read_file, path)
        if ok then return r end
    end
    if (KRNL or krnl) and KRNL.ReadFile then
        local ok, r = pcall(function() return KRNL.ReadFile(path) end)
        if ok then return r end
    end
    return nil
end

local function fileExists(path)
    if isfile then
        local ok, r = pcall(isfile, path)
        if ok then return r end
    end
    if file and file.IsExist then
        local ok, r = pcall(function() return file.IsExist(path) end)
        if ok then return r end
    end
    -- best-effort: try read
    local ok = pcall(function() return fileRead(path) end)
    return ok and fileRead(path) ~= nil
end

-- ======= PERSISTENCE =======
local function saveConfig()
    local encoded = HttpService:JSONEncode(SETTINGS)
    local ok = fileWrite(CONFIG_FILE, encoded)
    if ok then
        -- also set global for runtime
        _G.CxzWebhookConfig = SETTINGS
        return true
    end
    -- fallback: save to _G
    _G.CxzWebhookConfig = SETTINGS
    return false
end

local function loadConfig()
    local content = fileRead(CONFIG_FILE)
    if content then
        local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok and type(data) == "table" then
            for k,v in pairs(data) do SETTINGS[k] = v end
            _G.CxzWebhookConfig = SETTINGS
            return true
        end
    end
    -- fallback: try from _G
    if _G.CxzWebhookConfig then
        for k,v in pairs(_G.CxzWebhookConfig) do SETTINGS[k] = v end
        return true
    end
    return false
end

-- attempt load at start
loadConfig()

-- ======= STATE =======
local fishCounterTotal = 0
local last30MinCount = 0
local logEntries = {} -- newest first

-- ======= UTILS =======
local function safePost(payloadTable, webhook)
    local url = webhook or SETTINGS.WebhookURL
    if not url or url == "" then
        warn("[CxzDev] Webhook URL is empty. Set it in the UI first.")
        return false, "no_url"
    end
    local ok, err = pcall(function()
        local body = HttpService:JSONEncode(payloadTable)
        HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
    end)
    if not ok then
        warn("[CxzDev] Post error:", err)
    end
    return ok, err
end

-- parse chance "1 in X" style -> numeric + cleaned
local function parseChanceString(chanceText)
    if not chanceText then return nil end
    local s = chanceText:lower():gsub("%s+", "")
    -- handle range "1in100k-5m" take leftmost numeric
    local left = s:match("1in([%d%.]+[kKmM]?)") or s:match("1in([%d%.]+[kKmM]?)-")
    if not left then return nil end
    local mult = 1
    left = left:lower()
    if left:find("k") then left = left:gsub("k",""); mult = 1000 end
    if left:find("m") then left = left:gsub("m",""); mult = 1000000 end
    left = left:gsub("%.", "")
    local n = tonumber(left)
    if not n then return nil end
    return n * mult, chanceText
end

local function getTierFromChanceNumeric(numeric)
    if not numeric then return "Unknown", 0xFFFFFF, "❓" end
    if numeric >= 100000 then return "Secret", 0x0099CC, "💎" end
    if numeric >= 7500 then return "Legendary", 0xFFD700, "⭐" end
    if numeric >= 5000 then return "Mythic", 0xFF0000, "🔥" end
    if numeric >= 1000 then return "Epic", 0x9B59B6, "🟣" end
    if numeric >= 300 then return "Rare", 0x2ECC71, "🔵" end
    return "Common", 0xBFBFBF, "⚪"
end

-- inventory count best-effort
local function getInventoryCount()
    local invFolder = player:FindFirstChild("Inventory")
    if invFolder and typeof(invFolder.GetChildren) == "function" then
        return #invFolder:GetChildren()
    end
    -- search GUI for inventory-like
    local candidates = {"Inventory","Inv","Bag","BackpackGui"}
    for _, name in ipairs(candidates) do
        local obj = gui:FindFirstChild(name, true) or gui:FindFirstChild(name)
        if obj then
            local c = 0
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    c = c + 1
                end
            end
            if c > 0 then return c end
        end
    end
    return 0
end

-- logger helper
local function addLogEntry(name, tier, emoji)
    local t = os.date("%H:%M:%S")
    table.insert(logEntries, 1, { name = name, tier = tier, time = t, emoji = emoji or "" })
    while #logEntries > (SETTINGS.LoggerLimit or 12) do table.remove(logEntries) end
    if loggerGui and loggerGui.Refresh then loggerGui.Refresh() end
end

-- ======= WEBHOOK SENDERS =======
local function sendCatchWebhook(fishName, weightStr, chanceText, tier, color, emoji)
    if not SETTINGS.SendOnCatch then return end
    if SETTINGS.OnlyRareAndAbove then
        local ranks = { Common=1, Rare=2, Epic=3, Mythic=4, Legendary=5, Secret=6 }
        if (ranks[tier] or 1) < 2 then return end
    end

    local invCount = SETTINGS.SendInventory and getInventoryCount() or nil

    local desc = string.format(
        "✨ **Nama Ikan:** %s\n⚖️ **Berat:** %s\n🎯 **Chance:** `%s`\n🏷 **Tier:** %s %s",
        fishName or "Unknown",
        weightStr or "-",
        chanceText or "-",
        tier or "Unknown",
        emoji or ""
    )
    if invCount then desc = desc .. ("\n📦 **Inventory Count:** %d"):format(invCount) end

    local payload = {
        username = "🎣 CxzDev Webhook",
        embeds = {{
            title = (emoji or "") .. " You Got a Fish!",
            description = desc,
            color = color or 0xFFFFFF,
            footer = { text = ("Logged for: %s"):format(player.Name) },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    if SETTINGS.ENABLE_THUMBNAILS and SETTINGS.ThumbnailURL and SETTINGS.ThumbnailURL ~= "" then
        payload.embeds[1].thumbnail = { url = SETTINGS.ThumbnailURL }
    end

    safePost(payload)
end

local function sendStatsReport()
    local total = fishCounterTotal - last30MinCount
    local perMin = 0
    if SETTINGS.STATS_INTERVAL > 0 then perMin = math.floor(total / (SETTINGS.STATS_INTERVAL/60)) end
    local desc = string.format(
        "**Total Ikan (last %d min):** %d\n**Rata-rata per menit:** %d\n**Total Sejak Start:** %d",
        math.floor(SETTINGS.STATS_INTERVAL/60), total, perMin, fishCounterTotal
    )
    local payload = {
        username = "📊 CxzDev FishIt Stats",
        embeds = {{
            title = "📊 Statistik Periode",
            description = desc,
            color = 0x00C3FF,
            footer = { text = "Auto summary" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {}
        }}
    }
    if SETTINGS.SendInventory then
        table.insert(payload.embeds[1].fields, { name = "Inventory Snapshot", value = tostring(getInventoryCount()), inline = true })
    end
    safePost(payload)
    last30MinCount = fishCounterTotal
end

-- stats loop
task.spawn(function()
    while true do
        if SETTINGS.Send30MinReport then
            task.wait(SETTINGS.STATS_INTERVAL)
            pcall(sendStatsReport)
        else
            task.wait(1)
        end
    end
end)

-- ======= DETECTION LOGIC =======
local function findChanceAndNameInFrame(frame)
    -- gather textlabels, order by Y
    local textlabels = {}
    for _, c in ipairs(frame:GetDescendants()) do
        if c:IsA("TextLabel") then table.insert(textlabels, c) end
    end
    if #textlabels >= 2 then
        table.sort(textlabels, function(a,b)
            local ya, yb = 0,0
            pcall(function() ya = a.AbsolutePosition.Y; yb = b.AbsolutePosition.Y end)
            return ya < yb
        end)
        local top = textlabels[1].Text
        local bot = textlabels[2].Text
        return top, bot
    end
    -- fallback: single label with newline
    for _, c in ipairs(frame:GetDescendants()) do
        if c:IsA("TextLabel") then
            local t = c.Text
            if t and t:find("\n") and t:find("1 in") then
                local top, bottom = t:match("^(.-)\n(.-)$")
                return top, bottom
            end
        end
    end
    return nil, nil
end

local function handleNotifFrame(frame)
    task.wait(0.06)
    local ok, top, bottom = pcall(function() return findChanceAndNameInFrame(frame) end)
    if not ok or not top or not bottom then return end

    -- bottom may be "Bandit Angelfish (2.8kg)" or "You got: Bandit Angelfish"
    local nameText = bottom
    local weightStr = nil

    -- prefer explicit "You got: NAME"
    local gotName = bottom:match("You got:%s*(.+)") or bottom

    -- parse parentheses for weight
    local nmatch, wmatch = gotName:match("^(.-)%s*%((.-)%)$")
    if nmatch and nmatch ~= "" then
        nameText = nmatch
        weightStr = wmatch
    else
        local nm, wm = bottom:match("^(.-)%s*%((.-)%)$")
        if nm and nm ~= "" then
            nameText = nm
            weightStr = wm
        end
    end

    local numeric, cleaned = parseChanceString(top)
    local tier, color, emoji = getTierFromChanceNumeric(numeric)
    fishCounterTotal = fishCounterTotal + 1

    if SETTINGS.SendOnCatch then
        pcall(function()
            sendCatchWebhook(nameText, weightStr or "-", cleaned or top, tier, color, emoji)
        end)
    end

    addLogEntry(nameText, tier, emoji)
end

local function watchFolder(folder)
    if not folder then return end
    folder.ChildAdded:Connect(function(child)
        if child:IsA("Frame") or child:IsA("ImageLabel") then
            pcall(function() handleNotifFrame(child) end)
        elseif child:IsA("TextLabel") then
            local t = child.Text
            if t and t:find("1 in") and t:find("\n") then
                pcall(function() handleNotifFrame(child) end)
            end
        end
    end)
end

-- attach watchers
for _, v in ipairs(gui:GetChildren()) do
    if v:IsA("Frame") or v:IsA("Folder") or v:IsA("ScreenGui") then
        pcall(function() watchFolder(v) end)
    end
end
gui.ChildAdded:Connect(function(new)
    if new:IsA("Frame") or new:IsA("Folder") or new:IsA("ScreenGui") then
        pcall(function() watchFolder(new) end)
    end
end)

-- ======= GUI: create logger (premium) and Webhook Tab =======
local loggerGui
local function createLoggerGui()
    if gui:FindFirstChild("CxzDevFishLogger") then
        loggerGui = gui:FindFirstChild("CxzDevFishLogger")
        return
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CxzDevFishLogger"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = gui

    local frame = Instance.new("Frame")
    frame.Name = "LoggerFrame"
    frame.Size = UDim2.new(0, 320, 0, 180)
    frame.Position = UDim2.new(0, 8, 0.1, 0)
    frame.BackgroundTransparency = 0.15
    frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -12, 0, 24)
    title.Position = UDim2.new(0, 6, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "CxzDev Logger ⚡"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = frame

    local countLbl = Instance.new("TextLabel")
    countLbl.Name = "Count"
    countLbl.Size = UDim2.new(1, -12, 0, 18)
    countLbl.Position = UDim2.new(0,6,0,32)
    countLbl.BackgroundTransparency = 1
    countLbl.Text = "Total: 0"
    countLbl.TextXAlignment = Enum.TextXAlignment.Left
    countLbl.Font = Enum.Font.SourceSans
    countLbl.TextSize = 14
    countLbl.TextColor3 = Color3.fromRGB(200,200,200)
    countLbl.Parent = frame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.Size = UDim2.new(1, -12, 0, 96)
    scroll.Position = UDim2.new(0,6,0,54)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Name = "Toggle"
    btn.Size = UDim2.new(0, 60, 0, 20)
    btn.Position = UDim2.new(1, -66, 0, 6)
    btn.Text = "Hide"
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.Parent = frame
    local visible = true
    btn.MouseButton1Click:Connect(function()
        visible = not visible
        scroll.Visible = visible
        if visible then btn.Text = "Hide" else btn.Text = "Show" end
    end)

    screenGui.Refresh = function()
        for _, child in ipairs(scroll:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
        local y = 0
        for i = 1, #logEntries do
            local e = logEntries[i]
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -6, 0, 16)
            lbl.Position = UDim2.new(0, 4, 0, y)
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(220,220,220)
            lbl.Text = e.time .. " • " .. e.emoji .. " " .. e.name .. " (" .. (e.tier or "?") .. ")"
            lbl.Parent = scroll
            y = y + 18
        end
        scroll.CanvasSize = UDim2.new(0,0,0, y)
        countLbl.Text = "Total: "..tostring(fishCounterTotal)
    end

    loggerGui = screenGui
end

-- create UI window via library if available, else minimal fallback
local Window
if Library and Library.Window then
    Window = Library:Window({
        Title = "CxzDev Beginner Lua Project",
        Desc = "( Still Learning )",
        Icon = 105059922903197,
        Theme = "Dark",
        Config = {
            Keybind = Enum.KeyCode.LeftControl,
            Size = UDim2.new(0, 600, 0, 420)
        },
        CloseUIButton = {
            Enabled = true,
            Text = "Cxz"
        }
    })
else
    warn("[CxzDev] UI library missing. GUI controls won't be available.")
end

-- Settings tab creation (if library)
if Window and Window:Tab then
    local SettingsTab = Window:Tab({Title = "Settings", Icon = "wrench"})
    SettingsTab:Section({Title = "--- Settings ---"})
    SettingsTab:Toggle({
        Title = "Ultra Low Graphic",
        Desc = "Boost FPS by removing effects",
        Value = false,
        Callback = function(state)
            if state then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
                    if v:IsA("ParticleEmitter") or v:IsA("Beam") then v.Enabled = false end
                end
            else
                warn("GFX reset (basic only)")
            end
        end
    })
    SettingsTab:Toggle({
        Title = "Black Screen Overlay",
        Desc = "Hide screen but keep UI visible",
        Value = false,
        Callback = function(v)
            local BlackScreen = gui:FindFirstChild("CxzBlackScreen")
            if BlackScreen then BlackScreen.Enabled = v end
        end
    })
end

-- Webhook Tab (main controls)
local WebhookTab
if Window and Window:Tab then
    WebhookTab = Window:Tab({ Title = "Webhook", Icon = "notification" })
    WebhookTab:Section({ Title = "Webhook Settings" })
end

-- create webhook input (UI lib input if available)
local webhookInputWidget = nil
local function createWebhookInput()
    if WebhookTab and WebhookTab.Input then
        webhookInputWidget = WebhookTab:Input({
            Title = "Discord Webhook Link",
            Desc = "Masukkan webhook Discord (bisa diubah kapan saja)",
            Placeholder = "https://discord.com/api/webhooks/...",
            Value = SETTINGS.WebhookURL or ""
        })
        webhookInputWidget.OnChanged = function(txt)
            SETTINGS.WebhookURL = txt
        end
        -- add save button using library
        WebhookTab:Button({
            Title = "Save Webhook",
            Desc = "Save webhook to local file (persistent)",
            Callback = function()
                local ok = saveConfig()
                if ok then
                    Window:Notify({ Title = "Webhook", Desc = "Saved to file ✔️", Time = 3 })
                else
                    Window:Notify({ Title = "Webhook", Desc = "Saved to memory (no file API)", Time = 3 })
                end
            end
        })
    else
        -- fallback create small GUI on screen for input + save button
        local sg = Instance.new("ScreenGui")
        sg.Name = "CxzWebhookInputFallback"
        sg.ResetOnSpawn = false
        sg.Parent = gui

        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 360, 0, 80)
        frame.Position = UDim2.new(0, 180, 0, 8)
        frame.BackgroundTransparency = 0.15
        frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
        frame.BorderSizePixel = 0

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -12, 0, 18)
        label.Position = UDim2.new(0,6,0,6)
        label.BackgroundTransparency = 1
        label.Text = "Discord Webhook Link"
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(230,230,230)

        local txtb = Instance.new("TextBox", frame)
        txtb.Size = UDim2.new(1, -12, 0, 28)
        txtb.Position = UDim2.new(0,6,0,28)
        txtb.Text = SETTINGS.WebhookURL or ""
        txtb.ClearTextOnFocus = false

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 80, 0, 20)
        btn.Position = UDim2.new(1, -86, 0, 
