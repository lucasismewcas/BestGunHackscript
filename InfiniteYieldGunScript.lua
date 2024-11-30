-- Custom command script for Infinite Yield to give guns and locate players based on chat commands
-- Works in Infinite Yield's custom chat input

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local gunFolder = replicatedStorage:WaitForChild("Guns")  -- Folder with gun models

-- List of guns that can be given through the command
local gunNames = {"AKM", "MA1", "AKU-74SU"}

-- Function to give the specified gun to the player
local function giveGun(gunName)
    local gun = gunFolder:FindFirstChild(gunName)
    if gun then
        local clone = gun:Clone()  -- Clone the gun and add it to the player's backpack
        clone.Parent = player.Backpack
        print(player.Name .. " has received " .. gunName)  -- Print to the console for feedback
    else
        print("Gun " .. gunName .. " not found!")  -- Error if the gun isn't found
    end
end

-- Function to locate another player and print their position (without teleporting)
local function locatePlayer(targetPlayerName)
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    if targetPlayer then
        -- Get the target player's character position
        local targetCharacter = targetPlayer.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            local position = targetCharacter.HumanoidRootPart.Position
            print(targetPlayer.Name .. "'s location: " .. tostring(position))
        else
            print(targetPlayer.Name .. " does not have a valid character.")
        end
    else
        print("Player " .. targetPlayerName .. " not found.")
    end
end

-- Function to handle custom chat commands using Infinite Yield's command system
function onCustomChatCommand(command)
    local commandName, arg = command:match("!(%w+)%s*(%S*)")  -- Capture command and argument
    if commandName == "give" then
        -- Check if the gun name matches a valid gun from the list
        for _, gun in ipairs(gunNames) do
            if arg:lower() == gun:lower() then
                giveGun(gun)  -- Give the requested gun
                return
            end
        end
        print("Invalid gun name! Available options are: " .. table.concat(gunNames, ", "))
    elseif commandName == "locate" then
        -- Locate the player with the given username and print the location
        locatePlayer(arg)
    end
end

-- Hook into Infinite Yield’s custom command system
if _G.InfiniteYield then
    -- Infinite Yield command listening system
    _G.InfiniteYield.CommandHandlers["give"] = onCustomChatCommand  -- Hook the custom "give" command to the script
    _G.InfiniteYield.CommandHandlers["locate"] = onCustomChatCommand  -- Hook the custom "locate" command to the script
else
    print("Infinite Yield is not available.")
end

-- Optional: GUI to indicate the script is working (for visual feedback)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 300, 0, 50)
statusLabel.Position = UDim2.new(0.5, -150, 0.9, -25)
statusLabel.Text = "Script Loaded: Ready to give guns and locate players!"
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Parent = screenGui