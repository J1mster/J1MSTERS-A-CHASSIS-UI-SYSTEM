--[[
      __  ___              __             _      
 __ / / <  /  __ _   ___ / /_ ___   ____( )  ___
/ // /  / /  /  ' \ (_-</ __// -_) / __/|/  (_-<
\___/  /_/  /_/_/_//___/\__/ \__/ /_/      /___/
                                                
   ___        _____   __                    _      
  / _ | ____ / ___/  / /  ___ _  ___  ___  (_) ___
 / __ |/___// /__   / _ \/ _ `/ (_-<(_-</ / (_-<
/_/ |_|     \___/  /_//_/\_,_/ /___//___//_/ /___/
       
  __  __                        ____        __                ___                
 / / / /  ___  ___   ____      /  _/  ___  / /_  ___   ____  / _/ ___ _ ____ ___ 
/ /_/ /  (_-</ -_) / __/     _/ /   / _ \/ __// -_) / __/ / _/ / _ `// __// -_)
\____/  /___/\__/ /_/        /___/  /_//_/\__/  \__/ /_/   /_/   \_,_/ \__/ \__/ 
                   __             
  ___  __ __  ___ / /_ ___   __ _ 
 (_-</ // / (_-</__// -_) /  ' \
/___/ \_, / /___/\__/ \__/ /_/_/_/
     /___/                        

]]

local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")


local cfg = require(script.Parent.Parent.Configuration)
local ui = script.Parent.Parent
local main = script.Parent.Parent.Gauge.GaugeUI
local mn = ui.Menu.menu
local cp = ui.Menu.colorpicker --color picker, not what you thought

local car = ui.Parent.Car.Value
local values = ui.Parent.Values

local usingLTS = false 
local usingRTS = false 
local usingHazard = false

local _Tune = require(car["A-Chassis Tune"])

local peakRPM = _Tune.PeakRPM
local lineRPM = _Tune.Redline

local frames = main.custom4u.customInfo.screens
local currentScreen = frames["screen0 - blank"]
local s = frames["screen0 - blank"]
local function nextFrame()
	wait(0.2)
	currentScreen.nextFrame.Value.Position = UDim2.new(1.5, 0, 0.5, 0)
	currentScreen.nextFrame.Value.Visible = true
	ts:Create(currentScreen.nextFrame.Value, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	ts:Create(currentScreen, TweenInfo.new(0.2), {Position = UDim2.new(-0.5, 0, 0.5, 0)}):Play()
	currentScreen = currentScreen.nextFrame.Value
	wait(0.2)
	s.Visible = false
	s = currentScreen
end


local function openColorPicker(setting)
	ui.Menu.colorpicker.Picker.enabled.Value = true
	ui.Menu.colorpicker.Picker.change.Value = setting
end

car.DriveSeat.HeadsUpDisplay = false

if cfg.allowSettings == true then 
	main.sources["settingsbutton.ibt"].Visible = true
end


if _Tune.AutoStart == false and ui.Parent.IsOn.Value == false then 
	main.engine_start_stop.Visible = true
else 
	main.engine_start_stop.Visible = false 
end

cfg.hazardBoolean.Changed:Connect(function(v)
	if v == true then 
		usingHazard = true
	else 
		usingHazard = false
	end
end)

cfg.leftTurnSignalBoolean.Changed:Connect(function(v)
	if v == true then 
		usingLTS = true
	else 
		usingLTS = false
	end
end)

cfg.rightTurnSignalBoolean.Changed:Connect(function(v)
	if v == true then 
		usingRTS = true
	else 
		usingRTS = false
	end
end)


values.RPM.Changed:Connect(function(RPM)  --idle = 215 ; max = 43; off = 
	main.sources["needle.nd"].Rotation = (180 + 345 * math.min(1, RPM / 10000))

	if (RPM>(peakRPM+_Tune.AutoUpThresh)) and RPM<(peakRPM) then 
		
		ts:Create(main.sources["warningcolor.cl"] , TweenInfo.new(.2), {ImageColor3 = cfg.warninglightSHIFT}):Play()
		
	elseif RPM>(peakRPM)  then 
		
		ts:Create(main.sources["warningcolor.cl"] , TweenInfo.new(.2), {ImageColor3 = cfg.warninglightHRPM}):Play()
		
	else
		ts:Create(main.sources["warningcolor.cl"] , TweenInfo.new(.2), {ImageColor3 = cfg.warninglightNORMAL}):Play()
	end
end)

values.Horsepower.Changed:Connect(function(hp)
	main.sources["hp.txt"].Text = ("HP: ".. math.floor(hp))
end)
values.Torque.Changed:Connect(function(tq)
	main.sources["tq.txt"].Text = ("TQ: ".. math.floor(tq))
end)

values.TCS.Changed:Connect(function(tcs)
	if tcs == true then 
		main.sources["TCS.cl"].TextColor3 = cfg.color6_
	end
	if tcs == false then 
		main.sources["TCS.cl"].TextColor3 = Color3.fromRGB(140, 0, 2)
	end
end)

values.TCSActive.Changed:Connect(function(tcsA)
	if tcsA == true then 
		main.sources["TCS.cl"].TextColor3 = Color3.fromRGB(255, 213, 0)
	end
	if tcsA == false then 
		if values.TCS.Value == true then 
			main.sources["TCS.cl"].TextColor3 = cfg.color6_
		end
		if values.TCS.Value == false then 
			main.sources["TCS.cl"].TextColor3 = Color3.fromRGB(140, 0, 2)
		end
	end
end)

values.ABS.Changed:Connect(function(abs)
	if abs == true then 
		main.sources["ABS.txt"].TextColor3 = cfg.color6_
	end
	if abs == false then 
		main.sources["ABS.txt"].TextColor3 = Color3.fromRGB(140, 0, 2)
	end
end)
values.ABSActive.Changed:Connect(function(absA)
	if absA == true then 
		main.sources["ABS.txt"].TextColor3 = Color3.fromRGB(255, 213, 0)
	end
	if absA == false then 
		if values.ABS.Value == true then 
			main.sources["ABS.txt"].TextColor3 = cfg.color6_
		end
		if values.ABS.Value == false then 
			main.sources["ABS.txt"].TextColor3 = Color3.fromRGB(140, 0, 2)
		end
	end
end)

values.TransmissionMode.Changed:Connect(function(tm)
	if tm == "Auto" then 
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
		wait(0.2)
		main.sources["transmode.txt"].TextColor3 = cfg.color7_
		main.sources["transmode.txt"].Text = "A"
		cfg.Trans = "A"
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
	end
	if tm == "Semi" then 
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
		wait(0.2)
		cfg.Trans = "SM"
		main.sources["transmode.txt"].TextColor3 = cfg.color8_
		main.sources["transmode.txt"].Text = "SM"
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
	end
	if tm == "Manual" then 
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
		wait(0.2)
		cfg.Trans = "M"
		main.sources["transmode.txt"].TextColor3 = cfg.color9_
		main.sources["transmode.txt"].Text = "M"
		ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
	end
end)
local newGear = 0
values.TransmissionMode.Changed:Connect(function(tm)
	local gear = values.Gear.Value
	if values.TransmissionMode.Value == "Auto" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			ts:Create(main.sources["transmode.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "R"		
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			if values.PBrake.Value == true then 
				main.sources["gear.txt"].Text = "P"
			else
				main.sources["gear.txt"].Text = "N"
			end
			main.sources["gear.txt"].TextColor3 = cfg.color7_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 and not (main.sources["gear.txt"].Text == "D")then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "D"
			main.sources["gear.txt"].TextColor3 = cfg.color7_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
	if values.TransmissionMode.Value == "Semi" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "R"
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "N"
			main.sources["gear.txt"].TextColor3 = cfg.color10_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].TextColor3 = cfg.color8_
			main.sources["gear.txt"].Text = tostring(gear)
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
	if values.TransmissionMode.Value == "Manual" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "R"
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)

			main.sources["gear.txt"].Text = "N"
			main.sources["gear.txt"].TextColor3 = cfg.color10_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = tostring(gear)
			main.sources["gear.txt"].TextColor3 = cfg.color9_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
end)

values.Gear.Changed:Connect(function(gear)
	if values.TransmissionMode.Value == "Auto" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.5)
			main.sources["gear.txt"].Text = "R"		
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			if values.PBrake.Value == true then 
				main.sources["gear.txt"].Text = "P"
			else
				main.sources["gear.txt"].Text = "N"
			end
			main.sources["gear.txt"].TextColor3 = cfg.color7_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 and not (main.sources["gear.txt"].Text == "D") then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "D"
			main.sources["gear.txt"].TextColor3 = cfg.color7_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
	if values.TransmissionMode.Value == "Semi" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "R"
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "N"
			main.sources["gear.txt"].TextColor3 = cfg.color10_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].TextColor3 = cfg.color8_
			main.sources["gear.txt"].Text = tostring(gear)
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
	if values.TransmissionMode.Value == "Manual" then 
		if gear == -1  then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = "R"
			main.sources["gear.txt"].TextColor3 = cfg.color11_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear == 0 then 
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)

			main.sources["gear.txt"].Text = "N"
			main.sources["gear.txt"].TextColor3 = cfg.color10_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		elseif gear>0 then
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
			wait(0.2)
			main.sources["gear.txt"].Text = tostring(gear)
			main.sources["gear.txt"].TextColor3 = cfg.color9_
			ts:Create(main.sources["gear.txt"], TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
		end
	end
end)


