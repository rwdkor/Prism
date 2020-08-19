tmpSmooth = 0
baseSmooth = 0
AimKey = 0x1

function dst(xm1,xm2) return math.sqrt( (xm2.x-xm1.x)^2+(xm2.y-xm1.y)^2+(xm2.z-xm1.z)^2) end 

function TargetSelecter()
    local bestFov = Game.Engine:GetFov()
    bestBone = 0
    bestTarget = Player()
	local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
		(function()
			local player = Game.Engine:GetPlayerAt(i)
			if not (player:IsEnemy()) then
				return
			end
			
		
			local Health = player:GetHealth()
			if (not Health or not (Health:GetLife().y > 0)) then
				return
			end
			
			if (isheal) then
				if ((Health:GetLife().x <= Health:GetLife().y)) then
					return
				end
			end
		
			local out = Math.XMFLOAT2(0, 0)
			local Mesh = player:GetMesh()
			if (not Mesh) then
				return
			end
			
			local worldPos = Mesh:GetLocation()
			if (not Game.Engine:WorldToScreen(worldPos, out)) then
				return
			end
			
			local found = Game.Engine:FindBestBone(player, bestFov, player:GetBoneId(2), 1)
			-- head 0x11
				
			if (found.bFound) then
				bestFov = found.lastFov
				bestBone = found.foundBone
				bestTarget = player
			end
		end)()
    end
end

function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end

function Aimbot()
	local Mesh
	local locPos
	local Control
	local dstAngle

	if (Game.Utils.IsKeyPressed(0x1)) then --Only supports Left Key
		if (bestBone > 0) then
			Mesh = bestTarget:GetMesh()
			if (Mesh) then
				locPos = Game.Engine:GetViewMatrix():GetCameraVec()
				bonePos = Mesh:GetBonePos(bestBone)					
				
				local predicted = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 160, 0)
				predicted.y = bonePos.y + (predicted.y - bonePos.y ) * 0.3
				Control = Game.Engine:GetController()
				dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(predicted - locPos), 0.02)
				Control:SetAngle(dstAngle)
				--sleep(0.001)
			end
		end
	elseif (Game.Utils.IsKeyPressed(0x2)) then --right Key
		if (bestBone > 0) then
			Mesh = bestTarget:GetMesh()
			if (Mesh) then
				locPos = Game.Engine:GetViewMatrix():GetCameraVec()
				bonePos = Mesh:GetBonePos(bestBone)					
				
				local predicted = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 115, 0)
				predicted.y = bonePos.y + (predicted.y - bonePos.y ) * 0.3
				Control = Game.Engine:GetController()
				dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(predicted - locPos), 0.02)
				Control:SetAngle(dstAngle)
				--sleep(0.001)
			end
		end
	end
end

function OnUpdate()
	Game.Engine:SetFov(4)
    collectgarbage("collect")
    TargetSelecter()
	Aimbot()
	
end

function OnDraw()
    collectgarbage("collect")
    Game.Renderer:DrawText("UdyrPack - Zarya", 10, 20, 22, 0xFFFFFFFF, false)
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module