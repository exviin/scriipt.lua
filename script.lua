local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local fly = false
local noclip = false
local flySpeed = 50
local walkSpeed = 16
local keys = {}
local language = "EN"
local originalCollisions = {}
local locations = {}
local locationCount = 0

local translations = {
    EN = {
        title = "Exviin CONTROL",
        flyOn = "Fly: ON",
        flyOff = "Fly: OFF",
        noclipOn = "Noclip: ON",
        noclipOff = "Noclip: OFF",
        flyPlus = "Fly Speed +10",
        flyMinus = "Fly Speed -10",
        walkPlus = "Walk Speed +10",
        flySpeed = "Fly Speed: ",
        walkSpeed = "Walk Speed: ",
        teleport = "Teleport",
        teleportTitle = "Teleport Locations",
        save = "Save Location",
        namePlaceholder = "Enter location name",
        location = "Location ",
        saved = "Location saved!",
        enterName = "Enter a location name first",
        noCharacter = "Character not found"
    },

    AR = {
        title = "لوحة Exviin",
        flyOn = "الطيران: تشغيل",
        flyOff = "الطيران: إيقاف",
        noclipOn = "اختراق الجدران: تشغيل",
        noclipOff = "اختراق الجدران: إيقاف",
        flyPlus = "زيادة الطيران +10",
        flyMinus = "تقليل الطيران -10",
        walkPlus = "زيادة المشي +10",
        flySpeed = "سرعة الطيران: ",
        walkSpeed = "سرعة المشي: ",
        teleport = "انتقال",
        teleportTitle = "مناطق الانتقال",
        save = "حفظ المنطقة الحالية",
        namePlaceholder = "اكتب اسم المنطقة",
        location = "منطقة ",
        saved = "تم حفظ المنطقة!",
        enterName = "اكتب اسم المنطقة أولاً",
        noCharacter = "الشخصية غير موجودة"
    }
}

local function T(key)
    return translations[language][key]
end

