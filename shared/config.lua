Config = {}

-- Dashboard open key
Config.OpenKey = 'F1'

-- Interior slot price (in premium points)
Config.InteriorSlotPrice = 100

-- Vehicle slot price (in premium points)
Config.VehicleSlotPrice = 100

-- Animals available for purchase {name, price}
Config.AnimalsToBuy = {
    { name = "Husky",           price = 9000 },
    { name = "Rottweiler",      price = 6000 },
    { name = "Doberman",        price = 8000 },
    { name = "Bull Terrier",    price = 9000 },
    { name = "Boxer",           price = 7000 },
    { name = "Francia Bulldog", price = 10000 },
}

-- Walking styles (FiveM clipset names)
Config.WalkingStyles = {
    { clipset = "move_m@brave",            label = "Stílus #1" },
    { clipset = "move_m@confident",        label = "Stílus #2" },
    { clipset = "move_m@drunk",            label = "Stílus #3" },
    { clipset = "move_m@fat@a",            label = "Stílus #4" },
    { clipset = "move_m@gangster@var_e",   label = "Stílus #5" },
    { clipset = "move_m@gangster@var_f",   label = "Stílus #6" },
    { clipset = "move_m@gangster@var_i",   label = "Stílus #7" },
    { clipset = "move_m@hipster@a",        label = "Stílus #8" },
    { clipset = "move_m@hurry@a",          label = "Stílus #9" },
    { clipset = "move_m@injured",          label = "Stílus #10" },
    { clipset = "move_m@intimidation@1h",  label = "Stílus #11" },
    { clipset = "move_m@money",            label = "Stílus #12" },
    { clipset = "move_m@muscle@a",         label = "Stílus #13" },
    { clipset = "move_m@posh@",            label = "Stílus #14" },
    { clipset = "move_m@quick",            label = "Stílus #15" },
    { clipset = "move_m@sad@a",            label = "Stílus #16" },
    { clipset = "move_m@swagger",          label = "Stílus #17" },
}

-- Fighting styles
Config.FightingStyles = {
    { label = "Normál",   value = 0 },
    { label = "Boksz",    value = 1 },
    { label = "MMA",      value = 2 },
    { label = "Utcai",    value = 3 },
    { label = "Karate",   value = 4 },
}

-- Chat animations (FiveM anim dict/name pairs)
Config.ChatAnims = {
    { dict = "gestures@m@standing@casual", anim = "gesture_hand_mouth",  label = "Animáció #1" },
    { dict = "gestures@m@standing@casual", anim = "gesture_hello",       label = "Animáció #2" },
    { dict = "gestures@m@standing@casual", anim = "gesture_me",          label = "Animáció #3" },
    { dict = "gestures@m@standing@casual", anim = "gesture_nod_yes",     label = "Animáció #4" },
    { dict = "gestures@m@standing@casual", anim = "gesture_point",       label = "Animáció #5" },
    { dict = "gestures@m@standing@casual", anim = "gesture_shrug_hard",  label = "Animáció #6" },
    { dict = "gestures@m@standing@casual", anim = "gesture_shrug_soft",  label = "Animáció #7" },
    { dict = "gestures@m@standing@casual", anim = "gesture_wave",        label = "Animáció #8" },
    { dict = "gestures@m@standing@casual", anim = "gesture_why",         label = "Animáció #9" },
    { dict = "random@",                    anim = "idle_a",              label = "Animáció #10" },
    { dict = "random@",                    anim = "idle_b",              label = "Animáció #11" },
    { dict = "random@",                    anim = "idle_c",              label = "Véletlenszerű" },
    { dict = "",                           anim = "",                    label = "Kikapcsolva" },
}

-- Crosshair types
Config.CrosshairTypes = {
    { label = "Alapértelmezett", id = 1 },
    { label = "Pont",            id = 2 },
    { label = "Kereszt",         id = 3 },
    { label = "Kör",             id = 4 },
    { label = "Kikapcsolva",     id = 0 },
}

