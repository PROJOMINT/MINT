
--------------------------------------------------
-- MINT UI
-- fixed clips
-- CoreGui fix
-- Bottom-Left Resize Edition
--------------------------------------------------

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

--------------------------------------------------
-- LIBRARY
--------------------------------------------------

local Library = {}
Library.__index = Library

Library.Theme = {
    Background = Color3.fromRGB(13, 20, 18),
    Sidebar = Color3.fromRGB(17, 27, 24),
    Panel = Color3.fromRGB(20, 32, 28),
    Panel2 = Color3.fromRGB(27, 42, 36),
    Hover = Color3.fromRGB(35, 58, 49),

    Mint = Color3.fromRGB(102, 255, 204),
    MintDark = Color3.fromRGB(54, 176, 139),

    Text = Color3.fromRGB(235, 247, 242),
    Muted = Color3.fromRGB(145, 170, 160),
    Dim = Color3.fromRGB(65, 88, 79),

    White = Color3.fromRGB(255, 255, 255),
    Green = Color3.fromRGB(104, 193, 128),
    Red = Color3.fromRGB(220, 91, 111)
}

Library.Flags = {}

-- Config storage. Uses executor filesystem functions when available,
-- and falls back to in-memory configs in normal Roblox Studio.
Library.Configs = {}
Library.ConfigFolder = "MINT"

local function RegisterFlag(element, flag)
    if flag == nil then
        return
    end

    flag = tostring(flag)

    if flag == "" then
        return
    end

    element.Flag = flag
    Library.Flags[flag] = element
end

local function SerializeConfigValue(value)
    if typeof(value) == "Color3" then
        return {
            __MINT_TYPE = "Color3",
            R = value.R,
            G = value.G,
            B = value.B
        }
    end

    local valueType = typeof(value)

    if valueType == "string"
        or valueType == "number"
        or valueType == "boolean"
        or value == nil then
        return value
    end

    return nil
end

local function DeserializeConfigValue(value)
    if type(value) == "table"
        and value.__MINT_TYPE == "Color3" then
        return Color3.new(
            math.clamp(tonumber(value.R) or 1, 0, 1),
            math.clamp(tonumber(value.G) or 1, 0, 1),
            math.clamp(tonumber(value.B) or 1, 0, 1)
        )
    end

    return value
end

local function SanitizeConfigName(name)
    name = tostring(name or "")
    name = name:gsub('[\\/:*?"<>|]', "_")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("%.json$", "")

    if name == "" then
        return nil
    end

    return name:sub(1, 80)
end

local function HasFilesystem()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
        and type(delfile) == "function"
        and type(listfiles) == "function"
end

local function ConfigPath(folder, name)
    return folder .. "/" .. name .. ".json"
end


--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function New(class, props, parent)
    local obj = Instance.new(class)

    for key, value in pairs(props or {}) do
        obj[key] = value
    end

    if parent then
        obj.Parent = parent
    end

    return obj
end

local function Corner(parent, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, radius or 6)
    }, parent)
end

local function Stroke(parent, color, transparency)
    New("UIStroke", {
        Color = color or Library.Theme.Dim,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Padding(parent, left, right, top, bottom)
    New("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0)
    }, parent)
end

local function Tween(obj, time, props)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            time,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )

    tween:Play()

    return tween
end

local function Callback(fn, ...)
    if typeof(fn) ~= "function" then
        return
    end

    task.spawn(function(...)
        local success, err = pcall(fn, ...)

        if not success then
            warn("[MINT UI]", err)
        end
    end, ...)
end

--------------------------------------------------
-- DRAGGING
--------------------------------------------------

local function MakeDraggable(handle, window)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true

        dragStart = Vector2.new(
            input.Position.X,
            input.Position.Y
        )

        startPosition = window.Position
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local current = Vector2.new(
            input.Position.X,
            input.Position.Y
        )

        local delta = current - dragStart

        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)
end

--------------------------------------------------
-- RESIZING
--------------------------------------------------

local function MakeResizable(handle, window)
    local resizing = false
    local resizeStart
    local startSize

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        resizing = true

        resizeStart = Vector2.new(
            input.Position.X,
            input.Position.Y
        )

        startSize = window.AbsoluteSize
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not resizing then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local current = Vector2.new(
            input.Position.X,
            input.Position.Y
        )

        local delta = current - resizeStart

        --------------------------------------------------
        -- Bottom-left resize
        --------------------------------------------------

        local newWidth = math.clamp(
            startSize.X - delta.X,
            500,
            1400
        )

        local newHeight = math.clamp(
            startSize.Y + delta.Y,
            350,
            900
        )

        window.Size = UDim2.fromOffset(
            newWidth,
            newHeight
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            resizing = false
        end
    end)
end

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = {}
Window.__index = Window

