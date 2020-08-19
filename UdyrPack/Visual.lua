local OnDraw_Init_First = true
local tmBasedSmth = 0.0

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
    ["Genji"] = { HeroID = 0x02E0000000000029, UltMax = 1680, NPC = false, Resource },
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
    ["Tracer"] = { HeroID = 0x02E0000000000003, UltMax = 1260, NPC = false, Resource },
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
        --["BrigitteE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        --["BrigitteR"] = { Resource, slot = 4, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x3306 },
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
    ["Genji"] = { 
        ["GenjiShift"] = { Resource, slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["GenjiE"] = { Resource, slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["GenjiUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = false, id = 0x1510, extra_id = 0 },
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
    ["Tracer"] = { 
        ["TracerShift"] = { Resource, slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x2 },
        ["TracerE"] = { Resource, slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x1 },
        ["TracerUlt"] = { Resource, slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
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

-- Return -> x: Max / y: Current
function GetSkillCooldown(Player, Skill)
    -- [slot] 0: Passive, 1: SKILL_1(Shift), 2: SKILL_2(E), 3: SKILL_L, 4: SKILL_R, 5: SKILL_ULT
    -- [type] 1: .isUsing, 2: .flUltGauge, 3: .isBlocked, 4: GetCoolTime(), 5: .isUsing+GetCoolTime()
    
    local Skill_Cooldown = { x, y }
    local Skill_Status = -1

    --Skill_Cooldown.y = 3.5
    
    local Skill_NormalInfo = Player:GetSkill():GetSkillInfo(Skill.slot, 0)
    local Skill_CoolInfo = Player:GetSkill():GetSkillInfo(Skill.id, Skill.extra_id)

    if Skill.type == 1 then
        Skill_Status = Skill_NormalInfo.isUsing
        if Skill_Status == 1 then Skill_Cooldown = Skill_CoolInfo:GetCoolTime().x
        else Skill_Cooldown.y = Skill_CoolInfo:GetCoolTime().y end
    elseif Skill.type == 2 then
        Skill_Cooldown.y = Skill_NormalInfo.flUltGauge
    elseif Skill.type == 3 then
        Skill_Cooldown.x = 1
        Skill_Cooldown.y = Skill_NormalInfo.isBlocked
    elseif Skill.type == 4 then
        Skill_Cooldown.y = Skill_CoolInfo:GetCoolTime().y
        Skill_Cooldown.x = Skill_CoolInfo:GetCoolTime().x
    elseif Skill.type == 5 then
        Skill_Status = Skill_NormalInfo.isUsing
        if Skill_Status == 1 then
            if Skill.slot ~= 5 then
                Skill_Cooldown.x = Skill_CoolInfo:GetCoolTime().x
                Skill_Cooldown.y = Skill_CoolInfo:GetCoolTime().x
            else
                Skill_Cooldown.x = 0
                Skill_Cooldown.y = 0
            end
        else
            if Skill.slot ~= 5 then
                Skill_Cooldown.x = Skill_CoolInfo:GetCoolTime().x
                Skill_Cooldown.y = Skill_CoolInfo:GetCoolTime().y
            else
                Skill_Cooldown.x = 0
                Skill_Cooldown.y = Skill_NormalInfo.flUltGauge
            end
        end
    end
    
    return Skill_Cooldown
end


--[[
    Visual Class
--]]
local Visual = { 
    --[[ BoxESP ]]
    Box_Visible_Color = 0xFF00FF00, --Green
    Box_Hidden_Color = 0xFFFF0000, --Red
    Box_Outline_Color = 0xFF000000, --Black
    Box_Line_Thickness = 1,
    Box_Outline_Thickness = 1,

    --[[ Health ]]
    Health_Back_Color = 0xFF000000, --Black
    Health_Margin_Right = 3,
    Health_Main_Thickness = 4,
    Health_Back_Thickness = 6,

    --[[ Awareness ]]
    Awareness_Icon_Size = 36,
    Awareness_Icon_Margin = 7
}

function Visual:DrawESP(Player, Box_Type)
    local Mesh = Player:GetMesh()

    if not (Mesh) then return nil end
    if not (Player:GetIdentifier()) then return nil end

    local Bottom3D = Mesh:GetLocation()
    local Bottom2D = Math.XMFLOAT2(0, 0)

    if not (W2S(Bottom3D, Bottom2D)) then return nil end

    local Top3D = Mesh:GetBonePos(Player:GetBoneId((1))) --머리
    Top3D.y = Top3D.y + 0.25
    local Top2D = Math.XMFLOAT2(0, 0)

    if not (W2S(Top3D, Top2D)) then return nil end

    local Left3D = Mesh:GetBonePos(Player:GetBoneId((6))) --왼쪽 어깨
    local Right3D = Mesh:GetBonePos(Player:GetBoneId((9))) --오른쪽 어깨

    local Height3D = abs(Top3D.y - Bottom3D.y)
    local Height2D = abs(Top2D.y - Bottom2D.y)

    local Width3D = ((Left3D.x - Right3D.x)^2 + (Left3D.z - Right3D.z)^2)^0.5 * 2
    local Width2D = (Height2D * (Width3D / Height3D))
    
    local Box_Color = self.Box_Hidden_Color
    if Player:GetVisibility():IsVisible() then Box_Color = self.Box_Visible_Color end

    local PointLU = Math.XMFLOAT2(Bottom2D.x - (Width2D / 2), Top2D.y)
    local PointLD = Math.XMFLOAT2(Bottom2D.x - (Width2D / 2), Bottom2D.y)
    local PointRD = Math.XMFLOAT2(Bottom2D.x + (Width2D / 2), Bottom2D.y)

    if (Box_Type == 0) then --Default Box
        DrawShadowBox(PointLU.x, PointLU.y, Width2D, Height2D, Box_Color, self.Box_Outline_Color, self.Box_Line_Thickness, self.Box_Outline_Thickness)
    elseif (Box_Type == 1) then --Semi Box
        DrawShadowLine(PointLU, PointLD, Box_Color, self.Box_Outline_Color, self.Box_Line_Thickness, self.Box_Outline_Thickness)
        DrawShadowLine(PointLD, PointRD, Box_Color, self.Box_Outline_Color, self.Box_Line_Thickness, self.Box_Outline_Thickness)
    end
end

function Visual:DrawHealth(Player, HealthCurrent, HealthMax)
    local Mesh = Player:GetMesh()

    if not (Mesh) then return nil end
    if not (Player:GetIdentifier()) then return nil end

    local Bottom3D = Mesh:GetLocation()
    local Bottom2D = Math.XMFLOAT2(0, 0)

    if not (W2S(Bottom3D, Bottom2D)) then return nil end

    local Top3D = Mesh:GetBonePos(Player:GetBoneId((1))) --머리
    Top3D.y = Top3D.y + 0.25
    local Top2D = Math.XMFLOAT2(0, 0)

    if not (W2S(Top3D, Top2D)) then return nil end

    local Left3D = Mesh:GetBonePos(Player:GetBoneId((6))) --왼쪽 어깨
    local Right3D = Mesh:GetBonePos(Player:GetBoneId((9))) --오른쪽 어깨

    local Height3D = abs(Top3D.y - Bottom3D.y)
    local Height2D = abs(Top2D.y - Bottom2D.y)

    local Width3D = ((Left3D.x - Right3D.x)^2 + (Left3D.z - Right3D.z)^2)^0.5 * 2
    local Width2D = (Height2D * (Width3D / Height3D))
    
    local Box_Color = 0xFF01710F --Error

    if (HealthCurrent > 120) then Box_Color = 0xFF00FF00 --Green
    elseif (HealthCurrent > 60) then Box_Color = 0xFFFFFF00 --Yellow
    else Box_Color = 0xFFFF0000 end --Red

    local PointLU = Math.XMFLOAT2(Bottom2D.x - (Width2D / 2), Top2D.y)

    local Health_Main_Height = Height2D * (HealthCurrent / HealthMax)
    local Thickness_Diff = self.Health_Back_Thickness - self.Health_Main_Thickness
    local From2D = Math.XMFLOAT2(PointLU.x - self.Health_Margin_Right - self.Health_Back_Thickness, PointLU.y - Thickness_Diff / 2)
    local To2D = Math.XMFLOAT2(PointLU.x - self.Health_Margin_Right, PointLU.y + Thickness_Diff / 2 + Height2D)
    
    Game.Renderer:DrawBoxFilled(From2D, To2D, 0xFF000000, 0, 0)

    From2D.x = From2D.x + round(Thickness_Diff / 2)
    From2D.y = To2D.y - Health_Main_Height
    To2D.x = To2D.x - round(Thickness_Diff / 2)
    To2D.y = To2D.y - round(Thickness_Diff / 2)

    Game.Renderer:DrawBoxFilled(From2D, To2D, Box_Color, 0, 0)
end

function Visual:Awareness()
    local Count = Game.Engine:GetPlayerCount()
    local EnemyCount = 0

    for i = 0, Count - 1 do
        if (Game.Engine:GetPlayerAt(i):IsEnemy() and
            Game.Engine:GetPlayerAt(i):GetIdentifier() and
            Game.Engine:GetPlayerAt(i):GetMesh()) then
            EnemyCount = EnemyCount + 1
        end
    end

    local ScreenHeight = Game.Renderer:GetHeight()
    self.Awareness_Icon_Size = ScreenHeight / 40
    self.Awareness_Icon_Margin = self.Awareness_Icon_Size / 5
    local BoxWidth = (self.Awareness_Icon_Size + self.Awareness_Icon_Margin) * 6 + self.Awareness_Icon_Margin
    local BoxHeight = EnemyCount * (self.Awareness_Icon_Size + self.Awareness_Icon_Margin) + self.Awareness_Icon_Margin
    local FontSize = self.Awareness_Icon_Size * 0.6
    
    local BoxFrom2D = Math.XMFLOAT2(0, round(ScreenHeight / 2 - BoxHeight * 0.8) - 30)
    local BoxTo2D = Math.XMFLOAT2(BoxWidth, round(ScreenHeight / 2 + BoxHeight * 0.2))

    Game.Renderer:DrawBoxFilled(BoxFrom2D, BoxTo2D, 0x9A0000000, 0, 0)
    Game.Renderer:DrawText("UdyrAwareness", BoxFrom2D.x + BoxWidth / 2, BoxFrom2D.y + self.Awareness_Icon_Margin, FontSize, 0xFFFAFF60, true)

    BoxFrom2D.y = BoxFrom2D.y + 30

    EnemyCount = 0

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        if not (Player:IsEnemy()) then goto Continue end
        if not (Player:GetIdentifier()) then return nil end
        local HeroName = Player:GetIdentifier():GetHeroName()
        if (HeroName == nil) or (Heroname == "") then return nil end
        Game.Renderer:DrawResource(BoxFrom2D.x + self.Awareness_Icon_Margin, BoxFrom2D.y + self.Awareness_Icon_Margin + EnemyCount * (self.Awareness_Icon_Margin + self.Awareness_Icon_Size), self.Awareness_Icon_Size, self.Awareness_Icon_Size, HeroDatabase[HeroName].Resource)
        local XM2From = Math.XMFLOAT2(BoxFrom2D.x + self.Awareness_Icon_Margin, BoxFrom2D.y + self.Awareness_Icon_Margin + EnemyCount * (self.Awareness_Icon_Margin + self.Awareness_Icon_Size))
        local XM2To = Math.XMFLOAT2(XM2From.x + self.Awareness_Icon_Size, XM2From.y + self.Awareness_Icon_Size)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        if (Health and (HealthCurrent == 0)) then Game.Renderer:DrawBoxFilled(XM2From, XM2To, 0xA0C80000, 0, 0) end

        for Key in pairs(SkillDatabase[HeroName]) do
            --local Resource_SkillIcon = Game.Renderer:LoadResource("UdyrPack\\Images\\Icons\\Skills\\" .. Key .. ".png")
            Game.Renderer:DrawResource(BoxFrom2D.x + self.Awareness_Icon_Margin + (SkillDatabase[HeroName][Key].slot) * (self.Awareness_Icon_Size + self.Awareness_Icon_Margin), BoxFrom2D.y + self.Awareness_Icon_Margin + EnemyCount * (self.Awareness_Icon_Margin + self.Awareness_Icon_Size), self.Awareness_Icon_Size, self.Awareness_Icon_Size, SkillDatabase[HeroName][Key].Resource)
            local Cooldown = GetSkillCooldown(Player, SkillDatabase[HeroName][Key])
            --Game.Renderer:DrawText(Cooldown.y, 100 + (SkillDatabase[HeroName][Key].slot - 1) * 250, 100 + i * 30, 24, 0xff000000, false)
            local IconHeight = 0
            local ModifiedBoxFrom2D = Math.XMFLOAT2(0, 0)
            local ModifiedBoxTo2D = Math.XMFLOAT2(0, 0)

            if (Cooldown.y > 0.2) and (SkillDatabase[HeroName][Key].slot ~= 5) then
                IconHeight = self.Awareness_Icon_Size * (Cooldown.y / Cooldown.x)
                ModifiedBoxFrom2D = Math.XMFLOAT2(BoxFrom2D.x + self.Awareness_Icon_Margin + (SkillDatabase[HeroName][Key].slot) * (self.Awareness_Icon_Size + self.Awareness_Icon_Margin), BoxFrom2D.y + self.Awareness_Icon_Size - IconHeight + self.Awareness_Icon_Margin + EnemyCount * (self.Awareness_Icon_Margin + self.Awareness_Icon_Size))
                ModifiedBoxTo2D = Math.XMFLOAT2(ModifiedBoxFrom2D.x + self.Awareness_Icon_Size, ModifiedBoxFrom2D.y + IconHeight)
                Game.Renderer:DrawBoxFilled(ModifiedBoxFrom2D, ModifiedBoxTo2D, 0xA0EE8030, 0, 0)
                ModifiedBoxFrom2D.x = ModifiedBoxFrom2D.x + self.Awareness_Icon_Size / 2
                ModifiedBoxFrom2D.y = ModifiedBoxFrom2D.y + IconHeight - self.Awareness_Icon_Size + 6
                Game.Renderer:DrawText(round(Cooldown.y), ModifiedBoxFrom2D.x, ModifiedBoxFrom2D.y, FontSize + 3, 0xFF333333, true)
                ModifiedBoxFrom2D.y = ModifiedBoxFrom2D.y + 1
                Game.Renderer:DrawText(round(Cooldown.y), ModifiedBoxFrom2D.x, ModifiedBoxFrom2D.y, FontSize, 0xFFFFA0FF, true)
            elseif (SkillDatabase[HeroName][Key].slot == 5) and (GetUltPercent(HeroName, Cooldown.y) ~= "100") then
                local UltPercent = GetUltPercent(HeroName, Cooldown.y)
                IconHeight = self.Awareness_Icon_Size * (1 - UltPercent / 100)
                ModifiedBoxFrom2D = Math.XMFLOAT2(BoxFrom2D.x + self.Awareness_Icon_Margin + (SkillDatabase[HeroName][Key].slot) * (self.Awareness_Icon_Size + self.Awareness_Icon_Margin), BoxFrom2D.y + self.Awareness_Icon_Size - IconHeight + self.Awareness_Icon_Margin + EnemyCount * (self.Awareness_Icon_Margin + self.Awareness_Icon_Size))
                ModifiedBoxTo2D = Math.XMFLOAT2(ModifiedBoxFrom2D.x + self.Awareness_Icon_Size, ModifiedBoxFrom2D.y + IconHeight)
                Game.Renderer:DrawBoxFilled(ModifiedBoxFrom2D, ModifiedBoxTo2D, 0xA0EE8030, 0, 0)
                ModifiedBoxFrom2D.x = ModifiedBoxFrom2D.x + self.Awareness_Icon_Size / 2
                ModifiedBoxFrom2D.y = ModifiedBoxFrom2D.y + IconHeight - self.Awareness_Icon_Size + 6
                Game.Renderer:DrawText(UltPercent, ModifiedBoxFrom2D.x, ModifiedBoxFrom2D.y, FontSize + 3, 0xFF000000, true)
                ModifiedBoxFrom2D.y = ModifiedBoxFrom2D.y + 1
                Game.Renderer:DrawText(UltPercent, ModifiedBoxFrom2D.x, ModifiedBoxFrom2D.y, FontSize, 0xFFFF80FF, true)
            end
        end
        --Game.Renderer:DrawText(SkillCount, 200, 200 + i * 30, 24, 0xFFFF0000, false)

        EnemyCount = EnemyCount + 1
        --
        ::Continue::
    end
end


--[[
    Evade
--]]
local Evade = {}

function Evade:Draw()
    local Count = Game.Engine:GetProjectileCount()

    for i = 0, Count - 1 do
        local Projectile = Game.Engine:GetProjectileAt(i)
        local Info = Projectile:GetProjectileInfo()
        local Velocity = Info:GetVelocity()
        local Location3D = Info:GetLocation()
        local Location2D = Math.XMFLOAT2(0, 0)

        if not (W2S(Location3D, Location2D)) then goto Continue end

        local Owner = Projectile:GetOwner()

        Game.Renderer:DrawText(string.format("0x%X", Projectile:GetProjectileId()), Location2D.x, Location2D.y, 20, 0xFF00FF00, false)

        ::Continue::
    end
end

function OnDraw_Init()
    Game.Settings.settings_draw_fov = true
    Game.Settings.settings_esp_text = true
    Game.Settings.settings_esp_skeleton = false
    Game.Settings.settings_esp_skeleton_useraycast = false
    Game.Settings.settings_esp_highlight = true

    for Key in pairs(SkillDatabase) do
        for Key2 in pairs(SkillDatabase[Key]) do
            SkillDatabase[Key][Key2].Resource = Game.Renderer:LoadResource("UdyrPack\\Images\\Icons\\Skills\\" .. Key2 .. ".png")
        end
    end

    for Key in pairs(HeroDatabase) do
        HeroDatabase[Key].Resource = Game.Renderer:LoadResource("UdyrPack\\Images\\Icons\\Heroes\\" .. Key .. ".png")
    end

    OnDraw_Init_First = false
end

function Visuals()
    local Count = Game.Engine:GetPlayerCount()

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
            Visual:DrawESP(Player, 0) --BoxESP
            Visual:DrawHealth(Player, HealthCurrent, HealthMax)
        end
    end

    Visual:Awareness()
end

function OnUpdate()
    collectgarbage("collect")
end

function OnDraw()
    collectgarbage("collect")

    if (OnDraw_Init_First) then OnDraw_Init() end
    Visuals()
    --Evade:Draw()
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module