fov = 20
Lsm = 0.03
Rsm = 0.07
manual_dash = 0x12 -- VK_SHIFT

function sleep (a) local s=tonumber(os.clock()+a)while(os.clock()<s)do end end
function dst(xm1,xm2) return math.sqrt( (xm2.x-xm1.x)^2+(xm2.y-xm1.y)^2+(xm2.z-xm1.z)^2) end 

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
function md()
	local ctr=Game.Engine:GetController()
	local cnt=Game.Engine:GetPlayerCount()
	if (Game.Utils.IsKeyPressed(manual_dash)) then	
		nts(15,true)
		if (nearestEnemy:IsValid()) then	
            local m = nearestEnemy:GetMesh()
			if (m) then
				local s=Game.Engine:GetLocalPlayer():GetSkill() 
				local inf=s:GetSkillInfo(0x3D,6)
				if (inf) then local dc=inf:GetCoolTime()
					if dc.x==0 then 
						local h=nearestEnemy:GetHealth()
						local lp=Game.Engine:GetViewMatrix():GetCameraVec() 
						local bp=m:GetBonePos(nearestEnemy:GetBoneId(1))
						local dst=dst(lp,bp)
						if (dst <= 15.0) then 
							if (h and h:GetLife().y > 0) then
								for bonenum=1,17,1 do
									local rcbp = m:GetBonePos(nearestEnemy:GetBoneId(bonenum))
									local rr=Game.Engine:RayCast(lp,rcbp,1)
									if not ((rr.bHitted) and (rr.hittedPlayer:IsValid())) then
										return
									end
								end
								
								for i=0,10,1 do
									local lp = Game.Engine:GetViewMatrix():GetCameraVec()
									local bp=m:GetBonePos(nearestEnemy:GetBoneId(14))
									local pp=Math.Predict(lp,bp,m:GetVelocity(),200,0.0)
									local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
									ctr:SetAngle(dstAg)
									sleep(0.008)
								end
								ctr:SetKeyCode(0x8)
								sleep(0.1) --[[ Anti-Dash Abuse --]]
							end
						end 
					end 
				end 
			end
		end
	end
end
function ade()
	local c = Game.Engine:GetPlayerCount()
	for i=0,c-1 do 
		local p = Game.Engine:GetPlayerAt(i)
		if p:IsEnemy() then
			local h=p:GetHealth()
			if (h and (h:GetLife().y > 0))then
				local m = p:GetMesh()
				if (m) then
					local ll = Game.Engine:GetLocalPlayer():GetMesh():GetBonePos(Game.Engine:GetLocalPlayer():GetBoneId(2))
					local ls = Game.Engine:GetLocalPlayer():GetSkill()
					local el = m:GetBonePos(p:GetBoneId(2))
					local es = p:GetSkill()
					local eId = p:GetIdentifier()

					local out = Math.XMFLOAT2(0,0)
					if (Game.Engine:WorldToScreen(el, out)) then					
						local de = ls:GetSkillInfo(0x3D, 7)
						if (de and de:GetCoolTime().x == 0.0) then
							if (dst(ll,el) <= 15.0) then
								local rr = Game.Engine:RayCast(ll, ls)
								if not ((rr.bHitted) and (rr.hittedPlayer:IsValid())) then
									return
								end
								if (eId.HeroID == 0x02E000000000013B) then --ANA
									local si = es:GetSkillInfo(0x31, 6)
									if ((si) and (si.isUsing > 0)) then						
										local ctr = Game.Engine:GetController()
										ctr:SetKeyCode(0x10)
										Game.Engine:SetMouseBlock(true)
										for i=0,10,1 do
											local lp = Game.Engine:GetViewMatrix():GetCameraVec()
											local el = m:GetBonePos(p:GetBoneId(2))
											local pp=Math.Predict(lp,el,m:GetVelocity(),55,0.0)
											local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
											ctr:SetAngle(dstAg)
											sleep(0.006)
										end												
										Game.Engine:SetMouseBlock(false)
									end
								end
								if (eId.HeroID == 0x02E0000000000042) then --MCCREE
									local si = es:GetSkillInfo(0x28E9, 0)
									if ((si) and (si.isUsing > 0)) then						
										local ctr = Game.Engine:GetController()
										ctr:SetKeyCode(0x10)
										Game.Engine:SetMouseBlock(true)
										for i=0,10,1 do
											local lp = Game.Engine:GetViewMatrix():GetCameraVec()
											local el = m:GetBonePos(p:GetBoneId(2))
											local pp=Math.Predict(lp,el,m:GetVelocity(),55,0.0)
											local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
											ctr:SetAngle(dstAg)
											sleep(0.006)
										end												
										Game.Engine:SetMouseBlock(false)
									end
								end								
							end
						end
					end
				end
			end
		end
	end