function Library:CreateWindow(options)
    options = options or {}

    local self = setmetatable({
        Tabs = {},
        SelectedTab = nil,
        ConfigFolder = options.ConfigFolder or "MINT"
    }, Window)

    --------------------------------------------------
    -- ScreenGui
    --------------------------------------------------

    local gui = New("ScreenGui", {
        Name = "MINT",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = options.DisplayOrder or 50
    }, Game.CoreGui)

    self.Gui = gui

    --------------------------------------------------
    -- Main window
    --------------------------------------------------

    local window = New("Frame", {
        Name = "Window",

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.fromScale(
            0.5,
            0.5
        ),

        Size = UDim2.fromOffset(
            options.Width or 850,
            options.Height or 550
        ),

        BackgroundColor3 = Library.Theme.Background,

        BorderSizePixel = 0,

        ClipsDescendants = true,

        ZIndex = 1
    }, gui)

    self.Frame = window

    Corner(window, 10)

    Stroke(
        window,
        Library.Theme.Dim,
        0.3
    )

    --------------------------------------------------
    -- Top mint line
    --------------------------------------------------

    New("Frame", {
        Size = UDim2.new(
            1,
            0,
            0,
            2
        ),

        BackgroundColor3 = Library.Theme.Mint,

        BorderSizePixel = 0,

        ZIndex = 5
    }, window)

    --------------------------------------------------
    -- SIDEBAR
    --------------------------------------------------

    local sidebar = New("Frame", {
        Name = "Sidebar",

        Position = UDim2.fromOffset(
            0,
            2
        ),

        Size = UDim2.new(
            0,
            200,
            1,
            -2
        ),

        BackgroundColor3 = Library.Theme.Sidebar,

        BorderSizePixel = 0,

        ZIndex = 2
    }, window)

    self.Sidebar = sidebar

    --------------------------------------------------
    -- LOGO
    --------------------------------------------------

    local logo = New("Frame", {
        Position = UDim2.fromOffset(
            18,
            18
        ),

        Size = UDim2.fromOffset(
            40,
            40
        ),

        BackgroundColor3 = Library.Theme.Panel2,

        BorderSizePixel = 0,

        ZIndex = 5
    }, sidebar)

    Corner(logo, 10)

    Stroke(
        logo,
        Library.Theme.MintDark,
        0.3
    )

    New("ImageLabel", {
        Size = UDim2.fromScale(
            1,
            1
        ),

        BackgroundTransparency = 1,

        Image = options.Logo or "",

        ImageColor3 = options.LogoColor or Library.Theme.Mint,

        ImageTransparency = options.LogoTransparency or 0,

        ScaleType = Enum.ScaleType.Fit,

        ZIndex = 6,
        Rotation = 22
    }, logo)

    --------------------------------------------------
    -- TITLE
    --------------------------------------------------

    New("TextLabel", {
        Position = UDim2.fromOffset(
            68,
            20
        ),

        Size = UDim2.fromOffset(
            115,
            18
        ),

        BackgroundTransparency = 1,

        Text = options.Title or "MINT",

        TextColor3 = Library.Theme.Text,

        Font = Enum.Font.GothamBold,

        TextSize = 13,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 5
    }, sidebar)

    New("TextLabel", {
        Position = UDim2.fromOffset(
            68,
            38
        ),

        Size = UDim2.fromOffset(
            115,
            14
        ),

        BackgroundTransparency = 1,

        Text = options.Subtitle or "Configuration",

        TextColor3 = Library.Theme.Muted,

        Font = Enum.Font.Gotham,

        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 5
    }, sidebar)

    --------------------------------------------------
    -- TABS LABEL
    --------------------------------------------------

    New("TextLabel", {
        Position = UDim2.fromOffset(
            18,
            76
        ),

        Size = UDim2.fromOffset(
            150,
            18
        ),

        BackgroundTransparency = 1,

        Text = "TABS",

        TextColor3 = Library.Theme.Muted,

        Font = Enum.Font.GothamBold,

        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 5
    }, sidebar)

    --------------------------------------------------
    -- TAB LIST
    --------------------------------------------------

    local tabList = New("ScrollingFrame", {
        Name = "TabList",

        Position = UDim2.fromOffset(
            0,
            98
        ),

        Size = UDim2.new(
            1,
            0,
            1,
            -108
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ScrollBarThickness = 0,

        CanvasSize = UDim2.new(
            0,
            0,
            0,
            0
        ),

        AutomaticCanvasSize =
            Enum.AutomaticSize.Y,

        ScrollingDirection =
            Enum.ScrollingDirection.Y,

        Active = true,

        ClipsDescendants = true,

        ZIndex = 10
    }, sidebar)

    self.TabList = tabList

    New("UIListLayout", {
        Padding = UDim.new(
            0,
            5
        ),

        SortOrder =
            Enum.SortOrder.LayoutOrder
    }, tabList)

    --------------------------------------------------
    -- CONTENT
    --------------------------------------------------

    local content = New("Frame", {
        Name = "Content",

        Position = UDim2.fromOffset(
            200,
            2
        ),

        Size = UDim2.new(
            1,
            -200,
            1,
            -2
        ),

        BackgroundColor3 =
            Library.Theme.Background,

        BorderSizePixel = 0,

        ClipsDescendants = true,

        ZIndex = 2
    }, window)

    self.Content = content

    --------------------------------------------------
    -- DRAG AREA
    --------------------------------------------------

    local dragArea = New("Frame", {
        Position = UDim2.fromOffset(
            200,
            0
        ),

        Size = UDim2.new(
            1,
            -200,
            0,
            45
        ),

        BackgroundTransparency = 1,

        Active = true,

        ZIndex = 20
    }, window)

    MakeDraggable(
        dragArea,
        window
    )

    --------------------------------------------------
    -- RESIZE HANDLE
    --------------------------------------------------

    local resizeHandle = New("TextButton", {
        Name = "ResizeHandle",

        AnchorPoint = Vector2.new(
            0,
            1
        ),

        Position = UDim2.new(
            0,
            5,
            1,
            -5
        ),

        Size = UDim2.fromOffset(
            12,
            12
        ),

        BackgroundColor3 =
            Library.Theme.Mint,

        BackgroundTransparency = 0.1,

        BorderSizePixel = 0,

        Text = "•",

        TextColor3 =
            Library.Theme.White,

        Font =
            Enum.Font.GothamBold,

        TextSize = 12,

        AutoButtonColor = false,

        Active = true,

        ZIndex = 100
    }, window)

    Corner(
        resizeHandle,
        6
    )

    Stroke(
        resizeHandle,
        Library.Theme.MintDark,
        0.2
    )

    MakeResizable(
        resizeHandle,
        window
    )

    --------------------------------------------------
    -- RESIZE HOVER
    --------------------------------------------------

    resizeHandle.MouseEnter:Connect(function()
        Tween(
            resizeHandle,
            0.12,
            {
                BackgroundTransparency = 0
            }
        )
    end)

    resizeHandle.MouseLeave:Connect(function()
        Tween(
            resizeHandle,
            0.12,
            {
                BackgroundTransparency = 0.1
            }
        )
    end)

    --------------------------------------------------
    -- CLOSE
    --------------------------------------------------

    local close = New("TextButton", {
        AnchorPoint = Vector2.new(
            1,
            0
        ),

        Position = UDim2.new(
            1,
            -12,
            0,
            10
        ),

        Size = UDim2.fromOffset(
            25,
            25
        ),

        BackgroundTransparency = 1,

        Text = "×",

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.GothamBold,

        TextSize = 17,

        AutoButtonColor = false,

        ZIndex = 30
    }, content)

    close.MouseEnter:Connect(function()
        close.TextColor3 =
            Library.Theme.Red
    end)

    close.MouseLeave:Connect(function()
        close.TextColor3 =
            Library.Theme.Muted
    end)

    close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    --------------------------------------------------
    -- NOTIFICATIONS
    --------------------------------------------------

    self.NotificationHolder = New("Frame", {
        AnchorPoint = Vector2.new(
            1,
            1
        ),

        Position = UDim2.fromScale(
            1,
            1
        ),

        Size = UDim2.fromOffset(
            330,
            400
        ),

        BackgroundTransparency = 1,

        ZIndex = 100
    }, gui)

    return self
end

--------------------------------------------------
-- TAB
--------------------------------------------------

local Tab = {}
Tab.__index = Tab

function Window:CreateTab(name, icon)
    local tab = setmetatable({
        Window = self,

        Name = tostring(
            name or "Tab"
        ),

        Icon = tostring(
            icon or "rbxassetid://284402752"
        ),

        Sections = {}
    }, Tab)

    table.insert(
        self.Tabs,
        tab
    )

    tab:Build()

    if not self.SelectedTab then
        self:SelectTab(tab)
    end

    return tab
end

--------------------------------------------------
-- BUILD TAB
--------------------------------------------------

function Tab:Build()
    local window = self.Window

    self.Button = New("TextButton", {
        Name =
            "TabButton_" ..
            self.Name,

        Size = UDim2.new(
            1,
            -24,
            0,
            36
        ),

        BackgroundColor3 =
            Library.Theme.Sidebar,

        BorderSizePixel = 0,

        AutoButtonColor = false,

        Text = "",

        LayoutOrder =
            #window.Tabs,

        Active = true,

        ZIndex = 10
    }, window.TabList)

    Corner(
        self.Button,
        6
    )

    --------------------------------------------------
    -- SELECTION INDICATOR
    --------------------------------------------------

    self.Indicator = New("Frame", {
        Position = UDim2.fromOffset(
            0,
            7
        ),

        Size = UDim2.fromOffset(
            3,
            22
        ),

        BackgroundColor3 =
            Library.Theme.Mint,

        BorderSizePixel = 0,

        Visible = false,

        ZIndex = 12
    }, self.Button)

    Corner(
        self.Indicator,
        2
    )

    --------------------------------------------------
    -- IMAGE ICON
    --------------------------------------------------

    self.IconLabel = New("ImageLabel", {
        Position = UDim2.fromOffset(
            13,
            8
        ),

        Size = UDim2.fromOffset(
            20,
            20
        ),

        BackgroundTransparency = 1,

        Image = self.Icon,

        ImageColor3 =
            Library.Theme.Muted,

        ImageTransparency = 0,

        ScaleType =
            Enum.ScaleType.Fit,

        ZIndex = 12
    }, self.Button)

    --------------------------------------------------
    -- TAB TEXT
    --------------------------------------------------

    New("TextLabel", {
        Position = UDim2.fromOffset(
            45,
            0
        ),

        Size = UDim2.new(
            1,
            -53,
            1,
            0
        ),

        BackgroundTransparency = 1,

        Text = self.Name,

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        TextYAlignment =
            Enum.TextYAlignment.Center,

        ZIndex = 12
    }, self.Button)

    --------------------------------------------------
    -- TAB CLICK
    --------------------------------------------------

    self.Button.MouseButton1Click:Connect(function()
        window:SelectTab(self)
    end)

    --------------------------------------------------
    -- TAB HOVER
    --------------------------------------------------

    self.Button.MouseEnter:Connect(function()
        if window.SelectedTab ~= self then
            Tween(
                self.Button,
                0.1,
                {
                    BackgroundColor3 =
                        Library.Theme.Panel2
                }
            )

            Tween(
                self.IconLabel,
                0.1,
                {
                    ImageColor3 =
                        Library.Theme.Text
                }
            )
        end
    end)

    self.Button.MouseLeave:Connect(function()
        if window.SelectedTab ~= self then
            Tween(
                self.Button,
                0.1,
                {
                    BackgroundColor3 =
                        Library.Theme.Sidebar
                }
            )

            Tween(
                self.IconLabel,
                0.1,
                {
                    ImageColor3 =
                        Library.Theme.Muted
                }
            )
        end
    end)

    --------------------------------------------------
    -- PAGE
    --------------------------------------------------

    self.Page = New("ScrollingFrame", {
        Name =
            "Page_" ..
            self.Name,

        Size = UDim2.fromScale(
            1,
            1
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ScrollBarThickness = 3,

        ScrollBarImageColor3 =
            Library.Theme.MintDark,

        AutomaticCanvasSize =
            Enum.AutomaticSize.Y,

        CanvasSize = UDim2.new(
            0,
            0,
            0,
            0
        ),

        Visible = false,

        ZIndex = 3,

        ClipsDescendants = true
    }, window.Content)

    Padding(
        self.Page,
        12,
        12,
        45,
        15
    )

    New("UIListLayout", {
        Padding = UDim.new(
            0,
            10
        ),

        SortOrder =
            Enum.SortOrder.LayoutOrder
    }, self.Page)
end

--------------------------------------------------
-- SELECT TAB
--------------------------------------------------

function Window:SelectTab(tab)
    for _, other in ipairs(self.Tabs) do
        local selected =
            other == tab

        if other.Button then
            Tween(
                other.Button,
                0.12,
                {
                    BackgroundColor3 =
                        selected
                        and Library.Theme.Hover
                        or Library.Theme.Sidebar
                }
            )
        end

        if other.IconLabel then
            Tween(
                other.IconLabel,
                0.12,
                {
                    ImageColor3 =
                        selected
                        and Library.Theme.Mint
                        or Library.Theme.Muted
                }
            )
        end

        if other.Indicator then
            other.Indicator.Visible =
                selected
        end

        if other.Page then
            other.Page.Visible =
                selected
        end
    end

    self.SelectedTab = tab
end

--------------------------------------------------
-- SECTION
--------------------------------------------------

local Section = {}
Section.__index = Section

function Tab:CreateSection(name)
    local section = setmetatable({
        Tab = self,

        Name = tostring(
            name or "Section"
        ),

        Elements = {}
    }, Section)

    table.insert(
        self.Sections,
        section
    )

    section:Build()

    return section
end

function Section:Build()
    self.Frame = New("Frame", {
        Size = UDim2.new(
            1,
            0,
            0,
            50
        ),

        AutomaticSize =
            Enum.AutomaticSize.Y,

        BackgroundColor3 =
            Library.Theme.Panel,

        BorderSizePixel = 0,

        ClipsDescendants = false,

        ZIndex = 20
    }, self.Tab.Page)

    Corner(
        self.Frame,
        8
    )

    Stroke(
        self.Frame,
        Library.Theme.Dim,
        0.5
    )

    Padding(
        self.Frame,
        14,
        14,
        12,
        12
    )

    New("UIListLayout", {
        Padding = UDim.new(
            0,
            5
        ),

        SortOrder =
            Enum.SortOrder.LayoutOrder
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(
            1,
            0,
            0,
            20
        ),

        BackgroundTransparency = 1,

        Text =
            self.Name:upper(),

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamBold,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        LayoutOrder = 0,

        ZIndex = 21
    }, self.Frame)
end

function Section:Register(element)
    table.insert(
        self.Elements,
        element
    )

    return element
end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

function Section:CreateToggle(options)
    options = options or {}

    local element = {
        Value =
            options.Default == true,

        Callback =
            options.Callback
    }

    RegisterFlag(element, options.Flag)

    local row = New("TextButton", {
        Size = UDim2.new(
            1,
            0,
            0,
            38
        ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        Text = "",

        AutoButtonColor = false,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 22
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(
            1,
            -60,
            1,
            0
        ),

        BackgroundTransparency = 1,

        Text =
            options.Name or "Toggle",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 23
    }, row)

    local switch = New("Frame", {
        AnchorPoint = Vector2.new(
            1,
            0.5
        ),

        Position = UDim2.new(
            1,
            0,
            0.5,
            0
        ),

        Size = UDim2.fromOffset(
            34,
            18
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        ZIndex = 23
    }, row)

    Corner(
        switch,
        9
    )

    local knob = New("Frame", {
        AnchorPoint = Vector2.new(
            0.5,
            0.5
        ),

        Position = UDim2.new(
            0,
            9,
            0.5,
            0
        ),

        Size = UDim2.fromOffset(
            12,
            12
        ),

        BackgroundColor3 =
            Library.Theme.Muted,

        BorderSizePixel = 0,

        ZIndex = 24
    }, switch)

    Corner(
        knob,
        8
    )

    function element:Set(value)
        element.Value =
            value == true

        Tween(
            switch,
            0.18,
            {
                BackgroundColor3 =
                    element.Value
                    and Library.Theme.MintDark
                    or Library.Theme.Panel2
            }
        )

        Tween(
            knob,
            0.18,
            {
                Position =
                    element.Value
                    and UDim2.new(
                        1,
                        -9,
                        0.5,
                        0
                    )
                    or UDim2.new(
                        0,
                        9,
                        0.5,
                        0
                    ),

                BackgroundColor3 =
                    element.Value
                    and Library.Theme.White
                    or Library.Theme.Muted
            }
        )

        Callback(
            element.Callback,
            element.Value
        )
    end

    function element:Get()
        return element.Value
    end

    row.MouseButton1Click:Connect(function()
        element:Set(
            not element.Value
        )
    end)

    element:Set(
        element.Value
    )

    return self:Register(element)
end

--------------------------------------------------
-- DROPDOWN
--------------------------------------------------

function Section:CreateDropdown(options)
    options = options or {}

    local choices =
        options.Options or {}

    local element = {
        Options = choices,

        Value =
            options.Default
            or choices[1],

        IsOpen = false,

        Callback =
            options.Callback
    }

    RegisterFlag(element, options.Flag)

    local container = New("Frame", {
        Size = UDim2.new(
            1,
            0,
            0,
            62
        ),

        BackgroundTransparency = 1,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 30
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(
            1,
            0,
            0,
            20
        ),

        BackgroundTransparency = 1,

        Text =
            options.Name or "Dropdown",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 31
    }, container)

    local button = New("TextButton", {
        Position = UDim2.fromOffset(
            0,
            25
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            32
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        AutoButtonColor = false,

        Text = "",

        ZIndex = 32
    }, container)

    Corner(
        button,
        6
    )

    Stroke(
        button,
        Library.Theme.Dim,
        0.3
    )

    local selected = New("TextLabel", {
        Position = UDim2.fromOffset(
            10,
            0
        ),

        Size = UDim2.new(
            1,
            -40,
            1,
            0
        ),

        BackgroundTransparency = 1,

        Text =
            tostring(
                element.Value
                or "None"
            ),

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.Gotham,

        TextSize = 10,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 33
    }, button)

    local arrow = New("TextLabel", {
        AnchorPoint = Vector2.new(
            1,
            0.5
        ),

        Position = UDim2.new(
            1,
            -8,
            0.5,
            0
        ),

        Size = UDim2.fromOffset(
            20,
            20
        ),

        BackgroundTransparency = 1,

        Text = "▼",

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.GothamBold,

        TextSize = 9,

        ZIndex = 33
    }, button)

    local list = New("Frame", {
        Position = UDim2.new(
            0,
            0,
            1,
            3
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            0
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        Visible = false,

        ClipsDescendants = true,

        ZIndex = 100
    }, container)

    Corner(
        list,
        6
    )

    Stroke(
        list,
        Library.Theme.Dim,
        0.25
    )

    New("UIListLayout", {
        SortOrder =
            Enum.SortOrder.LayoutOrder
    }, list)

    local function BuildOptions()
        for _, child in ipairs(
            list:GetChildren()
        ) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for index, choice in ipairs(
            element.Options
        ) do

            local item = New("TextButton", {
                Size = UDim2.new(
                    1,
                    0,
                    0,
                    28
                ),

                BackgroundColor3 =
                    Library.Theme.Panel2,

                BorderSizePixel = 0,

                AutoButtonColor = false,

                Text =
                    tostring(choice),

                TextColor3 =
                    Library.Theme.Muted,

                Font =
                    Enum.Font.Gotham,

                TextSize = 10,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                LayoutOrder = index,

                ZIndex = 101
            }, list)

            Padding(
                item,
                10,
                5,
                0,
                0
            )

            item.MouseEnter:Connect(function()
                item.BackgroundColor3 =
                    Library.Theme.MintDark

                item.TextColor3 =
                    Library.Theme.White
            end)

            item.MouseLeave:Connect(function()
                item.BackgroundColor3 =
                    Library.Theme.Panel2

                item.TextColor3 =
                    Library.Theme.Muted
            end)

            item.MouseButton1Click:Connect(function()
                element:Set(choice)
                element:Close()
            end)
        end
    end

    function element:Set(value)
        local valid = false

        for _, choice in ipairs(
            element.Options
        ) do
            if choice == value then
                valid = true
                break
            end
        end

        if not valid then
            value =
                element.Options[1]
        end

        element.Value = value

        selected.Text =
            tostring(
                value or "None"
            )

        Callback(
            element.Callback,
            value
        )
    end

    function element:Get()
        return element.Value
    end

    function element:Open()
        if element.IsOpen then
            return
        end

        element.IsOpen = true

        list.Visible = true

        local height =
            math.min(
                #element.Options * 28,
                168
            )

        Tween(
            list,
            0.15,
            {
                Size = UDim2.new(
                    1,
                    0,
                    0,
                    height
                )
            }
        )

        arrow.Text = "▲"
    end

    function element:Close()
        if not element.IsOpen then
            return
        end

        element.IsOpen = false

        local tween = Tween(
            list,
            0.12,
            {
                Size = UDim2.new(
                    1,
                    0,
                    0,
                    0
                )
            }
        )

        tween.Completed:Connect(function()
            if not element.IsOpen then
                list.Visible = false
            end
        end)

        arrow.Text = "▼"
    end

    function element:SetOptions(newOptions)
        element.Options =
            newOptions or {}

        BuildOptions()

        element:Set(
            element.Options[1]
        )
    end

    button.MouseButton1Click:Connect(function()
        if element.IsOpen then
            element:Close()
        else
            element:Open()
        end
    end)

    BuildOptions()

    element:Set(
        element.Value
    )

    return self:Register(element)
end

--------------------------------------------------
-- BUTTON
--------------------------------------------------

function Section:CreateButton(options)
    options = options or {}

    local element = {}

    local button = New("TextButton", {
        Size = UDim2.new(
            1,
            0,
            0,
            36
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        AutoButtonColor = false,

        Text =
            options.Name or "Button",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 22
    }, self.Frame)

    Corner(
        button,
        6
    )

    Stroke(
        button,
        Library.Theme.Dim,
        0.3
    )

    button.MouseEnter:Connect(function()
        Tween(
            button,
            0.12,
            {
                BackgroundColor3 =
                    Library.Theme.MintDark
            }
        )
    end)

    button.MouseLeave:Connect(function()
        Tween(
            button,
            0.12,
            {
                BackgroundColor3 =
                    Library.Theme.Panel2
            }
        )
    end)

    button.MouseButton1Click:Connect(function()
        Callback(
            options.Callback
        )
    end)

    function element:Press()
        Callback(
            options.Callback
        )
    end

    return self:Register(element)
end

--------------------------------------------------
-- TEXTBOX
--------------------------------------------------

function Section:CreateTextbox(options)
    options = options or {}

    local element = {
        Value =
            options.Default or ""
    }

    RegisterFlag(element, options.Flag)

    local container = New("Frame", {
        Size = UDim2.new(
            1,
            0,
            0,
            62
        ),

        BackgroundTransparency = 1,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 22
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(
            1,
            0,
            0,
            20
        ),

        BackgroundTransparency = 1,

        Text =
            options.Name or "Textbox",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 23
    }, container)

    local box = New("TextBox", {
        Position = UDim2.fromOffset(
            0,
            25
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            32
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        ClearTextOnFocus = false,

        Text =
            element.Value,

        PlaceholderText =
            options.Placeholder
            or "Enter text...",

        PlaceholderColor3 =
            Library.Theme.Muted,

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.Gotham,

        TextSize = 10,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 24
    }, container)

    Corner(
        box,
        6
    )

    Stroke(
        box,
        Library.Theme.Dim,
        0.3
    )

    Padding(
        box,
        10,
        10,
        0,
        0
    )

    function element:Set(value)
        element.Value =
            tostring(
                value or ""
            )

        box.Text =
            element.Value

        Callback(
            options.Callback,
            element.Value
        )
    end

    function element:Get()
        return element.Value
    end

    box.FocusLost:Connect(function()
        element:Set(
            box.Text
        )
    end)

    return self:Register(element)
end

--------------------------------------------------
-- SLIDER
--------------------------------------------------

function Section:CreateSlider(options)
    options = options or {}

    local min =
        options.Min or 0

    local max =
        options.Max or 100

    local step =
        options.Step or 1

    if step <= 0 then
        step = 1
    end

    local default =
        options.Default or min

    local element = {
        Value = min
    }

    RegisterFlag(element, options.Flag)

    local row = New("Frame", {
        Size = UDim2.new(
            1,
            0,
            0,
            58
        ),

        BackgroundTransparency = 1,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 22
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(
            1,
            -60,
            0,
            20
        ),

        BackgroundTransparency = 1,

        Text =
            options.Name or "Slider",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamMedium,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 23
    }, row)

    local valueLabel = New("TextLabel", {
        AnchorPoint = Vector2.new(
            1,
            0
        ),

        Position = UDim2.new(
            1,
            0,
            0,
            0
        ),

        Size = UDim2.fromOffset(
            55,
            20
        ),

        BackgroundTransparency = 1,

        Text = "",

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.Gotham,

        TextSize = 10,

        TextXAlignment =
            Enum.TextXAlignment.Right,

        ZIndex = 23
    }, row)

    local track = New("Frame", {
        Position = UDim2.fromOffset(
            0,
            33
        ),

        Size = UDim2.new(
            1,
            0,
            0,
            5
        ),

        BackgroundColor3 =
            Library.Theme.Dim,

        BorderSizePixel = 0,

        ZIndex = 23
    }, row)

    Corner(
        track,
        5
    )

    local fill = New("Frame", {
        Size = UDim2.new(
            0,
            0,
            1,
            0
        ),

        BackgroundColor3 =
            Library.Theme.Mint,

        BorderSizePixel = 0,

        ZIndex = 24
    }, track)

    Corner(
        fill,
        5
    )

    local dragging = false

    local function snapValue(value)
        value = math.clamp(
            tonumber(value) or min,
            min,
            max
        )

        local steps =
            math.floor(
                ((value - min) / step) + 0.5
            )

        local snapped =
            min + (steps * step)

        return math.clamp(
            snapped,
            min,
            max
        )
    end

    local function setFromX(x)
        if track.AbsoluteSize.X <= 0 then
            return
        end

        local alpha = math.clamp(
            (
                x -
                track.AbsolutePosition.X
            )
            /
            track.AbsoluteSize.X,

            0,
            1
        )

        local rawValue =
            min +
            ((max - min) * alpha)

        element:Set(
            rawValue
        )
    end

    function element:Set(value)
        value =
            snapValue(value)

        element.Value =
            value

        local alpha = 0

        if max ~= min then
            alpha =
                (value - min)
                /
                (max - min)
        end

        fill.Size =
            UDim2.new(
                alpha,
                0,
                1,
                0
            )

        if value % 1 == 0 then
            valueLabel.Text =
                tostring(
                    math.floor(value)
                )
        else
            valueLabel.Text =
                tostring(value)
        end

        Callback(
            options.Callback,
            value
        )
    end

    function element:Get()
        return element.Value
    end

    function element:SetStep(newStep)
        newStep =
            tonumber(newStep)

        if not newStep
            or newStep <= 0 then
            return
        end

        step =
            newStep

        element:Set(
            element.Value
        )
    end

    function element:GetStep()
        return step
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true

            setFromX(
                input.Position.X
            )
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            setFromX(
                input.Position.X
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    element:Set(
        default
    )

    return self:Register(element)
end

--------------------------------------------------
-- COLOR PICKER
--------------------------------------------------

function Section:CreateColorPicker(options)

    options = options or {}

    local element = {
        Value = options.Default or Color3.fromRGB(255, 255, 255),
        Callback = options.Callback,
        IsOpen = false
    }

    RegisterFlag(element, options.Flag)

    ------------------------------------------------------------
    -- ROW
    ------------------------------------------------------------

    local row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = #self.Elements + 1,
        ZIndex = 50
    }, self.Frame)

    New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name or "Color",
        TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 51
    }, row)

    ------------------------------------------------------------
    -- COLOR BUTTON
    ------------------------------------------------------------

    local colorButton = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(42, 28),
        BackgroundColor3 = element.Value,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Active = true,
        ZIndex = 100
    }, row)

    Corner(colorButton, 6)

    Stroke(
        colorButton,
        Library.Theme.Dim,
        0.2
    )

    ------------------------------------------------------------
    -- PICKER
    ------------------------------------------------------------

    local picker = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 1, 8),
        Size = UDim2.fromOffset(275, 285),
        BackgroundColor3 = Library.Theme.Panel2,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = false,
        Active = true,
        ZIndex = 500
    }, row)

    Corner(picker, 8)

    Stroke(
        picker,
        Library.Theme.Dim,
        0.15
    )

    ------------------------------------------------------------
    -- MAIN COLOR BOX
    ------------------------------------------------------------

    local gradientBox = New("Frame", {
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(235, 185),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 501
    }, picker)

    Corner(gradientBox, 6)

    ------------------------------------------------------------
    -- WHITE LAYER
    ------------------------------------------------------------

    local whiteLayer = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 502
    }, gradientBox)

    Corner(whiteLayer, 6)

    local whiteGradient = Instance.new("UIGradient")

    whiteGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    whiteGradient.Rotation = 0
    whiteGradient.Parent = whiteLayer

    ------------------------------------------------------------
    -- BLACK LAYER
    ------------------------------------------------------------

    local blackLayer = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 503
    }, gradientBox)

    Corner(blackLayer, 6)

    local blackGradient = Instance.new("UIGradient")

    blackGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })

    blackGradient.Rotation = 90
    blackGradient.Parent = blackLayer

    ------------------------------------------------------------
    -- COLOR BOX INPUT
    ------------------------------------------------------------

    local gradientInput = Instance.new("TextButton")

    gradientInput.Name = "GradientInput"
    gradientInput.Size = UDim2.fromScale(1, 1)
    gradientInput.BackgroundTransparency = 1
    gradientInput.BorderSizePixel = 0
    gradientInput.Text = ""
    gradientInput.AutoButtonColor = false
    gradientInput.Active = true
    gradientInput.ZIndex = 504
    gradientInput.Parent = gradientBox

    ------------------------------------------------------------
    -- PICKER DOT
    ------------------------------------------------------------

    local pickerDot = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 505
    }, gradientBox)

    Corner(pickerDot, 8)

    Stroke(
        pickerDot,
        Color3.fromRGB(25, 25, 25),
        0
    )

    ------------------------------------------------------------
    -- HUE BAR
    --
    -- IMPORTANT:
    -- This does NOT use UIGradient.
    -- It uses separate colored frames so nothing
    -- can turn the middle black.
    ------------------------------------------------------------

    local hueBar = Instance.new("Frame")

    hueBar.Name = "HueBar"
    hueBar.Position = UDim2.fromOffset(12, 207)
    hueBar.Size = UDim2.fromOffset(235, 16)
    hueBar.BackgroundTransparency = 1
    hueBar.BorderSizePixel = 0
    hueBar.ClipsDescendants = true
    hueBar.ZIndex = 510
    hueBar.Parent = picker

    ------------------------------------------------------------
    -- RAINBOW COLORS
    ------------------------------------------------------------

    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),       -- Red
        Color3.fromRGB(255, 127, 0),     -- Orange
        Color3.fromRGB(255, 255, 0),     -- Yellow
        Color3.fromRGB(0, 255, 0),       -- Green
        Color3.fromRGB(0, 255, 255),     -- Cyan
        Color3.fromRGB(0, 100, 255),     -- Blue
        Color3.fromRGB(128, 0, 255),     -- Purple
        Color3.fromRGB(255, 0, 255),     -- Magenta
        Color3.fromRGB(255, 0, 0)        -- Red
    }

    local segmentCount = #rainbowColors - 1
    local segmentWidth = 235 / segmentCount

    for i = 1, segmentCount do

        local segment = Instance.new("Frame")

        segment.Name = "RainbowSegment" .. i

        segment.Position = UDim2.new(
            0,
            (i - 1) * segmentWidth,
            0,
            0
        )

        segment.Size = UDim2.new(
            0,
            segmentWidth + 1,
            1,
            0
        )

        segment.BackgroundColor3 =
            rainbowColors[i]

        segment.BorderSizePixel = 0

        segment.ZIndex = 510

        segment.Parent = hueBar

        --------------------------------------------------------
        -- SMOOTH TRANSITION BETWEEN COLORS
        --------------------------------------------------------

        local gradient = Instance.new("UIGradient")

        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                rainbowColors[i]
            ),

            ColorSequenceKeypoint.new(
                1,
                rainbowColors[i + 1]
            )
        })

        gradient.Transparency =
            NumberSequence.new(0)

        gradient.Parent = segment
    end

    ------------------------------------------------------------
    -- HUE INPUT
    --
    -- Direct Instance.new() so your New() function
    -- cannot apply a black background to it.
    ------------------------------------------------------------

    local hueInput = Instance.new("TextButton")

    hueInput.Name = "HueInput"
    hueInput.Size = UDim2.fromScale(1, 1)
    hueInput.Position = UDim2.fromScale(0, 0)
    hueInput.BackgroundTransparency = 1
    hueInput.BorderSizePixel = 0
    hueInput.Text = ""
    hueInput.AutoButtonColor = false
    hueInput.Active = true
    hueInput.ZIndex = 511
    hueInput.Parent = hueBar

    ------------------------------------------------------------
    -- HUE DOT
    ------------------------------------------------------------

    local hueDot = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(8, 22),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 512
    }, hueBar)

    Corner(hueDot, 4)

    Stroke(
        hueDot,
        Color3.fromRGB(25, 25, 25),
        0
    )

    ------------------------------------------------------------
    -- RGB BOX
    ------------------------------------------------------------

    local rgbBox = New("TextBox", {
        Position = UDim2.fromOffset(12, 238),
        Size = UDim2.fromOffset(170, 32),
        BackgroundColor3 = Library.Theme.Panel,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Text = "",
        PlaceholderText = "255, 255, 255",
        PlaceholderColor3 = Library.Theme.Muted,
        TextColor3 = Library.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 520
    }, picker)

    Corner(rgbBox, 6)

    Stroke(
        rgbBox,
        Library.Theme.Dim,
        0.3
    )

    Padding(
        rgbBox,
        9,
        9,
        0,
        0
    )

    ------------------------------------------------------------
    -- APPLY BUTTON
    ------------------------------------------------------------

    local apply = New("TextButton", {
        Position = UDim2.fromOffset(190, 238),
        Size = UDim2.fromOffset(57, 32),
        BackgroundColor3 = Library.Theme.MintDark,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "Apply",
        TextColor3 = Library.Theme.White,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        ZIndex = 520
    }, picker)

    Corner(apply, 6)

    ------------------------------------------------------------
    -- HSV VALUES
    ------------------------------------------------------------

    local hue, saturation, value =
        Color3.toHSV(element.Value)

    ------------------------------------------------------------
    -- UPDATE VISUALS
    ------------------------------------------------------------

    local function updateVisuals()

        gradientBox.BackgroundColor3 =
            Color3.fromHSV(
                hue,
                1,
                1
            )

        pickerDot.Position =
            UDim2.fromScale(
                math.clamp(saturation, 0, 1),
                math.clamp(1 - value, 0, 1)
            )

        hueDot.Position =
            UDim2.fromScale(
                math.clamp(hue, 0, 1),
                0.5
            )

        colorButton.BackgroundColor3 =
            element.Value

        local r =
            math.floor(
                element.Value.R * 255 + 0.5
            )

        local g =
            math.floor(
                element.Value.G * 255 + 0.5
            )

        local b =
            math.floor(
                element.Value.B * 255 + 0.5
            )

        rgbBox.Text =
            string.format(
                "%d, %d, %d",
                r,
                g,
                b
            )
    end

    ------------------------------------------------------------
    -- SET
    ------------------------------------------------------------

    function element:Set(color)

        if typeof(color) ~= "Color3" then
            return
        end

        element.Value = color

        hue, saturation, value =
            Color3.toHSV(color)

        updateVisuals()

        Callback(
            element.Callback,
            color
        )
    end

    ------------------------------------------------------------
    -- GET
    ------------------------------------------------------------

    function element:Get()
        return element.Value
    end

    ------------------------------------------------------------
    -- GRADIENT DRAGGING
    ------------------------------------------------------------

    local gradientDragging = false

    local function setGradient(input)

        if gradientBox.AbsoluteSize.X <= 0
            or gradientBox.AbsoluteSize.Y <= 0 then
            return
        end

        local x =
            math.clamp(
                input.Position.X -
                    gradientBox.AbsolutePosition.X,
                0,
                gradientBox.AbsoluteSize.X
            )

        local y =
            math.clamp(
                input.Position.Y -
                    gradientBox.AbsolutePosition.Y,
                0,
                gradientBox.AbsoluteSize.Y
            )

        saturation =
            x /
            gradientBox.AbsoluteSize.X

        value =
            1 -
            (
                y /
                gradientBox.AbsoluteSize.Y
            )

        element:Set(
            Color3.fromHSV(
                hue,
                saturation,
                value
            )
        )
    end

    gradientInput.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            gradientDragging = true

            setGradient(input)
        end
    end)

    ------------------------------------------------------------
    -- HUE DRAGGING
    ------------------------------------------------------------

    local hueDragging = false

    local function setHue(input)

        if hueBar.AbsoluteSize.X <= 0 then
            return
        end

        local x =
            math.clamp(
                input.Position.X -
                    hueBar.AbsolutePosition.X,
                0,
                hueBar.AbsoluteSize.X
            )

        hue =
            x /
            hueBar.AbsoluteSize.X

        element:Set(
            Color3.fromHSV(
                hue,
                saturation,
                value
            )
        )
    end

    hueInput.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            hueDragging = true

            setHue(input)
        end
    end)

    ------------------------------------------------------------
    -- INPUT CHANGED
    ------------------------------------------------------------

    UserInputService.InputChanged:Connect(function(input)

        if input.UserInputType ~=
            Enum.UserInputType.MouseMovement
            and
            input.UserInputType ~=
            Enum.UserInputType.Touch then

            return
        end

        if gradientDragging then

            setGradient(input)

        elseif hueDragging then

            setHue(input)
        end
    end)

    ------------------------------------------------------------
    -- INPUT ENDED
    ------------------------------------------------------------

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            gradientDragging = false
            hueDragging = false
        end
    end)

    ------------------------------------------------------------
    -- RGB
    ------------------------------------------------------------

    local function applyRGB()

        local r, g, b =
            rgbBox.Text:match(
                "^%s*(%d+)%s*[, ]%s*(%d+)%s*[, ]%s*(%d+)%s*$"
            )

        r = tonumber(r)
        g = tonumber(g)
        b = tonumber(b)

        if not r or not g or not b then

            updateVisuals()

            return
        end

        r = math.clamp(r, 0, 255)
        g = math.clamp(g, 0, 255)
        b = math.clamp(b, 0, 255)

        element:Set(
            Color3.fromRGB(
                r,
                g,
                b
            )
        )
    end

    apply.MouseButton1Click:Connect(function()
        applyRGB()
    end)

    rgbBox.FocusLost:Connect(function()
        applyRGB()
    end)

    ------------------------------------------------------------
    -- OPEN
    ------------------------------------------------------------

    function element:Open()

        if element.IsOpen then
            return
        end

        element.IsOpen = true

        picker.Visible = true

        updateVisuals()
    end

    ------------------------------------------------------------
    -- CLOSE
    ------------------------------------------------------------

    function element:Close()

        if not element.IsOpen then
            return
        end

        element.IsOpen = false

        picker.Visible = false
    end

    ------------------------------------------------------------
    -- COLOR BUTTON
    ------------------------------------------------------------

    colorButton.MouseButton1Click:Connect(function()

        if element.IsOpen then
            element:Close()
        else
            element:Open()
        end
    end)

    ------------------------------------------------------------
    -- INITIALIZE
    ------------------------------------------------------------

    element:Set(
        element.Value
    )

    return self:Register(element)
