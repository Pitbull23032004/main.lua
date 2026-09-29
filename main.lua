-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Proteção para garantir o pai correto da GUI
local guiParent = pcall(function() return gethui() end) and gethui() or (CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui"))

-- Remove instâncias antigas se houver
if guiParent:FindFirstChild("DarkGamingYT_ProHub") then
	guiParent.DarkGamingYT_ProHub:Destroy()
end

-- ==========================================================================
-- EFEITOS SONOROS
-- ==========================================================================
local function PlayClickSound()
	task.spawn(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://6895079853"
		sound.Volume = 0.5
		sound.Parent = SoundService
		sound:Play()
		sound.Ended:Wait()
		sound:Destroy()
	end)
end

local function PlayTabSound()
	task.spawn(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://9114223179"
		sound.Volume = 0.4
		sound.Parent = SoundService
		sound:Play()
		sound.Ended:Wait()
		sound:Destroy()
	end)
end

-- ==========================================================================
-- 1. Interface Gráfica / Main Frame
-- ==========================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkGamingYT_ProHub"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local MainRGB = Instance.new("UIStroke")
MainRGB.Parent = MainFrame
MainRGB.Thickness = 1.5
MainRGB.Color = Color3.fromRGB(0, 255, 102)

task.spawn(function()
	local pulse = 0
	while task.wait() do
		pulse = (pulse + 0.03) % (math.pi * 2)
		local greenVal = 0.6 + math.sin(pulse) * 0.4
		MainRGB.Color = Color3.fromRGB(10, math.floor(greenVal * 255), 80)
	end
end)

-- Header / Barra Superior
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(16, 22, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0.04, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "DARKGAMINGYT  |  ZOMBIES"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 102)
TitleLabel.TextSize = 13.000
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ClockLabel = Instance.new("TextLabel")
ClockLabel.Name = "ClockLabel"
ClockLabel.Parent = TitleBar
ClockLabel.BackgroundTransparency = 1.000
ClockLabel.Position = UDim2.new(0.55, 0, 0, 0)
ClockLabel.Size = UDim2.new(0.20, 0, 1, 0)
ClockLabel.Font = Enum.Font.Code
ClockLabel.Text = "00:00:00"
ClockLabel.TextColor3 = Color3.fromRGB(160, 220, 180)
ClockLabel.TextSize = 10.000
ClockLabel.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
	while task.wait(1) do
		ClockLabel.Text = os.date("%H:%M:%S")
	end
end)

local ButtonHolder = Instance.new("Frame")
ButtonHolder.Name = "ButtonHolder"
ButtonHolder.Parent = TitleBar
ButtonHolder.BackgroundTransparency = 1.000
ButtonHolder.Position = UDim2.new(1, -60, 0, 8)
ButtonHolder.Size = UDim2.new(0, 50, 0, 24)

local UIListLayout_Title = Instance.new("UIListLayout")
UIListLayout_Title.Parent = ButtonHolder
UIListLayout_Title.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Title.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout_Title.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Title.Padding = UDim.new(0, 4)

local function CreateTitleButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.Parent = ButtonHolder
	btn.BackgroundColor3 = Color3.fromRGB(24, 32, 26)
	btn.BorderSizePixel = 0
	btn.Size = UDim2.new(0, 22, 0, 22)
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(0, 255, 102)
	btn.TextSize = 11.000
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		PlayClickSound()
		callback()
	end)
	return btn
end

-- Barra de Abas
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(14, 18, 16)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(1, 0, 0, 36)

local UIListLayout_Tabs = Instance.new("UIListLayout")
UIListLayout_Tabs.Parent = TabBar
UIListLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Tabs.SortOrder = Enum.SortOrder.LayoutOrder

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = MainFrame

local function CreatePage()
	local page = Instance.new("ScrollingFrame")
	page.Parent = PagesFolder
	page.BackgroundTransparency = 1.000
	page.BorderSizePixel = 0
	page.Position = UDim2.new(0, 0, 0, 80)
	page.Size = UDim2.new(1, 0, 1, -85)
	page.CanvasSize = UDim2.new(0, 0, 0, 520)
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 102)
	page.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Parent = page
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	return page
end