-- Crosshair colors
Config.CrosshairColors = {
    { label = "Fehér",    hex = "#ffffff" },
    { label = "Zöld",     hex = "#4ae06c" },
    { label = "Piros",    hex = "#f54a4a" },
    { label = "Kék",      hex = "#4a9ef5" },
    { label = "Sárga",    hex = "#f5d44a" },
    { label = "Narancssárga", hex = "#f5944a" },
    { label = "Fekete",   hex = "#000000" },
}

-- Speedo units
Config.SpeedoUnits = { "KM/H", "MPH" }

-- GPS sound packs
Config.GpsSounds = { "Női", "Férfi", "Kikapcsolva" }

-- Keybind defaults
Config.DefaultBinds = {
    { id = "voice",         label = "Voice egyedi nyomógomb",       default = "Q" },
    { id = "animcircle",    label = "Animációk gyors elérése",      default = "MOUSE3" },
    { id = "animpanel",     label = "Animáció lista",               default = "F2" },
    { id = "cuccaim",       label = "Kiegészítők",                  default = "F9" },
    { id = "pointing",      label = "Mutatás",                      default = "X" },
    { id = "tempotoggle",   label = "Tempomat be/ki",               default = "C" },
    { id = "tempoup",       label = "Tempomat sebesség +",          default = "NUM+" },
    { id = "tempodown",     label = "Tempomat sebesség -",          default = "NUM-" },
    { id = "activespoiler", label = "Active Spoiler",               default = "NUM5" },
    { id = "seatbelt",      label = "Biztonsági öv",                default = "F5" },
    { id = "downshift",     label = "Sebességváltó -",              default = "LCTRL" },
    { id = "upshift",       label = "Sebességváltó +",              default = "LSHIFT" },
    { id = "togcursor",     label = "Kurzor mód (nyomva tartva)",   default = "LALT" },
    { id = "pullkey",       label = "Pullozás",                     default = "X" },
    { id = "sirenKey",      label = "Villogó",                      default = "P" },
}