end
dbsmooth = 0.0
function af()
	local s = Game.Engine:GetLocalPlayer():GetSkill()
	local u = s:GetSkillInfo(0x1510, 0).isUsing
	if (u > 0) and (Game.Utils.IsKeyPressed(0x5)) then
		nts(15,false)	
		if (nearestEnemy:IsValid()) then	
            local m = nearestEnemy:GetMesh()
			if (m) then
				local s2 = Game.Engine:GetLocalPlayer():GetSkill()
				local d = s2:GetSkillInfo(0x3D, 6)
				if (d) then
					local ctr = Game.Engine:GetController()
					local lp = Game.Engine:GetViewMatrix():GetCameraVec()
					local bp = m:GetBonePos(nearestEnemy:GetBoneId(14))		
					local rcbp = m:GetBonePos(nearestEnemy:GetBoneId(5))							
					local rr = Game.Engine:RayCast(lp, rcbp, 1)
					local dc = d:GetCoolTime()
					local h = nearestEnemy:GetHealth()
					
					local db = s2:GetSkillInfo(0xD7, 9)
					local dbc = db:GetCoolTime()
					
					if (dst(lp, bp) <= 6.5) then
						if (dbc.x == 0.0) or (dbc.y > 0.4) then
							local out = Math.XMFLOAT2(0,0)
							if (Game.Engine:WorldToScreen(bp, out)) then
								dbsmooth = dbsmooth + 0.00018
								if (dbsmooth > 1.0) then
									dbsmooth = 1.0
								end
					
								bp = m:GetBonePos(nearestEnemy:GetBoneId(0x2))
								local lp = Game.Engine:GetViewMatrix():GetCameraVec()			
								local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), dbsmooth)
								ctr:SetAngle(dstAg)						
								local rr = Game.Engine:LineOfSight(1)
								if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
									ctr:SetKeyCode(0x1)
									dbsmooth = 0.0
								end
							else
								dbsmooth = dbsmooth + 0.00025
								if (dbsmooth > 1.0) then
									dbsmooth = 1.0
								end
								
								bp = m:GetBonePos(nearestEnemy:GetBoneId(0x2))
								local lp = Game.Engine:GetViewMatrix():GetCameraVec()			
								local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), dbsmooth)
								ctr:SetAngle(dstAg)						
								local rr = Game.Engine:LineOfSight(1)
								if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
									ctr:SetKeyCode(0x1)
									dbsmooth = 0.0
								end
							end
						end				
					elseif (dc.x == 0.0) then
						hts(170)	
						if (lowhpEnemy:IsValid()) then	
							local lowhpMesh = lowhpEnemy:GetMesh()
							if not (lowhpMesh) then
								return
							end		
							local rcbp = lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(5))
							local rr = Game.Engine:RayCast(lp, rcbp, 1)
							if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
								for i=0,10,1 do
									local lp = Game.Engine:GetViewMatrix():GetCameraVec()
									local bp=lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(14))
									local pp=Math.Predict(lp,bp,lowhpMesh:GetVelocity(),200,0.0)
									local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
									ctr:SetAngle(dstAg)
									sleep(0.008)
								end
								ctr:SetKeyCode(0x8)
							end
						else
							hts(200)
							if (lowhpEnemy:IsValid()) then
								local lowhpMesh = lowhpEnemy:GetMesh()
								if not (lowhpMesh) then
									return
								end													
								local rcbp = lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(5))
								local rr = Game.Engine:RayCast(lp, rcbp, 1)
								if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
									for i=0,10,1 do
										local lp = Game.Engine:GetViewMatrix():GetCameraVec()
										local bp=lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(14))
										local pp=Math.Predict(lp,bp,lowhpMesh:GetVelocity(),200,0.0)
										local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
										ctr:SetAngle(dstAg)
										sleep(0.008)
									end		
									ctr:SetKeyCode(0x8)
								end
							else
								hts(350)
								if (lowhpEnemy:IsValid()) then
									local lowhpMesh = lowhpEnemy:GetMesh()
									if not (lowhpMesh) then
										return
									end														
									local rcbp = lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(5))
									local rr = Game.Engine:RayCast(lp, rcbp, 1)
									if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
										for i=0,10,1 do
											local lp = Game.Engine:GetViewMatrix():GetCameraVec()
											local bp=lowhpMesh:GetBonePos(lowhpEnemy:GetBoneId(14))
											local pp=Math.Predict(lp,bp,lowhpMesh:GetVelocity(),200,0.0)
											local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
											ctr:SetAngle(dstAg)
											sleep(0.008)
										end											
										ctr:SetKeyCode(0x8)
									end
								end
							end
						end
					end
				end
			end
		end
	else
		dbsmooth = 0.0
	end
