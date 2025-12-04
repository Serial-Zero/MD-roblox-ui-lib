local MDLib = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

local theme = {
    bg = Color3.fromRGB(15, 15, 20),
    card = Color3.fromRGB(22, 22, 30),
    elevated = Color3.fromRGB(30, 30, 40),
    border = Color3.fromRGB(40, 40, 55),
    accent = Color3.fromRGB(235, 55, 75),
    accentDark = Color3.fromRGB(180, 40, 60),
    text = Color3.fromRGB(240, 240, 245),
    textDim = Color3.fromRGB(150, 150, 165),
    textMuted = Color3.fromRGB(90, 90, 105),
    shadow = Color3.fromRGB(0, 0, 0)
}

local function tw(obj, props, dur)
    return TS:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function round(obj, r)
    return new("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = obj})
end

local function outline(obj, c, t)
    return new("UIStroke", {Color = c or theme.border, Thickness = t or 1, Transparency = 0.5, Parent = obj})
end

local function shadow(parent)
    local s = new("ImageLabel", {
        Size = UDim2.new(1, 50, 1, 50),
        Position = UDim2.new(0.5, 0, 0.5, 5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.shadow,
        ImageTransparency = 0.6,
        ZIndex = -5,
        Parent = parent
    })
    return s
end

local function drag(frame, handle)
    local d, di, ds, sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
            ds = i.Position
            sp = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then d = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and d then
            local delta = i.Position - ds
            tw(frame, {Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)}, 0.06):Play()
        end
    end)
end

