speed = 0.005
Fov = 13.0
isheal = false

function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end

function IsValidTarget(player)
    local Skill = player:GetSkill()
    local Identifier = player:GetIdentifier()
    if (Skill and Identifier) then
        if (Identifier.HeroID == 0x02E000000000012E) then --SOMBRA
            local SkillInfo = Skill:GetSkillInfo(1, 0)
            if (SkillInfo and SkillInfo.isUsing ~= 0) then
                return false
            end
        elseif (Identifier.HeroID == 0x02E0000000000029) then --GENJI
            local SkillInfo = Skill:GetSkillInfo(2, 0)
            if (SkillInfo and SkillInfo.isUsing ~= 0) then
                return false
            end
        end
    end

    return true
end


function TargetSelecter()
    Game.Engine:SetFov(Fov)
    local bestFov = Game.Engine:GetFov()
    bestBone = 0
    bestTarget = Player()
	local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
		(function()
			local player = Game.Engine:GetPlayerAt(i)
			if (isheal == player:IsEnemy()) then
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
				
			if (found.bFound and IsValidTarget(player)) then
				bestFov = found.lastFov
				bestBone = found.foundBone
				bestTarget = player
			end
		end)()
    end
end

function Aimbot()
	if (not bestBone) then
		smooth = 0.0
		return
	end
	
	local Mesh = bestTarget:GetMesh()
	if (not Mesh) then
		smooth = 0.0
		return
	end

	smooth = smooth + speed
	if (smooth > 0.15) then
		smooth = 0.15
	end

	local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
	local bonePos = Mesh:GetBonePos(bestBone)
	local Control = Game.Engine:GetController()
	local dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(bonePos - locPos), smooth)
	Control:SetAngle(dstAngle)
end

function TriggerBot()
	
	local hitted = Game.Engine:LineOfSight(1).hittedPlayer
	if (not hitted:IsValid()) then
		return
	end
	
	if (isheal == hitted:IsEnemy()) then
		return
	end
	
	local Health = hitted:GetHealth()
	if (not Health or not (Health:GetLife().y > 0)) then
		return
	end
	
	if (isheal) then
		if (not (Health:GetLife().x > Health:GetLife().y)) then
			return
		end
	end
	
	local Control = Game.Engine:GetController()
	Control:SetKeyCode(1)
	last_shot = Game.Engine:GetTick()
	canfire = false
end

function heal_esp()
    Game.Engine:SetFov(Fov)
    local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
		(function()
			local player = Game.Engine:GetPlayerAt(i)		
			if (player:IsEnemy()) then
			--	return
			end
		
			local Health = player:GetHealth()
			if (not Health or not (Health:GetLife().y > 0)) then
				return
			end
			
			local out = Math.XMFLOAT2(0, 0)
			local Mesh = player:GetMesh()
			if (not Mesh) then
				return
			end
			
			local worldPos = Mesh:GetBonePos(0x11)--Mesh:GetLocation()
			worldPos.y = worldPos.y + 0.5
			if (not Game.Engine:WorldToScreen(worldPos, out)) then
				return
			end
			
			Game.Renderer:DrawText(tostring(math.floor(Health:GetLife().y)), out.x, out.y, 18, 0xFFFFFFFF, true)
		end)()
    end
end

function sleep_esp()
	local player = bestTarget
	local Mesh = player:GetMesh()
	if (not Mesh) then
		return
	end
	
	local Health = player:GetHealth()
	if (not Health or not (Health:GetLife().y > 0)) then
		return
	end
	
	local worldPos = Mesh:GetBonePos(0x11)--Mesh:GetLocation()
	local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
	local predicted = Math.Predict(locPos, worldPos, Mesh:GetVelocity(), 60, 0)
	
	local out = Math.XMFLOAT2(0, 0)
	if (not Game.Engine:WorldToScreen(predicted, out)) then
		return
	end
	
	--Game.Renderer:DrawCircleFilled(out.x, out.y, 3, 0xFF008000)
	local rr = Game.Engine:RayCast(locPos, predicted, 1)
	if not (rr and rr.hittedPlayer:IsValid()) then
		Game.Renderer:DrawCircleFilled(out.x, out.y, 3, 0xFF008000)
	else
		Game.Renderer:DrawCircleFilled(out.x, out.y, 3, 0xFFFF0000)
	end
end

function skill_as()
	if (not Game.Utils.IsKeyPressed(0xA0)) then -- VK_LSHIFT
		return
	end
	
	local cool = Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x3D, 6):GetCoolTime()
	if (cool.x > 0) then
		return
	end
	
	sleep(0.2)

	local player = bestTarget
	local Mesh = player:GetMesh()
	if (not Mesh) then
		return
	end
	
	local Health = player:GetHealth()
	if (not Health or not (Health:GetLife().y > 0)) then
		return
	end
	
	local Control = Game.Engine:GetController()
	local locPos = Game.Engine:GetViewMatrix():GetCameraVec()
	local bonePos = Mesh:GetBonePos(player:GetBoneId(2))
	local predicted = Math.Predict(locPos, bonePos, Mesh:GetVelocity(), 60, 0)
	for i = 0, 5 do
        local dstAngle = Math.LerpVec3(Control:GetAngle(), Math.NormalizeVec3(predicted - locPos), 0.2*i)    
        Control:SetAngle(dstAngle)
        sleep(0.001)
    end
end


function OnUpdate()
    collectgarbage("collect")
	
	TargetSelecter()
	if (Game.Utils.IsKeyPressed(0x5) or Game.Utils.IsKeyPressed(0x4)) then
		isheal = Game.Utils.IsKeyPressed(0x5)
		local Skill = Game.Engine:GetLocalPlayer():GetSkill()
		local cool = Skill:GetSkillInfo(0xAD, 9):GetCoolTime()
		if ((cool.x - 0.1) <= 0.0) then 
			Aimbot()
			TriggerBot()
		else
			smooth = 0.0
		end
	else
		smooth = 0.0
	end
	
	skill_as()
end

function OnDraw()
    collectgarbage("collect")
	TargetSelecter()
	sleep_esp()
	
	local Skill = Game.Engine:GetLocalPlayer():GetSkill()
	local cool = Skill:GetSkillInfo(0xAD, 9):GetCoolTime()
	Game.Renderer:DrawText(cool.x .. ", " .. cool.y, 10, 10, 16, 0xffffffff, false)
	cool = Skill:GetSkillInfo(0x3D, 4):GetCoolTime()
	Game.Renderer:DrawText(cool.x .. ", " .. cool.y, 10, 26, 16, 0xffffffff, false)
	cool = Game.Engine:GetLocalPlayer():GetSkill():GetSkillInfo(0x3D, 6):GetCoolTime()
	Game.Renderer:DrawText(cool.x .. ", " .. cool.y, 10, 42, 16, 0xffffffff, false)
	
	heal_esp()
	
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module