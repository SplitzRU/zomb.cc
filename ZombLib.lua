--[[
     ____  ___  __  __ ____     ___ ___
    |_  / / _ \|  \/  | __ )   / __/ __|
     / / | (_) | |\/| |  _ \ _| (_| (__
    /___| \___/|_|  |_|____(_)\___\___|

    zomb.cc interface library
    black + toxic green, mobile first, Linoria-compatible API

    local Library = loadstring(...)()
    local Window  = Library:CreateWindow({ Title = "zomb.cc" })
    local Tab     = Window:AddTab("Main")
    local Box     = Tab:AddLeftGroupbox("Combat")
    Box:AddToggle("Aimbot", { Text = "Aimbot", Default = false })
]]

local cloneref = cloneref or clonereference or function(i) return i end
local function Svc(name) return cloneref(game:GetService(name)) end

local Players          = Svc("Players")
local UserInputService = Svc("UserInputService")
local TweenService     = Svc("TweenService")
local RunService       = Svc("RunService")
local HttpService      = Svc("HttpService")
local GuiService       = Svc("GuiService")
local CoreGui          = Svc("CoreGui")
local Stats            = Svc("Stats")
local Teams            = Svc("Teams")

local LocalPlayer = Players.LocalPlayer
local genv = (getgenv and getgenv()) or _G

if genv.ZombLib and type(genv.ZombLib.Unload) == "function" then
	pcall(function() genv.ZombLib:Unload() end)
end

local SHADOW_B64 = "iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAALG0lEQVR4nO1ci3LjNgwUZTn5/8+9xrI61zE6uM0uAFK0k7uWMxzJtMTHLrEAacnL8n/60tSW/16/juUbpa8koC3fLx1/KgjtN7aAY3lial9Yd5tQx2wgj1eT8QwC2oTytjwvHR3A9pZ3p1kDPQNuG7hnNuDZZ1UWlb+EgDZQ1oKy2ST0gn8EZb31Pp2AKtD+PCprot4e66rOUgT6GCBjCgmjBEQgKZAjwFuxnqgPFVAUwBEhvUQczyZAgV8FuOe8QoRKEWDHifPoyNoLU5s86zNQMS9JmZ3PIoABG5X1kILn7POntC1jKQI/A93yWiRGtTcTfMv3hATWTnPf+/NSqhKQOcJesNciEY20E/UpcqJHAfiVkMBIwTYV8CkhIxaQSYwCmx3XIglnCaiAf39kT8L90Q4jhaWIjBDM6jUR+GxWI8iYmyBiFW30EsBk5y6A9+c+s2uYdfg2WF+GLGAU/Eq+FMmISFCpAj4DfRckWLs28+1o1mJttF7f0OsDkBA2ay/uyMC+uM+XgCDmR1RfPPD+yPSbAWzgXx5HT8QuZNDqQhI84Kd8QOR4K1LjQUbQWdnqzrFO5g+wj0p+EPiDAGzH3bXrwbcjkroQErAvvq/HGSccRThMWhDoTZStARnKQSP4OPDM0SLoP89v7rNl3+YO7XrA70l/ZFIEMKnJyEACDHB2xLJLQoLyCRkB6DAZ+DvIz+2RI1/k28GJ4UHHsk9WcMYClGO9CMCjfBFEZE65SgBqPebbo00Dfn2cs/Z2EekwSxi2AA96RIIBw6TF5ys5v3aQwKQI+8fkh0kPA9/yhyAfVUAtxiJLKEdBFdAj/UcSriJvhAQkQq0RWD/9oFWsr4D34H9Au1h/lLPJ8YmMnijIVxyBjzP/Z34T51dhCd45R7OxYgGo/eZsI/DZrFdtMBJYCDoUBbEBoxwoCULA31xmRGyJFYxaQDb7DXzm+Fn96Nz9lsVKSMC+dREw4oSVBVh+F0RsjyNGR2qBhiQwB8wIMAv4eJyztjLg/b6RZZQhqfsRASrCyHwAi3z87PbAewLeAzl6JgEGPM5+VjeTtA3IsIUYw4jJ0L/lmQ+IJKjqA/zsN9A9GVeQo4oM9RLA5Afb8dKq/IlfQV+EFfhQNIuepkiQCkG9rCgreAc5YiSwLQo1OPQBuOUQ6b7VifXg4s3vG3mSmRWcXgcw4CtEZD7A5zdCAvMDZwhA/WcEe9DU6nlz4NvKWe1XlYjwBDCzxnMlP5kTzoh4Iw55e4IEmQWwOpfCqtkI8CtmljEC8iT84gcq6wCcaT0ypKyA+YO3ICSdQYABXwUfibP++HqUFSBWbF3wT9qCqKc3DK2QEBFxJRYQERDF6YwAdOq+jsxi1HaJitBU/z5FRT0LscwHVPeEFAlXd64iIR+pRBbgQ0S/2+kjHg8I6j0Cn4Ffwam0EGOsse89+IqErbgndAXwcVGGTljNMrYtgL9ysZmpZr1FS2zrnK3OlTQqHEvrAH+O4CsLUCRkDvpKQlElG1UCvEYz2WEzH/ekVESWSQ/zB0PrAOWAs3B0LZCwJdvUfmNu1AmzvR1cXPnQVIGPY8ukh+H3KVV8QBV45pQjWbqIQaud0V4fYAujO7nWbyl4HxHJDXO6VSLKPiBlrJMQdFzooC8C9GghVrEAi8V34XA3IT1Rf3sAz7BLfw9gJlSNhiKrYBK1BgM+uxDz15hPsO+ifkT9x7FWZj8FPyLgDCEVEnDQq7AavLZqAX5bGME3y8j6EYHfA3iYqlHQKAkVItaO3EMA+3y23TPgt7O7oVEDmSkiERE5Lbg+0lwPuu/XSqxiRrvYftfM742CVBmbAT1ktIHv1Iyzz/gz4Yx2oxkfEYH96iYgqjCSKOxcT14Ks81f4xP++tRbf3W2L8X+sOuWs044ajTrtLq/FYCu1FsBpae+yrh6+vMp/TS5GSlqqDqjLFWBQRnq6UPlmp4+DKdZBMxKrXiNAr8ym6vtvCR9NwKO4jU+xMRjtY4/ioBoQGyXMgLqKFzj28TjaJ29/czaLKWqE846jZ8rnV+KA1blbUJ9Z/qJ36n7ThPAKlEDY9f05iX4zoM+2v7ZvmXtdZGQEZBVODow/7rQ0fmdik6e2W6FyCpmXQRk4I8Mnr21chffebDZjGMWMaPdHjIybMIUERCZfDbjs8FWcwtWsPY56tOZthU5mUUoEo5ZTrgKfjaoHY6+nC2EjoHfA9RDVpV+KCLOkFAmwM/+DHCmoRnw7FnLHR5yWt2bib4PPRYQtRP1o0JCRaJSQraC9CiCKlrPBozPad6CX70QVCMmIwCBuiWvJ/n+qFz1DVk6RqKgKuDMtD0RONgb/AJmz1xi+56ce4EA7Bd7LUl9RjLYeJSPqFjBqXVAhQg0bTY4ny/icUHf3uhzQWiF9rCVP7LM+s0kqmIJx4woCNmMJCeb8eqV0Eba8/WOPhnn++PBZ7lqEZkkLVUitk79Z2audB9Bt8f81KPni5j5lvdBH8C0/69HVkQgIUqWWGTk+6LS0eMDjhNOl72LG70YsbiZa0+rRc/kYIr6hf0wAowMJIXJ0ohTDp3zJmY+s4TM+Ubge+AZoEug22eeC4oIYOAzy6iSoKTIJywLX9AwEpiWKcerwI+ep18SGZtFwB5YwI+EiAoJygGHsrQJwD0wyjGq0NP/8YUHP5r5d+Jwn/mOGLMAJCFz0NliTTngXwiphqE94aefafjEGW6uHUIm2NsxZwjA+j2wSIAigllAz4r49G5oBLyBZINc3f8u+D+/8MAdDiycpezdgBkSxEgwkD3wPwj4ioSIiDRlPsCf46xtgc76mc92MH3otgezX/mNM5txzAqQAOYLmB/I5CclRK0DWFSUyU9z4NuR7WgiSDsAc3kBAbgow5DUk4F+QK0JKvLzySGflSBmBTdYMLF4XcnOR0F+vJSxPlr9FRli/gCdc48TnipBfkA2YATfz+JWAF457pt4KyZbhPX8IGOgqW0RRgSeK/337SkJ6iaAyRAjwfIegMOA2Qn4ava3ExaQRWqehJ59omgh5vuCfUsJYMDjeYUERoAH4uq2G9TrQYyAXgtQBCg5wognC0EroagkoiJBlUH6pJw30+OtAD4jANtR/ct8gbKGbItaSVAJ9B4CVCUR8LixhoCo7YaLeF2oTSAArYARgb5hF8f7K5ywn/lWUdUS9sJMtO2G3QGuwGc/xFQJiNr3JHjnzEhR0lOZ+UzCUwIUKazMW4Ka+ZZ3sse/BlsO2a9gka9iJKgtCmYRWIbXYp0ZGaejIDbQu/ud1gBBCfIArMQK1uSdLS9BS4cFWP8UEWyhhlaBcuOBZ8cI+HIUpG5mO6VIgn1nYPlO+R/VUYJWMuuZ5qv1BesvhoRMiphfUgQpvcfw02OTWkFlMMzkGTDMYTJwWXSzkvsy8DPrrJAQkcHKmWNnbbC+DBPQQwJzmgrcNXG0meOtEOBBUTkCWUkMk5xu8EcezrUKvc5jwsWZyY/dh5K1dgA/SsBSJKECtnK2ZdkZsQC8NrII9pnltQB6FfgeS1iKRGRgV2Z8SsaIBSzEGUcWYd9jPh7fzwbft9tDAiuLJKZbbljqGZC6R8lE5Cuq57MJWDpAjcDOZOd4JgHsvqo8YVl1trN+Zj6AlVWsIvsuOld9mE6AurdChCprol7VxyoBrLwyk0f0/SUSlN1fJaYF91TrzVIFpB7Qe8ueTkBWTwXINnDPM0mo3pOVv5SASp1nSJqZZoB7CvRXDbRNaLst89Ix4ZppwL+CgDPttOV5qRfE6aB/BQHfre0vAft3AWH5Zhbw1PQ39IY8v+dMx+UAAAAASUVORK5CYII="

local Library = {
	Version = "1.0.0",
	Toggles = {},
	Options = {},
	Open = false,
	Toggled = false,
	Unloaded = false,
	Scale = 1,
	UserScale = 1,
	Connections = {},
	UnloadCallbacks = {},
	Registry = {},
	Refreshers = {},
	KeyPickers = {},
	OverlayScales = {},
	Folder = "zomb.cc/default",
	NotifySide = "Bottom right",
	MenuKeyDefault = "RightShift",
	Theme = {
		Accent = Color3.fromHex("363636"),       -- dark grey: fills, bars, checks
		Brand  = Color3.fromRGB(1, 245, 25),     -- the green ".cc", nothing else
		Base   = Color3.fromHex("030303"),
		Text   = Color3.fromHex("FFFFFF"),
		Risky  = Color3.fromRGB(255, 72, 72),
	},
	Presets = {
		Zomb   = { Accent = Color3.fromHex("363636"),     Base = Color3.fromHex("030303"), Text = Color3.fromHex("FFFFFF") },
		Toxic  = { Accent = Color3.fromRGB(1, 245, 25),   Base = Color3.fromRGB(9, 9, 9),    Text = Color3.fromRGB(236, 236, 236) },
		Blood  = { Accent = Color3.fromRGB(255, 45, 70),  Base = Color3.fromRGB(10, 8, 9),   Text = Color3.fromRGB(238, 232, 233) },
		Frost  = { Accent = Color3.fromRGB(70, 200, 255), Base = Color3.fromRGB(8, 10, 13),  Text = Color3.fromRGB(230, 238, 245) },
		Violet = { Accent = Color3.fromRGB(160, 100, 255), Base = Color3.fromRGB(10, 9, 13), Text = Color3.fromRGB(236, 233, 245) },
		Amber  = { Accent = Color3.fromRGB(255, 176, 0),  Base = Color3.fromRGB(11, 10, 8),  Text = Color3.fromRGB(240, 236, 228) },
	},
}
genv.ZombLib = Library
genv.Toggles = Library.Toggles
genv.Options = Library.Options

Library.IsMobile = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
	or (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)
if genv.ZOMB_FORCE_MOBILE ~= nil then Library.IsMobile = genv.ZOMB_FORCE_MOBILE == true end

-- =====================================================================
-- fonts, sizes, small helpers
-- =====================================================================
-- everything is Oswald (built into Roblox, Light..Bold); it's condensed, so every TextSize is scaled up in New()
local TEXT_SCALE = 1.15
local function TS(px) return math.floor(px * TEXT_SCALE + 0.5) end
local function Family(weight)
	return Font.new("rbxasset://fonts/families/Oswald.json", weight)
end
local FONT = {
	Regular = Family(Enum.FontWeight.Regular),
	Medium  = Family(Enum.FontWeight.Medium),
	Semi    = Family(Enum.FontWeight.SemiBold),
	Bold    = Family(Enum.FontWeight.Bold),
	Heavy   = Family(Enum.FontWeight.Bold),
	Mono    = Family(Enum.FontWeight.Regular),
}
Library.Fonts = FONT

local S = {}
local function SetSizes(mobile)
	S.Row   = mobile and 30 or 22
	S.Box   = mobile and 36 or 30
	S.Btn   = mobile and 36 or 30
	S.Txt   = mobile and 15 or 13
	S.Small = mobile and 13 or 12
	S.Tab   = mobile and 40 or 34
	S.Opt   = mobile and 32 or 26
	S.Gap   = mobile and 10 or 8
	S.Check = mobile and 20 or 18
	S.Bar   = mobile and 8 or 6
	S.Hit   = mobile and 28 or 18
end
SetSizes(Library.IsMobile)

local Enums = {
	X = Enum.AutomaticSize.X, Y = Enum.AutomaticSize.Y, XY = Enum.AutomaticSize.XY, None = Enum.AutomaticSize.None,
	Left = Enum.TextXAlignment.Left, Right = Enum.TextXAlignment.Right, Center = Enum.TextXAlignment.Center,
}

local function Lighten(c, n)
	n = n / 255
	return Color3.new(math.clamp(c.R + n, 0, 1), math.clamp(c.G + n, 0, 1), math.clamp(c.B + n, 0, 1))
end

local function Luma(c) return 0.299 * c.R + 0.587 * c.G + 0.114 * c.B end

function Library:_DeriveTheme()
	local T = self.Theme
	local b = T.Base
	-- window + sidebar sit a few shades under the base so panels lift off them
	T.Background  = Lighten(b, -5)
	T.Sidebar     = Lighten(b, -2)
	T.Panel       = Lighten(b, 6)
	T.Element     = Lighten(b, 13)
	T.Hover       = Lighten(b, 20)
	T.Stroke      = Lighten(b, 24)
	T.StrokeLight = Lighten(b, 40)
	T.SubText     = T.Text:Lerp(b, 0.42)
	T.DimText     = T.Text:Lerp(b, 0.66)
	T.AccentDark  = T.Accent:Lerp(Color3.new(0, 0, 0), 0.45)
	T.OnAccent    = Luma(T.Accent) > 0.45 and Lighten(b, 0) or Color3.new(1, 1, 1)
end
Library:_DeriveTheme()
Library.DefaultTheme = { Accent = Library.Theme.Accent, Base = Library.Theme.Base, Text = Library.Theme.Text }

local ClassDefaults = {
	Frame = { BorderSizePixel = 0 },
	CanvasGroup = { BorderSizePixel = 0 },
	ScrollingFrame = {
		BorderSizePixel = 0, BackgroundTransparency = 1, ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(), ScrollBarImageTransparency = 0.35,
	},
	TextLabel = {
		BackgroundTransparency = 1, BorderSizePixel = 0, FontFace = FONT.Regular, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left, Text = "", TextColor3 = Color3.new(1, 1, 1),
	},
	TextButton = {
		BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false, Text = "",
		FontFace = FONT.Regular, TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
	},
	TextBox = {
		BackgroundTransparency = 1, BorderSizePixel = 0, ClearTextOnFocus = false, FontFace = FONT.Regular,
		TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Text = "", TextColor3 = Color3.new(1, 1, 1),
	},
	ImageLabel = { BackgroundTransparency = 1, BorderSizePixel = 0 },
	ImageButton = { BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false },
}

function Library:_Resolve(key)
	if type(key) == "function" then return key() end
	return self.Theme[key]
end

function Library:AddToRegistry(inst, map)
	self.Registry[inst] = map
	for prop, key in pairs(map) do
		inst[prop] = self:_Resolve(key)
	end
end

-- glass mode: every solid surface is tagged with a layer; in glass mode its background goes see-through.
-- layers stack (window > sidebar/panel > element), so the inner ones only add a little opacity on top.
Library.Glass = true
Library.GlassOpacity = 0.85
Library.GlassBlur = true
Library.GlassReg = {}
local GLASS_WEIGHT = { Window = 1, Sidebar = 0.4, Panel = 0.5, Element = 0.65, Float = 1.05 }

function Library:_GlassT(layer)
	if not self.Glass then return 0 end
	return math.clamp(1 - self.GlassOpacity * (GLASS_WEIGHT[layer] or 1), 0, 0.97)
end

local function New(class, props)
	local inst = Instance.new(class)
	local defaults = ClassDefaults[class]
	if defaults then
		for k, v in pairs(defaults) do inst[k] = v end
	end
	local parent, theme, glass
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		elseif k == "Theme" then
			theme = v
		elseif k == "Glass" then
			glass = v
		elseif type(k) == "number" then
			v.Parent = inst
		else
			inst[k] = v
		end
	end
	if theme then Library:AddToRegistry(inst, theme) end
	if glass then
		Library.GlassReg[inst] = glass
		inst.BackgroundTransparency = Library:_GlassT(glass)
	end
	if class == "TextLabel" or class == "TextButton" or class == "TextBox" then inst.TextSize = TS(inst.TextSize) end
	if parent then inst.Parent = parent end
	return inst
end
Library.Create = New

local function Round(px) return New("UICorner", { CornerRadius = UDim.new(0, px) }) end
local function Pill() return New("UICorner", { CornerRadius = UDim.new(1, 0) }) end
local function Pad(t, r, b, l)
	return New("UIPadding", {
		PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r or t),
		PaddingBottom = UDim.new(0, b or t), PaddingLeft = UDim.new(0, l or r or t),
	})
end
local function List(props)
	props = props or {}
	props.SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder
	return New("UIListLayout", props)
end
local function Stroke(parent, key, thickness, transparency)
	return New("UIStroke", {
		Thickness = thickness or 1, Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Theme = { Color = key }, Parent = parent,
	})
end
local function Flex()
	return New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
end

local function Tween(obj, t, props, style, dir, delay)
	local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out, 0, false, delay or 0), props)
	tw:Play()
	return tw
end
Library.Tween = Tween

