local MDLib = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

local clr = {
    bg = Color3.fromRGB(12, 12, 16),
    bg2 = Color3.fromRGB(18, 18, 24),
    bg3 = Color3.fromRGB(24, 24, 32),
    panel = Color3.fromRGB(16, 16, 22),
    accent = Color3.fromRGB(255, 45, 85),
    accent2 = Color3.fromRGB(180, 50, 255),
    glow = Color3.fromRGB(255, 60, 90),
    txt = Color3.fromRGB(245, 245, 250),
    txt2 = Color3.fromRGB(140, 140, 160),
    txt3 = Color3.fromRGB(90, 90, 110),
    border = Color3.fromRGB(45, 45, 60),
    success = Color3.fromRGB(80, 255, 120),
    warn = Color3.fromRGB(255, 180, 50)
}

local function tween(obj, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    return TS:Create(obj, ti, props)
end

local function create(cls, props, children)
    local obj = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    for _, c in ipairs(children or {}) do
        c.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function corner(obj, rad)
    return create("UICorner", {CornerRadius = UDim.new(0, rad or 8), Parent = obj})
end

local function stroke(obj, col, thick, trans)
    return create("UIStroke", {Color = col or clr.border, Thickness = thick or 1, Transparency = trans or 0, Parent = obj})
end

local function gradient(obj, c1, c2, rot)
    return create("UIGradient", {
        Color = ColorSequence.new(c1 or clr.accent, c2 or clr.accent2),
        Rotation = rot or 90,
        Parent = obj
    })
end

local function pad(obj, t, b, l, r)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 8),
        PaddingRight = UDim.new(0, r or 8),
        Parent = obj
    })
end

local function glow(parent, col, size, trans)
    local g = create("ImageLabel", {
        Size = UDim2.new(1, size or 60, 1, size or 60),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = col or clr.glow,
        ImageTransparency = trans or 0.85,
        ZIndex = -2,
        Parent = parent
    })
    return g
end

local function makeDrag(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08):Play()
        end
    end)
end

