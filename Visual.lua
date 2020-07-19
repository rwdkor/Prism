--heroid list
HERO_REAPER = 0x02E0000000000002
HERO_TRACER = 0x02E0000000000003
HERO_MERCY = 0x02E0000000000004
HERO_HANZO = 0x02E0000000000005
HERO_TORBJORN = 0x02E0000000000006
HERO_REINHARDT = 0x02E0000000000007
HERO_PHARAH = 0x02E0000000000008
HERO_WINSTON = 0x02E0000000000009
HERO_WIDOWMAKER = 0x02E000000000000A
HERO_BASTION = 0x02E0000000000015
HERO_SYMMETRA = 0x02E0000000000016
HERO_ZENYATTA = 0x02E0000000000020
HERO_GENJI = 0x02E0000000000029
HERO_ROADHOG = 0x02E0000000000040
HERO_MCCREE = 0x02E0000000000042
HERO_JUNKRAT = 0x02E0000000000065
HERO_ZARYA = 0x02E0000000000068
HERO_SOLDIER76 = 0x02E000000000006E
HERO_LUCIO = 0x02E0000000000079
HERO_DVA = 0x02E000000000007A
HERO_MEI = 0x02E00000000000DD
HERO_ANA = 0x02E000000000013B
HERO_SOMBRA = 0x02E000000000012E
HERO_ORISA = 0x02E000000000013E
HERO_DOOMFIST = 0x02E000000000012F
HERO_MOIRA = 0x02E00000000001A2
HERO_BRIGITTE = 0x02E0000000000195
HERO_WRECKINGBALL = 0x02E00000000001CA
HERO_ASHE = 0x02E0000000000200
HERO_ECHO = 0x02E0000000000206
HERO_BAPTISTE = 0x02E0000000000221
HERO_SIGMA = 0x02E000000000023B
HERO_TRAININGBOT1 = 0x02E000000000016B
HERO_TRAININGBOT2 = 0x02E000000000016C
HERO_TRAININGBOT3 = 0x02E000000000016D
HERO_TRAININGBOT4 = 0x02E000000000016E

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

function DrawBox(px, py, width, height, thickness, color)
    local point1 = Math.XMFLOAT2(px, py)
    local point2 = Math.XMFLOAT2(px + width, py)
    local point3 = Math.XMFLOAT2(px, py + height)
    local point4 = Math.XMFLOAT2(px + width, py + height)

    Game.Renderer:DrawLine(point1, point2, color, thickness)
    Game.Renderer:DrawLine(point1, point3, color, thickness)
    Game.Renderer:DrawLine(point2, point4, color, thickness)
    Game.Renderer:DrawLine(point3, point4, color, thickness)  
end

function GetSkillBoxColor(usable, bUlt)
    --if usable == 0 then return 0xffff0000 end
    if (usable == "0.0" or usable == 0) and bUlt == false then return 0xff00ff00 end
    if bUlt == true and usable == "100" then return 0xff00ff00 end
    return 0xffff0000
end

function GetUltPercent(heroid, value)
    local ultCooldownTable = {
        {0x02E000000000013B, 2100}, --Ana
        {0x02E0000000000200, 2240}, --Ashe
        {0x02E0000000000221, 2352}, --Baptiste
        {0x02E0000000000015, 2310}, --Bastion
        {0x02E0000000000195, 2800}, --Brigitte
        {0x02E000000000012F, 1680}, --Doomfist
        {0x02E000000000007A, 1540}, --D.Va
        {0x02E0000000000206, 1960}, --Echo
        {0x02E0000000000029, 1680}, --Gentji
        {0x02E0000000000005, 1680}, --Hanzo
        {0x02E0000000000065, 1925}, --Junkrat
        {0x02E0000000000079, 2940}, --Lucio
        {0x02E0000000000042, 1680}, --McCree
        {0x02E00000000000DD, 1610}, --Mei
        {0x02E0000000000004, 1820}, --Mercy
        {0x02E00000000001A2, 2380}, --Moira
        {0x02E000000000013E, 1680}, --Orisa
        {0x02E0000000000008, 2100}, --Pharah
        {0x02E0000000000002, 2100}, --Reaper
        {0x02E0000000000007, 1540}, --Reinhardt
        {0x02E0000000000040, 2240}, --Roadhog
        {0x02E000000000023B, 1960}, --Sigma
        {0x02E000000000006E, 2310}, --Soldier:76
        {0x02E000000000012E, 1400}, --Sombra
        {0x02E0000000000016, 1680}, --Symmetra
        {0x02E0000000000006, 2142}, --Torbjorn
        {0x02E0000000000003, 1260}, --Tracer
        {0x02E000000000000A, 1540}, --Widowmaker
        {0x02E0000000000009, 1540}, --Winston
        {0x02E00000000001CA, 1540}, --Wrecking Ball
        {0x02E0000000000068, 2100}, --Zarya
        {0x02E0000000000020, 2310}  --Zenyatta
    }

    for i=1, #ultCooldownTable do
        if heroid == ultCooldownTable[i][1] then
            return round(value / ultCooldownTable[i][2] * 100)
        end
    end

    return 0
