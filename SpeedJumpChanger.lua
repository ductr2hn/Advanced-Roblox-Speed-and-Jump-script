local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local originalWalkSpeed
local originalJumpValue
local originalJumpPropertyIsHeight

local function setupGui()
	local oldGui = player.PlayerGui:FindFirstChild("CustomGui")
	if oldGui then oldGui:Destroy() end

	originalWalkSpeed = humanoid.WalkSpeed
	if humanoid:GetAttribute("JumpHeight") ~= nil or humanoid.UseJumpPower == false then
		originalJumpPropertyIsHeight = true
		originalJumpValue = humanoid.JumpHeight
	else
		originalJumpPropertyIsHeight = false
		originalJumpValue = humanoid.JumpPower
	end

	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "CustomGui"
	screenGui.ResetOnSpawn = false

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 55)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, 220, 0, 220)
	mainFrame.Visible = false
	mainFrame.Active = true
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Color = Color3.fromRGB(0, 100, 255)
	mainStroke.Transparency = 1
	mainStroke.Thickness = 2
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local button = Instance.new("TextButton", screenGui)
	button.Name = "OpenButton"
	button.Text = "Menu"
	button.Position = UDim2.new(0.1, 0, 0.42, 0)
	button.Size = UDim2.new(0, 40, 0, 40)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 55)
	button.TextColor3 = Color3.fromRGB(0, 255, 255)
	button.Font = Enum.Font.Roboto
	button.TextSize = 14
	button.Active = true
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

	local uiStroke = Instance.new("UIStroke", button)
	uiStroke.Color = Color3.fromRGB(0, 100, 255)
	uiStroke.Transparency = 0.25
	uiStroke.Thickness = 2
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function createLabel(text, pos)
		local label = Instance.new("TextLabel", mainFrame)
		label.Text = text
		label.Position = pos
		label.Size = UDim2.new(0, 70, 0, 18)
		label.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 255)
		label.Font = Enum.Font.Roboto
		label.TextSize = 15
		Instance.new("UICorner", label).CornerRadius = UDim.new(0, 5)
		local stroke = Instance.new("UIStroke", label)
		stroke.Color = Color3.fromRGB(0, 255, 255)
		stroke.Transparency = 1
		stroke.Thickness = 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return label
	end

	local function createInput(pos, placeholder)
		local input = Instance.new("TextBox", mainFrame)
		input.PlaceholderText = placeholder
		input.Text = ""
		input.Position = pos
		input.Size = UDim2.new(0, 100, 0, 18)
		input.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
		input.BackgroundTransparency = 1
		input.TextTransparency = 1
		input.TextColor3 = Color3.fromRGB(0, 255, 255)
		input.Font = Enum.Font.Roboto
		input.TextSize = 13
		Instance.new("UICorner", input).CornerRadius = UDim.new(0, 5)
		local stroke = Instance.new("UIStroke", input)
		stroke.Color = Color3.fromRGB(0, 255, 255)
		stroke.Transparency = 1
		stroke.Thickness = 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return input
	end

	local function createButton(text, pos, size, bgColor, textColor, textSize)
		local btn = Instance.new("TextButton", mainFrame)
		btn.Text = text
		btn.Position = pos
		btn.Size = size
		btn.BackgroundColor3 = bgColor
		btn.BackgroundTransparency = 1
		btn.TextTransparency = 1
		btn.TextColor3 = textColor
		btn.Font = Enum.Font.Roboto
		btn.TextSize = textSize
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
		local stroke = Instance.new("UIStroke", btn)
		stroke.Color = textColor
		stroke.Transparency = 1
		stroke.Thickness = 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return btn
	end

	local speedLabel = createLabel("Speed", UDim2.new(0.1, 0, 0.08, 0))
	local speedInput = createInput(UDim2.new(0.45, 0, 0.08, 0), "Enter")
	local jumpLabel = createLabel("Jump", UDim2.new(0.1, 0, 0.23, 0))
	local jumpInput = createInput(UDim2.new(0.45, 0, 0.23, 0), "Enter")
	local setButton = createButton("Apply", UDim2.new(0.45, 0, 0.38, 0), UDim2.new(0, 100, 0, 22), Color3.fromRGB(0, 65, 0), Color3.fromRGB(0, 255, 0), 15)
	local langButton = createButton("Language", UDim2.new(0.1, 0, 0.38, 0), UDim2.new(0, 70, 0, 22), Color3.fromRGB(40, 40, 40), Color3.fromRGB(255, 255, 255), 15)
	local resetSpeedButton = createButton("Reset Speed", UDim2.new(0.1, 0, 0.56, 0), UDim2.new(0, 85, 0, 22), Color3.fromRGB(100, 0, 0), Color3.fromRGB(255, 0, 0), 13)
	local resetJumpButton = createButton("Reset Jump", UDim2.new(0.525, 0, 0.56, 0), UDim2.new(0, 85, 0, 22), Color3.fromRGB(100, 0, 0), Color3.fromRGB(255, 0, 0), 13)

	local langPanel = Instance.new("ScrollingFrame", mainFrame)
	langPanel.Name = "LanguagePanel"
	langPanel.Position = UDim2.new(0.1, 0, 0, 0)
	langPanel.Size = UDim2.new(0, 70, 0, 84)
	langPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 55)
	langPanel.BackgroundTransparency = 1
	langPanel.BorderSizePixel = 0
	langPanel.ScrollBarThickness = 0
	langPanel.CanvasSize = UDim2.new(0, 0, 0, 286)
	langPanel.Visible = false
	langPanel.ZIndex = 10
	Instance.new("UICorner", langPanel).CornerRadius = UDim.new(0, 5)

	local langPanelStroke = Instance.new("UIStroke", langPanel)
	langPanelStroke.Color = Color3.fromRGB(255, 255, 255)
	langPanelStroke.Transparency = 1
	langPanelStroke.Thickness = 1
	langPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local languages = {
		{code = "en", text = "English"},
		{code = "vi", text = "Việt Nam"},
		{code = "es", text = "España"},
		{code = "fr", text = "France"},
		{code = "de", text = "Deutschland"},
		{code = "zh", text = "中国"},
		{code = "hk", text = "香港"},
		{code = "ja", text = "日本"},
		{code = "ko", text = "한국"},
		{code = "th", text = "ไทย"},
		{code = "ru", text = "Россия"},
		{code = "uk", text = "Україна"},
		{code = "ms", text = "Malaysia"}
	}

	local langButtons = {}
	for i, lang in ipairs(languages) do
		local btn = Instance.new("TextButton", langPanel)
		btn.Name = lang.code.."Btn"
		btn.Text = lang.text
		btn.Position = UDim2.new(0, 0, 0, (i-1) * 22)
		btn.Size = UDim2.new(1, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.Roboto
		btn.TextSize = 13
		btn.ZIndex = 11
		langButtons[lang.code] = btn
	end

	local hoverIndicator = Instance.new("Frame", langPanel)
	hoverIndicator.Size = UDim2.new(1, 0, 0, 22)
	hoverIndicator.Position = UDim2.new(0, 0, 0, 0)
	hoverIndicator.BackgroundTransparency = 1
	hoverIndicator.ZIndex = 10
	Instance.new("UICorner", hoverIndicator).CornerRadius = UDim.new(0, 5)

	local hoverStroke = Instance.new("UIStroke", hoverIndicator)
	hoverStroke.Color = Color3.fromRGB(255, 255, 255)
	hoverStroke.Transparency = 1
	hoverStroke.Thickness = 2
	hoverStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local notificationLabel = Instance.new("TextLabel", mainFrame)
	notificationLabel.Text = ""
	notificationLabel.Position = UDim2.new(0.1, 0, 0.71, 0)
	notificationLabel.Size = UDim2.new(0, 177, 0, 38)
	notificationLabel.BackgroundColor3 = Color3.fromRGB(0, 40, 120)
	notificationLabel.BackgroundTransparency = 1
	notificationLabel.TextTransparency = 1
	notificationLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
	notificationLabel.Font = Enum.Font.Roboto
	notificationLabel.TextSize = 12
	notificationLabel.TextWrapped = true
	notificationLabel.TextXAlignment = Enum.TextXAlignment.Center
	notificationLabel.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", notificationLabel).CornerRadius = UDim.new(0, 5)

	local notifStroke = Instance.new("UIStroke", notificationLabel)
	notifStroke.Color = Color3.fromRGB(0, 255, 255)
	notifStroke.Transparency = 1
	notifStroke.Thickness = 1
	notifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local infoDisplay = Instance.new("TextLabel", mainFrame)
	infoDisplay.Name = "InfoDisplay"
	local _p1 = {77,97}
	local _p2 = {100,101}
	local _p3 = {32,98,121,32}
	local _p4 = {100,117,99}
	local _p5 = {116,114,50,104,110}
	local _d1 = string.char
	local _d2 = table.concat
	local _result = {}
	for _,chunk in pairs({_p1,_p2,_p3,_p4,_p5}) do
		for _,byte in pairs(chunk) do
			table.insert(_result, _d1(byte))
		end
	end

	infoDisplay.Text = _d2(_result)
	infoDisplay.Position = UDim2.new(0.5, 0, 0.91, 0)
	infoDisplay.AnchorPoint = Vector2.new(0.5, 0)
	infoDisplay.Size = UDim2.new(0, 140, 0, 14)
	infoDisplay.BackgroundTransparency = 1
	infoDisplay.TextTransparency = 1
	infoDisplay.TextColor3 = Color3.fromRGB(0, 255, 255)
	infoDisplay.Font = Enum.Font.Roboto
	infoDisplay.TextSize = 10
	infoDisplay.TextXAlignment = Enum.TextXAlignment.Center

	local isAnimating = false
	local langPanelOpen = false
	local currentLanguage = "en"
	local currentNotifFadeOut = nil
	local antiKickEnabled = true
	local lastSpeed = originalWalkSpeed
	local lastJump = originalJumpValue
	local checkInterval = 0.05
	local detectionCount = 0
	local maxDetections = 5
	local bypassMode = true
	local systemSafe = nil
	local hasTestedSystem = false
	local isTesting = false

	local translations = {
		en = {speed = "Speed", jump = "Jump", apply = "Apply", language = "Language", resetSpeed = "Reset Speed", resetJump = "Reset Jump", applied = "Applied successfully!", resetSpeedMsg = "Speed reset!", resetJumpMsg = "Jump reset!", placeholder = "Enter", langChanged = "Changed to English!", invalidSpeed = "Invalid speed value!", invalidJump = "Invalid jump value!", invalidBoth = "Invalid values!", testing = "Testing anti-cheat system...", testPassed = "System safe! Values applied!", testFailed = "DANGER! Anti-cheat detected!", scrollHint = "Scroll or swipe to see more languages"},
		vi = {speed = "Tốc độ", jump = "Độ nhảy", apply = "Áp dụng", language = "Ngôn ngữ", resetSpeed = "Reset Tốc Độ", resetJump = "Reset Độ Nhảy", applied = "Đã áp dụng thành công!", resetSpeedMsg = "Đã reset tốc độ!", resetJumpMsg = "Đã reset độ nhảy!", placeholder = "Nhập", langChanged = "Đã đổi sang Tiếng Việt!", invalidSpeed = "Tốc độ không hợp lệ!", invalidJump = "Độ nhảy không hợp lệ!", invalidBoth = "Giá trị không hợp lệ!", testing = "Đang test hệ thống anti-cheat...", testPassed = "Hệ thống an toàn! Đã áp dụng!", testFailed = "NGUY HIỂM! Phát hiện anti-cheat!", scrollHint = "Cuộn hoặc vuốt để xem ngôn ngữ khác"},
		es = {speed = "Velocidad", jump = "Salto", apply = "Aplicar", language = "Idioma", resetSpeed = "Reset Velocidad", resetJump = "Reset Salto", applied = "¡Aplicado con éxito!", resetSpeedMsg = "¡Velocidad reiniciada!", resetJumpMsg = "¡Salto reiniciado!", placeholder = "Entrar", langChanged = "¡Cambiado a Español!", invalidSpeed = "¡Valor de velocidad inválido!", invalidJump = "¡Valor de salto inválido!", invalidBoth = "¡Valores inválidos!", testing = "Probando anti-cheat...", testPassed = "¡Sistema seguro! ¡Aplicado!", testFailed = "¡PELIGRO! ¡Anti-cheat detectado!", scrollHint = "Desliza para ver más idiomas"},
		fr = {speed = "Vitesse", jump = "Saut", apply = "Appliquer", language = "Langue", resetSpeed = "Reset Vitesse", resetJump = "Reset Saut", applied = "Appliqué avec succès!", resetSpeedMsg = "Vitesse réinitialisée!", resetJumpMsg = "Saut réinitialisé!", placeholder = "Entrer", langChanged = "Passé en Français!", invalidSpeed = "Valeur de vitesse invalide!", invalidJump = "Valeur de saut invalide!", invalidBoth = "Valeurs invalides!", testing = "Test anti-cheat...", testPassed = "Système sûr! Appliqué!", testFailed = "DANGER! Anti-cheat détecté!", scrollHint = "Faites défiler pour plus de langues"},
		de = {speed = "Tempo", jump = "Sprung", apply = "Anwenden", language = "Sprache", resetSpeed = "Reset Tempo", resetJump = "Reset Sprung", applied = "Erfolgreich angewendet!", resetSpeedMsg = "Tempo zurückgesetzt!", resetJumpMsg = "Sprung zurückgesetzt!", placeholder = "Eingeben", langChanged = "Auf Deutsch geändert!", invalidSpeed = "Ungültiger Tempowert!", invalidJump = "Ungültiger Sprungwert!", invalidBoth = "Ungültige Werte!", testing = "Anti-cheat testen...", testPassed = "System sicher! Angewendet!", testFailed = "GEFAHR! Anti-cheat erkannt!", scrollHint = "Scrollen Sie für weitere Sprachen"},
		zh = {speed = "速度", jump = "跳跃", apply = "应用", language = "语言", resetSpeed = "重置速度", resetJump = "重置跳跃", applied = "应用成功！", resetSpeedMsg = "速度已重置！", resetJumpMsg = "跳跃已重置！", placeholder = "输入", langChanged = "已切换到中文！", invalidSpeed = "无效的速度值！", invalidJump = "无效的跳跃值！", invalidBoth = "无效的值！", testing = "正在测试反作弊...", testPassed = "系统安全！已应用！", testFailed = "危险！检测到反作弊！", scrollHint = "滚动查看更多语言"},
		hk = {speed = "速度", jump = "跳躍", apply = "應用", language = "語言", resetSpeed = "重設速度", resetJump = "重設跳躍", applied = "應用成功！", resetSpeedMsg = "速度已重設！", resetJumpMsg = "跳躍已重設！", placeholder = "輸入", langChanged = "已切換到粵語！", invalidSpeed = "無效嘅速度值！", invalidJump = "無效嘅跳躍值！", invalidBoth = "無效嘅值！", testing = "測試緊反作弊...", testPassed = "系統安全！已應用！", testFailed = "危險！檢測到反作弊！", scrollHint = "捲動查看更多語言"},
		ja = {speed = "速度", jump = "ジャンプ", apply = "適用", language = "言語", resetSpeed = "速度リセット", resetJump = "ジャンプリセット", applied = "適用しました！", resetSpeedMsg = "速度をリセットしました！", resetJumpMsg = "ジャンプをリセットしました！", placeholder = "入力", langChanged = "日本語に変更しました！", invalidSpeed = "無効な速度の値です！", invalidJump = "無効なジャンプの値です！", invalidBoth = "無効な値です！", testing = "アンチチートをテスト中...", testPassed = "システム安全！適用完了！", testFailed = "危険！アンチチート検出！", scrollHint = "スクロールして他の言語を表示"},
		ko = {speed = "속도", jump = "점프", apply = "적용", language = "언어", resetSpeed = "속도 초기화", resetJump = "점프 초기화", applied = "적용되었습니다!", resetSpeedMsg = "속도가 초기화되었습니다!", resetJumpMsg = "점프가 초기화되었습니다!", placeholder = "입력", langChanged = "한국어로 변경되었습니다!", invalidSpeed = "유효하지 않은 속도 값입니다!", invalidJump = "유효하지 않은 점프 값입니다!", invalidBoth = "유효하지 않은 값입니다!", testing = "안티치트 테스트 중...", testPassed = "시스템 안전! 적용 완료!", testFailed = "위험! 안티치트 감지!", scrollHint = "스크롤하여 더 많은 언어 보기"},
		th = {speed = "ความเร็ว", jump = "กระโดด", apply = "ใช้", language = "ภาษา", resetSpeed = "รีเซ็ตความเร็ว", resetJump = "รีเซ็ตกระโดด", applied = "ใช้สำเร็จ!", resetSpeedMsg = "รีเซ็ตความเร็วแล้ว!", resetJumpMsg = "รีเซ็ตการกระโดดแล้ว!", placeholder = "ป้อน", langChanged = "เปลี่ยนเป็นภาษาไทยแล้ว!", invalidSpeed = "ค่าความเร็วไม่ถูกต้อง!", invalidJump = "ค่าการกระโดดไม่ถูกต้อง!", invalidBoth = "ค่าไม่ถูกต้อง!", testing = "กำลังทดสอบแอนตี้โกง...", testPassed = "ระบบปลอดภัย! ใช้แล้ว!", testFailed = "อันตราย! ตรวจพบแอนตี้โกง!", scrollHint = "เลื่อนเพื่อดูภาษาอื่น"},
		ru = {speed = "Скорость", jump = "Прыжок", apply = "Применить", language = "Язык", resetSpeed = "Сброс скорости", resetJump = "Сброс прыжка", applied = "Успешно применено!", resetSpeedMsg = "Скорость сброшена!", resetJumpMsg = "Прыжок сброшен!", placeholder = "Ввод", langChanged = "Изменено на русский!", invalidSpeed = "Неверное значение скорости!", invalidJump = "Неверное значение прыжка!", invalidBoth = "Неверные значения!", testing = "Тестирование анти-чита...", testPassed = "Система безопасна! Применено!", testFailed = "ОПАСНО! Обнаружен анти-чит!", scrollHint = "Прокрутите для других языков"},
		uk = {speed = "Швидкість", jump = "Стрибок", apply = "Застосувати", language = "Мова", resetSpeed = "Скинути швидкість", resetJump = "Скинути стрибок", applied = "Успішно застосовано!", resetSpeedMsg = "Швидкість скинуто!", resetJumpMsg = "Стрибок скинуto!", placeholder = "Ввести", langChanged = "Змінено на українську!", invalidSpeed = "Невірне значення швидкості!", invalidJump = "Невірне значення стрибка!", invalidBoth = "Невірні значення!", testing = "Тестування анті-чіту...", testPassed = "Система безпечна! Застосовано!", testFailed = "НЕБЕЗПЕЧНО! Виявлено анті-чіт!", scrollHint = "Прокрутіть для інших мов"},
		ms = {speed = "Kelajuan", jump = "Lompat", apply = "Guna", language = "Bahasa", resetSpeed = "Reset Laju", resetJump = "Reset Lompat", applied = "Berjaya digunakan!", resetSpeedMsg = "Kelajuan diset semula!", resetJumpMsg = "Lompatan diset semula!", placeholder = "Masukkan", langChanged = "Ditukar kepada Bahasa Melayu!", invalidSpeed = "Nilai kelajuan tidak sah!", invalidJump = "Nilai lompatan tidak sah!", invalidBoth = "Nilai không sah!", testing = "Menguji anti-cheat...", testPassed = "Sistem selamat! Digunakan!", testFailed = "BAHAYA! Anti-cheat dikesan!", scrollHint = "Tatal untuk lihat bahasa lain"}
	}

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function animateUI(direction, callback)
		if isAnimating then return end
		isAnimating = true
		local isFadingIn = direction == "In"
		local targetTrans, targetStrokeTrans = isFadingIn and 0 or 1, isFadingIn and 0.25 or 1

		if isFadingIn then mainFrame.Visible = true end
		TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = targetTrans}):Play()
		TweenService:Create(mainStroke, tweenInfo, {Transparency = isFadingIn and 0.5 or 1}):Play()

		for _, child in ipairs(mainFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Name ~= "InfoDisplay" and child.Name ~= "NotificationLabel" and child.Name ~= "LanguagePanel" then
				if child:IsA("TextButton") or child:IsA("TextBox") then child.Active = isFadingIn end
				TweenService:Create(child, tweenInfo, {BackgroundTransparency = targetTrans, TextTransparency = targetTrans}):Play()
				local stroke = child:FindFirstChildOfClass("UIStroke")
				if stroke then TweenService:Create(stroke, tweenInfo, {Transparency = targetStrokeTrans}):Play() end
			elseif child.Name == "InfoDisplay" then
				TweenService:Create(child, tweenInfo, {TextTransparency = targetTrans}):Play()
			elseif child.Name == "NotificationLabel" then
				TweenService:Create(child, tweenInfo, {BackgroundTransparency = targetTrans}):Play()
				TweenService:Create(notifStroke, tweenInfo, {Transparency = targetStrokeTrans}):Play()
			end
		end

		task.delay(tweenInfo.Time, function()
			if not isFadingIn then mainFrame.Visible = false end
			if callback then callback() end
			isAnimating = false
		end)
	end

	local function slimeBounce()
		local squeezeTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 35, 0, 35)})
		local bounceTween = TweenService:Create(button, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 40, 0, 40)})
		squeezeTween:Play()
		squeezeTween.Completed:Connect(function() bounceTween:Play() end)
	end

	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local function showNotification(msg, textColor, strokeColor)
		if currentNotifFadeOut then task.cancel(currentNotifFadeOut) currentNotifFadeOut = nil end
		notificationLabel.Text = msg
		notificationLabel.TextColor3 = textColor
		notifStroke.Color = strokeColor
		notificationLabel.TextTransparency = 0
		currentNotifFadeOut = task.delay(5, function()
			TweenService:Create(notificationLabel, fadeInfo, {TextTransparency = 1}):Play()
			task.wait(0.5)
			notificationLabel.Text = ""
			notificationLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
			notifStroke.Color = Color3.fromRGB(0, 255, 255)
			currentNotifFadeOut = nil
		end)
	end

	local function updateLanguage(lang)
		currentLanguage = lang
		local t = translations[lang]
		speedLabel.Text, jumpLabel.Text, setButton.Text, langButton.Text = t.speed, t.jump, t.apply, t.language
		resetSpeedButton.Text, resetJumpButton.Text = t.resetSpeed, t.resetJump
		speedInput.PlaceholderText, jumpInput.PlaceholderText = t.placeholder, t.placeholder
		showNotification(t.langChanged, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
	end

	local function toggleLanguagePanel()
		langPanelOpen = not langPanelOpen
		local expandInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local collapseInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		if langPanelOpen then
			langPanel.ZIndex = 10
			hoverIndicator.ZIndex = 10
			for _, btn in pairs(langButtons) do btn.ZIndex = 11 end
			langPanel.BackgroundTransparency, langPanelStroke.Transparency = 1, 1
			langPanel.Visible = true
			TweenService:Create(langPanel, expandInfo, {BackgroundTransparency = 0}):Play()
			TweenService:Create(langPanelStroke, expandInfo, {Transparency = 0.25}):Play()
			showNotification(translations[currentLanguage].scrollHint, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
		else
			TweenService:Create(langPanel, collapseInfo, {BackgroundTransparency = 1}):Play()
			TweenService:Create(langPanelStroke, collapseInfo, {Transparency = 1}):Play()
			task.delay(collapseInfo.Time, function() langPanel.Visible = false end)
		end
	end

	local function selectLanguage(lang, btn)
		local squeezeTween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 20)})
		local bounceTween = TweenService:Create(btn, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 22)})
		local flashTween = TweenService:Create(hoverStroke, TweenInfo.new(0.1), {Transparency = 0})
		local fadeFlash = TweenService:Create(hoverStroke, TweenInfo.new(0.3), {Transparency = 1})
		squeezeTween:Play()
		flashTween:Play()
		flashTween.Completed:Connect(function() fadeFlash:Play() end)
		squeezeTween.Completed:Connect(function()
			bounceTween:Play()
			updateLanguage(lang)
			task.wait(0.2)
			toggleLanguagePanel()
		end)
	end

	local function isValidNumber(text)
		if text == "" or text == nil then return false end
		local num = tonumber(text)
		return num ~= nil and num >= 0
	end

	-- Smart anti-cheat system
	local function testAntiCheatSystem(targetSpeed, targetJump, callback)
		if isTesting then return end
		isTesting = true
		hasTestedSystem = true

		local t = translations[currentLanguage]
		showNotification(t.testing, Color3.fromRGB(100, 200, 255), Color3.fromRGB(100, 200, 255))
		local testSpeed = originalWalkSpeed * 1.2
		local testJump = originalJumpValue * 1.2

		local savedSpeed = humanoid.WalkSpeed
		local savedJump = originalJumpPropertyIsHeight and humanoid.JumpHeight or humanoid.JumpPower
		humanoid.WalkSpeed = testSpeed
		if originalJumpPropertyIsHeight then
			humanoid.JumpHeight = testJump
		else
			humanoid.JumpPower = testJump
		end

		task.wait(2)
		local currentSpeed = humanoid.WalkSpeed
		local currentJump = originalJumpPropertyIsHeight and humanoid.JumpHeight or humanoid.JumpPower

		local speedChanged = math.abs(currentSpeed - testSpeed) > 0.5
		local jumpChanged = math.abs(currentJump - testJump) > 0.5

		if speedChanged or jumpChanged then
			-- Anti-cheat detected ! Danger notify !
			systemSafe = false
			humanoid.WalkSpeed = originalWalkSpeed
			if originalJumpPropertyIsHeight then
				humanoid.JumpHeight = originalJumpValue
			else
				humanoid.JumpPower = originalJumpValue
			end
			showNotification(t.testFailed, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
			antiKickEnabled = false
			bypassMode = false
		else
			-- Safe anti-cheat notification !
			systemSafe = true
			if targetSpeed then
				humanoid.WalkSpeed = targetSpeed
				lastSpeed = targetSpeed
			else
				humanoid.WalkSpeed = savedSpeed
			end

			if targetJump then
				if originalJumpPropertyIsHeight then
					humanoid.JumpHeight = targetJump
				else
					humanoid.JumpPower = targetJump
				end
				lastJump = targetJump
			else
				if originalJumpPropertyIsHeight then
					humanoid.JumpHeight = savedJump
				else
					humanoid.JumpPower = savedJump
				end
			end

			showNotification(t.testPassed, Color3.fromRGB(0, 255, 100), Color3.fromRGB(0, 255, 100))
		end

		isTesting = false
		if callback then callback() end
	end

	local function smartAntiKickMonitor()
		task.spawn(function()
			while antiKickEnabled and humanoid and humanoid.Parent do
				task.wait(checkInterval)
				if not bypassMode or isTesting or not hasTestedSystem then continue end

				local currentSpeed = humanoid.WalkSpeed
				local currentJump = originalJumpPropertyIsHeight and humanoid.JumpHeight or humanoid.JumpPower

				if lastSpeed ~= originalWalkSpeed and math.abs(currentSpeed - originalWalkSpeed) < 0.1 then
					detectionCount = detectionCount + 1

					if detectionCount >= maxDetections then
						bypassMode, antiKickEnabled = false, false
						humanoid.WalkSpeed = originalWalkSpeed
						if originalJumpPropertyIsHeight then humanoid.JumpHeight = originalJumpValue
						else humanoid.JumpPower = originalJumpValue end
						showNotification(translations[currentLanguage].testFailed, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
						lastSpeed, lastJump = originalWalkSpeed, originalJumpValue
						systemSafe = false
						break
					else
						local randomDelay = math.random(10, 80) / 1000
						task.wait(randomDelay)
						local targetSpeed = lastSpeed
						for i = 1, 3 do
							humanoid.WalkSpeed = originalWalkSpeed + (targetSpeed - originalWalkSpeed) * (i / 3)
							task.wait(0.01)
						end
					end
				end

				if lastJump ~= originalJumpValue and math.abs(currentJump - originalJumpValue) < 0.1 then
					detectionCount = detectionCount + 1

					if detectionCount >= maxDetections then
						bypassMode, antiKickEnabled = false, false
						humanoid.WalkSpeed = originalWalkSpeed
						if originalJumpPropertyIsHeight then humanoid.JumpHeight = originalJumpValue
						else humanoid.JumpPower = originalJumpValue end
						showNotification(translations[currentLanguage].testFailed, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
						lastSpeed, lastJump = originalWalkSpeed, originalJumpValue
						systemSafe = false
						break
					else
						local randomDelay = math.random(10, 80) / 1000
						task.wait(randomDelay)
						local targetJump = lastJump
						for i = 1, 3 do
							if originalJumpPropertyIsHeight then
								humanoid.JumpHeight = originalJumpValue + (targetJump - originalJumpValue) * (i / 3)
							else
								humanoid.JumpPower = originalJumpValue + (targetJump - originalJumpValue) * (i / 3)
							end
							task.wait(0.01)
						end
					end
				end

				if detectionCount > 0 and math.abs(currentSpeed - lastSpeed) < 0.1 and math.abs(currentJump - lastJump) < 0.1 then
					task.wait(3)
					detectionCount = math.max(0, detectionCount - 1)
				end
			end
		end)
	end

	smartAntiKickMonitor()

	button.MouseButton1Click:Connect(function()
		if isAnimating then return end
		slimeBounce()
		if not mainFrame.Visible then animateUI("In")
		else animateUI("Out", function() if langPanelOpen then toggleLanguagePanel() end end) end
	end)

	button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 80, 255)}):Play() end)
	button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 0, 55)}):Play() end)

	setButton.MouseButton1Click:Connect(function()
		local t = translations[currentLanguage]
		local speedText, jumpText = speedInput.Text, jumpInput.Text
		local speedValid, jumpValid = isValidNumber(speedText), isValidNumber(jumpText)
		local speedEmpty, jumpEmpty = speedText == "", jumpText == ""

		if not speedEmpty and not speedValid and not jumpEmpty and not jumpValid then
			showNotification(t.invalidBoth, Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 200, 0))
		elseif not speedEmpty and not speedValid then
			showNotification(t.invalidSpeed, Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 200, 0))
		elseif not jumpEmpty and not jumpValid then
			showNotification(t.invalidJump, Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 200, 0))
		else
			local targetSpeed = speedValid and tonumber(speedText) or nil
			local targetJump = jumpValid and tonumber(jumpText) or nil

			-- Anti-cheat test
			if not hasTestedSystem then
				testAntiCheatSystem(targetSpeed, targetJump)
			else
				if speedValid then 
					humanoid.WalkSpeed = targetSpeed
					lastSpeed = targetSpeed
				end
				if jumpValid then
					if originalJumpPropertyIsHeight then
						humanoid.JumpHeight = targetJump
					else
						humanoid.JumpPower = targetJump
					end
					lastJump = targetJump
				end
				showNotification(t.applied, Color3.fromRGB(0, 255, 100), Color3.fromRGB(0, 255, 100))
			end
		end
	end)

	resetSpeedButton.MouseButton1Click:Connect(function()
		humanoid.WalkSpeed = originalWalkSpeed
		lastSpeed = originalWalkSpeed
		showNotification(translations[currentLanguage].resetSpeedMsg, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 100, 100))
	end)

	resetJumpButton.MouseButton1Click:Connect(function()
		if originalJumpPropertyIsHeight then humanoid.JumpHeight = originalJumpValue
		else humanoid.JumpPower = originalJumpValue end
		lastJump = originalJumpValue
		showNotification(translations[currentLanguage].resetJumpMsg, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 100, 100))
	end)

	langButton.MouseButton1Click:Connect(toggleLanguagePanel)

	local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for code, btn in pairs(langButtons) do
		btn.MouseEnter:Connect(function()
			if langPanelOpen then
				TweenService:Create(hoverIndicator, hoverTweenInfo, {Position = btn.Position}):Play()
				TweenService:Create(hoverStroke, hoverTweenInfo, {Transparency = 0.3}):Play()
			end
		end)
		btn.MouseButton1Click:Connect(function() selectLanguage(code, btn) end)
	end

	langPanel.MouseLeave:Connect(function() TweenService:Create(hoverStroke, hoverTweenInfo, {Transparency = 1}):Play() end)

	-- Drag functionality
	local dragging, dragInput, dragStart, startPos
	local dragConnection, inputConnection
	local buttonDragging, buttonDragStart, buttonStartPos
	local buttonInputConnection

	mainFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position

			inputConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if inputConnection then
						inputConnection:Disconnect()
						inputConnection = nil
					end
					if dragConnection then
						dragConnection:Disconnect()
						dragConnection = nil
					end
				end
			end)
		end
	end)

	button.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			buttonDragging = true
			buttonDragStart = input.Position
			buttonStartPos = button.Position

			buttonInputConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					buttonDragging = false
					if buttonInputConnection then
						buttonInputConnection:Disconnect()
						buttonInputConnection = nil
					end
				end
			end)
		end
	end)

	mainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

			-- Smooth drag
			TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = newPos}):Play()
		elseif buttonDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - buttonDragStart
			local newPos = UDim2.new(
				buttonStartPos.X.Scale,
				buttonStartPos.X.Offset + delta.X,
				buttonStartPos.Y.Scale,
				buttonStartPos.Y.Offset + delta.Y
			)

			TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = newPos}):Play()
		end
	end)
end

player.CharacterAdded:Connect(function(newChar) 
	character = newChar 
	humanoid = character:WaitForChild("Humanoid") 
	setupGui()
end)

setupGui()
