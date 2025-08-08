-- UI Library by 0khs
-- Modern Roblox GUI Library with Icon Support and Settings

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Library Configuration
local Config = {
    Font = Enum.Font.GothamBold,
    MainColor = Color3.fromRGB(25, 25, 35),
    AccentColor = Color3.fromRGB(100, 100, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryColor = Color3.fromRGB(35, 35, 45),
    BorderColor = Color3.fromRGB(60, 60, 70),
    SuccessColor = Color3.fromRGB(0, 255, 0),
    WarningColor = Color3.fromRGB(255, 255, 0),
    ErrorColor = Color3.fromRGB(255, 0, 0)
}

-- Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, tweenInfo, properties)
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Config.BorderColor
    stroke.Parent = parent
    return stroke
end

-- Main Library Functions
function UILibrary:CreateWindow(title, iconId)
    local Window = {}
    Window.Pages = {}
    Window.CurrentPage = nil
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    CreateCorner(MainFrame, 12)
    CreateStroke(MainFrame, 2, Config.BorderColor)
    
    -- Icon Holder at Top
    local IconHolder = Instance.new("Frame")
    IconHolder.Name = "IconHolder"
    IconHolder.Size = UDim2.new(1, 0, 0, 50)
    IconHolder.Position = UDim2.new(0, 0, 0, 0)
    IconHolder.BackgroundColor3 = Config.SecondaryColor
    IconHolder.BorderSizePixel = 0
    IconHolder.Parent = MainFrame
    CreateCorner(IconHolder, 12)
    
    -- Main Icon
    local MainIcon = Instance.new("ImageLabel")
    MainIcon.Name = "MainIcon"
    MainIcon.Size = UDim2.new(0, 32, 0, 32)
    MainIcon.Position = UDim2.new(0, 10, 0.5, -16)
    MainIcon.BackgroundTransparency = 1
    MainIcon.Image = iconId or "rbxassetid://0"
    MainIcon.ImageColor3 = Config.AccentColor
    MainIcon.Parent = IconHolder
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 50, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "UI Library"
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.TextScaled = true
    TitleLabel.Font = Config.Font
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = IconHolder
    
    -- Navigation Frame
    local NavigationFrame = Instance.new("Frame")
    NavigationFrame.Name = "NavigationFrame"
    NavigationFrame.Size = UDim2.new(0, 150, 1, -60)
    NavigationFrame.Position = UDim2.new(0, 10, 0, 60)
    NavigationFrame.BackgroundColor3 = Config.SecondaryColor
    NavigationFrame.BorderSizePixel = 0
    NavigationFrame.Parent = MainFrame
    CreateCorner(NavigationFrame, 8)
    
    -- Navigation List
    local NavigationList = Instance.new("UIListLayout")
    NavigationList.SortOrder = Enum.SortOrder.LayoutOrder
    NavigationList.Padding = UDim.new(0, 5)
    NavigationList.Parent = NavigationFrame
    
    local NavigationPadding = Instance.new("UIPadding")
    NavigationPadding.PaddingTop = UDim.new(0, 10)
    NavigationPadding.PaddingBottom = UDim.new(0, 10)
    NavigationPadding.PaddingLeft = UDim.new(0, 10)
    NavigationPadding.PaddingRight = UDim.new(0, 10)
    NavigationPadding.Parent = NavigationFrame
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -180, 1, -60)
    ContentFrame.Position = UDim2.new(0, 170, 0, 60)
    ContentFrame.BackgroundColor3 = Config.SecondaryColor
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    CreateCorner(ContentFrame, 8)
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    IconHolder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Window Functions
    function Window:CreatePage(name, iconId)
        local Page = {}
        Page.Elements = {}
        
        -- Page Button
        local PageButton = Instance.new("TextButton")
        PageButton.Name = name
        PageButton.Size = UDim2.new(1, 0, 0, 35)
        PageButton.BackgroundColor3 = Config.MainColor
        PageButton.BorderSizePixel = 0
        PageButton.Text = ""
        PageButton.Parent = NavigationFrame
        CreateCorner(PageButton, 6)
        
        -- Page Icon
        local PageIcon = Instance.new("ImageLabel")
        PageIcon.Name = "PageIcon"
        PageIcon.Size = UDim2.new(0, 20, 0, 20)
        PageIcon.Position = UDim2.new(0, 8, 0.5, -10)
        PageIcon.BackgroundTransparency = 1
        PageIcon.Image = iconId or "rbxassetid://0"
        PageIcon.ImageColor3 = Config.TextColor
        PageIcon.Parent = PageButton
        
        -- Page Label
        local PageLabel = Instance.new("TextLabel")
        PageLabel.Name = "PageLabel"
        PageLabel.Size = UDim2.new(1, -35, 1, 0)
        PageLabel.Position = UDim2.new(0, 35, 0, 0)
        PageLabel.BackgroundTransparency = 1
        PageLabel.Text = name
        PageLabel.TextColor3 = Config.TextColor
        PageLabel.TextScaled = true
        PageLabel.Font = Config.Font
        PageLabel.TextXAlignment = Enum.TextXAlignment.Left
        PageLabel.Parent = PageButton
        
        -- Page Content
        local PageContent = Instance.new("ScrollingFrame")
        PageContent.Name = name .. "Content"
        PageContent.Size = UDim2.new(1, 0, 1, 0)
        PageContent.Position = UDim2.new(0, 0, 0, 0)
        PageContent.BackgroundTransparency = 1
        PageContent.BorderSizePixel = 0
        PageContent.ScrollBarThickness = 6
        PageContent.ScrollBarImageColor3 = Config.AccentColor
        PageContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        PageContent.Visible = false
        PageContent.Parent = ContentFrame
        
        -- Page Content Layout
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = PageContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.Parent = PageContent
        
        -- Update canvas size when content changes
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 30)
        end)
        
        -- Page button functionality
        PageButton.MouseButton1Click:Connect(function()
            Window:SelectPage(name)
        end)
        
        -- Hover effects
        PageButton.MouseEnter:Connect(function()
            if Window.CurrentPage ~= name then
                CreateTween(PageButton, {BackgroundColor3 = Config.BorderColor}, 0.2):Play()
            end
        end)
        
        PageButton.MouseLeave:Connect(function()
            if Window.CurrentPage ~= name then
                CreateTween(PageButton, {BackgroundColor3 = Config.MainColor}, 0.2):Play()
            end
        end)
        
        Window.Pages[name] = {
            Button = PageButton,
            Content = PageContent,
            Page = Page
        }
        
        -- Select first page by default
        if not Window.CurrentPage then
            Window:SelectPage(name)
        end
        
        return Page
    end
    
    function Window:SelectPage(name)
        if Window.Pages[name] then
            -- Hide current page
            if Window.CurrentPage and Window.Pages[Window.CurrentPage] then
                Window.Pages[Window.CurrentPage].Content.Visible = false
                CreateTween(Window.Pages[Window.CurrentPage].Button, {BackgroundColor3 = Config.MainColor}, 0.2):Play()
            end
            
            -- Show new page
            Window.CurrentPage = name
            Window.Pages[name].Content.Visible = true
            CreateTween(Window.Pages[name].Button, {BackgroundColor3 = Config.AccentColor}, 0.2):Play()
        end
    end
    
    return Window