local combatPage = CreatePage()
local movementPage = CreatePage()
local visualsPage = CreatePage()
local infoPage = CreatePage()

combatPage.Visible = true

local tabButtons = {}
local function CreateTabButton(name, targetPage)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Parent = TabBar
	tabBtn.BackgroundColor3 = Color3.fromRGB(14, 18, 16)
	tabBtn.BorderSizePixel = 0
	tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(120, 140, 130)
	tabBtn.TextSize = 10.000

	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Parent = tabBtn
	indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
	indicator.BorderSizePixel = 0
	indicator.Position = UDim2.new(0.1, 0, 1, -2)
	indicator.Size = UDim2.new(0.8, 0, 0, 2)
	indicator.Visible = false

	tabBtn.MouseButton1Click:Connect(function()
		PlayTabSound()
		combatPage.Visible = false
		movementPage.Visible = false
		visualsPage.Visible = false
		infoPage.Visible = false
		
		targetPage.Visible = true
		
		for _, btn in pairs(tabButtons) do
			btn.TextColor3 = Color3.fromRGB(120, 140, 130)
			btn.BackgroundColor3 = Color3.fromRGB(14, 18, 16)
			if btn:FindFirstChild("Indicator") then
				btn.Indicator.Visible = false
			end
		end
		
		tabBtn.TextColor3 = Color3.fromRGB(0, 255, 102)
		tabBtn.BackgroundColor3 = Color3.fromRGB(22, 30, 25)
		indicator.Visible = true
	end)
	
	table.insert(tabButtons, tabBtn)
	return tabBtn
end

CreateTabButton("COMBATE", combatPage)
CreateTabButton("MOVIMENTO", movementPage)
CreateTabButton("VISUAIS", visualsPage)
CreateTabButton("INFO", infoPage)

tabButtons[1].TextColor3 = Color3.fromRGB(0, 255, 102)
tabButtons[1].BackgroundColor3 = Color3.fromRGB(22, 30, 25)
tabButtons[1].Indicator.Visible = true

local minimized = false
CreateTitleButton("-", function()
	minimized = not minimized
	TabBar.Visible = not minimized
	PagesFolder.Parent = minimized and nil or MainFrame
	if minimized then
		MainFrame.Size = UDim2.new(0, 420, 0, 40)
	else
		MainFrame.Size = UDim2.new(0, 420, 0, 500)
	end
end)

CreateTitleButton("X", function()
	ScreenGui:Destroy()
	getgenv().ESP_Box = false
	getgenv().ESP_Line = false
	getgenv().ESP_Name = false
	getgenv().ESP_Distance = false
	getgenv().ESP_Friend = false
	getgenv().ESP_HealthBar = false
	getgenv().Noclip_Active = false
	getgenv().Fly_Active = false
	getgenv().Aimbot_Active = false
	getgenv().Speed_Active = false
end)