values.PBrake.Changed:Connect(function(b)
	if b == true then 
		ts:Create(main.sources["PB.txt"], TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0.2}):Play()
	end
	if b == false then 
		ts:Create(main.sources["PB.txt"], TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
	end
end)

values.Brake.Changed:Connect(function(brakeForce)
	local red = 255
	local green = 255-brakeForce*255
	local blue = 255-brakeForce*255
	
	local color = Color3.fromRGB(red, green, blue)
	ts:Create(main.sources["brake.cl"], TweenInfo.new(0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = color}):Play()
end)
values.Throttle.Changed:Connect(function(throttleForce)
	local red = 255-throttleForce*255
	local green = 255-throttleForce*255
	local blue = 255

	local color = Color3.fromRGB(red, green, blue)
	ts:Create(main.sources["Throttle.cl"], TweenInfo.new(0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = color}):Play()
end)



values.Velocity.Changed:Connect(function(val)
	main.sources["speedometer.txt"].Text = math.floor(cfg[cfg.Unit .. "units"]*values.Velocity.Value.Magnitude)
end)






--UI menu 


local function openMenu()
	mn.ScrollingEnabled = false
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	mn.Size = UDim2.new(0.827, 0, 0.005, 0)
	mn.Visible = true
	ts:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(-0.24, 0, 0.559, 0)}):Play()
	wait(0.3)
	ts:Create(mn, TweenInfo.new(0.6), {Size = UDim2.new(0.827, 0, 1.424, 0)}):Play()
	wait(0.7)
	mn.interface.Position = UDim2.new(0.5, 0,0.5, 0)
	mn.interface.Visible = true
	
