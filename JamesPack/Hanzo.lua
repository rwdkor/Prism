---------------------------------------------------------------------------------
---------------------------------User Set----------------------------------------

--[[ Aimbot Settings ]]--

fov = 30
cv1 = 0.525 cv2 = 0.475 cv3 = 0.465 cv4 = 0.535
sp1 = 0.00305 sp2 = 0.00295 sp3 = 0.00285 sp4 = 0.00305
headchance = 100 -- % or body
misschance = 0 -- %

aimbot1=0x6 -- chance aimbot
aimbot2=0x5 -- head aimbot

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end
function curve(xv, yv, zv) local reductor = {__index = function(self, ind) return setmetatable({tree = self, level = ind}, {__index = function(curves, ind)
return function(t) local x1, y1, z1 = curves.tree[curves.level-1][ind](t) local x2, y2, z2 = curves.tree[curves.level-1][ind+1](t) 
return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t,  z1 + (z2 - z1) * t end end}) end } local points = {} 
for i = 1, #xv do points[i] = function(t) return xv[i], yv[i], zv[i] end end return setmetatable({points}, reductor)[#points][1] end

function abas(p)
	local s = p:GetSkill()
	local Id = p:GetIdentifier()
	if (s and Id) then
        if (Id.HeroID == 0x02E000000000012E) then --SOMBRA
            local si = s:GetSkillInfo(1, 0) -- Hiding
            if (si and si.isUsing ~= 0) then
                return false
            end
        elseif (Id.HeroID == 0x02E0000000000029) then --GENJI
            local si = s:GetSkillInfo(2, 0) -- Deflect
            if (si and si.isUsing ~= 0) then
                return false
            end
            local si = s:GetSkillInfo(1, 0) -- Dash
            if (si and si.isUsing ~= 0) then
                return false
            end
		elseif (Id.HeroID == 0x02E0000000000003) then --TRACER
            local si = s:GetSkillInfo(1, 0) -- Flash
            if (si and si.isUsing ~= 0) then
                return false
            end
            local si = s:GetSkillInfo(2, 0) -- Recall
            if (si and si.isUsing ~= 0) then
                return false
            end						
		elseif (Id.HeroID == 0x02E0000000000020) then --ZENYATTA
            local si = s:GetSkillInfo(0xD7, 5) -- Transcendence
            if (si and si.isUsing ~= 0) then
                return false
            end			
        end		
    end
    return true
end