end
function am()
	local s = Game.Engine:GetLocalPlayer():GetSkill()
	local u = s:GetSkillInfo(0x1510, 0).isUsing
	if (u == 0) then
		if (s:GetSkillInfo(0x3D, 3):GetCoolTime().x == 0.0) then
			local cnt = Game.Engine:GetPlayerCount()
			for i = 0, cnt - 1 do
				(function()
					local p = Game.Engine:GetPlayerAt(i)
					local m = p:GetMesh()
					if not (m and p:IsEnemy()) then
						return
					end
					local lp = Game.Engine:GetViewMatrix():GetCameraVec()
					local bp = m:GetBonePos(p:GetBoneId(5))
					local dst = dst(lp, bp)
					if dst > 3.0 then
						return
					end
					local h = p:GetHealth()
					if not (h and h:GetLife().y <= 26.0 and h:GetLife().y > 0) then
						return
					end
					local rr = Game.Engine:RayCast(lp, bp, 1)
					if not (rr and rr.hittedPlayer:IsValid()) then
						return
					end
					local ctr = Game.Engine:GetController()				
					for i=0,10,1 do
						local lp = Game.Engine:GetViewMatrix():GetCameraVec()			
						local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), (0.01*i)*i)
						ctr:SetAngle(dstAg)
						sleep(0.008)
					end
					ctr:SetKeyCode(0x800)
				end)()
			end
		end
	end
