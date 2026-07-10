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
Main.Size = UDim2.new(0, 260, 0, 450)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Draggable = true
Main.Active = true
Main.Visible = false
Main.CanvasSize = UDim2.new(0, 0, 3, 0)
Main.ScrollBarThickness = 4
Main.ScrollBarImageColor3 = Color3.fromRGB(35, 35, 35)

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(25, 25, 25)
MainStroke.Thickness = 1

local States = {}
local FlySpeed = 20
local DeviceMode = "PC"
local ActiveRemote = nil

local function UpdateRemote()
	for _, obj in ipairs(RS:GetDescendants()) do
		if obj:IsA("RemoteEvent") and #obj:GetFullName() > 10 then
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

local function GetClosestEnemy()
	local closestTarget = nil
	local maxDistance = math.huge
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	
	local myPos = root.Position
	for i = 1, #cachedEnemies do
		local player = cachedEnemies[i]
		local eChar = player.Character
		if eChar then
			local eRoot = eChar:FindFirstChild("Head") or eChar:FindFirstChild("HumanoidRootPart")
			local eHum = eChar:FindFirstChildOfClass("Humanoid")
			if eRoot and eHum and eHum.Health > 0 then
				local distance = (myPos - eRoot.Position).Magnitude
				if distance < maxDistance then
					maxDistance = distance
					closestTarget = eChar
				end
			end
		end
	end
	return closestTarget
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
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 12, 12), TextColor3 = Color3.fromRGB(255, 60, 60)}):Play()
			btnStroke.Color = Color3.fromRGB(60, 15, 15)
		else
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(18, 18, 18), TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
			btnStroke.Color = Color3.fromRGB(25, 25, 25)
		end
	end)
end

local Features = {
	"Aimbot", "SilentAim", "Rapid Fire", "ESP", "Infinite Jump", "Fly", "Anti Aim", "Void Spam", 
	"Bypass Bow", "Bypass Dagger", "Bypass Slingshot", "Player Aura", "Hit Sound", "Fake Lag", 
	"Ping Changer", "FPS Changer", "Name Spoofer", "ELO Spoofer", "Device Spoofer", "Win Streak Spoofer"
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

RunService.RenderStepped:Connect(function(deltaTime)
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if States["Fly"] and hum then
		root.Velocity = Vector3.new(0, 0, 0)
		local moveDir = Vector3.new(0,0,0)
		if DeviceMode == "PC" then
			moveDir = hum.MoveDirection
		else
			if currentCamera then moveDir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection or currentCamera.CFrame.LookVector end
		end
		FlySpeed = math.min(FlySpeed + (40 * deltaTime), 200)
		root.CFrame = root.CFrame + (moveDir * FlySpeed * deltaTime)
	else
		FlySpeed = 20
	end

	if States["Aimbot"] or States["SilentAim"] then
		local target = GetClosestEnemy()
		if target then
			local tPart = target:FindFirstChild("Head")
			if tPart and currentCamera then
				currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, tPart.Position)
			end
		end
	end

	if States["Anti Aim"] then
		root.CFrame = root.CFrame * CFrame.Angles(0, 0.8, 0)
	end

	if States["Player Aura"] then
		local myPos = root.Position
		for i = 1, #cachedEnemies do
			local p = cachedEnemies[i]
			local eChar = p.Character
			if eChar then
				local eRoot = eChar:FindFirstChild("HumanoidRootPart")
				local eHum = eChar:FindFirstChildOfClass("Humanoid")
				if eRoot and eHum and (myPos - eRoot.Position).Magnitude < 30 then
					eHum:TakeDamage(25)
				end
			end
		end
	end

	if States["ESP"] then
		local myPos = root.Position
		for i = 1, #cachedEnemies do
			local player = cachedEnemies[i]
			local eChar = player.Character
			if eChar then
				local eRoot = eChar:FindFirstChild("HumanoidRootPart")
				if eRoot then
					if not eChar:FindFirstChild("ESPHighlight") then
						local highlight = Instance.new("Highlight", eChar)
						highlight.Name = "ESPHighlight"
						highlight.FillColor = Color3.fromRGB(255, 0, 0)
						highlight.FillTransparency = 0.6
						highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
						highlight.OutlineTransparency = 0
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

		if f == "Device Spoofer" then
			DeviceMode = (DeviceMode == "PC") and "Mobile" or "PC"
		end

		if States[f] then
			task.spawn(function()
				while States[f] do
					if not ActiveRemote then UpdateRemote() end
					if ActiveRemote then
						if f == "Rapid Fire" then
							for i = 1, 45 do
								local target = GetClosestEnemy()
								local targetHead = target and target:FindFirstChild("Head")
								if targetHead then
									ActiveRemote:FireServer("Fire", targetHead.Position, math.random(1, 999))
								else
									ActiveRemote:FireServer("Fire", math.random(1, 999))
								end
							end
						elseif f == "Hit Sound" then
							PlayWowSound()
						elseif f == "Bypass Bow" or f == "Bypass Dagger" or f == "Bypass Slingshot" then
							ActiveRemote:FireServer("Equip", f:gsub("Bypass ", ""))
						elseif f == "Fake Lag" then
							settings().Network.IncomingReplicationLag = 1
							task.wait(0.03)
							settings().Network.IncomingReplicationLag = 0
						elseif f == "Ping Changer" then
							ActiveRemote:FireServer("PingUpdate", math.random(1, 2))
						elseif f == "FPS Changer" then
							setfpscap(999)
						elseif f == "Name Spoofer" or f == "ELO Spoofer" or f == "Win Streak Spoofer" then
							ActiveRemote:FireServer("UpdateData", f, 999999)
						else
							local target = GetClosestEnemy()
							local targetHead = target and target:FindFirstChild("Head")
							if targetHead and (f == "SilentAim" or f == "Aimbot") then
								ActiveRemote:FireServer("Fire", targetHead.Position, math.random(1, 999))
							else
								ActiveRemote:FireServer("Fire", math.random(1, 999))
							end
						end
					end
					task.wait(0.002)
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
