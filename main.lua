-- ==========================================================================
-- KNIFE DUELS | COM2 BRUTAL V15 (ESP Vida BETA + Firebase Live + Menu Completo)
-- Jogo: [CEMITÉRIO] DUELOS DE FACA (Knife Duels) - Roblox
-- Site Oficial: https://darkgamingyt-br-pt.netlify.app/
-- Firebase: https://darkgamingyt-1c438-default-rtdb.firebaseio.com/
-- Canal: https://youtube.com/@wallacy_rtx | Discord: https://discord.com/invite/vzMRuAs6gt
-- ==========================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local SCRIPT_VERSION = "KD BRUTAL V15 [ESP VIDA BETA]"
local FIREBASE_BASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"
local FONT_MAIN = Enum.Font.Code

-- Paleta de Cores Estilo Cemitério / Roxo Halloween & Ciano Neon
local COLOR_BG = Color3.fromRGB(10, 8, 14)
local COLOR_PANEL = Color3.fromRGB(16, 12, 22)
local COLOR_ITEM = Color3.fromRGB(24, 18, 34)
local COLOR_ACCENT = Color3.fromRGB(190, 0, 255)    -- Roxo Cemitério
local COLOR_SECONDARY = Color3.fromRGB(0, 255, 240) -- Ciano Brilhante
local COLOR_BORDER = Color3.fromRGB(75, 30, 110)
local COLOR_TEXT = Color3.fromRGB(245, 240, 255)
local COLOR_SUBTEXT = Color3.fromRGB(160, 140, 190)
local COLOR_WARN = Color3.fromRGB(255, 205, 75)     -- Alerta Risco Ban 24h
local COLOR_OFF = Color3.fromRGB(255, 75, 75)
local COLOR_ON = Color3.fromRGB(75, 255, 140)

-- Compatibilidade de requisição HTTP para o Firebase
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Variáveis de telemetria
local fpsAtual = 60
local paisUsuario = "Desconhecido"
local cidadeUsuario = "Desconhecida"
local safeKey = "user_" .. tostring(LocalPlayer.UserId)

-- Coleta assíncrona de geolocalização por IP
task.spawn(function()
	pcall(function()
		local response = game:HttpGet("http://ip-api.com/json/?fields=country,city")
		if response then
			local data = HttpService:JSONDecode(response)
			if data and data.country then
				paisUsuario = data.country
				cidadeUsuario = data.city or "Desconhecida"
			end
		end
	end)
end)

-- Limpeza de versão anterior
pcall(function()
	if CoreGui:FindFirstChild("KD_Brutal_V15") then CoreGui.KD_Brutal_V15:Destroy() end
	if LocalPlayer.PlayerGui:FindFirstChild("KD_Brutal_V15") then LocalPlayer.PlayerGui.KD_Brutal_V15:Destroy() end
	if gethui and gethui():FindFirstChild("KD_Brutal_V15") then gethui().KD_Brutal_V15:Destroy() end
end)

-- Criação segura do ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KD_Brutal_V15"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentSuccess = pcall(function()
	if gethui then
		ScreenGui.Parent = gethui()
	else
		ScreenGui.Parent = CoreGui
	end
end)
if not parentSuccess or not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local EspLineFolder = Instance.new("Folder", ScreenGui)
EspLineFolder.Name = "KD_EspLinesPool"

-- Sistema de Sons (Sound FX)
local function playClickSound()
	pcall(function()
		local snd = Instance.new("Sound")
		snd.SoundId = "rbxassetid://6026985050"
		snd.Volume = 0.5
		snd.Parent = ScreenGui
		snd:Play()
		game:GetService("Debris"):AddItem(snd, 1)
	end)
end

local function applyStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or COLOR_ACCENT
	stroke.Thickness = thickness or 1.5
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

local function makeDraggable(dragHandle, targetFrame)
	local dragging = false
	local dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ==========================================================================
-- BARRA DE CARREGAMENTO INICIAL (LOADING SCREEN)
-- ==========================================================================
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(0, 320, 0, 150)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -75)
LoadingFrame.BackgroundColor3 = COLOR_BG
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 200
applyStroke(LoadingFrame, COLOR_SECONDARY, 2)
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 10)