end
function ad()
	local ctr=Game.Engine:GetController()
	local cnt=Game.Engine:GetPlayerCount()
    for i=0,cnt-1 do local p=Game.Engine:GetPlayerAt(i) local m=p:GetMesh()
			if m and p:IsEnemy() then 
				local s=Game.Engine:GetLocalPlayer():GetSkill() 
				local u = s:GetSkillInfo(0x1510, 0).isUsing
				local inf=s:GetSkillInfo(0x3D,6)
				if (inf) then local dc=inf:GetCoolTime()
					if dc.x==0 then 
						local h=p:GetHealth()	
						local lp=Game.Engine:GetViewMatrix():GetCameraVec() 
						local bp=m:GetBonePos(p:GetBoneId(14))
						local dst=dst(lp,bp)
						if dst <= 15.0 then 
							if (h and h:GetLife().y<=78.0 and h:GetLife().y>0) then
							for bonenum=1,17,1 do
								local rcbp = m:GetBonePos(p:GetBoneId(bonenum))
								local rr=Game.Engine:RayCast(lp,rcbp,1)
								if not ((rr.bHitted) and (rr.hittedPlayer:IsValid())) then
									return
								end
							end
							if (u == 0) and (h:GetLife().y > 48.0) and (dst < 10.0) then
								for i=0,10,1 do
									local lp = Game.Engine:GetViewMatrix():GetCameraVec()	
									local bp=m:GetBonePos(p:GetBoneId(14))			
									local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), (0.01*i)*i)
									ctr:SetAngle(dstAg)
									sleep(0.01)
								end
								ctr:SetKeyCode(0x2)
								sleep(0.02)
								ctr:SetKeyCode(0x8)	
								sleep(0.1) --[[ Anti-Dash Abuse --]]
							elseif (h:GetLife().y <= 48.0) then
								for i=0,10,1 do
									local lp = Game.Engine:GetViewMatrix():GetCameraVec()
									local bp=m:GetBonePos(p:GetBoneId(14))
									local pp=Math.Predict(lp,bp,m:GetVelocity(),200,0.0)
									local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), (0.01*i)*i)
									ctr:SetAngle(dstAg)
									sleep(0.01)
								end
								ctr:SetKeyCode(0x8)
								sleep(0.1) --[[ Anti-Dash Abuse --]]
							end 
						end 
					end 
				end 
			end 
		end 
	end
end
function ab()
    if Game.Utils.IsKeyPressed(0x5) or Game.Utils.IsKeyPressed(0x6) then
	local s = Game.Engine:GetLocalPlayer():GetSkill()
	local u = s:GetSkillInfo(0x1510, 0).isUsing
	if (u > 0) then
		return
	end
::NearestPos::
		nts(9,false)
		if (nearestEnemy:IsValid()) then		
			ts()
			if (bestBone > 0) then
				local m = bestTarget:GetMesh()
				if (m) then
					local lp = Game.Engine:GetLocalPlayer():GetMesh():GetLocation()
					local ep = m:GetLocation()
					
					if (dst(lp, ep) < 10) then
						goto NearestAim
					end
				end			
			end
			local m = nearestEnemy:GetMesh()
			if (m) then
				local lp = Game.Engine:GetViewMatrix():GetCameraVec()
				local bp = Math.XMFLOAT3(0, 0, 0)
				if (Game.Utils.IsKeyPressed(0x5)) then
					bp = m:GetBonePos(nearestEnemy:GetBoneId(1))
				elseif (Game.Utils.IsKeyPressed(0x6)) then
					bp = m:GetBonePos(nearestEnemy:GetBoneId(1))
				end
				local ctr = Game.Engine:GetController()
				local lp = Game.Engine:GetViewMatrix():GetCameraVec()	
				local pp = Math.Predict(lp, bp, m:GetVelocity(), 200, 0.0)		

				local rbtc = s:GetSkillInfo(0xAD, 9):GetCoolTime()
				
				local out = Math.XMFLOAT2(0,0)
				if (rbtc.x == 0.0) or (rbtc.y < 0.01) then
					if (Game.Engine:WorldToScreen(bp, out)) then
						local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Rsm*1.5)
						ctr:SetAngle(dstAg)					
					else
						local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), Rsm*2.25)
						ctr:SetAngle(dstAg)						
					end
				else
					if (Game.Engine:WorldToScreen(bp, out)) then
						local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Rsm*0.25)
						ctr:SetAngle(dstAg)					
					else
						local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), Rsm*0.5)
						ctr:SetAngle(dstAg)						
					end
				end
				local rr = Game.Engine:LineOfSight(1)
				if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then
					ctr:SetKeyCode(2)
				end
			end
			return
		end
		
