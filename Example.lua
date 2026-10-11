-- zomb.cc ui — full feature showcase
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SplitzRU/zomb.cc/main/ZombLib.lua"))()
local Toggles, Options = Library.Toggles, Library.Options

local Window = Library:CreateWindow({
	Title = "zomb.cc",
	Folder = "showcase",          -- configs land in workspace/zomb.cc/showcase/configs
	-- Loader = false,            -- skip the loading screen
	-- Mobile = true,             -- force the touch layout (handy for testing on pc)
})

local Tabs = {
	Combat  = Window:AddTab({ Name = "Combat",  Description = "aim assistance & triggers" }),
	Visuals = Window:AddTab({ Name = "Visuals", Description = "esp, chams & world" }),
	Player  = Window:AddTab({ Name = "Player",  Description = "movement & character" }),
}

-- combat ---------------------------------------------------------------------
local Aim = Tabs.Combat:AddLeftGroupbox("Aimbot")
Aim:AddToggle("AimEnabled", { Text = "Enabled", Tooltip = "Locks onto the closest target in your FOV" })
	:AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold", Text = "Aimbot" })
Aim:AddSlider("AimFOV", { Text = "Field of view", Min = 10, Max = 600, Default = 140, Suffix = "px" })
Aim:AddSlider("AimSmooth", { Text = "Smoothing", Min = 0, Max = 1, Default = 0.35, Rounding = 2 })
Aim:AddDropdown("AimPart", { Text = "Target part", Values = { "Head", "UpperTorso", "HumanoidRootPart", "Closest" }, Default = "Head" })
Aim:AddToggle("AimVisible", { Text = "Visibility check", Default = true })
Aim:AddToggle("AimSilent", { Text = "Silent aim", Risky = true, Tooltip = "Red = higher detection risk" })

local Trigger = Tabs.Combat:AddRightGroupbox("Triggerbot")
Trigger:AddToggle("TrigEnabled", { Text = "Enabled" }):AddKeyPicker("TrigKey", { Default = "T", Mode = "Toggle", Text = "Triggerbot", SyncToggleState = true })
Trigger:AddSlider("TrigDelay", { Text = "Reaction delay", Min = 0, Max = 300, Default = 60, Suffix = "ms" })
Trigger:AddDropdown("TrigWeapons", { Text = "Weapons", Values = { "Pistol", "Rifle", "Shotgun", "Sniper", "SMG" }, Multi = true, Default = { "Rifle", "SMG" } })

local Targets = Tabs.Combat:AddRightTabbox()
local Whitelist = Targets:AddTab("Whitelist")
Whitelist:AddDropdown("Whitelist", { Text = "Ignored players", SpecialType = "Player", Multi = true, ExcludeLocal = true })
Whitelist:AddToggle("IgnoreFriends", { Text = "Ignore friends", Default = true })
local Priority = Targets:AddTab("Priority")
Priority:AddDropdown("PriorityMode", { Text = "Sort targets by", Values = { "Distance", "Health", "Crosshair" }, Default = 3 })
Priority:AddToggle("StickyTarget", { Text = "Sticky target" })

-- visuals --------------------------------------------------------------------
local Esp = Tabs.Visuals:AddLeftGroupbox("Players")
Esp:AddToggle("EspBoxes", { Text = "Boxes", Default = true }):AddColorPicker("BoxColor", { Default = Color3.fromRGB(1, 245, 25), Title = "Box color" })
Esp:AddToggle("EspNames", { Text = "Names", Default = true }):AddColorPicker("NameColor", { Default = Color3.new(1, 1, 1) })
Esp:AddToggle("EspHealth", { Text = "Health bar" })
Esp:AddToggle("EspChams", { Text = "Chams" }):AddColorPicker("ChamColor", { Default = Color3.fromRGB(160, 100, 255), Transparency = 0.4, Title = "Chams" })
Esp:AddToggle("EspTracers", { Text = "Tracers" })
local TracerOpts = Esp:AddDependencyBox()
TracerOpts:AddDropdown("TracerOrigin", { Text = "Tracer origin", Values = { "Bottom", "Center", "Mouse" }, Default = "Bottom" })
TracerOpts:AddSlider("TracerThickness", { Text = "Thickness", Min = 1, Max = 5, Default = 1 })
TracerOpts:SetupDependencies({ { Toggles.EspTracers, true } })
Esp:AddSlider("EspDistance", { Text = "Render distance", Min = 50, Max = 5000, Default = 1500, Suffix = " studs" })

