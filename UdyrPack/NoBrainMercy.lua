local OnDraw_Init_First = true
local Color = {R = 255, G = 0, B = 0};
local Fov = 30.0

--[[ UtilFunctions ]]
function CalcDst(xm1,xm2) return math.sqrt((xm2.x-xm1.x)^2+(xm2.y-xm1.y)^2+(xm2.z-xm1.z)^2) end 
function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end

--[[ Resource ]]
local Resource = {}

--GIF 선언예시 : local rwdkor = { Images = {}, CurrentIndex = 1, Count = png개수 }
--스크립트폴더\FileName\FileName-몇번째인지숫자.png 형식으로 이미지 넣기
local Resource_Logo_GIF = { Images = {}, CurrentIndex = 1, Count = 250 }

function Resource:Init()
    Resource:LoadGIF("PrismLogo", Resource_Logo_GIF)
end

function Resource:LoadGIF(FileName, GIF)
    for i = 0, GIF.Count - 1 do
        GIF.Images[#(GIF.Images) + 1] = Game.Renderer:LoadResource(FileName .. "\\" .. FileName .. "-" .. tostring(i) .. ".png")
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
local AllyHeroes = {}
local HeroData = { BattleTag, Waypoints = {}, HeroName }
local Waypoint = { Position, Timestamp }

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

        if (DistanceFromMe > 15.0) and (true--[[타임스탬프 지나도 멈춰있는경우]]) then goto Continue end
        --대충 일정 거리안에 아군이있고 그 아군이 쓸모없는경우가 아닐경우(afk같은거) NearAllyHeroes++ 한다는코드

        NearAllyHeroes = NearAllyHeroes + 1

        --Continue statement
        ::Continue::
    end

    if (NearAllyHeroes > 0) then return false end

    return true
end

function Caption_Aggro(Text, X, Y, Size)
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

    local ColorHex = 0xFF000000 + 0x10000 * Color.R + 0x100 * Color.G + Color.B

    Game.Renderer:DrawText(Text, X, Y, Size, ColorHex, false)
end

function OnDraw_Init()
    --[[ Config ]]
    local Config = Game.Settings
    Config.settings_esp_skeleton = false
    Config.settings_esp_highlight = true
    Config.settings_esp_text = false
    Config.settings_draw_fov = false

    Mercy:Init()
    Resource:Init()

    Init_First = false
end

function OnUpdate()
    collectgarbage("collect")	
end

function OnDraw()
    collectgarbage("collect")
    --[[ Init ]]--
    if (OnDraw_Init_First) then 
        OnDraw_Init()
        Game.Engine:SetFov(Fov)
    end

    --[[ Overlay ]]--
    local WindowSize = { W = Game.Renderer:GetWidth(), H = Game.Renderer:GetHeight()}
    local Logo_Rect = { W = 64, H = 64, L = 10, T = 10 }
    Resource:DrawGIF(Logo_Rect.L, Logo_Rect.T, Logo_Rect.W, Logo_Rect.H, 0.010, Resource_Logo_GIF)

    --[[ Drawings ]]--
    Caption_Aggro("[UdyrPack]NoBrainMercy - Loaded!", Logo_Rect.L + Logo_Rect.W, Logo_Rect.T + Logo_Rect.H / 2 - 10, 20)
end