end

return UILibrary


-- Enhanced Icon System
local IconManager = {}
IconManager.LoadedIcons = {}

function IconManager:LoadIcon(iconId, callback)
    if self.LoadedIcons[iconId] then
        if callback then callback(true) end
        return true
    end
    
    -- Simulate icon loading
    spawn(function()
        wait(0.1) -- Simulate loading time
        self.LoadedIcons[iconId] = true
        if callback then callback(true) end
    end)
    
    return false
end

function IconManager:GetIcon(iconId)
    return iconId or "rbxassetid://0"
end

-- UI Elements for Pages
function UILibrary:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Config.AccentColor
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Config.TextColor
    Button.TextScaled = true
    Button.Font = Config.Font
    Button.Parent = parent
    CreateCorner(Button, 6)
    
    -- Button animations
    Button.MouseEnter:Connect(function()
        CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(120, 120, 255)}, 0.2):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        CreateTween(Button, {BackgroundColor3 = Config.AccentColor}, 0.2):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        CreateTween(Button, {Size = UDim2.new(1, -4, 0, 31)}, 0.1):Play()
        wait(0.1)
        CreateTween(Button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1):Play()
        if callback then callback() end
    end)
    
    return Button
end

function UILibrary:CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Config.SecondaryColor
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    CreateCorner(ToggleFrame, 6)
    CreateStroke(ToggleFrame, 1, Config.BorderColor)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Config.TextColor
    ToggleLabel.TextScaled = true
    ToggleLabel.Font = Config.Font
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and Config.SuccessColor or Config.BorderColor
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    CreateCorner(ToggleButton, 10)
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "ToggleIndicator"
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Config.TextColor
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    CreateCorner(ToggleIndicator, 8)
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local newColor = toggled and Config.SuccessColor or Config.BorderColor
        local newPosition = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        CreateTween(ToggleButton, {BackgroundColor3 = newColor}, 0.2):Play()
        CreateTween(ToggleIndicator, {Position = newPosition}, 0.2):Play()
        
        if callback then callback(toggled) end
    end)
    
    return ToggleFrame, function() return toggled end