local function IsPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- follows one mouse press / one finger until it lifts
local function TrackDrag(input, onMove, onEnd)
	local touch = input.UserInputType == Enum.UserInputType.Touch
	local moveConn, endConn
	moveConn = UserInputService.InputChanged:Connect(function(i)
		if touch then
			if i == input then onMove(i.Position) end
		elseif i.UserInputType == Enum.UserInputType.MouseMovement then
			onMove(i.Position)
		end
	end)
	endConn = input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			moveConn:Disconnect()
			endConn:Disconnect()
			if onEnd then onEnd() end
		end
	end)
end

local function RandName()
	return (HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 14))
end

local function Escape(s)
	return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function RoundTo(v, decimals)
	local m = 10 ^ (decimals or 0)
	return math.floor(v * m + 0.5) / m
end

function Library:Connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(self.Connections, c)
	return c
end

function Library:SafeCallback(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[zomb.cc] callback error: " .. tostring(err))
		if self.NotifyOnError ~= false then
			self:Notify({ Title = "Callback error", Content = tostring(err):sub(1, 160), Duration = 5 })
		end
	end
end

function Library:OnUnload(fn) table.insert(self.UnloadCallbacks, fn) end

function Library:GetPlayersString(excludeLocal)
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if not (excludeLocal and p == LocalPlayer) then table.insert(list, p.Name) end
	end
	table.sort(list, function(a, b) return a:lower() < b:lower() end)
	return list
end

function Library:GetTeamsString()
	local list = {}
	for _, t in ipairs(Teams:GetTeams()) do table.insert(list, t.Name) end
	table.sort(list)
	return list
end

-- =====================================================================
-- embedded assets (written to the workspace, served via getcustomasset)
-- =====================================================================
local function B64Decode(s)
	local native = (crypt and (crypt.base64decode or crypt.base64_decode or (crypt.base64 and crypt.base64.decode)))
		or base64_decode or base64decode or (base64 and base64.decode)
	if native then
		local ok, out = pcall(native, s)
		if ok and type(out) == "string" and #out > 0 then return out end
	end
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	s = s:gsub("[^" .. chars .. "=]", "")
	return (s:gsub(".", function(x)
		if x == "=" then return "" end
		local r, f = "", (chars:find(x, 1, true) - 1)
		for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0") end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0) end
		return string.char(c)
	end))
end

local FS = (writefile and readfile and isfile and makefolder and isfolder) and true or false
Library.HasFileSystem = FS

local function EnsureFolder(path)
	if not FS then return end
	local acc = ""
	for part in path:gmatch("[^/]+") do
		acc = acc == "" and part or (acc .. "/" .. part)
		if not isfolder(acc) then pcall(makefolder, acc) end
	end
end

local function Asset(name, b64)
	if not (FS and getcustomasset) then return "" end
	local ok, id = pcall(function()
		local path = "zomb.cc/assets/" .. name
		local bytes = B64Decode(b64)
		EnsureFolder("zomb.cc/assets")
		if not isfile(path) or #readfile(path) ~= #bytes then writefile(path, bytes) end
		return getcustomasset(path)
	end)
	return ok and id or ""
end

Library.Shadow = Asset("shadow.png", SHADOW_B64)

-- "zomb.cc" -> "zomb" + ".cc" in the brand green (the only green left in the ui)
function Library:BrandText(title)
	local hex = self.Theme.Brand:ToHex()
	local a, b = tostring(title):match("^(.-)(%.[^%.]+)$")
	if a and a ~= "" then return Escape(a) .. '<font color="#' .. hex .. '">' .. Escape(b) .. "</font>" end
	return Escape(title)
end

-- =====================================================================
-- root gui
-- =====================================================================
local function ParentGui(gui)
	pcall(function()
		if protect_gui then protect_gui(gui) elseif syn and syn.protect_gui then syn.protect_gui(gui) end
	end)
	local ok = pcall(function() gui.Parent = CoreGui end)
	if not ok or gui.Parent == nil then
		pcall(function() gui.Parent = gethui() end)
	end
	if gui.Parent == nil then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local ScreenGui = New("ScreenGui", {
	Name = RandName(), ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false,
	IgnoreGuiInset = false, DisplayOrder = 9990,
})
ParentGui(ScreenGui)
Library.ScreenGui = ScreenGui

-- floating layers live directly in the ScreenGui (unscaled space) and carry their own UIScale
local Overlay = New("Frame", { Name = "Overlay", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 20, Parent = ScreenGui })
Library.Overlay = Overlay

local function OverlayScale(parent)
	local sc = New("UIScale", { Scale = Library.Scale, Parent = parent })
	table.insert(Library.OverlayScales, sc)
	return sc
end

local function MakeDraggable(handle, target, onEnd, onTap, filter)
	handle.InputBegan:Connect(function(input)
		if not IsPress(input) then return end
		if filter and not filter(input) then return end
		local start = input.Position
		local startPos = target.Position
		local moved = false
		TrackDrag(input, function(p)
			local d = p - start
			if not moved and d.Magnitude < 6 then return end
			moved = true
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end, function()
			if moved then
				if onEnd then onEnd() end
			elseif onTap then
				onTap()
			end
		end)
	end)
end

-- checkmark drawn from two rotated bars, grown like a pen stroke
local function BuildCheck(parent, size, colorKey, z)
	local k = size / 18
	local thick = math.max(2, math.floor(2 * k + 0.5))
	local function Leg(cx, cy, rot, len)
		local pivot = New("Frame", {
			BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(cx / 18, cy / 18), Size = UDim2.fromOffset(math.floor(len * 2 * k + 0.5), thick),
			Rotation = rot, ZIndex = z or 2, Parent = parent,
		})
		return New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0, 1),
			ZIndex = z or 2, Theme = { BackgroundColor3 = colorKey }, Parent = pivot, Pill(),
		})
	end
	return Leg(4.6, 9.4, 45, 4.4), Leg(7.6, 12.4, -47, 8.6)
end

-- a "v" chevron made the same way
local function BuildChevron(parent, size, colorKey)
	local holder = New("Frame", {
		BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(size, size), Parent = parent,
	})
	local len = math.floor(size * 0.42 + 0.5)
	local function Leg(x, rot)
		New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(x, 0.5),
			Size = UDim2.fromOffset(len, 2), Rotation = rot, Theme = { BackgroundColor3 = colorKey }, Parent = holder, Pill(),
		})
	end
	Leg(0.36, 45)
	Leg(0.64, -45)
	return holder
end

-- =====================================================================
-- tooltips
-- =====================================================================
local Tip = New("Frame", {
	AutomaticSize = Enums.XY, Size = UDim2.fromOffset(0, 0), Visible = false, ZIndex = 50,
	Theme = { BackgroundColor3 = "Panel" }, Glass = "Float", Parent = Overlay, Round(6), Pad(6, 9, 6, 9),
})
Stroke(Tip, "StrokeLight")
OverlayScale(Tip)
local TipText = New("TextLabel", {
	AutomaticSize = Enums.XY, Size = UDim2.fromOffset(0, 0), ZIndex = 51, TextSize = 12, FontFace = FONT.Medium,
	Theme = { TextColor3 = "Text" }, Parent = Tip, New("UISizeConstraint", { MaxSize = Vector2.new(260, 400) }),
})
TipText.TextWrapped = true
local tipToken = 0

local function PlaceTip()
	local m = UserInputService:GetMouseLocation()
	local inset = GuiService:GetGuiInset()
	Tip.Position = UDim2.fromOffset(m.X + 14, m.Y - inset.Y + 16)
end

function Library:_ShowTip(text, duration)
	tipToken += 1
	local token = tipToken
	TipText.Text = text
	PlaceTip()
	Tip.Visible = true
	if duration then
		task.delay(duration, function() if tipToken == token then Tip.Visible = false end end)
	end
end

function Library:_HideTip()
	tipToken += 1
	Tip.Visible = false
end

Library:Connect(RunService.RenderStepped, function()
	if Tip.Visible then PlaceTip() end
end)

function Library:AddTooltip(obj, text)
	if type(text) ~= "string" or text == "" then return end
	local hovering = false
	obj.MouseEnter:Connect(function()
		hovering = true
		task.delay(0.35, function() if hovering then Library:_ShowTip(text) end end)
	end)
	obj.MouseLeave:Connect(function()
		hovering = false
		Library:_HideTip()
	end)
	obj.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then return end
		local held = true
		local c; c = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then held = false; c:Disconnect() end
		end)
		task.delay(0.5, function() if held then Library:_ShowTip(text, 2.5) end end)
	end)
end

-- =====================================================================
-- notifications
-- =====================================================================
local NotifyHolder = New("Frame", {
	BackgroundTransparency = 1, Size = UDim2.new(0, 290, 1, -32), ZIndex = 15, Parent = ScreenGui,
})
local NotifyList = List({ Padding = UDim.new(0, 8), Parent = NotifyHolder })
OverlayScale(NotifyHolder)

function Library:SetNotifySide(side)
	self.NotifySide = side or "Bottom right"
	local top = side == "Top right" or side == "Top left"
	local left = side == "Top left" or side == "Bottom left"
	NotifyHolder.AnchorPoint = Vector2.new(left and 0 or 1, top and 0 or 1)
	NotifyHolder.Position = UDim2.new(left and 0 or 1, left and 16 or -16, top and 0 or 1, top and 16 or -16)
	NotifyList.VerticalAlignment = top and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
	NotifyList.HorizontalAlignment = left and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
end
Library:SetNotifySide(Library.IsMobile and "Top right" or "Bottom right")

local notifyOrder = 0
function Library:Notify(a, b)
	if self.Unloaded then return end
	local title, content, duration
	if type(a) == "table" then
		title = a.Title
		content = a.Content or a.Description or a.Text
		duration = a.Duration or a.Time
	else
		content = tostring(a)
		duration = b
	end
	duration = tonumber(duration) or 4
	notifyOrder += 1
	local left = self.NotifySide == "Top left" or self.NotifySide == "Bottom left"
	local fromX = left and -320 or 320

	local Slot = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y,
		LayoutOrder = (NotifyList.VerticalAlignment == Enum.VerticalAlignment.Top) and notifyOrder or -notifyOrder,
		Parent = NotifyHolder,
	})
	local Card = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Position = UDim2.fromOffset(fromX, 0),
		BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Panel" }, Glass = "Float", Parent = Slot, Round(8),
	})
	Stroke(Card, "Stroke")
	local Body = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Parent = Card,
		Pad(10, 12, 13, 12), List({ Padding = UDim.new(0, 3) }),
	})
	local Head = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1, Parent = Body })
	local brand = self._Title or "zomb.cc"
	New("TextLabel", {
		Text = (title == nil or title == brand) and self:BrandText(brand) or Escape(title), RichText = true,
		FontFace = FONT.Semi, TextSize = 13, Size = UDim2.fromScale(1, 1), TextTruncate = Enum.TextTruncate.AtEnd,
		Theme = { TextColor3 = "Text" }, Parent = Head,
	})
	if content and content ~= "" then
		New("TextLabel", {
			Text = content, TextWrapped = true, RichText = true, FontFace = FONT.Regular, TextSize = 12,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 2, Theme = { TextColor3 = "SubText" }, Parent = Body,
		})
	end
	local Bar = New("Frame", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -5), Size = UDim2.new(1, -20, 0, 2),
		Theme = { BackgroundColor3 = "Element" }, Parent = Card, Pill(),
	})
	local Fill = New("Frame", { Size = UDim2.fromScale(1, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = Bar, Pill() })

	Tween(Card, 0.45, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quint)
	Tween(Fill, duration, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Linear)

	local closed = false
	local function Close()
		if closed then return end
		closed = true
		Tween(Card, 0.35, { Position = UDim2.fromOffset(fromX, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		task.delay(0.36, function() Slot:Destroy() end)
	end
	Card.Activated:Connect(Close)
	task.delay(duration, Close)
	return { Close = Close }
end

-- =====================================================================
-- watermark
-- =====================================================================
local Watermark = New("Frame", {
	Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(0, 30), AutomaticSize = Enums.X, Visible = false, ZIndex = 12,
	Theme = { BackgroundColor3 = "Background" }, Glass = "Float", Parent = ScreenGui, Round(7), Pad(0, 12, 0, 10),
	List({ FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8) }),
})
Stroke(Watermark, "Stroke")
OverlayScale(Watermark)
local WatermarkText = New("TextLabel", {
	AutomaticSize = Enums.X, Size = UDim2.fromOffset(0, 30), RichText = true, FontFace = FONT.Medium, TextSize = 12,
	-- placeholder until the first fps sample lands, so it never shows as an empty box
	Text = Library:BrandText("zomb.cc"), LayoutOrder = 2, Theme = { TextColor3 = "Text" }, Parent = Watermark,
})
Library.Watermark = Watermark
Library.AutoWatermark = true
MakeDraggable(Watermark, Watermark)

function Library:SetWatermark(text)
	self.AutoWatermark = false
	WatermarkText.Text = text
end
function Library:SetWatermarkVisibility(v) Watermark.Visible = v == true end

do
	local frames, last = 0, os.clock()
	Library:Connect(RunService.RenderStepped, function()
		frames += 1
		local now = os.clock()
		if now - last >= 0.5 then
			local fps = math.floor(frames / (now - last) + 0.5)
			frames, last = 0, now
			Library.FPS = fps
			if Library.AutoWatermark and Watermark.Visible then
				local ping = 0
				pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5) end)
				local sep = '  <font color="#' .. Library.Theme.DimText:ToHex() .. '">|</font>  '
				WatermarkText.Text = Library:BrandText(Library._Title or "zomb.cc") .. sep .. fps .. " fps" .. sep .. ping .. " ms" .. sep .. os.date("%H:%M")
			end
		end
	end)
end

-- =====================================================================
-- keybind list
-- =====================================================================
local KeybindFrame = New("Frame", {
	Position = UDim2.new(0, 16, 0.42, 0), Size = UDim2.fromOffset(200, 0), AutomaticSize = Enums.Y, Visible = false, ZIndex = 12,
	Theme = { BackgroundColor3 = "Background" }, Glass = "Float", Parent = ScreenGui, Round(8), Pad(0, 0, 8, 0), List({ Padding = UDim.new(0, 0) }),
})
Stroke(KeybindFrame, "Stroke")
OverlayScale(KeybindFrame)
do
	local head = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 0, Parent = KeybindFrame })
	New("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(3, 12), Theme = { BackgroundColor3 = "Accent" }, Parent = head, Pill() })
	New("TextLabel", { Text = "Keybinds", FontFace = FONT.Semi, TextSize = 13, Position = UDim2.fromOffset(22, 0), Size = UDim2.new(1, -22, 1, 0), Theme = { TextColor3 = "Text" }, Parent = head })
	New("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 1, Theme = { BackgroundColor3 = "Stroke" }, Parent = KeybindFrame })
	New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 4), LayoutOrder = 2, Parent = KeybindFrame })
	MakeDraggable(head, KeybindFrame)
end
Library.KeybindFrame = KeybindFrame

local KeyShort = {
	MB1 = "MB1", MB2 = "MB2", MB3 = "MB3", LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl",
	RightControl = "RCtrl", LeftAlt = "LAlt", RightAlt = "RAlt", Backquote = "`", Return = "Enter", CapsLock = "Caps",
	One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
	LeftBracket = "[", RightBracket = "]", Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/",
	BackSlash = "\\", Minus = "-", Equals = "=", PageUp = "PgUp", PageDown = "PgDn", Insert = "Ins", Delete = "Del",
	None = "none",
}
local function KeyName(k) return KeyShort[k] or tostring(k) end

local function InputMatches(key, input)
	if key == "None" or key == nil then return false end
	local t = input.UserInputType
	if key == "MB1" then return t == Enum.UserInputType.MouseButton1 end
	if key == "MB2" then return t == Enum.UserInputType.MouseButton2 end
	if key == "MB3" then return t == Enum.UserInputType.MouseButton3 end
	return t == Enum.UserInputType.Keyboard and input.KeyCode.Name == key
end

local function NormalizeKey(k)
	if typeof(k) == "EnumItem" then
		if k == Enum.UserInputType.MouseButton1 then return "MB1" end
		if k == Enum.UserInputType.MouseButton2 then return "MB2" end
		if k == Enum.UserInputType.MouseButton3 then return "MB3" end
		return k.Name
	end
	if k == "MouseButton1" then return "MB1" end
	if k == "MouseButton2" then return "MB2" end
	if k == "MouseButton3" then return "MB3" end
	if k == nil or k == "" then return "None" end
	return tostring(k)
end

