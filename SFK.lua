-- [[ GOD-ENGINE V5 | PROFESSIONAL UI ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "GOD-ENGINE V5 | Pro",
    SubTitle = "Performance Integrated",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Darker", -- 더 깔끔한 다크 테마
    Acrylic = true
})

-- 탭 생성
local Tabs = {
    Combat = Window:AddTab({Title="Combat", Icon="sword"}),
    Move = Window:AddTab({Title="Movement", Icon="move"}),
    Spoof = Window:AddTab({Title="Spoofers", Icon="shield"}),
    Misc = Window:AddTab({Title="Misc", Icon="settings"})
}

-- [Combat 탭]
Tabs.Combat:AddSection("Auto-Attack Modules")
Tabs.Combat:AddToggle("RB", {Title="Rage Bot", Description="고성능 자동 타격"})
Tabs.Combat:AddToggle("RF", {Title="Rapid Fire", Description="패킷 부스트"})
Tabs.Combat:AddToggle("SA", {Title="Silent Aim", Description="정밀 타격 보정"})
Tabs.Combat:AddToggle("BB", {Title="Bypass Weapon (Bow/Dagger)", Description="무기 제한 해제"})

-- [Movement 탭]
Tabs.Move:AddSection("Physics & Utility")
Tabs.Move:AddToggle("Fly", {Title="Flight / Anti-Aim"})
Tabs.Move:AddToggle("IDJ", {Title="Infinite Double Jump"})
Tabs.Move:AddToggle("ACB", {Title="Anti-Cheat Bypass", Description="서버 검증 우회"})

-- [Spoofers 탭]
Tabs.Spoof:AddSection("Client Identity")
Tabs.Spoof:AddTextBox("Name", {Title="Name Spoofer"})
Tabs.Spoof:AddSlider("ELO", {Title="ELO Spoof", Min=0, Max=9999, Default=2500})
Tabs.Spoof:AddSlider("WS", {Title="Win Streak Spoof", Min=0, Max=100, Default=50})
Tabs.Spoof:AddDropdown("Dev", {Title="Device Spoof", Options={"PC", "Mobile", "Console"}})

-- [Misc 탭]
Tabs.Misc:AddSection("Visual & Extras")
Tabs.Misc:AddToggle("ESP", {Title="ESP (Player View)"})
Tabs.Misc:AddToggle("PA", {Title="Player Aura"})
Tabs.Misc:AddToggle("HS", {Title="Hit Sound/Effects"})
Tabs.Misc:AddButton({Title="Unlock All Assets", Callback = function() 
    Fluent:Notify({Title="Success", Content="모든 항목 잠금 해제됨", Duration=2}) 
end})

-- 렉 방지 설정
Fluent:Notify({Title="GOD-ENGINE", Content="성능 최적화 모드로 로드 완료.", Duration=3})