-- ==========================================================================
-- 2. Construtores de Componentes
-- ==========================================================================
local function CreateToggle(parentPage, text, callback)
	local toggleContainer = Instance.new("Frame")
	toggleContainer.Name = text.."Container"
	toggleContainer.Parent = parentPage
	toggleContainer.BackgroundColor3 = Color3.fromRGB(18, 24, 20)
	toggleContainer.BorderSizePixel = 0
	toggleContainer.Size = UDim2.new(0.92, 0, 0, 42)

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = toggleContainer

	local containerStroke = Instance.new("UIStroke")
	containerStroke.Parent = toggleContainer
	containerStroke.Thickness = 1
	containerStroke.Color = Color3.fromRGB(30, 42, 34)

	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Parent = toggleContainer
	toggleLabel.BackgroundTransparency = 1.000
	toggleLabel.Position = UDim2.new(0.04, 0, 0, 0)
	toggleLabel.Size = UDim2.new(0.65, 0, 1, 0)
	toggleLabel.Font = Enum.Font.GothamMedium
	toggleLabel.Text = text
	toggleLabel.TextColor3 = Color3.fromRGB(220, 240, 225)
	toggleLabel.TextSize = 11.000
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Parent = toggleContainer
	toggleButton.BackgroundColor3 = Color3.fromRGB(28, 36, 30)
	toggleButton.BorderSizePixel = 0
	toggleButton.Position = UDim2.new(0.72, 0, 0.18, 0)
	toggleButton.Size = UDim2.new(0.24, 0, 0.64, 0)
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.Text = "OFF"
	toggleButton.TextColor3 = Color3.fromRGB(255, 70, 70)
	toggleButton.TextSize = 10.000

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = toggleButton

	local active = false
	toggleButton.MouseButton1Click:Connect(function()
		PlayClickSound()
		active = not active
		callback(active)
		if active then
			toggleButton.BackgroundColor3 = Color3.fromRGB(10, 50, 25)
			toggleButton.TextColor3 = Color3.fromRGB(0, 255, 102)
			toggleButton.Text = "ON"
			containerStroke.Color = Color3.fromRGB(0, 200, 90)
		else
			toggleButton.BackgroundColor3 = Color3.fromRGB(28, 36, 30)
			toggleButton.TextColor3 = Color3.fromRGB(255, 70, 70)
			toggleButton.Text = "OFF"
			containerStroke.Color = Color3.fromRGB(30, 42, 34)
		end
	end)
end

local function CreateMaintenanceToggle(parentPage, text)
	local toggleContainer = Instance.new("Frame")
	toggleContainer.Name = text.."Container"
	toggleContainer.Parent = parentPage
	toggleContainer.BackgroundColor3 = Color3.fromRGB(24, 20, 20)
	toggleContainer.BorderSizePixel = 0
	toggleContainer.Size = UDim2.new(0.92, 0, 0, 42)

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = toggleContainer

	local containerStroke = Instance.new("UIStroke")
	containerStroke.Parent = toggleContainer
	containerStroke.Thickness = 1
	containerStroke.Color = Color3.fromRGB(60, 40, 20)

	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Parent = toggleContainer
	toggleLabel.BackgroundTransparency = 1.000
	toggleLabel.Position = UDim2.new(0.04, 0, 0, 0)
	toggleLabel.Size = UDim2.new(0.55, 0, 1, 0)
	toggleLabel.Font = Enum.Font.GothamMedium
	toggleLabel.Text = text
	toggleLabel.TextColor3 = Color3.fromRGB(170, 160, 150)
	toggleLabel.TextSize = 11.000
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local badge = Instance.new("TextLabel")
	badge.Parent = toggleContainer
	badge.BackgroundColor3 = Color3.fromRGB(50, 30, 10)
	badge.BorderSizePixel = 0
	badge.Position = UDim2.new(0.56, 0, 0.20, 0)
	badge.Size = UDim2.new(0.40, 0, 0.60, 0)
	badge.Font = Enum.Font.GothamBold
	badge.Text = "[EM MANUTENÇÃO]"
	badge.TextColor3 = Color3.fromRGB(255, 170, 0)
	badge.TextSize = 8.500

	local badgeCorner = Instance.new("UICorner")
	badgeCorner.CornerRadius = UDim.new(0, 4)
	badgeCorner.Parent = badge
end

