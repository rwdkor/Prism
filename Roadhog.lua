local Global_Fov = 15.0
local tmBasedSmth = 0.0
local Roadhog_First_Init = true

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
    return tonumber(number)
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
    ["Roadhog"] = { HeroID = 0x02E0000000000029, UltMax = 1680, NPC = false, Resource },
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
    ["Roadhog"] = { HeroID = 0x02E0000000000003, UltMax = 1260, NPC = false, Resource },
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

local InterruptableSkills = {
    ["Genji"] = {
        ["GenjiUlt"] = { slot = 5, casting_time = 1.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Hana"] = {
        ["HanaUlt"] = { slot = 5, casting_time = 2.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Hanzo"] = {
        ["HanzoUlt"] = { slot = 5, casting_time = 0.9, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Junkrat"] = {
        ["JunkratUlt"] = { slot = 5, casting_time = 1.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Lucio"] = {
        ["LucioUlt"] = { slot = 5, casting_time = 0.72, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["McCree"] = {
        ["McCreeUlt"] = { slot = 5, casting_time = 6.2, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Mei"] = {
        ["MeiUlt"] = { slot = 5, casting_time = 0.5, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Mercy"] = {
        ["MercyE"] = { slot = 2, casting_time = 1.75, id = 0x3D, extra_id = 0x5, last_value = 0, last_tick = 0 },
    },
    ["Moira"] = {
        ["MoiraUlt"] = { slot = 5, casting_time = 8.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Orisa"] = {
        ["OrisaUlt"] = { slot = 5, casting_time = 1.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Pharah"] = {
        ["PharahUlt"] = { slot = 5, casting_time = 2.5, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Reaper"] = {
        ["ReaperUlt"] = { slot = 5, casting_time = 3.0, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Reinhardt"] = {
        ["ReinhardtShift"] = { slot = 1, casting_time = 0.6, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
        ["ReinhardtE"] = { slot = 2, casting_time = 1.02, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
        ["ReinhardtUlt"] = { slot = 5, casting_time = 0.45, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Roadhog"] = {
        ["RoadhogUlt"] = { slot = 5, casting_time = 5.5, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Sigma"] = {
        ["SigmaE"] = { slot = 2, casting_time = 0.65, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
        ["SigmaUlt"] = { slot = 5, casting_time = 0.6, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Sombra"] = {
        ["SombraUlt"] = { slot = 5, casting_time = 0.35, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
    ["Torbjorn"] = {
        ["TorbjornUlt"] = { slot = 5, casting_time = 0.5, id = 0, extra_id = 0, last_value = 0, last_tick = 0 },
    },
}

-- Return -> true / false
function GetSkillUsing(Player, Skill)
    local Skill_NormalInfo = Player:GetSkill():GetSkillInfo(Skill.slot, 0)

    if Skill.slot == 5 then
        local UltCurrent = GetUltPercent(Player:GetIdentifier():GetHeroName(), Skill_NormalInfo.flUltGauge)
        
        if (Skill.last_value == "100") and (UltCurrent == "0") then
            Skill.last_value = UltCurrent
            Skill.last_tick = Game.Engine:GetTick()
            return true
        end
        if (Skill.last_tick + (Skill.casting_time * 1000) > Game.Engine:GetTick()) then
            Skill.last_value = UltCurrent
            return true
        else
            Skill.last_value = UltCurrent
            return false
        end
    else
        if Skill_NormalInfo.isUsing == 0 then return false end
        return true
    end
end

function GetUltPercent(HeroName, UltCurrent)
    if HeroDatabase[HeroName] ~= nil then return tonumber(round(UltCurrent / HeroDatabase[HeroName].UltMax * 100)) end
    return 0
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
    Roadhog
--]]
local Roadhog = { BestTarget = nil, BestFov, BestBone,
                MeleeAimbot = false, MeleeTarget = nil, MeleeAimbotSpeed = 0.025,
                GrabAimbot = false, GrabTarget = nil, GrabAimbotSpeed = 0.025,
                InterruptAimbot = false, InterruptTarget = nil, InterruptAimbotSpeed = 0.038 }

--[[
    Roadhog:TargetSelector
    Mode - 0: Closest, 1: LowestHP, 2: Priority, 3: ClosestAim, 4: Smart
--]]
function Roadhog:TargetSelector(Mode)
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    local Count = Game.Engine:GetPlayerCount()

    Roadhog.BestTarget = nil
    Roadhog.BestFov = Game.Engine:GetFov()
    Roadhog.BestBone = -1

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
            if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end

            if (Roadhog.BestTarget == nil) then
                local Found = Game.Engine:FindBestBone(Player, Roadhog.BestFov, 0x11, 1)

                if (Found.bFound) then
                    Roadhog.BestTarget = Player
                    Roadhog.BestFov = Found.lastFov
                    Roadhog.BestBone = Found.foundBone
                end
                goto Continue
            end

            if (Mode == 0) then --Closest
                if (dst(LocalPlayer:GetMesh():GetLocation(), Roadhog.BestTarget:GetMesh():GetLocation()) >=
                    dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())) then
                    Roadhog.BestTarget = Player
                end
            elseif (Mode == 1) then --LowestHP
                if (Roadhog.BestTarget:GetHealth():GetLife().y >= HealthCurrent) then
                    Roadhog.BestTarget = Player
                end
            elseif (Mode == 2) then --Priority
                --to-do
            elseif (Mode == 3) then --ClosestAim
                local LocalPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local Control = Game.Engine:GetController()
                if (CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Roadhog.BestTarget:GetMesh():GetBonePos(Roadhog.BestTarget:GetBoneId(1)))) >=
                    CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Player:GetMesh():GetBonePos(Player:GetBoneId(1))))) then
                    local Found = Game.Engine:FindBestBone(Player, Roadhog.BestFov, 0x11, 1)

                    if (Found.bFound) then
                        Roadhog.BestTarget = Player
                        Roadhog.BestFov = Found.lastFov
                        Roadhog.BestBone = Found.foundBone
                    end
                end
            elseif (Mode == 4) then --Smart
                local _Friends = Roadhog:NearFriends(Roadhog.BestTarget, true)
                local Friends = Roadhog:NearFriends(Player, true)
                local _Distance = dst(LocalPlayer:GetMesh():GetLocation(), Roadhog.BestTarget:GetMesh():GetLocation())
                local Distance = dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())
                local _HealthCurrent = Roadhog.BestTarget:GetHealth():GetLife().y

                local _Score = Roadhog:CalcTargetScore(_Friends, _Distance, _HealthCurrent)
                local Score = Roadhog:CalcTargetScore(Friends, Distance, HealthCurrent)

                if (_Score >= Score) then
                    Roadhog.BestTarget = Player
                end
            end
        end
        ::Continue::
    end
end

--[[
    Roadhog:CalcTargetScore
--]]
function Roadhog:CalcTargetScore(Friends, Distance, HealthCurrent)
    return Friends + Distance / 10 + HealthCurrent / 100
end

--[[
    Roadhog:NearFriends
    Enemy - True: Enemy, False: Team
--]]
function Roadhog:NearFriends(_Player, Enemy)
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
    Roadhog:UsingDragonblade
--]]
function Roadhog:NanoBoosted()
	return Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x34A, 0).isUsing
end

function Roadhog:GrabCooldownMax()
    return Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x3D, 0x3):GetCoolTime().x
end
    

function Roadhog:GrabCooldownCurrent()
    return Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x3D, 0x3):GetCoolTime().y
end
--[[
    Roadhog:Aimbot
--]]
function Roadhog:Aimbot(Speed, Fov_Free)
    if (Roadhog.InterruptAimbot) then
        local Mesh = Roadhog.InterruptTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local PredictPos = Roadhog:GrabPrediction(Roadhog.InterruptTarget)

                local AimSpeed = Roadhog.InterruptAimbotSpeed
                local Control = Game.Engine:GetController()
                local AngleDiff = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(PredictPos))

                if (AngleDiff >= 0.1) then AimSpeed = AngleDiff * 0.01 + AimSpeed
                else AimSpeed = AngleDiff * 0.5 + AimSpeed end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), CalcAngleFromLocalPosition(PredictPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
    elseif (Roadhog.GrabAimbot) then
        local Mesh = Roadhog.GrabTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local PredictPos = Roadhog:GrabPrediction(Roadhog.GrabTarget)

                local AimSpeed = Roadhog.GrabAimbotSpeed
                local Control = Game.Engine:GetController()
                local AngleDiff = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(PredictPos))

                if (AngleDiff >= 0.1) then AimSpeed = AngleDiff * 0.01 + AimSpeed
                else AimSpeed = AngleDiff * 0.5 + AimSpeed end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), CalcAngleFromLocalPosition(PredictPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
	elseif (Roadhog.MeleeAimbot) then
        local Mesh = Roadhog.MeleeTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local bonePos = Mesh:GetBonePos(0x11)

                local PredictPos = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 50, 0)

                local Diff = Math.XMFLOAT3(PredictPos.x - bonePos.x, PredictPos.y - bonePos.y, PredictPos.z - bonePos.z)

                PredictPos.y = bonePos.y + Diff.y - 0.35
                
                local AimSpeed = Roadhog.MeleeAimbotSpeed
                local Control = Game.Engine:GetController()
                local AngleDiff = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(PredictPos))

                if (AngleDiff >= 0.35) then AimSpeed = AngleDiff * 0.01 + AimSpeed end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), CalcAngleFromLocalPosition(PredictPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
    elseif (Game.Utils.IsKeyPressed(0x1) or Game.Utils.IsKeyPressed(0x2)) then
        if (Roadhog.BestBone ~= -1) then
            local Mesh = Roadhog.BestTarget:GetMesh()
            if (Mesh) then
                local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
                local bonePos = Mesh:GetBonePos(Roadhog.BestBone)

                local PredictPos = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 80, 0)

                local Diff = Math.XMFLOAT3(PredictPos.x - bonePos.x, PredictPos.y - bonePos.y, PredictPos.z - bonePos.z)
                local HeightMultiply = 0.2

                PredictPos.x = bonePos.x + Diff.x * 1.33
                PredictPos.y = bonePos.y + Diff.y * HeightMultiply - 0.15
                PredictPos.z = bonePos.z + Diff.z * 1.33
                
                local AimSpeed = Speed
                local Control = Game.Engine:GetController()
                local AngleDiff = dst(Control:GetAngle(), Math.NormalizeVec3(PredictPos - locPos))
                
                if (AngleDiff < Fov_Free + 0.2) and (AngleDiff >= Fov_Free) then AimSpeed = AngleDiff * 0.016 + AimSpeed end

                local dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(PredictPos - locPos), AimSpeed)
                Control:SetAngle(dstAngle)
            end
        end
    end
end

--[[
    Roadhog:AutoMelee
--]]
function Roadhog:AutoMelee()
    local Count = Game.Engine:GetPlayerCount()
    local LocalPlayer = Game.Engine:GetLocalPlayer()

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
		local HealthMax = Health:GetLife().x
		if (Roadhog:NanoBoosted()) then HealthCurrent = HealthCurrent * 0.75 end
        Roadhog.MeleeAimbot = false

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
			if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end

            local Distance = dst(Player:GetMesh():GetLocation(), LocalPlayer:GetMesh():GetLocation())

			if (Distance > 2.86) then goto Continue end

			local Fov_Enemy_Local = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Player:GetMesh():GetBonePos(0x11)))

			if (HealthCurrent > 25) then goto Continue end

			if (Fov_Enemy_Local > (0.6^Distance)*1.5) then
				Roadhog.MeleeAimbot = true
				Roadhog.MeleeTarget = Player
				Roadhog.MeleeAimbotSpeed = 0.025
				return
			else
				Roadhog.MeleeAimbot = true
				Roadhog.MeleeTarget = Player
				Roadhog.MeleeAimbotSpeed = 0.001
				Game.Engine:GetController():SetKeyCode(0x800)
				return
			end
            ::Continue::
        end
    end
