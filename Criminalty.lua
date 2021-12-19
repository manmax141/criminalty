repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character -- wait for player to load
for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "FluxLib2" then
        v:Destroy()
    end
end


local player = game.Players.LocalPlayer;
local char = player.Character;
local holding = false;
local mouse = player:GetMouse();
local runService = game:GetService"RunService";
local input =   game:GetService("UserInputService")
local onoff = true;
input.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.RightShift and onoff then
          
            for i,v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "FluxLib2" then

                   
                        onoff = false;
                        v.Enabled = false;
                     
                end

              end
            elseif i.KeyCode == Enum.KeyCode.RightShift and not onoff then
            
            for i,v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "FluxLib2" then

                   
                    onoff = true;
                     v.Enabled = true;
                     
                end

              end
        end;

end);

-- holding
local spectate_PLAYER = nil;
local properties = {
    AIMBOT_RANGE = 15;
    esp_player = false;
    light_mode = false;
    spectate = false;
    aimbot = false;
    AIMBOT_PLAYERS = {};
    spectate_PLAYERS = {};
}
local client = {
    funcs = {};
};

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/manmax141/flux/main/lib")()

client.funcs.rejoin_start = function()
    return game:GetService("TeleportService"):Teleport(4588604953, player);
end;

client.esp_clear = function()
    for i, esps in pairs(workspace.Characters:GetDescendants()) do
        if (esps.name == "esp_tag") then
            
            esps:Destroy();
        end;
    end;
    return true;
end;

client.funcs.light_mode = function(state)
    if (state) then
        game.Lighting.ExposureCompensation = 2;
    else
        game.Lighting.ExposureCompensation = 1;
    end

    return true;
end;

client.funcs.fast_mode = function()
    if (not player) then
        return false;
    end

    for i, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            
            v.Material = Enum.Material.SmoothPlastic;
        end
    end
    return true;
end;

client.esp_player = function(player)
    local part = Instance.new("Part");
    part.Name = "esp_tag";
    part.CFrame = player.HumanoidRootPart.CFrame;
    part.CanCollide = false;
    part.Anchored = false;
    part.Transparency = 1;
    part.Parent = player;

    local weld = Instance.new("Weld");
    weld.Parent = part;
    weld.Part0 = part;
    weld.Part1 = player.HumanoidRootPart;

    local esp_tag = Instance.new("BillboardGui");
    esp_tag.AlwaysOnTop = true; --يحطلو الويز
    esp_tag.Name = "tag";
    esp_tag.Parent = part;
    esp_tag.Size = UDim2.new(0,75,0,75);

    local esp_text = Instance.new("TextLabel");
    esp_text.BackgroundTransparency = 1;
    esp_text.TextTransparency = 0;
    esp_text.TextScaled = true;
    local r_color = BrickColor.Random();
    esp_text.TextColor3 = r_color.Color;
    esp_text.Name = player.Name.."Label";
    esp_text.Text = player.name;
    esp_text.Parent = esp_tag;
    esp_text.Size = UDim2.new(0,75,0,75);
    return true;
end

client.funcs.esp_player_start = function(state)

    if (state == true) then
        client.esp_clear();
        properties.esp_player = true;
        for i, player in pairs(workspace.Characters:GetChildren()) do
           
                if(properties.esp_player) then
                    
                    client.esp_player(player);
                end

        end
    else
        
        client.esp_clear();
        properties.esp_player = false
        return false;
    end

end;

local win = Flux:Window("Mos Lord Hub", "Criminalty Version", Color3.fromRGB(255, 0, 0), Enum.KeyCode.RightShift);
local AIMBOT_TAB = win:Tab("AIMBOT","http://www.roblox.com/asset/?id=6023426915");
local spectate_TAB = win:Tab("SPECTATE","http://www.roblox.com/asset/?id=6023426915");
local MiscTab = win:Tab("MISC","http://www.roblox.com/asset/?id=6023426915");