function Library:_UpdateKeybinds()
	local order = 10
	for _, kp in ipairs(self.KeyPickers) do
		local show = kp.Value ~= "None" and not kp.NoUI
		if show and not kp._ListRow then
			local row = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Parent = KeybindFrame, Pad(0, 12, 0, 12) })
			kp._ListKey = New("TextLabel", { FontFace = FONT.Mono, TextSize = 11, Size = UDim2.fromOffset(52, 22), Parent = row })
			kp._ListName = New("TextLabel", { FontFace = FONT.Medium, TextSize = 12, Position = UDim2.fromOffset(54, 0), Size = UDim2.new(1, -100, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
			kp._ListMode = New("TextLabel", { FontFace = FONT.Regular, TextSize = 11, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(46, 22), TextXAlignment = Enums.Right, Parent = row })
			kp._ListRow = row
		end
		if kp._ListRow then
			kp._ListRow.Visible = show
			if show then
				order += 1
				kp._ListRow.LayoutOrder = order
				local active = kp:GetState()
				local T = self.Theme
				kp._ListKey.Text = "[" .. KeyName(kp.Value) .. "]"
				kp._ListKey.TextColor3 = active and T.Accent or T.DimText
				kp._ListName.Text = kp.Text
				kp._ListName.TextColor3 = active and T.Text or T.SubText
				kp._ListMode.Text = kp.Mode:lower()
				kp._ListMode.TextColor3 = active and T.Accent or T.DimText
			end
		end
	end
end
table.insert(Library.Refreshers, function() Library:_UpdateKeybinds() end)

-- =====================================================================
-- mode menu for key pickers (right click / long press)
-- =====================================================================
local ModeMenu
function Library:_CloseModeMenu()
	if ModeMenu then ModeMenu:Destroy(); ModeMenu = nil end
end

function Library:_OpenModeMenu(kp, anchor)
	self:_CloseModeMenu()
	local ap, as = anchor.AbsolutePosition, anchor.AbsoluteSize
	local menu = New("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromOffset(ap.X + as.X, ap.Y + as.Y + 4),
		Size = UDim2.fromOffset(104, 0), AutomaticSize = Enums.Y, ZIndex = 40, Theme = { BackgroundColor3 = "Panel" }, Glass = "Float",
		Parent = Overlay, Round(7), Pad(4), List({ Padding = UDim.new(0, 2) }),
	})
	Stroke(menu, "StrokeLight")
	OverlayScale(menu)
	for i, mode in ipairs(kp.Modes) do
		local current = kp.Mode == mode
		local b = New("TextButton", {
			Size = UDim2.new(1, 0, 0, S.Opt - 2), LayoutOrder = i, ZIndex = 41, BackgroundTransparency = 1,
			Theme = { BackgroundColor3 = "Element" }, Parent = menu, Round(5),
		})
		New("TextLabel", {
			Text = mode, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 1, 0), ZIndex = 42, FontFace = FONT.Medium,
			TextSize = S.Small, TextColor3 = current and self.Theme.Accent or self.Theme.SubText, Parent = b,
		})
		b.MouseEnter:Connect(function() Tween(b, 0.12, { BackgroundTransparency = Library.Glass and 0.5 or 0 }) end)
		b.MouseLeave:Connect(function() Tween(b, 0.12, { BackgroundTransparency = 1 }) end)
		b.Activated:Connect(function()
			kp.Mode = mode
			kp.Toggled = false
			self:_CloseModeMenu()
			self:_UpdateKeybinds()
		end)
	end
	ModeMenu = menu
end

Library:Connect(UserInputService.InputBegan, function(input)
	if not ModeMenu or not IsPress(input) then return end
	local p, ap, as = input.Position, ModeMenu.AbsolutePosition, ModeMenu.AbsoluteSize
	if p.X < ap.X or p.Y < ap.Y or p.X > ap.X + as.X or p.Y > ap.Y + as.Y then
		task.defer(function() Library:_CloseModeMenu() end)
	end
end)

-- =====================================================================
-- shared element plumbing
-- =====================================================================
function Library:_ApplyVisibility(el)
	if el.Holder then el.Holder.Visible = el.Visible ~= false and not el._SearchHidden end
end

local function Base(obj, group)
	obj.Visible = true
	obj._Listeners = {}
	obj._Internal = {}
	function obj:OnChanged(fn)
		table.insert(self._Listeners, fn)
		Library:SafeCallback(fn, self.Value)
		return self
	end
	function obj:_Emit(...)
		Library:SafeCallback(self.Callback, ...)
		if self.Changed then Library:SafeCallback(self.Changed, ...) end
		for _, fn in ipairs(self._Listeners) do Library:SafeCallback(fn, ...) end
		for _, fn in ipairs(self._Internal) do task.spawn(fn, ...) end
	end
	function obj:SetVisible(v)
		self.Visible = v ~= false
		Library:_ApplyVisibility(self)
		return self
	end
	function obj:AddTooltip(text)
		if self.Holder then Library:AddTooltip(self.Holder, text) end
		return self
	end
	if group and group._Elements then table.insert(group._Elements, obj) end
	return obj
end

local function LockScroll(page, locked)
	if page then page.ScrollingEnabled = not locked end
end

local Funcs = {}
Funcs.__index = Funcs

local function NewContainer(frame, window, tab, group)
	return setmetatable({ Container = frame, Window = window, Tab = tab, Page = tab and tab.Page, _Group = group, _Order = 0 }, Funcs)
end

function Funcs:_Next()
	self._Order += 1
	return self._Order
end

-- a row that can carry addons (key pickers, color pickers) on its right and drop panels under it
local function MakeAddonHost(obj, holder)
	obj._PanelOrder = 0
	function obj:_NextPanel()
		self._PanelOrder += 1
		return self._PanelOrder
	end
	function obj:AddKeyPicker(idx, info)
		Library:_BuildKeyPicker(self, idx, info)
		return self
	end
	function obj:AddColorPicker(idx, info)
		Library:_BuildColorPicker(self, idx, info)
		return self
	end
end

-- =====================================================================
-- key picker
-- =====================================================================
function Library:_BuildKeyPicker(owner, idx, info)
	info = info or {}
	local KP = Base({
		Type = "KeyPicker", Idx = idx, Value = NormalizeKey(info.Default or "None"), Mode = info.Mode or "Toggle",
		Modes = info.Modes or { "Always", "Toggle", "Hold" }, Toggled = false, Text = info.Text or owner.Text or tostring(idx),
		SyncToggleState = info.SyncToggleState == true, NoUI = info.NoUI == true, Callback = info.Callback,
		ChangedCallback = info.ChangedCallback, Owner = owner, _Clicked = {},
	})
	if info.Clicked then table.insert(KP._Clicked, info.Clicked) end

	local Pill_ = New("TextButton", {
		Size = UDim2.fromOffset(0, S.Row - 4), AutomaticSize = Enums.X, Text = KeyName(KP.Value), FontFace = FONT.Mono,
		TextSize = S.Small - 1, LayoutOrder = 10, BackgroundTransparency = 0,
		Theme = { BackgroundColor3 = "Element", TextColor3 = "SubText" }, Glass = "Element", Parent = owner.AddonsFrame,
		Round(5), Pad(0, 8, 0, 8), New("UISizeConstraint", { MinSize = Vector2.new(30, 0) }),
	})
	local PillStroke = Stroke(Pill_, "Stroke")
	KP.Button = Pill_

	local picking, pulse, lastBind, longPressed = false, nil, 0, false

	local function Show()
		Pill_.Text = KeyName(KP.Value)
		Pill_.TextColor3 = (KP.Value ~= "None") and self.Theme.Text or self.Theme.DimText
	end

	local function StopPick()
		picking = false
		if pulse then pulse:Cancel(); pulse = nil end
		PillStroke.Transparency = 0
		Tween(PillStroke, 0.15, { Color = self.Theme.Stroke })
		Show()
		task.defer(function() if Library._Picking == KP then Library._Picking = nil end end)
	end

	function KP:GetState()
		if self.Mode == "Always" then return true end
		if self.Mode == "Hold" then
			local k = self.Value
			if k == "None" then return false end
			if k == "MB1" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end
			if k == "MB2" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
			if k == "MB3" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3) end
			local ok, kc = pcall(function() return Enum.KeyCode[k] end)
			return ok and kc and UserInputService:IsKeyDown(kc) or false
		end
		return self.Toggled
	end

	function KP:SetValue(data)
		local key, mode = data, nil
		if type(data) == "table" then key, mode = data[1], data[2] end
		self.Value = NormalizeKey(key)
		if mode and table.find(self.Modes, mode) then self.Mode = mode end
		Show()
		Library:_UpdateKeybinds()
		return self
	end

	function KP:OnClick(fn) table.insert(self._Clicked, fn); return self end

	function KP:_Press()
		if self.Mode == "Toggle" then
			self.Toggled = not self.Toggled
			if self.SyncToggleState and owner.Type == "Toggle" then owner:SetValue(not owner.Value) end
			Library:SafeCallback(self.Callback, self.Toggled)
			for _, fn in ipairs(self._Clicked) do Library:SafeCallback(fn, self.Toggled) end
		elseif self.Mode == "Hold" then
			Library:SafeCallback(self.Callback, true)
			for _, fn in ipairs(self._Clicked) do Library:SafeCallback(fn, true) end
		end
	end

	function KP:_Release()
		if self.Mode == "Hold" then Library:SafeCallback(self.Callback, false) end
	end

	Pill_.MouseEnter:Connect(function() if not picking then Tween(PillStroke, 0.15, { Color = Library.Theme.StrokeLight }) end end)
	Pill_.MouseLeave:Connect(function() if not picking then Tween(PillStroke, 0.15, { Color = Library.Theme.Stroke }) end end)

	Pill_.Activated:Connect(function()
		if picking or longPressed or os.clock() - lastBind < 0.3 then return end
		picking = true
		Library._Picking = KP
		Pill_.Text = "..."
		Pill_.TextColor3 = Library.Theme.Accent
		PillStroke.Color = Library.Theme.Accent
		pulse = TweenService:Create(PillStroke, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.75 })
		pulse:Play()
		task.wait()
		local conn
		conn = UserInputService.InputBegan:Connect(function(input)
			local t = input.UserInputType
			local key
			if t == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then
					key = false
				elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
					key = "None"
				else
					key = input.KeyCode.Name
				end
			elseif t == Enum.UserInputType.MouseButton1 then key = "MB1"
			elseif t == Enum.UserInputType.MouseButton2 then key = "MB2"
			elseif t == Enum.UserInputType.MouseButton3 then key = "MB3"
			elseif t == Enum.UserInputType.Touch then key = false
			else return end
			conn:Disconnect()
			lastBind = os.clock()
			if key then
				KP.Value = key
				KP.Toggled = false
				Library:SafeCallback(KP.ChangedCallback, key)
				KP:_Emit(key)
			end
			StopPick()
			Library:_UpdateKeybinds()
		end)
	end)

	Pill_.MouseButton2Click:Connect(function()
		if not picking then Library:_OpenModeMenu(KP, Pill_) end
	end)
	Pill_.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then return end
		local held = true
		local c; c = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then held = false; c:Disconnect() end
		end)
		task.delay(0.45, function()
			if held and not picking then
				longPressed = true
				Library:_OpenModeMenu(KP, Pill_)
				task.delay(0.6, function() longPressed = false end)
			end
		end)
	end)

	table.insert(self.Refreshers, function() if not picking then Show() end end)
	Show()
	table.insert(self.KeyPickers, KP)
	if owner.Type == "Toggle" then table.insert(owner.Addons, KP) end
	self.Options[idx] = KP
	self:_UpdateKeybinds()
	return KP
end

-- global key handling: menu bind + every key picker
Library:Connect(UserInputService.InputBegan, function(input)
	if Library.Unloaded or Library._Picking or UserInputService:GetFocusedTextBox() then return end
	local menuKey = Library.ToggleKeybind
	local menuName = type(menuKey) == "table" and menuKey.Value or (typeof(menuKey) == "EnumItem" and NormalizeKey(menuKey)) or Library.MenuKeyDefault
	if InputMatches(menuName, input) then Library:Toggle() end
	local touched = false
	for _, kp in ipairs(Library.KeyPickers) do
		if kp ~= menuKey and InputMatches(kp.Value, input) then
			kp:_Press()
			touched = true
		end
	end
	if touched then Library:_UpdateKeybinds() end
end)

Library:Connect(UserInputService.InputEnded, function(input)
	if Library.Unloaded then return end
	local touched = false
	for _, kp in ipairs(Library.KeyPickers) do
		if kp.Mode == "Hold" and InputMatches(kp.Value, input) then
			kp:_Release()
			touched = true
		end
	end
	if touched then Library:_UpdateKeybinds() end
end)

