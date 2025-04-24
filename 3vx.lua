local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local WEBHOOK_URL = "https://discord.com/api/webhooks/1364701670516326471/cM3JP5GeypuWK3o9IwEvPI1IelfmD8A5ajOwnlf579uoto8Nb_lbQjOrfQFJqI_bc5wY"

local VALID_RIFTS = {
	"event-1", "event-2", "event-3", "spikey-egg", "magma-egg", "crystal-egg",
	"lunar-egg", "void-egg", "hell-egg", "nightmare-egg", "rainbow-egg", "aura-egg"
}

local customNames = {
	["void-egg"] = "Void egg",
	["nightmare-egg"] = "Nightmare egg",
	["rainbow-egg"] = "Rainbow egg",
	["aura-egg"] = "AURA EGG",
	["event-1"] = "Bunny egg",
	["event-2"] = "Pastel egg",
	["event-3"] = "Throwback egg",
	["hell-egg"] = "Hell egg"
}

local imageUrls = {
	["void-egg"] = "https://static.wikia.nocookie.net/bgs-infinity/images/5/58/Void_Egg.png/revision/latest?cb=20250412180803",
	["nightmare-egg"] = "https://static.wikia.nocookie.net/bgs-infinity/images/4/43/Nightmare_Egg.png/revision/latest?cb=20250412170032",
	["rainbow-egg"] = "https://static.wikia.nocookie.net/bgs-infinity/images/3/3f/Rainbow_Egg.png/revision/latest?cb=20250412180318",
	["aura-egg"] = "https://static.wikia.nocookie.net/bgs-infinity/images/2/2e/Aura_Egg.png/revision/latest?cb=20250420102104",
	["event-1"] = "https://static.wikia.nocookie.net/bgs-infinity/images/c/cc/Pastel_Egg.png/revision/latest?cb=20250419195650",
	["event-2"] = "https://static.wikia.nocookie.net/bgs-infinity/images/4/4d/Bunny_Egg.png/revision/latest?cb=20250419195943",
	["event-3"] = "https://www.bgsi.gg/eggs/throwback-egg.png"
}

Color3.new(1, 0.964706, 0.25098)

local eggColors = {
	["void-egg"] = 0x3916a8,
	["nightmare-egg"] = 0x9d1c1b,
	["rainbow-egg"] = 0xf75ef7,
	["aura-egg"] = 0xeeb76a,
	["event-1"] = 0x64f792,
	["event-2"] = 0x64f792,
	["event-3"] = 0x64f792,
	["hell-egg"] = 0xfff640,
}

local riftsFolder = workspace:WaitForChild("Rendered"):WaitForChild("Rifts")
local jobId = game.JobId
local playerCount = #game.Players:GetPlayers()

local function sendEmbed(title, description, color, height, riftName)
	local payload = {
		embeds = { {
			title = title,
			description = description,
			color = color,
			fields = {
				{ name = "Height", value = height .. "m", inline = true },
				{ name = "Players", value = tostring(playerCount), inline = true },
				{ name = "Job ID", value = jobId, inline = false }
			},
			thumbnail = imageUrls[riftName:lower()] and { url = imageUrls[riftName:lower()] } or nil
		} }
	}
	http_request({
		Url = WEBHOOK_URL,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode(payload)
	})
end

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

for _, rift in ipairs(riftsFolder:GetChildren()) do
	local nameLower = rift.Name:lower()
	if table.find(VALID_RIFTS, nameLower) then
		local displayName = customNames[nameLower] or rift.Name
		local surfaceGui = rift.Display.SurfaceGui
		local luckMultiplier = surfaceGui.Icon:FindFirstChild("Luck").Text or surfaceGui.Luck.Text
		local height = math.round(rift.Output.Position.Y)

		local color = eggColors[nameLower] or 0xFFFFFF

		if not nameLower:find("event") and not nameLower:find("aura") and (nameLower == "void-egg" or nameLower == "nightmare-egg" or nameLower == "rainbow-egg") and (--[[luckMultiplier:lower() == "x5" or luckMultiplier:lower() == "x10" or]] luckMultiplier:lower() == "x25") then
			sendEmbed("🎯 Egg Found!", "Found **" .. luckMultiplier .. " " .. displayName .. "**", color, height, nameLower)
		elseif nameLower:find("event") then
			sendEmbed("🎉 Event Egg Found!", "Found **" .. luckMultiplier .. " " .. displayName .. "**", color, height, nameLower)
		elseif nameLower:find("aura") then
			sendEmbed("FOUND AURA EGG!", "An **" .. displayName .. "** has spawned!", color, height, nameLower)
		end
	end
end

task.spawn(function()
	local PLACE_ID = 85896571713843
	local success = false

	while not success do
		success = pcall(function()
			return TeleportService:TeleportAsync(PLACE_ID, { LocalPlayer })
		end)

		if not success then
			task.wait(2)
		end
	end
end)