-- Premium shop menus (full content from MTA original)
Config.PremiumShop = {
    {
        name = "Fegyverek",
        items = {
            { item = "Pistol",              price = 2500 },
            { item = "Combat Pistol",       price = 3000 },
            { item = "Pistol .50",          price = 5000 },
            { item = "Revolver",            price = 6000 },
            { item = "SNS Pistol",          price = 3200 },
            { item = "Heavy Pistol",        price = 4600 },
            { item = "Vintage Pistol",      price = 5000 },
            { item = "Micro SMG",           price = 4500 },
            { item = "SMG",                 price = 6200 },
            { item = "Combat PDW",          price = 6200 },
            { item = "Assault SMG",         price = 8200 },
            { item = "MG",                  price = 9500 },
            { item = "Gusenberg Sweeper",   price = 6500 },
            { item = "Pump Shotgun",        price = 4500 },
            { item = "Sawed-Off Shotgun",   price = 6600 },
            { item = "Assault Shotgun",     price = 7200 },
            { item = "Bullpup Shotgun",     price = 6600 },
            { item = "Assault Rifle",       price = 7500 },
            { item = "Carbine Rifle",       price = 12500 },
            { item = "Advanced Rifle",      price = 13000 },
            { item = "Special Carbine",     price = 12000 },
            { item = "Bullpup Rifle",       price = 9500 },
            { item = "Compact Rifle",       price = 9900 },
            { item = "Military Rifle",      price = 12500 },
            { item = "Sniper Rifle",        price = 7700 },
            { item = "Heavy Sniper",        price = 13000 },
            { item = "Marksman Rifle",      price = 8000 },
            { item = "Combat MG Mk II",     price = 14000 },
            { item = "RPG",                 price = 22600 },
            { item = "Grenade Launcher",    price = 27600 },
            { item = "Molotov",             price = 500 },
            { item = "Gránát",              price = 500 },
            { item = "Könnygáz",            price = 1000 },
        }
    },
    {
        name = "Skines fegyverek",
        items = {
            { item = "AK-47 Camo",              price = 12000 },
            { item = "AK-47 Camo II",           price = 12000 },
            { item = "AK-47 Gold",              price = 13500 },
            { item = "AK-47 Gold II",           price = 13500 },
            { item = "AK-47 Kitty",             price = 18500 },
            { item = "AK-47 Silver",            price = 18500 },
            { item = "Desert Eagle Camo",       price = 15500 },
            { item = "Desert Eagle Gold",       price = 17500 },
            { item = "Desert Eagle Kitty",      price = 17500 },
            { item = "MP5 Skin #1",             price = 17500 },
            { item = "MP5 Skin #2",             price = 17500 },
            { item = "MP5 Skin #3",             price = 19500 },
            { item = "MP5 Skin #4",             price = 17500 },
            { item = "Sniper Camo",             price = 19000 },
            { item = "Sniper Camo II",          price = 21500 },
            { item = "Tec-9 Skin #1",           price = 16800 },
            { item = "Tec-9 Skin #2",           price = 16800 },
            { item = "Tec-9 Skin #3",           price = 18800 },
            { item = "Uzi Skin #1",             price = 19500 },
            { item = "Uzi Skin #2",             price = 19500 },
            { item = "Uzi Skin #3",             price = 21500 },
            { item = "Shotgun Skin #1",         price = 18500 },
            { item = "Shotgun Skin #2",         price = 18500 },
            { item = "Shotgun Skin #3",         price = 20500 },
            { item = "P90 Skin #1",             price = 19500 },
            { item = "P90 Skin #2",             price = 19500 },
            { item = "P90 Skin #3",             price = 21500 },
            { item = "P90 Gold",                price = 24500 },
            { item = "M4A1 Sopmod Skin #1",     price = 24500 },
            { item = "M4A1 Sopmod Skin #2",     price = 26500 },
            { item = "M4A1 Sopmod Gold",        price = 27500 },
            { item = "Glock-19 Laser Skin #1",  price = 20500 },
            { item = "Glock-19 Laser Skin #2",  price = 20500 },
            { item = "Glock-19 Laser Gold",     price = 24500 },
            { item = "AR-15 Holo Skin",         price = 36000 },
            { item = "AR-15 Aimpoint Skin",     price = 36000 },
            { item = "M110 Skin",               price = 38000 },
            { item = "Vipera",                  price = 44000 },
        }
    },
    {
        name = "Lőszerek",
        items = {
            { item = "Pisztoly lövedék (x30)",     price = 5 },
            { item = "SMG lövedék (x30)",          price = 5 },
            { item = "Puska lövedék (x30)",        price = 10 },
            { item = "Géppuska lövedék (x30)",     price = 10 },
            { item = "Sörétes lövedék (x12)",      price = 10 },
            { item = "Sniper lövedék (x5)",        price = 10 },
            { item = "Nehéz sniper lövedék (x5)",  price = 10 },
            { item = "Gépkarabély lövedék (x30)",  price = 10 },
            { item = "AP lövedék (x20)",           price = 10 },
            { item = "Tüzes lövedék (x10)",        price = 10 },
            { item = "Nyomjelző lövedék (x10)",    price = 10 },
            { item = "FMJ lövedék (x20)",          price = 10 },
        }
    },
    {
        name = "Mesterkönyvek",
        items = {
            { item = "Mesterkönyv: Fegyverkovács",       price = 2900 },
            { item = "Mesterkönyv: Lőszergyártás",       price = 2900 },
            { item = "Mesterkönyv: Robbanószer",         price = 2100 },
            { item = "Mesterkönyv: Mechanikus I.",       price = 3900 },
            { item = "Mesterkönyv: Mechanikus II.",      price = 3900 },
            { item = "Mesterkönyv: Mechanikus III.",     price = 3900 },
            { item = "Mesterkönyv: Elektronika",         price = 4900 },
            { item = "Mesterkönyv: Kémia I.",            price = 3900 },
            { item = "Mesterkönyv: Kémia II.",           price = 3900 },
            { item = "Mesterkönyv: Gyógyszeripar",       price = 3900 },
            { item = "Mesterkönyv: Orvoslás",            price = 3900 },
            { item = "Mesterkönyv: Festés",              price = 4900 },
            { item = "Mesterkönyv: Szabás-varrás",       price = 4900 },
            { item = "Mesterkönyv: Ékszerkészítés",      price = 4900 },
            { item = "Mesterkönyv: Főzés I.",            price = 4900 },
            { item = "Mesterkönyv: Főzés II.",           price = 3900 },
            { item = "Mesterkönyv: Horgászat",           price = 4900 },
            { item = "Mesterkönyv: Bányászat",           price = 4900 },
            { item = "Mesterkönyv: Famegmunkálás",       price = 4900 },
            { item = "Mesterkönyv: Állattenyésztés",     price = 4900 },
            { item = "Mesterkönyv: Növénytermesztés",    price = 4900 },
            { item = "Mesterkönyv: Szerelés",            price = 4900 },
            { item = "Mesterkönyv: IT Szakértő",         price = 4900 },
            { item = "Mesterkönyv: Zárfeltörés",         price = 3900 },
            { item = "Mesterkönyv: Hamisítás",           price = 4900 },
            { item = "Mesterkönyv: Mérgek",              price = 5900 },
            { item = "Mesterkönyv: Üvegfúvás",           price = 5900 },
            { item = "Mesterkönyv: Kőfaragás",           price = 5900 },
        }
    },
    {
        name = "Speciális itemek",
        items = {
            { item = "VIP Kártya (7 nap)",           price = 800 },
            { item = "Névváltó kártya",              price = 100 },
            { item = "Jármű slot bővítés",           price = 200 },
            { item = "Interior slot bővítés",        price = 200 },
            { item = "Garázs slot bővítés",          price = 200 },
            { item = "Teleport kártya",              price = 200 },
            { item = "Rendszámváltó kártya",         price = 200 },
            { item = "Extra karakter slot",          price = 100 },
            { item = "XP Boost kártya (2x, 1 óra)", price = 200 },
            { item = "XP Boost kártya (3x, 1 óra)", price = 400 },
            { item = "Protect kártya (7 nap)",       price = 1490 },
            { item = "Rádió lejátszó",               price = 200 },
            { item = "Egyedi autó festés",           price = 9800 },
            { item = "Felni paintjob",               price = 4900 },
            { item = "Lámpa paintjob",               price = 1800 },
            { item = "AirRide készlet",              price = 3500 },
            { item = "NOS palack",                   price = 300 },
            { item = "Szervíz készlet",              price = 50 },
            { item = "Traffipax radar",              price = 300 },
            { item = "Prémium traffipax radar",      price = 400 },
            { item = "Biztonsági táska",             price = 200 },
            { item = "Hátizsák",                     price = 150 },
            { item = "Elsősegély készlet",           price = 100 },
            { item = "Kötszer",                      price = 50 },
            { item = "Fájdalomcsillapító",           price = 30 },
        }
    },
    {
        name = "Drogok",
        items = {
            { item = "Marihuana (x5)",       price = 200 },
            { item = "Kokain (x3)",          price = 700 },
            { item = "Heroin (x3)",          price = 800 },
            { item = "Metamfetamin (x3)",    price = 800 },
            { item = "LSD (x5)",             price = 800 },
            { item = "Ecstasy (x5)",         price = 700 },
            { item = "Crack (x3)",           price = 800 },
            { item = "Adrenalin injekció",   price = 300 },
            { item = "Steroid",              price = 300 },
            { item = "Joint (x10)",          price = 200 },
            { item = "Cigaretta (x20)",      price = 100 },
            { item = "Alkohol",              price = 300 },
            { item = "Energia ital (x5)",    price = 200 },
        }
    },
    {
        name = "Blueprintek",
        items = {
            { item = "Blueprint: AK-74",              price = 3000 },
            { item = "Blueprint: AR-15",              price = 3000 },
            { item = "Blueprint: M4A1",               price = 3000 },
            { item = "Blueprint: M4A1 Sopmod",        price = 3000 },
            { item = "Blueprint: MP7A1",              price = 3000 },
            { item = "Blueprint: P90",                price = 3000 },
            { item = "Blueprint: Benelli M4",         price = 3000 },
            { item = "Blueprint: Mosin Nagant",       price = 3000 },
            { item = "Blueprint: Glock-19",           price = 3000 },
            { item = "Blueprint: Glock-19 Laser",     price = 3000 },
            { item = "Blueprint: HK USP45",           price = 3000 },
            { item = "Blueprint: Colt 1911",          price = 3000 },
            { item = "Blueprint: SW Model 66",        price = 3000 },
            { item = "Blueprint: M110",               price = 3000 },
            { item = "Blueprint: M700",               price = 3000 },
            { item = "Blueprint: Micro Draco",        price = 3000 },
            { item = "Blueprint: Taser X26",          price = 3000 },
            { item = "Blueprint: Pipe Wrench",        price = 3000 },
            { item = "Blueprint: Bard",               price = 3000 },
            { item = "Blueprint: Axe",                price = 3000 },
            { item = "Blueprint: Hammer",             price = 3000 },
            { item = "Blueprint: Suspension Kit",     price = 3000 },
            { item = "Blueprint: Vipera",             price = 3000 },
            { item = "Blueprint: AR-15 Holo",         price = 3000 },
        }
    },
    {
        name = "Készpénz",
        items = {
            { item = "money", price = 3000,  amount = 10000 },
            { item = "money", price = 6000,  amount = 25000 },
            { item = "money", price = 15000, amount = 100000 },
            { item = "money", price = 30000, amount = 500000 },
            { item = "money", price = 50000, amount = 1500000 },
            { item = "money", price = 75000, amount = 2000000 },
        }
    },
}