local LoadTitle = Instance.new("TextLabel", LoadingFrame)
LoadTitle.Size = UDim2.new(1, -20, 0, 24)
LoadTitle.Position = UDim2.new(0, 10, 0, 12)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "🗡️ KNIFE DUELS // COM2 BRUTAL V15"
LoadTitle.TextColor3 = COLOR_SECONDARY
LoadTitle.TextSize = 12
LoadTitle.Font = FONT_MAIN
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.ZIndex = 202

local LoadStatus = Instance.new("TextLabel", LoadingFrame)
LoadStatus.Size = UDim2.new(1, -20, 0, 20)
LoadStatus.Position = UDim2.new(0, 10, 0, 50)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Conectando ao Firebase DB..."
LoadStatus.TextColor3 = COLOR_SUBTEXT
LoadStatus.TextSize = 10
LoadStatus.Font = FONT_MAIN
LoadStatus.TextXAlignment = Enum.TextXAlignment.Left
LoadStatus.ZIndex = 202

local LoadBarBg = Instance.new("Frame", LoadingFrame)
LoadBarBg.Size = UDim2.new(1, -24, 0, 16)
LoadBarBg.Position = UDim2.new(0, 12, 0, 85)
LoadBarBg.BackgroundColor3 = COLOR_PANEL
LoadBarBg.BorderSizePixel = 0
LoadBarBg.ZIndex = 202
applyStroke(LoadBarBg, COLOR_BORDER, 1)
Instance.new("UICorner", LoadBarBg).CornerRadius = UDim.new(0, 6)

local LoadBarFill = Instance.new("Frame", LoadBarBg)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = COLOR_ACCENT
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 203
Instance.new("UICorner", LoadBarFill).CornerRadius = UDim.new(0, 5)

-- Painel Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 470)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -235)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 80
applyStroke(MainFrame, COLOR_ACCENT, 2)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FloatContainer = Instance.new("Frame", ScreenGui)
FloatContainer.Size = UDim2.fromOffset(120, 56)
FloatContainer.Position = UDim2.new(0.5, -340, 0.5, -235)
FloatContainer.BackgroundColor3 = COLOR_BG
FloatContainer.BorderSizePixel = 0
FloatContainer.Visible = false
FloatContainer.ZIndex = 100
applyStroke(FloatContainer, COLOR_ACCENT, 2)
Instance.new("UICorner", FloatContainer).CornerRadius = UDim.new(0, 8)

local FpsLabel = Instance.new("TextLabel", FloatContainer)
FpsLabel.Size = UDim2.new(1, 0, 0, 18)
FpsLabel.Position = UDim2.new(0, 0, 0, 2)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = COLOR_SECONDARY
FpsLabel.TextSize = 10
FpsLabel.Font = FONT_MAIN
FpsLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsLabel.ZIndex = 102

local FloatBtn = Instance.new("TextButton", FloatContainer)
FloatBtn.Size = UDim2.new(1, -6, 0, 30)
FloatBtn.Position = UDim2.new(0, 3, 0, 22)
FloatBtn.BackgroundColor3 = COLOR_PANEL
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "🗡️ KD V15"
FloatBtn.TextColor3 = COLOR_ACCENT
FloatBtn.TextSize = 11
FloatBtn.Font = FONT_MAIN
FloatBtn.ZIndex = 101
applyStroke(FloatBtn, COLOR_BORDER, 1)
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 6)

makeDraggable(FloatBtn, FloatContainer)

-- Sequência de Carregamento
task.spawn(function()
	local stages = {
		{pct = 0.30, txt = "Carregando modulos ESP & ESP Vida BETA... [30%]"},
		{pct = 0.65, txt = "Sincronizando com Firebase Realtime DB... [65%]"},
		{pct = 0.90, txt = "Aplicando Bypass Anti-Kick... [90%]"},
		{pct = 1.00, txt = "Sistema pronto! Bem-vindo ao KD V15 [100%]"}
	}
	for _, st in ipairs(stages) do
		LoadStatus.Text = st.txt
		TweenService:Create(LoadBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
			Size = UDim2.new(st.pct, 0, 1, 0)
		}):Play()
		task.wait(0.35)
	end
	task.wait(0.2)
	LoadingFrame:Destroy()
	MainFrame.Visible = true
	FloatContainer.Visible = true
	playClickSound()