-- =====================================================================
-- color picker
-- =====================================================================
local RAINBOW = {}
for i = 0, 6 do table.insert(RAINBOW, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1))) end
RAINBOW[#RAINBOW] = ColorSequenceKeypoint.new(1, Color3.fromHSV(0.999, 1, 1))

function Library:_BuildColorPicker(owner, idx, info)
	info = info or {}
	local alpha = info.Transparency ~= nil
	local CP = Base({
		Type = "ColorPicker", Idx = idx, Value = info.Default or Color3.new(1, 1, 1),
		Transparency = alpha and info.Transparency or 0, Title = info.Title or owner.Text, Callback = info.Callback,
	})
	CP.Hue, CP.Sat, CP.Vib = CP.Value:ToHSV()

	local Swatch = New("TextButton", {
		Size = UDim2.fromOffset(self.IsMobile and 34 or 28, S.Row - 8), LayoutOrder = 20, BackgroundColor3 = CP.Value, BackgroundTransparency = 0,
		Parent = owner.AddonsFrame, Round(4),
	})
	local SwatchStroke = Stroke(Swatch, "StrokeLight")

	local SVH = 112
	local panelH = 8 + SVH + 8 + (alpha and 20 or 0) + 26 + 8
	local Panel = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, Visible = false, LayoutOrder = 100 + owner:_NextPanel(),
		Theme = { BackgroundColor3 = "Background" }, Glass = "Element", Parent = owner.Holder, Round(6),
	})
	Stroke(Panel, "Stroke")
	local Inner = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, panelH), Parent = Panel, Pad(8) })

	local SV = New("TextButton", { Size = UDim2.new(1, -28, 0, SVH), BackgroundColor3 = Color3.fromHSV(CP.Hue, 1, 1), BackgroundTransparency = 0, Parent = Inner, Round(5) })
	New("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = SV, Round(5),
		New("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
	})
	New("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Parent = SV, Round(5),
		New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }),
	})
	local Cursor = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = CP.Value, ZIndex = 3, Parent = SV, Pill(),
		New("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }),
	})

	local Hue = New("TextButton", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 18, 0, SVH),
		BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, Parent = Inner, Round(5),
		New("UIGradient", { Rotation = 90, Color = ColorSequence.new(RAINBOW) }),
	})
	local HueCursor = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 4, 0, 4), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 3, Parent = Hue, Pill(),
		New("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.5 }),
	})

	local AlphaBar, AlphaCursor
	if alpha then
		local back = New("Frame", { Position = UDim2.fromOffset(0, SVH + 8), Size = UDim2.new(1, 0, 0, 12), Theme = { BackgroundColor3 = "Hover" }, Parent = Inner, Round(4) })
		AlphaBar = New("TextButton", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = CP.Value, BackgroundTransparency = 0, Parent = back, Round(4),
			New("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
		})
		AlphaCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(0, 4, 1, 4),
			BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 3, Parent = back, Pill(),
			New("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.5 }),
		})
	end

	local Bottom = New("Frame", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(0, SVH + 8 + (alpha and 20 or 0)), Size = UDim2.new(1, 0, 0, 26), Parent = Inner,
		List({ FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }),
	})
	local function SmallBox(width, order)
		local f = New("Frame", { Size = width, LayoutOrder = order, Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Bottom, Round(5) })
		Stroke(f, "Stroke")
		return New("TextBox", {
			Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(6, 0), FontFace = FONT.Mono, TextSize = 11,
			TextXAlignment = Enums.Center, Theme = { TextColor3 = "Text" }, Parent = f,
		})
	end
	local HexBox = SmallBox(UDim2.new(0.36, -4, 1, 0), 1)
	local RGBBox = SmallBox(UDim2.new(0.64, -66, 1, 0), 2)
	local function MiniButton(text, order)
		local b = New("TextButton", {
			Size = UDim2.fromOffset(30, 26), LayoutOrder = order, Text = text, FontFace = FONT.Medium, TextSize = 11,
			BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Element", TextColor3 = "SubText" }, Glass = "Element", Parent = Bottom, Round(5),
		})
		Stroke(b, "Stroke")
		b.MouseEnter:Connect(function() Tween(b, 0.12, { TextColor3 = Library.Theme.Accent }) end)
		b.MouseLeave:Connect(function() Tween(b, 0.12, { TextColor3 = Library.Theme.SubText }) end)
		return b
	end
	local CopyBtn = MiniButton("cpy", 3)
	local PasteBtn = MiniButton("pst", 4)

	function CP:Display()
		local c = self.Value
		SV.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
		Cursor.Position = UDim2.fromScale(self.Sat, 1 - self.Vib)
		Cursor.BackgroundColor3 = c
		HueCursor.Position = UDim2.fromScale(0.5, self.Hue)
		Swatch.BackgroundColor3 = c
		Swatch.BackgroundTransparency = alpha and self.Transparency * 0.85 or 0
		if alpha then
			AlphaBar.BackgroundColor3 = c
			AlphaCursor.Position = UDim2.fromScale(self.Transparency, 0.5)
		end
		if not HexBox:IsFocused() then HexBox.Text = "#" .. c:ToHex():upper() end
		if not RGBBox:IsFocused() then
			RGBBox.Text = string.format("%d, %d, %d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
		end
	end

	function CP:_Commit()
		self.Value = Color3.fromHSV(self.Hue, self.Sat, self.Vib)
		self:Display()
		self:_Emit(self.Value, self.Transparency)
	end

	function CP:SetValueRGB(color, transparency)
		if typeof(color) ~= "Color3" then return self end
		self.Hue, self.Sat, self.Vib = color:ToHSV()
		if transparency ~= nil then self.Transparency = math.clamp(tonumber(transparency) or 0, 0, 1) end
		self.Value = color
		self:Display()
		self:_Emit(self.Value, self.Transparency)
		return self
	end

	function CP:SetValue(hsv, transparency)
		if typeof(hsv) == "Color3" then return self:SetValueRGB(hsv, transparency) end
		if type(hsv) == "table" then
			self.Hue, self.Sat, self.Vib = hsv[1] or 0, hsv[2] or 0, hsv[3] or 0
			if transparency ~= nil then self.Transparency = transparency end
			self:_Commit()
		end
		return self
	end

	local open = false
	function CP:Show(state)
		open = state
		if state then
			Panel.Visible = true
			Tween(Panel, 0.28, { Size = UDim2.new(1, 0, 0, panelH) })
			Tween(SwatchStroke, 0.2, { Color = Library.Theme.Accent })
		else
			Tween(Panel, 0.22, { Size = UDim2.new(1, 0, 0, 0) })
			Tween(SwatchStroke, 0.2, { Color = Library.Theme.StrokeLight })
			task.delay(0.22, function() if not open then Panel.Visible = false end end)
		end
	end
	Swatch.Activated:Connect(function() CP:Show(not open) end)

	local page = owner._Page
	local function DragArea(btn, fn)
		btn.InputBegan:Connect(function(input)
			if not IsPress(input) then return end
			LockScroll(page, true)
			fn(input.Position)
			TrackDrag(input, fn, function() LockScroll(page, false) end)
		end)
	end
	DragArea(SV, function(p)
		local ap, as = SV.AbsolutePosition, SV.AbsoluteSize
		CP.Sat = math.clamp((p.X - ap.X) / as.X, 0, 1)
		CP.Vib = 1 - math.clamp((p.Y - ap.Y) / as.Y, 0, 1)
		CP:_Commit()
	end)
	DragArea(Hue, function(p)
		local ap, as = Hue.AbsolutePosition, Hue.AbsoluteSize
		CP.Hue = math.clamp((p.Y - ap.Y) / as.Y, 0, 0.999)
		CP:_Commit()
	end)
	if alpha then
		DragArea(AlphaBar, function(p)
			local ap, as = AlphaBar.AbsolutePosition, AlphaBar.AbsoluteSize
			CP.Transparency = RoundTo(math.clamp((p.X - ap.X) / as.X, 0, 1), 2)
			CP:_Commit()
		end)
	end

	HexBox.FocusLost:Connect(function()
		local hex = HexBox.Text:gsub("#", ""):gsub("%s", "")
		if #hex == 3 then hex = hex:gsub(".", "%0%0") end
		local ok, c = pcall(Color3.fromHex, hex)
		if ok and c and #hex == 6 then CP:SetValueRGB(c) else CP:Display() end
	end)
	RGBBox.FocusLost:Connect(function()
		local r, g, b = RGBBox.Text:match("(%d+)%D+(%d+)%D+(%d+)")
		if r then
			CP:SetValueRGB(Color3.fromRGB(math.clamp(tonumber(r), 0, 255), math.clamp(tonumber(g), 0, 255), math.clamp(tonumber(b), 0, 255)))
		else
			CP:Display()
		end
	end)
	CopyBtn.Activated:Connect(function()
		Library.CopiedColor = { CP.Value, CP.Transparency }
		pcall(setclipboard, "#" .. CP.Value:ToHex():upper())
		Library:Notify({ Title = "Color copied", Content = "#" .. CP.Value:ToHex():upper(), Duration = 2 })
	end)
	PasteBtn.Activated:Connect(function()
		if Library.CopiedColor then CP:SetValueRGB(Library.CopiedColor[1], alpha and Library.CopiedColor[2] or nil) end
	end)

	CP:Display()
	self.Options[idx] = CP
	if owner.Type == "Toggle" then table.insert(owner.Addons, CP) end
	return CP
end

-- =====================================================================
-- elements
-- =====================================================================
function Funcs:AddToggle(idx, info)
	if type(idx) == "table" then info = idx; idx = info.Flag or info.Idx or info.Text end
	info = info or {}
	local group = self._Group
	local Toggle = Base({
		Type = "Toggle", Idx = idx, Value = info.Default == true, Text = info.Text or tostring(idx),
		Risky = info.Risky == true, Callback = info.Callback, Addons = {},
	}, group)
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = self:_Next(),
		Parent = self.Container, List({ Padding = UDim.new(0, 6) }),
	})
	local Row = New("TextButton", {
		Size = UDim2.new(1, 0, 0, S.Row), LayoutOrder = 0, Parent = Holder,
		List({ FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10) }),
	})
	local Box = New("Frame", { Size = UDim2.fromOffset(S.Check, S.Check), LayoutOrder = 1, Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Row, Round(5) })
	local BoxStroke = Stroke(Box, "Stroke")
	local BoxScale = New("UIScale", { Parent = Box })
	local Fill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Accent" }, Parent = Box, Round(5) })
	local Leg1, Leg2 = BuildCheck(Box, S.Check, "OnAccent", 3)
	local Label = New("TextLabel", {
		Size = UDim2.new(0, 0, 1, 0), Text = Toggle.Text, FontFace = FONT.Medium, TextSize = S.Txt,
		TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 2, Parent = Row, Flex(),
	})
	local Addons = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enums.X, LayoutOrder = 3, Parent = Row,
		List({ FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6) }),
	})
	Toggle.Holder, Toggle.Row, Toggle.AddonsFrame, Toggle._Page = Holder, Row, Addons, self.Page
	MakeAddonHost(Toggle, Holder)

	local hovered = false
	local function LabelColor()
		local T = Library.Theme
		if Toggle.Risky then return T.Risky end
		return (Toggle.Value or hovered) and T.Text or T.SubText
	end

	local function Display(animate, pop)
		local on = Toggle.Value
		local T = Library.Theme
		local k = animate and 1 or 0.001
		Tween(Fill, 0.18 * k, { BackgroundTransparency = on and 0 or 1 })
		Tween(BoxStroke, 0.18 * k, { Color = on and T.Accent or (hovered and T.StrokeLight or T.Stroke) })
		Tween(Label, 0.18 * k, { TextColor3 = LabelColor() })
		if on then
			if pop or not animate then
				Tween(Leg1, 0.12 * k, { Size = UDim2.fromScale(0.5, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.05 * k)
				Tween(Leg2, 0.16 * k, { Size = UDim2.fromScale(0.5, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.16 * k)
			end
			if pop then
				Tween(BoxScale, 0.07, { Scale = 0.82 }, Enum.EasingStyle.Quad)
				Tween(BoxScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0.07)
			end
		else
			Tween(Leg2, 0.08 * k, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Quad)
			Tween(Leg1, 0.08 * k, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.06 * k)
		end
	end

	function Toggle:SetValue(v)
		v = v == true
		local changed = v ~= self.Value
		self.Value = v
		Display(changed, changed)
		for _, addon in ipairs(self.Addons) do
			if addon.Type == "KeyPicker" and addon.SyncToggleState then addon.Toggled = v end
		end
		Library:_UpdateKeybinds()
		self:_Emit(v)
		return self
	end

	function Toggle:SetText(text)
		self.Text = text
		Label.Text = text
		self.SearchText = text:lower()
		return self
	end

	Row.MouseEnter:Connect(function() hovered = true; Display(true) end)
	Row.MouseLeave:Connect(function() hovered = false; Display(true) end)
	Row.Activated:Connect(function() Toggle:SetValue(not Toggle.Value) end)

	Toggle.SearchText = Toggle.Text:lower()
	table.insert(Library.Refreshers, function() Display(false) end)
	Display(false)
	if info.Tooltip then Toggle:AddTooltip(info.Tooltip) end
	if info.Visible == false then Toggle:SetVisible(false) end
	Library.Toggles[idx] = Toggle
	return Toggle
end
Funcs.AddCheckbox = Funcs.AddToggle

function Funcs:AddSlider(idx, info)
	if type(idx) == "table" then info = idx; idx = info.Flag or info.Text end
	info = info or {}
	local min, max = info.Min or 0, info.Max or 100
	local Slider = Base({
		Type = "Slider", Idx = idx, Min = min, Max = max, Rounding = info.Rounding or 0, Suffix = info.Suffix or "",
		Prefix = info.Prefix or "", Text = info.Text or tostring(idx), Callback = info.Callback, ShowMax = info.ShowMax == true,
	}, self._Group)
	Slider.Value = math.clamp(info.Default or min, min, max)

	local labelH = S.Txt + 4
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, labelH + 4 + S.Hit), LayoutOrder = self:_Next(), Parent = self.Container,
	})
	local Label = New("TextLabel", {
		Size = UDim2.new(1, -80, 0, labelH), Text = Slider.Text, FontFace = FONT.Medium, TextSize = S.Txt,
		TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Holder,
	})
	local ValueBox = New("TextBox", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 80, 0, labelH),
		FontFace = FONT.Mono, TextSize = S.Small, TextXAlignment = Enums.Right, Theme = { TextColor3 = "SubText" }, Parent = Holder,
	})
	local Track = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 1, -S.Hit / 2), Size = UDim2.new(1, 0, 0, S.Bar),
		Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Holder, Pill(),
	})
	local Fill = New("Frame", {
		Size = UDim2.fromScale(0, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = Track, Pill(),
		New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 0) }) }),
	})
	local Hit = New("TextButton", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, S.Hit), ZIndex = 3, Parent = Holder,
	})
	Slider.Holder, Slider.Track, Slider.Fill = Holder, Track, Fill

	local dragging, hovered = false, false

	local function Format(v)
		local s = Slider.Rounding > 0 and string.format("%." .. Slider.Rounding .. "f", v) or string.format("%d", v)
		s = Slider.Prefix .. s .. Slider.Suffix
		if Slider.ShowMax then s = s .. " / " .. Slider.Prefix .. (Slider.Rounding > 0 and string.format("%." .. Slider.Rounding .. "f", Slider.Max) or tostring(Slider.Max)) .. Slider.Suffix end
		return s
	end

	function Slider:Display()
		local span = self.Max - self.Min
		local pct = span == 0 and 0 or (self.Value - self.Min) / span
		Tween(Fill, dragging and 0.07 or 0.25, { Size = UDim2.fromScale(pct, 1) })
		if not ValueBox:IsFocused() then ValueBox.Text = Format(self.Value) end
	end

	function Slider:SetValue(v)
		v = tonumber(v)
		if not v then return self end
		v = RoundTo(math.clamp(v, self.Min, self.Max), self.Rounding)
		self.Value = v
		self:Display()
		self:_Emit(v)
		return self
	end

	function Slider:SetMin(v) self.Min = v; self:SetValue(self.Value) return self end
	function Slider:SetMax(v) self.Max = v; self:SetValue(self.Value) return self end
	function Slider:SetText(t) self.Text = t; Label.Text = t; self.SearchText = t:lower() return self end

	local function Emphasize(on)
		Tween(Track, 0.18, { Size = UDim2.new(1, 0, 0, on and S.Bar + 2 or S.Bar) })
		Tween(ValueBox, 0.18, { TextColor3 = on and Library.Theme.Accent or Library.Theme.SubText })
	end

	local function FromX(x)
		local ap, as = Track.AbsolutePosition, Track.AbsoluteSize
		local pct = math.clamp((x - ap.X) / math.max(as.X, 1), 0, 1)
		local v = RoundTo(Slider.Min + (Slider.Max - Slider.Min) * pct, Slider.Rounding)
		if v ~= Slider.Value then Slider:SetValue(v) else Slider:Display() end
	end

	local page = self.Page
	Hit.InputBegan:Connect(function(input)
		if not IsPress(input) then return end
		if input.UserInputType == Enum.UserInputType.Touch then
			-- decide between "drag the slider" and "scroll the page" on the first real movement
			local start, engaged, decided = input.Position, false, false
			TrackDrag(input, function(p)
				local d = p - start
				if not decided then
					if d.Magnitude < 5 then return end
					decided = true
					engaged = math.abs(d.X) >= math.abs(d.Y)
					if engaged then dragging = true; LockScroll(page, true); Emphasize(true) end
				end
				if engaged then FromX(p.X) end
			end, function()
				if not decided then FromX(start.X) end
				if engaged then dragging = false; LockScroll(page, false); Emphasize(false); Slider:Display() end
			end)
		else
			dragging = true
			Emphasize(true)
			FromX(input.Position.X)
			TrackDrag(input, function(p) FromX(p.X) end, function()
				dragging = false
				if not hovered then Emphasize(false) end
				Slider:Display()
			end)
		end
	end)
	Hit.MouseEnter:Connect(function() hovered = true; Emphasize(true) end)
	Hit.MouseLeave:Connect(function() hovered = false; if not dragging then Emphasize(false) end end)

	ValueBox.Focused:Connect(function()
		ValueBox.Text = tostring(Slider.Value)
		ValueBox.SelectionStart = 1
		ValueBox.CursorPosition = #ValueBox.Text + 1
		Emphasize(true)
	end)
	ValueBox.FocusLost:Connect(function()
		local n = tonumber((ValueBox.Text:gsub("[^%d%.%-]", "")))
		Emphasize(false)
		if n then Slider:SetValue(n) else Slider:Display() end
	end)

	Slider.SearchText = Slider.Text:lower()
	dragging = true
	Slider:Display()
	dragging = false
	Fill.Size = UDim2.fromScale((Slider.Max - Slider.Min) == 0 and 0 or (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
	if info.Tooltip then Slider:AddTooltip(info.Tooltip) end
	if info.Visible == false then Slider:SetVisible(false) end
	Library.Options[idx] = Slider
	return Slider
end

function Funcs:AddDropdown(idx, info)
	if type(idx) == "table" then info = idx; idx = info.Flag or info.Text end
	info = info or {}
	local DD = Base({
		Type = "Dropdown", Idx = idx, Values = info.Values or {}, Multi = info.Multi == true, AllowNull = info.AllowNull == true,
		Text = info.Text or tostring(idx), Callback = info.Callback, SpecialType = info.SpecialType, MaxVisible = info.MaxVisible or 6,
	}, self._Group)
	DD.Value = DD.Multi and {} or nil

	if DD.SpecialType == "Player" then
		DD.Values = Library:GetPlayersString(info.ExcludeLocal)
	elseif DD.SpecialType == "Team" then
		DD.Values = Library:GetTeamsString()
	end

	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = self:_Next(),
		Parent = self.Container, List({ Padding = UDim.new(0, 6) }),
	})
	if DD.Text ~= "" then
		New("TextLabel", {
			Size = UDim2.new(1, 0, 0, S.Txt + 2), Text = DD.Text, FontFace = FONT.Medium, TextSize = S.Txt, LayoutOrder = 1,
			TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Holder,
		})
	end
	local Box = New("TextButton", { Size = UDim2.new(1, 0, 0, S.Box), LayoutOrder = 2, BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Holder, Round(6) })
	local BoxStroke = Stroke(Box, "Stroke")
	local Display = New("TextLabel", {
		Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -40, 1, 0), FontFace = FONT.Medium, TextSize = S.Small + 1,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = Box,
	})
	local Chevron = BuildChevron(Box, 12, "SubText")

	local List_ = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, Visible = false, LayoutOrder = 3,
		Theme = { BackgroundColor3 = "Background" }, Glass = "Element", Parent = Holder, Round(6),
	})
	Stroke(List_, "Stroke")
	local searchable = info.Searchable or (info.Searchable == nil and (#DD.Values > 7 or DD.SpecialType == "Player"))
	local top = searchable and (S.Opt + 10) or 4
	local SearchBox
	if searchable then
		local sb = New("Frame", { Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 0, S.Opt), Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = List_, Round(5) })
		SearchBox = New("TextBox", {
			Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -18, 1, 0), PlaceholderText = "Search...", FontFace = FONT.Regular,
			TextSize = S.Small, Theme = { TextColor3 = "Text", PlaceholderColor3 = "DimText" }, Parent = sb,
		})
	end
	local Scroll = New("ScrollingFrame", {
		Position = UDim2.fromOffset(4, top), Size = UDim2.new(1, -8, 1, -(top + 4)), ScrollBarThickness = 0, ScrollBarImageTransparency = 1,
		Theme = { ScrollBarImageColor3 = "Accent" }, Parent = List_, List({ Padding = UDim.new(0, 2) }),
	})
	DD.Holder, DD.Box = Holder, Box

	local Options = {}
	local open = false

	local function Selected(v)
		if DD.Multi then return DD.Value[v] == true end
		return DD.Value == v
	end

	local function RefreshOptions()
		local T = Library.Theme
		for _, o in ipairs(Options) do
			local sel = Selected(o.Value)
			Tween(o.Text, 0.15, { TextColor3 = sel and T.Accent or T.SubText })
			Tween(o.Bar, 0.2, { Size = UDim2.fromOffset(2, sel and (S.Opt - 12) or 0) })
			Tween(o.L1, 0.12, { Size = UDim2.fromScale(sel and 0.5 or 0, 1) })
			Tween(o.L2, 0.14, { Size = UDim2.fromScale(sel and 0.5 or 0, 1) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, sel and 0.08 or 0)
		end
	end

	local function DisplayText()
		local T = Library.Theme
		local text
		if DD.Multi then
			local parts = {}
			for _, v in ipairs(DD.Values) do if DD.Value[v] then table.insert(parts, tostring(v)) end end
			for v in pairs(DD.Value) do if not table.find(DD.Values, v) then table.insert(parts, tostring(v)) end end
			text = #parts > 0 and table.concat(parts, ", ") or nil
		else
			text = DD.Value ~= nil and tostring(DD.Value) or nil
		end
		Display.Text = text or "None"
		Display.TextColor3 = text and T.Text or T.DimText
	end

	local function OpenHeight()
		local n = 0
		for _, o in ipairs(Options) do if o.Btn.Visible then n += 1 end end
		local rows = math.clamp(n, 1, DD.MaxVisible)
		return top + rows * (S.Opt + 2) - 2 + 4
	end

	function DD:Open()
		open = true
		List_.Visible = true
		Tween(List_, 0.28, { Size = UDim2.new(1, 0, 0, OpenHeight()) })
		Tween(Chevron, 0.28, { Rotation = 180 })
		Tween(BoxStroke, 0.2, { Color = Library.Theme.StrokeLight })
	end

	function DD:Close()
		open = false
		Tween(List_, 0.22, { Size = UDim2.new(1, 0, 0, 0) })
		Tween(Chevron, 0.22, { Rotation = 0 })
		Tween(BoxStroke, 0.2, { Color = Library.Theme.Stroke })
		task.delay(0.22, function() if not open then List_.Visible = false end end)
	end

	local function Pick(v)
		if DD.Multi then
			DD.Value[v] = (not DD.Value[v]) or nil
		else
			if DD.Value == v then
				if DD.AllowNull then DD.Value = nil end
			else
				DD.Value = v
			end
		end
		DisplayText()
		RefreshOptions()
		DD:_Emit(DD.Value)
		if not DD.Multi then DD:Close() end
	end

	local function BuildList()
		for _, o in ipairs(Options) do o.Btn:Destroy() end
		table.clear(Options)
		for i, v in ipairs(DD.Values) do
			local Btn = New("TextButton", {
				Size = UDim2.new(1, 0, 0, S.Opt), LayoutOrder = i, BackgroundTransparency = 1,
				Theme = { BackgroundColor3 = "Element" }, Parent = Scroll, Round(5),
			})
			local Bar = New("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(2, 0),
				Theme = { BackgroundColor3 = "Accent" }, Parent = Btn, Pill(),
			})
			local Text = New("TextLabel", {
				Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -38, 1, 0), Text = tostring(v), FontFace = FONT.Medium,
				TextSize = S.Small + 1, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "SubText" }, Parent = Btn,
			})
			local TickHolder = New("Frame", {
				BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0),
				Size = UDim2.fromOffset(14, 14), Parent = Btn,
			})
			local L1, L2 = BuildCheck(TickHolder, 14, "Accent", 2)
			Btn.MouseEnter:Connect(function() Tween(Btn, 0.12, { BackgroundTransparency = Library.Glass and 0.5 or 0 }) end)
			Btn.MouseLeave:Connect(function() Tween(Btn, 0.12, { BackgroundTransparency = 1 }) end)
			Btn.Activated:Connect(function() Pick(v) end)
			table.insert(Options, { Btn = Btn, Bar = Bar, Text = Text, L1 = L1, L2 = L2, Value = v })
		end
		RefreshOptions()
		if open then Tween(List_, 0.2, { Size = UDim2.new(1, 0, 0, OpenHeight()) }) end
	end

	if SearchBox then
		SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local q = SearchBox.Text:lower()
			for _, o in ipairs(Options) do
				o.Btn.Visible = q == "" or tostring(o.Value):lower():find(q, 1, true) ~= nil
			end
			if open then Tween(List_, 0.15, { Size = UDim2.new(1, 0, 0, OpenHeight()) }) end
		end)
	end

	Box.Activated:Connect(function() if open then DD:Close() else DD:Open() end end)
	Box.MouseEnter:Connect(function() if not open then Tween(BoxStroke, 0.15, { Color = Library.Theme.StrokeLight }) end end)
	Box.MouseLeave:Connect(function() if not open then Tween(BoxStroke, 0.15, { Color = Library.Theme.Stroke }) end end)

	function DD:SetValues(values)
		self.Values = values or {}
		BuildList()
		DisplayText()
		-- static option lists are searchable ("head" finds the target-part dropdown); live player/team lists are not
		local words = { self.Text }
		if not self.SpecialType then
			for _, v in ipairs(self.Values) do table.insert(words, tostring(v)) end
		end
		self.SearchText = table.concat(words, " "):lower()
		return self
	end
	DD.Refresh = DD.SetValues

	function DD:SetValue(val)
		if self.Multi then
			local t = {}
			if type(val) == "table" then
				for k, v in pairs(val) do
					if type(k) == "number" then t[v] = true elseif v then t[k] = true end
				end
			end
			self.Value = t
		else
			if type(val) == "number" and not table.find(self.Values, val) then val = self.Values[val] end
			self.Value = val
		end
		DisplayText()
		RefreshOptions()
		self:_Emit(self.Value)
		return self
	end

	function DD:GetActiveValues()
		if self.Multi then
			local t = {}
			for v in pairs(self.Value) do table.insert(t, v) end
			return t
		end
		return self.Value and 1 or 0
	end

	function DD:SetText(t) self.Text = t return self end

	if info.Default ~= nil then
		local d = info.Default
		if DD.Multi then
			local t = {}
			if type(d) == "table" then
				for k, v in pairs(d) do if type(k) == "number" then t[v] = true elseif v then t[k] = true end end
			elseif type(d) == "number" then
				if DD.Values[d] then t[DD.Values[d]] = true end
			else
				t[d] = true
			end
			DD.Value = t
		else
			if type(d) == "number" and DD.Values[d] ~= nil and not table.find(DD.Values, d) then d = DD.Values[d] end
			DD.Value = d
		end
	end
	DisplayText()
	RefreshOptions()
	DD:SetValues(DD.Values)

	if DD.SpecialType == "Player" then
		local function Update() DD:SetValues(Library:GetPlayersString(info.ExcludeLocal)) end
		Library:Connect(Players.PlayerAdded, Update)
		Library:Connect(Players.PlayerRemoving, function() task.defer(Update) end)
	elseif DD.SpecialType == "Team" then
		Library:Connect(Teams.ChildAdded, function() DD:SetValues(Library:GetTeamsString()) end)
		Library:Connect(Teams.ChildRemoved, function() DD:SetValues(Library:GetTeamsString()) end)
	end

	table.insert(Library.Refreshers, function() DisplayText(); RefreshOptions() end)
	if info.Tooltip then DD:AddTooltip(info.Tooltip) end
	if info.Visible == false then DD:SetVisible(false) end
	Library.Options[idx] = DD
	return DD
