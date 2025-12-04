local lib = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local clr = {
    bg = Color3.fromRGB(13, 13, 15),
    card = Color3.fromRGB(20, 20, 22),
    border = Color3.fromRGB(31, 31, 35),
    txt = Color3.fromRGB(255, 255, 255),
    txtDim = Color3.fromRGB(139, 139, 139),
    accent = Color3.fromRGB(0, 212, 255),
    hover = Color3.fromRGB(28, 28, 32),
    toggle = Color3.fromRGB(40, 40, 45)
}

local ti = {
    fast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    med = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    open = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

local function tween(obj, props, info)
    ts:Create(obj, info or ti.med, props):Play()
end

local function create(c, p)
    local i = Instance.new(c)
    for k, v in pairs(p) do
        if k ~= "Parent" then
            i[k] = v
        end
    end
    if p.Parent then i.Parent = p.Parent end
    return i
end

local function corner(p, r)
    return create("UICorner", {CornerRadius = UDim.new(0, r or 6), Parent = p})
end

local function stroke(p, c, t)
    return create("UIStroke", {Color = c or clr.border, Thickness = t or 1, Parent = p})
end

local function pad(p, px)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, px),
        PaddingBottom = UDim.new(0, px),
        PaddingLeft = UDim.new(0, px),
        PaddingRight = UDim.new(0, px),
        Parent = p
    })
end

local notifs = {}

function lib:SetAccent(c)
    clr.accent = c
end

function lib:Notify(cfg)
    local dur = cfg.Duration or 3
    local scr = self._gui
    if not scr then return end
    
    local holder = scr:FindFirstChild("NotifHolder")
    if not holder then
        holder = create("Frame", {
            Name = "NotifHolder",
            Size = UDim2.new(0, 280, 1, -20),
            Position = UDim2.new(1, -290, 0, 10),
            BackgroundTransparency = 1,
            Parent = scr
        })
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = holder
        })
    end
    
    local nf = create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = clr.card,
        ClipsDescendants = true,
        Parent = holder
    })
    corner(nf, 8)
    stroke(nf)
    
    local accent = create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = clr.accent,
        BorderSizePixel = 0,
        Parent = nf
    })
    corner(accent, 2)
    
    local ttl = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text = cfg.Title or "Notification",
        TextColor3 = clr.txt,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = nf
    })
    
    local txt = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 14, 0, 32),
        BackgroundTransparency = 1,
        Text = cfg.Text or "",
        TextColor3 = clr.txtDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = nf
    })
    
    local prog = create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = clr.accent,
        BorderSizePixel = 0,
        Parent = nf
    })
    
    nf.Position = UDim2.new(1, 20, 0, 0)
    tween(nf, {Position = UDim2.new(0, 0, 0, 0)}, ti.slow)
    tween(prog, {Size = UDim2.new(0, 0, 0, 2)}, TweenInfo.new(dur, Enum.EasingStyle.Linear))
    
    task.delay(dur, function()
        tween(nf, {Position = UDim2.new(1, 20, 0, 0), BackgroundTransparency = 1}, ti.slow)
        task.wait(0.25)
        nf:Destroy()
    end)
end