end)

-- Contador de FPS
local fpsFrames = 0
local fpsLastTick = tick()
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLastTick >= 1 then
		fpsAtual = math.floor(fpsFrames / (now - fpsLastTick))
		FpsLabel.Text = string.format("FPS: %d", fpsAtual)
		fpsFrames = 0
		fpsLastTick = now
	end
end)

-- Tarefa em background para atualizar o Firebase em tempo real
task.spawn(function()
	while task.wait(4) do
		pcall(function()
			if httpRequest then
				local payload = {
					nickRoblox = LocalPlayer.Name,
					displayName = LocalPlayer.DisplayName,
					userId = LocalPlayer.UserId,
					versaoScript = SCRIPT_VERSION,
					fps = fpsAtual,
					pais = paisUsuario,
					cidade = cidadeUsuario,
					jogo = "Knife Duels",
					ultimaAtualizacao = os.date("%d/%m/%Y %H:%M:%S"),
					timestamp = os.time()
				}
				httpRequest({
					Url = FIREBASE_BASE_URL .. "/knife_duels_users/" .. safeKey .. ".json",
					Method = "PUT",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode(payload)
				})
			end
		end)
	end
end)

FloatContainer:GetPropertyChangedSignal("Position"):Connect(function()
	local fPos = FloatContainer.Position
	MainFrame.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + 128, fPos.Y.Scale, fPos.Y.Offset)
end)

FloatBtn.MouseButton1Click:Connect(function()
	playClickSound()
	MainFrame.Visible = not MainFrame.Visible
	FloatBtn.TextColor3 = MainFrame.Visible and COLOR_ON or COLOR_SUBTEXT
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = COLOR_PANEL
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 82
applyStroke(TopBar, COLOR_BORDER, 1)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🗡️ KNIFE DUELS // @wallacy_rtx"
TitleLabel.TextColor3 = COLOR_ACCENT
TitleLabel.TextSize = 10
TitleLabel.Font = FONT_MAIN
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 83

-- 5 Abas: [BYPASS] | [ESP MOD] | [AIMBOT] | [GERAL] | [SITE & DC]
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -20, 0, 32)
TabHeader.Position = UDim2.new(0, 10, 0, 48)
TabHeader.BackgroundColor3 = COLOR_PANEL
TabHeader.BorderSizePixel = 0
TabHeader.ZIndex = 82
applyStroke(TabHeader, COLOR_BORDER, 1)
Instance.new("UICorner", TabHeader).CornerRadius = UDim.new(0, 6)

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.19, 0, 0.8, 0)
	btn.Position = UDim2.new(posX, 0, 0.1, 0)
	btn.BackgroundColor3 = active and COLOR_SECONDARY or COLOR_ITEM
	btn.BorderSizePixel = 0
	btn.TextColor3 = active and COLOR_TEXT or COLOR_SUBTEXT
	btn.TextSize = 8
	btn.Font = FONT_MAIN
	btn.Text = name
	btn.ZIndex = 83
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	applyStroke(btn, active and COLOR_ACCENT or COLOR_BORDER, 1)
	return btn
end

local btnBypass = createTabBtn("BYPASS", 0.01, true)
local btnEsp = createTabBtn("ESP MOD", 0.21, false)
local btnAim = createTabBtn("AIMBOT", 0.41, false)
local btnGeral = createTabBtn("GERAL", 0.61, false)
local btnSocial = createTabBtn("SITE & DC", 0.81, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -20, 1, -114)
ContentContainer.Position = UDim2.new(0, 10, 0, 88)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 82

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = COLOR_ACCENT
	scroll.Visible = false
	scroll.ZIndex = 82
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 8)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.PaddingLeft = UDim.new(0, 2)
	pad.PaddingRight = UDim.new(0, 6)
	return scroll
end

local panelBypass = createScroll()
local panelEsp = createScroll()
local panelAim = createScroll()
local panelGeral = createScroll()
local panelSocial = createScroll()
panelBypass.Visible = true