end

function UILibrary:CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Config.SecondaryColor
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    CreateCorner(SliderFrame, 6)
    CreateStroke(SliderFrame, 1, Config.BorderColor)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Size = UDim2.new(1, 0, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = Config.TextColor
    SliderLabel.TextScaled = true
    SliderLabel.Font = Config.Font
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "SliderTrack"
    SliderTrack.Size = UDim2.new(1, -20, 0, 4)
    SliderTrack.Position = UDim2.new(0, 10, 1, -15)
    SliderTrack.BackgroundColor3 = Config.BorderColor
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    CreateCorner(SliderTrack, 2)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Config.AccentColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    CreateCorner(SliderFill, 2)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Config.TextColor
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
    CreateCorner(SliderButton, 8)
    
    local value = default
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local relativePos = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
            
            value = min + (max - min) * relativePos
            value = math.floor(value * 100) / 100 -- Round to 2 decimal places
            
            SliderLabel.Text = text .. ": " .. value
            SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativePos, -8, 0.5, -8)
            
            if callback then callback(value) end
        end
    end)
    
    return SliderFrame, function() return value end
end

function UILibrary:CreateDropdown(parent, text, options, default, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundColor3 = Config.SecondaryColor
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    CreateCorner(DropdownFrame, 6)
    CreateStroke(DropdownFrame, 1, Config.BorderColor)
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = text .. ": " .. (default or options[1] or "None")
    DropdownButton.TextColor3 = Config.TextColor
    DropdownButton.TextScaled = true
    DropdownButton.Font = Config.Font
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = DropdownFrame
    
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Name = "DropdownArrow"
    DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = Config.TextColor
    DropdownArrow.TextScaled = true
    DropdownArrow.Font = Config.Font
    DropdownArrow.Parent = DropdownFrame
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.BackgroundColor3 = Config.MainColor
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = DropdownFrame
    CreateCorner(DropdownList, 6)
    CreateStroke(DropdownList, 1, Config.BorderColor)
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = DropdownList
    
    local selectedValue = default or options[1]
    local isOpen = false
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = "Option" .. i
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = Config.TextColor
        OptionButton.TextScaled = true
        OptionButton.Font = Config.Font
        OptionButton.Parent = DropdownList
        
        OptionButton.MouseEnter:Connect(function()
            CreateTween(OptionButton, {BackgroundColor3 = Config.BorderColor}, 0.2):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            CreateTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)}, 0.2):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedValue = option
            DropdownButton.Text = text .. ": " .. option
            DropdownList.Visible = false
            isOpen = false
            DropdownArrow.Text = "▼"
            if callback then callback(option) end
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = isOpen
        DropdownArrow.Text = isOpen and "▲" or "▼"
    end)
    
    return DropdownFrame, function() return selectedValue end
end


-- Settings System
local SettingsManager = {}
SettingsManager.Settings = {}
SettingsManager.FileName = "UILibrary_Settings.json"

function SettingsManager:LoadSettings()
    if readfile and isfile and isfile(self.FileName) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(self.FileName))
        end)
        if success and data then
            self.Settings = data
            return true
        end
    end
    return false
end

function SettingsManager:SaveSettings()
    if writefile then
        local success = pcall(function()
            local jsonData = game:GetService("HttpService"):JSONEncode(self.Settings)
            writefile(self.FileName, jsonData)
        end)
        return success
    end
    return false
end

function SettingsManager:GetSetting(key, default)
    return self.Settings[key] or default
end

function SettingsManager:SetSetting(key, value)
    self.Settings[key] = value
    self:SaveSettings()