end
local function closeMenu()
	mn.interface.Visible = false
	mn.controls.Visible = false
	mn.settings.Visible = false
	cp.Picker.Visible = false
	ts:Create(mn, TweenInfo.new(0.6), {Size = UDim2.new(0.827, 0, 0.005, 0)}):Play()
	wait(0.6)
	ts:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0.584, 0, 0.559, 0)}):Play()
	wait(0.3)
	mn.Visible = false
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
end

mn.interface.buttons.image_controls.MouseButton1Click:Connect(function()
	ts:Create(mn.interface, TweenInfo.new(0.2), {Position = UDim2.new(-0.501, 0,0.5, 0)}):Play()
	mn.controls.Visible = true 
	mn.settings.Visible = false
	mn.controls.Position = UDim2.new(1.501, 0,0.5, 0)
	ts:Create(mn.controls, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0,0.5, 0)}):Play()
	wait(0.2)
	mn.interface.Visible = false
	mn.ScrollingEnabled = true
end)
mn.interface.buttons.image_settings.MouseButton1Click:Connect(function()
	ts:Create(mn.interface, TweenInfo.new(0.2), {Position = UDim2.new(1.501, 0,0.5, 0)}):Play()
	mn.settings.Visible = true 
	mn.controls.Visible = false
	mn.settings.Position = UDim2.new(-0.501, 0,0.5, 0)
	ts:Create(mn.settings, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0,0.5, 0)}):Play()
	wait(0.2)
	mn.interface.Visible = false
	mn.ScrollingEnabled = true