local function CreateSlider(parentPage, text, min, max, default, callback)
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Name = text.."Slider"
	sliderContainer.Parent = parentPage
	sliderContainer.BackgroundColor3 = Color3.fromRGB(18, 24, 20)
	sliderContainer.BorderSizePixel = 0
	sliderContainer.Size = UDim2.new(0.92, 0, 0, 50)

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = sliderContainer

	local containerStroke = Instance.new("UIStroke")
	containerStroke.Parent = sliderContainer
	containerStroke.Thickness = 1
	containerStroke.Color = Color3.fromRGB(30, 42, 34)

	local sliderLabel = Instance.new("TextLabel")
	sliderLabel.Parent = sliderContainer
	sliderLabel.BackgroundTransparency = 1.000
	sliderLabel.Position = UDim2.new(0.04, 0, 0, 4)
	sliderLabel.Size = UDim2.new(0.9, 0, 0, 18)
	sliderLabel.Font = Enum.Font.GothamMedium
	sliderLabel.Text = text .. ": " .. default
	sliderLabel.TextColor3 = Color3.fromRGB(220, 240, 225)
	sliderLabel.TextSize = 11.000
	sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

	local sliderBar = Instance.new("Frame")
	sliderBar.Parent = sliderContainer
	sliderBar.BackgroundColor3 = Color3.fromRGB(28, 36, 30)
	sliderBar.BorderSizePixel = 0
	sliderBar.Position = UDim2.new(0.04, 0, 0, 28)
	sliderBar.Size = UDim2.new(0.92, 0, 0, 8)

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 4)
	barCorner.Parent = sliderBar

	local sliderFill = Instance.new("Frame")
	sliderFill.Parent = sliderBar
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
	sliderFill.BorderSizePixel = 0
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 4)
	fillCorner.Parent = sliderFill

	local dragging = false
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pos = UDim2.new(math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
			sliderFill.Size = pos
			local val = math.floor(min + ((max - min) * pos.X.Scale))
			sliderLabel.Text = text .. ": " .. val
			callback(val)
		end
	end)
end

-- ==========================================================================
-- 3. ABA INFO
-- ==========================================================================
local infoFrame = Instance.new("Frame")
infoFrame.Parent = infoPage
infoFrame.BackgroundColor3 = Color3.fromRGB(18, 24, 20)
infoFrame.BorderSizePixel = 0
infoFrame.Size = UDim2.new(0.92, 0, 0, 190)

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoStroke = Instance.new("UIStroke")
infoStroke.Parent = infoFrame
infoStroke.Thickness = 1
infoStroke.Color = Color3.fromRGB(0, 255, 102)

local channelTitle = Instance.new("TextLabel")
channelTitle.Parent = infoFrame
channelTitle.BackgroundTransparency = 1
channelTitle.Position = UDim2.new(0, 0, 0, 14)
channelTitle.Size = UDim2.new(1, 0, 0, 22)
channelTitle.Font = Enum.Font.GothamBold
channelTitle.Text = "CANAL OFICIAL // DARKGAMINGYT"
channelTitle.TextColor3 = Color3.fromRGB(0, 255, 102)
channelTitle.TextSize = 14

local channelSub = Instance.new("TextLabel")
channelSub.Parent = infoFrame
channelSub.BackgroundTransparency = 1
channelSub.Position = UDim2.new(0, 0, 0, 38)
channelSub.Size = UDim2.new(1, 0, 0, 18)
channelSub.Font = Enum.Font.Gotham
channelSub.Text = "youtube.com/@wallacy_rtx"
channelSub.TextColor3 = Color3.fromRGB(200, 220, 210)
channelSub.TextSize = 11

local copyBtn = Instance.new("TextButton")
copyBtn.Parent = infoFrame
copyBtn.BackgroundColor3 = Color3.fromRGB(24, 50, 32)
copyBtn.BorderSizePixel = 0
copyBtn.Position = UDim2.new(0.1, 0, 0.42, 0)
copyBtn.Size = UDim2.new(0.8, 0, 0, 36)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Text = "COPIAR LINK DO CANAL"
copyBtn.TextColor3 = Color3.fromRGB(0, 255, 102)
copyBtn.TextSize = 11

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

copyBtn.MouseButton1Click:Connect(function()
	PlayClickSound()
	pcall(function()
		setclipboard("https://www.youtube.com/@wallacy_rtx")
	end)
	copyBtn.Text = "LINK COPIADO!"
	task.wait(2)
	copyBtn.Text = "COPIAR LINK DO CANAL"
end)

-- ==========================================================================
-- 4. REGISTRO DE OPÇÕES NAS ABAS (TESTADO E FUNCIONAL)
-- ==========================================================================

-- ABA COMBATE
CreateMaintenanceToggle(combatPage, "Auto-Kill Boss / Zumbis")

getgenv().Aimbot_Active = false
getgenv().Aimbot_Smoothness = 12

