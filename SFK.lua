-- GOD-ENGINE | MOBILE PERFORMANCE EDITION
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local P, RS, UIS, LP = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [키 인증 시스템]
local AuthWin = Fluent:CreateWindow({Title = "AUTH", Size = UDim2.fromOffset(300, 150)})
AuthWin:AddInput("KeyInput", {Title = "Enter Key", Placeholder = "FTgood"})
AuthWin:AddButton({Title = "Login", Callback = function()
    if Fluent.Options.KeyInput.Value == "FTgood" then
        AuthWin:Destroy()
        
        local Win = Fluent:CreateWindow({Title = "GOD-ENGINE | STABLE", Size = UDim2.fromOffset(400, 500)})
        local Tabs = {C = Win:AddTab({Title="Combat"}), M = Win:AddTab({Title="Movement"}), V = Win:AddTab({Title="Visuals"})}
        getgenv().S = {Silent=false, Aimbot=false, Rage=false, Rapid=false, Void=false, InfJump=false, DoubleJump=false, Sling=false, AA=false, ESP=false}

        -- [기능 메뉴]
        Tabs.C:AddToggle("SA", {Title="Silent Aim"}):OnChanged(function(v) S.Silent = v end)
        Tabs.C:AddToggle("AB", {Title="Aimbot"}):OnChanged(function(v) S.Aimbot = v end)
        Tabs.C:AddToggle("RB", {Title="Rage Bot"}):OnChanged(function(v) S.Rage = v end)
        Tabs.C:AddToggle("RF", {Title="Rapid Fire"}):OnChanged(function(v) S.Rapid = v end)
        Tabs.C:AddToggle("VS", {Title="Void Spam (1000T)"}):OnChanged(function(v) S.Void = v end)
        Tabs.M:AddToggle("IJ", {Title="Inf Jump"}):OnChanged(function(v) S.InfJump = v end)
        Tabs.M:AddToggle("DJ", {Title="Double Jump (10cm)"}):OnChanged(function(v) S.DoubleJump = v end)
        Tabs.M:AddToggle("SS", {Title="Slingshot (E Key)"}):OnChanged(function(v) S.Sling = v end)
        Tabs.M:AddToggle("AA", {Title="Anti Aim"}):OnChanged(function(v) S.AA = v end)
        Tabs.V:AddToggle("ESP", {Title="Box ESP"}):OnChanged(function(v) S.ESP = v end)

        -- [고성능 루프]
        RS.RenderStepped:Connect(function()
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- Combat Logic
            if S.Rage or S.Aimbot then
                local closest, dist = nil, 999
                for _, p in pairs(P:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                        local d = (p.Character.Head.Position - hrp.Position).Magnitude
                        if d < dist then closest = p.Character.Head dist = d end
                    end
                end
                if closest then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position) end
            end

            -- Misc
            if S.Void then hrp.CFrame = CFrame.new(1e15, 1e15, 1e15) end
            if S.AA then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.1, 0) end
            
            -- ESP 최적화 (불필요한 반복 방지)
            if S.ESP then
                for _, p in pairs(P:GetPlayers()) do
                    if p ~= LP and p.Character and not p.Character:FindFirstChild("BoxHighlight") then
                        Instance.new("Highlight", p.Character).Name = "BoxHighlight"
                    end
                end
            end
        end)

        -- [입력 로직]
        UIS.InputBegan:Connect(function(inp, gpe)
            if gpe or not LP.Character then return end
            local hum = LP.Character:FindFirstChild("Humanoid")
            
            -- Jump Logic
            if S.InfJump and inp.KeyCode == Enum.KeyCode.Space then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            if S.DoubleJump and inp.KeyCode == Enum.KeyCode.Space then
                local old = hum.JumpPower 
                hum.JumpPower = 10 
                hum:ChangeState(Enum.HumanoidStateType.Jumping) 
                task.delay(0.2, function() hum.JumpPower = old end)
            end
            -- Sling
            if S.Sling and inp.KeyCode == Enum.KeyCode.E then LP.Character.HumanoidRootPart.Velocity = LP.Character.HumanoidRootPart.CFrame.LookVector * 200 end
        end)

        Fluent:Notify({Title="GOD-ENGINE", Content="성능 모드 가동 완료.", Duration=5})
    else
        Fluent:Notify({Title="ERROR", Content="Wrong Key", Duration=3})
    end
end})
