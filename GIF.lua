local Init_First = true
local Color = {R=255, G=0, B=0};

--Stolen from BrownJames' script ^ __ ^
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

    Game.Renderer:DrawText("Inoring is your best friend!", 404, 32, 20, ColorHex, false)
end

function OnUpdate()
    collectgarbage("collect")	
end

function OnDraw()
    collectgarbage("collect")
    --[[ Init ]]--
    if (Init_First) then 
        Resource:Init()
        Init_First = false
    end

    --[[ Drawings ]]--
    Caption_Aggro()

    --[[ Overlay ]]--
    Resource:DrawGIF(340, 10, 64, 64, 0.010, Resource_Logo_GIF)
end