-- if you skid this without credits your a pussy
-- updated with skeleton esp
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local ESP = {}

-- SETTINGS
getgenv().ESPSettings = getgenv().ESPSettings or {}

ESPSettings.boxESP = ESPSettings.boxESP or false
ESPSettings.box3dESP = ESPSettings.box3dESP or false
ESPSettings.nameESP = ESPSettings.nameESP or false
ESPSettings.glowESP = ESPSettings.glowESP or false
ESPSettings.tracerESP = ESPSettings.tracerESP or false
ESPSettings.skeletonESP = ESPSettings.skeletonESP or false
ESPSettings.teamCheck = ESPSettings.teamCheck or false
ESPSettings.masterColor = ESPSettings.masterColor or false

ESPSettings.boxColor = ESPSettings.boxColor or Color3.fromRGB(255, 0, 0)
ESPSettings.nameColor = ESPSettings.nameColor or Color3.fromRGB(255, 255, 255)
ESPSettings.mainColor = ESPSettings.mainColor or Color3.fromRGB(0, 255, 0)
ESPSettings.glowColor = ESPSettings.glowColor or Color3.fromRGB(0, 255, 255)
ESPSettings.tracerColor = ESPSettings.tracerColor or Color3.fromRGB(255, 255, 0)
ESPSettings.skeletonColor = ESPSettings.skeletonColor or Color3.fromRGB(255, 255, 255)

-- SAFETY WRAPPER
local function SafeColor(c)
    return typeof(c) == "Color3"
        and c
        or Color3.fromRGB(255, 255, 255)
end

-- DRAWING TABLES
local BoxESPBoxes = {}
local NameESPLabels = {}
local Box3DLines = {}
local GlowESP = {}
local Tracers = {}
local SkeletonESP = {}

------------------------------------------
-- 3D BOX FUNCTIONS
------------------------------------------

local function Create3DBox(character)
    if not character then return end
    if Box3DLines[character] then return end

    Box3DLines[character] = {}

    for i = 1, 12 do
        local line = Drawing.new("Line")

        line.Visible = false
        line.Thickness = 2
        line.Color = SafeColor(ESPSettings.boxColor)

        Box3DLines[character][i] = line
    end
end

local function Remove3DBox(character)
    if Box3DLines[character] then
        for _, line in ipairs(Box3DLines[character]) do
            pcall(function()
                line:Remove()
            end)
        end

        Box3DLines[character] = nil
    end
end

local function Update3DBox(character, hrp, camera)
    if not character or not hrp or not camera then
        return
    end

    if not Box3DLines[character] then
        return
    end

    local size = Vector3.new(2, 3, 1.5)
    local cf = hrp.CFrame

    local corners = {
        cf * Vector3.new(-size.X, -size.Y, -size.Z),
        cf * Vector3.new(size.X, -size.Y, -size.Z),
        cf * Vector3.new(size.X, size.Y, -size.Z),
        cf * Vector3.new(-size.X, size.Y, -size.Z),

        cf * Vector3.new(-size.X, -size.Y, size.Z),
        cf * Vector3.new(size.X, -size.Y, size.Z),
        cf * Vector3.new(size.X, size.Y, size.Z),
        cf * Vector3.new(-size.X, size.Y, size.Z),
    }

    local screen = {}

    for i = 1, 8 do
        local p, visible = camera:WorldToViewportPoint(corners[i])

        if not visible then
            for _, line in ipairs(Box3DLines[character]) do
                line.Visible = false
            end

            return
        end

        screen[i] = Vector2.new(p.X, p.Y)
    end

    local edges = {
        {1, 2},
        {2, 3},
        {3, 4},
        {4, 1},

        {5, 6},
        {6, 7},
        {7, 8},
        {8, 5},

        {1, 5},
        {2, 6},
        {3, 7},
        {4, 8},
    }

    local color = SafeColor(
        ESPSettings.masterColor
            and ESPSettings.mainColor
            or ESPSettings.boxColor
    )

    for i, edge in ipairs(edges) do
        local line = Box3DLines[character][i]

        line.Visible = ESPSettings.box3dESP
        line.Color = color
        line.From = screen[edge[1]]
        line.To = screen[edge[2]]
    end
end

------------------------------------------
-- 2D BOX + NAME FUNCTIONS
------------------------------------------