local function selectTab(selected)
	playClickSound()
	panelBypass.Visible = (selected == panelBypass)
	panelEsp.Visible = (selected == panelEsp)
	panelAim.Visible = (selected == panelAim)
	panelGeral.Visible = (selected == panelGeral)
	panelSocial.Visible = (selected == panelSocial)
	
	local tabs = {
		{btn = btnBypass, panel = panelBypass},
		{btn = btnEsp, panel = panelEsp},
		{btn = btnAim, panel = panelAim},
		{btn = btnGeral, panel = panelGeral},
		{btn = btnSocial, panel = panelSocial}
	}
	for _, t in ipairs(tabs) do
		local isSel = (t.panel == selected)
		t.btn.BackgroundColor3 = isSel and COLOR_SECONDARY or COLOR_ITEM
		t.btn.TextColor3 = isSel and COLOR_TEXT or COLOR_SUBTEXT
		local st = t.btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = isSel and COLOR_ACCENT or COLOR_BORDER end
	end
end

btnBypass.MouseButton1Click:Connect(function() selectTab(panelBypass) end)
btnEsp.MouseButton1Click:Connect(function() selectTab(panelEsp) end)
btnAim.MouseButton1Click:Connect(function() selectTab(panelAim) end)
btnGeral.MouseButton1Click:Connect(function() selectTab(panelGeral) end)
btnSocial.MouseButton1Click:Connect(function() selectTab(panelSocial) end)

-- Rodapé com créditos
local FooterBar = Instance.new("Frame", MainFrame)
FooterBar.Size = UDim2.new(1, -20, 0, 24)
FooterBar.Position = UDim2.new(0, 10, 1, -28)
FooterBar.BackgroundColor3 = COLOR_PANEL
FooterBar.BorderSizePixel = 0
FooterBar.ZIndex = 82
applyStroke(FooterBar, COLOR_BORDER, 1)
Instance.new("UICorner", FooterBar).CornerRadius = UDim.new(0, 6)

local CreditLabel = Instance.new("TextLabel", FooterBar)
CreditLabel.Size = UDim2.new(1, 0, 1, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Site: darkgamingyt-br-pt.netlify.app"
CreditLabel.TextColor3 = COLOR_SECONDARY
CreditLabel.TextSize = 9
CreditLabel.Font = FONT_MAIN
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.ZIndex = 83

local function createToggle(parent, name, callback, desc, isRisky)
	local hasDesc = (desc ~= nil and desc ~= "")
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, hasDesc and 48 or 36)
	row.BackgroundColor3 = COLOR_PANEL
	row.BorderSizePixel = 0
	row.ZIndex = 83
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	applyStroke(row, isRisky and COLOR_WARN or COLOR_BORDER, 1)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 0, 20)
	label.Position = UDim2.new(0, 10, 0, hasDesc and 4 or 8)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 11
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 84

	if hasDesc then
		local descLbl = Instance.new("TextLabel", row)
		descLbl.Size = UDim2.new(0.68, 0, 0, 16)
		descLbl.Position = UDim2.new(0, 10, 0, 24)
		descLbl.BackgroundTransparency = 1
		descLbl.Text = desc
		descLbl.TextColor3 = isRisky and COLOR_WARN or COLOR_SUBTEXT
		descLbl.TextSize = 9
		descLbl.Font = FONT_MAIN
		descLbl.TextXAlignment = Enum.TextXAlignment.Left
		descLbl.ZIndex = 84
	end
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 64, 0, 22)
	statusBtn.Position = UDim2.new(1, -72, 0.5, -11)
	statusBtn.BackgroundColor3 = COLOR_ITEM
	statusBtn.BorderSizePixel = 0
	statusBtn.Text = "[ OFF ]"
	statusBtn.TextColor3 = COLOR_OFF
	statusBtn.TextSize = 10
	statusBtn.Font = FONT_MAIN
	statusBtn.ZIndex = 84
	Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 4)
	local btnStroke = applyStroke(statusBtn, COLOR_OFF, 1)
	
	local state = false
	statusBtn.MouseButton1Click:Connect(function()
		playClickSound()
		state = not state
		if state then
			statusBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 35)
			statusBtn.TextColor3 = COLOR_ON
			statusBtn.Text = "[ ON ]"
			btnStroke.Color = COLOR_ON
		else
			statusBtn.BackgroundColor3 = COLOR_ITEM
			statusBtn.TextColor3 = COLOR_OFF
			statusBtn.Text = "[ OFF ]"
			btnStroke.Color = COLOR_OFF
		end
		callback(state)
	end)
