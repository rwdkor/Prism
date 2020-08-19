--[[
    Genji
--]]
local Genji = { BestTarget = nil, BestFov, BestBone }

--[[
    Genji:TargetSelector
    Mode - 0: Closest, 1: LowestHP, 2: Priority, 3: ClosestAim, 4: Smart
--]]
function Genji:TargetSelector(Mode)
    local LocalPlayer = Game.Engine:GetLocalPlayer()
    local Count = Game.Engine:GetPlayerCount()

    Genji.BestTarget = nil
    Genji.BestFov = Game.Engine:GetFov()
    Genji.BestBone = nil

    for i = 0, Count - 1 do
        local Player = Game.Engine:GetPlayerAt(i)
        local Health = Player:GetHealth()
        local HealthCurrent = Health:GetLife().y
        local HealthMax = Health:GetLife().x

        --check Alive
        if (Health and (HealthCurrent > 0) and Player:IsEnemy()) then
            if not (Player:GetVisibility():IsVisible()) then goto Continue end

            if (Genji.BestTarget == nil) then
                Genji.BestTarget = Player
                goto Continue
            end
            
            if (Mode == 0) then --Closest
                if (dst(LocalPlayer:GetMesh():GetLocation(), Genji.BestTarget:GetMesh():GetLocation()) >=
                    dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())) then
                    Genji.BestTarget = Player
                end
            elseif (Mode == 1) then --LowestHP
                if (Genji.BestTarget:GetHealth():GetLife().y >= HealthCurrent) then
                    Genji.BestTarget = Player
                end
            elseif (Mode == 2) then --Priority
                --to-do
            elseif (Mode == 3) then --ClosestAim
                local Found = Game.Engine:FindBestBone(Player, Genji.BestFov, 0x11, 1)
                        
                if (Found.bFound) then
                    Genji.BestFov = Found.lastFov
                    Genji.BestBone = Found.foundBone
                    Genji.BestTarget = Player
                end
            elseif (Mode == 4) then --Smart
                local _Friends = Genji:NearFriends(Genji.BestTarget, true)
                local Friends = Genji:NearFriends(Player, true)
                local _Distance = dst(LocalPlayer:GetMesh():GetLocation(), Genji.BestTarget:GetMesh():GetLocation())
                local Distance = dst(LocalPlayer:GetMesh():GetLocation(), Player:GetMesh():GetLocation())
                local _HealthCurrent = Genji.BestTarget:GetHealth():GetLife().y

                local _Score = Genji:CalcTargetScore(_Friends, _Distance, _HealthCurrent)
                local Score = Genji:CalcTargetScore(Friends, Distance, HealthCurrent)

                if (_Score >= Score) then
                    Genji.BestTarget = Player
                end
            end
        end
        ::Continue::
    end
end

--[[
    Genji:CalcTargetScore
--]]
function Genji:CalcTargetScore(Friends, Distance, HealthCurrent)
    return Friends + Distance / 10 + HealthCurrent / 100
end

--[[
    Genji:NearFriends
    Enemy - True: Enemy, False: Team
--]]
function Genji:NearFriends(_Player, Enemy)
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