end

--[[
    Roadhog:AutoGrab
--]]
function Roadhog:AutoGrab()
    local Count = Game.Engine:GetPlayerCount()
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    Roadhog.GrabAimbot = false

    if ((Roadhog:GrabCooldownCurrent() > 0.09) and (Roadhog:GrabCooldownMax() - Roadhog:GrabCooldownCurrent()) > 0.12) then
        do return end
    end
    
    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
		local HealthMax = Health:GetLife().x
        --Game.Engine:SetInputState(true)

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
			if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end
            
            if HealthCurrent > 250 then goto Continue end

            local Predicted = Roadhog:GrabPrediction(Player)

			local Distance = dst(Predicted, LocalPlayer:GetMesh():GetLocation()) --LocalPlayer:GetMesh():GetLocation())

			if (Distance > 6) then goto Continue end

			local Fov_Enemy_Local = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Predicted))

            if (Fov_Enemy_Local > (0.35 / Distance)) then
                --Game.Engine:SetInputState(false)
				Roadhog.GrabAimbot = true
				Roadhog.GrabTarget = Player
				Roadhog.GrabAimbotSpeed = 0.058
				do return end
            else
                --Game.Engine:SetInputState(false)
				Roadhog.GrabAimbot = true
				Roadhog.GrabTarget = Player
                Roadhog.GrabAimbotSpeed = 0.036
                
                if not (Roadhog:GrabCooldownCurrent() > 0.09) then
                    local Backup = Game.Engine:GetSensitivity()
                    Game.Engine:SetSensitivity(0.0)
                    Game.Engine:GetController():SetKeyCode(0x8)
                    sleep(0.16)
                    Game.Engine:SetSensitivity(Backup)
                end
				do return end
            end     
        end
        ::Continue::  
    end
