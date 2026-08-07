local lib = {Toggle = true}

local _New_ = Instance.new;


local mint = Instance.new("ScreenGui")
mint.IgnoreGuiInset = false
mint.ResetOnSpawn = true
mint.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mint.Name = "MINT"
mint.Parent = game.CoreGui

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ts = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


local TweenInfo = TweenInfo.new(
	0.2,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local function MakeDraggable(ClickObject, Object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	ClickObject.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Object.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	ClickObject.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - DragStart
			Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

function lib:Make()
	local main = Instance.new("Frame")
	main.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0745098)
	main.BorderColor3 = Color3.new(0, 0, 0)
	main.BorderSizePixel = 0
	main.Position = UDim2.new(0.515463948, 0, 0.131707385, 0)
	main.Size = UDim2.new(0, 558,0, 471)
	main.Visible = true
	main.Name = "Main"
	main.Parent = mint
	MakeDraggable(main,main)

	local logo = Instance.new("ImageButton")
	logo.Image = "rbxassetid://83980496960536"

	logo.BackgroundColor3 = Color3.new(1, 1, 1)
	logo.BackgroundTransparency = 1
	logo.BorderColor3 = Color3.new(0, 0, 0)
	logo.BorderSizePixel = 0
	logo.Position = UDim2.new(0.0032869291, 0, 0.019097561, 0)
	logo.Rotation = 16
	logo.Size = UDim2.new(0.0782778859, 0, 0.0792079195, 0)
	logo.Visible = true
	logo.Name = "logo"
	logo.Parent = main

	local text_label = Instance.new("TextLabel")
	text_label.Font = Enum.Font.SourceSansBold
	text_label.Text = "MINT"
	text_label.TextColor3 = Color3.new(0.494118, 0.490196, 0.498039)
	text_label.TextSize = 14
	text_label.TextXAlignment = Enum.TextXAlignment.Left
	text_label.BackgroundColor3 = Color3.new(1, 1, 1)
	text_label.BackgroundTransparency = 1
	text_label.BorderColor3 = Color3.new(0, 0, 0)
	text_label.BorderSizePixel = 0
	text_label.Position = UDim2.new(0.861136973, 0, -0.894011796, 0)
	text_label.Rotation = -16
	text_label.Size = UDim2.new(0, 190, 0, 40)
	text_label.Visible = true
	text_label.Parent = logo

	local main_round = Instance.new("UICorner")
	main_round.BottomLeftRadius = UDim.new(0, 5)
	main_round.BottomRightRadius = UDim.new(0, 5)
	main_round.CornerRadius = UDim.new(0, 5)
	main_round.TopLeftRadius = UDim.new(0, 5)
	main_round.TopRightRadius = UDim.new(0, 5)
	main_round.Name = "MainRound"
	main_round.Parent = main

	local TabContainer = Instance.new("Frame")
	TabContainer.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0509804)
	TabContainer.BorderColor3 = Color3.new(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.Position = UDim2.new(0.0450097844, 0, 0.112309888, 0)
	TabContainer.Size = UDim2.new(0.917808235, 0, 0.811881185, 0)
	TabContainer.Visible = true
	TabContainer.Name = "TabContainer"
	TabContainer.Parent = main

	local tab_round = Instance.new("UICorner")
	tab_round.BottomLeftRadius = UDim.new(0, 5)
	tab_round.BottomRightRadius = UDim.new(0, 5)
	tab_round.CornerRadius = UDim.new(0, 5)
	tab_round.TopLeftRadius = UDim.new(0, 5)
	tab_round.TopRightRadius = UDim.new(0, 5)
	tab_round.Name = "TabRound"
	tab_round.Parent = TabContainer

	local container_stroke = Instance.new("UIStroke")
	container_stroke.Color = Color3.new(0.0784314, 0.0784314, 0.0784314)
	container_stroke.Name = "ContainerStroke"
	container_stroke.Parent = TabContainer



	local main_stroke = Instance.new("UIStroke")
	main_stroke.Color = Color3.new(0.0784314, 0.0784314, 0.0784314)
	main_stroke.Name = "MainStroke"
	main_stroke.Parent = main

	local Buttons = Instance.new("Frame")
	Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
	Buttons.BackgroundTransparency = 1
	Buttons.BorderColor3 = Color3.new(0, 0, 0)
	Buttons.BorderSizePixel = 0
	Buttons.Position = UDim2.new(0.289628178, 0, 0.0198019799, 0)
	Buttons.Size = UDim2.new(0.686888456, 0, 0.0792079195, 0)
	Buttons.Visible = true
	Buttons.Name = "Buttons"
	Buttons.Parent = main

	local uilist_layout_3 = Instance.new("UIListLayout")
	uilist_layout_3.FillDirection = Enum.FillDirection.Horizontal
	uilist_layout_3.HorizontalAlignment = Enum.HorizontalAlignment.Right
	uilist_layout_3.SortOrder = Enum.SortOrder.LayoutOrder
	uilist_layout_3.VerticalAlignment = Enum.VerticalAlignment.Center
	uilist_layout_3.Parent = Buttons

	local hide_bind = Instance.new("TextLabel")
	hide_bind.Font = Enum.Font.SourceSansBold
	hide_bind.Text = "R-Shift"
	hide_bind.TextColor3 = Color3.new(0.309804, 0.321569, 0.352941)
	hide_bind.TextSize = 14
	hide_bind.TextTransparency = 0.44999998807907104
	hide_bind.BackgroundColor3 = Color3.new(1, 1, 1)
	hide_bind.BackgroundTransparency = 1
	hide_bind.BorderColor3 = Color3.new(0, 0, 0)
	hide_bind.BorderSizePixel = 0
	hide_bind.Position = UDim2.new(0.857142866, 0, 0.936633646, 0)
	hide_bind.Size = UDim2.new(0.119373776, 0, 0.0514851473, 0)
	hide_bind.Visible = true
	hide_bind.Name = "HideBind"
	hide_bind.Parent = main

	_G.Hiden = false

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		--print(input.KeyCode)

		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.RightShift then
			--print("Pressed!")
			main.Visible = not main.Visible
		end
	end)
	
	local t={}
	
	function t:Tab(e)
		e = e or {}
		
		-- tab button
		
		local TabBtn = _New_("TextButton", Buttons);
		TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		TabBtn.BackgroundTransparency = 1;
		TabBtn.BorderColor3 = Color3.fromRGB(0, 0, 0);
		TabBtn.BorderSizePixel = 0;
		TabBtn.Name = "TabBtn";
		TabBtn.Position = UDim2.new(0.8860399127006531, 0, 0.08749999850988388, 0);
		TabBtn.Size = UDim2.new(0, 40, 0, 33);
		TabBtn.Font = Enum.Font.SourceSansBold;
		TabBtn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		TabBtn.Text = e.name or "btn";
		TabBtn.TextColor3 = Color3.fromRGB(65.0000037252903, 70.00000342726707, 77.00000301003456);
		TabBtn.TextSize = 14;
		
		
		-- tab
		local Tab = _New_("Frame", TabContainer);
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Tab.BackgroundTransparency = 1;
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0);
		Tab.BorderSizePixel = 0;
		Tab.Name = "Tab";
		Tab.Size = UDim2.new(1, 0, 1, 0);
	

		local Left = _New_("ScrollingFrame", Tab);
		Left.Active = true;
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Left.BackgroundTransparency = 1;
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0);
		Left.BorderSizePixel = 0;
		Left.Name = "Left";
		Left.Size = UDim2.new(0.5, 0, 1, 0);
		Left.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		Left.CanvasPosition = Vector2.new(0, 0.000030517578125);
		Left.CanvasSize = UDim2.new(0, 0, 1, 0);
		Left.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
		Left.ScrollBarThickness = 0;

		local UIListLayout = _New_("UIListLayout", Left);
		UIListLayout.Padding = UDim.new(0, 10);
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;

		local UIPadding = _New_("UIPadding", Left);
		UIPadding.PaddingBottom = UDim.new(0, 10);
		UIPadding.PaddingLeft = UDim.new(0, 12);
		UIPadding.PaddingRight = UDim.new(0, 12);
		UIPadding.PaddingTop = UDim.new(0, 10);

		local Right = _New_("ScrollingFrame", Tab);
		Right.Active = true;
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Right.BackgroundTransparency = 1;
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0);
		Right.BorderSizePixel = 0;
		Right.Name = "Right";
		Right.Position = UDim2.new(0.5, 0, 0, 0);
		Right.Size = UDim2.new(0.5, 0, 1, 0);
		Right.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		Right.CanvasSize = UDim2.new(0, 0, 1, 0);
		Right.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
		Right.ScrollBarThickness = 0;

		local UIPadding_0 = _New_("UIPadding", Right);
		UIPadding_0.PaddingBottom = UDim.new(0, 10);
		UIPadding_0.PaddingLeft = UDim.new(0, 12);
		UIPadding_0.PaddingRight = UDim.new(0, 12);
		UIPadding_0.PaddingTop = UDim.new(0, 10);

		local UIListLayout_0 = _New_("UIListLayout", Right);
		UIListLayout_0.Padding = UDim.new(0, 10);
		UIListLayout_0.SortOrder = Enum.SortOrder.LayoutOrder;
		
		-- Code Stuff
		




		local ActiveColor = Color3.fromRGB(172, 170, 170)
		local InactiveColor = Color3.fromRGB(65, 70, 77)



		local CurrentTabButton

		local function TweenTextColor(button, color)
			ts:Create(button, TweenInfo, {
				TextColor3 = color
			}):Play()
		end

		-- Hover
		TabBtn.MouseEnter:Connect(function()
			if CurrentTabButton ~= TabBtn then
				TweenTextColor(TabBtn, ActiveColor)
			end
		end)

		TabBtn.MouseLeave:Connect(function()
			if CurrentTabButton ~= TabBtn then
				TweenTextColor(TabBtn, InactiveColor)
			end
		end)

		-- Click
		TabBtn.MouseButton1Click:Connect(function()
			-- Hide all tabs
			for _, v in ipairs(TabContainer:GetChildren()) do
				if v.Name == "Tab" then
					v.Visible = false
				end
			end

			-- Reset all button colors
			for _, v in ipairs(Buttons:GetChildren()) do
				if v:IsA("TextButton") then
					TweenTextColor(v, InactiveColor)
				end
			end

			-- Show selected tab
			Tab.Visible = true

			-- Set active button
			CurrentTabButton = TabBtn
			TweenTextColor(TabBtn, ActiveColor)
		end)

		-- Hide all tabs first
		for _, v in ipairs(TabContainer:GetChildren()) do
			if v.Name == "Tab" then
				v.Visible = false
			end
		end

		-- Make the first tab active
		if CurrentTabButton == nil then
			CurrentTabButton = TabBtn
			Tab.Visible = true
			TabBtn.TextColor3 = ActiveColor
		end
		
		local s={}
		function s:Section(e)
			e = e or {}
			local side = e.side or Right
			
			local Section = _New_("Frame", nil)
			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 1
			Section.BorderSizePixel = 0
			Section.Name = "Section"
			Section.Size = UDim2.new(1, 0, 0, 36)
			
			
			if e.side == "left" then
				Section.Parent = Left

			elseif e.side == "right" then
				Section.Parent = Right

			else
				warn("No side specified for section")
				Section.Parent = Left
			end
			

			local Header = _New_("TextLabel", Section)
			Header.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
			Header.BorderSizePixel = 0
			Header.Name = e.title or "Header"
			Header.Size = UDim2.new(0, 62, 0, 26)
			Header.Font = Enum.Font.SourceSansBold
			Header.Text = e.title or "Section"
			Header.TextColor3 = Color3.fromRGB(58, 62, 68)
			Header.TextSize = 14

			local HeaderCorner = _New_("UICorner", Header)
			HeaderCorner.CornerRadius = UDim.new(0, 3)

			local HeaderStroke = _New_("UIStroke", Header)
			HeaderStroke.Color = Color3.fromRGB(20, 20, 20)

			local Content = _New_("Frame", Section)
			Content.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
			Content.BorderSizePixel = 0
			Content.Name = "Content"
			Content.Position = UDim2.new(0, 0, 0, 30)
			Content.Size = UDim2.new(1, 0, 0, 0)
			Content.AutomaticSize = Enum.AutomaticSize.Y

			local ContentCorner = _New_("UICorner", Content)
			ContentCorner.CornerRadius = UDim.new(0, 3)

			local ContentStroke = _New_("UIStroke", Content)
			ContentStroke.Color = Color3.fromRGB(20, 20, 20)

			local Padding = _New_("UIPadding", Content)
			Padding.PaddingTop = UDim.new(0, 5)
			Padding.PaddingBottom = UDim.new(0, 5)
			Padding.PaddingLeft = UDim.new(0, 5)
			Padding.PaddingRight = UDim.new(0, 5)

			local Layout = _New_("UIListLayout", Content)
			Layout.Padding = UDim.new(0, 4)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder

			local function UpdateSectionSize()
				Section.Size = UDim2.new(
					1,
					0,
					0,
					30 + Layout.AbsoluteContentSize.Y + 10
				)
			end

			Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)
			UpdateSectionSize()
			
			
			
			local x = {}
			function x:toggle(e)
				e = e or {}

				local Toggle = _New_("Frame", Content);
				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Toggle.BackgroundTransparency = 1;
				Toggle.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Toggle.BorderSizePixel = 0;
				Toggle.Name = "Toggle";
				Toggle.Size = UDim2.new(1, 0, -0.0752941146492958, 40);

				local Title = _New_("TextLabel", Toggle);
				
				Title.AnchorPoint = Vector2.new(0, 0.5)
				Title.Position = UDim2.new(0, 28, 0.5, 0)
				Title.Size = UDim2.new(1, -36, 0, 20)

				
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Title.BackgroundTransparency = 1;
				Title.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Title.BorderSizePixel = 0;
				Title.Name = "Title";
				
				
				Title.Font = Enum.Font.SourceSansBold;
				Title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				Title.RichText = true;
				Title.Text = e.title or "Toggle";
				Title.TextColor3 = Color3.fromRGB(48.00000473856926, 49.000004678964615, 54.00000438094139);
				Title.TextSize = 14;
				Title.TextWrapped = true;
				Title.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint = _New_("UITextSizeConstraint", Title);
				UITextSizeConstraint.MaxTextSize = 14;

				local Interact = _New_("TextButton", Toggle);
				Interact.AnchorPoint = Vector2.new(0.5, 0.5);
				Interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Interact.BackgroundTransparency = 1;
				Interact.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Interact.BorderSizePixel = 0;
				Interact.Name = "Interact";
				Interact.Position = UDim2.new(0.49980059266090393, 0, 0.5, 0);
				Interact.Size = UDim2.new(1.0003985166549683, 0, 1, 0);
				Interact.ZIndex = 5;
				Interact.Font = Enum.Font.Unknown;
				Interact.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				Interact.RichText = true;
				Interact.Text = "";
				Interact.TextColor3 = Color3.fromRGB(0, 0, 0);
				Interact.TextScaled = true;
				Interact.TextSize = 14;
				Interact.TextTransparency = 1;
				Interact.TextWrapped = true;

				local UITextSizeConstraint_0 = _New_("UITextSizeConstraint", Interact);
				UITextSizeConstraint_0.MaxTextSize = 14;



				local vals = _New_("Frame", Toggle);
				vals.BackgroundColor3 = Color3.fromRGB(55.000004321336746, 56.0000042617321, 61.00000396370888);
				vals.BorderColor3 = Color3.fromRGB(0, 0, 0);
				vals.BorderSizePixel = 0;
				vals.Name = "vals";
				vals.Position = UDim2.new(0.03800475224852562, 0, 0.32499998807907104, 0);
				vals.Size = UDim2.new(0, 12, 0, 12);

				local UICorner = _New_("UICorner", vals);
				UICorner.CornerRadius = UDim.new(0, 3);
				
				
				e.callback = e.callback or function() end
				local debounce = e.value or false

				local EnabledColor = Color3.fromRGB(24, 136, 93)
				local DisabledColor = Color3.fromRGB(55, 56, 61)

				-- Toggle function
				local function toggle(state)
					if state ~= nil then
						debounce = state
					else
						debounce = not debounce
					end

					if debounce then
						vals.BackgroundColor3 = EnabledColor
					else
						vals.BackgroundColor3 = DisabledColor
					end

					pcall(e.callback, debounce)
				end

				-- Initial visuals
				if debounce then
					vals.BackgroundColor3 = EnabledColor
				else
					vals.BackgroundColor3 = DisabledColor
				end

				-- Mouse click
				Interact.MouseButton1Click:Connect(function()
					toggle()
				end)
				
				
				
				-- keybind
				
				local k = {}

				function k:Bind()
					
					local KeybindFrame = _New_("Frame", Toggle);
					KeybindFrame.AnchorPoint = Vector2.new(1, 0.5);
					KeybindFrame.AutomaticSize = Enum.AutomaticSize.XY;
					KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					KeybindFrame.BackgroundTransparency = 1;
					KeybindFrame.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
					KeybindFrame.BorderSizePixel = 0;
					KeybindFrame.Name = "KeybindFrame";
					KeybindFrame.Position = UDim2.new(0.9705551266670227, 0, 0.53125, 0);
					KeybindFrame.Size = UDim2.new(0.07888630777597427, 0, 0.5, 0);

					local KeybindBox = _New_("TextButton", KeybindFrame);
					KeybindBox.AnchorPoint = Vector2.new(0.5, 0.5);
					KeybindBox.AutomaticSize = Enum.AutomaticSize.XY;
					KeybindBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					KeybindBox.BackgroundTransparency = 1;
					KeybindBox.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
					KeybindBox.BorderSizePixel = 0;
					KeybindBox.Name = "KeybindBox";
					KeybindBox.Position = UDim2.new(0.5, 0, 0.5, 0);
					KeybindBox.Size = UDim2.new(1, 0, 1, 0);
					KeybindBox.ZIndex = 6;
					KeybindBox.Font = Enum.Font.SourceSansBold;
					KeybindBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
					KeybindBox.Text = "F";
					KeybindBox.TextColor3 = Color3.fromRGB(58.00000034272671, 62.00000010430813, 68.00000354647636);
					KeybindBox.TextSize = 14;
					KeybindBox.TextWrapped = true;

					local UITextSizeConstraint_1 = _New_("UITextSizeConstraint", KeybindBox);
					UITextSizeConstraint_1.MaxTextSize = 14;

					-- Read from e.Key (from toggle)
					local currentKeyCode = e.Key or Enum.KeyCode.F
					local currentKeyName = typeof(currentKeyCode) == "EnumItem" and currentKeyCode.Name or tostring(currentKeyCode)
					KeybindBox.Text = currentKeyName

					-- Click to rebind
					KeybindBox.MouseButton1Click:Connect(function()
						KeybindBox.Text = "..."
						local connection
						connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
							if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
								currentKeyCode = input.KeyCode
								currentKeyName = input.KeyCode.Name
								KeybindBox.Text = currentKeyName
								e.Key = currentKeyCode
								connection:Disconnect()
							end
						end)
					end)

					-- Press key to toggle
					UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKeyCode then
							toggle()
						end
					end)
				end
				return k;
				
				
			end
			
			function x:slider(e)
				e = e or {}

				e.callback = e.callback or function()end
				
				

				local Slider = _New_("Frame", Content);
				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Slider.BackgroundTransparency = 1;
				Slider.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Slider.BorderSizePixel = 0;
				Slider.Name = "Slider";
				Slider.Position = UDim2.new(0, 0, 0.2894117832183838, 0);
				Slider.Size = UDim2.new(1, 0, -0.07029413431882858, 40);

				local Title = _New_("TextLabel", Slider);
				Title.AnchorPoint = Vector2.new(0.5, 0.5);
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Title.BackgroundTransparency = 1;
				Title.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Title.BorderSizePixel = 0;
				Title.Name = "Title";
				Title.Position = UDim2.new(0.2980000078678131, 0, 0, 12);
				Title.Size = UDim2.new(0.5203210711479187, 0, 0.33835047483444214, 0);
				Title.Font = Enum.Font.SourceSansBold;
				Title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				Title.RichText = true;
				Title.Text = e.title or "Toggle";
				Title.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 152.0000061392784);
				Title.TextSize = 14;
				Title.TextWrapped = true;
				Title.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint = _New_("UITextSizeConstraint", Title);
				UITextSizeConstraint.MaxTextSize = 14;

				local Main = _New_("Frame", Slider);
				Main.AnchorPoint = Vector2.new(0.5, 0.5);
				Main.BackgroundColor3 = Color3.fromRGB(10.000000353902578, 10.000000353902578, 10.000000353902578);
				Main.BackgroundTransparency = 0.800000011920929;
				Main.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Main.BorderSizePixel = 0;
				Main.Name = "Main";
				Main.Position = UDim2.new(0.5059999227523804, 0, 0.6280019283294678, 4);
				Main.Size = UDim2.new(0.9399999976158142, 0, 0, 6);

				local UICorner = _New_("UICorner", Main);
				UICorner.CornerRadius = UDim.new(0, 2);

				local Interact = _New_("TextButton", Main);
				Interact.BackgroundColor3 = Color3.fromRGB(10.000000353902578, 10.000000353902578, 13.000000175088644);
				Interact.BackgroundTransparency = 1;
				Interact.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Interact.BorderSizePixel = 0;
				Interact.Name = "Interact";
				Interact.Size = UDim2.new(1, 0, 1, 0);
				Interact.ZIndex = 10;
				Interact.Font = Enum.Font.Unknown;
				Interact.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				Interact.RichText = true;
				Interact.Text = "";
				Interact.TextColor3 = Color3.fromRGB(0, 0, 0);
				Interact.TextScaled = true;
				Interact.TextSize = 14;
				Interact.TextWrapped = true;

				local UITextSizeConstraint_0 = _New_("UITextSizeConstraint", Interact);
				UITextSizeConstraint_0.MaxTextSize = 14;

				local Progress = _New_("Frame", Interact);
				Progress.BackgroundColor3 = Color3.fromRGB(26.000000350177288, 113.00000086426735, 73.00000324845314);
				Progress.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Progress.BorderSizePixel = 0;
				Progress.Name = "Progress";
				Progress.Size = UDim2.new(0.8009684681892395, 0, 1, 0);

				local UICorner_0 = _New_("UICorner", Progress);
				UICorner_0.CornerRadius = UDim.new(0, 2);

				local UIStroke = _New_("UIStroke", Interact);
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
				UIStroke.Color = Color3.fromRGB(17.00000088661909, 17.00000088661909, 17.00000088661909);

				local Information = _New_("TextLabel", Main);
				Information.AnchorPoint = Vector2.new(0.5, 0.5);
				Information.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Information.BackgroundTransparency = 1;
				Information.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Information.BorderSizePixel = 0;
				Information.Name = "Information";
				Information.Position = UDim2.new(0.5984159111976624, 0, -0.6666655540466309, -7);
				Information.Size = UDim2.new(0.7850467562675476, 0, 1.0714285373687744, 0);
				Information.ZIndex = 5;
				Information.Font = Enum.Font.SourceSansBold;
				Information.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				Information.RichText = true;
				Information.Text = "70";
				Information.TextColor3 = Color3.fromRGB(38.0000015348196, 39.00000147521496, 45.00000111758709);
				Information.TextSize = 13;
				Information.TextTransparency = 0.4000000059604645;
				Information.TextWrapped = true;
				Information.TextXAlignment = Enum.TextXAlignment.Right;

				local UITextSizeConstraint_1 = _New_("UITextSizeConstraint", Information);
				UITextSizeConstraint_1.MaxTextSize = 15;
				
	local UserInputService = game:GetService("UserInputService")