b1 = 0.0 b2 = 0.0 b3 = 0.0 b4 = 0.0
bflick = false
function ab()
   if ((Game.Utils.IsKeyPressed(aimbot1)) or (Game.Utils.IsKeyPressed(aimbot2))) then 
		local ctr = Game.Engine:GetController()
		ts() if (bestBone > 0) and (bflick == false) then
        local m = bestTarget:GetMesh() if (m) then
			local s = Game.Engine:GetLocalPlayer():GetSkill()
			local ChargeSkillInfo = s:GetSkillInfo(0x2A5, 0xA)
				if (ChargeSkillInfo) then 
					bflick = true
					local lp = Game.Engine:GetViewMatrix():GetCameraVec()
					cv1_lp = Game.Engine:GetViewMatrix():GetCameraVec()
					local bp = m:GetBonePos(bestBone)
					local xmEnem1,xmEnem2,xmEnem3,xmEnem4 = Math.XMFLOAT3(0,0,0)
					for i=10,1,-1 do b1 = b1 + (0.01 * i / 20) if b1 > 1.0 then b1 = 1.0 end
					if not abas(bestTarget) then goto exit end
					lp = Game.Engine:GetViewMatrix():GetCameraVec()
					bp = m:GetBonePos(bestBone)
					flCharge = 25.0 + 85.0 * ChargeSkillInfo:GetCoolTime().y
					pp = Math.Predict(lp, bp, m:GetVelocity(), flCharge, 9.8)
					local bez = curve({pp.x, lp.x},{pp.y, lp.y},{lp.z, pp.z})
					x1, y1, z1 = bez(cv1) xmEnem1 = Math.XMFLOAT3(x1+(0.1*math.random(-3,3)),y1+(0.1*math.random(-8,8)),z1+(0.1*math.random(-3,3)))
					local cAng = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(xmEnem1 - lp), b1)
					ctr:SetAngle(cAng) sleep(sp1)
					end
					for i=10,1,-1 do b2 = b2 + (0.01 * i / 10) if b2 > 1.0 then b2 = 1.0 end
					if not abas(bestTarget) then goto exit end
					lp = Game.Engine:GetViewMatrix():GetCameraVec()
					bp = m:GetBonePos(bestBone)
					flCharge = 25.0 + 85.0 * ChargeSkillInfo:GetCoolTime().y
					pp = Math.Predict(lp, bp, m:GetVelocity(), flCharge, 9.8)
					local bez2 = curve({pp.x, x1},{y1, pp.y},{z1, pp.z})
					x2, y2, z2 = bez2(cv2) xmEnem2 = Math.XMFLOAT3(x2+(0.1*math.random(-2,2)),y2+(0.1*math.random(-4,4)),z2+(0.1*math.random(-1,1)))
					local cAng = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(xmEnem2 - lp), b2)
					ctr:SetAngle(cAng) sleep(sp2)
					end			
					for i=10,1,-1 do b3 = b3 + (0.01 * i / 10) if b3 > 1.0 then b3 = 1.0 end
					if not abas(bestTarget) then goto exit end
					lp = Game.Engine:GetViewMatrix():GetCameraVec()
					bp = m:GetBonePos(bestBone)
					flCharge = 25.0 + 85.0 * ChargeSkillInfo:GetCoolTime().y
					pp = Math.Predict(lp, bp, m:GetVelocity(), flCharge, 9.8)
					local bez3 = curve({pp.x, x2},{y2, pp.y},{z2, pp.z})
					x3, y3, z3 = bez3(cv3) xmEnem3 = Math.XMFLOAT3(x3+(0.1*math.random(-1,1)),y3+(0.1*math.random(-2,2)),z3+(0.1*math.random(-1,1)))
					local cAng = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(xmEnem3 - lp), b3)
					ctr:SetAngle(cAng) sleep(sp3)				
					end
					miss = math.random(0,100) if (Game.Utils.IsKeyPressed(aimbot2)) then miss = 100 end if miss <= misschance then ctr:SetKeyCode(1) goto exit end	
					for i=1,10,1 do b4 = b4 + (0.01 * i) if b4 > 1.0 then b4 = 1.0 end	
					if not abas(bestTarget) then goto exit end
					lp = Game.Engine:GetViewMatrix():GetCameraVec()
					bp = m:GetBonePos(bestBone)
					flCharge = 25.0 + 85.0 * ChargeSkillInfo:GetCoolTime().y
					pp = Math.Predict(lp, bp, m:GetVelocity(), flCharge, 9.8)
					local bez4 = curve({pp.x, x3},{y3, pp.y},{z3, pp.z})
					x4, y4, z4 = bez4(cv4) xmEnem4 = Math.XMFLOAT3(x4,y4,z4)
					local cAng = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(xmEnem4 - lp), b4)
					ctr:SetAngle(cAng) sleep((sp4-(0.1*(sp4/i))))
					end
					::exit::
				end 
			end 
		end
	else
		b1 = 0.0
		b2 = 0.0
		b3 = 0.0
		b4 = 0.0
		bflick = false
	end
end

function ts()
	Game.Engine:SetFov(fov)
    local bestFov=Game.Engine:GetFov() bestBone=0 bestTarget=Player()
    local c=Game.Engine:GetPlayerCount()
    for i=0,c-1 do local p=Game.Engine:GetPlayerAt(i) local h=p:GetHealth()
    if (h and (h:GetLife().y>0)) then local o=Math.XMFLOAT2(0,0) local m=p:GetMesh()
    if (m) then local w=m:GetLocation()
    if (Game.Engine:WorldToScreen(w,o)) then
    if (p:IsEnemy()) then 
	local f local crit = math.random(0,100)
	if (Game.Utils.IsKeyPressed(aimbot2)) then crit = 0 end
	if crit <= headchance then f=Game.Engine:FindBestBone(p,bestFov,p:GetBoneId(1),1) else f=Game.Engine:FindBestBone(p,bestFov,p:GetBoneId(3),1) end
	if (abas(p)) then if (f.bFound) then bestFov=f.lastFov bestBone=f.foundBone bestTarget=p
	end end	end end end end end
end

function OnUpdate()
    collectgarbage("collect")
	ab()
end

function OnDraw()
    collectgarbage("collect")
    Game.Renderer:DrawText("Curved Hanzo", 10, 20, 15, 0xFF8B4010, false)
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module