end

--[[
    Roadhog:ManualGrab
--]]
function Roadhog:ManualGrab()
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    local Player = Roadhog.BestTarget

    if (Player == nil) or (Player:IsValid() == false) then do return end end

    local Health = Player:GetHealth()
    local HealthCurrent = Health:GetLife().y
    local HealthMax = Health:GetLife().x
    
    if ((Roadhog:GrabCooldownCurrent() > 0.09) and (Roadhog:GrabCooldownMax() - Roadhog:GrabCooldownCurrent()) > 0.12) then
        do return end
    end

    --check Alive
    if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
        if not (Game.Utils.IsKeyPressed(0x4)) then
            do return end
        end
        
        Roadhog.GrabAimbot = false

        --if not (Player:GetVisibility():IsVisible()) then return end
        if not (Player:GetIdentifier()) then do return end end
        
        local Predicted = Roadhog:GrabPrediction(Player)
        local Location = Player:GetMesh():GetLocation()
        local Diff = Math.XMFLOAT3(Predicted.x - Location.x, 0, Predicted.z - Location.z)
        
        local CameraLocation = Game.Engine:GetViewMatrix():GetCameraVec()
        local PredictedLocal = Math.XMFLOAT3(CameraLocation.x + Diff.x, CameraLocation.y, CameraLocation.z + Diff.z)
        --if not (Game.Engine:RayCast(PredictedLocal, Location, 0).hittedPlayer:IsValid()) then do return end end
        local Distance = dst(Predicted, LocalPlayer:GetMesh():GetBonePos(0x11))

        if (Distance > 20) then do return end end

        local Fov_Enemy_Local = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Predicted))

        if (Fov_Enemy_Local > (0.35 / Distance)) then
            Roadhog.GrabAimbot = true
            Roadhog.GrabTarget = Player
            Roadhog.GrabAimbotSpeed = 0.031
            do return end
        else
            Roadhog.GrabAimbot = true
            Roadhog.GrabTarget = Player
            Roadhog.GrabAimbotSpeed = 0.022
            if not (Roadhog:GrabCooldownCurrent() > 0.09) then Game.Engine:GetController():SetKeyCode(0x8) end
            do return end
        end
    end