end

function Funcs:AddInput(idx, info)
	if type(idx) == "table" then info = idx; idx = info.Flag or info.Text end
	info = info or {}
	local Input = Base({
		Type = "Input", Idx = idx, Value = tostring(info.Default or ""), Numeric = info.Numeric == true, Finished = info.Finished == true,
		Text = info.Text or tostring(idx), Callback = info.Callback, MaxLength = info.MaxLength,
	}, self._Group)
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = self:_Next(),
		Parent = self.Container, List({ Padding = UDim.new(0, 6) }),
	})
	if Input.Text ~= "" then
		New("TextLabel", {
			Size = UDim2.new(1, 0, 0, S.Txt + 2), Text = Input.Text, FontFace = FONT.Medium, TextSize = S.Txt, LayoutOrder = 1,
			TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Holder,
		})
	end
	local Box = New("Frame", { Size = UDim2.new(1, 0, 0, S.Box), LayoutOrder = 2, Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Holder, Round(6) })
	local BoxStroke = Stroke(Box, "Stroke")
	local TB = New("TextBox", {
		Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -22, 1, 0), Text = Input.Value, PlaceholderText = info.Placeholder or "",
		FontFace = FONT.Medium, TextSize = S.Small + 1, ClipsDescendants = true, ClearTextOnFocus = info.ClearTextOnFocus == true,
		Theme = { TextColor3 = "Text", PlaceholderColor3 = "DimText" }, Parent = Box,
	})
	local Underline = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(0, 0, 0, 2),
		Theme = { BackgroundColor3 = "Accent" }, Parent = Box, Pill(),
	})
	Input.Holder, Input.TextBox = Holder, TB

	function Input:SetValue(text)
		text = tostring(text or "")
		if self.MaxLength and #text > self.MaxLength then text = text:sub(1, self.MaxLength) end
		if self.Numeric and text ~= "" and not tonumber(text) then return self end
		self.Value = text
		if TB.Text ~= text then TB.Text = text end
		self:_Emit(text)
		return self
	end

	local lastValid = Input.Value
	TB:GetPropertyChangedSignal("Text"):Connect(function()
		local text = TB.Text
		if Input.MaxLength and #text > Input.MaxLength then TB.Text = text:sub(1, Input.MaxLength); return end
		if Input.Numeric and text ~= "" and text ~= "-" and text ~= "." and text ~= "-." and not tonumber(text) then
			TB.Text = lastValid
			return
		end
		lastValid = text
		if not Input.Finished and text ~= Input.Value then Input:SetValue(text) end
	end)
	TB.Focused:Connect(function()
		Tween(BoxStroke, 0.2, { Color = Library.Theme.AccentDark })
		Tween(Underline, 0.3, { Size = UDim2.new(1, -14, 0, 2) })
	end)
	TB.FocusLost:Connect(function(enter)
		Tween(BoxStroke, 0.2, { Color = Library.Theme.Stroke })
		Tween(Underline, 0.25, { Size = UDim2.new(0, 0, 0, 2) })
		if Input.Finished and enter then Input:SetValue(TB.Text) end
	end)

	Input.SearchText = Input.Text:lower()
	if info.Tooltip then Input:AddTooltip(info.Tooltip) end
	if info.Visible == false then Input:SetVisible(false) end
	Library.Options[idx] = Input
	return Input
end
Funcs.AddTextbox = Funcs.AddInput

function Funcs:AddButton(a, b)
	local info = type(a) == "table" and a or { Text = a, Func = b }
	local group = self._Group
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, S.Btn), LayoutOrder = self:_Next(), Parent = self.Container,
		List({ FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }),
	})
	local Button = Base({ Type = "Button", Text = info.Text }, group)
	Button.Holder = Holder
	local subs, texts = {}, {}

	local function Relayout()
		local n = #subs
		for _, s in ipairs(subs) do s.Size = UDim2.new(1 / n, -math.floor(6 * (n - 1) / n + 0.5), 1, 0) end
		Button.SearchText = table.concat(texts, " "):lower()
	end

	local function Make(inf)
		local text = inf.Text or "Button"
		local fn = inf.Func or inf.Callback
		local Btn = New("TextButton", {
			Size = UDim2.fromScale(1, 1), LayoutOrder = #subs + 1, BackgroundTransparency = 0, ClipsDescendants = true,
			Theme = { BackgroundColor3 = "Element" }, Glass = "Element", Parent = Holder, Round(6),
		})
		local BtnStroke = Stroke(Btn, "Stroke")
		local Scale = New("UIScale", { Parent = Btn })
		local Lbl = New("TextLabel", {
			Size = UDim2.fromScale(1, 1), Text = text, FontFace = FONT.Medium, TextSize = S.Txt, TextXAlignment = Enums.Center,
			TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Theme = { TextColor3 = "Text" }, Parent = Btn,
		})
		local armed, armedAt = false, 0
		local function Reset()
			armed = false
			Lbl.Text = text
			Tween(Lbl, 0.15, { TextColor3 = Library.Theme.Text })
		end
		Btn.MouseEnter:Connect(function()
			Tween(Btn, 0.15, { BackgroundColor3 = Library.Theme.Hover })
			Tween(BtnStroke, 0.15, { Color = Library.Theme.StrokeLight })
		end)
		Btn.MouseLeave:Connect(function()
			Tween(Btn, 0.15, { BackgroundColor3 = Library.Theme.Element })
			Tween(BtnStroke, 0.15, { Color = Library.Theme.Stroke })
			Tween(Scale, 0.15, { Scale = 1 })
		end)
		Btn.MouseButton1Down:Connect(function() Tween(Scale, 0.1, { Scale = 0.97 }) end)
		Btn.MouseButton1Up:Connect(function() Tween(Scale, 0.25, { Scale = 1 }, Enum.EasingStyle.Back) end)
		Btn.Activated:Connect(function(input)
			-- ripple from where it was pressed
			local ap, as = Btn.AbsolutePosition, Btn.AbsoluteSize
			local sc = math.max(Library.Scale, 0.01)
			local p = input and input.Position
			local x = p and (p.X - ap.X) / sc or as.X / 2 / sc
			local y = p and (p.Y - ap.Y) / sc or as.Y / 2 / sc
			if x < 0 or x > as.X / sc then x = as.X / 2 / sc end
			if y < 0 or y > as.Y / sc then y = as.Y / 2 / sc end
			local size = math.max(as.X, as.Y) / sc * 2.2
			local r = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(0, 0),
				BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0.82, ZIndex = 2, Parent = Btn, Pill(),
			})
			Tween(r, 0.55, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
			task.delay(0.56, function() r:Destroy() end)

			if inf.DoubleClick then
				if armed and os.clock() - armedAt < 2 then
					Reset()
					Library:SafeCallback(fn)
				else
					armed, armedAt = true, os.clock()
					Lbl.Text = "Are you sure?"
					Tween(Lbl, 0.15, { TextColor3 = Library.Theme.Accent })
					local stamp = armedAt
					task.delay(2, function() if armed and armedAt == stamp then Reset() end end)
				end
			else
				Library:SafeCallback(fn)
			end
		end)
		if inf.Tooltip then Library:AddTooltip(Btn, inf.Tooltip) end
		table.insert(subs, Btn)
		table.insert(texts, text)
		Relayout()
		return Btn
	end

	Make(info)
	function Button:AddButton(x, y)
		local inf = type(x) == "table" and x or { Text = x, Func = y }
		Make(inf)
		return self
	end
	function Button:SetText(t)
		local lbl = subs[1] and subs[1]:FindFirstChildOfClass("TextLabel")
		if lbl then lbl.Text = t end
		texts[1] = t
		Relayout()
		return self
	end
	if info.Visible == false then Button:SetVisible(false) end
	return Button
end

function Funcs:AddLabel(a, wrap)
	local info = type(a) == "table" and a or { Text = a, DoesWrap = wrap }
	local text = tostring(info.Text or "")
	local Label = Base({ Type = "Label", Text = text }, self._Group)
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = self:_Next(),
		Parent = self.Container, List({ Padding = UDim.new(0, 6) }),
	})
	local Row, Txt
	if info.DoesWrap then
		Row = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 0, Parent = Holder })
		Txt = New("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Text = text, TextWrapped = true, RichText = true,
			FontFace = FONT.Regular, TextSize = S.Small + 1, Theme = { TextColor3 = "SubText" }, Parent = Row,
		})
	else
		Row = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, S.Row), LayoutOrder = 0, Parent = Holder,
			List({ FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8) }),
		})
		Txt = New("TextLabel", {
			Size = UDim2.new(0, 0, 1, 0), Text = text, RichText = true, FontFace = FONT.Medium, TextSize = S.Txt,
			TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1, Theme = { TextColor3 = "SubText" }, Parent = Row, Flex(),
		})
	end
	local Addons = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(0, 0, info.DoesWrap and 0 or 1, info.DoesWrap and S.Row or 0), AutomaticSize = Enums.X,
		LayoutOrder = 2, AnchorPoint = info.DoesWrap and Vector2.new(1, 0) or Vector2.zero,
		Position = info.DoesWrap and UDim2.new(1, 0, 0, 0) or UDim2.new(), Parent = Row,
		List({ FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6) }),
	})
	Label.Holder, Label.TextLabel, Label.AddonsFrame, Label._Page = Holder, Txt, Addons, self.Page
	MakeAddonHost(Label, Holder)
	function Label:SetText(t)
		self.Text = tostring(t)
		Txt.Text = self.Text
		self.SearchText = self.Text:lower()
		return self
	end
	Label.SearchText = text:lower()
	return Label
end

function Funcs:AddDivider(text)
	local Holder = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, text and 16 or 6), LayoutOrder = self:_Next(), Parent = self.Container })
	local div = Base({ Type = "Divider", Holder = Holder }, self._Group)
	div.Holder = Holder
	local fade = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
	if text then
		New("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), AutomaticSize = Enums.X, Size = UDim2.fromOffset(0, 16),
			Text = tostring(text):upper(), FontFace = FONT.Semi, TextSize = 10, Theme = { TextColor3 = "DimText" }, Parent = Holder, Pad(0, 8, 0, 8),
		})
		for _, side in ipairs({ 0, 1 }) do
			New("Frame", {
				AnchorPoint = Vector2.new(side, 0.5), Position = UDim2.fromScale(side, 0.5), Size = UDim2.new(0.5, -42, 0, 1),
				Theme = { BackgroundColor3 = "StrokeLight" }, Parent = Holder,
				New("UIGradient", { Transparency = NumberSequence.new(side == 0 and 1 or 0, side == 0 and 0 or 1) }),
			})
		end
	else
		New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1),
			Theme = { BackgroundColor3 = "StrokeLight" }, Parent = Holder, New("UIGradient", { Transparency = fade }),
		})
	end
	div.SearchText = text and tostring(text):lower() or nil
	return div
end

function Funcs:AddBlank(size)
	return New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, size or 6), LayoutOrder = self:_Next(), Parent = self.Container })
end

function Funcs:AddDependencyBox()
	local Holder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = self:_Next(),
		Parent = self.Container, List({ Padding = UDim.new(0, S.Gap) }),
	})
	local Box = NewContainer(Holder, self.Window, self.Tab, self._Group)
	Box.Holder = Box.Container
	Box.Dependencies = {}
	function Box:Update()
		local ok = true
		for _, dep in ipairs(self.Dependencies) do
			local el, want = dep[1], dep[2]
			local v = el.Value
			if el.Type == "Dropdown" and el.Multi then
				if not v[want] then ok = false break end
			elseif v ~= want then
				ok = false
				break
			end
		end
		Holder.Visible = ok
	end
	function Box:SetupDependencies(deps)
		self.Dependencies = deps or {}
		for _, dep in ipairs(self.Dependencies) do
			if dep[1] and dep[1]._Internal then table.insert(dep[1]._Internal, function() Box:Update() end) end
		end
		self:Update()
		return self
	end
	return Box
end

-- =====================================================================
-- groupbox / tabbox
-- =====================================================================
local function MakeGroupbox(window, tab, column, title)
	local Box = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Theme = { BackgroundColor3 = "Panel" }, Glass = "Panel", LayoutOrder = #tab.Groupboxes + 1,
		Parent = column, Round(8), List({ Padding = UDim.new(0, 0) }),
	})
	Stroke(Box, "Stroke")
	local Header = New("TextButton", { Size = UDim2.new(1, 0, 0, S.Tab), LayoutOrder = 1, Parent = Box })
	New("TextLabel", {
		Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -42, 1, 0), Text = title or "Groupbox", FontFace = FONT.Semi,
		TextSize = S.Txt, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Header,
	})
	local Chev = BuildChevron(Header, 10, "DimText")
	Chev.Position = UDim2.new(1, -12, 0.5, 0)
	local Line = New("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2, Theme = { BackgroundColor3 = "Stroke" }, Parent = Box })
	local Content = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 3, Parent = Box,
		Pad(10, 12, 12, 12), List({ Padding = UDim.new(0, S.Gap) }),
	})
	local GB = NewContainer(Content, window, tab, nil)
	GB._Group = GB
	GB._Elements = {}
	GB.Holder = Box
	GB.Title = title or ""
	local collapsed = false
	Header.Activated:Connect(function()
		collapsed = not collapsed
		Content.Visible = not collapsed
		Line.Visible = not collapsed
		Tween(Chev, 0.25, { Rotation = collapsed and -90 or 0 })
	end)
	table.insert(tab.Groupboxes, GB)
	return GB
end

local function MakeTabbox(window, tab, column)
	local Box = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Theme = { BackgroundColor3 = "Panel" }, Glass = "Panel", LayoutOrder = #tab.Groupboxes + 1,
		Parent = column, Round(8), List({ Padding = UDim.new(0, 0) }),
	})
	Stroke(Box, "Stroke")
	local Header = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, S.Tab), LayoutOrder = 1, Parent = Box })
	local Buttons = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = Header,
		List({ FillDirection = Enum.FillDirection.Horizontal }),
	})
	local Under = New("Frame", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 2), ZIndex = 2,
		BackgroundTransparency = 1, Parent = Header,
	})
	local UnderBar = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0), Size = UDim2.new(1, -24, 1, 0),
		Theme = { BackgroundColor3 = "Accent" }, Parent = Under, Pill(),
	})
	New("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2, Theme = { BackgroundColor3 = "Stroke" }, Parent = Box })
	local Body = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 3, Parent = Box })

	local TB = { Tabs = {}, Holder = Box, _Elements = {}, Title = nil }
	local function Layout(active)
		local n = #TB.Tabs
		for i, t in ipairs(TB.Tabs) do
			t._Button.Size = UDim2.new(1 / n, 0, 1, 0)
			if t == active then
				Tween(Under, 0.3, { Position = UDim2.new((i - 1) / n, 0, 1, 0), Size = UDim2.new(1 / n, 0, 0, 2) })
			end
		end
	end
	function TB:AddTab(name)
		local Btn = New("TextButton", {
			Size = UDim2.fromScale(1, 1), LayoutOrder = #self.Tabs + 1, Text = name, FontFace = FONT.Semi, TextSize = S.Txt,
			Theme = { TextColor3 = "DimText" }, Parent = Buttons,
		})
		local Content = New("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, Visible = false, Parent = Body,
			Pad(10, 12, 12, 12), List({ Padding = UDim.new(0, S.Gap) }),
		})
		local C = NewContainer(Content, window, tab, TB)
		C.Name, C._Button, C.Holder = name, Btn, Content
		function C:Show()
			for _, t in ipairs(TB.Tabs) do
				t.Container.Visible = t == C
				Tween(t._Button, 0.2, { TextColor3 = t == C and Library.Theme.Text or Library.Theme.DimText })
			end
			TB.Active = C
			Layout(C)
		end
		Btn.Activated:Connect(function() C:Show() end)
		table.insert(self.Tabs, C)
		if #self.Tabs == 1 then C:Show() else Layout(self.Active) end
		return C
	end
	table.insert(Library.Refreshers, function()
		for _, t in ipairs(TB.Tabs) do t._Button.TextColor3 = t == TB.Active and Library.Theme.Text or Library.Theme.DimText end
	end)
	table.insert(tab.Groupboxes, TB)
	return TB
end

-- =====================================================================
-- save manager (Linoria-compatible config format)
-- =====================================================================
local SaveManager = { Ignore = {} }
Library.SaveManager = SaveManager

local function IsInternal(idx)
	return type(idx) == "string" and (idx:sub(1, 4) == "Zomb" or idx == "MenuKeybind")
end

SaveManager.Parsers = {
	Toggle = {
		Save = function(idx, o) return { type = "Toggle", idx = idx, value = o.Value } end,
		Load = function(idx, d) local o = Library.Toggles[idx]; if o then o:SetValue(d.value) end end,
	},
	Slider = {
		Save = function(idx, o) return { type = "Slider", idx = idx, value = tostring(o.Value) } end,
		Load = function(idx, d) local o = Library.Options[idx]; if o then o:SetValue(d.value) end end,
	},
	Dropdown = {
		Save = function(idx, o) return { type = "Dropdown", idx = idx, value = o.Value, mutli = o.Multi } end,
		Load = function(idx, d) local o = Library.Options[idx]; if o then o:SetValue(d.value) end end,
	},
	ColorPicker = {
		Save = function(idx, o) return { type = "ColorPicker", idx = idx, value = o.Value:ToHex(), transparency = o.Transparency } end,
		Load = function(idx, d)
			local o = Library.Options[idx]
			if o then o:SetValueRGB(Color3.fromHex(d.value), d.transparency) end
		end,
	},
	KeyPicker = {
		Save = function(idx, o) return { type = "KeyPicker", idx = idx, mode = o.Mode, key = o.Value } end,
		Load = function(idx, d) local o = Library.Options[idx]; if o then o:SetValue({ d.key, d.mode }) end end,
	},
	Input = {
		Save = function(idx, o) return { type = "Input", idx = idx, text = o.Value } end,
		Load = function(idx, d) local o = Library.Options[idx]; if o and type(d.text) == "string" then o:SetValue(d.text) end end,
	},
}

function SaveManager:SetIgnoreIndexes(list)
	for _, idx in ipairs(list) do self.Ignore[idx] = true end
end

function SaveManager:SetFolder(folder)
	Library.Folder = folder:find("^zomb%.cc") and folder or ("zomb.cc/" .. folder)
	self:BuildFolderTree()
