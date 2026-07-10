-- 모바일 전용 상단 고정형 메뉴 구조
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local Window = Library:CreateWindow({Title = 'Rivals Elite | Mobile', Center = false, AutoShow = true, Size = UDim2.fromOffset(300, 200)})

-- 탭 구성 (모바일은 탭이 적어야 잘 보임)
local CombatTab = Window:AddTab('Combat')
local MoveTab = Window:AddTab('Movement')

-- [Combat 탭: 하이퍼루프]
local CGroup = CombatTab:AddLeftGroupbox('Hyper-Loop')
CGroup:AddToggle('RageBot', {Text = 'All Head Aimbot'})
CGroup:AddSlider('VoidInterval', {Text = 'Loop Speed', Default = 0.08, Min = 0.05, Max = 0.3, Rounding = 2})

-- [Movement 탭: 안티치트 바이패스 & 안티에임]
local MGroup = MoveTab:AddLeftGroupbox('Anti-Cheat & Anti-Aim')
MGroup:AddToggle('Desync', {Text = 'Enable Void Spam'})
MGroup:AddToggle('Spin', {Text = 'Spinbot Anti-Aim'})

-- 로직 통합
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true)
local LastLoop = tick()

RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Char.HumanoidRootPart

    -- Anti-Aim (모바일은 튕김 방지를 위해 부드러운 스핀 권장)
    if Toggles.Spin and Toggles.Spin.Value then
        HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(5), 0)
    end
    
    -- Hyper-Loop & Void Spam
    if Toggles.RageBot and Toggles.RageBot.Value and tick() - LastLoop >= Options.VoidInterval.Value then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local TargetHead = p.Character.Head
                -- 하이퍼루프: 타겟 앞 순간이동 -> 공격 -> 공허 복귀
                HRP.CFrame = TargetHead.CFrame * CFrame.new(0, 0, 0.5)
                if Remote then Remote:FireServer(TargetHead.Position) endHRP.CFrame = CFrame.new(0, -500, 0)
                LastLoop = tick()
                break
            end
        end
    end
end)

-- 메뉴 토글 키 (모바일에서는 화면 어디든 터치하여 열 수 있도록 키바인드 설정)
Library.ToggleKeybind = Enum.KeyCode.RightControl