-- Award details for invite system
Config.AwardDetails = {
    { id = "invite:1",   label = "Hívj meg 1 embert",                                    reward = { amount = 1500,    type = "premium" } },
    { id = "invite:3",   label = "Hívj meg 3 embert",                                    reward = { amount = 2000,    type = "premium" } },
    { id = "invite:5",   label = "Hívj meg 5 embert",                                    reward = { amount = 2500,    type = "premium" } },
    { id = "invite:10",  label = "Hívj meg 10 embert",                                   reward = { amount = 3000,    type = "premium" } },
    { id = "invite:15",  label = "Hívj meg 15 embert",                                   reward = { amount = 3500,    type = "premium" } },
    { id = "invite:20",  label = "Hívj meg 20 embert",                                   reward = { amount = 4000,    type = "premium" } },
    { id = "invite:25",  label = "Hívj meg 25 embert",                                   reward = { amount = 4500,    type = "premium" } },
    { id = "invite:30",  label = "Hívj meg 30 embert",                                   reward = { amount = 5000,    type = "premium" } },
    { id = "invite:40",  label = "Hívj meg 40 embert",                                   reward = { amount = 6000,    type = "premium" } },
    { id = "invite:50",  label = "Hívj meg 50 embert",                                   reward = { amount = 8000,    type = "premium" } },
    { id = "earn:1:lvl:10",  label = "1 meghívottad érje el a 10-es szintet!",           reward = { amount = 300000,  type = "money" } },
    { id = "earn:2:lvl:15",  label = "2 meghívottad érje el a 15-es szintet!",           reward = { amount = 800000,  type = "money" } },
    { id = "earn:5:lvl:20",  label = "5 meghívottad érje el a 20-es szintet!",           reward = { amount = 1000000, type = "money" } },
    { id = "earn:3:lvl:25",  label = "3 meghívottad érje el a 25-es szintet!",           reward = { amount = 1500000, type = "money" } },
    { id = "earn:1:lvl:30",  label = "1 meghívottad érje el a 30-es szintet!",           reward = { amount = 12500,   type = "premium" } },
    { id = "work:1",         label = "Kezdjen el 1 meghívott játékos dolgozni!",         reward = { amount = 3500,    type = "premium" } },
    { id = "work:3",         label = "Kezdjen el 3 meghívott játékos dolgozni!",         reward = { amount = 5000,    type = "premium" } },
    { id = "work:5",         label = "Kezdjen el 5 meghívott játékos dolgozni!",         reward = { amount = 7000,    type = "premium" } },
    { id = "group:1",        label = "Csatlakozzon 1 meghívott játékos egy frakcióba",   reward = { amount = 85000,   type = "money" } },
    { id = "group:3",        label = "Csatlakozzon 3 meghívott játékos egy frakcióba",   reward = { amount = 185000,  type = "money" } },
    { id = "group:5",        label = "Csatlakozzon 5 meghívott játékos egy frakcióba",   reward = { amount = 245000,  type = "money" } },
    { id = "group:10",       label = "Csatlakozzon 10 meghívott játékos egy frakcióba",  reward = { amount = 15000,   type = "premium" } },
    { id = "buy:1:vehicle",  label = "Vásároljon 1 meghívott játékos autót!",            reward = { amount = 100000,  type = "money" } },
    { id = "buy:3:vehicle",  label = "Vásároljon 3 meghívott játékos autót!",            reward = { amount = 150000,  type = "money" } },
    { id = "buy:5:vehicle",  label = "Vásároljon 5 meghívott játékos autót!",            reward = { amount = 300000,  type = "money" } },
    { id = "buy:10:vehicle", label = "Vásároljon 10 meghívott játékos autót!",           reward = { amount = 10000,   type = "premium" } },
    { id = "buy:1:house",    label = "Vásároljon 1 meghívott játékos házat!",            reward = { amount = 150000,  type = "money" } },
    { id = "buy:3:house",    label = "Vásároljon 3 meghívott játékos házat!",            reward = { amount = 175000,  type = "money" } },
    { id = "buy:5:house",    label = "Vásároljon 5 meghívott játékos házat!",            reward = { amount = 7500,    type = "premium" } },
    { id = "buy:10:house",   label = "Vásároljon 10 meghívott játékos házat!",           reward = { amount = 15000,   type = "premium" } },
    { id = "buy:1:house-vehicle",  label = "1 meghívottad vegyen autót ÉS házat!",       reward = { amount = 200000,  type = "money" } },
    { id = "buy:3:house-vehicle",  label = "3 meghívottad vegyen autót ÉS házat!",       reward = { amount = 350000,  type = "money" } },
    { id = "buy:5:house-vehicle",  label = "5 meghívottad vegyen autót ÉS házat!",       reward = { amount = 12500,   type = "premium" } },
    { id = "earn:together:lvl-100",   label = "Meghívottak összszintje érje el a 100-at!", reward = { amount = 25000,   type = "premium" } },
    { id = "earn:together:hour-100",  label = "Meghívottak összesen 100 órát játszanak!", reward = { amount = 7500,    type = "premium" } },
    { id = "have:self:allachievements", label = "Érd el az összes meghívásos jutalmat!",  reward = { amount = 35000,   type = "premium" } },
}

-- News / Changelog
Config.LatestNews = {
    title = "Aranybankrablás",
    date = "2025.02.15",
    badges = {
        { text = "Hotfix",           color = "#4a9ef5" },
        { text = "Update",           color = "#4ae06c" },
        { text = "Aranybankrablás",  color = "#f5d44a" },
    }
}
