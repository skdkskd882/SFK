-- RIVALS ELITE | UNIVERSAL ENGINE (PC & MOBILE COMPATIBLE)
local g = game
local lp = g:GetService("Players").LocalPlayer
local rs = g:GetService("RunService")

-- [1] 환경 감지 및 라이브러리 호환성 확보
local isMobile = g:GetService("UserInputService").TouchEnabled
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()

-- [2] 윈도우 생성
local Window = Library:CreateWindow({Title = 'Rivals Elite | Multi-Platform', Center = true, AutoShow = true})

-- [3] 탭 구성
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [4] 기능 정의 (범용 함수)
local CombatGroup = Tabs.Combat:AddLeftGroupbox('Combat')
CombatGroup:AddToggle('AimEnabled', {Text = 'All Head Aimbot'})
CombatGroup:AddSlider('Smoothing', {Text = 'Smoothing', Default = 5, Min = 1, Max = 20})

local MoveGroup = Tabs.Movement:AddLeftGroupbox('Movement')
MoveGroup:AddToggle('AntiAim', {Text = 'Spinbot'})
MoveGroup:AddSlider('SpinSpeed', {Text = 'Spin Speed', Default = 25, Min = 1, Max = 50})

-- [5] 플랫폼별 입력 처리 (모바일/PC 구분)
rs.RenderStepped:Connect(function()
    pcall(function()
        if Toggles.AntiAim.Value and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            -- 모바일과 PC 모두 CFrame 연산은 동일하게 지원됨
            local hrp = lp.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeed.Value), 0)
        end
    end)
end)

-- [6] 설정 관리 (공통)
SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:SetFolder('RivalsElite_Universal')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)SaveManager:LoadAutoloadConfig()
