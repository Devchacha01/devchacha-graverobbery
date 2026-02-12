Config = {}
Config.Debug = false

-- ═══════════════════════════════════════════════════════════
-- POLICE / LAW ENFORCEMENT
-- ═══════════════════════════════════════════════════════════
Config.Police = {
    MinLawmen = 0,          -- Minimum law online to allow grave robbing
    AlertChance = 40,       -- % chance a local reports you to the law when you start digging
    Jobs = { 'police', 'marshal', 'sheriff' },
    BlipDuration = 300,     -- seconds blip stays on law map (5 min)
    AlertRadius = 150.0,    -- If a civilian NPC is within this radius they may snitch
}

-- ═══════════════════════════════════════════════════════════
-- DIGGING SETTINGS
-- ═══════════════════════════════════════════════════════════
Config.Digging = {
    Duration = 15000,       -- ms to dig (progress bar)
    ShovelModel = 'p_shovel02x',
    AnimDict = 'amb_work@world_human_gravedig@working@male_b@base',
    AnimName = 'base',
    -- Shovel attachment offsets (right hand)
    AttachBone = 'SKEL_R_Hand',
    AttachOffset = { x = 0.0, y = -0.19, z = -0.089 },
    AttachRotation = { x = 274.19, y = 483.89, z = 378.40 },
}

-- ═══════════════════════════════════════════════════════════
-- REQUIRED ITEM TO ROB
-- ═══════════════════════════════════════════════════════════
Config.RequiredItem = nil    -- Set to 'shovel' or nil (nil = no item needed)
Config.ConsumeItem = false   -- If true the shovel is consumed on use

-- ═══════════════════════════════════════════════════════════
-- VISUAL: DUG GRAVE PROP (spawns after robbing)
-- ═══════════════════════════════════════════════════════════
Config.DugGrave = {
    Enabled = true,
    Model = 'p_gravedug03x',            -- Dug grave prop that replaces the original
    OffsetZ = -0.5,                      -- Lower it slightly into the ground
}

-- ═══════════════════════════════════════════════════════════
-- SETTINGS
-- ═══════════════════════════════════════════════════════════
Config.NightOnly = true      -- Only allow grave robbing at night (22:00 - 05:00)

-- ═══════════════════════════════════════════════════════════
-- LOOT TABLE  (single flat table, no tiers)
-- ═══════════════════════════════════════════════════════════
Config.Loot = {
    chance = 75,   -- % chance to find anything at all
    rewards = {
        -- Coins
        { item = 'coin_half_penny',             min = 1, max = 3,  weight = 20 },
        { item = 'coin_penny_1787',             min = 1, max = 2,  weight = 18 },
        { item = 'coin_penny_1789',             min = 1, max = 2,  weight = 16 },
        { item = 'coin_nickel_1792',            min = 1, max = 2,  weight = 12 },
        { item = 'coin_half_dime',              min = 1, max = 2,  weight = 10 },
        { item = 'coin_quarter_1792',           min = 1, max = 1,  weight = 8  },
        { item = 'coin_quarter_1792_2',         min = 1, max = 1,  weight = 7  },
        { item = 'coin_gold_dollar',            min = 1, max = 1,  weight = 4  },
        { item = 'coin_five_dollar',            min = 1, max = 1,  weight = 3  },
        { item = 'coin_gold_quarter',           min = 1, max = 1,  weight = 3  },
        { item = 'coin_half_eagle',             min = 1, max = 1,  weight = 3  },
        { item = 'coin_gold_eagle',             min = 1, max = 1,  weight = 2  },
        { item = 'coin_new_yorke',              min = 1, max = 1,  weight = 5  },
        -- Teeth / Misc
        { item = 'tooth_gold',                  min = 1, max = 1,  weight = 10 },
        { item = 'cigar',                       min = 1, max = 2,  weight = 15 },
        -- Rings
        { item = 'silver_ring',                 min = 1, max = 1,  weight = 12 },
        { item = 'wedding_ring',                min = 1, max = 1,  weight = 8  },
        { item = 'platinum_ring',               min = 1, max = 1,  weight = 5  },
        -- Necklaces
        { item = 'necklace_pearl_rou',          min = 1, max = 1,  weight = 6  },
        { item = 'necklace_pearl_pelle',        min = 1, max = 1,  weight = 6  },
        { item = 'necklace_gold_ring',          min = 1, max = 1,  weight = 6  },
        { item = 'necklace_gold_cross',         min = 1, max = 1,  weight = 5  },
        { item = 'necklace_ancient',            min = 1, max = 1,  weight = 4  },
        { item = 'necklace_mini_blakely',       min = 1, max = 1,  weight = 4  },
        { item = 'necklace_amethyst_braxton',   min = 1, max = 1,  weight = 4  },
        { item = 'necklace_amethyst_richelieu', min = 1, max = 1,  weight = 3  },
        -- Jewelry / Valuables
        { item = 'antique_jewelry_box',         min = 1, max = 1,  weight = 3  },
        { item = 'pocket_watch_silver',         min = 1, max = 1,  weight = 8  },
        { item = 'gold_bar',                    min = 1, max = 1,  weight = 2  },
        { item = 'diamond',                     min = 1, max = 1,  weight = 3  },
        { item = 'ruby',                        min = 1, max = 1,  weight = 3  },
        { item = 'sapphire',                    min = 1, max = 1,  weight = 3  },
        { item = 'emerald',                     min = 1, max = 1,  weight = 3  },
        { item = 'art_golden_chalice',          min = 1, max = 1,  weight = 3  },
        -- Robbery Ledger (book needed for house robbery)
        { item = 'robbery_ledger',              min = 1, max = 2,  weight = 2  },
    },
    cash = { min = 0, max = 15 },
}

