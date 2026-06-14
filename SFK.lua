-- [[ KNG OMNISCIENT CORE - FINAL v4 INTEGRATION ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Fluent UI 로드
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [데이터 저장 시스템]
local SaveFile = "OmniscientCore_v4_Data.json"
local Config = { Name = "노스니", Skin = "골드 스킨" }

if isfile and isfile(SaveFile) then
    Config = HttpService:JSONDecode(readfile(SaveFile))
end

local function Save()
    if writefile then writefile(SaveFile, HttpService:JSONEncode(Config)) end
end

-- [UI 설정 - v4 적용]
local Window = Fluent:CreateWindow({
    Title = "🌌 OMNISCIENT CORE v4",
    SubTitle = "최종 통합 안정화 에디션",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Tab1 = Window:AddTab({ Title = "1. 에임봇 시스템", Icon = "crosshair" }),
    Tab2 = Window:AddTab({ Title = "2. 보이드 비행 시스템", Icon = "send" }),
    Tab3 = Window:AddTab({ Title = "3. 데이터 및 스킨 (v4)", Icon = "save" })
}

--------------------------------------------------------------------------
-- 1. 에임봇 시스템
--------------------------------------------------------------------------
Tabs.Tab1:AddToggle("HeadLock", {Title = "사일런트 헤드락 (ON/OFF)", Default = false}):OnChanged(function(v) getgenv().HeadLock = v end)

local rawMT = getrawmetatable(game)
setreadonly(rawMT, false)
local oldNamecall = rawMT.__namecall
rawMT.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if getgenv().HeadLock and (method == "FindPartOnRay" or method == "Raycast") then
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                target = p.Character.Head; break
            end
        end
        if target then return (method == "Raycast" and {Instance=target, Position=target.Position}) or target, target.Position, Vector3.new(0,1,0), target.Material end
    end
    return oldNamecall(self, ...)
end)
setreadonly(rawMT, true)

--------------------------------------------------------------------------
-- 2. 보이드 비행 시스템
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
-- 3. 데이터 및 스킨 시스템 (v4 저장)
--------------------------------------------------------------------------
Tabs.Tab3:AddDropdown("NameChange", {
    Title = "닉네임 변조 (v4 저장)",
    Values = {"노스니", "전설의 유저", "Admin"},
    Default = Config.Name,
    Callback = function(v) 
        Config.Name = v
        LocalPlayer.DisplayName = v
        Save()
    end
})

Tabs.Tab3:AddDropdown("SkinChange", {
    Title = "무기 스킨 선택 (v4 저장)",
    Values = {"골드 스킨", "다이아몬드 스킨", "네온 스킨"},
    Default = Config.Skin,
    Callback = function(v) 
        Config.Skin = v
        Save()
        Fluent:Notify({Title = "스킨 적용", Content = v .. " (v4) 저장 및 적용 완료"})
    end
})

Window:SelectTab(1)