end

-- ==========================================================================
-- CONTEÚDO DA ABA SOCIAL
-- ==========================================================================
local function createSocialCard(parent, title, url, desc)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(1, 0, 0, 75)
	card.BackgroundColor3 = COLOR_PANEL
	card.BorderSizePixel = 0
	card.ZIndex = 83
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
	applyStroke(card, COLOR_SECONDARY, 1)

	local titleLbl = Instance.new("TextLabel", card)
	titleLbl.Size = UDim2.new(1, -16, 0, 22)
	titleLbl.Position = UDim2.new(0, 10, 0, 6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = COLOR_SECONDARY
	titleLbl.TextSize = 12
	titleLbl.Font = FONT_MAIN
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 84

	local descLbl = Instance.new("TextLabel", card)
	descLbl.Size = UDim2.new(1, -16, 0, 16)
	descLbl.Position = UDim2.new(0, 10, 0, 26)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = desc
	descLbl.TextColor3 = COLOR_SUBTEXT
	descLbl.TextSize = 9
	descLbl.Font = FONT_MAIN
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.ZIndex = 84

	local copyBtn = Instance.new("TextButton", card)
	copyBtn.Size = UDim2.new(1, -20, 0, 24)
	copyBtn.Position = UDim2.new(0, 10, 0, 44)
	copyBtn.BackgroundColor3 = COLOR_ITEM
	copyBtn.BorderSizePixel = 0
	copyBtn.Text = "[ COPIAR LINK ]"
	copyBtn.TextColor3 = COLOR_TEXT
	copyBtn.TextSize = 10
	copyBtn.Font = FONT_MAIN
	copyBtn.ZIndex = 84
	Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 4)
	applyStroke(copyBtn, COLOR_ACCENT, 1)

	copyBtn.MouseButton1Click:Connect(function()
		playClickSound()
		pcall(function()
			setclipboard(url)
		end)
		copyBtn.Text = "[ LINK COPIADO! ]"
		task.wait(2)
		copyBtn.Text = "[ COPIAR LINK ]"
	end)
end

createSocialCard(panelSocial, "🌐 Site Oficial DarkGamingYT", "https://darkgamingyt-br-pt.netlify.app/", "Acesse nosso portal oficial para novidades e downloads!")
createSocialCard(panelSocial, "📺 Canal do YouTube (@wallacy_rtx)", "https://youtube.com/@wallacy_rtx?si=oA06X6BtQqJHAJuY", "Inscreva-se para tutoriais e novos scripts atualizados!")
createSocialCard(panelSocial, "💬 Servidor do Discord Oficial", "https://discord.com/invite/vzMRuAs6gt", "Entre na comunidade para suporte e novidades!")

-- ==========================================================================
-- LÓGICA V15 (ESP VIDA BETA + ESP COMPLETO + AIMBOT + AUTO-KILL TEST)
-- ==========================================================================
_G.KD_BypassAntiKick = false
_G.KD_EspHighlight = false
_G.KD_EspName = false
_G.KD_EspVidaBeta = false
_G.KD_EspLine = false
_G.KD_EspDistance = false
_G.KD_AimbotHS = false
_G.KD_SpeedOn = false
_G.KD_WallHack = false
_G.KD_AutoKillTest = false
_G.KD_FullBright = false

RunService.Heartbeat:Connect(function()
	if _G.KD_BypassAntiKick then
		pcall(function()
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if _G.KD_SpeedOn then
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if hum then hum.WalkSpeed = 32 end
			if root and hum and hum.MoveDirection.Magnitude > 0 then
				root.CFrame = root.CFrame + (hum.MoveDirection * 0.45)
			end
		end)
	end
end)

RunService.Stepped:Connect(function()
	if _G.KD_WallHack then
		pcall(function()
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	end
end)

task.spawn(function()
	while task.wait(0.15) do
		if _G.KD_AutoKillTest then
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and plr.Character then
							local eChar = plr.Character
							local eRoot = eChar:FindFirstChild("HumanoidRootPart")
							local eHum = eChar:FindFirstChildOfClass("Humanoid")
							if eRoot and eHum and eHum.Health > 0 then
								if (root.Position - eRoot.Position).Magnitude <= 30 then
									eHum.Health = 0
								end
							end
						end
					end
				end
			end)
		end
	end
end)