end

-- Initialize settings
SettingsManager:LoadSettings()

-- Settings Page Creator
function UILibrary:CreateSettingsPage(window)
    local SettingsPage = window:CreatePage("SETTINGS", "rbxassetid://7733779610")
    
    -- Settings Title
    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "SETTINGS"
    SettingsTitle.TextColor3 = Config.TextColor
    SettingsTitle.TextScaled = true
    SettingsTitle.Font = Config.Font
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
    SettingsTitle.Parent = window.Pages["SETTINGS"].Content
    
    -- Theme Grid Container
    local ThemeGrid = Instance.new("Frame")
    ThemeGrid.Name = "ThemeGrid"
    ThemeGrid.Size = UDim2.new(1, 0, 0, 300)
    ThemeGrid.BackgroundTransparency = 1
    ThemeGrid.Parent = window.Pages["SETTINGS"].Content
    
    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellSize = UDim2.new(0, 120, 0, 90)
    GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GridLayout.Parent = ThemeGrid
    
    -- Theme Options (recreating the grid from the original image)
    local themes = {
        {name = "Dark Red", main = Color3.fromRGB(40, 20, 20), accent = Color3.fromRGB(200, 100, 100)},
        {name = "Dark Purple", main = Color3.fromRGB(30, 20, 40), accent = Color3.fromRGB(150, 100, 200)},
        {name = "Dark Green", main = Color3.fromRGB(20, 40, 30), accent = Color3.fromRGB(100, 200, 150)},
        {name = "Dark Yellow", main = Color3.fromRGB(40, 40, 20), accent = Color3.fromRGB(200, 200, 100)},
        {name = "Dark Blue", main = Color3.fromRGB(20, 30, 50), accent = Color3.fromRGB(100, 150, 255)},
        {name = "Dark Cyan", main = Color3.fromRGB(20, 40, 40), accent = Color3.fromRGB(100, 200, 200)},
        {name = "Ocean Blue", main = Color3.fromRGB(15, 25, 45), accent = Color3.fromRGB(80, 120, 200)},
        {name = "Royal Purple", main = Color3.fromRGB(25, 15, 45), accent = Color3.fromRGB(120, 80, 200)},
        {name = "Forest Green", main = Color3.fromRGB(15, 35, 25), accent = Color3.fromRGB(80, 180, 120)}
    }
    
    for i, theme in ipairs(themes) do
        local ThemeButton = Instance.new("TextButton")
        ThemeButton.Name = "Theme" .. i
        ThemeButton.BackgroundColor3 = theme.main
        ThemeButton.BorderSizePixel = 0
        ThemeButton.Text = ""
        ThemeButton.LayoutOrder = i
        ThemeButton.Parent = ThemeGrid
        CreateCorner(ThemeButton, 8)
        CreateStroke(ThemeButton, 2, theme.accent)
        
        -- Theme preview lines (like in original)
        for j = 1, 3 do
            local PreviewLine = Instance.new("Frame")
            PreviewLine.Name = "PreviewLine" .. j
            PreviewLine.Size = UDim2.new(0.8, 0, 0, 2)
            PreviewLine.Position = UDim2.new(0.1, 0, 0.2 + (j * 0.15), 0)
            PreviewLine.BackgroundColor3 = theme.accent
            PreviewLine.BorderSizePixel = 0
            PreviewLine.Parent = ThemeButton
            CreateCorner(PreviewLine, 1)
        end
        
        -- Theme selection
        ThemeButton.MouseButton1Click:Connect(function()
            Config.MainColor = theme.main
            Config.AccentColor = theme.accent
            Config.SecondaryColor = Color3.fromRGB(
                math.min(255, theme.main.R * 255 + 10),
                math.min(255, theme.main.G * 255 + 10),
                math.min(255, theme.main.B * 255 + 10)
            )
            
            -- Save theme setting
            SettingsManager:SetSetting("selectedTheme", i)
            SettingsManager:SetSetting("mainColor", {theme.main.R, theme.main.G, theme.main.B})
            SettingsManager:SetSetting("accentColor", {theme.accent.R, theme.accent.G, theme.accent.B})
            
            -- Visual feedback
            CreateTween(ThemeButton, {Size = UDim2.new(0, 115, 0, 85)}, 0.1):Play()
            wait(0.1)
            CreateTween(ThemeButton, {Size = UDim2.new(0, 120, 0, 90)}, 0.1):Play()
            
            print("Theme changed to: " .. theme.name)
        end)
        
        -- Hover effects
        ThemeButton.MouseEnter:Connect(function()
            CreateTween(ThemeButton, {Size = UDim2.new(0, 125, 0, 95)}, 0.2):Play()
        end)
        
        ThemeButton.MouseLeave:Connect(function()
            CreateTween(ThemeButton, {Size = UDim2.new(0, 120, 0, 90)}, 0.2):Play()
        end)
    end
    
    -- Additional Settings
    local SettingsContainer = Instance.new("Frame")
    SettingsContainer.Name = "SettingsContainer"
    SettingsContainer.Size = UDim2.new(1, 0, 0, 200)
    SettingsContainer.BackgroundTransparency = 1
    SettingsContainer.Parent = window.Pages["SETTINGS"].Content
    
    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsLayout.Padding = UDim.new(0, 10)
    SettingsLayout.Parent = SettingsContainer
    
    -- Animation Speed Setting
    UILibrary:CreateSlider(SettingsContainer, "Animation Speed", 0.1, 2.0, 
        SettingsManager:GetSetting("animationSpeed", 1.0), function(value)
        SettingsManager:SetSetting("animationSpeed", value)
        print("Animation speed set to: " .. value)
    end)
    
    -- Auto-save Settings Toggle
    UILibrary:CreateToggle(SettingsContainer, "Auto-save Settings", 
        SettingsManager:GetSetting("autoSave", true), function(enabled)
        SettingsManager:SetSetting("autoSave", enabled)
        print("Auto-save " .. (enabled and "enabled" or "disabled"))
    end)
    
    -- Sound Effects Toggle
    UILibrary:CreateToggle(SettingsContainer, "Sound Effects", 
        SettingsManager:GetSetting("soundEffects", false), function(enabled)
        SettingsManager:SetSetting("soundEffects", enabled)
        print("Sound effects " .. (enabled and "enabled" or "disabled"))
    end)
    
    -- Font Selection
    local fontOptions = {"Gotham", "GothamBold", "SourceSans", "SourceSansBold", "Roboto", "RobotoMono"}
    UILibrary:CreateDropdown(SettingsContainer, "Font", fontOptions, 
        SettingsManager:GetSetting("selectedFont", "GothamBold"), function(font)
        local fontEnum = Enum.Font[font] or Enum.Font.GothamBold
        Config.Font = fontEnum
        SettingsManager:SetSetting("selectedFont", font)
        print("Font changed to: " .. font)
    end)
    
    -- Reset Settings Button
    UILibrary:CreateButton(SettingsContainer, "Reset All Settings", function()
        SettingsManager.Settings = {}
        SettingsManager:SaveSettings()
        
        -- Reset to default theme
        Config.MainColor = Color3.fromRGB(25, 25, 35)
        Config.AccentColor = Color3.fromRGB(100, 100, 255)
        Config.SecondaryColor = Color3.fromRGB(35, 35, 45)
        Config.Font = Enum.Font.GothamBold
        
        print("All settings have been reset to defaults")
    end)
    
    -- Load saved theme on startup
    local savedTheme = SettingsManager:GetSetting("selectedTheme", 1)
    local savedMainColor = SettingsManager:GetSetting("mainColor", nil)
    local savedAccentColor = SettingsManager:GetSetting("accentColor", nil)
    
    if savedMainColor and savedAccentColor then
        Config.MainColor = Color3.fromRGB(savedMainColor[1], savedMainColor[2], savedMainColor[3])
        Config.AccentColor = Color3.fromRGB(savedAccentColor[1], savedAccentColor[2], savedAccentColor[3])
        Config.SecondaryColor = Color3.fromRGB(
            math.min(255, savedMainColor[1] * 255 + 10),
            math.min(255, savedMainColor[2] * 255 + 10),
            math.min(255, savedMainColor[3] * 255 + 10)
        )
    end
    
    local savedFont = SettingsManager:GetSetting("selectedFont", "GothamBold")
    Config.Font = Enum.Font[savedFont] or Enum.Font.GothamBold
    
    return SettingsPage
end

-- Export SettingsManager for external use
UILibrary.SettingsManager = SettingsManager

return UILibrary

