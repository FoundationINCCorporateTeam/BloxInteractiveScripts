-- Copyright 2024 All Rights Reserved. Blox Interactive.
-- SCRIPT IS NOT ALLOWED TO BE RESOLD.
--THE FOLLOWING SECTION MAY NOT BE REMOVED UNDER THE Blox Interative BloxInteractiveScripts License. V0.1.4
--[[
DO NOT REMOVE:
---------------------------------------------
Credits:
Blox Interactive: Original Code
https://bloxinteractive.vercel.app
Version Information:
Script Name: Kick Module
Last Updated By Blox Interactive: 7/30/2024
Author Updated: Didjatoot
Script Version: v0.1.2
Copyright Blox Interactive 2024. All Rights Reserved.
---------------------------------------------
]]
--END OF DO NOT REMOVE SECTION
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local module = {}
module.gameName = 'Test1' -- Default value, can be overridden
module.pollInterval = 2 -- Default to 2 seconds, can be overridden

-- Define the URL of the server
local pollUrl = 'https://appbloxinteractive.glitch.me/poll-kick-data' -- Replace with your actual URL
local removeUrl = 'https://appbloxinteractive.glitch.me/remove-kick-data' -- Replace with your actual URL

-- Function to create the kick GUI
local function createKickGui(player, reason)
	-- Freeze the player's character
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.Anchored = true
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "KickGui"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.7
	frame.Parent = screenGui

	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.4, 0, 0.4, 0)
	container.Position = UDim2.new(0.3, 0, 0.3, 0)
	container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	container.BackgroundTransparency = 0.1
	container.BorderSizePixel = 0
	container.Parent = frame

	local uICorner = Instance.new("UICorner")
	uICorner.CornerRadius = UDim.new(0, 20)
	uICorner.Parent = container

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	titleLabel.TextScaled = true
	titleLabel.Text = "You have been kicked from the experience"
	titleLabel.Parent = container

	local reasonLabel = Instance.new("TextLabel")
	reasonLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
	reasonLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
	reasonLabel.BackgroundTransparency = 1
	reasonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	reasonLabel.TextScaled = true
	reasonLabel.TextWrapped = true
	reasonLabel.Text = reason
	reasonLabel.Parent = container

	local leaveButton = Instance.new("TextButton")
	leaveButton.Size = UDim2.new(0.5, 0, 0.15, 0)
	leaveButton.Position = UDim2.new(0.25, 0, 0.75, 0)
	leaveButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	leaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	leaveButton.TextScaled = true
	leaveButton.Text = "Leave"
	leaveButton.Parent = container

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 10)
	buttonCorner.Parent = leaveButton

	leaveButton.MouseButton1Click:Connect(function()
		player:Kick(reason)
	end)

	screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Function to kick a player
local function kickPlayer(username, reason)
	local player = Players:FindFirstChild(username)
	if player then
		createKickGui(player, reason)

		-- Notify the server to remove the entry
		local removeData = HttpService:JSONEncode({
			username = username,
			gameName = module.gameName
		})

		pcall(function()
			HttpService:PostAsync(removeUrl, removeData, Enum.HttpContentType.ApplicationJson)
		end)
	end
end

-- Function to check for kick requests
local function checkForKickRequests()
	local success, response = pcall(function()
		return HttpService:GetAsync(pollUrl .. '?gameName=' .. HttpService:UrlEncode(module.gameName))
	end)

	if success then
		local data = HttpService:JSONDecode(response)

		for _, entry in ipairs(data) do
			local username = entry.username
			local reason = "You have been kicked for the following reason: "..entry.reason.. ". \n(BloxInteractive Moderation)"

			-- Kick the player if they are in the game
			kickPlayer(username, reason)
		end
	else
		warn("Failed to fetch kick requests: " .. response)
	end
end

-- Poll function
local function startPolling()
	while true do
		checkForKickRequests()
		wait(module.pollInterval) -- Use configurable polling interval
	end
end

-- Start polling in a separate thread
coroutine.wrap(startPolling)()

return module