end

function SaveManager:BuildFolderTree()
	EnsureFolder(Library.Folder .. "/configs")
end

function SaveManager:Serialize(filter)
	local data = { objects = {}, place = game.PlaceId, version = Library.Version }
	for idx, t in pairs(Library.Toggles) do
		if filter(idx) then table.insert(data.objects, self.Parsers.Toggle.Save(idx, t)) end
	end
	for idx, o in pairs(Library.Options) do
		local p = self.Parsers[o.Type]
		if p and filter(idx) then table.insert(data.objects, p.Save(idx, o)) end
	end
	return HttpService:JSONEncode(data)
end

function SaveManager:Apply(json, filter)
	local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
	if not ok or type(data) ~= "table" or type(data.objects) ~= "table" then return false, "invalid config data" end
	for _, obj in ipairs(data.objects) do
		local p = self.Parsers[obj.type]
		if p and filter(obj.idx) then pcall(p.Load, obj.idx, obj) end
	end
	return true
end

local function ConfigFilter(idx) return not IsInternal(idx) and not SaveManager.Ignore[idx] end

function SaveManager:Path(name) return Library.Folder .. "/configs/" .. name .. ".json" end

function SaveManager:Save(name)
	if not FS then return false, "no file system" end
	if not name or name:gsub("%s", "") == "" then return false, "no config name" end
	self:BuildFolderTree()
	local ok, err = pcall(writefile, self:Path(name), self:Serialize(ConfigFilter))
	return ok, err
end

function SaveManager:Load(name)
	if not FS then return false, "no file system" end
	if not name or not isfile(self:Path(name)) then return false, "config not found" end
	return self:Apply(readfile(self:Path(name)), ConfigFilter)
end

function SaveManager:Delete(name)
	if not (FS and delfile) then return false, "delfile unavailable" end
	if not name or not isfile(self:Path(name)) then return false, "config not found" end
	return pcall(delfile, self:Path(name))
end

function SaveManager:Exists(name) return FS and name and isfile(self:Path(name)) or false end

function SaveManager:RefreshConfigList()
	if not (FS and listfiles) then return {} end
	self:BuildFolderTree()
	local out = {}
	local ok, files = pcall(listfiles, Library.Folder .. "/configs")
	if not ok then return out end
	for _, f in ipairs(files) do
		local name = f:gsub("\\", "/"):match("([^/]+)%.json$")
		if name then table.insert(out, name) end
	end
	table.sort(out)
	return out
end

function SaveManager:GetAutoload()
	if not FS then return nil end
	local p = Library.Folder .. "/configs/autoload.txt"
	if isfile(p) then
		local n = readfile(p)
		if n ~= "" then return n end
	end
	return nil
end

function SaveManager:SetAutoload(name)
	if not FS then return end
	self:BuildFolderTree()
	writefile(Library.Folder .. "/configs/autoload.txt", name or "")
end

function SaveManager:LoadAutoloadConfig()
	if self._Autoloaded then return end
	self._Autoloaded = true
	local name = self:GetAutoload()
	if name and self:Exists(name) then
		local ok = self:Load(name)
		if ok then Library:Notify({ Title = "Config loaded", Content = 'Autoloaded "' .. name .. '"', Duration = 3 }) end
	end
end

-- drop-in shims so Linoria scripts that wire up SaveManager / ThemeManager keep working
function SaveManager:SetLibrary() end
function SaveManager:IgnoreThemeSettings() end
function SaveManager:BuildConfigSection()
	if Library.Window then Library.Window:AddSettingsTab() end
end
-- =====================================================================
-- theme manager: named theme files (colours + glass) shared by every hub using the lib
-- =====================================================================
local ThemeManager = {
	Folder = "zomb.cc/themes",
	-- Linoria shims
	SetLibrary = function() end,
	ApplyToTab = function() end,
	ApplyToGroupbox = function() end,
}
Library.ThemeManager = ThemeManager

local function CleanName(s)
	return (tostring(s or ""):gsub("[^%w%s%-_%.]", ""):gsub("^%s+", ""):gsub("%s+$", ""))
end
Library.CleanName = CleanName

function ThemeManager:SetFolder(folder) self.Folder = folder end
function ThemeManager:Path(name) return self.Folder .. "/" .. name .. ".json" end
function ThemeManager:Exists(name) return FS and name ~= nil and isfile(self:Path(name)) or false end

function ThemeManager:Capture()
	local T = Library.Theme
	return {
		v = 2, accent = T.Accent:ToHex(), base = T.Base:ToHex(), text = T.Text:ToHex(),
		glass = { enabled = Library.Glass, opacity = Library.GlassOpacity, blur = Library.GlassBlur },
	}
end

function ThemeManager:Apply(data)
	if type(data) ~= "table" then return false, "invalid theme" end
	local ok, accent, base, text = pcall(function()
		return Color3.fromHex(data.accent), Color3.fromHex(data.base), Color3.fromHex(data.text)
	end)
	if not ok then return false, "invalid colours" end
	if self._ApplyHook then
		-- settings tab is up: route through it so the pickers / glass controls show the loaded values
		self._ApplyHook(accent, base, text, data.glass)
	else
		Library:SetTheme({ Accent = accent, Base = base, Text = text })
		if type(data.glass) == "table" then Library:SetGlass(data.glass.enabled, data.glass.opacity, data.glass.blur) end
	end
	return true
end

function ThemeManager:Save(name)
	if not FS then return false, "no file system" end
	name = CleanName(name)
	if name == "" then return false, "no theme name" end
	EnsureFolder(self.Folder)
	return pcall(writefile, self:Path(name), HttpService:JSONEncode(self:Capture()))
end

function ThemeManager:Load(name)
	if not self:Exists(name) then return false, "theme not found" end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, readfile(self:Path(name)))
	if not ok then return false, "theme file is corrupt" end
	return self:Apply(data)
end

function ThemeManager:Delete(name)
	if not (FS and delfile) then return false, "delfile unavailable" end
	if not self:Exists(name) then return false, "theme not found" end
	if self:GetDefault() == name then self:SetDefault(nil) end
	return pcall(delfile, self:Path(name))
end

function ThemeManager:List()
	if not (FS and listfiles) then return {} end
	EnsureFolder(self.Folder)
	local out = {}
	local ok, files = pcall(listfiles, self.Folder)
	if not ok then return out end
	for _, f in ipairs(files) do
		local n = f:gsub("\\", "/"):match("([^/]+)%.json$")
		if n then table.insert(out, n) end
	end
	table.sort(out, function(a, b) return a:lower() < b:lower() end)
	return out
end

function ThemeManager:GetDefault()
	if not FS then return nil end
	local p = self.Folder .. "/default.txt"
	if isfile(p) then
		local n = readfile(p)
		if n ~= "" then return n end
	end
	return nil
end

function ThemeManager:SetDefault(name)
	if not FS then return end
	EnsureFolder(self.Folder)
	writefile(self.Folder .. "/default.txt", name or "")
end

function ThemeManager:LoadDefault()
	local d = self:GetDefault()
	if d and self:Exists(d) then return self:Load(d) end
	return false
end

-- interface preferences (menu bind, scale, toggles, theme, positions) live outside configs
function Library:_SavePrefs()
	if not FS or not self._PrefsReady then return end
	if self._PrefsQueued then return end
	self._PrefsQueued = true
	task.delay(0.4, function()
		self._PrefsQueued = false
		if self.Unloaded then return end
		local data = HttpService:JSONDecode(SaveManager:Serialize(IsInternal))
		local T = self.Theme
		data.theme = {
			v = 3, accent = T.Accent:ToHex(), base = T.Base:ToHex(), text = T.Text:ToHex(),
			glass = { enabled = self.Glass, opacity = self.GlassOpacity, blur = self.GlassBlur },
		}
		if self.Root then
			local p = self.Root.Position
			data.window = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset, self.WindowSize.X, self.WindowSize.Y }
		end
		if self.MobileButton then
			local p = self.MobileButton.Position
			data.mobileButton = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
		end
		pcall(function()
			EnsureFolder(self.Folder)
			writefile(self.Folder .. "/interface.json", HttpService:JSONEncode(data))
		end)
	end)
end

function Library:_ReadPrefs()
	if not FS then return nil end
	local p = self.Folder .. "/interface.json"
	if not isfile(p) then return nil end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, readfile(p))
	return ok and data or nil
end

-- =====================================================================
-- theme application
-- =====================================================================
function Library:UpdateTheme()
	self:_DeriveTheme()
	for inst, map in pairs(self.Registry) do
		if inst.Parent == nil then
			self.Registry[inst] = nil
		else
			for prop, key in pairs(map) do
				pcall(function() inst[prop] = self:_Resolve(key) end)
			end
		end
	end
	for _, fn in ipairs(self.Refreshers) do pcall(fn) end
	self:_SavePrefs()
end

function Library:SetTheme(t)
	for k, v in pairs(t) do self.Theme[k] = v end
	self:UpdateTheme()
end

-- =====================================================================
-- scale + window layout
-- =====================================================================
function Library:_UpdateScale()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	local inset = GuiService:GetGuiInset()
	local availX, availY = vp.X - 20, vp.Y - inset.Y - 20
	local W, H = self.WindowSize.X, self.WindowSize.Y
	local base = self.BaseSize or self.WindowSize
	local fit = math.min(availX / base.X, availY / base.Y)
	local s = self.IsMobile and math.clamp(fit, 0.8, 1) or math.clamp(fit, 0.55, 1)
	s = s * self.UserScale
	self.Scale = s
	for _, sc in ipairs(self.OverlayScales) do
		if sc.Parent then sc.Scale = s end
	end
	if self.Root then
		if self.Open and not self._Animating then self.RootScale.Scale = s end
		local w = math.floor(math.min(W, availX / s))
		local h = math.floor(math.min(H, availY / s))
		self.Root.Size = UDim2.fromOffset(w, h)
		if self.Window then self.Window:_UpdateLayout() end
	end
end