end

--------------------------------------------------
-- LABEL
--------------------------------------------------

function Section:CreateLabel(text)
    local element = {}

    local label = New("TextLabel", {
        Size = UDim2.new(
            1,
            0,
            0,
            25
        ),

        BackgroundTransparency = 1,

        Text =
            tostring(
                text or ""
            ),

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.Gotham,

        TextSize = 10,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        LayoutOrder =
            #self.Elements + 1,

        ZIndex = 22
    }, self.Frame)

    function element:Set(value)
        label.Text =
            tostring(
                value or ""
            )
    end

    return self:Register(element)
end

--------------------------------------------------
-- NOTIFICATION
--------------------------------------------------

function Window:Notify(options)
    options = options or {}

    local notification = New("Frame", {
        AnchorPoint = Vector2.new(
            1,
            1
        ),

        Position = UDim2.new(
            1,
            20,
            1,
            -15
        ),

        Size = UDim2.fromOffset(
            300,
            70
        ),

        BackgroundColor3 =
            Library.Theme.Panel2,

        BorderSizePixel = 0,

        ZIndex = 100
    }, self.NotificationHolder)

    Corner(
        notification,
        7
    )

    Stroke(
        notification,
        Library.Theme.Dim,
        0.3
    )

    New("TextLabel", {
        Position = UDim2.fromOffset(
            14,
            10
        ),

        Size = UDim2.new(
            1,
            -25,
            0,
            18
        ),

        BackgroundTransparency = 1,

        Text =
            options.Title
            or "Notification",

        TextColor3 =
            Library.Theme.Text,

        Font =
            Enum.Font.GothamBold,

        TextSize = 11,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 101
    }, notification)

    New("TextLabel", {
        Position = UDim2.fromOffset(
            14,
            30
        ),

        Size = UDim2.new(
            1,
            -25,
            0,
            30
        ),

        BackgroundTransparency = 1,

        Text =
            options.Content or "",

        TextColor3 =
            Library.Theme.Muted,

        Font =
            Enum.Font.Gotham,

        TextSize = 10,

        TextWrapped = true,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 101
    }, notification)

    Tween(
        notification,
        0.25,
        {
            Position =
                UDim2.new(
                    1,
                    -10,
                    1,
                    -15
                )
        }
    )

    task.delay(
        options.Duration or 3,
        function()
            if notification.Parent then

                local tween =
                    Tween(
                        notification,
                        0.2,
                        {
                            Position =
                                UDim2.new(
                                    1,
                                    20,
                                    1,
                                    -15
                                )
                        }
                    )

                tween.Completed:Wait()

                if notification.Parent then
                    notification:Destroy()
                end
            end
        end
    )
