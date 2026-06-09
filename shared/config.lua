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
    { clipset = "move_m@brave",         label = "Stilus #1" },
    { clipset = "move_m@confident",     label = "Stilus #2" },
    { clipset = "move_m@drunk",         label = "Stilus #3" },
    { clipset = "move_m@fat@a",         label = "Stilus #4" },
    { clipset = "move_m@gangster@var_e", label = "Stilus #5" },
    { clipset = "move_m@gangster@var_f", label = "Stilus #6" },
    { clipset = "move_m@gangster@var_i", label = "Stilus #7" },
    { clipset = "move_m@hipster@a",     label = "Stilus #8" },
    { clipset = "move_m@hurry@a",       label = "Stilus #9" },
    { clipset = "move_m@injured",       label = "Stilus #10" },
    { clipset = "move_m@intimidation@1h", label = "Stilus #11" },
    { clipset = "move_m@money",         label = "Stilus #12" },
    { clipset = "move_m@muscle@a",      label = "Stilus #13" },
    { clipset = "move_m@posh@",         label = "Stilus #14" },
    { clipset = "move_m@quick",         label = "Stilus #15" },
    { clipset = "move_m@sad@a",         label = "Stilus #16" },
    { clipset = "move_m@swagger",       label = "Stilus #17" },
}

-- Chat animations (FiveM anim dict/name pairs)
Config.ChatAnims = {
    { dict = "gestures@m@standing@casual", anim = "gesture_hand_mouth" },
    { dict = "gestures@m@standing@casual", anim = "gesture_hello" },
    { dict = "gestures@m@standing@casual", anim = "gesture_me" },
    { dict = "gestures@m@standing@casual", anim = "gesture_nod_yes" },
    { dict = "gestures@m@standing@casual", anim = "gesture_point" },
    { dict = "gestures@m@standing@casual", anim = "gesture_shrug_hard" },
    { dict = "gestures@m@standing@casual", anim = "gesture_shrug_soft" },
    { dict = "gestures@m@standing@casual", anim = "gesture_wave" },
}