end)

mn.interface.buttons.image_controls.MouseEnter:Connect(function()
	ts:Create(mn.interface.buttons.image_controls, TweenInfo.new(0.5), {Size = UDim2.new(0, 188,0, 509)}):Play()
end)
mn.interface.buttons.image_settings.MouseEnter:Connect(function()
	ts:Create(mn.interface.buttons.image_settings, TweenInfo.new(0.5), {Size = UDim2.new(0, 188,0, 509)}):Play()
end)


mn.interface.buttons.image_controls.MouseLeave:Connect(function()
	ts:Create(mn.interface.buttons.image_controls, TweenInfo.new(0.5), {Size = UDim2.new(0, 188, 0, 435)}):Play()
end)
mn.interface.buttons.image_settings.MouseLeave:Connect(function()
	ts:Create(mn.interface.buttons.image_settings, TweenInfo.new(0.5), {Size = UDim2.new(0, 188,0, 435)}):Play()
end)

mn.interface["Close.bt"].MouseButton1Down:Connect(function()
	closeMenu()
end)
main.sources["settingsbutton.ibt"].MouseButton1Down:Connect(function()
	openMenu()
end)
mn.settings["Close.bt"].MouseButton1Click:Connect(function()
	closeMenu()
end)
mn.controls["Close.bt"].MouseButton1Click:Connect(function()
	closeMenu()
end)

local Cb = mn.controls.buttons
local Sb = mn.settings.buttons

Sb.Settings.UNIT.MouseButton1Down:Connect(function()
	if cfg.Unit == "MPH" then 
		cfg.Unit = "KPH"
	else 
		cfg.Unit = "MPH"
	end
end)
Sb.Settings.HP.MouseButton1Down:Connect(function()
	if cfg.showHP then 
		Sb.Settings.HP.Text = "SHOW HP = False"
		cfg.showHP = false
		main.sources["hp.txt"].Visible = false
	else 
		Sb.Settings.HP.Text = "SHOW HP = True"
		main.sources["hp.txt"].Visible = true
		cfg.showHP = true
	end
end)

Sb.Settings.TQ.MouseButton1Down:Connect(function()
	if cfg.showTQ ==true then 
		cfg.showTQ = false
		Sb.Settings.TQ.Text = "SHOW TQ = False"
		main.sources["tq.txt"].Visible = false
	else 
		cfg.showTQ = true
		Sb.Settings.TQ.Text = "SHOW TQ = True"
		main.sources["tq.txt"].Visible = true
	end
end)

Sb.Colors.GAUGECOLOR.MouseButton1Down:Connect(function()
	openColorPicker("color1_")
end)
Sb.Colors.REDZONE.MouseButton1Down:Connect(function()
	openColorPicker("color2_")
end)
Sb.Colors.TEXTPRIMARY.MouseButton1Down:Connect(function()
	openColorPicker("color3_")
end)
Sb.Colors.SECONDARYCOLOR.MouseButton1Down:Connect(function()
	openColorPicker("color4_")
end)
Sb.Colors.ACCENT1.MouseButton1Down:Connect(function()
	openColorPicker("color6_")
end)
Sb.Colors.ACCENT2.MouseButton1Down:Connect(function()
	openColorPicker("color5_")
end)
--Color theme