end

--------------------------------------------------
-- CONFIG SYSTEM
--------------------------------------------------

function Window:_GetConfigPath(name)
    return ConfigPath(
        self.ConfigFolder or Library.ConfigFolder,
        name
    )
end

function Window:_BuildConfigData()
    local data = {}

    for flag, element in pairs(Library.Flags) do
        if type(element) == "table"
            and type(element.Get) == "function" then

            local ok, value = pcall(function()
                return element:Get()
            end)

            if ok then
                local serialized = SerializeConfigValue(value)

                if serialized ~= nil then
                    data[flag] = serialized
                end
            end
        end
    end

    return data
end

function Window:SaveConfig(name)
    name = SanitizeConfigName(name)

    if not name then
        return false, "Invalid config name."
    end

    local data = self:_BuildConfigData()

    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if not ok then
        return false, "Failed to encode config."
    end

    if HasFilesystem() then
        local folder = self.ConfigFolder or Library.ConfigFolder

        pcall(function()
            if type(isfolder) == "function"
                and type(makefolder) == "function"
                and not isfolder(folder) then
                makefolder(folder)
            end
        end)

        local wrote, err = pcall(function()
            writefile(self:_GetConfigPath(name), encoded)
        end)

        if wrote then
            return true, name
        end

        return false, tostring(err)
    end

    Library.Configs[name] = data
    return true, name
