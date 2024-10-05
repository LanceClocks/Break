-- Load the UI Library
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptsLynX/LynX/main/UI-Library/Source.lua"))()

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Store global values safely
_G.Store = {}

-- Function to ensure environment and character are loaded
local function waitForEnvironment()
    print("Waiting for the game to fully load...")
    while not game:IsLoaded() do
        task.wait(0.1) -- Smooth wait in short increments to avoid stalling the script
    end
    print("Game loaded.")

    repeat task.wait(0.1) until LocalPlayer and Character
    print("LocalPlayer and Character found.")

    repeat task.wait(0.1) until Character:FindFirstChild("Humanoid")
    print("Humanoid found in character.")
end

-- Safe function to break body parts with wave-like flow
local function breakBodyParts(char)
    print("Breaking body parts for character:", char.Name)
    xpcall(function()
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                print("Applying BodyGyro and BodyVelocity to:", part.Name)
                local bodyGyro = Instance.new("BodyGyro", part)
                bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bodyGyro.CFrame = part.CFrame

                local bodyVelocity = Instance.new("BodyVelocity", part)
                bodyVelocity.Velocity = Vector3.new(math.random(-50, 50), math.random(50, 100), math.random(-50, 50))
                bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)

                task.wait(0.2) -- Create a wave flow effect by delaying each body part's break
            end
        end
    end, function(err)
        warn("Error occurred while breaking body parts:", err)
    end)
end

-- Function to wrap the smooth breaking into a coroutine
local function smoothBreakCoroutine()
    print("Starting smooth break coroutine...")
    while task.wait(1) do
        coroutine.wrap(function()
            breakBodyParts(Character)
        end)()
    end
end

-- Notify on successful execution
local function notifyExecutionSuccess()
    lib:Notify({
        Title = "Execution Success!",
        Description = "Script successfully executed.",
        Duration = 5
    })
    print("Notified user of successful execution.")
end

-- Notify when humanoid is loaded
local function notifyHumanoidLoaded()
    lib:Notify({
        Title = "Humanoid Loaded",
        Description = "Humanoid has fully loaded and is ready for action!",
        Duration = 5
    })
    print("Notified user that humanoid has loaded.")
end

-- UI Window
local win = lib:CreateWindow("Execution Success", Vector2.new(600, 400))
print("UI Window created.")

-- Main Tab for script functionality
local MainTab = win:CreateTab("Main")
MainTab:AddLabel("Body Part Breaker")

-- Button to start breaking body parts
MainTab:AddButton("Break Body Parts", function()
    print("Break Body Parts button clicked.")
    task.spawn(smoothBreakCoroutine)
end)

-- Credits Tab with user info
local CreditsTab = win:CreateTab("Credits")
CreditsTab:AddLabel("Discord: auti4sm")
CreditsTab:AddLabel("GitHub: github.com/LanceClocks")
CreditsTab:AddLabel("This Script Was Made By Clocks🕰️")
print("Credits tab added with Discord and GitHub info.")

-- Wait for everything to load before starting
xpcall(function()
    waitForEnvironment()
end, function(err)
    warn("Error while waiting for environment:", err)
end)

-- Function to handle player joining and character loading
local function handlePlayer(v)
    print("Handling player:", v.Name)
    if v and v.Character then
        breakBodyParts(v.Character)
    end
end

-- Break all players' body parts when they are loaded
for _, player in ipairs(Players:GetPlayers()) do
    print("Breaking body parts for player:", player.Name)
    task.spawn(function() handlePlayer(player) end)
end

-- Listen for new players joining the game
Players.PlayerAdded:Connect(function(player)
    print("Player joined:", player.Name)
    player.CharacterAdded:Connect(function(character)
        print("Character added for player:", player.Name)
        task.spawn(function() breakBodyParts(character) end)
    end)
end)

-- Notify player upon successful script execution
notifyExecutionSuccess()

-- Wait for the humanoid in LocalPlayer to load
local humanoid = Character:WaitForChild("Humanoid")
notifyHumanoidLoaded()