end

--[[
	Roadhog:AutoHeal
--]]
function Roadhog:AutoHeal()
	local LocalPlayer = Game.Engine:GetLocalPlayer()
	local Health = LocalPlayer:GetHealth()
	local HealthCurrent = Health:GetLife().y

	if (Health) and (HealthCurrent < 300) then
        if (LocalPlayer:GetSkill():GetSkillInfo(0x3D, 0x1):GetCoolTime().y <= 0.01) then
            sleep(0.05)
            Game.Engine:GetController():SetKeyCode(0x10)
            --sleep(0.05)
			do return end
		end
	end
end

--[[
	Roadhog:GrabPrediction
--]]
function Roadhog:GrabPrediction(Player)
	local Mesh = Player:GetMesh()
	if (not Mesh) then do return end end
	
	local Health = Player:GetHealth()
	if (not Health or not (Health:GetLife().y > 0)) then do return end end
	
    local worldPos = Mesh:GetBonePos(0x11)
    worldPos.y = worldPos.y - 0.3
	local locPos = Game.Engine:GetLocalPlayer():GetMesh():GetLocation()
	local predicted = Math.Predict(locPos, worldPos, Mesh:GetVelocity(), 40, 0)

	return predicted
end

--[[
    Roadhog:InterruptSkill
--]]
function Roadhog:InterruptSkill()
    local Count = Game.Engine:GetPlayerCount()
    local LocalPlayer = Game.Engine:GetLocalPlayer()

    Roadhog.InterruptAimbot = false

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x
        
        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
            if (Roadhog:GrabCooldownCurrent() > 0.09) then do return end end
			if not (Player:GetVisibility():IsVisible()) then goto Continue end
            if not (Player:GetIdentifier()) then goto Continue end
            local Predicted = Roadhog:GrabPrediction(Player)
            local Distance = dst( Predicted, LocalPlayer:GetMesh():GetLocation())

            if (Distance > 20) then goto Continue end
            
            for Key in pairs(InterruptableSkills) do
                if Key == Player:GetIdentifier():GetHeroName() then
                    for Key2 in pairs(InterruptableSkills[Key]) do
                        if GetSkillUsing(Player, InterruptableSkills[Key][Key2]) then
                            local Fov_Enemy_Local = CalcFovFromLocalAngle(CalcAngleFromLocalPosition(Predicted))

                            if (Fov_Enemy_Local > (0.35 / Distance)) then
                                Roadhog.InterruptAimbot = true
                                Roadhog.InterruptTarget = Player
                                Roadhog.InterruptAimbotSpeed = 0.068
                                do return end
                            else
                                Roadhog.InterruptAimbot = true
                                Roadhog.InterruptTarget = Player
                                Roadhog.InterruptAimbotSpeed = 0.035

                                if not (Roadhog:GrabCooldownCurrent() > 0.09) then
                                    local Backup = Game.Engine:GetSensitivity()
                                    Game.Engine:SetSensitivity(0.0)
                                    Game.Engine:GetController():SetKeyCode(0x8)
                                    sleep(0.25)
                                    Game.Engine:SetSensitivity(Backup)
                                end
                                do return end
                            end
                        end
                    end
                end
            end
            ::Continue::
        end
    end