-- Make sure the fill grows from the left
Progress.AnchorPoint = Vector2.new(0, 0)
Progress.Position = UDim2.new(0, 0, 0, 0)

local dragging = false


local function setSliderValue(value)
	local clamped = math.clamp(value, e.min, e.max)
	local percentage = (clamped - e.min) / (e.max - e.min)

	Information.Text = tostring(math.floor(clamped))

	-- Update progress instantly (no tween)
	Progress.Size = UDim2.new(
		percentage,
		0,
		1,
		0
	)

	if e.callback then
		e.callback(math.floor(clamped))
	end
end


local function updateSlider(mouseX)
	local bar = Progress.Parent

	local barStart = bar.AbsolutePosition.X
	local barWidth = bar.AbsoluteSize.X

	if barWidth <= 0 then
		return
	end

	local percentage = math.clamp(
		(mouseX - barStart) / barWidth,
		0,
		1
	)

	local value = e.min + ((e.max - e.min) * percentage)

	setSliderValue(value)
end


-- Initialize default value
if e.def then
	setSliderValue(e.def)
end


-- Start dragging
Interact.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true

		updateSlider(UserInputService:GetMouseLocation().X)
	end
end)


-- Update while moving mouse
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		updateSlider(input.Position.X)
	end
end)


-- Stop dragging
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
				
			end
			
			function x:button(e)
				e = e or {}
				e.callback = e.callback or function() end
				

				local Button = _New_("Frame", Content);
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Button.BackgroundTransparency = 1;
				Button.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Button.BorderSizePixel = 0;
				Button.Name = "Button";
				Button.Size = UDim2.new(1, 0, -0.0752941146492958, 40);

				local Interact = _New_("TextButton", Button);
				Interact.AnchorPoint = Vector2.new(0.5, 0.5);
				Interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Interact.BackgroundTransparency = 1;
				Interact.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Interact.BorderSizePixel = 0;
				Interact.Name = "Interact";
				Interact.Position = UDim2.new(0.49980059266090393, 0, 0.5, 0);
				Interact.Size = UDim2.new(1.0003985166549683, 0, 1, 0);
				Interact.ZIndex = 5;
				Interact.Font = Enum.Font.Unknown;
				Interact.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				Interact.RichText = true;
				Interact.Text = "";
				Interact.TextColor3 = Color3.fromRGB(0, 0, 0);
				Interact.TextScaled = true;
				Interact.TextSize = 14;
				Interact.TextTransparency = 1;
				Interact.TextWrapped = true;

				local UITextSizeConstraint = _New_("UITextSizeConstraint", Interact);
				UITextSizeConstraint.MaxTextSize = 14;

				local bg = _New_("Frame", Button);
				bg.BackgroundColor3 = Color3.fromRGB(55.000004321336746, 56.0000042617321, 61.00000396370888);
				bg.BorderColor3 = Color3.fromRGB(0, 0, 0);
				bg.BorderSizePixel = 0;
				bg.Name = "bg";
				bg.Size = UDim2.new(0.94, 0, 0, 19)
				bg.Position = UDim2.new(0.03, 0, 0.08, 0)

				local UICorner = _New_("UICorner", bg);
				UICorner.CornerRadius = UDim.new(0, 2);

				local Title = _New_("TextLabel", bg);
				Title.AnchorPoint = Vector2.new(0.5, 0.5);
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Title.BackgroundTransparency = 1;
				Title.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Title.BorderSizePixel = 0;
				Title.Name = "Title";
				Title.Position = UDim2.new(0.31402459740638733, 0, 0.47861775755882263, 0);
				Title.Size = UDim2.new(0.6120936274528503, 0, 0.3499999940395355, 0);
				Title.Font = Enum.Font.SourceSansBold;
				Title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				Title.RichText = true;
				Title.Text = e.title or "Button";
				Title.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 152.0000061392784);
				Title.TextSize = 14;
				Title.TextWrapped = true;
				Title.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint_0 = _New_("UITextSizeConstraint", Title);
				UITextSizeConstraint_0.MaxTextSize = 14;

				local UIStroke = _New_("UIStroke", bg);
				UIStroke.Color = Color3.fromRGB(34.00000177323818, 34.00000177323818, 34.00000177323818);

				local UIGradient = _New_("UIGradient", bg);
				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(199.0000033378601, 199.0000033378601, 199.0000033378601)), ColorSequenceKeypoint.new(1, Color3.fromRGB(107.00000122189522, 107.00000122189522, 107.00000122189522))};
				UIGradient.Rotation = 90;
				
				
				local normalColor = bg.BackgroundColor3
				local clickColor = normalColor:Lerp(Color3.new(0, 0, 0), 0.15) -- 15% darker

				Interact.MouseButton1Click:Connect(function()
					e.callback()
					
					bg.BackgroundColor3 = clickColor
					task.wait(0.08)
					bg.BackgroundColor3 = normalColor
				end)
				
				
			end
			
			function x:clr(e)
				e = e or {}
				e.callback = e.callback or function()end

				local ColorPicker = _New_("Frame", Content);
				ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				ColorPicker.BackgroundTransparency = 1;
				ColorPicker.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				ColorPicker.BorderSizePixel = 0;
				ColorPicker.Name = "ColorPicker";
				ColorPicker.Position = UDim2.new(0, 0, 0.14029419422149658, 0);
				ColorPicker.Size = UDim2.new(1, 0, -0.0752941146492958, 40);

				local Title = _New_("TextLabel", ColorPicker);
				Title.AnchorPoint = Vector2.new(0.5, 0.5);
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Title.BackgroundTransparency = 1;
				Title.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Title.BorderSizePixel = 0;
				Title.Name = "Title";
				Title.Position = UDim2.new(0.4418782889842987, 0, 0.5312498211860657, 0);
				Title.Size = UDim2.new(0.6120936274528503, 0, 0.3499999940395355, 0);
				Title.Font = Enum.Font.SourceSansBold;
				Title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
				Title.RichText = true;
				Title.Text = e.title or "ClrPicker";
				Title.TextColor3 = Color3.fromRGB(150.0000062584877, 150.0000062584877, 152.0000061392784);
				Title.TextSize = 14;
				Title.TextWrapped = true;
				Title.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint = _New_("UITextSizeConstraint", Title);
				UITextSizeConstraint.MaxTextSize = 14;

				local Interact = _New_("TextButton", ColorPicker);
				Interact.AnchorPoint = Vector2.new(0.5, 0.5);
				Interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Interact.BackgroundTransparency = 1;
				Interact.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Interact.BorderSizePixel = 0;
				Interact.Name = "Interact";
				Interact.Position = UDim2.new(0.49980059266090393, 0, 0.5, 0);
				Interact.Size = UDim2.new(1.0003985166549683, 0, 1, 0);
				Interact.ZIndex = 5;
				Interact.Font = Enum.Font.Unknown;
				Interact.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				Interact.RichText = true;
				Interact.Text = "";
				Interact.TextColor3 = Color3.fromRGB(0, 0, 0);
				Interact.TextScaled = true;
				Interact.TextSize = 14;
				Interact.TextTransparency = 1;
				Interact.TextWrapped = true;

				local UITextSizeConstraint_0 = _New_("UITextSizeConstraint", Interact);
				UITextSizeConstraint_0.MaxTextSize = 14;

				local Clr = _New_("Frame", ColorPicker);
				Clr.BackgroundColor3 = e.def or Color3.fromRGB(24.00000236928463, 136.00000709295273, 93.00000205636024);
				Clr.BorderColor3 = Color3.fromRGB(0, 0, 0);
				Clr.BorderSizePixel = 0;
				Clr.Name = "Clr";
				Clr.Position = UDim2.new(0.03800475224852562, 0, 0.32499998807907104, 0);
				Clr.Size = UDim2.new(0, 12, 0, 12);

				local UICorner = _New_("UICorner", Clr);
				UICorner.CornerRadius = UDim.new(0, 3);

				local Window = _New_("Frame", ColorPicker);
				Window.BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867);
				Window.BackgroundTransparency = 0.5;
				Window.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Window.BorderSizePixel = 0;
				Window.Name = "Window";
				Window.Position = UDim2.new(0.3533439338207245, 0, 0.32758596539497375, 0);
				Window.Size = UDim2.new(0.6120551228523254, 0, -0.1699995994567871, 120);
				Window.Visible = false;

				local UIStroke = _New_("UIStroke", Window);
				UIStroke.Color = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997);

				local UICorner_0 = _New_("UICorner", Window);
				UICorner_0.CornerRadius = UDim.new(0, 4);

				local RGB = _New_("Frame", Window);
				RGB.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				RGB.BackgroundTransparency = 1;
				RGB.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				RGB.Name = "RGB";
				RGB.Position = UDim2.new(0.13840331137180328, 0, 0.7523497343063354, 0);
				RGB.Size = UDim2.new(0.5382830500602722, 0, 0.24166665971279144, 0);

				local UIListLayout = _New_("UIListLayout", RGB);
				UIListLayout.Padding = UDim.new(0, 5);
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;

				local BInput = _New_("Frame", RGB);
				BInput.AnchorPoint = Vector2.new(1, 0.5);
				BInput.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871);
				BInput.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				BInput.BorderSizePixel = 0;
				BInput.LayoutOrder = 2;
				BInput.Name = "BInput";
				BInput.Position = UDim2.new(0.90625, 0, 0.4655172526836395, 0);
				BInput.Size = UDim2.new(0.23275862634181976, 0, 0.931034505367279, 0);
				BInput.ZIndex = 10;

				local UIStroke_0 = _New_("UIStroke", BInput);
				UIStroke_0.Color = Color3.fromRGB(60.00000022351742, 60.00000022351742, 60.00000022351742);

				local UICorner_1 = _New_("UICorner", BInput);
				UICorner_1.CornerRadius = UDim.new(0, 5);

				local InputBox = _New_("TextBox", BInput);
				InputBox.AnchorPoint = Vector2.new(0.5, 0.5);
				InputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				InputBox.BackgroundTransparency = 1;
				InputBox.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				InputBox.BorderSizePixel = 0;
				InputBox.ClearTextOnFocus = false;
				InputBox.Name = "InputBox";
				InputBox.Position = UDim2.new(0.5, 0, 0.5, 0);
				InputBox.Size = UDim2.new(0.5962222218513489, 0, 0.5185185074806213, 0);
				InputBox.ZIndex = 10;
				InputBox.Font = Enum.Font.Unknown;
				InputBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				InputBox.PlaceholderColor3 = Color3.fromRGB(178.49999696016312, 178.49999696016312, 178.49999696016312);
				InputBox.PlaceholderText = "B";
				InputBox.RichText = true;
				InputBox.Text = "";
				InputBox.TextColor3 = Color3.fromRGB(200.00000327825546, 200.00000327825546, 200.00000327825546);
				InputBox.TextScaled = true;
				InputBox.TextSize = 12;
				InputBox.TextWrapped = true;
				InputBox.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint_1 = _New_("UITextSizeConstraint", InputBox);
				UITextSizeConstraint_1.MaxTextSize = 12;

				local GInput = _New_("Frame", RGB);
				GInput.AnchorPoint = Vector2.new(1, 0.5);
				GInput.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871);
				GInput.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				GInput.BorderSizePixel = 0;
				GInput.LayoutOrder = 1;
				GInput.Name = "GInput";
				GInput.Position = UDim2.new(0.3296017348766327, 0, 0.4958333373069763, 0);
				GInput.Size = UDim2.new(0.23275862634181976, 0, 0.931034505367279, 0);
				GInput.ZIndex = 10;

				local UICorner_2 = _New_("UICorner", GInput);
				UICorner_2.CornerRadius = UDim.new(0, 5);

				local UIStroke_1 = _New_("UIStroke", GInput);
				UIStroke_1.Color = Color3.fromRGB(60.00000022351742, 60.00000022351742, 60.00000022351742);

				local InputBox_0 = _New_("TextBox", GInput);
				InputBox_0.AnchorPoint = Vector2.new(0.5, 0.5);
				InputBox_0.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				InputBox_0.BackgroundTransparency = 1;
				InputBox_0.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				InputBox_0.BorderSizePixel = 0;
				InputBox_0.ClearTextOnFocus = false;
				InputBox_0.Name = "InputBox";
				InputBox_0.Position = UDim2.new(0.5, 0, 0.5, 0);
				InputBox_0.Size = UDim2.new(0.5962222218513489, 0, 0.5185185074806213, 0);
				InputBox_0.ZIndex = 10;
				InputBox_0.Font = Enum.Font.Unknown;
				InputBox_0.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				InputBox_0.PlaceholderColor3 = Color3.fromRGB(178.49999696016312, 178.49999696016312, 178.49999696016312);
				InputBox_0.PlaceholderText = "G";
				InputBox_0.RichText = true;
				InputBox_0.Text = "";
				InputBox_0.TextColor3 = Color3.fromRGB(200.00000327825546, 200.00000327825546, 200.00000327825546);
				InputBox_0.TextScaled = true;
				InputBox_0.TextSize = 12;
				InputBox_0.TextWrapped = true;
				InputBox_0.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint_2 = _New_("UITextSizeConstraint", InputBox_0);
				UITextSizeConstraint_2.MaxTextSize = 12;

				local RInput = _New_("Frame", RGB);
				RInput.AnchorPoint = Vector2.new(1, 0.5);
				RInput.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871);
				RInput.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				RInput.BorderSizePixel = 0;
				RInput.Name = "RInput";
				RInput.Position = UDim2.new(0.159964457154274, 0, 0.4958333373069763, 0);
				RInput.Size = UDim2.new(0.23275862634181976, 0, 0.931034505367279, 0);
				RInput.ZIndex = 10;

				local UIStroke_2 = _New_("UIStroke", RInput);
				UIStroke_2.Color = Color3.fromRGB(60.00000022351742, 60.00000022351742, 60.00000022351742);

				local UICorner_3 = _New_("UICorner", RInput);
				UICorner_3.CornerRadius = UDim.new(0, 5);

				local InputBox_1 = _New_("TextBox", RInput);
				InputBox_1.AnchorPoint = Vector2.new(0.5, 0.5);
				InputBox_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				InputBox_1.BackgroundTransparency = 1;
				InputBox_1.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				InputBox_1.BorderSizePixel = 0;
				InputBox_1.ClearTextOnFocus = false;
				InputBox_1.Name = "InputBox";
				InputBox_1.Position = UDim2.new(0.5, 0, 0.5, 0);
				InputBox_1.Size = UDim2.new(0.5959380269050598, 0, 0.5185185074806213, 0);
				InputBox_1.ZIndex = 11;
				InputBox_1.Font = Enum.Font.Unknown;
				InputBox_1.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				InputBox_1.PlaceholderColor3 = Color3.fromRGB(178.49999696016312, 178.49999696016312, 178.49999696016312);
				InputBox_1.PlaceholderText = "R";
				InputBox_1.RichText = true;
				InputBox_1.Text = "";
				InputBox_1.TextColor3 = Color3.fromRGB(200.00000327825546, 200.00000327825546, 200.00000327825546);
				InputBox_1.TextScaled = true;
				InputBox_1.TextSize = 12;
				InputBox_1.TextWrapped = true;
				InputBox_1.TextXAlignment = Enum.TextXAlignment.Left;

				local UITextSizeConstraint_3 = _New_("UITextSizeConstraint", InputBox_1);
				UITextSizeConstraint_3.MaxTextSize = 12;

				local Darkness = _New_("ImageButton", Window);
				Darkness.AnchorPoint = Vector2.new(1, 1);
				Darkness.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Darkness.BackgroundTransparency = 1;
				Darkness.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Darkness.Name = "Darkness";
				Darkness.Position = UDim2.new(0.9098525643348694, 0, 0.9249998927116394, 0);
				Darkness.Selectable = false;
				Darkness.Size = UDim2.new(0.09013071656227112, 0, 0.8583333492279053, 0);
				Darkness.ClipsDescendants = true;
				Darkness.Image = "http://www.roblox.com/asset/?id=6523291212";

				local UIStroke_3 = _New_("UIStroke", Darkness);
				UIStroke_3.Color = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997);

				local UICorner_4 = _New_("UICorner", Darkness);
				UICorner_4.CornerRadius = UDim.new(0, 6);

				local SliderPoint = _New_("ImageButton", Darkness);
				SliderPoint.AnchorPoint = Vector2.new(0.5, 0.5);
				SliderPoint.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				SliderPoint.BackgroundTransparency = 1;
				SliderPoint.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				SliderPoint.Name = "SliderPoint";
				SliderPoint.Position = UDim2.new(0.5, 0, 0.5, 0);
				SliderPoint.Selectable = false;
				SliderPoint.Size = UDim2.new(0.7692307829856873, 0, 0.09708737581968307, 0);
				SliderPoint.Image = "rbxassetid://3926309567";
				SliderPoint.ImageColor3 = Color3.fromRGB(0, 0, 0);
				SliderPoint.ImageRectOffset = Vector2.new(628, 420);
				SliderPoint.ImageRectSize = Vector2.new(48, 48);

				local TintAdder = _New_("TextLabel", Darkness);
				TintAdder.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				TintAdder.BackgroundTransparency = 0.800000011920929;
				TintAdder.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				TintAdder.Name = "TintAdder";
				TintAdder.Size = UDim2.new(1, 0, 1, 0);
				TintAdder.Font = Enum.Font.Unknown;
				TintAdder.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				TintAdder.RichText = true;
				TintAdder.Text = "";
				TintAdder.TextColor3 = Color3.fromRGB(0, 0, 0);
				TintAdder.TextScaled = true;
				TintAdder.TextSize = 14;
				TintAdder.TextWrapped = true;

				local UICorner_5 = _New_("UICorner", TintAdder);
				UICorner_5.CornerRadius = UDim.new(0, 6);

				local UITextSizeConstraint_4 = _New_("UITextSizeConstraint", TintAdder);
				UITextSizeConstraint_4.MaxTextSize = 14;

				local Color = _New_("ImageButton", Window);
				Color.Active = false;
				Color.AnchorPoint = Vector2.new(1, 0.5);
				Color.BackgroundColor3 = Color3.fromRGB(98.00000175833702, 255, 0);
				Color.BackgroundTransparency = 1;
				Color.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				Color.BorderSizePixel = 0;
				Color.Name = "Color";
				Color.Position = UDim2.new(0.7774795889854431, 0, 0.40950849652290344, 0);
				Color.Selectable = false;
				Color.Size = UDim2.new(0.7394753694534302, 0, 0.6856829524040222, 0);
				Color.Image = "http://www.roblox.com/asset/?id=6523286724";

				local UIStroke_4 = _New_("UIStroke", Color);
				UIStroke_4.Color = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997);

				local UICorner_6 = _New_("UICorner", Color);
				UICorner_6.CornerRadius = UDim.new(0, 6);

				local SliderPoint_0 = _New_("ImageButton", Color);
				SliderPoint_0.AnchorPoint = Vector2.new(0.5, 0.5);
				SliderPoint_0.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				SliderPoint_0.BackgroundTransparency = 1;
				SliderPoint_0.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				SliderPoint_0.Name = "SliderPoint";
				SliderPoint_0.Position = UDim2.new(0.5, 0, 0.5, 0);
				SliderPoint_0.Selectable = false;
				SliderPoint_0.Size = UDim2.new(0.06711409240961075, 0, 0.09708737581968307, 0);
				SliderPoint_0.Image = "rbxassetid://3926309567";
				SliderPoint_0.ImageColor3 = Color3.fromRGB(0, 0, 0);
				SliderPoint_0.ImageRectOffset = Vector2.new(628, 420);
				SliderPoint_0.ImageRectSize = Vector2.new(48, 48);

				local TintAdder_0 = _New_("TextLabel", Color);
				TintAdder_0.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				TintAdder_0.BackgroundTransparency = 0.800000011920929;
				TintAdder_0.BorderColor3 = Color3.fromRGB(27.000002190470695, 42.000001296401024, 53.000004440546036);
				TintAdder_0.Name = "TintAdder";
				TintAdder_0.Size = UDim2.new(1, 0, 1, 0);
				TintAdder_0.Font = Enum.Font.Unknown;
				TintAdder_0.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				TintAdder_0.RichText = true;
				TintAdder_0.Text = "";
				TintAdder_0.TextColor3 = Color3.fromRGB(0, 0, 0);
				TintAdder_0.TextScaled = true;
				TintAdder_0.TextSize = 14;
				TintAdder_0.TextWrapped = true;

				local UICorner_7 = _New_("UICorner", TintAdder_0);
				UICorner_7.CornerRadius = UDim.new(0, 6);

				local UITextSizeConstraint_5 = _New_("UITextSizeConstraint", TintAdder_0);
				UITextSizeConstraint_5.MaxTextSize = 14;
				
				Interact.MouseButton1Down:Connect(function()
					if not Window.Visible then
						Window.Visible = true
					else
						Window.Visible = false
					end
					
				end)
				
				local UserInputService = game:GetService("UserInputService")

				-- Elements
				local colorSlider = SliderPoint_0
				local colorImage = Color
				local brightnessSlider = SliderPoint
				local brightnessImage = Darkness

				local RBox = RInput:FindFirstChild("InputBox")
				local GBox = GInput:FindFirstChild("InputBox")
				local BBox = BInput:FindFirstChild("InputBox")

				local draggingColor = false
				local draggingBrightness = false
				local brightness = 1 -- Value between 0 (dark) and 1 (bright)

				-- Update the final selected color
				local function UpdateColor()
					local hue = colorSlider.Position.X.Scale
					local sat = 1 - colorSlider.Position.Y.Scale
					local val = brightness

					local color = Color3.fromHSV(hue, sat, val)

					if RBox then RBox.Text = tostring(math.floor(color.R * 255)) end
					if GBox then GBox.Text = tostring(math.floor(color.G * 255)) end
					if BBox then BBox.Text = tostring(math.floor(color.B * 255)) end

					e.callback(color)
					Clr.BackgroundColor3 = color
				end

				-- Move slider and update position
				local function SetSliderPosition(slider, image, input)
					local absPos = image.AbsolutePosition
					local absSize = image.AbsoluteSize
					local mouse = input.Position

					local x = math.clamp((mouse.X - absPos.X) / absSize.X, 0, 1)
					local y = math.clamp((mouse.Y - absPos.Y) / absSize.Y, 0, 1)

					slider.Position = UDim2.new(x, 0, y, 0)

					return x, y
				end

				-- Color Gradient Interaction
				colorImage.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingColor = true
						SetSliderPosition(colorSlider, colorImage, input)
						UpdateColor()
					end
				end)

				-- Brightness Bar Interaction
				brightnessImage.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingBrightness = true
						local _, y = SetSliderPosition(brightnessSlider, brightnessImage, input)
						brightness = 1 - y
						UpdateColor()
					end
				end)

				-- Mouse Up
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingColor = false
						draggingBrightness = false
					end
				end)

				-- Mouse Movement for dragging
				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if draggingColor then
							SetSliderPosition(colorSlider, colorImage, input)
							UpdateColor()
						elseif draggingBrightness then
							local _, y = SetSliderPosition(brightnessSlider, brightnessImage, input)
							brightness = 1 - y
							UpdateColor()
						end
					end
				end)
				
				
				
			end
			
			return x;
		end
		return s;
	end
return t;
end

return lib
