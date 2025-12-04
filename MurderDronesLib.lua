local MDLib = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

local clr = {
    bg1 = Color3.fromRGB(26, 26, 31),
    bg2 = Color3.fromRGB(37, 37, 48),
    bg3 = Color3.fromRGB(45, 45, 58),
    accent = Color3.fromRGB(255, 51, 51),
    accent2 = Color3.fromRGB(153, 51, 255),
    txt = Color3.fromRGB(255, 255, 255),
    txt2 = Color3.fromRGB(180, 180, 180),
    dark = Color3.fromRGB(18, 18, 22),
    glow = Color3.fromRGB(255, 80, 80)
}

local notifs = {}

local function tween(obj, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
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

local function addCorner(obj, rad)
    return create("UICorner", {CornerRadius = UDim.new(0, rad or 6), Parent = obj})
end

local function addStroke(obj, col, thick)
    return create("UIStroke", {Color = col or clr.accent, Thickness = thick or 1, Parent = obj})
end

local function addPadding(obj, pad)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, pad),
        PaddingBottom = UDim.new(0, pad),
        PaddingLeft = UDim.new(0, pad),
        PaddingRight = UDim.new(0, pad),
        Parent = obj
    })
end

local function makeDraggable(frame, handle)
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
            tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05):Play()
        end
    end)
end