local function CreateBox(character)
    if not character then return end
    if BoxESPBoxes[character] then return end

    local hrp = character:WaitForChild("HumanoidRootPart", 5)

    if not hrp then
        return
    end

    local box = Drawing.new("Square")

    box.Visible = false
    box.Thickness = 2
    box.Color = SafeColor(ESPSettings.boxColor)
    box.Filled = false
    box.Transparency = 1

    BoxESPBoxes[character] = box
end

local function RemoveBox(character)
    if BoxESPBoxes[character] then
        pcall(function()
            BoxESPBoxes[character]:Remove()
        end)

        BoxESPBoxes[character] = nil
    end
end

local function CreateName(character)
    if not character then return end
    if NameESPLabels[character] then return end

    local head = character:FindFirstChild("Head")

    if not head then
        return
    end

    local label = Drawing.new("Text")

    label.Visible = false
    label.Color = SafeColor(ESPSettings.nameColor)
    label.Size = 16
    label.Center = true
    label.Outline = true
    label.Text = character.Name

    NameESPLabels[character] = label
end

local function RemoveName(character)
    if NameESPLabels[character] then
        pcall(function()
            NameESPLabels[character]:Remove()
        end)

        NameESPLabels[character] = nil
    end
end

------------------------------------------
-- GLOW FUNCTIONS
------------------------------------------

local function CreateGlow(character)
    if not character then
        return
    end

    if GlowESP[character] then
        return
    end

    local highlight = Instance.new("Highlight")

    highlight.Name = "ESPGlow"
    highlight.Adornee = character
    highlight.Enabled = false

    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    highlight.FillColor = SafeColor(ESPSettings.glowColor)
    highlight.OutlineColor = SafeColor(ESPSettings.glowColor)

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- Keep the Highlight separate from the character.
    highlight.Parent = CoreGui

    GlowESP[character] = highlight
end

local function RemoveGlow(character)
    local glow = GlowESP[character]

    if glow then
        pcall(function()
            glow.Enabled = false
            glow.Adornee = nil
            glow:Destroy()
        end)

        GlowESP[character] = nil
    end
end

local function UpdateGlow(character)
    local glow = GlowESP[character]

    if not glow then
        return
    end

    -- Recreate the Highlight if Roblox has removed/destroyed it.
    if glow.Parent == nil then
        GlowESP[character] = nil
        CreateGlow(character)
        glow = GlowESP[character]

        if not glow then
            return
        end
    end

    -- Make sure the Highlight is still attached to the correct character.
    if glow.Adornee ~= character then
        glow.Adornee = character
    end

    local color

    if ESPSettings.masterColor then
        color = SafeColor(ESPSettings.mainColor)
    else
        color = SafeColor(ESPSettings.glowColor)
    end

    glow.FillColor = color
    glow.OutlineColor = color

    glow.Enabled = (
        ESPSettings.glowESP
        and character.Parent ~= nil
    )
end

------------------------------------------
-- TRACER FUNCTIONS
------------------------------------------

local function CreateTracer(character)
    if not character then return end
    if Tracers[character] then return end

    local line = Drawing.new("Line")

    line.Visible = false
    line.Thickness = 1.5
    line.Color = SafeColor(ESPSettings.tracerColor)

    Tracers[character] = line
end

local function RemoveTracer(character)
    if Tracers[character] then
        pcall(function()
            Tracers[character]:Remove()
        end)

        Tracers[character] = nil
    end
end

local function UpdateTracer(character, hrp, camera)
    if not character or not hrp or not camera then
        return
    end

    local line = Tracers[character]

    if not line then
        return
    end

    local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)

    if onScreen then
        line.Visible = ESPSettings.tracerESP

        line.Color = SafeColor(
            ESPSettings.masterColor
                and ESPSettings.mainColor
                or ESPSettings.tracerColor
        )

        local screenSize = camera.ViewportSize

        line.From = Vector2.new(
            screenSize.X / 2,
            screenSize.Y
        )

        line.To = Vector2.new(pos.X, pos.Y)
    else
        line.Visible = false
    end
end

------------------------------------------
-- SKELETON ESP FUNCTIONS
------------------------------------------