end

--[[
    Roadhog:GetPredictionTime
--]]
function Roadhog:GetPredictionTime(Player)
    local Predicted = Roadhog:GrabPrediction(Player)
    local Distance = dst(Predicted, Game.Engine:GetLocalPlayer():GetMesh():GetLocation())

    return Distance / 40
end


--[[
    Roadhog:OnUpdate
--]]
function Roadhog:OnUpdate()
	Roadhog:TargetSelector(3)

    if (Roadhog.BestTarget ~= nil) and (Roadhog.BestBone == -1) then
        local Found = Game.Engine:FindBestBone(Roadhog.BestTarget, Game.Engine:GetFov(), 0x11, 1)

        if (Found.bFound) then
            Roadhog.BestFov = Found.lastFov
            Roadhog.BestBone = Found.foundBone
        end
    end
end


function OnUpdate()
    collectgarbage("collect")
    Roadhog:OnUpdate()
    Roadhog:AutoHeal()
	Roadhog:AutoMelee()
    Roadhog:AutoGrab()
    Roadhog:ManualGrab()
    Roadhog:InterruptSkill()
    Roadhog:Aimbot(0.025, 0.006)
end

function OnDraw()
    collectgarbage("collect")
    if (Roadhog_First_Init) then
        Game.Engine:SetFov(Global_Fov)
        Roadhog_First_Init = false;
    end
    Roadhog:TargetSelector(3)
	--Roadhog:OnUpdate()

    local Pos2D = Math.XMFLOAT2(100, 100)
    if (Roadhog.BestTarget ~= nil) then
        if W2S(Roadhog.BestTarget:GetMesh():GetLocation(), Pos2D) then
            Game.Renderer:DrawText("BestTarget: " .. Roadhog.BestTarget:GetIdentifier():GetHeroName(), Pos2D.x, Pos2D.y, 25, 0xFF80FFCF, true)
        end
    end

	--Game.Renderer:DrawText(Roadhog:GrabCooldownMax(), 400, 100, 25, 0xFFFFFF00, false)
	--Game.Renderer:DrawText(Roadhog:GrabCooldownCurrent(), 400, 150, 25, 0xFFFFFF00, false)
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module