end

function Window:LoadConfig(name)
    name = SanitizeConfigName(name)

    if not name then
        return false, "Invalid config name."
    end

    local data

    if HasFilesystem() then
        local path = self:_GetConfigPath(name)

        if not isfile(path) then
            return false, "Config not found."
        end

        local ok, contents = pcall(function()
            return readfile(path)
        end)

        if not ok then
            return false, tostring(contents)
        end

        local decoded, result = pcall(function()
            return HttpService:JSONDecode(contents)
        end)

        if not decoded or type(result) ~= "table" then
            return false, "Config file is invalid."
        end

        data = result
    else
        data = Library.Configs[name]

        if type(data) ~= "table" then
            return false, "Config not found."
        end
    end

    local loaded = 0

    for flag, savedValue in pairs(data) do
        local element = Library.Flags[flag]

        if element
            and type(element.Set) == "function" then

            local value = DeserializeConfigValue(savedValue)

            local ok = pcall(function()
                element:Set(value)
            end)

            if ok then
                loaded += 1
            end
        end
    end

    return true, loaded
end

function Window:DeleteConfig(name)
    name = SanitizeConfigName(name)

    if not name then
        return false, "Invalid config name."
    end

    if HasFilesystem() then
        local path = self:_GetConfigPath(name)

        if not isfile(path) then
            return false, "Config not found."
        end

        local ok, err = pcall(function()
            delfile(path)
        end)

        if not ok then
            return false, tostring(err)
        end

        return true, name
    end

    if Library.Configs[name] == nil then
        return false, "Config not found."
    end

    Library.Configs[name] = nil
    return true, name
