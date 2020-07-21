
-- HeroID(UInt64), UltMax(float), NPC(bool)
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

-- [slot] 0: Passive, 1: SKILL_1(Shift), 2: SKILL_2(E), 3: SKILL_L, 4: SKILL_R, 5: SKILL_ULT
-- [type] 1: .isUsing, 2: .flUltGauge, 3: .isBlocked, 4: GetCoolTime(), 5: .isUsing+GetCoolTime()
-- [id], [extra_id] 0: None
local SkillDatabase = {
    ["Ana"] = { 
        ["AnaShift"] = { slot = 1, type = 5, charging = false, casting = true, id = 0x3D, extra_id = 0x6 },
        ["AnaE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["AnaUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Ashe"] = { 
        ["AsheShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["AsheE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["AsheR"] = { slot = 4, type = 1, charging = false, casting = false, id = 0, extra_id = 0 },
        ["AsheUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Baptiste"] = { 
        ["BaptisteShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["BaptisteE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["BaptisteUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Bastion"] = { 
        ["BastionUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Brigitte"] = { 
        ["BrigitteShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["BrigitteE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["BrigitteR"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3306 },
        ["BrigitteUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Doomfist"] = { 
        ["DoomfistShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["DoomfistE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x8 },
        ["DoomfistR"] = { slot = 4, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["DoomfistUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["D.Va"] = { 
        ["D.VaShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["D.VaE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x9 },
        ["D.VaR"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["D.VaUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Echo"] = { 
        ["EchoShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["EchoE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["EchoR"] = { slot = 4, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["EchoUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Genji"] = { 
        ["GenjiShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["GenjiE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["GenjiUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0x1510, extra_id = 0 },
        ["GenjiUltUsing"] = { slot = 5, type = 2, charging = false, casting = false, id = 0x1510, extra_id = 0 },
    },
    ["Hana"] = { 
        ["HanaUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Hanzo"] = { 
        ["HanzoShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["HanzoE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["HanzoL"] = { slot = 3, type = 4, charging = true, casting = false, id = 0x2A5, extra_id = 0xA }
        ["HanzoUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Junkrat"] = { 
        ["JunkratShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["JunkratE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["JunkratUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Lucio"] = { 
        ["LucioE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["LucioR"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x9 },
        ["LucioUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["McCree"] = { 
        ["McCreeShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["McCreeE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["McCreeUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Mei"] = { 
        ["MeiShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["MeiE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id =  },
        ["MeiUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Mercy"] = { 
        ["MercyE"] = { slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id =  },
        ["MercyUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Moira"] = { 
        ["MoiraShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["MoiraE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["MoiraUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Orisa"] = { 
        ["OrisaShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["OrisaE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["OrisaR"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["OrisaUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Pharah"] = { 
        ["PharahShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x2 },
        ["PharahE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["PharahUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Reaper"] = { 
        ["ReaperShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x1 },
        ["ReaperE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id =  },
        ["ReaperUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Reinhardt"] = { 
        ["ReinhardtShift"] = { slot = 1, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x2 },
        ["ReinhardtE"] = { slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x7 },
        ["ReinhardtUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Roadhog"] = { 
        ["RoadhogShift"] = { slot = 1, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x3 },
        ["RoadhogE"] = { slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x7 },
        ["RoadhogUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Sigma"] = { 
        ["SigmaShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["SigmaE"] = { slot = 2, type = 4, charging = false, casting = true, id = 0x3D, extra_id = 0x6 },
        ["SigmaUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Soldier 76"] = { 
        ["Soldier 76E"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["Soldier 76R"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0xA },
        ["Soldier 76Ult"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Sombra"] = { 
        ["SombraShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["SombraE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["SombraUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Symmetra"] = { 
        ["SymmetraShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x5 },
        ["SymmetraE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id =  },
        ["SymmetraUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Torbjorn"] = { 
        ["TorbjornShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x189C, extra_id = 0 },
        ["TorbjornE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x1F89, extra_id = 0 },
        ["TorbjornUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Tracer"] = { 
        ["TracerShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0x2 },
        ["TracerE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x1 },
        ["TracerUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Widowmaker"] = { 
        ["WidowmakerShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x4 },
        ["WidowmakerE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["WidowmakerR"] = { slot = 4, type = 5, charging = true, casting = false, id = 0xAE, extra_id = 0x9 },
        ["WidowmakerUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Winston"] = { 
        ["WinstonShift"] = { slot = 1, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x6 },
        ["WinstonE"] = { slot = 2, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x3 },
        ["WinstonUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Wrecking Ball"] = { 
        ["Wrecking BallE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 0xA },
        ["Wrecking BallR"] = { slot = 4, type = 4, charging = false, casting = false, id = 0x3D, extra_id = 0x7 },
        ["Wrecking BallUlt"] = { slot = 5, type = 2, charging = false, casting = true, id = 0, extra_id = 0 },
    },
    ["Zarya"] = { 
        ["ZaryaShift"] = { slot = 1, type = 5, charging = false, casting = false, id = 0x3D, extra_id = 5 },
        ["ZaryaE"] = { slot = 2, type = 5, charging = false, casting = false, id = 0x3D, extra_id =  },
        ["ZaryaUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Zenyatta"] = { 
        ["ZenyattaUlt"] = { slot = 5, type = 2, charging = false, casting = false, id = 0, extra_id = 0 },
    },
    ["Training Bot1"] = {  },
    ["Training Bot2"] = {  },
    ["Training Bot3"] = {  },
    ["Training Bot4"] = {  },
    ["Common"] = { 
        ["ZaryaBarrier"] = { slot = 0, type = 4, charging = false, casting = false, id = 0x2BB, extra_id = 0x5 },
    },
}