function MDLib:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Murder Drones"
    local sz = cfg.Size or {520, 340}
    
    local gui = new("ScreenGui", {
        Name = "MDLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if syn then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = plr:WaitForChild("PlayerGui")
    end
    
    local main = new("Frame", {
        Size = UDim2.new(0, sz[1], 0, sz[2]),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0,
        Parent = gui
    })
    round(main, 12)
    outline(main, theme.accent, 1.5)
    shadow(main)
    
    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Parent = main
    })
    round(header, 12)
    
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Parent = header
    })
    
    local xIcon = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Parent = header
    })
    
    for _, r in ipairs({45, -45}) do
        local l = new("Frame", {
            Size = UDim2.new(0, 20, 0, 3),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = r,
            BackgroundColor3 = theme.accent,
            BorderSizePixel = 0,
            Parent = xIcon
        })
        round(l, 2)
    end
    
    new("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = theme.text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    local controls = new("Frame", {
        Size = UDim2.new(0, 56, 0, 24),
        Position = UDim2.new(1, -68, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Parent = header
    })
    
    local minBtn = new("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.elevated,
        BorderSizePixel = 0,
        Text = "",
        Parent = controls
    })
    round(minBtn, 6)
    
    new("Frame", {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.textDim,
        BorderSizePixel = 0,
        Parent = minBtn
    })
    
    local closeBtn = new("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = theme.elevated,
        BorderSizePixel = 0,
        Text = "",
        Parent = controls
    })
    round(closeBtn, 6)
    
    local closeX = new("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = closeBtn
    })
    
    for _, r in ipairs({45, -45}) do
        local l = new("Frame", {
            Size = UDim2.new(0, 12, 0, 2),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = r,
            BackgroundColor3 = theme.textDim,
            BorderSizePixel = 0,
            Parent = closeX
        })
        round(l, 1)
    end
    
    minBtn.MouseEnter:Connect(function() tw(minBtn, {BackgroundColor3 = theme.border}, 0.15):Play() end)
    minBtn.MouseLeave:Connect(function() tw(minBtn, {BackgroundColor3 = theme.elevated}, 0.15):Play() end)
    closeBtn.MouseEnter:Connect(function() 
        tw(closeBtn, {BackgroundColor3 = theme.accent}, 0.15):Play()
        for _, c in pairs(closeX:GetChildren()) do tw(c, {BackgroundColor3 = theme.text}, 0.15):Play() end
    end)
    closeBtn.MouseLeave:Connect(function() 
        tw(closeBtn, {BackgroundColor3 = theme.elevated}, 0.15):Play()
        for _, c in pairs(closeX:GetChildren()) do tw(c, {BackgroundColor3 = theme.textDim}, 0.15):Play() end
    end)
    
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tw(main, {Size = minimized and UDim2.new(0, sz[1], 0, 44) or UDim2.new(0, sz[1], 0, sz[2])}, 0.25):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        tw(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.25):Play()
        task.wait(0.25)
        gui:Destroy()
    end)
    
    drag(main, header)
    
    local body = new("Frame", {
        Size = UDim2.new(1, -20, 1, -54),
        Position = UDim2.new(0, 10, 0, 48),
        BackgroundTransparency = 1,
        Parent = main
    })
    
    local sidebar = new("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        Parent = body
    })
    round(sidebar, 10)
    
    local tabList = new("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    
    local tabLayout = new("UIListLayout", {Padding = UDim.new(0, 4), Parent = tabList})
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    local content = new("Frame", {
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.new(0, 130, 0, 0),
        BackgroundColor3 = theme.card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = body
    })
    round(content, 10)
    
    local win = {tabs = {}, active = nil, gui = gui, main = main}
    
    local notifHolder = new("Frame", {
        Size = UDim2.new(0, 260, 1, -20),
        Position = UDim2.new(1, -270, 0, 10),
        BackgroundTransparency = 1,
        Parent = gui
    })
    new("UIListLayout", {Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifHolder})
    
    function win:Notify(cfg)
        cfg = cfg or {}
        local t = cfg.Title or "Notice"
        local d = cfg.Description or ""
        local dur = cfg.Duration or 3
        
        local n = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = theme.card,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = notifHolder
        })
        round(n, 10)
        outline(n, theme.border)
        
        new("Frame", {
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.new(0, 10, 0, 8),
            BackgroundColor3 = theme.accent,
            BorderSizePixel = 0,
            Parent = n
        })
        
        new("TextLabel", {
            Size = UDim2.new(1, -35, 0, 18),
            Position = UDim2.new(0, 22, 0, 10),
            BackgroundTransparency = 1,
            Text = t,
            TextColor3 = theme.text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = n
        })
        
        new("TextLabel", {
            Size = UDim2.new(1, -35, 0, 28),
            Position = UDim2.new(0, 22, 0, 28),
            BackgroundTransparency = 1,
            Text = d,
            TextColor3 = theme.textDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = n
        })
        
        tw(n, {Size = UDim2.new(1, 0, 0, 64)}, 0.25):Play()
        task.delay(dur, function()
            tw(n, {Size = UDim2.new(1, 0, 0, 0)}, 0.2):Play()
            task.wait(0.2)
            n:Destroy()
        end)
    end
    
    function win:CreateTab(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Tab"
        
        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = theme.elevated,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = tabList
        })
        round(btn, 8)
        
        local indicator = new("Frame", {
            Size = UDim2.new(0, 3, 0.5, 0),
            Position = UDim2.new(0, 0, 0.25, 0),
            BackgroundColor3 = theme.accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = btn
        })
        round(indicator, 2)
        
        new("TextLabel", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = theme.textDim,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn
        })
        
        local page = new("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = theme.border,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content
        })
        
        local layout = new("UIListLayout", {Padding = UDim.new(0, 8), Parent = page})
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)
        
        local tab = {btn = btn, page = page}
        
        local function activate()
            for _, t in pairs(win.tabs) do
                t.page.Visible = false
                tw(t.btn, {BackgroundTransparency = 1}, 0.15):Play()
                local ind = t.btn:FindFirstChild("Frame")
                if ind then tw(ind, {BackgroundTransparency = 1}, 0.15):Play() end
                for _, c in pairs(t.btn:GetDescendants()) do
                    if c:IsA("TextLabel") then tw(c, {TextColor3 = theme.textDim}, 0.15):Play() end
                end
            end
            page.Visible = true
            tw(btn, {BackgroundTransparency = 0}, 0.15):Play()
            tw(indicator, {BackgroundTransparency = 0}, 0.15):Play()
            for _, c in pairs(btn:GetDescendants()) do
                if c:IsA("TextLabel") then tw(c, {TextColor3 = theme.text}, 0.15):Play() end
            end
            win.active = tab
        end
        
        btn.MouseButton1Click:Connect(activate)
        btn.MouseEnter:Connect(function()
            if win.active ~= tab then tw(btn, {BackgroundTransparency = 0.5}, 0.1):Play() end
        end)
        btn.MouseLeave:Connect(function()
            if win.active ~= tab then tw(btn, {BackgroundTransparency = 1}, 0.1):Play() end
        end)
        
        function tab:CreateButton(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Button"
            local cb = cfg.Callback or function() end
            
            local b = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = page
            })
            round(b, 8)
            outline(b, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = b
            })
            
            local arrow = new("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -28, 0, 0),
                BackgroundTransparency = 1,
                Text = "›",
                TextColor3 = theme.textMuted,
                TextSize = 18,
                Font = Enum.Font.GothamBold,
                Parent = b
            })
            
            b.MouseEnter:Connect(function()
                tw(b, {BackgroundColor3 = theme.border}, 0.1):Play()
                tw(arrow, {TextColor3 = theme.accent}, 0.1):Play()
            end)
            b.MouseLeave:Connect(function()
                tw(b, {BackgroundColor3 = theme.elevated}, 0.1):Play()
                tw(arrow, {TextColor3 = theme.textMuted}, 0.1):Play()
            end)
            b.MouseButton1Click:Connect(function()
                tw(b, {BackgroundColor3 = theme.accent}, 0.05):Play()
                task.wait(0.05)
                tw(b, {BackgroundColor3 = theme.elevated}, 0.1):Play()
                cb()
            end)
            return b
        end
        
        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Toggle"
            local def = cfg.Default or false
            local cb = cfg.Callback or function() end
            
            local state = def
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local track = new("Frame", {
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -48, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and theme.accent or theme.bg,
                BorderSizePixel = 0,
                Parent = h
            })
            round(track, 10)
            
            local knob = new("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = theme.text,
                BorderSizePixel = 0,
                Parent = track
            })
            round(knob, 8)
            
            local function upd()
                tw(track, {BackgroundColor3 = state and theme.accent or theme.bg}, 0.2):Play()
                tw(knob, {Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2):Play()
            end
            
            local btn = new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = h})
            btn.MouseButton1Click:Connect(function()
                state = not state
                upd()
                cb(state)
            end)
            
            return {Set = function(_, v) state = v upd() cb(state) end}
        end
        
        function tab:CreateSlider(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Slider"
            local min, max = cfg.Min or 0, cfg.Max or 100
            local def = cfg.Default or min
            local cb = cfg.Callback or function() end
            
            local val = def
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local valLbl = new("TextLabel", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = theme.accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = h
            })
            
            local trackBg = new("Frame", {
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, 36),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Parent = h
            })
            round(trackBg, 2)
            
            local fill = new("Frame", {
                Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = theme.accent,
                BorderSizePixel = 0,
                Parent = trackBg
            })
            round(fill, 2)
            
            local knob = new("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new((def - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = theme.text,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = trackBg
            })
            round(knob, 6)
            
            local sliding = false
            
            local function upd(i)
                local pct = math.clamp((i.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pct)
                valLbl.Text = tostring(val)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, 0, 0.5, 0)
                cb(val)
            end
            
            trackBg.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true upd(i) end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UIS.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end
            end)
            
            return {Set = function(_, v)
                val = math.clamp(v, min, max)
                valLbl.Text = tostring(val)
                local pct = (val - min) / (max - min)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, 0, 0.5, 0)
                cb(val)
            end}
        end
        
        function tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Dropdown"
            local opts = cfg.Options or {}
            local def = cfg.Default or (opts[1] or "Select")
            local cb = cfg.Callback or function() end
            
            local sel, open = def, false
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(0.4, 0, 0, 36),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local selBtn = new("TextButton", {
                Size = UDim2.new(0.55, -20, 0, 26),
                Position = UDim2.new(0.45, 5, 0, 5),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = h
            })
            round(selBtn, 6)
            
            local selLbl = new("TextLabel", {
                Size = UDim2.new(1, -28, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = sel,
                TextColor3 = theme.textDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selBtn
            })
            
            local arrow = new("TextLabel", {
                Size = UDim2.new(0, 16, 1, 0),
                Position = UDim2.new(1, -18, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = theme.textMuted,
                TextSize = 8,
                Font = Enum.Font.GothamBold,
                Parent = selBtn
            })
            
            local optFrame = new("Frame", {
                Size = UDim2.new(0.55, -20, 0, math.min(#opts * 28, 120)),
                Position = UDim2.new(0.45, 5, 0, 36),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Visible = false,
                Parent = h
            })
            round(optFrame, 6)
            
            local optScroll = new("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = theme.border,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0, 0, 0, #opts * 28),
                Parent = optFrame
            })
            new("UIListLayout", {Padding = UDim.new(0, 2), Parent = optScroll})
            
            local function makeOpts()
                for _, c in pairs(optScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                optScroll.CanvasSize = UDim2.new(0, 0, 0, #opts * 28)
                optFrame.Size = UDim2.new(0.55, -20, 0, math.min(#opts * 28, 120))
                
                for _, o in ipairs(opts) do
                    local ob = new("TextButton", {
                        Size = UDim2.new(1, -4, 0, 26),
                        BackgroundColor3 = theme.elevated,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Text = o,
                        TextColor3 = theme.textDim,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false,
                        Parent = optScroll
                    })
                    round(ob, 4)
                    
                    ob.MouseEnter:Connect(function() tw(ob, {BackgroundTransparency = 0, TextColor3 = theme.text}, 0.1):Play() end)
                    ob.MouseLeave:Connect(function() tw(ob, {BackgroundTransparency = 1, TextColor3 = theme.textDim}, 0.1):Play() end)
                    ob.MouseButton1Click:Connect(function()
                        sel = o
                        selLbl.Text = o
                        open = false
                        optFrame.Visible = false
                        tw(h, {Size = UDim2.new(1, 0, 0, 36)}, 0.15):Play()
                        tw(arrow, {Rotation = 0}, 0.15):Play()
                        cb(o)
                    end)
                end
            end
            makeOpts()
            
            selBtn.MouseButton1Click:Connect(function()
                open = not open
                optFrame.Visible = open
                tw(h, {Size = UDim2.new(1, 0, 0, open and (42 + math.min(#opts * 28, 120)) or 36)}, 0.15):Play()
                tw(arrow, {Rotation = open and 180 or 0}, 0.15):Play()
            end)
            
            return {
                Set = function(_, v) sel = v selLbl.Text = v cb(v) end,
                Refresh = function(_, o) opts = o makeOpts() end
            }
        end
        
        function tab:CreateTextbox(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Input"
            local ph = cfg.Placeholder or "Type..."
            local cb = cfg.Callback or function() end
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local input = new("TextBox", {
                Size = UDim2.new(0.6, -20, 0, 26),
                Position = UDim2.new(0.4, 5, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = ph,
                PlaceholderColor3 = theme.textMuted,
                TextColor3 = theme.text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = h
            })
            round(input, 6)
            
            local inpStroke = outline(input, theme.border)
            input.Focused:Connect(function() tw(inpStroke, {Color = theme.accent, Transparency = 0}, 0.15):Play() end)
            input.FocusLost:Connect(function(e)
                tw(inpStroke, {Color = theme.border, Transparency = 0.5}, 0.15):Play()
                if e then cb(input.Text) end
            end)
            
            return {Set = function(_, v) input.Text = v end}
        end
        
        function tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Keybind"
            local def = cfg.Default or Enum.KeyCode.Unknown
            local cb = cfg.Callback or function() end
            
            local key, waiting = def, false
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local keyBtn = new("TextButton", {
                Size = UDim2.new(0, 60, 0, 24),
                Position = UDim2.new(1, -70, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Text = key.Name or "None",
                TextColor3 = theme.accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = h
            })
            round(keyBtn, 6)
            
            keyBtn.MouseButton1Click:Connect(function()
                waiting = true
                keyBtn.Text = "..."
            end)
            
            UIS.InputBegan:Connect(function(i, g)
                if waiting then
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        key = i.KeyCode
                        keyBtn.Text = key.Name
                        waiting = false
                    end
                elseif i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == key and not g then
                    cb(key)
                end
            end)
            
            return {Set = function(_, k) key = k keyBtn.Text = k.Name end}
        end
        
        function tab:CreateColorPicker(cfg)
            cfg = cfg or {}
            local n = cfg.Name or "Color"
            local def = cfg.Default or theme.accent
            local cb = cfg.Callback or function() end
            
            local col, open = def, false
            
            local h = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = theme.elevated,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            round(h, 8)
            outline(h, theme.border)
            
            new("TextLabel", {
                Size = UDim2.new(1, -70, 0, 36),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = theme.text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = h
            })
            
            local preview = new("TextButton", {
                Size = UDim2.new(0, 44, 0, 22),
                Position = UDim2.new(1, -54, 0, 7),
                BackgroundColor3 = col,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = h
            })
            round(preview, 6)
            
            local picker = new("Frame", {
                Size = UDim2.new(1, -24, 0, 110),
                Position = UDim2.new(0, 12, 0, 42),
                BackgroundColor3 = theme.bg,
                BorderSizePixel = 0,
                Visible = false,
                Parent = h
            })
            round(picker, 8)
            
            local sv = new("ImageLabel", {
                Size = UDim2.new(0, 100, 0, 90),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = Color3.fromHSV(0, 1, 1),
                BorderSizePixel = 0,
                Image = "rbxassetid://4155801252",
                Parent = picker
            })
            round(sv, 6)
            
            local svBtn = new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = sv})
            
            local svCur = new("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = theme.text,
                BorderSizePixel = 0,
                Parent = sv
            })
            round(svCur, 5)
            outline(svCur, theme.bg, 2)
            
            local hue = new("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 90),
                Position = UDim2.new(0, 120, 0, 10),
                BackgroundColor3 = theme.text,
                BorderSizePixel = 0,
                Image = "rbxassetid://3641079629",
                Parent = picker
            })
            round(hue, 4)
            
            local hueBtn = new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = hue})
            
            local hueCur = new("Frame", {
                Size = UDim2.new(1, 4, 0, 6),
                Position = UDim2.new(0.5, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = theme.text,
                BorderSizePixel = 0,
                Parent = hue
            })
            round(hueCur, 3)
            outline(hueCur, theme.bg, 1)
            
            local hVal, sVal, vVal = col:ToHSV()
            local svD, hD = false, false
            
            local function upd()
                col = Color3.fromHSV(hVal, sVal, vVal)
                preview.BackgroundColor3 = col
                sv.BackgroundColor3 = Color3.fromHSV(hVal, 1, 1)
                svCur.Position = UDim2.new(sVal, 0, 1 - vVal, 0)
                hueCur.Position = UDim2.new(0.5, 0, hVal, 0)
                cb(col)
            end
            
            svBtn.MouseButton1Down:Connect(function() svD = true end)
            hueBtn.MouseButton1Down:Connect(function() hD = true end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then svD, hD = false, false end end)
            UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    if svD then
                        sVal = math.clamp((i.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
                        vVal = 1 - math.clamp((i.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
                        upd()
                    elseif hD then
                        hVal = math.clamp((i.Position.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
                        upd()
                    end
                end
            end)
            
            preview.MouseButton1Click:Connect(function()
                open = not open
                picker.Visible = open
                tw(h, {Size = UDim2.new(1, 0, 0, open and 160 or 36)}, 0.2):Play()
            end)
            
            upd()
            
            return {Set = function(_, c) col = c hVal, sVal, vVal = c:ToHSV() upd() end}
        end
        
        function tab:CreateLabel(cfg)
            cfg = cfg or {}
            local t = cfg.Text or "Label"
            
            local lbl = new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text = t,
                TextColor3 = theme.textDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = page
            })
            
            return {Set = function(_, v) lbl.Text = v end}
        end
        
        table.insert(win.tabs, tab)
        if #win.tabs == 1 then activate() end
        
        return tab
    end
    
    return win
end

return MDLib