local World = Tabs.Visuals:AddRightGroupbox("World")
World:AddToggle("FullBright", { Text = "Fullbright" })
World:AddLabel("Ambient"):AddColorPicker("Ambient", { Default = Color3.fromRGB(120, 120, 120) })
World:AddSlider("ClockTime", { Text = "Time of day", Min = 0, Max = 24, Default = 14, Rounding = 1, Suffix = "h" })
World:AddDivider("crosshair")
World:AddToggle("Crosshair", { Text = "Custom crosshair" }):AddColorPicker("CrossColor", { Default = Color3.fromRGB(1, 245, 25) })
World:AddSlider("CrossSize", { Text = "Size", Min = 2, Max = 30, Default = 8 })

-- player ---------------------------------------------------------------------
local Move = Tabs.Player:AddLeftGroupbox("Movement")
Move:AddToggle("SpeedOn", { Text = "Walk speed" }):AddKeyPicker("SpeedKey", { Default = "None", Mode = "Toggle", SyncToggleState = true, Text = "Walk speed" })
Move:AddSlider("Speed", { Text = "Speed", Min = 16, Max = 120, Default = 32 })
Move:AddToggle("JumpOn", { Text = "Jump power" })
Move:AddSlider("Jump", { Text = "Power", Min = 50, Max = 250, Default = 80 })
Move:AddToggle("InfJump", { Text = "Infinite jump" })

local Misc = Tabs.Player:AddRightGroupbox("Misc")
Misc:AddInput("ChatMsg", { Text = "Spam message", Placeholder = "type something...", Default = "zomb.cc on top" })
Misc:AddInput("Delay", { Text = "Delay (seconds)", Numeric = true, Default = "2", Finished = true })
Misc:AddButton({ Text = "Notify me", Func = function()
	Library:Notify({ Title = "zomb.cc", Content = "Message: <b>" .. Options.ChatMsg.Value .. "</b>", Duration = 4 })
end }):AddButton({ Text = "Rejoin", DoubleClick = true, Func = function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end })
Misc:AddButton({ Text = "Copy job id", Func = function()
	pcall(setclipboard, game.JobId)
	Library:Notify("Job id copied to clipboard", 2)
end })
Misc:AddLabel("Labels wrap on their own, support <font color=\"#01F519\">rich text</font> and can carry color or key pickers.", true)
Misc:AddLabel("Panic key"):AddKeyPicker("PanicKey", { Default = "End", Mode = "Toggle", Text = "Panic", NoUI = true })

-- behaviour ------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function Humanoid()
	local c = LocalPlayer.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local defaultSpeed, defaultJump = 16, 50
local loop = RunService.Heartbeat:Connect(function()
	local hum = Humanoid()
	if not hum then return end
	hum.WalkSpeed = Toggles.SpeedOn.Value and Options.Speed.Value or defaultSpeed
	if Toggles.JumpOn.Value then
		hum.UseJumpPower = true
		hum.JumpPower = Options.Jump.Value
	end
end)

local jumpConn = UserInputService.JumpRequest:Connect(function()
	if Toggles.InfJump.Value then
		local hum = Humanoid()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

Options.PanicKey:OnClick(function()
	for _, t in pairs(Toggles) do
		if t.Idx and not tostring(t.Idx):find("^Zomb") then t:SetValue(false) end
	end
	Library:Notify({ Title = "Panic", Content = "Every feature switched off.", Duration = 3 })
end)

Library:OnUnload(function()
	loop:Disconnect()
	jumpConn:Disconnect()
	local hum = Humanoid()
	if hum then hum.WalkSpeed = defaultSpeed; hum.JumpPower = defaultJump end
end)