-- ═══════════════════════════════════════════════════════════
-- GRAVE MODELS  (all in one flat list)
-- ═══════════════════════════════════════════════════════════
Config.GraveModels = {
    -- Standard gravestones
    'p_gravestone01ax',
    'p_gravestone01x',
    'p_gravestone02x',
    'p_gravestone03ax',
    'p_gravestone03x',
    'p_gravestone04x',
    'p_gravestone05x',
    'p_gravestone06x',
    'p_gravestone07ax',
    'p_gravestone07x',
    'p_gravestone08ax',
    'p_gravestone08x',
    'p_gravestone09x',
    'p_gravestone10x',
    'p_gravestone11x',
    'p_gravestone12x',
    'p_gravestone13x',
    'p_gravestone14ax',
    'p_gravestone14x',
    'p_gravestone15x',
    'p_gravestone16ax',
    'p_gravestone16x',
    'p_gravestonebroken01x',
    'p_gravestonebroken02x',
    'p_gravestonebroken05x',
    'p_gravestone_srd08x',
    -- Clean gravestones
    'p_gravestoneclean01x',
    'p_gravestoneclean02ax',
    'p_gravestoneclean02x',
    'p_gravestoneclean03x',
    'p_gravestoneclean04ax',
    'p_gravestoneclean04x',
    'p_gravestoneclean05ax',
    'p_gravestoneclean05x',
    'p_gravestoneclean06ax',
    'p_gravestoneclean06x',
    -- Special gravestones
    'p_gravestonegunslinger01x',
    'p_gravestonejanedoe01x',
    'p_gravestonejanedoe02x',
    'p_gravestonejohndoe01x',
    'p_gravestonejohndoe02x',
    -- Valentine gravestones
    'p_grvestne_v_01x',
    'p_grvestne_v_02x',
    'p_grvestne_v_03x',
    'p_grvestne_v_04x',
    'p_grvestne_v_05x',
    'p_grvestne_v_06x',
    'p_grvestne_v_07x',
    -- Markers, mounds, plaques
    'p_gravemarker01x',
    'p_gravemarker02x',
    'p_graveplaque01x',
    'p_gravemound01x',
    'p_gravemound02x',
    'p_gravemound03x',
    'p_gravemound04x',
    'p_gravefresh01x',
    'p_graveindian01x',
    'p_grave06x',
    'p_gravefather01x',
    'p_gravemother01x',
    'p_williegrave01x',
    -- Dug / open graves
    'p_gravedug03x',
    'p_gravedug06x',
    'p_gravediggingopen2x',
    'p_gravedugcover01x',
    'p_gravedugcover02x',
    -- Mass graves
    'p_massgrave01x',
    'p_massgrave02x',
    'p_massgrave03x',
    -- Story / character graves
    'p_arthur_grave_b',
    'p_arthur_grave_g',
    'p_davey_grave',
    'p_hosea_grave',
    'p_jenny_grave',
    'p_kieran_grave',
    'p_lenny_grave',
    'p_sean_grave',
    'p_susans_grave',
    'p_eagle_grave',
    -- DEA graves
    'p_dea_01_grave_04',
    'p_dea_01_grave_07',
    'p_dea_grave_03',
    'p_dea_grave_05',
    'p_dea_grave_06',
    'p_dea_grave_08',
    'p_dea_grave_09',
    'dea_01_grave_010',
    'dea_01_grave_011',
    'dea_01_grave_012',
    -- Misc
    'mp008_p_mp_gravemarker01x',
    'sfe2_dis_defacedgrave_01',
    'sfe2_dis_defacedgrave_02',
    'sfe2_dis_defacedgrave_slod',
    'sfe2_dis_defgrave_02_deb',
    'wat_ext_grave',
    'wat_ext_grave_lod',
}

-- ═══════════════════════════════════════════════════════════
-- SKILL CHECK (ox_lib skillCheck)
-- ═══════════════════════════════════════════════════════════
Config.SkillCheck = {
    Enabled = true,
    Difficulty = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 1 } },
    Keys = { 'w', 'a', 's', 'd' },
}

-- ═══════════════════════════════════════════════════════════
-- PRAY ANIMATIONS  (random one is picked each time)
-- ═══════════════════════════════════════════════════════════
Config.PrayAnim = {
    {"amb_misc@world_human_pray_rosary@base", "base"},
    {"amb_misc@prop_human_seat_pray@male_b@idle_b", "idle_d"},
    {"script_common@shared_scenarios@stand@random@town_burial@stand_mourn@male@react_look@loop@generic", "front"},
    {"amb_misc@world_human_grave_mourning@kneel@female_a@idle_a", "idle_a"},
    {"script_common@shared_scenarios@kneel@mourn@female@a@base", "base"},
    {"amb_misc@world_human_grave_mourning@female_a@idle_a", "idle_a"},
    {"amb_misc@world_human_grave_mourning@male_b@idle_c", "idle_g"},
    {"amb_misc@world_human_grave_mourning@male_b@idle_c", "idle_h"},
}