CreateToggle(combatPage, "Aimbot (Auto-Lock Suave)", function(state)
	getgenv().Aimbot_Active = state
end)

CreateSlider(combatPage, "Suavidade do Aimbot", 1, 30, 12, function(val)
	getgenv().Aimbot_Smoothness = val
end)

-- ABA MOVIMENTO
getgenv().Speed_Active = false
getgenv().Speed_Value = 30

CreateToggle(movementPage, "Ativar Velocidade (Speed)", function(state)
	getgenv().Speed_Active = state
	if not state and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
end)

CreateSlider(movementPage, "Valor da Velocidade", 16, 150, 30, function(val)
	getgenv().Speed_Value = val
end)

getgenv().Fly_Active = false
local flySpeed = 50
local bv, bg

CreateToggle(movementPage, "Modo Voo (Fly Hack)", function(state)
	getgenv().Fly_Active = state
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = character.HumanoidRootPart
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if state then
		bv = Instance.new("BodyVelocity")
		bv.Name = "ProFlyVelocity"
		bv.Parent = hrp
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.new(0, 0, 0)

		bg = Instance.new("BodyGyro")
		bg.Name = "ProFlyGyro"
		bg.Parent = hrp
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = hrp.CFrame

		if humanoid then humanoid.PlatformStand = true end

		task.spawn(function()
			while getgenv().Fly_Active and character.Parent do
				local cam = workspace.CurrentCamera
				local moveDir = Vector3.new(0, 0, 0)
				
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

				if bv and bg then
					bv.Velocity = moveDir * flySpeed
					bg.CFrame = cam.CFrame
				end
				RunService.RenderStepped:Wait()
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
		if humanoid then humanoid.PlatformStand = false end
	end
end)

getgenv().Noclip_Active = false
CreateToggle(movementPage, "Atravessar Paredes (Noclip)", function(state)
	getgenv().Noclip_Active = state
end)

RunService.Stepped:Connect(function()
	if getgenv().Noclip_Active and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- ABA VISUAIS
getgenv().ESP_Box = false
getgenv().ESP_Line = false
getgenv().ESP_Name = false
getgenv().ESP_Distance = false
getgenv().ESP_Friend = false
getgenv().ESP_HealthBar = false

CreateToggle(visualsPage, "ESP Box (Caixa)", function(state) getgenv().ESP_Box = state end)
CreateToggle(visualsPage, "ESP Line (Linhas Tracers)", function(state) getgenv().ESP_Line = state end)
CreateToggle(visualsPage, "ESP Health Bar (Barra de Vida)", function(state) getgenv().ESP_HealthBar = state end)
CreateToggle(visualsPage, "ESP Name (Nome do Alvo)", function(state) getgenv().ESP_Name = state end)
CreateToggle(visualsPage, "ESP Distance (Distância)", function(state) getgenv().ESP_Distance = state end)
CreateToggle(visualsPage, "ESP Amigo (Jogadores/Aliados)", function(state) getgenv().ESP_Friend = state end)

-- ==========================================================================
-- 5. RUNSERVICE LOOP (AIMBOT + ESP)
-- ==========================================================================
local drawings = {}

local function removeDrawings(model)
	if drawings[model] then
		for _, obj in pairs(drawings[model]) do
			pcall(function() obj:Remove() end)
		end
		drawings[model] = nil
	end
end

RunService.RenderStepped:Connect(function()
	-- Speed Loop
	if getgenv().Speed_Active and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = getgenv().Speed_Value end
	end

	-- Aimbot Loop
	if getgenv().Aimbot_Active then
		local closestTarget = nil
		local shortestDist = math.huge
		
		for _, model in ipairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model ~= LocalPlayer.Character then
				local humanoid = model:FindFirstChildOfClass("Humanoid")
				local targetPart = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
				
				if humanoid and targetPart and humanoid.Health > 0 and not Players:GetPlayerFromCharacter(model) then
					local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						local mouseDist = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
						if mouseDist < shortestDist then
							shortestDist = mouseDist
							closestTarget = targetPart
						end
					end
				end
			end
		end
		
		if closestTarget then
			local targetCF = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
			local smoothFactor = math.clamp(getgenv().Aimbot_Smoothness, 1, 30)
			Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 / smoothFactor)
		end
	end

	-- ESP Loop
	for _, model in ipairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model ~= LocalPlayer.Character then
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
			local playerTarget = Players:GetPlayerFromCharacter(model)
			
			local shouldProcess = false
			if playerTarget then
				if getgenv().ESP_Friend then shouldProcess = true end
			else
				shouldProcess = true
			end

			if humanoid and hrp and humanoid.Health > 0 and shouldProcess then
				local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
				
				if onScreen then
					if not drawings[model] then
						drawings[model] = {
							Box = Drawing.new("Square"),
							Line = Drawing.new("Line"),
							Text = Drawing.new("Text"),
							HealthBarBg = Drawing.new("Square"),
							HealthBar = Drawing.new("Square")
						}
						
						drawings[model].Box.Visible = false
						drawings[model].Box.Thickness = 1
						drawings[model].Box.Filled = false

						drawings[model].Line.Visible = false
						drawings[model].Line.Thickness = 1

						drawings[model].Text.Visible = false
						drawings[model].Text.Size = 12
						drawings[model].Text.Center = true
						drawings[model].Text.Outline = true
						drawings[model].Text.Color = Color3.fromRGB(255, 255, 255)

						drawings[model].HealthBarBg.Visible = false
						drawings[model].HealthBarBg.Thickness = 1
						drawings[model].HealthBarBg.Filled = true
						drawings[model].HealthBarBg.Color = Color3.fromRGB(40, 40, 40)

						drawings[model].HealthBar.Visible = false
						drawings[model].HealthBar.Thickness = 1
						drawings[model].HealthBar.Filled = true
						drawings[model].HealthBar.Color = Color3.fromRGB(0, 255, 102)
					end
					
					local d = drawings[model]
					local highlightColor = playerTarget and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(0, 255, 102)
					d.Box.Color = highlightColor
					d.Line.Color = highlightColor

					local head = model:FindFirstChild("Head") or hrp
					local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
					local legVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
					local height = math.abs(headVector.Y - legVector.Y)
					local width = height / 2

					if getgenv().ESP_Box then
						d.Box.Size = Vector2.new(width, height)
						d.Box.Position = Vector2.new(vector.X - width / 2, headVector.Y)
						d.Box.Visible = true
					else
						d.Box.Visible = false
					end

					if getgenv().ESP_Line then
						d.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						d.Line.To = Vector2.new(vector.X, legVector.Y)
						d.Line.Visible = true
					else
						d.Line.Visible = false
					end

					if getgenv().ESP_HealthBar then
						local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
						local barX = vector.X - width / 2 - 6
						local barY = headVector.Y
						local barHeight = height
						local barWidth = 3

						d.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
						d.HealthBarBg.Position = Vector2.new(barX, barY)
						d.HealthBarBg.Visible = true

						local filledHeight = barHeight * healthPct
						d.HealthBar.Size = Vector2.new(barWidth, filledHeight)
						d.HealthBar.Position = Vector2.new(barX, barY + (barHeight - filledHeight))
						d.HealthBar.Visible = true
					else
						d.HealthBarBg.Visible = false
						d.HealthBar.Visible = false
					end

					local showName = getgenv().ESP_Name
					local showDist = getgenv().ESP_Distance
					
					if showName or showDist then
						local textParts = {}
						if showName then 
							table.insert(textParts, playerTarget and playerTarget.DisplayName or model.Name) 
						end
						if showDist then
							local distance = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
							table.insert(textParts, "[" .. distance .. "m]")
						end
						
						d.Text.Text = table.concat(textParts, " ")
						d.Text.Position = Vector2.new(vector.X, headVector.Y - 18)
						d.Text.Visible = true
					else
						d.Text.Visible = false
					end
				else
					removeDrawings(model)
				end
			else
				removeDrawings(model)
			end
		end
	end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "DARKGAMINGYT",
	Text = "Painel ativado com sucesso!",
	Duration = 4
})
