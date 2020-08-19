local Global_Fov = 6.0
local tmBasedSmth = 0.0
local Zenyatta_First_Init = true

--[[
    Prism Wrapper / Util
--]]
function W2S(Point1, Point2)
    return Game.Engine:WorldToScreen(Point1, Point2)
end

function DrawLine(PointStart, PointEnd, Color, Thickness)
    Game.Renderer:DrawLine(PointStart, PointEnd, Color, Thickness)
end

function DrawShadowLine(PointStart, PointEnd, LineColor, OutlineColor, LineThickness, OutlineThickness)
    DrawLine(PointStart, PointEnd, OutlineColor, LineThickness * 2 + OutlineThickness)
    DrawLine(PointStart, PointEnd, LineColor, LineThickness)
end

function DrawBox(PointX, PointY, Width, Height, Color, Thickness)
    local Point1 = Math.XMFLOAT2(PointX, PointY)
    local Point2 = Math.XMFLOAT2(PointX + Width, PointY)
    local Point3 = Math.XMFLOAT2(PointX, PointY + Height)
    local Point4 = Math.XMFLOAT2(PointX + Width, PointY + Height)

    DrawLine(Point1, Point2, Color, Thickness)
    DrawLine(Point1, Point3, Color, Thickness)
    DrawLine(Point2, Point4, Color, Thickness)
    DrawLine(Point3, Point4, Color, Thickness)
end

function DrawShadowBox(PointX, PointY, Width, Height, LineColor, OutlineColor, LineThickness, OutlineThickness)
    DrawBox(PointX - LineThickness, PointY - LineThickness, Width + LineThickness * 2, Height + LineThickness * 2, OutlineColor, OutlineThickness) --Outline
    DrawBox(PointX, PointY, Width, Height, LineColor, LineThickness) --Line
end

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

function round2(number, precision)
    local fmtStr = string.format('%%0.%sf', precision)
    number = string.format(fmtStr,number)
    return number
end

function sleep(a)
    local s = tonumber(os.clock() + a)
    while (os.clock() < s) do end
end

function dst(xm1,xm2)
    return math.sqrt((xm2.x-xm1.x)^2+(xm2.y-xm1.y)^2+(xm2.z-xm1.z)^2)
end