function lib:Window(cfg)
    local win = {}
    win._tabs = {}
    win._accent = cfg.Accent or clr.accent
    clr.accent = win._accent
    
    local scr = create("ScreenGui", {
        Name = "UILib_" .. (cfg.Title or "Window"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local ok, _ = pcall(function()
        scr.Parent = game:GetService("CoreGui")
    end)
    if not ok then
        scr.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self._gui = scr
    
    local main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 580, 0, 380),
        Position = UDim2.new(0.5, -290, 0.5, -190),
        BackgroundColor3 = clr.bg,
        ClipsDescendants = true,
        Parent = scr
    })
    corner(main, 10)
    stroke(main, clr.border, 1)
    
    main.Size = UDim2.new(0, 580 * 0.9, 0, 380 * 0.9)
    main.BackgroundTransparency = 1
    tween(main, {
        Size = UDim2.new(0, 580, 0, 380),
        BackgroundTransparency = 0
    }, ti.open)
    
    local shadow = create("ImageLabel", {
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = main
    })
    
    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = clr.card,
        BorderSizePixel = 0,
        Parent = main
    })
    corner(titleBar, 10)
    
    local titleFix = create("Frame", {
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BackgroundColor3 = clr.card,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    local titleTxt = create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = cfg.Title or "UI Library",
        TextColor3 = clr.txt,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    local accentLine = create("Frame", {
        Size = UDim2.new(0, 40, 0, 2),
        Position = UDim2.new(0, 15, 1, -6),
        BackgroundColor3 = win._accent,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    corner(accentLine, 1)
    
    local btns = create("Frame", {
        Size = UDim2.new(0, 70, 0, 20),
        Position = UDim2.new(1, -80, 0.5, -10),
        BackgroundTransparency = 1,
        Parent = titleBar
    })
    
    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 189, 68),
        Text = "",
        Parent = btns
    })
    corner(minBtn, 10)
    
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 95, 87),
        Text = "",
        Parent = btns
    })
    corner(closeBtn, 10)
    
    local minimized = false
    local origSize = UDim2.new(0, 580, 0, 380)
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, 580, 0, 40)}, ti.slow)
        else
            tween(main, {Size = origSize}, ti.slow)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, ti.slow)
        task.wait(0.3)
        scr:Destroy()
    end)
    
    local drag = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = inp.Position
            startPos = main.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    uis.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local sidebar = create("Frame", {
        Size = UDim2.new(0, 140, 1, -48),
        Position = UDim2.new(0, 4, 0, 44),
        BackgroundColor3 = clr.card,
        Parent = main
    })
    corner(sidebar, 8)
    
    local tabList = create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabList
    })
    
    local content = create("Frame", {
        Size = UDim2.new(1, -156, 1, -48),
        Position = UDim2.new(0, 152, 0, 44),
        BackgroundColor3 = clr.card,
        ClipsDescendants = true,
        Parent = main
    })
    corner(content, 8)
    
    win._sidebar = tabList
    win._content = content
    win._main = main
    win._scr = scr
    
    function win:Tab(tcfg)
        local tab = {}
        tab._elements = {}
        
        local tabBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = clr.hover,
            BackgroundTransparency = 1,
            Text = "",
            Parent = self._sidebar
        })
        corner(tabBtn, 6)
        
        local icon = nil
        if tcfg.Icon then
            icon = create("ImageLabel", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                BackgroundTransparency = 1,
                Image = tcfg.Icon,
                ImageColor3 = clr.txtDim,
                Parent = tabBtn
            })
        end
        
        local tabTxt = create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, icon and 34 or 12, 0, 0),
            BackgroundTransparency = 1,
            Text = tcfg.Name or "Tab",
            TextColor3 = clr.txtDim,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        local indicator = create("Frame", {
            Size = UDim2.new(0, 3, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = win._accent,
            BackgroundTransparency = 1,
            Parent = tabBtn
        })
        corner(indicator, 2)
        
        local page = create("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = clr.border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = self._content
        })
        
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = page
        })
        
        tab._page = page
        tab._btn = tabBtn
        tab._indicator = indicator
        tab._icon = icon
        tab._txt = tabTxt
        
        tabBtn.MouseEnter:Connect(function()
            if not tab._active then
                tween(tabBtn, {BackgroundTransparency = 0.5})
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if not tab._active then
                tween(tabBtn, {BackgroundTransparency = 1})
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self._tabs) do
                t._active = false
                t._page.Visible = false
                tween(t._btn, {BackgroundTransparency = 1})
                tween(t._indicator, {BackgroundTransparency = 1})
                tween(t._txt, {TextColor3 = clr.txtDim})
                if t._icon then
                    tween(t._icon, {ImageColor3 = clr.txtDim})
                end
            end
            tab._active = true
            tab._page.Visible = true
            tween(tabBtn, {BackgroundTransparency = 0})
            tween(indicator, {BackgroundTransparency = 0})
            tween(tabTxt, {TextColor3 = clr.txt})
            if icon then
                tween(icon, {ImageColor3 = win._accent})
            end
        end)
        
        if #self._tabs == 0 then
            tab._active = true
            page.Visible = true
            tabBtn.BackgroundTransparency = 0
            indicator.BackgroundTransparency = 0
            tabTxt.TextColor3 = clr.txt
            if icon then icon.ImageColor3 = win._accent end
        end
        
        table.insert(self._tabs, tab)
        
        function tab:Section(scfg)
            local sec = {}
            
            local secFrame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = self._page
            })
            
            local secTxt = create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = (scfg.Name or "Section"):upper(),
                TextColor3 = clr.txtDim,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = secFrame
            })
            
            return sec
        end
        
        function tab:Label(lcfg)
            local lbl = create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = self._page
            })
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = lcfg.Text or "Label",
                TextColor3 = clr.txtDim,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = lbl
            })
            
            local api = {}
            function api:Set(t) txt.Text = t end
            return api
        end
        
        function tab:Button(bcfg)
            local btn = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                Parent = self._page
            })
            corner(btn, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = bcfg.Name or "Button",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btn
            })
            
            local click = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = btn
            })
            
            click.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = clr.hover})
            end)
            
            click.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = clr.toggle})
            end)
            
            click.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = win._accent}, ti.fast)
                task.wait(0.1)
                tween(btn, {BackgroundColor3 = clr.toggle}, ti.fast)
                if bcfg.Callback then bcfg.Callback() end
            end)
            
            return {}
        end
        
        function tab:Toggle(tcfg)
            local toggled = tcfg.Default or false
            
            local tgl = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                Parent = self._page
            })
            corner(tgl, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = tcfg.Name or "Toggle",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tgl
            })
            
            local box = create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = toggled and win._accent or clr.border,
                Parent = tgl
            })
            corner(box, 10)
            
            local knob = create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = clr.txt,
                Parent = box
            })
            corner(knob, 8)
            
            local click = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = tgl
            })
            
            local function update()
                tween(box, {BackgroundColor3 = toggled and win._accent or clr.border})
                tween(knob, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
            end
            
            click.MouseEnter:Connect(function()
                tween(tgl, {BackgroundColor3 = clr.hover})
            end)
            
            click.MouseLeave:Connect(function()
                tween(tgl, {BackgroundColor3 = clr.toggle})
            end)
            
            click.MouseButton1Click:Connect(function()
                toggled = not toggled
                update()
                if tcfg.Callback then tcfg.Callback(toggled) end
            end)
            
            local api = {}
            function api:Set(v)
                toggled = v
                update()
                if tcfg.Callback then tcfg.Callback(toggled) end
            end
            function api:Get() return toggled end
            return api
        end
        
        function tab:Slider(scfg)
            local val = scfg.Default or scfg.Min or 0
            local min = scfg.Min or 0
            local max = scfg.Max or 100
            
            local sld = create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = clr.toggle,
                Parent = self._page
            })
            corner(sld, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text = scfg.Name or "Slider",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sld
            })
            
            local valTxt = create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -55, 0, 6),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = win._accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sld
            })
            
            local track = create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 34),
                BackgroundColor3 = clr.border,
                Parent = sld
            })
            corner(track, 3)
            
            local fill = create("Frame", {
                Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = win._accent,
                Parent = track
            })
            corner(fill, 3)
            
            local knob = create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7),
                BackgroundColor3 = clr.txt,
                ZIndex = 2,
                Parent = track
            })
            corner(knob, 7)
            
            local dragging = false
            
            local function update(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * rel)
                valTxt.Text = tostring(val)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -7, 0.5, -7)
                if scfg.Callback then scfg.Callback(val) end
            end
            
            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(inp.Position.X)
                end
            end)
            
            uis.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            uis.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    update(inp.Position.X)
                end
            end)
            
            local api = {}
            function api:Set(v)
                val = math.clamp(v, min, max)
                local rel = (val - min) / (max - min)
                valTxt.Text = tostring(val)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -7, 0.5, -7)
            end
            function api:Get() return val end
            return api
        end
        
        function tab:Dropdown(dcfg)
            local sel = dcfg.Default or dcfg.Options[1] or ""
            local open = false
            local opts = dcfg.Options or {}
            
            local dd = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                ClipsDescendants = true,
                Parent = self._page
            })
            corner(dd, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -100, 0, 36),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = dcfg.Name or "Dropdown",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dd
            })
            
            local selBox = create("Frame", {
                Size = UDim2.new(0, 90, 0, 24),
                Position = UDim2.new(1, -100, 0, 6),
                BackgroundColor3 = clr.bg,
                Parent = dd
            })
            corner(selBox, 4)
            
            local selTxt = create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = sel,
                TextColor3 = clr.txtDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selBox
            })
            
            local arrow = create("TextLabel", {
                Size = UDim2.new(0, 12, 1, 0),
                Position = UDim2.new(1, -16, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = clr.txtDim,
                TextSize = 8,
                Font = Enum.Font.GothamBold,
                Parent = selBox
            })
            
            local optFrame = create("Frame", {
                Size = UDim2.new(0, 90, 0, #opts * 28),
                Position = UDim2.new(1, -100, 0, 36),
                BackgroundColor3 = clr.bg,
                Visible = false,
                ZIndex = 10,
                Parent = dd
            })
            corner(optFrame, 4)
            stroke(optFrame)
            
            create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = optFrame
            })
            
            local optBtns = {}
            
            for i, opt in ipairs(opts) do
                local optBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = clr.bg,
                    BackgroundTransparency = 1,
                    Text = opt,
                    TextColor3 = clr.txtDim,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ZIndex = 10,
                    Parent = optFrame
                })
                
                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 0, TextColor3 = clr.txt})
                end)
                
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, {BackgroundTransparency = 1, TextColor3 = clr.txtDim})
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    sel = opt
                    selTxt.Text = opt
                    open = false
                    optFrame.Visible = false
                    tween(dd, {Size = UDim2.new(1, 0, 0, 36)}, ti.fast)
                    tween(arrow, {Rotation = 0})
                    if dcfg.Callback then dcfg.Callback(opt) end
                end)
                
                table.insert(optBtns, optBtn)
            end
            
            local click = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                Parent = dd
            })
            
            click.MouseButton1Click:Connect(function()
                open = not open
                optFrame.Visible = open
                tween(dd, {Size = UDim2.new(1, 0, 0, open and (36 + #opts * 28 + 8) or 36)}, ti.fast)
                tween(arrow, {Rotation = open and 180 or 0})
            end)
            
            local api = {}
            function api:Set(v)
                sel = v
                selTxt.Text = v
                if dcfg.Callback then dcfg.Callback(v) end
            end
            function api:Get() return sel end
            function api:Refresh(newOpts)
                opts = newOpts
                for _, b in pairs(optBtns) do b:Destroy() end
                optBtns = {}
                optFrame.Size = UDim2.new(0, 90, 0, #opts * 28)
                for i, opt in ipairs(opts) do
                    local optBtn = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = clr.bg,
                        BackgroundTransparency = 1,
                        Text = opt,
                        TextColor3 = clr.txtDim,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        ZIndex = 10,
                        Parent = optFrame
                    })
                    optBtn.MouseEnter:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 0, TextColor3 = clr.txt})
                    end)
                    optBtn.MouseLeave:Connect(function()
                        tween(optBtn, {BackgroundTransparency = 1, TextColor3 = clr.txtDim})
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        sel = opt
                        selTxt.Text = opt
                        open = false
                        optFrame.Visible = false
                        tween(dd, {Size = UDim2.new(1, 0, 0, 36)}, ti.fast)
                        tween(arrow, {Rotation = 0})
                        if dcfg.Callback then dcfg.Callback(opt) end
                    end)
                    table.insert(optBtns, optBtn)
                end
            end
            return api
        end
        
        function tab:TextBox(tbcfg)
            local tb = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                Parent = self._page
            })
            corner(tb, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(0.5, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = tbcfg.Name or "TextBox",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tb
            })
            
            local box = create("Frame", {
                Size = UDim2.new(0.5, -15, 0, 24),
                Position = UDim2.new(0.5, 5, 0.5, -12),
                BackgroundColor3 = clr.bg,
                Parent = tb
            })
            corner(box, 4)
            
            local input = create("TextBox", {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                BackgroundTransparency = 1,
                Text = tbcfg.Default or "",
                PlaceholderText = tbcfg.Placeholder or "Enter...",
                PlaceholderColor3 = clr.txtDim,
                TextColor3 = clr.txt,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = box
            })
            
            input.FocusLost:Connect(function(enter)
                if tbcfg.Callback then tbcfg.Callback(input.Text) end
            end)
            
            local api = {}
            function api:Set(v) input.Text = v end
            function api:Get() return input.Text end
            return api
        end
        
        function tab:Keybind(kcfg)
            local key = kcfg.Default or Enum.KeyCode.Unknown
            local listening = false
            
            local kb = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                Parent = self._page
            })
            corner(kb, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = kcfg.Name or "Keybind",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = kb
            })
            
            local keyBtn = create("TextButton", {
                Size = UDim2.new(0, 70, 0, 24),
                Position = UDim2.new(1, -80, 0.5, -12),
                BackgroundColor3 = clr.bg,
                Text = key.Name or "None",
                TextColor3 = clr.txtDim,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                Parent = kb
            })
            corner(keyBtn, 4)
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                tween(keyBtn, {BackgroundColor3 = win._accent})
            end)
            
            uis.InputBegan:Connect(function(inp, gpe)
                if listening then
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        key = inp.KeyCode
                        keyBtn.Text = key.Name
                        listening = false
                        tween(keyBtn, {BackgroundColor3 = clr.bg})
                    elseif inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 then
                        listening = false
                        tween(keyBtn, {BackgroundColor3 = clr.bg})
                        keyBtn.Text = key.Name or "None"
                    end
                elseif not gpe and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key then
                    if kcfg.Callback then kcfg.Callback() end
                end
            end)
            
            local api = {}
            function api:Set(k)
                key = k
                keyBtn.Text = k.Name
            end
            function api:Get() return key end
            return api
        end
        
        function tab:ColorPicker(cpcfg)
            local col = cpcfg.Default or Color3.new(1, 1, 1)
            local h, s, v = col:ToHSV()
            local open = false
            
            local cp = create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = clr.toggle,
                ClipsDescendants = true,
                Parent = self._page
            })
            corner(cp, 6)
            
            local txt = create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 36),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = cpcfg.Name or "Color",
                TextColor3 = clr.txt,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = cp
            })
            
            local preview = create("Frame", {
                Size = UDim2.new(0, 36, 0, 20),
                Position = UDim2.new(1, -46, 0, 8),
                BackgroundColor3 = col,
                Parent = cp
            })
            corner(preview, 4)
            stroke(preview, clr.border, 1)
            
            local picker = create("Frame", {
                Size = UDim2.new(1, -20, 0, 120),
                Position = UDim2.new(0, 10, 0, 42),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = cp
            })
            
            local svBox = create("ImageLabel", {
                Size = UDim2.new(1, -30, 0, 100),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Image = "rbxassetid://4155801252",
                Parent = picker
            })
            corner(svBox, 4)
            
            local svCursor = create("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(s, -5, 1 - v, -5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Parent = svBox
            })
            corner(svCursor, 5)
            stroke(svCursor, Color3.new(0, 0, 0), 1)
            
            local hueBar = create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 100),
                Position = UDim2.new(1, -16, 0, 0),
                Image = "rbxassetid://3641079629",
                Parent = picker
            })
            corner(hueBar, 4)
            
            local hueCursor = create("Frame", {
                Size = UDim2.new(1, 4, 0, 6),
                Position = UDim2.new(0, -2, h, -3),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Parent = hueBar
            })
            corner(hueCursor, 2)
            stroke(hueCursor, Color3.new(0, 0, 0), 1)
            
            local function updateCol()
                col = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = col
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, -5, 1 - v, -5)
                hueCursor.Position = UDim2.new(0, -2, h, -3)
                if cpcfg.Callback then cpcfg.Callback(col) end
            end
            
            local dragSV, dragH = false, false
            
            svBox.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragSV = true
                    s = math.clamp((inp.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((inp.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    updateCol()
                end
            end)
            
            hueBar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragH = true
                    h = math.clamp((inp.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                    updateCol()
                end
            end)
            
            uis.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragSV = false
                    dragH = false
                end
            end)
            
            uis.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    if dragSV then
                        s = math.clamp((inp.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((inp.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        updateCol()
                    elseif dragH then
                        h = math.clamp((inp.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        updateCol()
                    end
                end
            end)
            
            local click = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                Parent = cp
            })
            
            click.MouseButton1Click:Connect(function()
                open = not open
                picker.Visible = open
                tween(cp, {Size = UDim2.new(1, 0, 0, open and 170 or 36)}, ti.fast)
            end)
            
            local api = {}
            function api:Set(c)
                col = c
                h, s, v = c:ToHSV()
                updateCol()
            end
            function api:Get() return col end
            return api
        end
        
        return tab
    end
    
    function win:Destroy()
        self._scr:Destroy()
    end
    
    function win:Minimize()
        tween(self._main, {Size = UDim2.new(0, 580, 0, 40)}, ti.slow)
    end
    
    function win:Maximize()
        tween(self._main, {Size = UDim2.new(0, 580, 0, 380)}, ti.slow)
    end
    
    return win
end

return lib