::NearestAim::
		ts()
		if (bestBone > 0) then
			local m = bestTarget:GetMesh()
			if (m) then
				local lp = Game.Engine:GetViewMatrix():GetCameraVec()
				local bp = Math.XMFLOAT3(0, 0, 0)
				if (Game.Utils.IsKeyPressed(0x5)) then
					bp = m:GetBonePos(bestBone)
				elseif (Game.Utils.IsKeyPressed(0x6)) then
					bp = m:GetBonePos(0x3)
				end
				local ctr = Game.Engine:GetController()
					if (dst(lp, bp) < 30.0) then
						if (dst(lp, bp) < 10.0) then
							local rbtc = s:GetSkillInfo(0xAD, 9):GetCoolTime()
								if (rbtc.x == 0.0) or (rbtc.y < 0.01) then			
									local rr = Game.Engine:LineOfSight(1)
									if (rr.bHitted) and (rr.hittedPlayer:IsValid()) then					
										local pp = Math.Predict(lp, bp, m:GetVelocity(), 200, 0.0)	
										local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Rsm) 
										ctr:SetAngle(dstAg)
										ctr:SetKeyCode(2)
									else
										local pp = Math.Predict(lp, bp, m:GetVelocity(), 200, 0.0)	
										local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Rsm)
										ctr:SetAngle(dstAg)
									end
								else
									local pp = Math.Predict(lp, bp, m:GetVelocity(), 200, 0.0)	
									local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Rsm*0.8)
									ctr:SetAngle(dstAg)							
								end
						else				
							local pp = Math.Predict(lp, bp, m:GetVelocity(), 55, 0.0)
							local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(pp - lp), Lsm)
							ctr:SetAngle(dstAg)
							ctr:SetKeyCode(1)
						end
				else
					local dstAg = Math.LerpVec3(ctr:GetAngle(), Math.NormalizeVec3(bp - lp), Lsm)
					ctr:SetAngle(dstAg)
					ctr:SetKeyCode(1)			
				end
			end
		end	
	end
end
function ts()
    local bestFov=Game.Engine:GetFov() bestBone=0 bestTarget=Player()
    local c=Game.Engine:GetPlayerCount()
    for i=0,c-1 do local p=Game.Engine:GetPlayerAt(i) 
		local h=p:GetHealth()
		if (h and (h:GetLife().y>0)) then 
		local o=Math.XMFLOAT2(0,0) local m=p:GetMesh()
			if (m) then
			local w=m:GetLocation()
				if (Game.Engine:WorldToScreen(w,o)) then
					if (p:IsEnemy()) then 
						if (abas(p)) then
							local f=Game.Engine:FindBestBone(p,bestFov,p:GetBoneId(1),1)
							if (f.bFound) then 
								bestFov=f.lastFov bestBone=f.foundBone bestTarget=p
							end	
						end
					end 
				end 
			end 
		end 
	end
end
nearestEnemy = Player()
function nts(maxdst, isvisible)
	local c = Game.Engine:GetPlayerCount()
	local oel = Math.XMFLOAT3(10000,10000,10000)
	nearestEnemy = Player()
	for i=0,c-1 do 
		local p = Game.Engine:GetPlayerAt(i)
		if p:IsEnemy() then
		if (abas(p)) then
			local h=p:GetHealth()
				if (h and (h:GetLife().y > 0))then
				local m = p:GetMesh()
					if (m) then
						local ll = Game.Engine:GetLocalPlayer():GetMesh():GetBonePos(Game.Engine:GetLocalPlayer():GetBoneId(1))
						local el = m:GetBonePos(p:GetBoneId(1))
						
						if (isvisible) then
							local out = Math.XMFLOAT2(0,0)
							if (Game.Engine:WorldToScreen(el, out)) then
								local rr = Game.Engine:RayCast(ll, el, 1)
								if (rr and rr.hittedPlayer:IsValid()) then
									if (dst(ll,el) < maxdst) then
										if (dst(ll,el) < dst(ll,oel)) then
											nearestEnemy = p
											oel = el 
										end
									end
								end	
							end
						else			
							local rr = Game.Engine:RayCast(ll, el, 1)
							if (rr and rr.hittedPlayer:IsValid()) then
								if (dst(ll,el) < maxdst) then
									if (dst(ll,el) < dst(ll,oel)) then
										nearestEnemy = p
										oel = el 
									end
								end
							end	
						end
					end
				end
			end
		end
	end
