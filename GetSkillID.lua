function OnUpdate()
    collectgarbage("collect")
end

function OnDraw()
    collectgarbage("collect")

    local Skill = Game.Engine:GetLocalPlayer():GetSkill()
    for i = 0, 0x10 do
        local info = Skill:GetSkillInfo(0x3D, i)
        if (info) then
            local cool = info:GetCoolTime()
            Game.Renderer:DrawText(i .. ":\t" .. cool.x .. ", " .. cool.y, 10, 10 + i*16, 16, 0xffffffff, false)
        end
    end
end