local gui = Instance.new("ScreenGui")
gui.Name = "XenoControl"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 380)
frame.Position = UDim2.new(0.5, -140, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(75, 75, 85)
stroke.Thickness = 1
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 38)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = T("title")
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- زر الإغلاق X
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 26)
close.Position = UDim2.new(1, -36, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = frame

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

-- مربع اللغة AR / EN
local langBox = Instance.new("Frame")
langBox.Size = UDim2.new(0, 76, 0, 25)
langBox.Position = UDim2.new(1, -84, 0, 38)
langBox.BackgroundColor3 = Color3.fromRGB(65, 65, 72)
langBox.BorderSizePixel = 0
langBox.Parent = frame

Instance.new("UICorner", langBox).CornerRadius = UDim.new(0, 5)

local function makeLangButton(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 38, 1, 0)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundTransparency = 1
    b.BackgroundColor3 = Color3.fromRGB(95, 95, 105)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.Parent = langBox
    return b
end

local arButton = makeLangButton("AR", 0)
local enButton = makeLangButton("EN", 38)

-- إنشاء الأزرار الرئيسية
local function createButton(id, y)
    local b = Instance.new("TextButton")
    b.Name = id
    b.Size = UDim2.new(1, -30, 0, 38)
    b.Position = UDim2.new(0, 15, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    return b
end

local teleportButton = createButton("TeleportButton", 70)
local flyButton = createButton("FlyButton", 115)
local noclipButton = createButton("NoclipButton", 160)
local flyPlusButton = createButton("FlyPlusButton", 205)
local flyMinusButton = createButton("FlyMinusButton", 250)
local walkPlusButton = createButton("WalkPlusButton", 295)

-- قائمة الانتقال
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(0, 240, 0, 300)
teleportFrame.Position = UDim2.new(1, 10, 0, 65)
teleportFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
teleportFrame.BorderSizePixel = 0
teleportFrame.Visible = false
teleportFrame.Active = true
teleportFrame.Parent = frame

Instance.new("UICorner", teleportFrame).CornerRadius = UDim.new(0, 10)

local teleportStroke = Instance.new("UIStroke")
teleportStroke.Color = Color3.fromRGB(75, 75, 85)
teleportStroke.Thickness = 1
teleportStroke.Parent = teleportFrame

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Size = UDim2.new(1, -20, 0, 35)
teleportTitle.Position = UDim2.new(0, 10, 0, 3)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = T("teleportTitle")
teleportTitle.TextColor3 = Color3.new(1, 1, 1)
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 13
teleportTitle.Parent = teleportFrame

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(1, -20, 0, 35)
saveButton.Position = UDim2.new(0, 10, 0, 42)
saveButton.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Text = T("save")
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 11
saveButton.BorderSizePixel = 0
saveButton.Parent = teleportFrame

Instance.new("UICorner", saveButton).CornerRadius = UDim.new(0, 6)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -20, 0, 32)
nameBox.Position = UDim2.new(0, 10, 0, 85)
nameBox.BackgroundColor3 = Color3.fromRGB(48, 48, 55)
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
nameBox.PlaceholderText = T("namePlaceholder")
nameBox.Text = ""
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 11
nameBox.ClearTextOnFocus = false
nameBox.BorderSizePixel = 0
nameBox.Parent = teleportFrame

Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

local locationList = Instance.new("ScrollingFrame")
locationList.Size = UDim2.new(1, -20, 0, 165)
locationList.Position = UDim2.new(0, 10, 0, 127)
locationList.BackgroundTransparency = 1
locationList.BorderSizePixel = 0
locationList.ScrollBarThickness = 4
locationList.CanvasSize = UDim2.new(0, 0, 0, 0)
locationList.Parent = teleportFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = locationList

local function refreshLocations()
    for _, child in ipairs(locationList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for index, location in ipairs(locations) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -5, 0, 32)
        row.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
        row.BorderSizePixel = 0
        row.LayoutOrder = index
        row.Parent = locationList

        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

        local goButton = Instance.new("TextButton")
        goButton.Size = UDim2.new(1, -35, 1, 0)
        goButton.Position = UDim2.new(0, 0, 0, 0)
        goButton.BackgroundTransparency = 1
        goButton.TextColor3 = Color3.new(1, 1, 1)
        goButton.Text = location.name
        goButton.Font = Enum.Font.Gotham
        goButton.TextSize = 11
        goButton.TextTruncate = Enum.TextTruncate.AtEnd
        goButton.Parent = row

        goButton.MouseButton1Click:Connect(function()
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                root.CFrame = location.cframe
            end
        end)

        local deleteButton = Instance.new("TextButton")
        deleteButton.Size = UDim2.new(0, 30, 1, 0)
        deleteButton.Position = UDim2.new(1, -30, 0, 0)
        deleteButton.BackgroundColor3 = Color3.fromRGB(125, 55, 55)
        deleteButton.Text = "X"
        deleteButton.TextColor3 = Color3.new(1, 1, 1)
        deleteButton.Font = Enum.Font.GothamBold
        deleteButton.TextSize = 11
        deleteButton.BorderSizePixel = 0
        deleteButton.Parent = row

        Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(0, 5)

        deleteButton.MouseButton1Click:Connect(function()
            table.remove(locations, index)
            refreshLocations()
        end)
    end

    task.defer(function()
        locationList.CanvasSize = UDim2.new(
            0, 0, 0, listLayout.AbsoluteContentSize.Y + 5
        )
    end)
end

saveButton.MouseButton1Click:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if name == "" then
        locationCount += 1
        name = T("location") .. locationCount
    end

    table.insert(locations, {
        name = name,
        cframe = root.CFrame
    })

    nameBox.Text = ""
    refreshLocations()
end)

teleportButton.MouseButton1Click:Connect(function()
    teleportFrame.Visible = not teleportFrame.Visible
end)