end
lowhpEnemy = Player()
function hts(maxhp)
	local c = Game.Engine:GetPlayerCount()
	local oeh = maxhp
	lowhpEnemy = Player()
	for i=0,c-1 do 
		local p = Game.Engine:GetPlayerAt(i)
		if p:IsEnemy() then
		if (abas(p)) then
			local h=p:GetHealth()
				if (h and (h:GetLife().y > 0))then
				local m = p:GetMesh()
					if (m) then
						local ll = Game.Engine:GetLocalPlayer():GetMesh():GetLocation()
						local el = m:GetLocation()
						if (dst(ll, el) < 15.0) then
							if (h:GetLife().y < oeh) then
								lowhpEnemy = p
								oeh = h:GetLife().y
							end
						end
					end
				end
			end
		end
	end
end

function OnUpdate()
	collectgarbage("collect")
	Game.Engine:SetFov(fov)
	abr = coroutine.create(ab)
	adr = coroutine.create(ad)
	amr = coroutine.create(am)
	afr = coroutine.create(af)
	ader = coroutine.create(ade)
	mdr = coroutine.create(md)
	
	coroutine.resume(abr)
	coroutine.resume(adr)
	coroutine.resume(amr)
	coroutine.resume(afr)	
	coroutine.resume(ader)	
	coroutine.resume(mdr)	
end


-- HPbar Visual -- Thanks to Inoring
function abs(v)
    return (v^2)^0.5
end
function Visuals()
    local cnt = Game.Engine:GetPlayerCount()
    for i = 0, cnt-1 do
        repeat
            local player = Game.Engine:GetPlayerAt(i)
            local health = player:GetHealth()
            local currenthealth = health:GetLife().y
            local maxhealth = health:GetLife().x

			if not (player:IsEnemy()) then
				do break end
			end
			
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

                    --[[ Health ]]
                    local heightBar = height2D * (currenthealth / maxhealth)
                    local widthBar = 6
                    local leftBar = 6
                    local fromBar = Math.XMFLOAT2(pointLU.x - leftBar - widthBar, pointLU.y - 1)
                    local toBar = Math.XMFLOAT2(pointLU.x - leftBar, pointLU.y + 1 + height2D)
                    
                    --box background
	
                    Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xff000000, 0, 0)

 
                    toBar.x = toBar.x - 1
                    toBar.y = toBar.y - 1
                    fromBar.x = fromBar.x + 1
                    fromBar.y = toBar.y - heightBar

                    --box health
                    if (currenthealth > 120) then
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xff00ff00, 0, 0) --green
                    elseif (currenthealth > 80) then
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xffffff00, 0, 0) --yellow
                    elseif (currenthealth > 50) then
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xffff0000, 0, 0) --red
                    else
                        Game.Renderer:DrawBoxFilled(fromBar, toBar, 0xffff00ff, 0, 0) --red
                    end					
                end
            end
            do break end
        until true
    end
end

function OnDraw()
    collectgarbage("collect")
	Visuals()
	Game.Renderer:DrawText("Loaded Genji Script - by.James brownie",10,25,16,0xF000FF00,false)	
end

local Module = {
	OnUpdate = OnUpdate,
	OnDraw = OnDraw
}
return Module