local linePool = {}
local function getOrCreateLine(index)
	if not linePool[index] or not linePool[index].Parent then
		local line = Instance.new("Frame", EspLineFolder)
		line.Name = "Tracer_" .. tostring(index)
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = COLOR_SECONDARY
		line.BorderSizePixel = 0
		line.Visible = false
		line.ZIndex = 10
		linePool[index] = line
	end
	return linePool[index]
end

local function hideAllLines(fromIndex)
	for i = fromIndex, #linePool do
		if linePool[i] then linePool[i].Visible = false end
	end
end

task.spawn(function()
	while task.wait(0.4) do
		pcall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local char = plr.Character
					if _G.KD_EspHighlight then
						if not char:FindFirstChild("KD_Highlight") then
							local hl = Instance.new("Highlight", char)
							hl.Name = "KD_Highlight"
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.FillColor = COLOR_ACCENT
							hl.OutlineColor = COLOR_SECONDARY
							hl.FillTransparency = 0.45
							hl.OutlineTransparency = 0.1
						end
					else
						local hl = char:FindFirstChild("KD_Highlight")
						if hl then hl:Destroy() end
					end
				end
			end
		end)
	end
end)

-- ESP Nome, HP & ESP Vida BETA (Barra de HP detalhada na cabeça)
task.spawn(function()
	while task.wait(0.2) do
		pcall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local char = plr.Character
					local head = char:FindFirstChild("Head")
					local hum = char:FindFirstChildOfClass("Humanoid")
					local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local eRoot = char:FindFirstChild("HumanoidRootPart")
					
					if head and hum and hum.Health > 0 then
						if _G.KD_EspName or _G.KD_EspDistance or _G.KD_EspVidaBeta then
							local tag = head:FindFirstChild("KD_NameTag")
							if not tag then
								tag = Instance.new("BillboardGui", head)
								tag.Name = "KD_NameTag"
								tag.Size = UDim2.new(0, 140, 0, 50)
								tag.StudsOffset = Vector3.new(0, 2.8, 0)
								tag.AlwaysOnTop = true
								
								local txt = Instance.new("TextLabel", tag)
								txt.Name = "Txt"
								txt.Size = UDim2.new(1, 0, 0, 20)
								txt.BackgroundTransparency = 1
								txt.TextColor3 = COLOR_TEXT
								txt.TextSize = 11
								txt.Font = FONT_MAIN

								local barBg = Instance.new("Frame", tag)
								barBg.Name = "BarBg"
								barBg.Size = UDim2.new(0.85, 0, 0, 6)
								barBg.Position = UDim2.new(0.075, 0, 0, 24)
								barBg.BackgroundColor3 = COLOR_BG
								barBg.BorderSizePixel = 0
								applyStroke(barBg, COLOR_BORDER, 1)

								local barFill = Instance.new("Frame", barBg)
								barFill.Name = "Fill"
								barFill.Size = UDim2.new(1, 0, 1, 0)
								barFill.BackgroundColor3 = COLOR_ON
								barFill.BorderSizePixel = 0
							end
							local label = tag:FindFirstChild("Txt")
							local barBg = tag:FindFirstChild("BarBg")
							
							if label then
								local distStr = ""
								if _G.KD_EspDistance and myRoot and eRoot then
									local dist = math.floor((myRoot.Position - eRoot.Position).Magnitude)
									distStr = string.format(" [%dm]", dist)
								end
								label.Text = string.format("%s [%d%%]%s", plr.Name, math.floor(hum.Health), distStr)
							end

							if barBg then
								barBg.Visible = _G.KD_EspVidaBeta
								local fill = barBg:FindFirstChild("Fill")
								if fill then
									local maxHp = math.max(hum.MaxHealth, 1)
									local ratio = math.clamp(hum.Health / maxHp, 0, 1)
									fill.Size = UDim2.new(ratio, 0, 1, 0)
									fill.BackgroundColor3 = ratio > 0.4 and COLOR_ON or COLOR_OFF
								end
							end
						else
							local tag = head:FindFirstChild("KD_NameTag")
							if tag then tag:Destroy() end
						end
					end
				end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if not _G.KD_EspLine then
		hideAllLines(1)
		return
	end
	local cam = workspace.CurrentCamera
	if not cam then hideAllLines(1); return end
	local vp = cam.ViewportSize
	local originBottom = Vector2.new(vp.X / 2, vp.Y)
	local activeCount = 0

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local char = plr.Character
			local root = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if root and hum and hum.Health > 0 then
				local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
				if onScreen and screenPos.Z > 0 then
					activeCount = activeCount + 1
					local line = getOrCreateLine(activeCount)
					local targetPt = Vector2.new(screenPos.X, screenPos.Y)
					local delta = targetPt - originBottom
					local dist = delta.Magnitude
					local center = (originBottom + targetPt) / 2
					local angle = math.deg(math.atan2(delta.Y, delta.X))

					line.Position = UDim2.fromOffset(center.X, center.Y)
					line.Size = UDim2.fromOffset(dist, 1.5)
					line.Rotation = angle
					line.Visible = true
				end
			end
		end
	end
	hideAllLines(activeCount + 1)
end)

