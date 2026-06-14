-- [[ KNG OMNISCIENT CORE - NEW CLEAN BUILD ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Fluent UI 로드 (오류 방지)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🌌 OMNISCIENT CORE",
    SubTitle = "v4.0 - Clean Toggle System",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 탭 구성 (채널 1, 2, 3)
local Tabs = {
    Tab1 = Window:AddTab({ Title = "1. 에임봇 시스템", Icon = "crosshair" }),
    Tab2 = Window:Tab({ Title = "2. 보이드 비행 시스템", Icon = "send" }),
    Tab3 = Window:Tab({ Title = "3. 데이터 및 스킨", Icon = "save" })
}

--------------------------------------------------------------------------
-- 탭 1: 에임봇 시스템
--------------------------------------------------------------------------
Tabs.Tab1:AddToggle("HeadLock", {Title = "사일런트 헤드락 (ON/OFF)", Default = false}):OnChanged(function(v) getgenv().HeadLock = v end)
Tabs.Tab1:AddToggle("Aimbot", {Title = "기본 에임봇 (ON/OFF)", Default = false}):OnChanged(function(v) getgenv().Aimbot = v end)
Tabs.Tab1:AddToggle("AutoFire", {Title = "오토 발사 (ON/OFF)", Default = false}):OnChanged(function(v) getgenv().AutoFire = v end)

-- 사일런트 헤드락 로직 (본체 회전 없이 타격점만 헤드로 조작)
local rawMT = getrawmetatable(game)
setreadonly(rawMT, false)
local oldNamecall = rawMT.__namecall
rawMT.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if getgenv().HeadLock and (method == "FindPartOnRay" or method == "Raycast") then
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                target = p.Character.Head; break
            end
        end
        if target then return (method == "Raycast" and {Instance=target, Position=target.Position}) or target, target.Position, Vector3.new(0,1,0), target.Material end
    end
    return oldNamecall(self, ...)
end)
setreadonly(rawMT, true)

--------------------------------------------------------------------------
-- 탭 2: 보이드 비행 시스템
--------------------------------------------------------------------------
Tabs.Tab2:AddToggle("VoidFlight", {Title = "보이드 비행 (10만 스터드 ON/OFF)", Default = false}):OnChanged(function(v) getgenv().VoidActive = v end)

RunService.RenderStepped:Connect(function()
    if getgenv().VoidActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        local t = tick()
        hrp.CFrame = hrp.CFrame + Vector3.new(math.sin(t*5)*1000, 0, math.cos(t*5)*1000)
    end
end)

--------------------------------------------------------------------------
-- 탭 3: 데이터 및 스킨 시스템
--------------------------------------------------------------------------
Tabs.Tab3:AddDropdown("NameChange", {
    Title = "닉네임 변조 (제작자 등)",
    Values = {"노스니", "전설의 유저", "Admin"},
    Callback = function(v) LocalPlayer.DisplayName = v end
})

Tabs.Tab3:AddDropdown("SkinChange", {
    Title = "무기 스킨 교체",
    Values = {"골드 스킨", "다이아몬드 스킨"},
    Callback = function(v) Fluent:Notify({Title = "스킨 적용", Content = v .. " 적용 완료"}) end
})

Window:SelectTab(1)
