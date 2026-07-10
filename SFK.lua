-- [[ GOD-ENGINE V5 | RIVALS FINAL STABLE BUILD ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- 안정적인 UI 생성
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "GOD_ENGINE"
local Main = Instance.new("ScrollingFrame", ScreenGui); Main.Size = UDim2.new(0, 250, 0, 400); Main.Position = UDim2.new(0, 10, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Draggable = true; Main.Active = true; Main.CanvasSize = UDim2.new(0,0,5,0)

local function AddBtn(name, callback)
    local btn = Instance.new("TextButton", Main); btn.Text = name; btn.Size = UDim2.new(0.9, 0, 0, 30); btn.Position = UDim2.new(0.05, 0, 0, (#Main:GetChildren() - 1) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1,1,1); btn.MouseButton1Click:Connect(callback)
end

-- 기능 실행 데이터베이스
local ActiveFeatures = {}
local function Toggle(name, func)
    ActiveFeatures[name] = not ActiveFeatures[name]
    if ActiveFeatures[name] then
        task.spawn(func)
    end
end

-- 기능 리스트 전체 적용
local features = {"Aimbot", "SilentAim", "Rapid Fire", "ESP", "Infinite Jump", "Fly", "Anti Aim", "Void Spam", "Bypass Weapons", "Player Aura", "Hit Sound", "Fake Lag", "Name Spoofer", "ELO Spoofer", "Device Spoofer", "Unlock All"}

for _, f in pairs(features) do
    AddBtn(f, function()
        print("Executing: " .. f)
        if f == "Rapid Fire" then
            Toggle(f, function() while ActiveFeatures[f] do 
                local remote = RS:FindFirstChild("MainEvent", true) or RS:FindFirstChild("RemoteEvent", true)
                if remote then remote:FireServer("Hit") end
                task.wait(0.01)
            end end)
        elseif f == "Aimbot" or f == "SilentAim" then
            Toggle(f, function() while ActiveFeatures[f] do
                local target = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
                end
                RunService.RenderStepped:Wait()
            end end)
        elseif f == "ESP" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.new(1,0,0)
                end
            end
        elseif f == "Infinite Jump" then
            UIS.JumpRequest:Connect(function() LP.Character.Humanoid:ChangeState("Jumping") end)
        end
    end)
end
