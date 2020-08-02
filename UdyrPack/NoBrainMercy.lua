local Init_First = true
local Color = {R=255, G=0, B=0};
local Fov = 30.0

function CalcDst(xm1,xm2) return math.sqrt((xm2.x-xm1.x)^2+(xm2.y-xm1.y)^2+(xm2.z-xm1.z)^2) end 
function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end

--[[ Resource ]]
local Resource = {}
local Resource_Logo_GIF = { Images = {}, CurrentIndex = 1, Count = 250 }

function Resource:Init()
    --Load GIF
    for i = 0, Resource_Logo_GIF.Count - 1 do
        Resource_Logo_GIF.Images[#(Resource_Logo_GIF.Images) + 1] = Game.Renderer:LoadResource("PrismLogo\\PrismLogo-" .. tostring(i) .. ".png")
    end
end

function Resource:DrawGIF(X, Y, W, H, Delay, GIF)
    Game.Renderer:DrawResource(X, Y, W, H, GIF.Images[GIF.CurrentIndex])
    
    if GIF.CurrentIndex < #(GIF.Images) then
        GIF.CurrentIndex = GIF.CurrentIndex + 1
    else
        GIF.CurrentIndex = 1
    end

    sleep(Delay)
end

--[[ Mercy ]]--
local Mercy = {}

function Mercy:Init()
    Fov = 30.0
end

function Mercy:Alone()
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    local LocalPlayer_Position = LocalPlayer:GetMesh():GetLocation()
    local NearAllyHeroes = 0

    for i = 0, Game.Engine:GetPlayerCount() - 1 do
        local Player = Game.Engine:GetPlayerAt(i)

        --Skip enemy
        if Player:IsEnemy() then goto Continue end

        --Skip dead player
        if not (Player:GetHealth() and (Player:GetHealth():GetLife().y > 0)) then goto Continue end

        local Player_Position = Player:GetMesh():GetLocation()

        local DistanceFromMe = CalcDst(Player_Position, LocalPlayer_Position)

        if (DistanceFromMe > 15.0) then
        end

        --대충 일정 거리안에 아군이있고 그 아군이 쓸모없는경우가 아닐경우(afk같은거) NearAllyHeroes++ 한다는코드

        --Continue statement
        ::Continue::
    end

    if (NearAllyHeroes > 0) then return true end

    return false
end

function Caption_Aggro()
    if (Color.R > 0 and Color.B == 0) then
        Color.R = Color.R - 1
        Color.G = Color.G + 1
    end
    if (Color.G > 0 and Color.R == 0) then
        Color.G = Color.G - 1
        Color.B = Color.B + 1
    end
    if (Color.B > 0 and Color.G == 0) then
        Color.R = Color.R + 1
        Color.B = Color.B - 1
    end

    local ColorHex = 0xEF000000 + 0x10000 * Color.R + 0x100 * Color.G + Color.B

    Game.Renderer:DrawText("[UdyrPack]NoBrainMercy - Loaded!", 374, 32, 20, ColorHex, false)
end

function Init()
    --[[ Config ]]
    local Config = Game.Settings
    Config.settings_esp_skeleton = false
    Config.settings_esp_highlight = true
    Config.settings_esp_text = false
    Config.settings_draw_fov = false

    Init_First = false
end

function OnUpdate()
    collectgarbage("collect")	
end

function OnDraw()
    collectgarbage("collect")
    --[[ Init ]]--
    if (Init_First) then 
        Init()
        Mercy:Init()
        Resource:Init()
        Game.Engine:SetFov(Fov)
    end

    --[[ Drawings ]]--
    Caption_Aggro()

    --[[ Overlay ]]--
    Resource:DrawGIF(310, 10, 64, 64, 0.010, Resource_Logo_GIF)

    --local Res_Logo = Game.Renderer:LoadResource("PrismLogo.png")
    --Game.Renderer:DrawResource(5, 5, 64, 64, Res_Logo)
end