-- Award details for invite system
Config.AwardDetails = {
    { id = "invite:1",   label = "Hivj meg 1 embert",                                    reward = { amount = 1500,    type = "premium" } },
    { id = "invite:3",   label = "Hivj meg 3 embert",                                    reward = { amount = 2000,    type = "premium" } },
    { id = "invite:5",   label = "Hivj meg 5 embert",                                    reward = { amount = 2500,    type = "premium" } },
    { id = "invite:10",  label = "Hivj meg 10 embert",                                   reward = { amount = 3000,    type = "premium" } },
    { id = "invite:15",  label = "Hivj meg 15 embert",                                   reward = { amount = 3500,    type = "premium" } },
    { id = "invite:20",  label = "Hivj meg 20 embert",                                   reward = { amount = 4000,    type = "premium" } },
    { id = "invite:25",  label = "Hivj meg 25 embert",                                   reward = { amount = 4500,    type = "premium" } },
    { id = "invite:30",  label = "Hivj meg 30 embert",                                   reward = { amount = 5000,    type = "premium" } },
    { id = "invite:40",  label = "Hivj meg 40 embert",                                   reward = { amount = 6000,    type = "premium" } },
    { id = "invite:50",  label = "Hivj meg 50 embert",                                   reward = { amount = 8000,    type = "premium" } },
    { id = "earn:1:lvl:10",  label = "1 meghivottad erje el a 10-es szintet!",           reward = { amount = 300000,  type = "money" } },
    { id = "earn:2:lvl:15",  label = "2 meghivottad erje el a 15-es szintet!",           reward = { amount = 800000,  type = "money" } },
    { id = "earn:5:lvl:20",  label = "5 meghivottad erje el a 20-es szintet!",           reward = { amount = 1000000, type = "money" } },
    { id = "earn:3:lvl:25",  label = "3 meghivottad erje el a 25-es szintet!",           reward = { amount = 1500000, type = "money" } },
    { id = "earn:1:lvl:30",  label = "1 meghivottad erje el a 30-es szintet!",           reward = { amount = 12500,   type = "premium" } },
    { id = "work:1",         label = "Kezdjen el 1 meghivott jatekos dolgozni!",         reward = { amount = 3500,    type = "premium" } },
    { id = "work:3",         label = "Kezdjen el 3 meghivott jatekos dolgozni!",         reward = { amount = 5000,    type = "premium" } },
    { id = "work:5",         label = "Kezdjen el 5 meghivott jatekos dolgozni!",         reward = { amount = 7000,    type = "premium" } },
    { id = "group:1",        label = "Csatlakozzon 1 meghivott jatekos egy frakciohoz",  reward = { amount = 85000,   type = "money" } },
    { id = "group:3",        label = "Csatlakozzon 3 meghivott jatekos egy frakciohoz",  reward = { amount = 185000,  type = "money" } },
    { id = "group:5",        label = "Csatlakozzon 5 meghivott jatekos egy frakciohoz",  reward = { amount = 245000,  type = "money" } },
    { id = "group:10",       label = "Csatlakozzon 10 meghivott jatekos egy frakciohoz", reward = { amount = 15000,   type = "premium" } },
    { id = "buy:1:vehicle",  label = "Vasaroljon 1 meghivott jatekos autot!",            reward = { amount = 100000,  type = "money" } },
    { id = "buy:3:vehicle",  label = "Vasaroljon 3 meghivott jatekos autot!",            reward = { amount = 150000,  type = "money" } },
    { id = "buy:5:vehicle",  label = "Vasaroljon 5 meghivott jatekos autot!",            reward = { amount = 300000,  type = "money" } },
    { id = "buy:10:vehicle", label = "Vasaroljon 10 meghivott jatekos autot!",           reward = { amount = 10000,   type = "premium" } },
    { id = "buy:1:house",    label = "Vasaroljon 1 meghivott jatekos hazat!",            reward = { amount = 150000,  type = "money" } },
    { id = "buy:3:house",    label = "Vasaroljon 3 meghivott jatekos hazat!",            reward = { amount = 175000,  type = "money" } },
    { id = "buy:5:house",    label = "Vasaroljon 5 meghivott jatekos hazat!",            reward = { amount = 7500,    type = "premium" } },
    { id = "buy:10:house",   label = "Vasaroljon 10 meghivott jatekos hazat!",           reward = { amount = 15000,   type = "premium" } },
}

-- Premium shop menus
Config.PremiumShop = {
    {
        name = "Fegyverek",
        items = {
            -- {itemName, price, amount}
            { item = "WEAPON_PISTOL",         price = 2500 },
            { item = "WEAPON_COMBATPISTOL",   price = 3000 },
            { item = "WEAPON_PISTOL50",       price = 5000 },
            { item = "WEAPON_REVOLVER",       price = 6000 },
            { item = "WEAPON_SMG",            price = 4500 },
            { item = "WEAPON_MICROSMG",       price = 3200 },
            { item = "WEAPON_ASSAULTRIFLE",   price = 7500 },
            { item = "WEAPON_CARBINERIFLE",   price = 7000 },
            { item = "WEAPON_SNIPERRIFLE",    price = 12500 },
            { item = "WEAPON_PUMPSHOTGUN",    price = 5000 },
        }
    },
    {
        name = "Specialis itemek",
        items = {
            { item = "armor",       price = 800 },
            { item = "medkit",      price = 500 },
            { item = "lockpick",    price = 200 },
            { item = "repairkit",   price = 400 },
        }
    },
    {
        name = "Keszpenz",
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

-- News / Changelog
Config.LatestNews = {
    title = "Szerver indulas",
    date = "2025.06.01",
    badges = {
        { text = "Update",  color = "#4CAF50" },
        { text = "Hotfix",  color = "#2196F3" },
    }
}