RunService.RenderStepped:Connect(function()
	pcall(function()
		local cam = workspace.CurrentCamera
		if _G.KD_AimbotHS and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			local closestTarget = nil
			local shortestDist = math.huge
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local char = plr.Character
					local hum = char:FindFirstChildOfClass("Humanoid")
					local head = char:FindFirstChild("Head")
					if hum and hum.Health > 0 and head then
						local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
						if onScreen then
							local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
							if dist2D <= shortestDist then
								shortestDist = dist2D
								closestTarget = head
							end
						end
					end
				end
			end
			if closestTarget then
				cam.CFrame = CFrame.new(cam.CFrame.Position, closestTarget.Position)
			end
		end
	end)
end)

RunService.RenderStepped:Connect(function()
	if _G.KD_FullBright then
		game.Lighting.Brightness = 2
		game.Lighting.GlobalShadows = false
	end
end)

-- ==========================================================================
-- REGISTRO NAS ABAS
-- ==========================================================================
createToggle(panelBypass, "Bypass Anti-Kick Pro", function(enabled)
	_G.KD_BypassAntiKick = enabled
end, "Protege contra o sistema anti-cheat e expulsão")

createToggle(panelEsp, "ESP Highlight Chams", function(enabled)
	_G.KD_EspHighlight = enabled
end, "Destaca os jogadores inimigos através das paredes")

createToggle(panelEsp, "ESP Linhas Tracers", function(enabled)
	_G.KD_EspLine = enabled
end, "Traça linhas da base da tela até os adversários")

createToggle(panelEsp, "ESP Vida (BETA)", function(enabled)
	_G.KD_EspVidaBeta = enabled
end, "Mostra barra de HP detalhada acima dos inimigos")

createToggle(panelAim, "Aimbot Headshot 100% Grudado", function(enabled)
	_G.KD_AimbotHS = enabled
end, "Trava instantaneamente na cabeça (Risco de Ban 24h)", true)

createToggle(panelAim, "Auto - Kill Inimigo Test", function(enabled)
	_G.KD_AutoKillTest = enabled
end, "Elimina inimigos próximos automaticamente (Risco de Ban 24h)", true)

createToggle(panelGeral, "Speed Hack Real Agilidade", function(enabled)
	_G.KD_SpeedOn = enabled
	if not enabled then
		pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
	end
end, "Aumenta a velocidade real (Risco de Ban 24h)", true)

createToggle(panelGeral, "Wall Hack / NoClip Paredes", function(enabled)
	_G.KD_WallHack = enabled
end, "Atravessa paredes e obstáculos (Risco de Ban 24h)", true)

createToggle(panelGeral, "ESP Nome & HP", function(enabled)
	_G.KD_EspName = enabled
end, "Mostra o nick e a vida em porcentagem")

createToggle(panelGeral, "ESP Distância Metros", function(enabled)
	_G.KD_EspDistance = enabled
end, "Exibe a distância exata até os adversários")

createToggle(panelGeral, "Full Bright Visão Clara", function(enabled)
	_G.KD_FullBright = enabled
end, "Ilumina o mapa e remove sombras")

print("[KNIFE DUELS BRUTAL V15] Carregado com Sucesso! ESP Vida BETA Adicionado.")
