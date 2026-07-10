local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", CoreGui)

local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LoadingFrame.ZIndex = 10

local LoadingBarBackground = Instance.new("Frame", LoadingFrame)
LoadingBarBackground.Size = UDim2.new(0, 200, 0, 4)
LoadingBarBackground.Position = UDim2.new(0.5, -100, 0.5, 0)
LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingBarBackground.BorderSizePixel = 0

local LoadingBar = Instance.new("Frame", LoadingBarBackground)
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LoadingBar.BorderSizePixel = 0

local Main = Instance.new("ScrollingFrame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Draggable = true
Main.Active = true
Main.Visible = false
Main.CanvasSize = UDim2.new(0, 0, 1.1, 0)
Main.ScrollBarThickness = 4
Main.ScrollBarImageColor3 = Color3.fromRGB(35, 35, 35)

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(25, 25, 25)
MainStroke.Thickness = 1

local States = {}
local FlySpeed = 20
local ActiveRemote = nil

-- Insert 키로 UI 토글
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Insert then
		Main.Visible = not Main.Visible
	end
end)

local function UpdateRemote()
	for _, obj in ipairs(RS:GetDescendants()) do
		if obj:IsA("RemoteEvent") and (#obj.Name > 3 or #obj:GetFullName() > 10) then
			ActiveRemote = obj
			return
		end
	end
end
UpdateRemote()

local cachedEnemies = {}
local function updateEnemyCache()
	local localTeam = LP.Team
	local newCache = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP then
			if localTeam then
				if player.Team ~= localTeam then
					table.insert(newCache, player)
				end
			else
				if player.Team ~= LP.Team then
					table.insert(newCache, player)
				end
			end
		end
	end
	cachedEnemies = newCache
end
Players.PlayerAdded:Connect(updateEnemyCache)
Players.PlayerRemoving:Connect(updateEnemyCache)
LP:GetPropertyChangedSignal("Team"):Connect(updateEnemyCache)
updateEnemyCache()

-- 레이지봇 집중 전용 초정밀 헤드 추적 필터
local function GetClosestEnemyHead()
	local closestHead = nil
	local maxDistance = math.huge
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	
	local myPos = root.Position
	local cam = workspace.CurrentCamera
	
	for i = 1, #cachedEnemies do
		local player = cachedEnemies[i]
		local eChar = player.Character
		if eChar then
			local eHead = eChar:FindFirstChild("Head")
			local eHum = eChar:FindFirstChildOfClass("Humanoid")
			
			-- 완전히 살아있는 상태의 적 헤드만 정밀 핀포인트 매칭
			if eHead and eHum and eHum.Health > 0 and eHead:IsA("BasePart") then
				local distance = (myPos - eHead.Position).Magnitude
				
				-- 레이지봇이 작동 중일 때는 벽 체크(Raycast) 과정을 아예 스킵하여 성능 낭비를 막음
				if not States["Lazy Bot"] and cam then
					local parts = cam:GetPartsObscuringTarget({myPos, eHead.Position}, {char, eChar})
					if #parts > 0 then
						continue 
					end
				end
				
				if distance < maxDistance then
					maxDistance = distance
					closestHead = eHead
				end
			end
		end
	end
	return closestHead
end

local function PlayWowSound()
	local sound = Instance.new("Sound", SoundService)
	sound.SoundId = "rbxassetid://9114223191"
	sound.Volume = 3
	sound:Play()
	sound.Ended:Connect(function() sound:Destroy() end)
end

local function AddBtn(name, callback)
	local btn = Instance.new("TextButton", Main)
	btn.Text = name
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, (#Main:GetChildren() - 3) * 40 + 10)
	btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	btn.TextColor3 = Color3.fromRGB(160, 160, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 4)
	
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Color3.fromRGB(25, 25, 25)
	btnStroke.Thickness = 1

	btn.MouseButton1Click:Connect(function()
		callback()
		if States[name] then
			if name == "Lazy Bot" then
				TweenService:Create(btn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(140, 5, 5), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				btnStroke.Color = Color3.fromRGB(255, 0, 0)
			else
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 12, 12), TextColor3 = Color3.fromRGB(255, 60, 60)}):Play()
				btnStroke.Color = Color3.fromRGB(60, 15, 15)
			end
		else
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(18, 18, 18), TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
			btnStroke.Color = Color3.fromRGB(25, 25, 25)
		end
	end)
end

local Features = {
	"Lazy Bot", "Aimbot", "SilentAim", "ESP", "Void Spam", "Fly", "Infinite Jump"
}

for _, f in pairs(Features) do
	States[f] = false
end

UserInputService.JumpRequest:Connect(function()
	if States["Infinite Jump"] then
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

local currentCamera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	currentCamera = workspace.CurrentCamera
end)