local function createX(parent, sz, col, thick)
    local x = create("Frame", {
        Size = UDim2.new(0, sz, 0, sz),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local l1 = create("Frame", {
        Size = UDim2.new(0, sz * 1.4, 0, thick or 3),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = 45,
        BackgroundColor3 = col or clr.accent,
        BorderSizePixel = 0,
        Parent = x
    })
    corner(l1, 2)
    
    local l2 = create("Frame", {
        Size = UDim2.new(0, sz * 1.4, 0, thick or 3),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = -45,
        BackgroundColor3 = col or clr.accent,
        BorderSizePixel = 0,
        Parent = x
    })
    corner(l2, 2)
    
    return x
end

local function ripple(btn)
    btn.ClipsDescendants = true
    btn.MouseButton1Click:Connect(function()
        local rip = create("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = clr.txt,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Parent = btn
        })
        corner(rip, 100)
        
        local t = tween(rip, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.4)
        t:Play()
        t.Completed:Connect(function()
            rip:Destroy()
        end)
    end)
end

function MDLib:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "MURDER DRONES"
    local sz = cfg.Size or {560, 380}
    
    local sg = create("ScreenGui", {
        Name = "MDLib_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if syn then
        syn.protect_gui(sg)
        sg.Parent = game:GetService("CoreGui")
    elseif gethui then
        sg.Parent = gethui()
    else
        sg.Parent = plr:WaitForChild("PlayerGui")
    end
    
    local main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, sz[1], 0, sz[2]),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = clr.bg,
        BorderSizePixel = 0,
        Parent = sg
    })
    corner(main, 12)
    
    local mainStroke = stroke(main, clr.accent, 2)
    gradient(mainStroke, clr.accent, clr.accent2, 45)
    
    glow(main, clr.accent, 100, 0.9)
    
    local scanLine = create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = clr.accent,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = main
    })
    
    spawn(function()
        while main.Parent do
            tween(scanLine, {Position = UDim2.new(0, 0, 1, 0)}, 3, Enum.EasingStyle.Linear):Play()
            wait(3)
            scanLine.Position = UDim2.new(0, 0, 0, 0)
        end
    end)
    
    local topBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = clr.panel,
        BorderSizePixel = 0,
        Parent = main
    })
    corner(topBar, 12)
    
    local topFix = create("Frame", {
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BackgroundColor3 = clr.panel,
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    local accentLine = create("Frame", {
        Size = UDim2.new(1, -24, 0, 2),
        Position = UDim2.new(0, 12, 1, -1),
        BackgroundColor3 = clr.accent,
        BorderSizePixel = 0,
        Parent = topBar
    })
    corner(accentLine, 1)
    gradient(accentLine, clr.accent, clr.accent2, 0)
    
    local logoX = createX(topBar, 20, clr.accent, 4)
    logoX.Position = UDim2.new(0, 18, 0.5, 0)
    logoX.AnchorPoint = Vector2.new(0, 0.5)
    
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = clr.txt,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    local verLbl = create("TextLabel", {
        Size = UDim2.new(0, 60, 0, 16),
        Position = UDim2.new(0, 50 + titleLbl.TextBounds.X + 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = clr.bg3,
        Text = "v1.0",
        TextColor3 = clr.accent,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Parent = topBar
    })
    corner(verLbl, 4)
    
    local btnHolder = create("Frame", {
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Parent = topBar
    })
    
    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = clr.bg3,
        BackgroundTransparency = 1,
        Text = "",
        Parent = btnHolder
    })
    corner(minBtn, 6)
    
    local minIcon = create("Frame", {
        Size = UDim2.new(0, 14, 0, 3),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = clr.txt2,
        BorderSizePixel = 0,
        Parent = minBtn
    })
    corner(minIcon, 2)
    
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = clr.bg3,
        BackgroundTransparency = 1,
        Text = "",
        Parent = btnHolder
    })
    corner(closeBtn, 6)
    
    local closeX = createX(closeBtn, 10, clr.txt2, 2)
    closeX.Position = UDim2.new(0.5, 0, 0.5, 0)
    closeX.AnchorPoint = Vector2.new(0.5, 0.5)
    
    minBtn.MouseEnter:Connect(function()
        tween(minBtn, {BackgroundTransparency = 0}, 0.15):Play()
        tween(minIcon, {BackgroundColor3 = clr.txt}, 0.15):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, {BackgroundTransparency = 1}, 0.15):Play()
        tween(minIcon, {BackgroundColor3 = clr.txt2}, 0.15):Play()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0, BackgroundColor3 = clr.accent}, 0.15):Play()
        for _, c in pairs(closeX:GetChildren()) do
            tween(c, {BackgroundColor3 = clr.txt}, 0.15):Play()
        end
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 1, BackgroundColor3 = clr.bg3}, 0.15):Play()
        for _, c in pairs(closeX:GetChildren()) do
            tween(c, {BackgroundColor3 = clr.txt2}, 0.15):Play()
        end
    end)
    
    local minimized = false
    local origSz = main.Size
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, sz[1], 0, 50)}, 0.3):Play()
        else
            tween(main, {Size = origSz}, 0.3):Play()
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3):Play()
        wait(0.3)
        sg:Destroy()
    end)
    
    makeDrag(main, topBar)
    
    local nav = create("Frame", {
        Size = UDim2.new(0, 140, 1, -65),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundColor3 = clr.panel,
        BorderSizePixel = 0,
        Parent = main
    })
    corner(nav, 10)
    stroke(nav, clr.border, 1)
    
    local navTitle = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = "NAVIGATION",
        TextColor3 = clr.txt3,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = nav
    })
    
    local tabScroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -45),
        Position = UDim2.new(0, 8, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = clr.accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = nav
    })
    
    local tabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = tabScroll
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    local content = create("Frame", {
        Size = UDim2.new(1, -170, 1, -65),
        Position = UDim2.new(0, 160, 0, 55),
        BackgroundColor3 = clr.panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = main
    })
    corner(content, 10)
    stroke(content, clr.border, 1)
    
    local win = {tabs = {}, activeTab = nil, gui = sg, main = main}
    
    local notifCont = create("Frame", {
        Size = UDim2.new(0, 280, 1, -20),
        Position = UDim2.new(1, -290, 0, 10),
        BackgroundTransparency = 1,
        Parent = sg
    })
    
    local notifLayout = create("UIListLayout", {
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = notifCont
    })
    
    function win:Notify(cfg)
        cfg = cfg or {}
        local ntitle = cfg.Title or "Notification"
        local desc = cfg.Description or ""
        local dur = cfg.Duration or 4
        local ntype = cfg.Type or "info"
        
        local col = clr.accent
        if ntype == "success" then col = clr.success
        elseif ntype == "warn" then col = clr.warn end
        
        local notif = create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = clr.bg,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = notifCont
        })
        corner(notif, 10)
        stroke(notif, col, 1)
        
        local prog = create("Frame", {
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            BackgroundColor3 = col,
            BorderSizePixel = 0,
            Parent = notif
        })
        
        local nX = createX(notif, 12, col, 3)
        nX.Position = UDim2.new(0, 15, 0, 15)
        
        local nTitle = create("TextLabel", {
            Size = UDim2.new(1, -50, 0, 18),
            Position = UDim2.new(0, 38, 0, 12),
            BackgroundTransparency = 1,
            Text = ntitle,
            TextColor3 = col,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notif
        })
        
        local nDesc = create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 30),
            Position = UDim2.new(0, 15, 0, 32),
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = clr.txt2,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = notif
        })
        
        tween(notif, {Size = UDim2.new(1, 0, 0, 70)}, 0.3):Play()
        tween(prog, {Size = UDim2.new(0, 0, 0, 3)}, dur, Enum.EasingStyle.Linear):Play()
        
        task.delay(dur, function()
            tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.25):Play()
            wait(0.25)
            notif:Destroy()
        end)
    end
    
    function win:CreateTab(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Tab"
        
        local tabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = clr.bg3,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = tabScroll
        })
        corner(tabBtn, 8)
        
        local tabInd = create("Frame", {
            Size = UDim2.new(0, 4, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = clr.accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabBtn
        })
        corner(tabInd, 2)
        gradient(tabInd, clr.accent, clr.accent2, 90)
        
        local tabX = createX(tabBtn, 10, clr.txt3, 2)
        tabX.Position = UDim2.new(0, 14, 0.5, 0)
        tabX.AnchorPoint = Vector2.new(0, 0.5)
        
        local tabLbl = create("TextLabel", {
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = clr.txt2,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        local page = create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = clr.accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content
        })
        
        local pageLayout = create("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = page
        })
        
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local tab = {btn = tabBtn, page = page}
        
        local function activate()
            for _, t in pairs(win.tabs) do
                t.page.Visible = false
                tween(t.btn, {BackgroundTransparency = 1}, 0.2):Play()
                local ind = t.btn:FindFirstChild("Frame")
                if ind and ind.Size.X.Offset == 4 then
                    tween(ind, {BackgroundTransparency = 1}, 0.2):Play()
                end
                for _, d in pairs(t.btn:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        tween(d, {TextColor3 = clr.txt2}, 0.2):Play()
                    end
                    if d:IsA("Frame") and d.Size.X.Offset > 8 then
                        tween(d, {BackgroundColor3 = clr.txt3}, 0.2):Play()
                    end
                end
            end
            
            page.Visible = true
            tween(tabBtn, {BackgroundTransparency = 0}, 0.2):Play()
            tween(tabInd, {BackgroundTransparency = 0}, 0.2):Play()
            tween(tabLbl, {TextColor3 = clr.txt}, 0.2):Play()
            for _, c in pairs(tabX:GetChildren()) do
                tween(c, {BackgroundColor3 = clr.accent}, 0.2):Play()
            end
            win.activeTab = tab
        end
        
        tabBtn.MouseButton1Click:Connect(activate)
        
        tabBtn.MouseEnter:Connect(function()
            if win.activeTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 0.5}, 0.15):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if win.activeTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 1}, 0.15):Play()
            end
        end)
        
        function tab:CreateSection(name)
            local sec = create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = page
            })
            
            local secLbl = create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = string.upper(name or "SECTION"),
                TextColor3 = clr.txt3,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sec
            })
            
            local secLine = create("Frame", {
                Size = UDim2.new(1, -80, 0, 1),
                Position = UDim2.new(0, 75, 0.5, 0),
                BackgroundColor3 = clr.border,
                BorderSizePixel = 0,
                Parent = sec
            })
        end
        
        function tab:CreateButton(cfg)
            cfg = cfg or {}
            local bName = cfg.Name or "Button"
            local bDesc = cfg.Description
            local cb = cfg.Callback or function() end
            
            local h = bDesc and 52 or 38
            
            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = page
            })
            corner(btn, 8)
            stroke(btn, clr.border, 1)
            ripple(btn)
            
            local bLbl = create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 14, 0, bDesc and 8 or 9),
                BackgroundTransparency = 1,
                Text = bName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btn
            })
            
            if bDesc then
                local dLbl = create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 16),
                    Position = UDim2.new(0, 14, 0, 28),
                    BackgroundTransparency = 1,
                    Text = bDesc,
                    TextColor3 = clr.txt3,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = btn
                })
            end
            
            local arrow = create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Text = "›",
                TextColor3 = clr.txt3,
                TextSize = 22,
                Font = Enum.Font.GothamBold,
                Parent = btn
            })
            
            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = clr.bg2}, 0.15):Play()
                tween(btn.UIStroke, {Color = clr.accent}, 0.15):Play()
                tween(arrow, {TextColor3 = clr.accent, Position = UDim2.new(1, -25, 0.5, 0)}, 0.15):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = clr.bg3}, 0.15):Play()
                tween(btn.UIStroke, {Color = clr.border}, 0.15):Play()
                tween(arrow, {TextColor3 = clr.txt3, Position = UDim2.new(1, -30, 0.5, 0)}, 0.15):Play()
            end)
            
            btn.MouseButton1Click:Connect(cb)
            
            return btn
        end
        
        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local tName = cfg.Name or "Toggle"
            local tDesc = cfg.Description
            local def = cfg.Default or false
            local cb = cfg.Callback or function() end
            
            local state = def
            local h = tDesc and 52 or 38
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -80, 0, 20),
                Position = UDim2.new(0, 14, 0, tDesc and 8 or 9),
                BackgroundTransparency = 1,
                Text = tName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            if tDesc then
                create("TextLabel", {
                    Size = UDim2.new(1, -80, 0, 16),
                    Position = UDim2.new(0, 14, 0, 28),
                    BackgroundTransparency = 1,
                    Text = tDesc,
                    TextColor3 = clr.txt3,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder
                })
            end
            
            local togBg = create("Frame", {
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -58, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and clr.accent or clr.bg,
                BorderSizePixel = 0,
                Parent = holder
            })
            corner(togBg, 12)
            stroke(togBg, state and clr.accent or clr.border, 1)
            
            local togCircle = create("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = togBg
            })
            corner(togCircle, 9)
            
            local function upd()
                if state then
                    tween(togBg, {BackgroundColor3 = clr.accent}, 0.2):Play()
                    tween(togBg.UIStroke, {Color = clr.accent}, 0.2):Play()
                    tween(togCircle, {Position = UDim2.new(1, -21, 0.5, 0)}, 0.2):Play()
                else
                    tween(togBg, {BackgroundColor3 = clr.bg}, 0.2):Play()
                    tween(togBg.UIStroke, {Color = clr.border}, 0.2):Play()
                    tween(togCircle, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.2):Play()
                end
            end
            
            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = holder
            })
            
            btn.MouseButton1Click:Connect(function()
                state = not state
                upd()
                cb(state)
            end)
            
            local tog = {}
            function tog:Set(v)
                state = v
                upd()
                cb(state)
            end
            return tog
        end
        
        function tab:CreateSlider(cfg)
            cfg = cfg or {}
            local sName = cfg.Name or "Slider"
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local def = cfg.Default or min
            local suffix = cfg.Suffix or ""
            local cb = cfg.Callback or function() end
            
            local val = def
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 14, 0, 10),
                BackgroundTransparency = 1,
                Text = sName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local valBox = create("TextBox", {
                Size = UDim2.new(0, 50, 0, 22),
                Position = UDim2.new(1, -60, 0, 8),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Text = tostring(val) .. suffix,
                TextColor3 = clr.accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ClearTextOnFocus = true,
                Parent = holder
            })
            corner(valBox, 6)
            
            local sliderBg = create("Frame", {
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 0, 40),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Parent = holder
            })
            corner(sliderBg, 3)
            
            local sliderFill = create("Frame", {
                Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = clr.accent,
                BorderSizePixel = 0,
                Parent = sliderBg
            })
            corner(sliderFill, 3)
            gradient(sliderFill, clr.accent, clr.accent2, 0)
            
            local sliderKnob = create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((def - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = sliderBg
            })
            corner(sliderKnob, 7)
            
            local sliding = false
            
            local function upd(input)
                local pct = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pct)
                valBox.Text = tostring(val) .. suffix
                tween(sliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05):Play()
                tween(sliderKnob, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.05):Play()
                cb(val)
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    upd(input)
                end
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    upd(input)
                end
            end)
            
            valBox.FocusLost:Connect(function()
                local num = tonumber(valBox.Text:gsub(suffix, ""))
                if num then
                    val = math.clamp(num, min, max)
                end
                valBox.Text = tostring(val) .. suffix
                local pct = (val - min) / (max - min)
                sliderFill.Size = UDim2.new(pct, 0, 1, 0)
                sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                cb(val)
            end)
            
            local sld = {}
            function sld:Set(v)
                val = math.clamp(v, min, max)
                valBox.Text = tostring(val) .. suffix
                local pct = (val - min) / (max - min)
                sliderFill.Size = UDim2.new(pct, 0, 1, 0)
                sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                cb(val)
            end
            return sld
        end
        
        function tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local dName = cfg.Name or "Dropdown"
            local opts = cfg.Options or {}
            local def = cfg.Default or (opts[1] or "Select...")
            local cb = cfg.Callback or function() end
            
            local sel = def
            local open = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(0.45, 0, 0, 38),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = dName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local selBtn = create("TextButton", {
                Size = UDim2.new(0.5, -20, 0, 28),
                Position = UDim2.new(0.5, 5, 0, 5),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = holder
            })
            corner(selBtn, 6)
            stroke(selBtn, clr.border, 1)
            
            local selLbl = create("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = sel,
                TextColor3 = clr.txt2,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selBtn
            })
            
            local arrow = create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1,
                Text = "⌄",
                TextColor3 = clr.accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = selBtn
            })
            
            local optFrame = create("Frame", {
                Size = UDim2.new(0.5, -20, 0, math.min(#opts * 30, 150)),
                Position = UDim2.new(0.5, 5, 0, 40),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Visible = false,
                ClipsDescendants = true,
                Parent = holder
            })
            corner(optFrame, 6)
            
            local optScroll = create("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = clr.accent,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0, 0, 0, #opts * 30),
                Parent = optFrame
            })
            
            local optLayout = create("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = optScroll
            })
            
            local function makeOpts()
                for _, c in pairs(optScroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                optScroll.CanvasSize = UDim2.new(0, 0, 0, #opts * 30)
                optFrame.Size = UDim2.new(0.5, -20, 0, math.min(#opts * 30, 150))
                
                for _, o in ipairs(opts) do
                    local optBtn = create("TextButton", {
                        Size = UDim2.new(1, -4, 0, 28),
                        BackgroundColor3 = clr.bg2,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Text = o,
                        TextColor3 = clr.txt2,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false,
                        Parent = optScroll
                    })
                    corner(optBtn, 4)
                    
                    optBtn.MouseEnter:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 0, TextColor3 = clr.accent}, 0.1):Play()
                    end)
                    optBtn.MouseLeave:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 1, TextColor3 = clr.txt2}, 0.1):Play()
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        sel = o
                        selLbl.Text = o
                        open = false
                        optFrame.Visible = false
                        tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.2):Play()
                        tween(arrow, {Rotation = 0}, 0.2):Play()
                        cb(o)
                    end)
                end
            end
            makeOpts()
            
            selBtn.MouseButton1Click:Connect(function()
                open = not open
                optFrame.Visible = open
                if open then
                    tween(holder, {Size = UDim2.new(1, 0, 0, 45 + math.min(#opts * 30, 150))}, 0.2):Play()
                    tween(arrow, {Rotation = 180}, 0.2):Play()
                else
                    tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.2):Play()
                    tween(arrow, {Rotation = 0}, 0.2):Play()
                end
            end)
            
            local dd = {}
            function dd:Set(v)
                sel = v
                selLbl.Text = v
                cb(v)
            end
            function dd:Refresh(newOpts)
                opts = newOpts
                makeOpts()
            end
            return dd
        end
        
        function tab:CreateTextbox(cfg)
            cfg = cfg or {}
            local iName = cfg.Name or "Input"
            local placeholder = cfg.Placeholder or "Type here..."
            local cb = cfg.Callback or function() end
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = iName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local input = create("TextBox", {
                Size = UDim2.new(0.6, -20, 0, 28),
                Position = UDim2.new(0.4, 5, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder,
                PlaceholderColor3 = clr.txt3,
                TextColor3 = clr.txt,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = holder
            })
            corner(input, 6)
            local inpStroke = stroke(input, clr.border, 1)
            
            input.Focused:Connect(function()
                tween(inpStroke, {Color = clr.accent}, 0.15):Play()
            end)
            input.FocusLost:Connect(function(enter)
                tween(inpStroke, {Color = clr.border}, 0.15):Play()
                if enter then cb(input.Text) end
            end)
            
            local inp = {}
            function inp:Set(v) input.Text = v end
            return inp
        end
        
        function tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local kName = cfg.Name or "Keybind"
            local def = cfg.Default or Enum.KeyCode.Unknown
            local cb = cfg.Callback or function() end
            
            local key = def
            local waiting = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -90, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = kName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local keyBtn = create("TextButton", {
                Size = UDim2.new(0, 70, 0, 26),
                Position = UDim2.new(1, -80, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Text = key.Name or "None",
                TextColor3 = clr.accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = holder
            })
            corner(keyBtn, 6)
            local keyStroke = stroke(keyBtn, clr.border, 1)
            
            keyBtn.MouseButton1Click:Connect(function()
                waiting = true
                keyBtn.Text = "..."
                tween(keyStroke, {Color = clr.accent}, 0.15):Play()
            end)
            
            UIS.InputBegan:Connect(function(input, gpe)
                if waiting then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        keyBtn.Text = key.Name
                        waiting = false
                        tween(keyStroke, {Color = clr.border}, 0.15):Play()
                    end
                elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key and not gpe then
                    cb(key)
                end
            end)
            
            local kb = {}
            function kb:Set(k)
                key = k
                keyBtn.Text = k.Name
            end
            return kb
        end
        
        function tab:CreateLabel(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Label"
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = clr.txt2,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = page
            })
            
            local l = {}
            function l:Set(t) lbl.Text = t end
            return l
        end
        
        function tab:CreateColorPicker(cfg)
            cfg = cfg or {}
            local cName = cfg.Name or "Color"
            local def = cfg.Default or clr.accent
            local cb = cfg.Callback or function() end
            
            local col = def
            local open = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            corner(holder, 8)
            stroke(holder, clr.border, 1)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 38),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = cName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local preview = create("TextButton", {
                Size = UDim2.new(0, 50, 0, 24),
                Position = UDim2.new(1, -60, 0, 7),
                BackgroundColor3 = col,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = holder
            })
            corner(preview, 6)
            stroke(preview, clr.border, 1)
            
            local pickerFrame = create("Frame", {
                Size = UDim2.new(1, -28, 0, 140),
                Position = UDim2.new(0, 14, 0, 45),
                BackgroundColor3 = clr.bg,
                BorderSizePixel = 0,
                Visible = false,
                Parent = holder
            })
            corner(pickerFrame, 8)
            
            local satVal = create("ImageLabel", {
                Size = UDim2.new(0, 120, 0, 120),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = Color3.fromHSV(0, 1, 1),
                BorderSizePixel = 0,
                Image = "rbxassetid://4155801252",
                Parent = pickerFrame
            })
            corner(satVal, 6)
            
            local svBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = satVal
            })
            
            local svCursor = create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = satVal
            })
            corner(svCursor, 6)
            stroke(svCursor, clr.bg, 2)
            
            local hueBar = create("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 120),
                Position = UDim2.new(0, 140, 0, 10),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Image = "rbxassetid://3641079629",
                Parent = pickerFrame
            })
            corner(hueBar, 6)
            
            local hueBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = hueBar
            })
            
            local hueCursor = create("Frame", {
                Size = UDim2.new(1, 6, 0, 8),
                Position = UDim2.new(0.5, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = hueBar
            })
            corner(hueCursor, 4)
            stroke(hueCursor, clr.bg, 2)
            
            local hexBox = create("TextBox", {
                Size = UDim2.new(0, 80, 0, 26),
                Position = UDim2.new(0, 170, 0, 10),
                BackgroundColor3 = clr.bg2,
                BorderSizePixel = 0,
                Text = string.format("#%02X%02X%02X", col.R * 255, col.G * 255, col.B * 255),
                TextColor3 = clr.txt,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                Parent = pickerFrame
            })
            corner(hexBox, 6)
            
            local h, s, v = col:ToHSV()
            
            local function updCol()
                col = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = col
                satVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                hexBox.Text = string.format("#%02X%02X%02X", math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255))
                cb(col)
            end
            
            local svDrag, hueDrag = false, false
            
            svBtn.MouseButton1Down:Connect(function() svDrag = true end)
            hueBtn.MouseButton1Down:Connect(function() hueDrag = true end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDrag, hueDrag = false, false
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if svDrag then
                        s = math.clamp((input.Position.X - satVal.AbsolutePosition.X) / satVal.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((input.Position.Y - satVal.AbsolutePosition.Y) / satVal.AbsoluteSize.Y, 0, 1)
                        updCol()
                    elseif hueDrag then
                        h = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        updCol()
                    end
                end
            end)
            
            hexBox.FocusLost:Connect(function()
                local hex = hexBox.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1, 2), 16) or 255
                    local g = tonumber(hex:sub(3, 4), 16) or 51
                    local b = tonumber(hex:sub(5, 6), 16) or 51
                    col = Color3.fromRGB(r, g, b)
                    h, s, v = col:ToHSV()
                    updCol()
                end
            end)
            
            preview.MouseButton1Click:Connect(function()
                open = not open
                pickerFrame.Visible = open
                tween(holder, {Size = UDim2.new(1, 0, 0, open and 195 or 38)}, 0.25):Play()
            end)
            
            updCol()
            
            local cp = {}
            function cp:Set(c)
                col = c
                h, s, v = c:ToHSV()
                updCol()
            end
            return cp
        end
        
        table.insert(win.tabs, tab)
        if #win.tabs == 1 then activate() end
        
        return tab
    end
    
    return win
end

return MDLib
