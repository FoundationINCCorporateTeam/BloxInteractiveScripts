# How to Install the KickModule Script in Your Roblox Game

Follow these steps to install and use the `KickModule` script from the BloxInteractiveScripts repository in your Roblox game:

## Step 1: Enable `HttpService` in Roblox Studio

1. Open your game in Roblox Studio.
2. Go to the `Home` tab.
3. Click on `Game Settings`.
4. Navigate to the `Security` tab.
5. Enable `Http Requests`.

## Step 2: Create a Script to Fetch and Load the Module

1. In Roblox Studio, create a new `Script` in `ServerScriptService`.
2. Copy and paste the following code into the script:

    ```lua
    local HttpService = game:GetService("HttpService")
    local ServerScriptService = game:GetService("ServerScriptService")

    -- URL of the raw GitHub module script
    local url = "https://raw.githubusercontent.com/FoundationINCCorporateTeam/BloxInteractiveScripts/main/V1/Lua/Moderation/KickModule.lua"

    -- Function to fetch the script from the URL
    local function fetchModuleScript(url)
        local success, result = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if success then
            return result
        else
            warn("Failed to fetch the module script: " .. tostring(result))
            return nil
        end
    end

    -- Fetch the module script
    local moduleScriptContent = fetchModuleScript(url)

    if moduleScriptContent then
        -- Create a Script to execute the module content
        local script = Instance.new("Script")
        script.Name = "KickModuleScript"
        script.Source = moduleScriptContent
        script.Parent = ServerScriptService

        -- Wait for the Script to be loaded and get the module
        local success, module = pcall(function()
            return require(script)
        end)

        if success then
            -- Use the module
            -- Example usage
            module.gameName = "YourGameName" -- Customize your game name if needed
            module.pollInterval = 5 -- Customize the polling interval if needed

            -- The module starts polling automatically in a separate thread as per the provided script
        else
            warn("Failed to require the module script: " .. tostring(module))
        end

        -- Optionally, remove the script if you don't need it anymore
        script:Destroy()
    else
        warn("Module script content is nil.")
    end
    ```

## Step 3: Customize and Use the Module

1. Customize the `gameName` and `pollInterval` properties of the module as needed in the script.
2. The module will start polling automatically based on the script you provided.

## Step 4: Save and Run

1. Save your script in Roblox Studio.
2. Run the game to ensure the `KickModule` is working correctly.

By following these steps, you'll successfully install and use the `KickModule` script from the BloxInteractiveScripts repository in your Roblox game.