end

-- slot_id -> Slot Number
-- Return -> -2: Hero not found, -1: Disabled, Other: Cooltime / Optional -> Ult: UltGuage
function GetSkillCooldown(player, slot_id)
    -- slot1, slot1type, slot2, slot2type, slot3, slot3type, slot4, slot4type,
    -- slottype - 1: isusing, 2: isusable, 3: isblocked, 4: isusing+isusable
    local skillCooldownTable = {
        {0x02E000000000013B, 1, 2,  2, 2,  0, 2,  5, 4}, --Ana
        {0x02E0000000000200, 1, 2,  2, 2,  0, 2,  5, 4}, --Ashe
        {0x02E0000000000221, 1, 2,  2, 2,  0, 2,  5, 4}, --Baptiste
        {0x02E0000000000015, 0, 2,  0, 2,  0, 2,  5, 4}, --Bastion
        {0x02E0000000000195, 1, 2,  2, 2,  0, 2,  5, 4}, --Brigitte
        {0x02E000000000012F, 1, 2,  2, 2,  4, 2,  5, 4}, --Doomfist
        {0x02E000000000007A, 1, 2,  2, 2,  0, 2,  5, 4}, --D.Va
        {0x02E0000000000206, 1, 2,  2, 2,  4, 2,  5, 4}, --Echo
        {0x02E0000000000029, 1, 2,  2, 2,  0, 2,  5, 4}, --Genji
        {0x02E0000000000005, 1, 2,  2, 2,  0, 2,  5, 4}, --Hanzo
        {0x02E0000000000065, 0, 2,  0, 2,  0, 2,  5, 4}, --Junkrat
        {0x02E0000000000079, 0, 2,  2, 2,  4, 2,  5, 4}, --Lucio
        {0x02E0000000000042, 1, 2,  2, 2,  0, 2,  5, 4}, --McCree
        {0x02E00000000000DD, 1, 2,  2, 2,  0, 2,  5, 4}, --Mei
        {0x02E0000000000004, 0, 2,  2, 2,  0, 2,  5, 4}, --Mercy
        {0x02E00000000001A2, 1, 2,  2, 2,  0, 2,  5, 4}, --Moira
        {0x02E000000000013E, 1, 2,  2, 2,  4, 2,  5, 4}, --Orisa
        {0x02E0000000000008, 1, 2,  2, 2,  0, 2,  5, 4}, --Pharah
        {0x02E0000000000002, 1, 2,  2, 2,  0, 2,  5, 4}, --Reaper
        {0x02E0000000000007, 1, 2,  2, 2,  0, 2,  5, 4}, --Reinhardt
        {0x02E0000000000040, 1, 2,  2, 2,  0, 2,  5, 4}, --Roadhog
        {0x02E000000000023B, 1, 2,  2, 2,  0, 2,  5, 4}, --Sigma
        {0x02E000000000006E, 0, 2,  2, 2,  4, 2,  5, 4}, --Soldier:76
        {0x02E000000000012E, 1, 2,  2, 2,  0, 2,  5, 4}, --Sombra
        {0x02E0000000000016, 1, 2,  2, 2,  0, 2,  5, 4}, --Symmetra
        {0x02E0000000000006, 1, 2,  2, 2,  0, 2,  5, 4}, --Torbjorn
        {0x02E0000000000003, 1, 4,  2, 2,  0, 2,  5, 4}, --Tracer
        {0x02E000000000000A, 1, 2,  2, 2,  0, 2,  5, 4}, --Widowmaker
        {0x02E0000000000009, 1, 2,  2, 2,  0, 2,  5, 4}, --Winston
        {0x02E00000000001CA, 0, 2,  2, 2,  4, 2,  5, 4}, --Wrecking Ball
        {0x02E0000000000068, 1, 4,  2, 4,  0, 2,  5, 4}, --Zarya
        {0x02E0000000000020, 0, 2,  0, 2,  0, 2,  5, 4}, --Zenyatta
    }

    -- shift, e, r
    local skillIDTable = {
        {0x02E000000000013B,  0x3D, 6,  0x3D, 4,  -1, -1,  -1, -1}, --Ana
        {0x02E0000000000200,  0x3D, 6,  0x3D, 3,  -1, -1,  -1, -1}, --Ashe
        {0x02E0000000000221,  0x3D, 5,  0x3D, 4,  -1, -1,  -1, -1}, --Baptiste
        {0x02E0000000000015,  -1, -1,  -1, -1,  -1, -1,  -1, -1}, --Bastion
        {0x02E0000000000195,  0x3D, 6,  0x3D, 7,  0x3306, 4,  -1, -1}, --Brigitte
        {0x02E000000000012F,  0x3D, 6,  0x3D, 8,  0x3D, 5,  -1, -1}, --Doomfist
        {0x02E000000000007A,  0x3D, 5,  0x3D, 9,  0x3D, 4,  -1, -1}, --D.Va
        {0x02E0000000000206,  0x3D, 4,  0x3D, 6,  0x3D, 7,  -1, -1}, --Echo
        {0x02E0000000000029,  0x3D, 6,  0x3D, 7,  -1, -1,  -1, -1}, --Genji
        {0x02E0000000000005,  0x3D, 4,  0x3D, 5,  -1, -1,  -1, -1}, --Hanzo
        {0x02E0000000000065,  0x3D, 6,  0x3D, 7,  -1, -1,  -1, -1}, --Junkrat
        {0x02E0000000000079,  -1, -1,  0x3D, 6,  0x3D, 9,  -1, -1}, --Lucio
        {0x02E0000000000042,  0x3D, 6,  0x3D, 7,  -1, -1,  -1, -1}, --McCree
        {0x02E00000000000DD,  0x3D, 4,  0x3D, -1,  -1, -1,  -1, -1}, --Mei
        {0x02E0000000000004, -1, -1,  -1, -1,  -1, -1,  -1, -1}, --Mercy
        {0x02E00000000001A2,  0x3D, 6,  0x3D, 4,  -1, -1,  -1, -1}, --Moira
        {0x02E000000000013E,  0x3D, 6,  0x3D, 4,  0x3D, 5,  -1, -1}, --Orisa
        {0x02E0000000000008,  0x3D, 2,  0x3D, 7,  -1, -1,  -1, -1}, --Pharah
        {0x02E0000000000002,  0x3D, 1,  0x3D, -1,  -1, -1,  -1, -1}, --Reaper
        {0x02E0000000000007,  0x3D, 2,  0x3D, 7,  -1, -1,  -1, -1}, --Reinhardt
        {0x02E0000000000040,  0x3D, 3,  0x3D, 7,  -1, -1,  -1, -1}, --Roadhog
        {0x02E000000000023B,  0x3D, 5,  0x3D, 6,  -1, -1,  -1, -1}, --Sigma
        {0x02E000000000006E,  -1, -1,  0x3D, 6,  0x3D, 10,  -1, -1}, --Soldier:76
        {0x02E000000000012E,  0x3D, 7,  0x3D, 6,  -1, -1,  -1, -1}, --Sombra
        {0x02E0000000000016,  0x3D, 5,  0x3D, -1,  -1, -1,  -1, -1}, --Symmetra
        {0x02E0000000000006, -1, -1,  -1, -1,  -1, -1,  -1, -1}, --Torbjorn
        {0x02E0000000000003,  0x3D, 2,  0x3D, 1,  -1, -1,  -1, -1}, --Tracer
        {0x02E000000000000A,  0x3D, 4,  0x3D, 3,  -1, -1,  -1, -1}, --Widowmaker
        {0x02E0000000000009,  0x3D, 6,  0x3D, 3,  -1, -1,  -1, -1}, --Winston
        {0x02E00000000001CA, -1, -1,  0x3D, 10, 0x3D, 7,  -1, -1}, --Wrecking Ball
        {0x02E0000000000068,  0x3D, 5,  0x3D, -1,  -1, -1,  -1, -1}, --Zarya
        {0x02E0000000000020, -1, -1,  -1, -1,  -1, -1,  -1, -1},  --Zenyatta
    }

    local heroid = player:GetIdentifier().HeroID
    local skill_cooldown = -2

    for i=1, #skillCooldownTable do
        if heroid == skillCooldownTable[i][1] then
            
            local slot_skill = skillCooldownTable[i][slot_id * 2]
            local slot_type = skillCooldownTable[i][slot_id * 2 + 1]

            if slot_skill ~= 0 then
                --if skillIDTable[i][slot_id * 2] == -1 then return -1 end

                local skill = player:GetSkill():GetSkillInfo(slot_skill, 0)
                --if heroid == 0x02E0000000000003 then Game.Renderer:DrawText(slot_skill .. " / " .. slot_type .. "", 15, 35, 15, 0xffffffff, false) end
                local skill_cool = player:GetSkill():GetSkillInfo(skillIDTable[i][slot_id * 2], skillIDTable[i][slot_id * 2 + 1])

                local skill_status = 0

                if slot_type == 1 then
                    skill_status = skill.isUsing
                    if skill_status == 1 then skill_cooldown = skill_cool:GetCoolTime().x
                    else skill_cooldown = skill_cool:GetCoolTime().y end
                elseif slot_type == 2 then
                    if slot_skill ~= 5 then skill_cooldown = skill_cool:GetCoolTime().y
                    else skill_cooldown = skill.flUltGauge end
                elseif slot_type == 3 then
                    skill_status = skill.isBlocked
                    skill_cooldown = 0
                elseif slot_type == 4 then
                    skill_status = skill.isUsing
                    if skill_status == 1 then
                        if slot_skill ~= 5 then skill_cooldown = skill_cool:GetCoolTime().x
                        else skill_cooldown = 0 end
                    else
                        if slot_skill ~= 5 then skill_cooldown = skill_cool:GetCoolTime().y
                        else skill_cooldown = skill.flUltGauge end
                    end
                end
            else
                skill_cooldown = -1
            end

            return skill_cooldown
        end
    end
    return -2