local function drawX(parent, size, col)
    local xFrame = create("Frame", {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local line1 = create("Frame", {
        Size = UDim2.new(0, size * 1.2, 0, 2),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = 45,
        BackgroundColor3 = col or clr.accent,
        BorderSizePixel = 0,
        Parent = xFrame
    })
    
    local line2 = create("Frame", {
        Size = UDim2.new(0, size * 1.2, 0, 2),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = -45,
        BackgroundColor3 = col or clr.accent,
        BorderSizePixel = 0,
        Parent = xFrame
    })
    
    return xFrame
end

function MDLib:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Murder Drones"
    local sz = cfg.Size or {500, 400}
    
    local sg = create("ScreenGui", {
        Name = "MurderDronesUI",
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
        BackgroundColor3 = clr.bg1,
        BorderSizePixel = 0,
        Parent = sg
    })
    addCorner(main, 8)
    addStroke(main, clr.accent, 2)
    
    local shadow = create("ImageLabel", {
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = main
    })
    
    local titleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = clr.dark,
        BorderSizePixel = 0,
        Parent = main
    })
    addCorner(titleBar, 8)
    
    local titleFix = create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = clr.dark,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    local xIcon = drawX(titleBar, 16, clr.accent)
    xIcon.Position = UDim2.new(0, 12, 0.5, 0)
    xIcon.AnchorPoint = Vector2.new(0, 0.5)
    
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = clr.txt,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = "",
        Parent = titleBar
    })
    
    local closeX = drawX(closeBtn, 12, clr.txt2)
    closeX.Position = UDim2.new(0.5, 0, 0.5, 0)
    closeX.AnchorPoint = Vector2.new(0.5, 0.5)
    
    closeBtn.MouseEnter:Connect(function()
        for _, c in pairs(closeX:GetChildren()) do
            tween(c, {BackgroundColor3 = clr.accent}, 0.15):Play()
        end
    end)
    
    closeBtn.MouseLeave:Connect(function()
        for _, c in pairs(closeX:GetChildren()) do
            tween(c, {BackgroundColor3 = clr.txt2}, 0.15):Play()
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
        wait(0.3)
        sg:Destroy()
    end)
    
    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -65, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = "-",
        TextColor3 = clr.txt2,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = titleBar
    })
    
    local minimized = false
    local origSize = main.Size
    
    minBtn.MouseEnter:Connect(function()
        tween(minBtn, {TextColor3 = clr.accent}, 0.15):Play()
    end)
    
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, {TextColor3 = clr.txt2}, 0.15):Play()
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, sz[1], 0, 35)}, 0.2):Play()
        else
            tween(main, {Size = origSize}, 0.2):Play()
        end
    end)
    
    makeDraggable(main, titleBar)
    
    local tabHolder = create("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 130, 1, -45),
        Position = UDim2.new(0, 5, 0, 40),
        BackgroundColor3 = clr.bg2,
        BorderSizePixel = 0,
        Parent = main
    })
    addCorner(tabHolder, 6)
    
    local tabList = create("ScrollingFrame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = clr.accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = tabHolder
    })
    
    local tabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    local contentHolder = create("Frame", {
        Name = "ContentHolder",
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.new(0, 140, 0, 40),
        BackgroundColor3 = clr.bg2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = main
    })
    addCorner(contentHolder, 6)
    
    local win = {}
    win.tabs = {}
    win.activeTab = nil
    win.gui = sg
    win.main = main
    
    local notifHolder = create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 250, 1, -20),
        Position = UDim2.new(1, -260, 0, 10),
        BackgroundTransparency = 1,
        Parent = sg
    })
    
    local notifLayout = create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = notifHolder
    })
    
    function win:Notify(cfg)
        cfg = cfg or {}
        local ntitle = cfg.Title or "Notification"
        local desc = cfg.Description or ""
        local dur = cfg.Duration or 3
        
        local notif = create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = clr.bg1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = notifHolder
        })
        addCorner(notif, 6)
        addStroke(notif, clr.accent, 1)
        
        local nIcon = drawX(notif, 14, clr.accent)
        nIcon.Position = UDim2.new(0, 12, 0, 12)
        
        local nTitle = create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 20),
            Position = UDim2.new(0, 35, 0, 8),
            BackgroundTransparency = 1,
            Text = ntitle,
            TextColor3 = clr.accent,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notif
        })
        
        local nDesc = create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 28),
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = clr.txt2,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = notif
        })
        
        notif.Size = UDim2.new(1, 0, 0, 0)
        tween(notif, {Size = UDim2.new(1, 0, 0, 60)}, 0.2):Play()
        
        task.delay(dur, function()
            tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.2):Play()
            wait(0.2)
            notif:Destroy()
        end)
    end
    
    function win:CreateTab(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Tab"
        local icon = cfg.Icon or "X"
        
        local tabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = clr.bg3,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = tabList
        })
        addCorner(tabBtn, 4)
        
        local tabIcon
        if icon == "X" then
            tabIcon = drawX(tabBtn, 12, clr.txt2)
            tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
            tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        end
        
        local tabName = create("TextLabel", {
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = clr.txt2,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        local indicator = create("Frame", {
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = clr.accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Parent = tabBtn
        })
        addCorner(indicator, 2)
        
        local content = create("ScrollingFrame", {
            Size = UDim2.new(1, -15, 1, -10),
            Position = UDim2.new(0, 8, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = clr.accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentHolder
        })
        
        local contentLayout = create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = content
        })
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local tab = {}
        tab.btn = tabBtn
        tab.content = content
        
        local function activate()
            for _, t in pairs(win.tabs) do
                tween(t.btn, {BackgroundColor3 = clr.bg3}, 0.15):Play()
                t.content.Visible = false
                for _, c in pairs(t.btn:GetDescendants()) do
                    if c:IsA("Frame") and c.Parent.Name ~= "TitleBar" then
                        tween(c, {BackgroundColor3 = clr.txt2}, 0.15):Play()
                    end
                    if c:IsA("TextLabel") then
                        tween(c, {TextColor3 = clr.txt2}, 0.15):Play()
                    end
                end
                local ind = t.btn:FindFirstChild("Frame")
                if ind and ind.Size.X.Offset == 3 then
                    tween(ind, {BackgroundTransparency = 1}, 0.15):Play()
                end
            end
            
            tween(tabBtn, {BackgroundColor3 = clr.bg1}, 0.15):Play()
            content.Visible = true
            tween(indicator, {BackgroundTransparency = 0}, 0.15):Play()
            tween(tabName, {TextColor3 = clr.txt}, 0.15):Play()
            if tabIcon then
                for _, c in pairs(tabIcon:GetChildren()) do
                    tween(c, {BackgroundColor3 = clr.accent}, 0.15):Play()
                end
            end
            win.activeTab = tab
        end
        
        tabBtn.MouseButton1Click:Connect(activate)
        
        tabBtn.MouseEnter:Connect(function()
            if win.activeTab ~= tab then
                tween(tabBtn, {BackgroundColor3 = clr.bg1}, 0.1):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if win.activeTab ~= tab then
                tween(tabBtn, {BackgroundColor3 = clr.bg3}, 0.1):Play()
            end
        end)
        
        function tab:CreateButton(cfg)
            cfg = cfg or {}
            local btnName = cfg.Name or "Button"
            local cb = cfg.Callback or function() end
            
            local btn = create("TextButton", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = content
            })
            addCorner(btn, 4)
            addStroke(btn, clr.bg1, 1)
            
            local btnLbl = create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = btnName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btn
            })
            
            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = clr.bg2}, 0.1):Play()
                tween(btn.UIStroke, {Color = clr.accent}, 0.1):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = clr.bg3}, 0.1):Play()
                tween(btn.UIStroke, {Color = clr.bg1}, 0.1):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = clr.accent}, 0.05):Play()
                wait(0.05)
                tween(btn, {BackgroundColor3 = clr.bg3}, 0.1):Play()
                cb()
            end)
            
            return btn
        end
        
        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local tName = cfg.Name or "Toggle"
            local def = cfg.Default or false
            local cb = cfg.Callback or function() end
            
            local state = def
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = tName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local toggleBg = create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and clr.accent or clr.bg1,
                BorderSizePixel = 0,
                Parent = holder
            })
            addCorner(toggleBg, 10)
            
            local toggleCircle = create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = toggleBg
            })
            addCorner(toggleCircle, 8)
            
            local function updateToggle()
                if state then
                    tween(toggleBg, {BackgroundColor3 = clr.accent}, 0.15):Play()
                    tween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.15):Play()
                else
                    tween(toggleBg, {BackgroundColor3 = clr.bg1}, 0.15):Play()
                    tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.15):Play()
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
                updateToggle()
                cb(state)
            end)
            
            local tog = {}
            function tog:Set(v)
                state = v
                updateToggle()
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
            local cb = cfg.Callback or function() end
            
            local val = def
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 50),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = sName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local valLbl = create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -55, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = clr.accent2,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = holder
            })
            
            local sliderBg = create("Frame", {
                Size = UDim2.new(1, -20, 0, 8),
                Position = UDim2.new(0, 10, 0, 32),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Parent = holder
            })
            addCorner(sliderBg, 4)
            
            local sliderFill = create("Frame", {
                Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = clr.accent2,
                BorderSizePixel = 0,
                Parent = sliderBg
            })
            addCorner(sliderFill, 4)
            
            local sliderBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 10),
                Position = UDim2.new(0, 0, 0, -5),
                BackgroundTransparency = 1,
                Text = "",
                Parent = sliderBg
            })
            
            local sliding = false
            
            local function update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                tween(sliderFill, {Size = pos}, 0.05):Play()
                val = math.floor(min + (max - min) * pos.X.Scale)
                valLbl.Text = tostring(val)
                cb(val)
            end
            
            sliderBtn.MouseButton1Down:Connect(function()
                sliding = true
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            sliderBtn.MouseButton1Click:Connect(function()
                update({Position = Vector3.new(mouse.X, 0, 0)})
            end)
            
            local sld = {}
            function sld:Set(v)
                val = v
                valLbl.Text = tostring(v)
                sliderFill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                cb(v)
            end
            
            return sld
        end
        
        function tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local dName = cfg.Name or "Dropdown"
            local opts = cfg.Options or {}
            local def = cfg.Default or (opts[1] or "")
            local cb = cfg.Callback or function() end
            
            local sel = def
            local open = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(0.5, -10, 0, 32),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = dName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local selBtn = create("TextButton", {
                Size = UDim2.new(0.5, -15, 0, 24),
                Position = UDim2.new(0.5, 5, 0, 4),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Text = sel,
                TextColor3 = clr.txt2,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false,
                Parent = holder
            })
            addCorner(selBtn, 4)
            
            local arrow = create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                Text = "v",
                TextColor3 = clr.accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = selBtn
            })
            
            local optHolder = create("Frame", {
                Size = UDim2.new(0.5, -15, 0, #opts * 26),
                Position = UDim2.new(0.5, 5, 0, 32),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Visible = false,
                Parent = holder
            })
            addCorner(optHolder, 4)
            
            local optLayout = create("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = optHolder
            })
            
            for _, o in ipairs(opts) do
                local optBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundColor3 = clr.bg2,
                    BorderSizePixel = 0,
                    Text = o,
                    TextColor3 = clr.txt2,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    Parent = optHolder
                })
                addCorner(optBtn, 3)
                
                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundColor3 = clr.bg3, TextColor3 = clr.accent}, 0.1):Play()
                end)
                
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, {BackgroundColor3 = clr.bg2, TextColor3 = clr.txt2}, 0.1):Play()
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    sel = o
                    selBtn.Text = o
                    open = false
                    optHolder.Visible = false
                    tween(holder, {Size = UDim2.new(1, -5, 0, 32)}, 0.15):Play()
                    tween(arrow, {Rotation = 0}, 0.15):Play()
                    cb(o)
                end)
            end
            
            selBtn.MouseButton1Click:Connect(function()
                open = not open
                optHolder.Visible = open
                if open then
                    tween(holder, {Size = UDim2.new(1, -5, 0, 36 + #opts * 26)}, 0.15):Play()
                    tween(arrow, {Rotation = 180}, 0.15):Play()
                else
                    tween(holder, {Size = UDim2.new(1, -5, 0, 32)}, 0.15):Play()
                    tween(arrow, {Rotation = 0}, 0.15):Play()
                end
            end)
            
            local dd = {}
            function dd:Set(v)
                sel = v
                selBtn.Text = v
                cb(v)
            end
            
            function dd:Refresh(newOpts)
                for _, c in pairs(optHolder:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                opts = newOpts
                optHolder.Size = UDim2.new(0.5, -15, 0, #opts * 26)
                for _, o in ipairs(opts) do
                    local optBtn = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = clr.bg2,
                        BorderSizePixel = 0,
                        Text = o,
                        TextColor3 = clr.txt2,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false,
                        Parent = optHolder
                    })
                    addCorner(optBtn, 3)
                    
                    optBtn.MouseEnter:Connect(function()
                        tween(optBtn, {BackgroundColor3 = clr.bg3, TextColor3 = clr.accent}, 0.1):Play()
                    end)
                    
                    optBtn.MouseLeave:Connect(function()
                        tween(optBtn, {BackgroundColor3 = clr.bg2, TextColor3 = clr.txt2}, 0.1):Play()
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        sel = o
                        selBtn.Text = o
                        open = false
                        optHolder.Visible = false
                        tween(holder, {Size = UDim2.new(1, -5, 0, 32)}, 0.15):Play()
                        tween(arrow, {Rotation = 0}, 0.15):Play()
                        cb(o)
                    end)
                end
            end
            
            return dd
        end
        
        function tab:CreateTextInput(cfg)
            cfg = cfg or {}
            local iName = cfg.Name or "Input"
            local placeholder = cfg.Placeholder or "Enter text..."
            local cb = cfg.Callback or function() end
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(0.4, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = iName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local inputBox = create("TextBox", {
                Size = UDim2.new(0.6, -15, 0, 24),
                Position = UDim2.new(0.4, 5, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder,
                PlaceholderColor3 = clr.txt2,
                TextColor3 = clr.txt,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = holder
            })
            addCorner(inputBox, 4)
            local inputStroke = addStroke(inputBox, clr.bg2, 1)
            
            inputBox.Focused:Connect(function()
                tween(inputStroke, {Color = clr.accent}, 0.15):Play()
            end)
            
            inputBox.FocusLost:Connect(function(enter)
                tween(inputStroke, {Color = clr.bg2}, 0.15):Play()
                if enter then
                    cb(inputBox.Text)
                end
            end)
            
            local inp = {}
            function inp:Set(v)
                inputBox.Text = v
            end
            
            return inp
        end
        
        function tab:CreateLabel(cfg)
            cfg = cfg or {}
            local text = cfg.Text or "Label"
            local desc = cfg.Description or nil
            
            local h = desc and 45 or 28
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, h),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -20, 0, desc and 18 or h),
                Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            if desc then
                local descLbl = create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 18),
                    Position = UDim2.new(0, 10, 0, 24),
                    BackgroundTransparency = 1,
                    Text = desc,
                    TextColor3 = clr.txt2,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder
                })
            end
            
            local lret = {}
            function lret:Set(t)
                lbl.Text = t
            end
            
            return lret
        end
        
        function tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local kName = cfg.Name or "Keybind"
            local def = cfg.Default or Enum.KeyCode.Unknown
            local cb = cfg.Callback or function() end
            
            local key = def
            local waiting = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = kName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local keyBtn = create("TextButton", {
                Size = UDim2.new(0, 60, 0, 24),
                Position = UDim2.new(1, -70, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Text = key.Name or "None",
                TextColor3 = clr.accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = holder
            })
            addCorner(keyBtn, 4)
            local keyStroke = addStroke(keyBtn, clr.bg2, 1)
            
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
                        tween(keyStroke, {Color = clr.bg2}, 0.15):Play()
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
        
        function tab:CreateColorPicker(cfg)
            cfg = cfg or {}
            local cName = cfg.Name or "Color"
            local def = cfg.Default or Color3.fromRGB(255, 51, 51)
            local cb = cfg.Callback or function() end
            
            local col = def
            local open = false
            
            local holder = create("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundColor3 = clr.bg3,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = content
            })
            addCorner(holder, 4)
            
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 32),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = cName,
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })
            
            local preview = create("TextButton", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0, 6),
                BackgroundColor3 = col,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = holder
            })
            addCorner(preview, 4)
            addStroke(preview, clr.bg1, 1)
            
            local pickerFrame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 130),
                Position = UDim2.new(0, 10, 0, 38),
                BackgroundColor3 = clr.bg1,
                BorderSizePixel = 0,
                Visible = false,
                Parent = holder
            })
            addCorner(pickerFrame, 4)
            
            local satVal = create("ImageLabel", {
                Size = UDim2.new(0, 100, 0, 100),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundColor3 = Color3.fromHSV(0, 1, 1),
                BorderSizePixel = 0,
                Image = "rbxassetid://4155801252",
                Parent = pickerFrame
            })
            addCorner(satVal, 4)
            
            local satValBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = satVal
            })
            
            local svCursor = create("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(1, -5, 0, -5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = satVal
            })
            addCorner(svCursor, 5)
            addStroke(svCursor, clr.dark, 2)
            
            local hueBar = create("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 100),
                Position = UDim2.new(0, 115, 0, 5),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Image = "rbxassetid://3641079629",
                Parent = pickerFrame
            })
            addCorner(hueBar, 4)
            
            local hueBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = hueBar
            })
            
            local hueCursor = create("Frame", {
                Size = UDim2.new(1, 4, 0, 6),
                Position = UDim2.new(0, -2, 0, 0),
                BackgroundColor3 = clr.txt,
                BorderSizePixel = 0,
                Parent = hueBar
            })
            addCorner(hueCursor, 3)
            addStroke(hueCursor, clr.dark, 1)
            
            local hexInput = create("TextBox", {
                Size = UDim2.new(0, 70, 0, 20),
                Position = UDim2.new(0, 145, 0, 5),
                BackgroundColor3 = clr.bg2,
                BorderSizePixel = 0,
                Text = string.format("#%02X%02X%02X", col.R * 255, col.G * 255, col.B * 255),
                TextColor3 = clr.txt,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = pickerFrame
            })
            addCorner(hexInput, 4)
            
            local h, s, v = col:ToHSV()
            
            local function updateColor()
                col = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = col
                satVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                hueCursor.Position = UDim2.new(0, -2, h, 0)
                hexInput.Text = string.format("#%02X%02X%02X", math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255))
                cb(col)
            end
            
            local svDragging, hueDragging = false, false
            
            satValBtn.MouseButton1Down:Connect(function()
                svDragging = true
            end)
            
            hueBtn.MouseButton1Down:Connect(function()
                hueDragging = true
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                    hueDragging = false
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if svDragging then
                        local rx = math.clamp((input.Position.X - satVal.AbsolutePosition.X) / satVal.AbsoluteSize.X, 0, 1)
                        local ry = math.clamp((input.Position.Y - satVal.AbsolutePosition.Y) / satVal.AbsoluteSize.Y, 0, 1)
                        s, v = rx, 1 - ry
                        updateColor()
                    elseif hueDragging then
                        local ry = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        h = ry
                        updateColor()
                    end
                end
            end)
            
            hexInput.FocusLost:Connect(function()
                local hex = hexInput.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1, 2), 16) or 255
                    local g = tonumber(hex:sub(3, 4), 16) or 51
                    local b = tonumber(hex:sub(5, 6), 16) or 51
                    col = Color3.fromRGB(r, g, b)
                    h, s, v = col:ToHSV()
                    updateColor()
                end
            end)
            
            preview.MouseButton1Click:Connect(function()
                open = not open
                pickerFrame.Visible = open
                if open then
                    tween(holder, {Size = UDim2.new(1, -5, 0, 175)}, 0.2):Play()
                else
                    tween(holder, {Size = UDim2.new(1, -5, 0, 32)}, 0.2):Play()
                end
            end)
            
            updateColor()
            
            local cp = {}
            function cp:Set(c)
                col = c
                h, s, v = c:ToHSV()
                updateColor()
            end
            
            return cp
        end
        
        table.insert(win.tabs, tab)
        
        if #win.tabs == 1 then
            activate()
        end
        
        return tab
    end
    
    return win
end

return MDLib