local ESP_PLAYERS_TGL = MiscTab:Toggle("ESP PLAYERS", "esp's you players", false, function(state)

    client.funcs.esp_player_start(state);
end);

local REJOIN_BTN = MiscTab:Button("REJOIN", "rejoins u", function()

    client.funcs.rejoin_start();
end);

local LIGHT_MODE_BTN = MiscTab:Toggle("LIGHT MODE", "omg", false, function(state)

    client.funcs.light_mode(state);
end);

local FAST_MODE_BTN = MiscTab:Button("FAST MODE", "WOW", function()

    client.funcs.fast_mode();
end);

local PLAYER_spectate_DRPDOWN = spectate_TAB:Dropdown("CHOOSE PLAYER TO SPECTATE", properties.spectate_PLAYERS, function(text)
    client.funcs.CHOOSE_spectatePLAYER(text);
end);

local PLAYER_spectate_REFRESH = spectate_TAB:Button("REFRESH DROPDOWN", "OMG", function()
    client.funcs.UPD_spectate_DRPDOWN();
end);

local PLAYER_spectate_TGL = spectate_TAB:Toggle("SPECTATE", "yes yes", false, function(state)
    client.funcs.spectate_start(state);
end);

local PLAYER_AIMBOT_TGL = AIMBOT_TAB:Toggle("AIMBOT", "how?", false, function(state)
    client.AIMBOT(state);
end);

local PLAYER_AIMRANGE_SLIDER = AIMBOT_TAB:Slider("AIMBOT RANGE", "yes i am", 0, 100, 15, function(change)
    properties.AIMBOT_RANGE = change;
    return true;
end);

client.spectate = function(player)
    if(not player) then
        return false;
    end
    spawn(function()
        while(true) do runService.RenderStepped:Wait();
            if(not properties.spectate) then
                break;
            end

            for i,v in pairs(workspace.Characters:FindFirstChild(player):GetChildren()) do
                if v:IsA("Accessory") then
                    v:Destroy();
                end;
            end;
            workspace.CurrentCamera.CFrame = workspace.Characters:FindFirstChild(player).Head.CFrame;
        end
    end);
    return true;
end;

client.funcs.spectate_start = function(state)
    if(not state) then
        properties.spectate = false;
        return false;
    end

    properties.spectate = true;
    client.spectate(spectate_PLAYER);
    return true;
end;

client.funcs.UPD_spectate_DRPDOWN = function()
    PLAYER_spectate_DRPDOWN:Clear();
    for i, player in pairs(workspace.Characters:GetChildren()) do
        if (not player) then
            return false;
        end
        if (not properties.spectate_PLAYERS[player.Name]) then
            -- add players
            table.insert(properties.spectate_PLAYERS, player.Name);
            PLAYER_spectate_DRPDOWN:Add(player.Name);
        end
        if(not game.Players:FindFirstChild(properties.spectate_PLAYERS[i])) then
            -- remove players
            table.remove(properties.spectate_PLAYERS, i);
        end
    end
       
end

client.funcs.CHOOSE_spectatePLAYER = function(player)
    spectate_PLAYER = player;
    return true;
end;

client.AIMBOT = function(state)
    if (not state) then
        properties.aimbot = false;
        return false;
    end
    properties.aimbot = true;
    spawn(function()
        while(true) do runService.RenderStepped:Wait();
            char = player.Character or player.CharacterAdded:Wait(); -- update the character
            if(not properties.aimbot) then
                break;    
            end
            for i, AIMBOT_PLAYER in pairs(workspace.Characters:GetChildren()) do
                if((AIMBOT_PLAYER.HumanoidRootPart.Position-char.HumanoidRootPart.Position).magnitude <= properties.AIMBOT_RANGE and AIMBOT_PLAYER.Name ~= game.Players.LocalPlayer.Name) then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, AIMBOT_PLAYER.Head.Position);
                end
            end
        end
    end);

    return true;
end;
client.funcs.UPD_spectate_DRPDOWN();