end

function Visuals()
    local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
        repeat
            local player = Game.Engine:GetPlayerAt(i)
            local health = player:GetHealth()
            local currenthealth = health:GetLife().y
            local maxhealth = health:GetLife().x

            --check Alive
            if (health and (currenthealth > 0)) then
                local Mesh = player:GetMesh()

                if not (Mesh) then
                    do break end
                end

                local bottom3D = Mesh:GetLocation()
                local bottom2D = Math.XMFLOAT2(0, 0)

                if not (Game.Engine:WorldToScreen(bottom3D, bottom2D)) then
                    do break end
                end

                local top3D = Mesh:GetBonePos(player:GetBoneId((1))) --head pos
                top3D.y = top3D.y + 0.2
                local top2D = Math.XMFLOAT2(0, 0)

                if not (Game.Engine:WorldToScreen(top3D, top2D)) then
                    do break end
                end

                local left3D = Mesh:GetBonePos(player:GetBoneId((6)))
                local right3D = Mesh:GetBonePos(player:GetBoneId((9)))

                local height3D = abs(top3D.y - bottom3D.y)
                local height2D = abs(top2D.y - bottom2D.y)

                local width3D = ((left3D.x - right3D.x)^2 + (left3D.z - right3D.z)^2)^0.5 * 2
                local width2D = (height2D * (width3D / height3D))

                local pointLU = Math.XMFLOAT2(bottom2D.x - (width2D / 2), top2D.y)

                if (true) then --player:IsEnemy()
                    
                    --[[ ESP ]]--
                    local box_width = 1;
                    local box_outline_width = 1;

                    --main box
                    local box_color = 0xffff0000
                    if Game.Engine:RayCast(Game.Engine:GetLocalPlayer():GetMesh():GetBonePos(0x11), Mesh:GetBonePos(player:GetBoneId(1))).hittedPlayer:IsValid() then
                        box_color = 0xff00ff00
                    end
                    DrawBox(pointLU.x, pointLU.y, width2D, height2D, box_width, box_color)

                    --box outline1
                    DrawBox(pointLU.x - box_width, pointLU.y - box_width, width2D + box_width * 2, height2D + box_width * 2, box_outline_width, 0xff000000)

                    --box outline2
                    DrawBox(pointLU.x + box_width, pointLU.y + box_width, width2D - box_width * 2, height2D - box_width * 2, box_outline_width, 0xff000000)
                   

                    --[[ Health ]]
                    local heightBar = height2D * (currenthealth / maxhealth)
                    local widthBar = 7
                    local leftBar = 4
                    local fromBar = Math.XMFLOAT2(pointLU.x - leftBar - widthBar, pointLU.y - 2)
                    local toBar = Math.XMFLOAT2(pointLU.x - leftBar, pointLU.y + 2 + height2D)
                    
                    --box background
                    Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xff000000, 0, 0)

                    toBar.x = toBar.x - 1
                    toBar.y = toBar.y - 1
                    fromBar.x = fromBar.x + 1
                    fromBar.y = toBar.y - heightBar

                    --box health
                    if (currenthealth > 120) then
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xff00ff00, 0, 0) --green
                    elseif (currenthealth > 60) then
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xffffff00, 0, 0) --yellow
                    else
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xffff0000, 0, 0) --red
                    end

                    
                    --[[ Tracker ]]
                    local heroid = player:GetIdentifier().HeroID
                    local skill = player:GetSkill()

                    local skill_1 = GetSkillCooldown(player, 1)
                    local skill_2 = GetSkillCooldown(player, 2)
                    local skill_3 = GetSkillCooldown(player, 3)
                    local skill_ult = GetSkillCooldown(player, 4)
                    
                    local skillbox_size = height2D / 5
                    if skillbox_size > 17 then skillbox_size = 17
                    elseif skillbox_size < 4 then skillbox_size = 0 end
                    local skillbox_margin_right = 4
                    local skillbox_margin_bottom = 2
                    local caption_margin = 2

                    if skillbox_size ~= 0 then
                        fromBar = Math.XMFLOAT2(bottom2D.x + (width2D / 2) + skillbox_margin_right, top2D.y)
                        toBar = Math.XMFLOAT2(fromBar.x + skillbox_size, fromBar.y + skillbox_size)
                        if skill_1 >= 0 then
                            Game.Renderer:DrawBoxFilled(fromBar, toBar, GetSkillBoxColor(string.format("%.1f", skill_1), false), 0, 0)
                            Game.Renderer:DrawText(string.format("%.1f", skill_1) .. "s", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        else
                            --Game.Renderer:DrawText("Error", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        end

                        fromBar.y = fromBar.y + skillbox_size + skillbox_margin_bottom
                        toBar.y = toBar.y + skillbox_size + skillbox_margin_bottom
                        if skill_2 >= 0 then
                            Game.Renderer:DrawBoxFilled(fromBar, toBar, GetSkillBoxColor(string.format("%.1f", skill_2), false), 0, 0)
                            Game.Renderer:DrawText(string.format("%.1f", skill_2) .. "s", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        else
                            --Game.Renderer:DrawText("Error", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        end

                        fromBar.y = fromBar.y + skillbox_size + skillbox_margin_bottom
                        toBar.y = toBar.y + skillbox_size + skillbox_margin_bottom
                        if skill_3 >= 0 then
                            Game.Renderer:DrawBoxFilled(fromBar, toBar, GetSkillBoxColor(string.format("%.1f", skill_3), false), 0, 0)
                            Game.Renderer:DrawText(string.format("%.1f", skill_3) .. "s", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        else
                            --Game.Renderer:DrawText("Error", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                        end

                        fromBar.y = fromBar.y + skillbox_size + skillbox_margin_bottom
                        toBar.y = toBar.y + skillbox_size + skillbox_margin_bottom
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, GetSkillBoxColor(GetUltPercent(heroid, skill_ult), true), 0, 0)
                        Game.Renderer:DrawText(GetUltPercent(heroid, skill_ult) .. "%", fromBar.x + skillbox_size + caption_margin, fromBar.y, skillbox_size, 0xffffffff, false)
                    end
                end
            end
            do break end
        until true
    end
end

function OnUpdate()
    collectgarbage("collect")
end

function OnDraw()
    collectgarbage("collect")
    Visuals()
end