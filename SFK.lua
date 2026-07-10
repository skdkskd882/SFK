local g = game
local lp = g:GetService("Players").LocalPlayer
local rs = g:GetService("RunService")
local TS = g:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- [1] 라이브러리 및 에드온
local Library = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local SaveManager = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()
local ThemeManager = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()

-- [2] 윈도우 생성
local Window = Library:CreateWindow({Title = 'Rivals Elite | Advanced', Center = true, AutoShow = true, Size = UDim2.fromOffset(500, 500)})

-- [3] 탭 및 섹션 구성 (UI 직관성 개선)
local CombatTab = Window:AddTab('Combat')
local MoveTab = Window:AddTab('Movement')
local SettingsTab = Window:AddTab('Settings')

-- Combat 탭 섹션
local AimGroup = CombatTab:AddLeftGroupbox('Aimbot')
local RageGroup = CombatTab:AddRightGroupbox('Ragebot')

-- Movement 탭 섹션
local MoveGroup = MoveTab:AddLeftGroupbox('Physics')

-- [4] 기능 로직

-- 자연스러운 에임 (Smooth Aimbot)
local function GetClosestPlayer()
    local closest, minDist = nil, math.huge
    for _, v in pairs(g:GetService("Players"):GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - g:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if dist < minDist then
                    closest = v.Character.Head
                    minDist = dist
                end
            end
        end
    end
    return closest
end

-- 비싱크 (Desync) - 서버와 클라이언트 위치 분리 시도
local DesyncActive = false
rs.Heartbeat:Connect(function()
    if Toggles.Desync and Toggles.Desync.Value then
        -- 캐릭터의 CFrame을 미세하게 흔들어 서버 예측을 방해
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(100, 0, 100) -- 물리 엔진 강제 유도
        end
    end
end)

-- [5] UI 옵션 추가
AimGroup:AddToggle('AimEnabled', {Text = 'Enable Aimbot'})
AimGroup:AddSlider('Smoothing', {Text = 'Smoothness', Default = 10, Min = 1, Max = 20})

RageGroup:AddToggle('Desync', {Text = 'Desync (Rage)'})
RageGroup:AddToggle('Spinbot', {Text = 'Spinbot'})
RageGroup:AddSlider('SpinSpeed', {Text = 'Spin Speed', Default = 25, Min = 10, Max = 100})

-- [6] 메인 루프 (최적화)
rs.RenderStepped:Connect(function()
    -- Aimbot 로직
    if Toggles.AimEnabled and Toggles.AimEnabled.Value then
        local target = GetClosestPlayer()
        if target then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
            -- 자연스러운 움직임을 위해 Lerp 사용
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / Options.Smoothing.Value)
        end
    end

    -- Spinbot 로직
    if Toggles.Spinbot and Toggles.Spinbot.Value then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeed.Value), 0)
        end
    end
end)

-- [7] 저장 및 테마
SaveManager:SetLibrary(Library)
SaveManager:SetFolder('RivalsElite_Master')
ThemeManager:SetLibrary(Library)
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()