-- HeroID(UInt64), UltMax(float), NPC(bool)
local HeroDatabase = {
    ["Ana"] = { HeroID = 0x02E000000000013B, UltMax = 2100 , NPC = false,  },
    ["Ashe"] = { HeroID = 0x02E0000000000200, UltMax = 2240, NPC = false, Resource },
    ["Baptiste"] = { HeroID = 0x02E0000000000221, UltMax = 2352, NPC = false, Resource },
    ["Bastion"] = { HeroID = 0x02E0000000000015, UltMax = 2310, NPC = false, Resource },
    ["Brigitte"] = { HeroID = 0x02E0000000000195, UltMax = 2800, NPC = false, Resource },
    ["Doomfist"] = { HeroID = 0x02E000000000012F, UltMax = 1680, NPC = false, Resource },
    ["D.Va"] = { HeroID = 0x02E000000000007A, UltMax = 1540, NPC = false, Resource },
    ["Echo"] = { HeroID = 0x02E0000000000206, UltMax = 1960, NPC = false, Resource },
    ["Zenyatta"] = { HeroID = 0x02E0000000000029, UltMax = 1680, NPC = false, Resource },
    ["Hana"] = { HeroID = 0x02E000000000007A, UltMax = 319.2, NPC = false, Resource },
    ["Hanzo"] = { HeroID = 0x02E0000000000005, UltMax = 1680, NPC = false, Resource },
    ["Junkrat"] = { HeroID = 0x02E0000000000065, UltMax = 1925, NPC = false, Resource },
    ["Lucio"] = { HeroID = 0x02E0000000000079, UltMax = 2940, NPC = false, Resource },
    ["McCree"] = { HeroID = 0x02E0000000000042, UltMax = 1680, NPC = false, Resource },
    ["Mei"] = { HeroID = 0x02E00000000000DD, UltMax = 1610, NPC = false, Resource },
    ["Mercy"] = { HeroID = 0x02E0000000000004, UltMax = 1820, NPC = false, Resource },
    ["Moira"] = { HeroID = 0x02E00000000001A2, UltMax = 2380, NPC = false, Resource },
    ["Orisa"] = { HeroID = 0x02E000000000013E, UltMax = 1680, NPC = false, Resource },
    ["Pharah"] = { HeroID = 0x02E0000000000008, UltMax = 2100, NPC = false, Resource },
    ["Reaper"] = { HeroID = 0x02E0000000000002, UltMax = 2100, NPC = false, Resource },
    ["Reinhardt"] = { HeroID = 0x02E0000000000007, UltMax = 1540, NPC = false, Resource },
    ["Roadhog"] = { HeroID = 0x02E0000000000040, UltMax = 2240, NPC = false, Resource },
    ["Sigma"] = { HeroID = 0x02E000000000023B, UltMax = 1960, NPC = false, Resource },
    ["Soldier 76"] = { HeroID = 0x02E000000000006E, UltMax = 2310, NPC = false, Resource },
    ["Sombra"] = { HeroID = 0x02E000000000012E, UltMax = 1400, NPC = false, Resource },
    ["Symmetra"] = { HeroID = 0x02E0000000000016, UltMax = 1680, NPC = false, Resource },
    ["Torbjorn"] = { HeroID = 0x02E0000000000006, UltMax = 2142, NPC = false, Resource },
    ["Zenyatta"] = { HeroID = 0x02E0000000000003, UltMax = 1260, NPC = false, Resource },
    ["Widowmaker"] = { HeroID = 0x02E000000000000A, UltMax = 1540, NPC = false, Resource },
    ["Winston"] = { HeroID = 0x02E0000000000009, UltMax = 1540, NPC = false, Resource },
    ["Wrecking Ball"] = { HeroID = 0x02E00000000001CA, UltMax = 1540, NPC = false, Resource },
    ["Zarya"] = { HeroID = 0x02E0000000000068, UltMax = 2100, NPC = false, Resource },
    ["Zenyatta"] = { HeroID = 0x02E0000000000020, UltMax = 2310, NPC = false, Resource },
    ["Training Bot1"] = { HeroID = 0x02E000000000016B, UltMax = 0, NPC = true, Resource },
    ["Training Bot2"] = { HeroID = 0x02E000000000016C, UltMax = 0, NPC = true, Resource },
    ["Training Bot3"] = { HeroID = 0x02E000000000016D, UltMax = 0, NPC = true, Resource },
    ["Training Bot4"] = { HeroID = 0x02E000000000016E, UltMax = 0, NPC = true, Resource },
}

