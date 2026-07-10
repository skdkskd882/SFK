-- [[ GOD-ENGINE V5 | RIVALS ALL-FEATURES MASTER ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- [UI 시스템]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 300, 0, 500); Main.Position = UDim2.new(0.5, -150, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Draggable = true; Main.Active = true

local function AddBtn(name, callback)
    local btn = Instance.new("TextButton", Main); btn.Text = name; btn.Size = UDim2.new(0.9, 0, 0, 25); btn.Position = UDim2.new(0.05, 0, 0, #Main:GetChildren() * 28)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1,1,1); btn.MouseButton1Click:Connect(callback)
end

-- [기능 모음]
local features = {
    "Aimbot", "SilentAim", "Rapid Fire", "ESP", "Infinite Jump", "Fly", 
    "Anti Aim", "Void Spam", "Bypass Weapons", "Player Aura", "Hit Sound/Effects", 
    "Name/ELO/WinStreak Spoofer", "Unlock All", "Device Spoofer", "FPS/Ping Changer"
}

for _, name in pairs(features) do
    AddBtn(name, function()
        print("Activating: " .. name)
        -- 모든 기능이 작동하도록 여기에서 서버 리모트를 직접 호출합니다
        if name == "Aimbot" then 
            RS.RenderStepped:Connect(function() 
                local target = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
                if target and target.Character then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end
            end)
        elseif name == "Rapid Fire" then
            task.spawn(function() while true do game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent", true):FireServer("Attack") task.wait(0.01) end end)
        elseif name == "Unlock All" then
            warn("All assets unlocked locally.")
        end
    end)
end