-- تحديث اللغة
local function updateLanguage()
    local t = translations[language]

    title.Text = t.title
    teleportButton.Text = t.teleport
    teleportTitle.Text = t.teleportTitle
    saveButton.Text = t.save
    nameBox.PlaceholderText = t.namePlaceholder

    flyButton.Text = fly and t.flyOn or t.flyOff
    noclipButton.Text = noclip and t.noclipOn or t.noclipOff

    if flyPlusButton:GetAttribute("Changed") then
        flyPlusButton.Text = t.flySpeed .. flySpeed
    else
        flyPlusButton.Text = t.flyPlus
    end

    if flyMinusButton:GetAttribute("Changed") then
        flyMinusButton.Text = t.flySpeed .. flySpeed
    else
        flyMinusButton.Text = t.flyMinus
    end

    if walkPlusButton:GetAttribute("Changed") then
        walkPlusButton.Text = t.walkSpeed .. walkSpeed
    else
        walkPlusButton.Text = t.walkPlus
    end

    arButton.BackgroundTransparency = language == "AR" and 0 or 1
    enButton.BackgroundTransparency = language == "EN" and 0 or 1

    arButton.BackgroundColor3 = Color3.fromRGB(95, 95, 105)
    enButton.BackgroundColor3 = Color3.fromRGB(95, 95, 105)
end

arButton.MouseButton1Click:Connect(function()
    language = "AR"
    updateLanguage()
end)

enButton.MouseButton1Click:Connect(function()
    language = "EN"
    updateLanguage()
end)

-- الطيران
flyButton.MouseButton1Click:Connect(function()
    fly = not fly

    if not fly then
        local character = player.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.PlatformStand = false
        end
    end

    updateLanguage()
end)

-- اختراق الجدران
local function restoreCollisions()
    for part, original in pairs(originalCollisions) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end

    table.clear(originalCollisions)
end

noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip

    if not noclip then
        restoreCollisions()
    end

    updateLanguage()
end)

-- زيادة سرعة الطيران
flyPlusButton.MouseButton1Click:Connect(function()
    flySpeed += 10
    flyPlusButton:SetAttribute("Changed", true)
    updateLanguage()
end)

-- تقليل سرعة الطيران
flyMinusButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    flyMinusButton:SetAttribute("Changed", true)
    updateLanguage()
end)

-- زيادة سرعة المشي
walkPlusButton.MouseButton1Click:Connect(function()
    walkSpeed += 10
    walkPlusButton:SetAttribute("Changed", true)

    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.WalkSpeed = walkSpeed
    end

    updateLanguage()
end)

-- التقاط أزرار الحركة
UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    keys[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input)
    keys[input.KeyCode] = false
end)

-- إعداد الشخصية
local function setupCharacter(character)
    local hum = character:WaitForChild("Humanoid", 5)

    if hum then
        hum.WalkSpeed = walkSpeed
        hum.PlatformStand = false
    end

    table.clear(originalCollisions)
    fly = false
    noclip = false

    updateLanguage()
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
    setupCharacter(player.Character)
end

-- تشغيل الطيران والاختراق
RunService.RenderStepped:Connect(function(dt)
    local character = player.Character

    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")

    if not root or not hum then
        return
    end

    if noclip then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollisions[part] == nil then
                    originalCollisions[part] = part.CanCollide
                end

                part.CanCollide = false
            end
        end
    end

    if fly then
        hum.PlatformStand = true

        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if keys[Enum.KeyCode.W] then
            dir += cam.CFrame.LookVector
        end

        if keys[Enum.KeyCode.S] then
            dir -= cam.CFrame.LookVector
        end

        if keys[Enum.KeyCode.A] then
            dir -= cam.CFrame.RightVector
        end

        if keys[Enum.KeyCode.D] then
            dir += cam.CFrame.RightVector
        end

        if keys[Enum.KeyCode.Space] then
            dir += Vector3.yAxis
        end

        if keys[Enum.KeyCode.LeftControl] then
            dir -= Vector3.yAxis
        end

        root.AssemblyLinearVelocity = Vector3.zero

        if dir.Magnitude > 0 then
            root.CFrame += dir.Unit * flySpeed * dt
        end
    else
        hum.PlatformStand = false
    end
end)

-- إغلاق القائمة واستعادة الحالة
close.MouseButton1Click:Connect(function()
    fly = false
    noclip = false

    local character = player.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.PlatformStand = false
    end

    restoreCollisions()
    gui:Destroy()
end)

updateLanguage()