end

function Window:ListConfigs()
    local configs = {}

    if HasFilesystem() then
        local folder = self.ConfigFolder or Library.ConfigFolder

        if type(isfolder) ~= "function"
            or not isfolder(folder) then
            return configs
        end

        local ok, files = pcall(function()
            return listfiles(folder)
        end)

        if not ok or type(files) ~= "table" then
            return configs
        end

        for _, path in ipairs(files) do
            local fileName = tostring(path):match("[/\\]([^/\\]+)%.json$")

            if fileName then
                table.insert(configs, fileName)
            end
        end
    else
        for name in pairs(Library.Configs) do
            table.insert(configs, name)
        end
    end

    table.sort(configs, function(a, b)
        return a:lower() < b:lower()
    end)

    return configs
end

function Window:RefreshConfigs(dropdown)
    local configs = self:ListConfigs()

    if dropdown then
        dropdown:SetOptions(configs)
    end

    return configs
end

function Window:CreateConfigTab(options)
    options = options or {}

    local tab = self:CreateTab(
        options.Name or "Configs",
        options.Icon or "rbxassetid://14304827265"
    )

    local section = tab:CreateSection(
        options.SectionName or "Config Manager"
    )

    section:CreateLabel(
        options.Description
            or "Save, load and manage your MINT configurations."
    )

    local nameBox = section:CreateTextbox({
        Name = "Config Name",
        Default = options.DefaultName or "Default",
        Placeholder = "Config name..."
    })

    local configDropdown = section:CreateDropdown({
        Name = "Saved Configs",
        Options = self:ListConfigs()
    })

    local function getName()
        local name = nameBox:Get()

        if name == nil or name:gsub("%s+", "") == "" then
            name = configDropdown:Get()
        end

        return SanitizeConfigName(name)
    end

    section:CreateButton({
        Name = "Save Config",
        Callback = function()
            local name = getName()

            if not name then
                self:Notify({
                    Title = "Config",
                    Content = "Enter a config name first.",
                    Duration = 2.5
                })
                return
            end

            local ok, result = self:SaveConfig(name)

            if ok then
                nameBox:Set(name)
                self:RefreshConfigs(configDropdown)
                configDropdown:Set(name)

                self:Notify({
                    Title = "Config Saved",
                    Content = "Saved \"" .. name .. "\" successfully.",
                    Duration = 2.5
                })
            else
                self:Notify({
                    Title = "Config Error",
                    Content = tostring(result),
                    Duration = 3
                })
            end
        end
    })

    section:CreateButton({
        Name = "Load Config",
        Callback = function()
            local name = getName()

            if not name then
                self:Notify({
                    Title = "Config",
                    Content = "Select or enter a config first.",
                    Duration = 2.5
                })
                return
            end

            local ok, result = self:LoadConfig(name)

            if ok then
                self:Notify({
                    Title = "Config Loaded",
                    Content = "Loaded \"" .. name .. "\" (" .. tostring(result) .. " settings).",
                    Duration = 2.5
                })
            else
                self:Notify({
                    Title = "Config Error",
                    Content = tostring(result),
                    Duration = 3
                })
            end
        end
    })

    section:CreateButton({
        Name = "Delete Config",
        Callback = function()
            local name = getName()

            if not name then
                self:Notify({
                    Title = "Config",
                    Content = "Select or enter a config first.",
                    Duration = 2.5
                })
                return
            end

            local ok, result = self:DeleteConfig(name)

            if ok then
                self:RefreshConfigs(configDropdown)

                self:Notify({
                    Title = "Config Deleted",
                    Content = "Deleted \"" .. name .. "\".",
                    Duration = 2.5
                })
            else
                self:Notify({
                    Title = "Config Error",
                    Content = tostring(result),
                    Duration = 3
                })
            end
        end
    })

    section:CreateButton({
        Name = "Refresh Configs",
        Callback = function()
            self:RefreshConfigs(configDropdown)

            self:Notify({
                Title = "Configs",
                Content = "Config list refreshed.",
                Duration = 2
            })
        end
    })

    -- Selecting a saved config also fills the name box.
    local originalDropdownSet = configDropdown.Set

    configDropdown.Set = function(element, value)
        originalDropdownSet(element, value)

        if value ~= nil then
            nameBox:Set(value)
        end
    end

    tab.ConfigName = nameBox
    tab.ConfigDropdown = configDropdown
    tab.ConfigSection = section

    self.ConfigTab = tab

    return tab
end

--------------------------------------------------
-- DESTROY
--------------------------------------------------

function Window:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

--------------------------------------------------
-- EXAMPLE
--------------------------------------------------
-- Roblox's Creator Hub documentation uses these
-- image assets in its ImageLabel examples.
--------------------------------------------------

return Library
