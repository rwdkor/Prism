tmpSmooth = 0
baseSmooth = 0
AimKey = 0x4

function TriggerBot()
	if (LocalHero == "McCree" or LocalHero == "Widowmaker") then
		if (Game.Utils.IsKeyPressed(AimKey)) then
			local hitted = Game.Engine:LineOfSight()
			if (hitted.bHitted == true) then
				if (hitted.hittedPlayer:IsValid()) then
					if (hitted.hittedPlayer:IsEnemy()) then
						local Control = Game.Engine:GetController()
						Control:SetKeyCode(1)
						tmpSmooth = 0.0
					end
				end
			end
		end
	end
end
function TargetSelecter()
    Game.Engine:SetFov(10.0)
    local bestFov = Game.Engine:GetFov()
    bestBone = 0
    bestTarget = Player()

    local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
        local player = Game.Engine:GetPlayerAt(i)
        local Health = player:GetHealth()
        
        if (Health and (Health:GetLife().y > 0)) then
            local out = Math.XMFLOAT2(0, 0)
            local Mesh = player:GetMesh()
            if (Mesh) then
                local worldPos = Mesh:GetLocation()
    
                if (Game.Engine:WorldToScreen(worldPos, out)) then
                    if (player:IsEnemy()) then
                        local found = Game.Engine:FindBestBone(player, bestFov, 0x11)
                        
                        if (found.bFound) then
                            bestFov = found.lastFov
                            bestBone = found.foundBone
                            bestTarget = player
                        end
                    end
                end
            end
        end
    end
end

function Aimbot()
local Mesh
local locPos
local Control
local dstAngle

	if (LocalHero == "McCree" or LocalHero == "Widowmaker") then
		if (Game.Utils.IsKeyPressed(AimKey)) then
			if (bestBone > 0) then
				Mesh = bestTarget:GetMesh()
				if (Mesh) then
					locPos = Game.Engine:GetViewMatrix():GetCameraVec()
					bonePos = Mesh:GetBonePos(bestBone)					
					tmpSmooth = tmpSmooth + baseSmooth
					if (tmpSmooth > 1.0) then
						tmpSmooth = 1.0
					end
					Control = Game.Engine:GetController()
					dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(bonePos - locPos), tmpSmooth)
					Control:SetAngle(dstAngle)
				end
			end
		else tmpSmooth = 0.0
		end
	elseif (LocalHero == "Tracer") then
		if (Game.Utils.IsKeyPressed(0x1)) then --Only supports Left Key
			if (bestBone > 0) then
				Mesh = bestTarget:GetMesh()
				if (Mesh) then
					locPos = Game.Engine:GetViewMatrix():GetCameraVec()
					bonePos = Mesh:GetBonePos(bestBone)					
					tmpSmooth = tmpSmooth + baseSmooth
					if (tmpSmooth > 0.06) then
						tmpSmooth = 0.06
					end
					Control = Game.Engine:GetController()
					dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(bonePos - locPos), tmpSmooth)
					Control:SetAngle(dstAngle)
				end
			end
		else tmpSmooth = 0.0
		end
	elseif (LocalHero == "Hanzo") then
		if (Game.Utils.IsKeyPressed(AimKey)) then
			if (bestBone > 0) then
				Mesh = bestTarget:GetMesh()
				if (Mesh) then
					locPos = Game.Engine:GetViewMatrix():GetCameraVec()
					bonePos = Mesh:GetBonePos(bestBone)
					local predicted = Math.Predict(locPos, bonePos, Mesh:GetVelocity() / Math.XMFLOAT3(10, 10, 10), 110, 9.8)
					predicted.y = predicted.y + 0.1
					tmpSmooth = tmpSmooth + baseSmooth
					if (tmpSmooth > 1.0) then
						tmpSmooth = 1.0
					end
					Control = Game.Engine:GetController()
					dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(predicted - locPos), tmpSmooth)
					Control:SetAngle(dstAngle)
				end
			end
		else tmpSmooth = 0.0
		end
	elseif (LocalHero == "Zenyatta") then
		if (Game.Utils.IsKeyPressed(0x1)) then
			if (bestBone > 0) then
				Mesh = bestTarget:GetMesh()
				if (Mesh) then
					locPos = Game.Engine:GetViewMatrix():GetCameraVec()
					bonePos = Mesh:GetBonePos(bestBone)
					local predicted = Math.Predict(locPos, bonePos, Mesh:GetVelocity() / Math.XMFLOAT3(10, 10, 10), 80, 9.8)
					predicted.y = bonePos.y --predicted.y - 0.2 --
					Control = Game.Engine:GetController()
					dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(predicted - locPos), baseSmooth)
					Control:SetAngle(dstAngle)
				end
			end
		else tmpSmooth = 0.0
		end
	end
end


function OnUpdate()
    collectgarbage("collect")
	LocalHero = Game.Engine:GetLocalPlayer():GetIdentifier():GetHeroName()
	if (LocalHero == "McCree") then
		baseSmooth = 0.006
	elseif (LocalHero == "Widowmaker") then
		baseSmooth = 0.004
	elseif (LocalHero == "Hanzo") then
		baseSmooth = 0.008
	elseif (LocalHero == "Zenyatta") then
		baseSmooth = 0.06
	elseif (LocalHero == "Tracer") then
		baseSmooth = 0.001
	end
    TargetSelecter()
    Aimbot()
	TriggerBot()
end

function OnDraw()
    collectgarbage("collect")
	LocalHero = Game.Engine:GetLocalPlayer():GetIdentifier():GetHeroName()
    Game.Renderer:DrawText("Udyr - Wino Script", 10, 20, 16, 0xFFFFFFFF, false)
	Game.Renderer:DrawText(LocalHero, 10, 40, 16, 0xFFFFFFFF, false)
end