-- 프레임 동기화 루프
RunService.RenderStepped:Connect(function(deltaTime)
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if States["Fly"] and hum then
		root.Velocity = Vector3.new(0, 0, 0)
		local moveDir = hum.MoveDirection
		FlySpeed = math.min(FlySpeed + (40 * deltaTime), 200)
		root.CFrame = root.CFrame + (moveDir * FlySpeed * deltaTime)
	else
		FlySpeed = 20
	end

	-- 레이지봇 활성화 시 예외 없이 카메라 록온 연산 강제 고정
	if States["Lazy Bot"] or States["Aimbot"] or States["SilentAim"] then
		local targetHead = GetClosestEnemyHead()
		if targetHead and currentCamera then
			currentCamera.CFrame = CFrame.lookAt(currentCamera.CFrame.Position, targetHead.Position)
		end
	end

	-- ESP 추적 시스템
	if States["ESP"] then
		local myPos = root.Position
		for i = 1, #cachedEnemies do
			local player = cachedEnemies[i]
			local eChar = player.Character
			if eChar then
				local eRoot = eChar:FindFirstChild("HumanoidRootPart")
				if eRoot then
					local highlight = eChar:FindFirstChild("ESPHighlight")
					if not highlight then
						highlight = Instance.new("Highlight", eChar)
						highlight.Name = "ESPHighlight"
						highlight.FillColor = Color3.fromRGB(255, 0, 0)
						highlight.FillTransparency = 1
						highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
						highlight.OutlineTransparency = 0
						highlight.Adornee = eChar
					end
					
					local head = eChar:FindFirstChild("Head")
					if head then
						local bb = head:FindFirstChild("ESPMeters")
						if not bb then
							bb = Instance.new("BillboardGui", head)
							bb.Name = "ESPMeters"
							bb.Size = UDim2.new(0, 100, 0, 30)
							bb.AlwaysOnTop = true
							bb.ExtentsOffset = Vector3.new(0, 3, 0)
							
							local tl = Instance.new("TextLabel", bb)
							tl.Size = UDim2.new(1, 0, 1, 0)
							tl.BackgroundTransparency = 1
							tl.TextColor3 = Color3.fromRGB(255, 60, 60)
							tl.TextSize = 13
							tl.Font = Enum.Font.GothamBold
						end
						bb.TextLabel.Text = tostring(math.floor((myPos - eRoot.Position).Magnitude)) .. "m"
					end
				end
			end
		end
	else
		for i = 1, #cachedEnemies do
			local player = cachedEnemies[i]
			local eChar = player.Character
			if eChar then
				local high = eChar:FindFirstChild("ESPHighlight")
				if high then high:Destroy() end
				local head = eChar:FindFirstChild("Head")
				local meter = head and head:FindFirstChild("ESPMeters")
				if meter then meter:Destroy() end
			end
		end
	end
end)

-- [★레이지봇 전용 초집중 하이퍼 하트비트 인젝션 시스템★]
RunService.Heartbeat:Connect(function()
	if States["Lazy Bot"] then
		if not ActiveRemote then UpdateRemote() end
		if ActiveRemote then
			local targetHead = GetClosestEnemyHead()
			-- 타겟 머리 부위가 메모리상에 확실히 존재하고 소멸하지 않았는지 2중 검증
			if targetHead and targetHead:IsDescendantOf(workspace) then
				-- 한 프레임에 전송되는 타격 무차별 스팸 강도를 극대화 (3초 내 즉사 보장 코어)
				for i = 1, 40 do
					ActiveRemote:FireServer("Fire", targetHead.Position, math.random(1, 999))
				end
			end
		end
	end
end)

for _, f in pairs(Features) do
	AddBtn(f, function()
		States[f] = not States[f]
		
		if f == "Void Spam" and States["Void Spam"] then
			task.spawn(function()
				while States["Void Spam"] do
					local char = LP.Character
					local root = char and char:FindFirstChild("HumanoidRootPart")
					if root then
						root.CFrame = CFrame.new(0, 100000000000, 0)
					end
					task.wait(0.01)
				end
			end)
		end

		if States[f] and f ~= "Lazy Bot" and f ~= "Void Spam" then
			task.spawn(function()
				while States[f] do
					if not ActiveRemote then UpdateRemote() end
					if ActiveRemote then
						local targetHead = GetClosestEnemyHead()
						if targetHead and (f == "SilentAim" or f == "Aimbot") then
							ActiveRemote:FireServer("Fire", targetHead.Position, math.random(1, 999))
						else
							ActiveRemote:FireServer("Fire", math.random(1, 999))
						end
					end
					task.wait(0.005)
				end
			end)
		end
	end)
end

local function listenCharacter(player)
	player.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then
			hum.Died:Connect(function()
				local creator = hum:FindFirstChild("creator")
				if creator and creator.Value == LP then
					PlayWowSound()
				end
			end)
		end
	end)
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LP then listenCharacter(p) end
end
Players.PlayerAdded:Connect(listenCharacter)

local tweenLoad = TweenService:Create(LoadingBar, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)})
tweenLoad:Play()
tweenLoad.Completed:Connect(function()
	TweenService:Create(LoadingFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
	TweenService:Create(LoadingBarBackground, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
	TweenService:Create(LoadingBar, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
	task.wait(0.2)
	LoadingFrame:Destroy()
	Main.Visible = true
end)
