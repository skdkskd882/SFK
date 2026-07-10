-- RIVALS ELITE | ULTIMATE MASTER ENGINE (WITH UI TOGGLE)
local g = game
local lp = g:GetService("Players").LocalPlayer
local rs = g:GetService("RunService")
local UIS = g:GetService("UserInputService")

-- [1] 라이브러리 및 에드온
local Library = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local SaveManager = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()
local ThemeManager = loadstring(g:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()

-- [2] 윈도우 생성
local Window = Library:CreateWindow({Title = 'Rivals Elite | Master Engine', Center = true, AutoShow = true, Size = UDim2.fromOffset(500, 400)})

-- [3] UI 토글 시스템 (Keybind 연동)
-- 설정 탭에 UI 토글 키바인드 추가
local SettingsTab = Window:AddTab('Settings')
local ToggleGroup = SettingsTab:AddLeftGroupbox('Menu Settings')

ToggleGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightControl', -- 우측 컨트롤 키로 껐다 켜기
    NoUI = true,
    Text = 'Menu Keybind'
})

Library.ToggleKeybind = Options.MenuKeybind -- 이 설정으로 키 한번 누르면 껐다 켜짐

-- [4] 기능 탭 생성
local CombatTab = Window:AddTab('Combat')
local MoveTab = Window:AddTab('Movement')

-- [5] 모든 기능이 담긴 로직 루프 (Fail-safe 바이패스)
local function RegisterFeature(name, func)
    rs.RenderStepped:Connect(function()
        if Toggles[name] and Toggles[name].Value then
            local success, err = pcall(func)
            if not success then warn("Bypassing error: " .. tostring(err)) end
        end
    end)
end

-- 기능 구현
local CombatGroup = CombatTab:AddLeftGroupbox('Aim & Attack')
CombatGroup:AddToggle('AimEnabled', {Text = 'All Head Aimbot'})
CombatGroup:AddDropdown('AimMode', {Values = {'Legit', 'Rage'}, Default = 2, Text = 'Mode'})

local MoveGroup = MoveTab:AddLeftGroupbox('Physics')
MoveGroup:AddToggle('AntiAim', {Text = 'Spinbot'})
MoveGroup:AddSlider('SpinSpeed', {Text = 'Spin Speed', Default = 25, Min = 1, Max = 50})
MoveGroup:AddToggle('Slingshot', {Text = 'Slingshot Velocity'})

RegisterFeature('AimEnabled', function()
    -- 올 헤드 타겟팅 로직 (pcall 내장)
    -- 여기에 타겟팅 상세 코드 삽입
end)

RegisterFeature('AntiAim', function()
    lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeed.Value), 0)
end)

-- [6] 저장 및 테마 동기화
SaveManager:SetLibrary(Library)
SaveManager:SetFolder('RivalsElite_Master')
ThemeManager:SetLibrary(Library)
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()
