function abs(v)
    return (v^2)^0.5
end

function round(number)
    if (number - (number % 0.1)) - (number - (number % 1)) < 0.5 then
        number = number - (number % 1)
    else
        number = (number - (number % 1)) + 1
    end
    return string.format('%0.0f', number)
end

function Ballsploit()
    local player = Game.Engine:GetLocalPlayer()
    local mesh = player:GetMesh()
    local velocity = mesh:GetVelocity()
    local controller = Game.Engine:GetController()

    local currentvelocity = tonumber(round(abs((velocity.x^2 + velocity.z^2)^0.5)))
    
    if currentvelocity >= 15.5 then
        controller:SetMove2(0x81)
    end
end

function Ballsploit_Draw()
    local cnt = Game.Engine:GetPlayerCount()

    local player = Game.Engine:GetLocalPlayer()
    local heroid = player:GetIdentifier().HeroID
    if heroid ~= 0x02E00000000001CA then
        return
    end
    local mesh = player:GetMesh()
    local velocity = mesh:GetVelocity()
    local controller = Game.Engine:GetController()

    local currentvelocity = tonumber(round(abs((velocity.x^2 + velocity.z^2)^0.5)))
    
    Game.Renderer:DrawText(currentvelocity, 150, 35, 16, 0xffffffff, false)
end

local color = {r=255, g=0, b=0};

function Caption_Aggro()
    if (color.r > 0 and color.b == 0) then
        color.r = color.r - 1
        color.g = color.g + 1
    end
    if (color.g > 0 and color.r == 0) then
        color.g = color.g - 1
        color.b = color.b + 1
    end
    if (color.b > 0 and color.g == 0) then
        color.r = color.r + 1
        color.b = color.b - 1
    end

    local colorhex = 0xff000000 + 0x10000 * color.r + 0x100 * color.g + color.b

    Game.Renderer:DrawText("Ballsploit Loaded! (Author: Inoring / Powered by Prism)", 10, 10, 20, colorhex, false)
end

function OnUpdate()
    collectgarbage("collect")
    Ballsploit()
end

function OnDraw()
    collectgarbage("collect")
    --Visuals()
    --Ballsploit_Draw()
    Caption_Aggro()
end