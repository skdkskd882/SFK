local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local P, RS, UIS, LP = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [키 시스템]
local AuthWin = Fluent:CreateWindow({Title = "GOD-ENGINE | AUTH", Size = UDim2.fromOffset(300, 150)})
AuthWin:AddInput("KeyInput", {Title = "Enter Key", Placeholder = "FTgood"})
AuthWin:AddButton({Title = "Login", Callback = function()
    if Fluent.Options.KeyInput.Value == "FTgood" then
        AuthWin:Destroy()
        
        local Win = Fluent:CreateWindow({Title = "GOD-ENGINE | OPTIMIZED", Size = UDim2.fromOffset(450, 600)})
        local Tabs = {C = Win:AddTab({Title="Combat"}), M = Win:AddTab({Title="Movement"}), V = Win:AddTab({Title="Visuals"})}
        getgenv().S = {Aimbot=false, Silent=false, Rage=false, Rapid=false, Void=false, AA=false, InfJump=false, DoubleJump=false, Sling=false, ESP=false, Smoothness=0.1}

        -- [UI 생성]
        Tabs.C:AddToggle("SA", {Title="Silent Aim"}):OnChanged(function(v) S.Silent = v end)
        Tabs.C:AddToggle("AB", {Title="Aimbot"}):OnChanged(function(v) S.Aimbot = v end)
        Tabs.C:AddSlider("SM", {Title="Smoothing", Min=0.01, Max=1, Default=0.1}):OnChanged(function(v) S.Smoothness = v end)
        Tabs.C:AddToggle("RB", {Title="Rage Bot (Hyper)"}):OnChanged(function(v) S.Rage = v end)
        Tabs.C:AddToggle("RF", {Title="Rapid Fire"}):OnChanged(function(v) S.Rapid = v end)
        Tabs.C:AddToggle("VS", {Title="Void Spam"}):OnChanged(function(v) S.Void = v end)
        Tabs.M:AddToggle("IJ", {Title="Inf Jump"}):OnChanged(function(v) S.InfJump = v end)
        Tabs.M:AddToggle("DJ", {Title="Double Jump (10cm)"}):OnChanged(function(v) S.DoubleJump = v end)
        Tabs.M:AddToggle("SS", {Title="Slingshot"}):OnChanged(function(v) S.Sling = v end)
        Tabs.M:AddToggle("AA", {Title="Anti Aim"}):OnChanged(function(v) S.AA = v end)
        Tabs.V:AddToggle("ESP", {Title="Box ESP"}):OnChanged(function(v) S.ESP = v end)

        -- [최적화된 Rage Bot Hyper-Loop]
        task.spawn(function()
            while task.wait(0.01) do
                if S.Rage and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local target, minDst = nil, math.huge
                    for _, p in pairs(P:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                            local dst = (p.Character.Head.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                            if dst < minDst then target, minDst = p, dst end
                        end
                    end
                    if target then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
                        if S.Rapid then
                            local Event = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent", true)
                            if Event then Event:FireServer("Hit", {Target=target.Character.Head, Position=target.Character.Head.Position}) end
                        end
                    end
                end
            end
        end)

        -- [Silent Aim Hook]
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local Args = {...}
            if S.Silent and getnamecallmethod() == "FireServer" and Args[1] == "Hit" then
                local Closest, Dist = nil, math.huge
                for _, p in pairs(P:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                        local pos, on = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                        local d = (Vector2.new(pos.X, pos.Y) - workspace.CurrentCamera.ViewportSize/2).Magnitude
                        if on and d < Dist then Closest, Dist = p, d end
                    end
                end
                if Closest then Args[2].Position = Closest.Character.Head.Position end
            end
            return OldNamecall(self, unpack(Args))
        end)

        -- [최적화된 메인 루프]
        RS.RenderStepped:Connect(function()
            if not LP.Character then return end
            if S.Void then LP.Character.HumanoidRootPart.CFrame = CFrame.new(1e15, 1e15, 1e15) end
            if S.InfJump and LP.Character.Humanoid:GetState() == Enum.HumanoidStateType.Landed then LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            if S.Aimbot then
                local Cld, Dst = nil, math.huge
                for _, p in pairs(P:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                        local pos, on = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                        local d = (Vector2.new(pos.X, pos.Y) - workspace.CurrentCamera.ViewportSize/2).Magnitude
                        if on and d < Dst then Cld, Dst = p, d end
                    end
                end
                if Cld then workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, Cld.Character.Head.Position), S.Smoothness) end
            end
            if S.AA then LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0.1, 0) end
        end)

        UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if S.Sling and inp.KeyCode == Enum.KeyCode.E then LP.Character.HumanoidRootPart.Velocity = LP.Character.HumanoidRootPart.CFrame.LookVector * 200 end
            if S.DoubleJump and inp.KeyCode == Enum.KeyCode.Space then
                local Hum = LP.Character.Humanoid
                local old = Hum.JumpPower Hum.JumpPower = 10 Hum:ChangeState(Enum.HumanoidStateType.Jumping) task.delay(0.1, function() Hum.JumpPower = old end)
            end
        end)
    else
        Fluent:Notify({Title="ERROR", Content="Wrong Key", Duration=3})
    end
end})