-- R15 body connections.
local SkeletonConnections = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},

    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},

    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},

    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},

    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local function CreateSkeleton(character)
    if not character then
        return
    end

    if SkeletonESP[character] then
        return
    end

    SkeletonESP[character] = {}

    for i = 1, #SkeletonConnections do
        local line = Drawing.new("Line")

        line.Visible = false
        line.Thickness = 1.5
        line.Color = SafeColor(ESPSettings.skeletonColor)

        SkeletonESP[character][i] = line
    end
end

local function RemoveSkeleton(character)
    if SkeletonESP[character] then
        for _, line in ipairs(SkeletonESP[character]) do
            pcall(function()
                line:Remove()
            end)
        end

        SkeletonESP[character] = nil
    end
end

local function UpdateSkeleton(character, camera)
    if not character or not camera then
        return
    end

    local lines = SkeletonESP[character]

    if not lines then
        return
    end

    local color = SafeColor(
        ESPSettings.masterColor
            and ESPSettings.mainColor
            or ESPSettings.skeletonColor
    )

    for i, connection in ipairs(SkeletonConnections) do
        local line = lines[i]

        if not line then
            continue
        end

        local part1 = character:FindFirstChild(connection[1])
        local part2 = character:FindFirstChild(connection[2])

        if part1 and part2 then
            local pos1, visible1 =
                camera:WorldToViewportPoint(part1.Position)

            local pos2, visible2 =
                camera:WorldToViewportPoint(part2.Position)

            if visible1
                and visible2
                and pos1.Z > 0
                and pos2.Z > 0
            then
                line.Visible = ESPSettings.skeletonESP
                line.Color = color

                line.From = Vector2.new(
                    pos1.X,
                    pos1.Y
                )

                line.To = Vector2.new(
                    pos2.X,
                    pos2.Y
                )
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

------------------------------------------
-- TEAM CHECK
------------------------------------------

local function IsEnemy(player)
    if not player then
        return false
    end

    if not ESPSettings.teamCheck then
        return true
    end

    return player.Team ~= Players.LocalPlayer.Team
end

------------------------------------------
-- CLEANUP
------------------------------------------

local function CleanupCharacter(character)
    if not character then
        return
    end

    RemoveBox(character)
    RemoveName(character)
    Remove3DBox(character)
    RemoveGlow(character)
    RemoveTracer(character)
    RemoveSkeleton(character)
end

------------------------------------------
-- PLAYER EVENTS
------------------------------------------

local function OnCharacterAdded(character)
    if not character then
        return
    end

    task.spawn(function()
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        local humanoid = character:WaitForChild("Humanoid", 5)

        if not hrp or not humanoid then
            return
        end

        CreateBox(character)
        CreateName(character)
        Create3DBox(character)
        CreateGlow(character)
        CreateTracer(character)
        CreateSkeleton(character)

        humanoid.Died:Connect(function()
            CleanupCharacter(character)
        end)

        character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                CleanupCharacter(character)
            end
        end)
    end)
end

local function OnPlayerAdded(player)
    if not player then
        return
    end

    player.CharacterAdded:Connect(OnCharacterAdded)

    if player.Character then
        OnCharacterAdded(player.Character)
    end
end

local function OnPlayerRemoving(player)
    if player and player.Character then
        CleanupCharacter(player.Character)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

------------------------------------------
-- RENDER LOOP
------------------------------------------

RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera

    if not camera then
        return
    end

    ------------------------------------------
    -- 2D BOX
    ------------------------------------------

    for character, box in pairs(BoxESPBoxes) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and ESPSettings.boxESP
            and IsEnemy(player)
        then
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                local pos, onScreen =
                    camera:WorldToViewportPoint(hrp.Position)

                if onScreen and pos.Z > 0 then
                    local scale = 1 / pos.Z * 120
                    local width = 35 * scale
                    local height = 50 * scale

                    box.Visible = true

                    box.Position = Vector2.new(
                        pos.X - width / 2,
                        pos.Y - height / 2
                    )

                    box.Size = Vector2.new(
                        width,
                        height
                    )

                    box.Color = SafeColor(
                        ESPSettings.masterColor
                            and ESPSettings.mainColor
                            or ESPSettings.boxColor
                    )
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end

    ------------------------------------------
    -- NAME ESP
    ------------------------------------------

    for character, label in pairs(NameESPLabels) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and ESPSettings.nameESP
            and IsEnemy(player)
        then
            local head = character:FindFirstChild("Head")

            if head then
                local pos, onScreen =
                    camera:WorldToViewportPoint(
                        head.Position + Vector3.new(0, 2, 0)
                    )

                if onScreen and pos.Z > 0 then
                    label.Visible = true
                    label.Position = Vector2.new(
                        pos.X,
                        pos.Y
                    )

                    label.Color = SafeColor(
                        ESPSettings.masterColor
                            and ESPSettings.mainColor
                            or ESPSettings.nameColor
                    )
                else
                    label.Visible = false
                end
            else
                label.Visible = false
            end
        else
            label.Visible = false
        end
    end

    ------------------------------------------
    -- 3D BOX
    ------------------------------------------

    for character, lines in pairs(Box3DLines) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and ESPSettings.box3dESP
            and IsEnemy(player)
        then
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                Update3DBox(
                    character,
                    hrp,
                    camera
                )
            else
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
            end
        else
            for _, line in ipairs(lines) do
                line.Visible = false
            end
        end
    end

    ------------------------------------------
    -- GLOW ESP
    ------------------------------------------

    for character, glow in pairs(GlowESP) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and IsEnemy(player)
        then
            UpdateGlow(character)
        else
            if glow then
                glow.Enabled = false
            end
        end
    end

    ------------------------------------------
    -- TRACERS
    ------------------------------------------

    for character, line in pairs(Tracers) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and ESPSettings.tracerESP
            and IsEnemy(player)
        then
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                UpdateTracer(
                    character,
                    hrp,
                    camera
                )
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end

    ------------------------------------------
    -- SKELETON ESP
    ------------------------------------------

    for character, lines in pairs(SkeletonESP) do
        local player = Players:GetPlayerFromCharacter(character)

        if player
            and character.Parent
            and ESPSettings.skeletonESP
            and IsEnemy(player)
        then
            UpdateSkeleton(
                character,
                camera
            )
        else
            for _, line in ipairs(lines) do
                line.Visible = false
            end
        end
    end
end)

------------------------------------------
-- PUBLIC FUNCTIONS
------------------------------------------

function ESP:SetBoxESP(b)
    ESPSettings.boxESP = b
end

function ESP:Set3DBoxESP(b)
    ESPSettings.box3dESP = b
end

function ESP:SetNameESP(b)
    ESPSettings.nameESP = b
end

function ESP:SetGlowESP(b)
    ESPSettings.glowESP = b
end

function ESP:SetTracerESP(b)
    ESPSettings.tracerESP = b
end

function ESP:SetSkeletonESP(b)
    ESPSettings.skeletonESP = b
end

function ESP:SetTeamCheck(b)
    ESPSettings.teamCheck = b
end

function ESP:SetMasterColor(b)
    ESPSettings.masterColor = b
end

function ESP:SetBoxColor(c)
    ESPSettings.boxColor = SafeColor(c)
end

function ESP:SetNameColor(c)
    ESPSettings.nameColor = SafeColor(c)
end

function ESP:SetMainColor(c)
    ESPSettings.mainColor = SafeColor(c)
end

function ESP:SetGlowColor(c)
    ESPSettings.glowColor = SafeColor(c)
end

function ESP:SetTracerColor(c)
    ESPSettings.tracerColor = SafeColor(c)
end

function ESP:SetSkeletonColor(c)
    ESPSettings.skeletonColor = SafeColor(c)
end

------------------------------------------
-- TOGGLE FUNCTIONS
------------------------------------------

function ESP:ToggleBoxESP()
    ESPSettings.boxESP = not ESPSettings.boxESP
end

function ESP:Toggle3DBoxESP()
    ESPSettings.box3dESP = not ESPSettings.box3dESP
end

function ESP:ToggleNameESP()
    ESPSettings.nameESP = not ESPSettings.nameESP
end

function ESP:ToggleGlowESP()
    ESPSettings.glowESP = not ESPSettings.glowESP
end

function ESP:ToggleTracerESP()
    ESPSettings.tracerESP = not ESPSettings.tracerESP
end

function ESP:ToggleSkeletonESP()
    ESPSettings.skeletonESP = not ESPSettings.skeletonESP
end

function ESP:ToggleTeamCheck()
    ESPSettings.teamCheck = not ESPSettings.teamCheck
end

function ESP:ToggleMasterColor()
    ESPSettings.masterColor = not ESPSettings.masterColor
end

return ESP