game["Run Service"].Heartbeat:Connect(function()
	wait()
	Sb.Colors.GAUGECOLOR.preview.BackgroundColor3 = cfg.color1_
	Sb.Colors.REDZONE.preview.BackgroundColor3 = cfg.color2_
	Sb.Colors.TEXTPRIMARY.preview.BackgroundColor3 = cfg.color3_
	Sb.Colors.SECONDARYCOLOR.preview.BackgroundColor3 = cfg.color4_
	Sb.Colors.ACCENT1.preview.BackgroundColor3 = cfg.color6_
	Sb.Colors.ACCENT2.preview.BackgroundColor3 = cfg.color5_

	main.images["_gauge.img"].ImageColor3 = cfg.color1_
	main.images["_redzone.img"].ImageColor3 = cfg.color2_
	main.images["_numbers.img"].ImageColor3 = cfg.color3_
	
	if _Tune.AutoStart == false and cfg.useSEB == true then 
		ui.Gauge.GaugeUI.engine_start_stop.Visible = true 
	end
	
	Sb.Settings.UNIT.Text = "UNIT = ".. cfg.Unit
	main.sources["speedunit.txt"].Text = cfg.Unit
	if cfg.showHP == true then Sb.Settings.HP.Text = "SHOW HP = True" main.sources["hp.txt"].Visible = true else Sb.Settings.HP.Text = "SHOW HP = False" main.sources["hp.txt"].Visible = false end
	if cfg.showTQ == true then Sb.Settings.TQ.Text = "SHOW TQ = True" main.sources["tq.txt"].Visible = true else Sb.Settings.TQ.Text = "SHOW TQ = False" main.sources["tq.txt"].Visible = false end
	if cfg.carIsElectric == true then 
		main.sources["fuellvl.bar"].BackgroundColor3 = cfg.color12_
	else 
		main.sources["fuellvl.bar"].BackgroundColor3 = cfg.color13_
	end
	
	for _, v in pairs(main:GetDescendants())  do
		if v:FindFirstChild("color_directives") then 
			if string.find(v.Name, ".txt") then 
				v.TextColor3 = (cfg["color" ..  tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, ".cl") then 
				v.BackgroundColor3 = (cfg["color" ..  tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, "img") then 
				v.ImageColor3 = (cfg["color" .. tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, ".nd") then 
				v.ImageColor3 = (cfg["color" .. tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, ".ibt") then 
				v.ImageColor3 = (cfg["color" .. tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, ".tbt") then 
				v.TextColor3 = (cfg["color" .. tostring(v.color_directives.Value) .. "_"])
			end
			if string.find(v.Name, ".clr") then 
				v.TextColor3 = (cfg["color" .. tostring(v.color_directives.Value) .. "_"])
			end
		end
	end
	
end)


game["Run Service"].Heartbeat:Connect(function()
	if usingLTS == true then 
		ts:Create(main.sources["TurningLeft.txt"], TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	end
	if usingRTS == true then 
		ts:Create(main.sources["TurningRight.txt"], TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	end
	if usingHazard == true then 
		ts:Create(main.sources["TurningLeft.txt"], TweenInfo.new(0.2), {TextTransparency = 0}):Play()
		ts:Create(main.sources["TurningRight.txt"], TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	end
	wait(0.8)	
	ts:Create(main.sources["TurningLeft.txt"], TweenInfo.new(0.2), {TextTransparency = 0.76}):Play()
	ts:Create(main.sources["TurningRight.txt"], TweenInfo.new(0.2), {TextTransparency = 0.76}):Play()
	wait(0.8)
end)


frames.Parent.nextScreen.MouseButton1Down:Connect(function()
	nextFrame()
end)

ui.Gauge.GaugeUI.engine_start_stop.MouseButton1Down:Connect(function()
	if values.Parent.IsOn.Value == false then
		values.Parent.IsOn.Value = true 
		ts:Create(ui.Gauge.GaugeUI.engine_start_stop, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(172, 172, 172)}):Play()
		ts:Create(ui.Gauge.GaugeUI.engine_start_stop.boarder, TweenInfo.new(0.5), {Color = Color3.fromRGB(172, 172, 172)}):Play()
	elseif values.Parent.IsOn.Value == true then
		values.Parent.IsOn.Value = false 
		ts:Create(ui.Gauge.GaugeUI.engine_start_stop, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(255, 0, 4)}):Play()
		ts:Create(ui.Gauge.GaugeUI.engine_start_stop.boarder, TweenInfo.new(0.5), {Color = Color3.fromRGB(255, 0, 4)}):Play()
		
	end
end)
local needle3 = "rbxassetid://12788011081" --Full needle
local needle2 = "rbxassetid://12788011264" --same thing but bigger
local needle1 = "rbxassetid://12788011434" --cuts off until under the gauge
mn.settings.buttons.Settings.NEEDLE.MouseButton1Down:Connect(function()
	if cfg.Needle == 1 then 
		mn.settings.buttons.Settings.NEEDLE.Text = "NEEDLE = 2"
		cfg.Needle = 2 
		main.sources["needle.nd"].Image = needle2
	elseif cfg.Needle == 2 then 
		cfg.Needle = 3 
		main.sources["needle.nd"].Image = needle3
		mn.settings.buttons.Settings.NEEDLE.Text = "NEEDLE = 3"
	elseif cfg.Needle == 3 then 
		cfg.Needle = 1 
		main.sources["needle.nd"].Image = needle1
		mn.settings.buttons.Settings.NEEDLE.Text = "NEEDLE = 1"
	end
end)

uis.InputBegan:Connect(function(input)
	if cfg.useKeybinds == true and ui.Visible == true then 
		if uis:IsKeyDown(Enum.KeyCode.J) then 

			if uis:IsKeyDown(cfg.next_) then 
				nextFrame()
			end
			if uis:IsKeyDown(cfg.changeUnit_) then 
				if cfg.Unit == "MPH" then 
					cfg.Unit = "KPH"
				else 
					cfg.Unit = "MPH"
				end
			end
			if uis:IsKeyDown(cfg.settings_) then 
				openMenu()
				wait(1)
				ts:Create(mn.interface, TweenInfo.new(0.2), {Position = UDim2.new(1.501, 0,0.5, 0)}):Play()
				mn.settings.Visible = true 
				mn.controls.Visible = false
				mn.settings.Position = UDim2.new(-0.501, 0,0.5, 0)
				ts:Create(mn.settings, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0,0.5, 0)}):Play()
				wait(0.2)
				mn.interface.Visible = false
				mn.ScrollingEnabled = true
			end
			if uis:IsKeyDown(cfg.keybinds_) then 
				openMenu()
				wait(1)
				ts:Create(mn.interface, TweenInfo.new(0.2), {Position = UDim2.new(-0.501, 0,0.5, 0)}):Play()
				mn.controls.Visible = true 
				mn.settings.Visible = false
				mn.controls.Position = UDim2.new(1.501, 0,0.5, 0)
				ts:Create(mn.controls, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0,0.5, 0)}):Play()
				wait(0.2)
				mn.interface.Visible = false
				mn.ScrollingEnabled = true
			end
			if uis:IsKeyDown(cfg.hideorshow_) then 
				if ui.Visible == false then 
					ui.Visible = true
				elseif ui.Visible == true then 
					ui.Visible = false
					
					local x = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui) 
					local q = Instance.new("TextLabel", x)
					q.BackgroundTransparency = 1 
					q.TextColor3 = Color3.fromRGB(86, 0, 0)
					
					q.Text = ("Vehicle UI hidden. Press " .. cfg.hideorshow_.Name .. " + J to show it again.")
					
				end
			end

		elseif uis:IsKeyDown(cfg.startOrStop) then 
			if values.Parent.IsOn.Value == false then
				values.Parent.IsOn.Value = true 
				ts:Create(ui.Gauge.GaugeUI.engine_start_stop, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(172, 172, 172)}):Play()
				ts:Create(ui.Gauge.GaugeUI.engine_start_stop.boarder, TweenInfo.new(0.5), {Color = Color3.fromRGB(172, 172, 172)}):Play()
			elseif values.Parent.IsOn.Value == true then
				values.Parent.IsOn.Value = false 
				ts:Create(ui.Gauge.GaugeUI.engine_start_stop, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(255, 0, 4)}):Play()
				ts:Create(ui.Gauge.GaugeUI.engine_start_stop.boarder, TweenInfo.new(0.5), {Color = Color3.fromRGB(255, 0, 4)}):Play()
			end
		end 
	end
end)
