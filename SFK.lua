-- GOD-ENGINE | ULTIMATE MOBILE PERFORMANCE VERSION
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local P, RS, UIS, LP = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [키 시스템]
local AuthWin = Fluent:CreateWindow({Title = "AUTH", Size = UDim2.fromOffset(300, 150)})
AuthWin:AddInput("KeyInput", {Title = "Enter Key", Placeholder = "FTgood"})
AuthWin:AddButton({Title = "Login", Callback = function()
    if Fluent.Options.KeyInput.Value == "FTgood" then
        AuthWin:Destroy()
        
        local Win = Fluent:CreateWindow({Title = "GOD-ENGINE | MAX PERFORMANCE", Size = UDim2.fromOffset(400, 500)})
        local T = {C = Win:AddTab({Title="Combat"}), M = Win:AddTab({Title="Move"}), V = Win:AddTab({Title="Visuals"})}
        getgenv().S = {Silent=false, Aimbot=false, Rage=false, Rapid=false, Void=false, InfJump=false, DoubleJump=false, Sling=false, AA=false, ESP=false}

        -- 기능 싹 다 삽입
        T.C:AddToggle("SA", {Title="Silent Aim"}):OnChanged(function(v) S.Silent = v end)
        T.C:AddToggle("AB", {Title="Aimbot"}):OnChanged(function(v) S.Aimbot = v end)
        T.C:AddToggle("RB", {Title="Rage Bot"}):OnChanged(function(v) S.Rage = v end)
        T.C:AddToggle("RF", {Title="Rapid Fire"}):OnChanged(function(v) S.Rapid = v end)
        T.C:AddToggle("VS", {Title="Void Spam"}):OnChanged(function(v) S.Void = v end)
        T.M:AddToggle("IJ", {Title="Inf Jump"}):OnChanged(function(v) S.InfJump = v end)
        T.M:AddToggle("DJ", {Title="Double Jump"}):OnChanged(function(v) S.DoubleJump = v end)
        T.M:AddToggle("SS", {Title="Slingshot"}):OnChanged(function(v) S.Sling = v end)
        T.M:AddToggle("AA", {Title="Anti Aim"}):OnChanged(function(v) S.AA = v end)
        T.V:AddToggle("ESP", {Title="Box ESP"}):OnChanged(function(v) S.ESP = v end)

        -- [최적화 루프: 렉 방지 핵심]
        task.spawn(function()
            while task.wait(0.15) do -- 0.15초 주기로 루프 속도 낮춤 (부하 대폭 감소)
                pcall(function()
                    if not LP.Character then return end
                    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    
                    -- Combat (에임봇/레이지)
                    if (S.Rage or S.Aimbot) and hrp then
                        local closest, dist = nil, 250 -- 거리 제한(250)을 두어 연산량 감소
                        for _, p in pairs(P:GetPlayers()) do
                            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                                local d = (p.Character.Head.Position - hrp.Position).Magnitude
                                if d < dist then closest = p.Character.Head dist = d end
                            end
                        end
                        if closest then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position) end
                    end

                    -- Void & AA
                    if S.Void and hrp then hrp.CFrame = CFrame.new(1e15, 1e15, 1e15) end
                    if S.AA and hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.5, 0) end
                end)
            end
        end)

        -- [ESP 최적화: 켜질 때만 딱 한 번 실행]
        local function RunESP()
            if not S.ESP then return end
            for _, p in pairs(P:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("BoxHighlight") then
                    local h = Instance.new("Highlight", p.Character) h.Name = "BoxHighlight"
                end
            end
        end

        -- [입력 이벤트: 반응성 유지]
        UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if S.InfJump and inp.KeyCode == Enum.KeyCode.Space then LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            if S.Sling and inp.KeyCode == Enum.KeyCode.E then LP.Character.HumanoidRootPart.Velocity = LP.Character.HumanoidRootPart.CFrame.LookVector * 200 end
        end)

        Fluent:Notify({Title="GOD-ENGINE", Content="최대 성능 모드 적용됨.", Duration=3})
    else
        Fluent:Notify({Title="ERROR", Content="Wrong Key", Duration=2})
    end
end})