-- [slot] 0: Passive, 1: SKILL_1(Shift), 2: SKILL_2(E), 3: SKILL_L, 4: SKILL_R, 5: SKILL_ULT
-- [type] 1: .isUsing, 2: .flUltGauge, 3: .isBlocked, 4: GetCoolTime(), 5: .isUsing+GetCoolTime()
-- [id], [extra_id] 0: None
local SkillDatabase = {
    ["Ana"] = { 
        ["AnaShift"] = { Resource, slot = 1, type = 5, charging = false, casting = true, id = 0x3D, extra_id = 0x6 },
        ["AnaE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["AnaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Ashe"] = { 
        ["AsheShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["AsheE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["AsheUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Baptiste"] = { 
        ["BaptisteShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["BaptisteE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["BaptisteUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Bastion"] = { 
        ["BastionUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Brigitte"] = { 
        ["BrigitteShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["BrigitteE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["BrigitteR"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3306 },
        ["BrigitteUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Doomfist"] = { 
        ["DoomfistShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["DoomfistE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x8 },
        ["DoomfistR"] = { Resource, slot = 4, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["DoomfistUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["D.Va"] = { 
        ["D.VaShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["D.VaE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x9 },
        ["D.VaR"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["D.VaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Echo"] = { 
        ["EchoShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["EchoE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["EchoR"] = { Resource, slot = 4, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["EchoUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Zenyatta"] = { 
        ["ZenyattaShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["ZenyattaE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["ZenyattaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0x1510, extra_id = 0 },
    },
    ["Hana"] = { 
        ["HanaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Hanzo"] = { 
        ["HanzoShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["HanzoE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["HanzoUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Junkrat"] = { 
        ["JunkratShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["JunkratE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["JunkratUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Lucio"] = { 
        ["LucioE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["LucioR"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x9 },
        ["LucioUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["McCree"] = { 
        ["McCreeShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["McCreeE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["McCreeUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Mei"] = { 
        ["MeiShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["MeiE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["MeiUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Mercy"] = { 
        ["MercyE"] = { Resource, slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x5 },
        ["MercyUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Moira"] = { 
        ["MoiraShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["MoiraE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["MoiraUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Orisa"] = { 
        ["OrisaShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["OrisaE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["OrisaR"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["OrisaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Pharah"] = { 
        ["PharahShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x2 },
        ["PharahE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["PharahUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Reaper"] = { 
        ["ReaperShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x1 },
        ["ReaperE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["ReaperUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Reinhardt"] = { 
        ["ReinhardtShift"] = { Resource, slot = 1, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x2 },
        ["ReinhardtE"] = { Resource, slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x7 },
        ["ReinhardtUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Roadhog"] = { 
        ["RoadhogShift"] = { Resource, slot = 1, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x3 },
        ["RoadhogE"] = { Resource, slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x7 },
        ["RoadhogUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Sigma"] = { 
        ["SigmaShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["SigmaE"] = { Resource, slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x6 },
        ["SigmaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Soldier 76"] = { 
        ["Soldier 76E"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["Soldier 76R"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0xA },
        ["Soldier 76Ult"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Sombra"] = { 
        ["SombraShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["SombraE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["SombraUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Symmetra"] = { 
        ["SymmetraShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["SymmetraE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["SymmetraUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Torbjorn"] = { 
        ["TorbjornShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x189C, extra_id = 0 },
        ["TorbjornE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x1F89, extra_id = 0 },
        ["TorbjornUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Zenyatta"] = { 
        ["ZenyattaShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x2 },
        ["ZenyattaE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x1 },
        ["ZenyattaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Widowmaker"] = { 
        ["WidowmakerShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["WidowmakerE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["WidowmakerUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Winston"] = { 
        ["WinstonShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["WinstonE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["WinstonUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Wrecking Ball"] = { 
        ["Wrecking BallE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0xA },
        ["Wrecking BallR"] = { Resource, slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["Wrecking BallUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Zarya"] = { 
        ["ZaryaShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["ZaryaE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["ZaryaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Zenyatta"] = { 
        ["ZenyattaUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Training Bot1"] = {  },
    ["Training Bot2"] = {  },
    ["Training Bot3"] = {  },
    ["Training Bot4"] = {  },
    ["Common"] = { 
        ["ZaryaBarrier"] = { Resource, slot = 0, type = 4, charging = false, casting = false, id = 0x2BB, extra_id = 0x5 },
    },
}


function GetUltPercent(HeroName, UltCurrent)
    if HeroDatabase[HeroName] ~= nil then return round(UltCurrent / HeroDatabase[HeroName].UltMax * 100) end
    return 100
end

function CalcAngle(Position1, Position2)
    return Math.NormalizeVec3(Position1 - Position2)
end

function CalcAngleFromLocalPosition(Position)
    local LocalPos = Game.Engine:GetViewMatrix():GetCameraVec()
    return Math.NormalizeVec3(Position - LocalPos)
end

function CalcFov(Angle1, Angle2)
    return dst(Angle1, Angle2)
end

function CalcFovFromLocalAngle(Angle)
    local Control = Game.Engine:GetController()
    return dst(Control:GetAngle(), Angle)
end

--[[
    Zenyatta
--]]
local Zenyatta = { BestTarget = nil, BestFov, BestBone,
                MeleeAimbot = false, MeleeTarget = nil, MeleeAimbotSpeed = 0.025,
                PulseAimbot = false, PulseTarget = nil, PulseAimbotSpeed = 0.025 }

--[[
    Zenyatta:TargetSelector
    Mode - 0: Closest, 1: LowestHP, 2: Priority, 3: ClosestAim, 4: Smart
--]]
function Zenyatta:TargetSelector(Mode)
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    local Count = Game.Engine:GetPlayerCount()

    Zenyatta.BestTarget = nil
    Zenyatta.BestFov = Game.Engine:GetFov()
    Zenyatta.BestBone = -1

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
            if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end

            if (Zenyatta.BestTarget == nil) then
                local Found = Game.Engine:FindBestBone(Player, Zenyatta.BestFov, 0x11, 1)

                if (Found.bFound) then
                    Zenyatta.BestTarget = Player
                    Zenyatta.BestFov = Found.lastFov
                    Zenyatta.BestBone = Found.foundBone
                end
                goto Continue
            end

            if (Mode == 0) then --Closest
                if (dst(LocalPlayer:GetMesh():GetLocation(), Zenyatta.BestTarget:GetMesh():GetLocation()) >=
                    dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())) then
                    Zenyatta.BestTarget = Player
                end
            elseif (Mode == 1) then --LowestHP
                if (Zenyatta.BestTarget:GetHealth():GetLife().y >= HealthCurrent) then
                    Zenyatta.BestTarget = Player
                end
            elseif (Mode == 2) then --Priority
                --to-do
            elseif (Mode == 3) then --ClosestAim
                local LocalPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local Control = Game.Engine:GetController()
                if (CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Zenyatta.BestTarget:GetMesh():GetBonePos(Zenyatta.BestTarget:GetBoneId(1)))) >=
                    CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Player:GetMesh():GetBonePos(Player:GetBoneId(1))))) then
                    local Found = Game.Engine:FindBestBone(Player, Zenyatta.BestFov, 0x11, 1)

                    if (Found.bFound) then
                        Zenyatta.BestTarget = Player
                        Zenyatta.BestFov = Found.lastFov
                        Zenyatta.BestBone = Found.foundBone
                    end
                end
            elseif (Mode == 4) then --Smart
                local _Friends = Zenyatta:NearFriends(Zenyatta.BestTarget, true)
                local Friends = Zenyatta:NearFriends(Player, true)
                local _Distance = dst(LocalPlayer:GetMesh():GetLocation(), Zenyatta.BestTarget:GetMesh():GetLocation())
                local Distance = dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())
                local _HealthCurrent = Zenyatta.BestTarget:GetHealth():GetLife().y

                local _Score = Zenyatta:CalcTargetScore(_Friends, _Distance, _HealthCurrent)
                local Score = Zenyatta:CalcTargetScore(Friends, Distance, HealthCurrent)

                if (_Score >= Score) then
                    Zenyatta.BestTarget = Player
                end
            end
        end
        ::Continue::
    end
end

--[[
    Zenyatta:CalcTargetScore
--]]
function Zenyatta:CalcTargetScore(Friends, Distance, HealthCurrent)
    return Friends + Distance / 10 + HealthCurrent / 100
end

--[[
    Zenyatta:NearFriends
    Enemy - True: Enemy, False: Team
--]]
function Zenyatta:NearFriends(_Player, Enemy)
    local Count = Game.Engine:GetPlayerCount()
    local NearAllyHeroes = 0

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x

        --check Alive
        if (Health and (HealthCurrent > 0) and (Player:IsEnemy() == Enemy)) then
            if (_Player == Player) then goto Continue end

            local Distance = dst(Player:GetMesh():GetLocation(), _Player:GetMesh():GetLocation())

            if (Distance > 10.0) then goto Continue end

            NearAllyHeroes = NearAllyHeroes + 1
            ::Continue::
        end
    end

    return NearAllyHeroes
end

--[[
    Zenyatta:UsingDragonblade
--]]
function Zenyatta:NanoBoosted()
	return Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x34A, 0).isUsing
end

--[[
    Zenyatta:Aimbot
--]]
function Zenyatta:Aimbot(Speed, Fov_Free)
	if (Zenyatta.MeleeAimbot) then
        local Mesh = Zenyatta.MeleeTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local bonePos = Mesh:GetBonePos(0x11)

                local PredictPos = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 50, 0)

                local Diff = Math.XMFLOAT3(PredictPos.x - bonePos.x, PredictPos.y - bonePos.y, PredictPos.z - bonePos.z)

                PredictPos.y = bonePos.y + Diff.y - 0.35
                
                local AimSpeed = Zenyatta.MeleeAimbotSpeed
                local Control = Game.Engine:GetController()
                local AngleDiff = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(PredictPos))

                if (Zenyatta.UsingDragonblade() == 0) then
                    if (AngleDiff >= 0.35) then AimSpeed = AngleDiff * 0.01 + AimSpeed end
                else
                    if (AngleDiff >= 0.15) then AimSpeed = (AngleDiff * 0.01 + AimSpeed) * 0.5 end
                end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), CalcAngleFromLocalPosition(PredictPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
    elseif (Game.Utils.IsKeyPressed(0x1)) then
        if (Zenyatta.BestBone ~= -1) then
            local Mesh = Zenyatta.BestTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local bonePos = Mesh:GetBonePos(Zenyatta.BestBone)

                local PredictPos = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 75, 0)

                local Diff = Math.XMFLOAT3(PredictPos.x - bonePos.x, PredictPos.y - bonePos.y, PredictPos.z - bonePos.z)
                local HeightMultiply = 0.2

                PredictPos.x = bonePos.x + Diff.x * 1.13
                PredictPos.y = bonePos.y + Diff.y * HeightMultiply + 0.05
                PredictPos.z = bonePos.z + Diff.z * 1.13
                
                local AimSpeed = Speed
                local Control = Game.Engine:GetController()
                local AngleDiff = dst(Control:GetAngle(), Math.NormalizeVec3(bonePos - locPos))
                
                if (AngleDiff < Fov_Free + 0.13) and (AngleDiff >= Fov_Free) then AimSpeed = Fov_Free / 15 / AngleDiff end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(PredictPos - locPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
        end
    end
end

--[[
    Zenyatta:AutoMelee
--]]
function Zenyatta:AutoMelee()
    local Count = Game.Engine:GetPlayerCount()
    local LocalPlayer = Game.Engine:GetLocalPlayer()

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
		local HealthMax = Health:GetLife().x
        Zenyatta.MeleeAimbot = false

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
			if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end

            local Distance = dst(Player:GetMesh():GetLocation(), LocalPlayer:GetMesh():GetLocation())

			if (Distance > 2.76) then goto Continue end

			local Fov_Enemy_Local = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Player:GetMesh():GetBonePos(0x11)))

			if (HealthCurrent > 25) then goto Continue end

			if (Fov_Enemy_Local > (0.6^Distance)*1.5) then
				Zenyatta.MeleeAimbot = true
				Zenyatta.MeleeTarget = Player
				Zenyatta.MeleeAimbotSpeed = 0.025
				return
			else
				Zenyatta.MeleeAimbot = true
				Zenyatta.MeleeTarget = Player
				Zenyatta.MeleeAimbotSpeed = 0.001
				Game.Engine:GetController():SetKeyCode(0x800)
				return
			end
            ::Continue::
        end
    end
end

--[[
    Zenyatta:OnUpdate
--]]
function Zenyatta:OnUpdate()
	Zenyatta:TargetSelector(3)

    if (Zenyatta.BestTarget ~= nil) and (Zenyatta.BestBone == -1) then
        local Found = Game.Engine:FindBestBone(Zenyatta.BestTarget, Game.Engine:GetFov(), 0x11, 1)

        if (Found.bFound) then
            Zenyatta.BestFov = Found.lastFov
            Zenyatta.BestBone = Found.foundBone
        end
    end
end

function OnUpdate()
    collectgarbage("collect")
    Zenyatta:OnUpdate()
	Zenyatta:AutoMelee()
    Zenyatta:Aimbot(0.015, 0.01)
end

function OnDraw()
    collectgarbage("collect")
    if (Zenyatta_First_Init) then
        Game.Engine:SetFov(Global_Fov)
        Zenyatta_First_Init = false;
    end
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module