function Library:Toggle(state)
	if not self.Root then return end
	if state == nil then state = not self.Open end
	if state == self.Open and self.Root.Visible == state then return end
	self.Open = state
	self.Toggled = state
	local s = self.Scale
	self._Animating = true
	local token = (self._ToggleToken or 0) + 1
	self._ToggleToken = token
	if state then
		self.Root.Visible = true
		self.Cover.Visible = true
		self.Cover.BackgroundTransparency = self:_GlassT("Window")
		self.RootScale.Scale = s * 0.94
		Tween(self.RootScale, 0.38, { Scale = s }, Enum.EasingStyle.Quint)
		Tween(self.Cover, 0.32, { BackgroundTransparency = 1 })
		Tween(self.ShadowImg, 0.5, { ImageTransparency = self.Glass and 1 or 0.35 })
		task.delay(0.33, function()
			if self._ToggleToken == token then self.Cover.Visible = false; self._Animating = false end
		end)
	else
		self.Cover.Visible = true
		Tween(self.Cover, 0.18, { BackgroundTransparency = self:_GlassT("Window") })
		Tween(self.RootScale, 0.2, { Scale = s * 0.95 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		Tween(self.ShadowImg, 0.18, { ImageTransparency = 1 })
		task.delay(0.2, function()
			if self._ToggleToken == token then self.Root.Visible = false; self._Animating = false end
		end)
		self:_HideTip()
		self:_CloseModeMenu()
		if self._ForcedCursor then
			self._ForcedCursor = false
			UserInputService.MouseIconEnabled = false
		end
	end
	if self.MobileButton then
		Tween(self.MobileStroke, 0.25, { Transparency = state and 0 or 0.6 })
	end
	self:_UpdateBlur()
end

-- =====================================================================
-- glass mode
-- =====================================================================
-- Glass look = see-through surfaces + frosted sheen + bright edge, and "acrylic" blur ONLY behind the ui:
-- a DepthOfFieldEffect that blurs nothing in the world (FarIntensity 0) plus a near-invisible Glass-material
-- part parked 0.001 studs in front of the camera, sized every frame to each panel's screen rectangle.
-- Glass material renders what's behind it through the DoF pass, so only those rectangles come out blurred.
local Lighting = Svc("Lighting")
local Acrylic = { Entries = {}, Saved = {}, On = false }

function Library:_AcrylicTrack(frame, isVisible)
	local part = Instance.new("Part")
	part.Name = RandName()
	part.Color = Color3.new(0, 0, 0)
	part.Material = Enum.Material.Glass
	part.Size = Vector3.new(1, 1, 0)
	part.Anchored, part.CanCollide, part.CanQuery, part.CanTouch, part.CastShadow = true, false, false, false, false
	part.Transparency = 1
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Brick
	mesh.Offset = Vector3.new(0, 0, -1e-6)
	mesh.Parent = part
	table.insert(Acrylic.Entries, { Frame = frame, Part = part, Mesh = mesh, Visible = isVisible })
end

local function AcrylicPlace(e, cam)
	local ap, as = e.Frame.AbsolutePosition, e.Frame.AbsoluteSize
	-- pull in a few px so the rectangular blur never peeks past the rounded corners
	local inset = 4 * Library.Scale
	local tl = ap + Vector2.new(inset, inset)
	local br = ap + as - Vector2.new(inset, inset)
	local function World(p)
		local ray = cam:ScreenPointToRay(p.X, p.Y)
		return ray.Origin + ray.Direction * 0.001
	end
	local a, b, c = World(tl), World(Vector2.new(br.X, tl.Y)), World(br)
	local cf = cam.CFrame
	e.Part.CFrame = CFrame.fromMatrix((a + c) / 2, cf.XVector, cf.YVector, cf.ZVector)
	e.Mesh.Scale = Vector3.new((b - a).Magnitude, (b - c).Magnitude, 0)
end

local AcrylicStep = "zomb_acrylic_" .. RandName()
function Library:_UpdateBlur()
	local want = self.Glass and self.GlassBlur and not self.Unloaded
	if want == Acrylic.On then return end
	Acrylic.On = want
	if want then
		if not Acrylic.DoF then
			Acrylic.DoF = Instance.new("DepthOfFieldEffect")
			Acrylic.DoF.Name = RandName()
			Acrylic.DoF.FarIntensity = 0
			Acrylic.DoF.InFocusRadius = 0.1
			Acrylic.DoF.NearIntensity = 1
		end
		-- the game's own depth-of-field would fight ours; park it and restore it later
		table.clear(Acrylic.Saved)
		local cam = workspace.CurrentCamera
		for _, holder in ipairs({ Lighting, cam }) do
			if holder then
				for _, fx in ipairs(holder:GetChildren()) do
					if fx:IsA("DepthOfFieldEffect") and fx ~= Acrylic.DoF then
						Acrylic.Saved[fx] = fx.Enabled
						fx.Enabled = false
					end
				end
			end
		end
		Acrylic.DoF.Parent = Lighting
		RunService:BindToRenderStep(AcrylicStep, Enum.RenderPriority.Camera.Value + 1, function()
			local c = workspace.CurrentCamera
			if not c then return end
			for _, e in ipairs(Acrylic.Entries) do
				local show = e.Visible() and e.Frame.AbsoluteSize.X > 8
				if show then
					if e.Part.Parent ~= c then e.Part.Parent = c end
					AcrylicPlace(e, c)
				end
				e.Part.Transparency = show and 0.98 or 1
			end
		end)
	else
		pcall(function() RunService:UnbindFromRenderStep(AcrylicStep) end)
		if Acrylic.DoF then Acrylic.DoF.Parent = nil end
		for fx, enabled in pairs(Acrylic.Saved) do pcall(function() fx.Enabled = enabled end) end
		table.clear(Acrylic.Saved)
		for _, e in ipairs(Acrylic.Entries) do e.Part.Transparency = 1 end
	end
end

function Library:_DestroyAcrylic()
	Acrylic.On = true
	self.Unloaded = true
	self:_UpdateBlur()
	for _, e in ipairs(Acrylic.Entries) do pcall(function() e.Part:Destroy() end) end
	if Acrylic.DoF then pcall(function() Acrylic.DoF:Destroy() end) end
end

function Library:_ApplyGlass()
	for inst, layer in pairs(self.GlassReg) do
		if inst.Parent == nil then
			self.GlassReg[inst] = nil
		else
			inst.BackgroundTransparency = self:_GlassT(layer)
		end
	end
	if self.Sheen then self.Sheen.Visible = self.Glass end
	if self.MainStroke then
		self.MainStroke.Color = self.Glass and self.Theme.Text or self.Theme.Stroke
		self.MainStroke.Transparency = self.Glass and 0.82 or 0
	end
	if self.ShadowImg and self.Open then self.ShadowImg.ImageTransparency = self.Glass and 1 or 0.35 end
	self:_UpdateBlur()
end

function Library:SetGlass(enabled, opacity, blur)
	self.Glass = enabled == true
	if opacity ~= nil then self.GlassOpacity = math.clamp(opacity, 0.05, 1) end
	if blur ~= nil then self.GlassBlur = blur == true end
	self:_ApplyGlass()
end
table.insert(Library.Refreshers, function() Library:_ApplyGlass() end)

-- =====================================================================
-- mobile toggle button
-- =====================================================================
function Library:_BuildMobileButton()
	local size = 52
	local Btn = New("ImageButton", {
		Size = UDim2.fromOffset(size, size), Position = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 0, ZIndex = 16,
		Visible = false, Theme = { BackgroundColor3 = "Background" }, Glass = "Float", Parent = ScreenGui, Round(15),
	})
	self.MobileStroke = Stroke(Btn, "Accent", 1.5, 0.6)
	-- text mark instead of a logo: first letter + the green suffix, e.g. "z.cc"
	local Mark = New("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
		RichText = true, FontFace = FONT.Heavy, TextSize = 16, TextXAlignment = Enums.Center, ZIndex = 17,
		Theme = { TextColor3 = "Text" }, Parent = Btn,
	})
	local function RenderMark()
		local t = self._Title or "zomb.cc"
		local a, b = t:match("^(.-)(%.[^%.]+)$")
		Mark.Text = (a and a ~= "") and self:BrandText(a:sub(1, 1) .. b) or Escape(t:sub(1, 1))
	end
	RenderMark()
	table.insert(self.Refreshers, RenderMark)
	local IconScale = New("UIScale", { Parent = Mark })
	MakeDraggable(Btn, Btn, function() self:_SavePrefs() end, function()
		IconScale.Scale = 0.8
		Tween(IconScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back)
		self:Toggle()
	end)
	self.MobileButton = Btn
end

function Library:SetMobileButton(v)
	-- touch players have no keyboard to bring the menu back, so the button can't be turned off for them
	if self.MobileButton then self.MobileButton.Visible = v == true or self.IsMobile end
end

-- =====================================================================
-- loading screen (minimal: dim backdrop, wordmark, one thin progress line)
-- =====================================================================
function Library:_RunLoader(opts, title, onDone)
	opts = type(opts) == "table" and opts or {}
	local duration = opts.Duration or 1.2
	local T = self.Theme

	local gui = New("ScreenGui", {
		Name = RandName(), IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10001,
	})
	ParentGui(gui)
	self.LoaderGui = gui

	local Back = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.Background, BackgroundTransparency = 1, Parent = gui })
	local Center = New("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(280, 70),
		BackgroundTransparency = 1, GroupTransparency = 1, Parent = gui,
	})
	local vp = workspace.CurrentCamera.ViewportSize
	New("UIScale", { Scale = math.clamp(vp.Y / 560, 0.7, 1.1), Parent = Center })
	New("TextLabel", {
		Size = UDim2.new(1, 0, 0, 40), Text = self:BrandText(title), RichText = true, FontFace = FONT.Bold, TextSize = 30,
		TextXAlignment = Enums.Center, TextColor3 = T.Text, Parent = Center,
	})
	local Bar = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 52), Size = UDim2.fromOffset(150, 2),
		BackgroundColor3 = T.Element, Parent = Center, Pill(),
	})
	-- the fill uses the text colour: the default accent is too dark to read against the backdrop
	local Fill = New("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = T.Text, Parent = Bar, Pill() })

	local finished = false
	task.spawn(function()
		local ok, err = pcall(function()
			Tween(Back, 0.3, { BackgroundTransparency = 0.15 })
			Tween(Center, 0.3, { GroupTransparency = 0 })
			Tween(Fill, duration, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			task.wait(duration + 0.1)
			Tween(Center, 0.25, { GroupTransparency = 1 })
			Tween(Back, 0.3, { BackgroundTransparency = 1 })
			finished = true
			if onDone then task.spawn(onDone) end
			task.wait(0.32)
		end)
		if not ok then warn("[zomb.cc] loader: " .. tostring(err)) end
		-- whatever happened above, never leave the user without a menu
		if not finished and onDone then task.spawn(onDone) end
		gui:Destroy()
		if self.LoaderGui == gui then self.LoaderGui = nil end
	end)
end

-- =====================================================================
-- window
-- =====================================================================
function Library:CreateWindow(info)
	info = info or {}
	if self.Window then return self.Window end
	if info.Mobile ~= nil then
		self.IsMobile = info.Mobile == true
		SetSizes(self.IsMobile)
		self:SetNotifySide(self.IsMobile and "Top right" or "Bottom right")
	end
	if info.Folder then SaveManager:SetFolder(info.Folder) end
	if info.MenuKeybind then self.MenuKeyDefault = NormalizeKey(info.MenuKeybind) end
	if info.NotifyOnError == false then self.NotifyOnError = false end

	local title = info.Title or "zomb.cc"
	self._Title = title
	local W = (info.Size and info.Size.X.Offset) or 700
	local H = (info.Size and info.Size.Y.Offset) or 480
	self.WindowSize = Vector2.new(W, H)
	self.BaseSize = Vector2.new(W, H)
	self._StartTime = os.clock()

	local prefs = self:_ReadPrefs()
	-- the remembered look (colours + glass) only counts if it was saved under the current defaults (v3);
	-- older saves are ignored so a defaults change actually shows up
	if prefs and type(prefs.theme) == "table" and prefs.theme.v == 3 then
		pcall(function()
			self.Theme.Accent = Color3.fromHex(prefs.theme.accent)
			self.Theme.Base = Color3.fromHex(prefs.theme.base)
			self.Theme.Text = Color3.fromHex(prefs.theme.text)
			local g = prefs.theme.glass
			if type(g) == "table" then
				self.Glass = g.enabled == true
				self.GlassOpacity = tonumber(g.opacity) or self.GlassOpacity
				self.GlassBlur = g.blur ~= false
			end
			self:UpdateTheme()
		end)
	end
	-- the window always opens at its default size; a resize only lasts for the session

	local Window = { Tabs = {}, Library = self, Title = title, SearchQuery = "" }
	self.Window = Window

	local Root = New("Frame", {
		Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H),
		BackgroundTransparency = 1, Visible = false, ZIndex = 1, Parent = ScreenGui,
	})
	if prefs and type(prefs.window) == "table" and prefs.window[4] then
		local p = prefs.window
		Root.Position = UDim2.new(p[1], p[2], p[3], p[4])
	end
	local RootScale = New("UIScale", { Parent = Root })
	self.Root, self.RootScale = Root, RootScale

	self.ShadowImg = New("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 56, 1, 56),
		Image = self.Shadow, ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(46, 46, 50, 50), ZIndex = 0, Parent = Root,
	})
	local Main = New("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 1, Theme = { BackgroundColor3 = "Background" }, Glass = "Window", Parent = Root, Round(10) })
	self.MainStroke = Stroke(Main, "Stroke")
	New("TextButton", { Size = UDim2.fromOffset(0, 0), Modal = true, Parent = Main })

	-- glass sheen: a faint diagonal light catch across the pane, only shown in glass mode
	self.Sheen = New("Frame", {
		Size = UDim2.fromScale(1, 1), ZIndex = 0, BackgroundColor3 = Color3.new(1, 1, 1), Visible = self.Glass, Parent = Main, Round(10),
		New("UIGradient", {
			Rotation = 35,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.86), NumberSequenceKeypoint.new(0.32, 0.95),
				NumberSequenceKeypoint.new(0.55, 0.985), NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	})

	-- glowing top edge
	New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(1, -60, 0, 1), ZIndex = 5,
		Theme = { BackgroundColor3 = "Accent" }, Parent = Main,
		New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.35), NumberSequenceKeypoint.new(1, 1) }) }),
	})

	-- sidebar ---------------------------------------------------------
	-- one rounded background that pokes past the clip edge: left corners stay round, right edge is square,
	-- and nothing overlaps (an overlapping filler would show as a darker strip in glass mode)
	local Sidebar = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0, 184, 1, 0), ClipsDescendants = true, Parent = Main })
	New("Frame", { Size = UDim2.new(1, 20, 1, 0), ZIndex = 0, Theme = { BackgroundColor3 = "Sidebar" }, Glass = "Sidebar", Parent = Sidebar, Round(10) })
	New("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), Theme = { BackgroundColor3 = "Stroke" }, Parent = Sidebar })

	-- wordmark only (no logo image), lined up with the tab labels; collapses to "z.cc" on narrow windows
	local Brand = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, -1, 0, 66), Parent = Sidebar })
	local BrandTitle = New("TextLabel", {
		Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -32, 1, 0), RichText = true, FontFace = FONT.Heavy, TextSize = 20,
		TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Brand,
	})
	local brandCollapsed = false
	local function RenderTitle()
		if brandCollapsed then
			local a, b = title:match("^(.-)(%.[^%.]+)$")
			BrandTitle.Text = (a and a ~= "") and self:BrandText(a:sub(1, 1) .. b) or Escape(title:sub(1, 1))
		else
			BrandTitle.Text = self:BrandText(title)
		end
	end
	RenderTitle()
	table.insert(self.Refreshers, RenderTitle)

	local TabScroll = New("ScrollingFrame", {
		Position = UDim2.fromOffset(10, 70), Size = UDim2.new(1, -21, 1, -70 - 12), ScrollBarThickness = 0, Parent = Sidebar,
	})
	-- active tab = just the sliding green bar, no pill behind it
	local Indicator = New("Frame", {
		Size = UDim2.new(1, 0, 0, S.Tab), ZIndex = 1, BackgroundTransparency = 1, Parent = TabScroll,
	})
	New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0, 3, 0, S.Tab - 16), ZIndex = 2,
		Theme = { BackgroundColor3 = "Accent" }, Parent = Indicator, Pill(),
	})
	local TabHolder = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enums.Y, ZIndex = 2, Parent = TabScroll,
		List({ Padding = UDim.new(0, 4) }),
	})

	-- content ---------------------------------------------------------
	local Content = New("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(184, 0), Size = UDim2.new(1, -184, 1, 0), Parent = Main })
	-- no header at all: pages fill the content area; an invisible strip along the top margin still drags the window
	local Pages = New("Frame", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ClipsDescendants = true, Parent = Content,
	})
	local DragArea = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 12), ZIndex = 30, Parent = Content })
	local PageCover = New("Frame", {
		Size = UDim2.fromScale(1, 1), ZIndex = 10, BackgroundTransparency = 1, Visible = false, Theme = { BackgroundColor3 = "Background" }, Parent = Pages,
	})
	local EmptyState = New("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 60), Size = UDim2.new(1, -40, 0, 40), ZIndex = 5,
		Visible = false, RichText = true, TextWrapped = true, FontFace = FONT.Medium, TextSize = 13, TextXAlignment = Enums.Center,
		Theme = { TextColor3 = "DimText" }, Parent = Pages,
	})

	local Grip = New("TextButton", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(18, 18), ZIndex = 20, Parent = Main,
	})
	for i, p in ipairs({ { 13, 7 }, { 13, 13 }, { 7, 13 } }) do
		New("Frame", {
			Position = UDim2.fromOffset(p[1] - 1, p[2] - 1), Size = UDim2.fromOffset(2, 2), ZIndex = 21, Name = "Dot" .. i,
			Theme = { BackgroundColor3 = "DimText" }, Parent = Grip, Pill(),
		})
	end

	local Cover = New("Frame", {
		Size = UDim2.fromScale(1, 1), ZIndex = 100, BackgroundTransparency = 0, Theme = { BackgroundColor3 = "Background" }, Parent = Main, Round(10),
	})
	self.Cover = Cover

	-- dragging + resizing -------------------------------------------------
	local function ClampOnScreen()
		local vp = workspace.CurrentCamera.ViewportSize
		local inset = GuiService:GetGuiInset()
		local p = Root.AbsolutePosition
		local sz = Root.AbsoluteSize
		local h = vp.Y - inset.Y
		local cx = p.X + sz.X / 2
		local cy = p.Y + sz.Y / 2
		-- keep at least 80px of the window and the whole header reachable
		local nx = math.clamp(cx, 80 - sz.X / 2, vp.X - 80 + sz.X / 2)
		local ny = math.clamp(cy, sz.Y / 2, math.max(sz.Y / 2, h - 60 + sz.Y / 2))
		if nx ~= cx or ny ~= cy then
			Root.Position = UDim2.new(Root.Position.X.Scale, Root.Position.X.Offset + (nx - cx), Root.Position.Y.Scale, Root.Position.Y.Offset + (ny - cy))
		end
	end

	-- on boot / screen changes the whole window should be visible, not just a sliver
	local function FitOnScreen()
		local vp = workspace.CurrentCamera.ViewportSize
		local h = vp.Y - GuiService:GetGuiInset().Y
		local s = self.Scale
		local hw, hh = Root.Size.X.Offset * s / 2, Root.Size.Y.Offset * s / 2
		local cx = Root.Position.X.Scale * vp.X + Root.Position.X.Offset
		local cy = Root.Position.Y.Scale * h + Root.Position.Y.Offset
		local nx = hw * 2 <= vp.X and math.clamp(cx, hw + 8, vp.X - hw - 8) or vp.X / 2
		local ny = hh * 2 <= h and math.clamp(cy, hh + 8, h - hh - 8) or h / 2
		Root.Position = UDim2.fromOffset(math.floor(nx), math.floor(ny))
	end
	self._FitOnScreen = FitOnScreen
	MakeDraggable(Brand, Root, function() ClampOnScreen(); self:_SavePrefs() end)
	MakeDraggable(DragArea, Root, function() ClampOnScreen(); self:_SavePrefs() end)

	Grip.InputBegan:Connect(function(input)
		if not IsPress(input) then return end
		local start = input.Position
		local startSize = self.WindowSize
		local startPos = Root.Position
		local startAbs = Root.Size
		TrackDrag(input, function(p)
			local s = self.Scale
			local d = (p - start)
			local nw = math.max(500, startSize.X + d.X / s)
			local nh = math.max(340, startSize.Y + d.Y / s)
			self.WindowSize = Vector2.new(math.floor(nw), math.floor(nh))
			self:_UpdateScale()
			local real = Root.Size
			local dx = (real.X.Offset - startAbs.X.Offset) * s / 2
			local dy = (real.Y.Offset - startAbs.Y.Offset) * s / 2
			Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + dx, startPos.Y.Scale, startPos.Y.Offset + dy)
		end, function()
			self.WindowSize = Vector2.new(Root.Size.X.Offset, Root.Size.Y.Offset)
			self:_SavePrefs()
		end)
	end)
	Grip.MouseEnter:Connect(function() for _, d in ipairs(Grip:GetChildren()) do if d:IsA("Frame") then Tween(d, 0.15, { BackgroundColor3 = self.Theme.Accent }) end end end)
	Grip.MouseLeave:Connect(function() for _, d in ipairs(Grip:GetChildren()) do if d:IsA("Frame") then Tween(d, 0.15, { BackgroundColor3 = self.Theme.DimText }) end end end)

	-- responsive layout ---------------------------------------------------
	local collapsedNav = false
	function Window:_UpdateLayout()
		local w = Root.Size.X.Offset
		local collapsed = w < 600
		local sideW = collapsed and 62 or 184
		Sidebar.Size = UDim2.new(0, sideW, 1, 0)
		Content.Position = UDim2.fromOffset(sideW, 0)
		Content.Size = UDim2.new(1, -sideW, 1, 0)
		if brandCollapsed ~= collapsed then
			brandCollapsed = collapsed
			RenderTitle()
		end
		BrandTitle.Position = UDim2.fromOffset(collapsed and 0 or 26, 0)
		BrandTitle.Size = collapsed and UDim2.fromScale(1, 1) or UDim2.new(1, -32, 1, 0)
		BrandTitle.TextXAlignment = collapsed and Enums.Center or Enums.Left
		BrandTitle.TextSize = TS(collapsed and 15 or 20)
		TabScroll.Position = UDim2.fromOffset(collapsed and 8 or 10, 70)
		TabScroll.Size = UDim2.new(1, collapsed and -17 or -21, 1, -70 - 12)
		if collapsed ~= collapsedNav then
			collapsedNav = collapsed
			for _, t in ipairs(self.Tabs) do t:_SetCollapsed(collapsed) end
		end
		local twoCols = (w - sideW - 30) >= 440
		for _, t in ipairs(self.Tabs) do t:_SetColumns(twoCols) end
	end

	local function TabIndex(tab)
		local sorted = table.clone(Window.Tabs)
		table.sort(sorted, function(a, b) return a.Order < b.Order end)
		return table.find(sorted, tab) or 1
	end

	function Window:_ApplySearch()
		local q = self.SearchQuery
		local tab = self.Active
		if not tab then return end
		local found = false
		for _, g in ipairs(tab.Groupboxes) do
			local any = false
			local titleHit = q == "" or (g.Title and g.Title ~= "" and g.Title:lower():find(q, 1, true) ~= nil)
			for _, el in ipairs(g._Elements) do
				local hit = titleHit or (el.SearchText ~= nil and el.SearchText:find(q, 1, true) ~= nil)
				el._SearchHidden = not hit
				Library:_ApplyVisibility(el)
				if hit and el.Visible ~= false then any = true end
			end
			g.Holder.Visible = q == "" or any
			found = found or any
		end
		EmptyState.Visible = q ~= "" and not found
		if EmptyState.Visible then
			EmptyState.Text = 'Nothing in <font color="#' .. Library.Theme.Text:ToHex() .. '">' .. Escape(tab.Name) .. "</font> matches “" .. Escape(q) .. "”"
		end
	end
	-- no search bar in the ui anymore; filtering stays available from code
	function Window:Search(query)
		self.SearchQuery = tostring(query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
		self:_ApplySearch()
	end

	function Window:SelectTab(tab)
		if self.Active == tab then return end
		self.Active = tab
		local T = Library.Theme
		for _, t in ipairs(self.Tabs) do
			local sel = t == tab
			t.Page.Visible = sel
			Tween(t.Label, 0.2, { TextColor3 = sel and T.Text or T.SubText })
			Tween(t.Initial, 0.2, { TextColor3 = sel and T.Accent or T.SubText })
			if t.IconImg then Tween(t.IconImg, 0.2, { ImageColor3 = sel and T.Accent or T.SubText }) end
		end
		Tween(Indicator, 0.38, { Position = UDim2.fromOffset(0, (TabIndex(tab) - 1) * (S.Tab + 4)) }, Enum.EasingStyle.Quint)
		tab.Page.Position = UDim2.fromOffset(0, 12)
		Tween(tab.Page, 0.35, { Position = UDim2.fromOffset(0, 0) })
		-- solid fade-in cover; skipped in glass mode where a solid flash would break the see-through look
		if not Library.Glass then
			PageCover.Visible = true
			PageCover.BackgroundTransparency = 0
			local tw = Tween(PageCover, 0.3, { BackgroundTransparency = 1 })
			tw.Completed:Once(function() if PageCover.BackgroundTransparency >= 0.99 then PageCover.Visible = false end end)
		end
		self.SearchQuery = ""
		self:_ApplySearch()
	end

	function Window:AddTab(name, icon, desc)
		local opts = type(name) == "table" and name or { Name = name, Icon = icon, Description = desc }
		local Tab = {
			Name = opts.Name or opts.Title or "Tab", Description = opts.Description, Window = self, Groupboxes = {},
			Order = opts.Order or (#self.Tabs + 1),
		}
		local Btn = New("TextButton", { Size = UDim2.new(1, 0, 0, S.Tab), LayoutOrder = Tab.Order, ZIndex = 3, Parent = TabHolder })
		local iconId = opts.Icon
		if type(iconId) == "number" then iconId = "rbxassetid://" .. iconId end
		if iconId and iconId ~= "" then
			Tab.IconImg = New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(16, 16), Image = iconId,
				ZIndex = 3, Theme = { ImageColor3 = "SubText" }, Parent = Btn,
			})
		end
		Tab.Label = New("TextLabel", {
			Position = UDim2.fromOffset(Tab.IconImg and 38 or 16, 0), Size = UDim2.new(1, Tab.IconImg and -44 or -22, 1, 0), Text = Tab.Name,
			FontFace = FONT.Medium, TextSize = S.Txt, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Theme = { TextColor3 = "SubText" }, Parent = Btn,
		})
		Tab.Initial = New("TextLabel", {
			Size = UDim2.fromScale(1, 1), Text = Tab.Name:sub(1, 1):upper(), FontFace = FONT.Bold, TextSize = 15, TextXAlignment = Enums.Center,
			Visible = false, ZIndex = 3, Theme = { TextColor3 = "SubText" }, Parent = Btn,
		})
		Btn.MouseEnter:Connect(function() if Window.Active ~= Tab then Tween(Tab.Label, 0.15, { TextColor3 = Library.Theme.Text }) end end)
		Btn.MouseLeave:Connect(function() if Window.Active ~= Tab then Tween(Tab.Label, 0.15, { TextColor3 = Library.Theme.SubText }) end end)
		Btn.Activated:Connect(function() Window:SelectTab(Tab) end)
		Tab.Button = Btn

		local Page = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 1, ScrollBarThickness = 0, ScrollBarImageTransparency = 1,
			Parent = Pages,
		})
		-- explicit margins: UIPadding on a ScrollingFrame does not shrink scale-sized children
		local Columns = New("Frame", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 14), Size = UDim2.new(1, -28, 0, 0), AutomaticSize = Enums.Y,
			Parent = Page, Pad(0, 0, 16, 0),
		})
		local ColLayout = List({ FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12), Parent = Columns })
		local Left = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 1, Parent = Columns, List({ Padding = UDim.new(0, 12) }) })
		local Right = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enums.Y, LayoutOrder = 2, Parent = Columns, List({ Padding = UDim.new(0, 12) }) })
		Tab.Page, Tab.Left, Tab.Right = Page, Left, Right

		function Tab:_SetColumns(two)
			ColLayout.FillDirection = two and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
			Left.Size = two and UDim2.new(0.5, -6, 0, 0) or UDim2.new(1, 0, 0, 0)
			Right.Size = Left.Size
		end
		function Tab:_SetCollapsed(c)
			self.Label.Visible = not c
			if self.IconImg then
				self.IconImg.Position = c and UDim2.new(0.5, -8, 0.5, 0) or UDim2.new(0, 14, 0.5, 0)
				self.Initial.Visible = false
			else
				self.Initial.Visible = c
			end
		end
		function Tab:AddGroupbox(a)
			local side, name = 1, a
			if type(a) == "table" then side = a.Side or 1; name = a.Name or a.Title end
			return MakeGroupbox(Window, self, side == 2 and Right or Left, name)
		end
		function Tab:AddLeftGroupbox(name) return MakeGroupbox(Window, self, Left, name) end
		function Tab:AddRightGroupbox(name) return MakeGroupbox(Window, self, Right, name) end
		function Tab:AddLeftTabbox() return MakeTabbox(Window, self, Left) end
		function Tab:AddRightTabbox() return MakeTabbox(Window, self, Right) end
		function Tab:AddTabbox(a)
			local side = type(a) == "table" and a.Side or 1
			return MakeTabbox(Window, self, side == 2 and Right or Left)
		end
		function Tab:Select() Window:SelectTab(self) end

		table.insert(self.Tabs, Tab)
		Tab:_SetColumns((Root.Size.X.Offset - (collapsedNav and 62 or 184) - 30) >= 440)
		Tab:_SetCollapsed(collapsedNav)
		if not self.Active then self:SelectTab(Tab) end
		return Tab
	end

	table.insert(self.Refreshers, function()
		if Window.Active then
			local T = self.Theme
			for _, t in ipairs(Window.Tabs) do
				local sel = t == Window.Active
				t.Label.TextColor3 = sel and T.Text or T.SubText
				t.Initial.TextColor3 = sel and T.Accent or T.SubText
				if t.IconImg then t.IconImg.ImageColor3 = sel and T.Accent or T.SubText end
			end
		end
	end)

	-- settings tab ----------------------------------------------------------
	function Window:AddSettingsTab(name)
		if self.SettingsTab then return self.SettingsTab end
		local tab = self:AddTab({ Name = name or "Settings", Order = 100000, Description = "interface, configs & theme" })
		self.SettingsTab = tab
		local L = Library

		local ui = tab:AddLeftGroupbox("Interface")
		ui:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", { Default = L.MenuKeyDefault, NoUI = true, Text = "Menu keybind", Modes = { "Toggle" } })
		L.ToggleKeybind = L.Options.MenuKeybind
		L.Options.MenuKeybind:OnChanged(function() L:_SavePrefs() end)
		ui:AddToggle("ZombMobileButton", {
			Text = "Mobile toggle button", Default = true, Tooltip = "Floating button that shows / hides the menu (always on for touch devices)",
			Callback = function(v) L:SetMobileButton(v); L:_SavePrefs() end,
		})
		ui:AddToggle("ZombKeybindList", { Text = "Keybind list", Default = true, Callback = function(v) KeybindFrame.Visible = v; L:_SavePrefs() end })
		ui:AddToggle("ZombWatermark", { Text = "Watermark", Default = true, Callback = function(v) L:SetWatermarkVisibility(v); L:_SavePrefs() end })
		ui:AddSlider("ZombScale", {
			Text = "Interface scale", Min = 50, Max = 150, Default = 100, Rounding = 0, Suffix = "%",
			Callback = function(v) L.UserScale = v / 100; L:_UpdateScale(); L:_SavePrefs() end,
		})
		ui:AddDropdown("ZombNotifySide", {
			Text = "Notifications", Values = { "Bottom right", "Top right", "Top left", "Bottom left" }, Default = L.NotifySide,
			Callback = function(v) if v then L:SetNotifySide(v); L:_SavePrefs() end end,
		})
		ui:AddDivider()
		ui:AddButton({ Text = "Unload", DoubleClick = true, Func = function() L:Unload() end })

		local th = tab:AddLeftGroupbox("Theme")
		local presetNames = { "Zomb", "Toxic", "Blood", "Frost", "Violet", "Amber" }
		local applyingPreset = false
		-- one path for presets and saved themes: sync the pickers silently, then repaint once
		local function ApplyThemeUI(accent, base, text, glass)
			applyingPreset = true
			L.Options.ZombAccent:SetValueRGB(accent)
			L.Options.ZombBase:SetValueRGB(base)
			L.Options.ZombText:SetValueRGB(text)
			applyingPreset = false
			L:SetTheme({ Accent = accent, Base = base, Text = text })
			if type(glass) == "table" then
				if glass.opacity then L.Options.ZombGlassOpacity:SetValue(math.floor(glass.opacity * 100 + 0.5)) end
				if glass.blur ~= nil then L.Toggles.ZombGlassBlur:SetValue(glass.blur == true) end
				if glass.enabled ~= nil then L.Toggles.ZombGlass:SetValue(glass.enabled == true) end
			end
		end
		th:AddDropdown("ZombPreset", {
			Text = "Preset", Values = presetNames, AllowNull = true,
			Callback = function(v)
				local p = v and L.Presets[v]
				if p then ApplyThemeUI(p.Accent, p.Base, p.Text) end
			end,
		})
		local function ThemeColor(key)
			return function(c)
				L.Theme[key] = c
				if not applyingPreset then L:UpdateTheme() end
			end
		end
		th:AddLabel("Accent"):AddColorPicker("ZombAccent", { Default = L.Theme.Accent, Title = "Accent", Callback = ThemeColor("Accent") })
		th:AddLabel("Base"):AddColorPicker("ZombBase", { Default = L.Theme.Base, Title = "Base", Callback = ThemeColor("Base") })
		th:AddLabel("Text"):AddColorPicker("ZombText", { Default = L.Theme.Text, Title = "Text", Callback = ThemeColor("Text") })
		th:AddButton({ Text = "Reset theme", Func = function() L.Options.ZombPreset:SetValue("Zomb") end })
		th:AddDivider("glass")
		local glassToggle = th:AddToggle("ZombGlass", {
			Text = "Glass mode", Default = L.Glass, Tooltip = "See-through frosted panels",
			Callback = function(v) L:SetGlass(v); L:_SavePrefs() end,
		})
		local glassOpts = th:AddDependencyBox()
		glassOpts:AddSlider("ZombGlassOpacity", {
			Text = "Glass opacity", Min = 15, Max = 90, Default = math.floor(L.GlassOpacity * 100 + 0.5), Rounding = 0, Suffix = "%",
			Callback = function(v) L:SetGlass(L.Glass, v / 100); L:_SavePrefs() end,
		})
		glassOpts:AddToggle("ZombGlassBlur", {
			Text = "Blur the game behind", Default = L.GlassBlur, Tooltip = "Softens the 3D world while the menu is open",
			Callback = function(v) L:SetGlass(L.Glass, nil, v); L:_SavePrefs() end,
		})
		glassOpts:SetupDependencies({ { glassToggle, true } })
		ThemeManager._ApplyHook = ApplyThemeUI

		local cfg = tab:AddRightGroupbox("Configs")
		cfg:AddInput("ZombConfigName", { Text = "Config name", Placeholder = "e.g. legit", MaxLength = 40 })
		local list
		local autoLabel
		local function Refresh()
			list:SetValues(SaveManager:RefreshConfigList())
			local a = SaveManager:GetAutoload()
			autoLabel:SetText("Autoload: " .. (a and ('<font color="#' .. L.Theme.Accent:ToHex() .. '">' .. Escape(a) .. "</font>") or "none"))
		end
		local function Selected()
			return list.Value or (L.Options.ZombConfigName.Value ~= "" and L.Options.ZombConfigName.Value or nil)
		end
		cfg:AddButton({
			Text = "Create", Func = function()
				local n = L.Options.ZombConfigName.Value:gsub("[^%w%s%-_%.]", ""):gsub("^%s+", ""):gsub("%s+$", "")
				if n == "" then return L:Notify({ Title = "Configs", Content = "Type a config name first.", Duration = 3 }) end
				if SaveManager:Exists(n) then return L:Notify({ Title = "Configs", Content = '"' .. n .. '" already exists — use Overwrite.', Duration = 3 }) end
				local ok, err = SaveManager:Save(n)
				L:Notify({ Title = ok and "Config created" or "Save failed", Content = ok and ('Saved "' .. n .. '"') or tostring(err), Duration = 3 })
				Refresh()
				if ok then list:SetValue(n) end
			end,
		}):AddButton({
			Text = "Overwrite", DoubleClick = true, Func = function()
				local n = Selected()
				if not n then return L:Notify({ Title = "Configs", Content = "Pick a config to overwrite.", Duration = 3 }) end
				local ok, err = SaveManager:Save(n)
				L:Notify({ Title = ok and "Config overwritten" or "Save failed", Content = ok and ('Updated "' .. n .. '"') or tostring(err), Duration = 3 })
				Refresh()
			end,
		})
		list = cfg:AddDropdown("ZombConfigList", { Text = "Saved configs", Values = SaveManager:RefreshConfigList(), AllowNull = true, Searchable = true })
		cfg:AddButton({
			Text = "Load", Func = function()
				local n = list.Value
				if not n then return L:Notify({ Title = "Configs", Content = "Pick a config to load.", Duration = 3 }) end
				local ok, err = SaveManager:Load(n)
				L:Notify({ Title = ok and "Config loaded" or "Load failed", Content = ok and ('Loaded "' .. n .. '"') or tostring(err), Duration = 3 })
			end,
		}):AddButton({
			Text = "Delete", DoubleClick = true, Func = function()
				local n = list.Value
				if not n then return L:Notify({ Title = "Configs", Content = "Pick a config to delete.", Duration = 3 }) end
				local ok = SaveManager:Delete(n)
				if ok and SaveManager:GetAutoload() == n then SaveManager:SetAutoload("") end
				L:Notify({ Title = ok and "Config deleted" or "Delete failed", Content = '"' .. n .. '"', Duration = 3 })
				list:SetValue(nil)
				Refresh()
			end,
		})
		cfg:AddButton({ Text = "Refresh", Func = Refresh }):AddButton({
			Text = "Set autoload", Func = function()
				local n = list.Value
				if not n then
					SaveManager:SetAutoload("")
					L:Notify({ Title = "Autoload", Content = "Autoload cleared.", Duration = 3 })
				else
					SaveManager:SetAutoload(n)
					L:Notify({ Title = "Autoload", Content = '"' .. n .. '" will load on startup.', Duration = 3 })
				end
				Refresh()
			end,
		})
		autoLabel = cfg:AddLabel("Autoload: none", true)
		cfg:AddDivider("share")
		cfg:AddButton({
			Text = "Copy config", Func = function()
				local ok = pcall(setclipboard, SaveManager:Serialize(ConfigFilter))
				L:Notify({ Title = ok and "Copied" or "Clipboard unavailable", Content = ok and "Current settings copied to clipboard." or "", Duration = 3 })
			end,
		})
		cfg:AddInput("ZombImport", { Text = "Import", Placeholder = "paste a config here" })
		cfg:AddButton({
			Text = "Import pasted config", Func = function()
				local ok, err = SaveManager:Apply(L.Options.ZombImport.Value, ConfigFilter)
				L:Notify({ Title = ok and "Imported" or "Import failed", Content = ok and "Settings applied." or tostring(err), Duration = 3 })
				if ok then L.Options.ZombImport:SetValue("") end
			end,
		})
		if not FS then
			cfg:AddLabel('<font color="#ff4848">Your executor has no file system — configs are disabled.</font>', true)
		end
		Refresh()
		Library._RefreshConfigs = Refresh

		-- saved themes ------------------------------------------------------
		local tm = tab:AddRightGroupbox("Themes")
		tm:AddInput("ZombThemeName", { Text = "Theme name", Placeholder = "e.g. midnight", MaxLength = 40 })
		local tlist, defLabel, defaultName
		local function RenderDefault()
			defLabel:SetText("Default theme: " .. (defaultName and ('<font color="#' .. L.Theme.Accent:ToHex() .. '">' .. Escape(defaultName) .. "</font>") or "none"))
		end
		local function RefreshThemes()
			tlist:SetValues(ThemeManager:List())
			defaultName = ThemeManager:GetDefault()
			RenderDefault()
		end
		local function Note(title, text) L:Notify({ Title = title, Content = text, Duration = 3 }) end
		tm:AddButton({
			Text = "Save", Func = function()
				local n = CleanName(L.Options.ZombThemeName.Value)
				if n == "" then return Note("Themes", "Type a theme name first.") end
				if ThemeManager:Exists(n) then return Note("Themes", '"' .. n .. '" already exists — use Overwrite.') end
				local ok, err = ThemeManager:Save(n)
				Note(ok and "Theme saved" or "Save failed", ok and ('Saved "' .. n .. '"') or tostring(err))
				RefreshThemes()
				if ok then tlist:SetValue(n) end
			end,
		}):AddButton({
			Text = "Overwrite", DoubleClick = true, Func = function()
				local n = tlist.Value or (CleanName(L.Options.ZombThemeName.Value) ~= "" and CleanName(L.Options.ZombThemeName.Value) or nil)
				if not n then return Note("Themes", "Pick a theme to overwrite.") end
				local ok, err = ThemeManager:Save(n)
				Note(ok and "Theme overwritten" or "Save failed", ok and ('Updated "' .. n .. '"') or tostring(err))
				RefreshThemes()
			end,
		})
		tlist = tm:AddDropdown("ZombThemeList", { Text = "Saved themes", Values = ThemeManager:List(), AllowNull = true, Searchable = true })
		tm:AddButton({
			Text = "Load", Func = function()
				local n = tlist.Value
				if not n then return Note("Themes", "Pick a theme to load.") end
				local ok, err = ThemeManager:Load(n)
				Note(ok and "Theme loaded" or "Load failed", ok and ('Applied "' .. n .. '"') or tostring(err))
			end,
		}):AddButton({
			Text = "Delete", DoubleClick = true, Func = function()
				local n = tlist.Value
				if not n then return Note("Themes", "Pick a theme to delete.") end
				local ok = ThemeManager:Delete(n)
				Note(ok and "Theme deleted" or "Delete failed", '"' .. n .. '"')
				tlist:SetValue(nil)
				RefreshThemes()
			end,
		})
		tm:AddButton({ Text = "Refresh", Func = RefreshThemes }):AddButton({
			Text = "Set default", Func = function()
				local n = tlist.Value
				ThemeManager:SetDefault(n)
				Note("Default theme", n and ('"' .. n .. '" loads on startup.') or "Default cleared.")
				RefreshThemes()
			end,
		})
		defLabel = tm:AddLabel("Default theme: none", true)
		RefreshThemes()
		-- theme repaints fire every frame while a colour is dragged: only recolour the label, no disk access
		table.insert(L.Refreshers, function() if defLabel then RenderDefault() end end)

		-- re-apply saved interface prefs over the defaults
		local prefsData = Library:_ReadPrefs()
		if prefsData then
			SaveManager:Apply(HttpService:JSONEncode(prefsData), function(idx)
				-- theme colours come from prefs.theme (version-gated in CreateWindow), not from the picker values
				return IsInternal(idx) and idx ~= "ZombConfigName" and idx ~= "ZombConfigList" and idx ~= "ZombImport" and idx ~= "ZombPreset"
					and idx ~= "ZombAccent" and idx ~= "ZombBase" and idx ~= "ZombText"
					and idx ~= "ZombThemeName" and idx ~= "ZombThemeList"
					-- glass rides with prefs.theme too (version-gated), not with the toggle values
					and idx ~= "ZombGlass" and idx ~= "ZombGlassOpacity" and idx ~= "ZombGlassBlur"
			end)
		end
		-- a chosen default theme wins over whatever was last on screen
		ThemeManager:LoadDefault()
		return tab
	end

	-- boot ----------------------------------------------------------------
	self:_BuildMobileButton()
	-- acrylic blur follows these panels (only does anything while glass mode + blur are on)
	self:_AcrylicTrack(Main, function() return Root.Visible end)
	self:_AcrylicTrack(KeybindFrame, function() return KeybindFrame.Visible end)
	self:_AcrylicTrack(Watermark, function() return Watermark.Visible end)
	self:_AcrylicTrack(self.MobileButton, function() return self.MobileButton.Visible end)
	self:_ApplyGlass() -- glass is on by default: style the window edge/sheen and start the acrylic now
	if prefs and type(prefs.mobileButton) == "table" and prefs.mobileButton[4] then
		local p = prefs.mobileButton
		self.MobileButton.Position = UDim2.new(p[1], p[2], p[3], p[4])
	end
	-- on by default (the settings toggles / saved prefs can switch them off)
	self:SetMobileButton(true)
	KeybindFrame.Visible = true
	self:SetWatermarkVisibility(true)

	self:_UpdateScale()
	local function OnViewport()
		self:_UpdateScale()
		FitOnScreen()
	end
	self:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), OnViewport)
	self:Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
		task.wait()
		if workspace.CurrentCamera then
			self:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), OnViewport)
			OnViewport()
		end
	end)

	-- mouse unlock / cursor while the menu is up
	self:Connect(RunService.RenderStepped, function()
		if self.Open and not UserInputService.MouseIconEnabled then
			UserInputService.MouseIconEnabled = true
			self._ForcedCursor = true
		end
	end)

	local function Finish()
		if self.Unloaded then return end
		if info.AutoSettings ~= false and not Window.SettingsTab then Window:AddSettingsTab() end
		self._PrefsReady = true
		SaveManager:LoadAutoloadConfig()
		FitOnScreen()
		if info.AutoShow ~= false then self:Toggle(true) end
		self.Loaded = true
		local key = type(self.ToggleKeybind) == "table" and self.ToggleKeybind.Value or self.MenuKeyDefault
		self:Notify({
			Title = title,
			Content = string.format("Loaded in %.2fs · %s", os.clock() - self._StartTime,
				self.IsMobile and "tap the zomb button to toggle" or ("press <b>" .. KeyName(key) .. "</b> to toggle")),
			Duration = 5,
		})
	end

	if info.Loader == false or info.LoadingScreen == false then
		task.defer(Finish)
	else
		local loaderOpts = type(info.Loader) == "table" and info.Loader or {}
		self:_RunLoader(loaderOpts, loaderOpts.Title or title, Finish)
	end

	return Window
end

-- =====================================================================
-- unload
-- =====================================================================
function Library:Unload()
	if self.Unloaded then return end
	self.Unloaded = true
	for _, fn in ipairs(self.UnloadCallbacks) do pcall(fn) end
	for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
	if self._ForcedCursor then pcall(function() UserInputService.MouseIconEnabled = false end) end
	pcall(function() ScreenGui:Destroy() end)
	pcall(function() self:_DestroyAcrylic() end)
	pcall(function() if self.LoaderGui then self.LoaderGui:Destroy() end end)
	if genv.ZombLib == self then genv.ZombLib = nil end
end

return Library
