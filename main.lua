local HeroDatabase = {
    ["Ana"] = { HeroID = 0x02E000000000013B, UltMax = 2100 , NPC = false },
    ["Ashe"] = { HeroID = 0x02E0000000000200, UltMax = 2240, NPC = false },
    ["Baptiste"] = { HeroID = 0x02E0000000000221, UltMax = 2352, NPC = false },
    ["Bastion"] = { HeroID = 0x02E0000000000015, UltMax = 2310, NPC = false },
    ["Brigitte"] = { HeroID = 0x02E0000000000195, UltMax = 2800, NPC = false },
    ["Doomfist"] = { HeroID = 0x02E000000000012F, UltMax = 1680, NPC = false },
    ["D.Va"] = { HeroID = 0x02E000000000007A, UltMax = 1540, NPC = false },
    ["Echo"] = { HeroID = 0x02E0000000000206, UltMax = 1960, NPC = false },
    ["Genji"] = { HeroID = 0x02E0000000000029, UltMax = 1680, NPC = false },
    ["Hana"] = { HeroID = 0x02E000000000007A, UltMax = 319.2, NPC = false },
    ["Hanzo"] = { HeroID = 0x02E0000000000005, UltMax = 1680, NPC = false },
    ["Junkrat"] = { HeroID = 0x02E0000000000065, UltMax = 1925, NPC = false },
    ["Lucio"] = { HeroID = 0x02E0000000000079, UltMax = 2940, NPC = false },
    ["McCree"] = { HeroID = 0x02E0000000000042, UltMax = 1680, NPC = false },
    ["Mei"] = { HeroID = 0x02E00000000000DD, UltMax = 1610, NPC = false },
    ["Mercy"] = { HeroID = 0x02E0000000000004, UltMax = 1820, NPC = false },
    ["Moira"] = { HeroID = 0x02E00000000001A2, UltMax = 2380, NPC = false },
    ["Orisa"] = { HeroID = 0x02E000000000013E, UltMax = 1680, NPC = false },
    ["Pharah"] = { HeroID = 0x02E0000000000008, UltMax = 2100, NPC = false },
    ["Reaper"] = { HeroID = 0x02E0000000000002, UltMax = 2100, NPC = false },
    ["Reinhardt"] = { HeroID = 0x02E0000000000007, UltMax = 1540, NPC = false },
    ["Roadhog"] = { HeroID = 0x02E0000000000040, UltMax = 2240, NPC = false },
    ["Sigma"] = { HeroID = 0x02E000000000023B, UltMax = 1960, NPC = false },
    ["Soldier 76"] = { HeroID = 0x02E000000000006E, UltMax = 2310, NPC = false },
    ["Sombra"] = { HeroID = 0x02E000000000012E, UltMax = 1400, NPC = false },
    ["Symmetra"] = { HeroID = 0x02E0000000000016, UltMax = 1680, NPC = false },
    ["Torbjorn"] = { HeroID = 0x02E0000000000006, UltMax = 2142, NPC = false },
    ["Tracer"] = { HeroID = 0x02E0000000000003, UltMax = 1260, NPC = false },
    ["Widowmaker"] = { HeroID = 0x02E000000000000A, UltMax = 1540, NPC = false },
    ["Winston"] = { HeroID = 0x02E0000000000009, UltMax = 1540, NPC = false },
    ["Wrecking Ball"] = { HeroID = 0x02E00000000001CA, UltMax = 1540, NPC = false },
    ["Zarya"] = { HeroID = 0x02E0000000000068, UltMax = 2100, NPC = false },
    ["Zenyatta"] = { HeroID = 0x02E0000000000020, UltMax = 2310, NPC = false },
    ["Training Bot1"] = { HeroID = 0x02E000000000016B, UltMax = 0, NPC = true },
    ["Training Bot2"] = { HeroID = 0x02E000000000016C, UltMax = 0, NPC = true },
    ["Training Bot3"] = { HeroID = 0x02E000000000016D, UltMax = 0, NPC = true },
    ["Training Bot4"] = { HeroID = 0x02E000000000016E, UltMax = 0, NPC = true },
}

main = 0
local HeroId = Game.Engine:GetLocalPlayer():GetIdentifier().HeroID
for key, value in next, HeroDatabase do
	if (value["HeroID"] == HeroId) then
		if (key ~= bak) then
			bak = key
			package.path = package.path .. ";" .. Game.Engine:GetPath() .. "?.lua"
			main = require(key)
		end
	end
end
Visual = require("Visual")


function OnUpdate()
    collectgarbage("collect")
    main.OnUpdate()
end

function OnDraw()
    collectgarbage("collect")
    Game.Renderer:DrawText(bak, Game.Renderer:GetWidth()/2, 10, 16, 0xFFFFFFFF, true)
    Visual.OnDraw()
    main.OnDraw()
end