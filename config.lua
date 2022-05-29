Config = {}
Config.OpenKey = 166	 --E

Config.Upgrade = {
    [0] = {
        require = {},
        unlock = {
            
        },
        requireString = {}
    },
    [1] = {
        require = {
            money = 1000000,
            member = 5,
            point = 0,
        },
        unlock = {
            {itemType = "item", itemName = "armor3", itemLabel = "Giáp 3", itemSrc = "http://103.48.192.184/inventory/items/armour_gang.png", price = 20000}
            --[[ {itemType = "weapon", itemName = "WEAPON_SMG", itemLabel = "SMG", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_SMG.png", price = 10000},
            {itemType = "weapon", itemName = "WEAPON_KNIFE", itemLabel = "KNIFE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 5000},
            {itemType = "item", itemName = "armour_gang", itemLabel = "KNIFE", itemSrc = "http://103.48.192.184/inventory/items/armour_gang.png", price = 3300}, ]]
        },
        requireString = {}
    },
    [2] = {
        require = {
            money = 10000000,
            member = 7,
            point = 5000
        },
        unlock = {
            {itemType = "item", itemName = "armor3", itemLabel = "Giáp 3", itemSrc = "http://103.48.192.184/inventory/items/armour_gang.png", price = 20000},
            {itemType = "weapon", itemName = "WEAPON_KATANA", itemLabel = "Katana", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 200000},

            --{itemType = "weapon", itemName = "WEAPON_SMG", itemLabel = "SMG", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_SMG.png", price = 10000},
            --[[ {itemType = "weapon", itemName = "WEAPON_KNIFE", itemLabel = "KNIFE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 50000},
            {itemType = "weapon", itemName = "WEAPON_ASSAULTRIFLE", itemLabel = "ASSAULRIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_ASSAULTRIFLE.png", price = 450000},
            {itemType = "item", itemName = "armor1", itemLabel = "Giáp Gang", itemSrc = "http://103.48.192.184/inventory/items/armor1.png", price = 13300}, ]]
        } 
    },
    [3] = {
        require = {
            money = 15000000,
            member = 10,
            point = 15000
        },
        unlock = {
            {itemType = "item", itemName = "armor3", itemLabel = "Giáp 3", itemSrc = "http://103.48.192.184/inventory/items/armour_gang.png", price = 20000},
            {itemType = "weapon", itemName = "WEAPON_KATANA", itemLabel = "Katana", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 200000},
            --{itemType = "weapon", itemName = "WEAPON_SMG", itemLabel = "SMG", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_SMG.png", price = 10000},
            {itemType = "weapon", itemName = "WEAPON_ASSAULTRIFLE", itemLabel = "ASSAULRIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_ASSAULTRIFLE.png", price = 5000000},
            --{itemType = "weapon", itemName = "WEAPON_CARBINERIFLE", itemLabel = "CARBINERIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_CARBINERIFLE.png", price = 40000},
            --{itemType = "item", itemName = "armor1", itemLabel = "Giáp Gang", itemSrc = "http://103.48.192.184/inventory/items/armor1.png", price = 13300},
        } 
    },
    [4] = {
        require = {
            money = 30000000,
            member = 15,
            point = 30000
        },
        unlock = {
            --{itemType = "weapon", itemName = "WEAPON_SMG", itemLabel = "SMG", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_SMG.png", price = 10000},
            {itemType = "weapon", itemName = "WEAPON_KNIFE", itemLabel = "KNIFE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 50000},
            {itemType = "weapon", itemName = "WEAPON_ASSAULTRIFLE", itemLabel = "ASSAULRIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_ASSAULTRIFLE.png", price = 5000000},
            --{itemType = "weapon", itemName = "WEAPON_CARBINERIFLE", itemLabel = "CARBINERIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_CARBINERIFLE.png", price = 40000},
            {itemType = "weapon", itemName = "WEAPON_BAT", itemLabel = "BAT", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_BAT.png", price = 200000},
            --{itemType = "item", itemName = "armor1", itemLabel = "Giáp Gang", itemSrc = "http://103.48.192.184/inventory/items/armor1.png", price = 13300},
            --{itemType = "item", itemName = "armor2", itemLabel = "Giáp Gang", itemSrc = "http://103.48.192.184/inventory/items/armor2.png", price = 18300},
        }  
    },
    [5] = {
        require = {
            money = 45000000,
            member = 20,
            gem = 10000,
            point = 50000
        },
        unlock = {
            --{itemType = "weapon", itemName = "WEAPON_SMG", itemLabel = "SMG", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_SMG.png", price = 10000},
            {itemType = "weapon", itemName = "WEAPON_KNIFE", itemLabel = "KNIFE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_KNIFE.png", price = 5000},
            {itemType = "weapon", itemName = "WEAPON_ASSAULTRIFLE", itemLabel = "ASSAULRIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_ASSAULTRIFLE.png", price = 5000000},
            --{itemType = "weapon", itemName = "WEAPON_CARBINERIFLE", itemLabel = "CARBINERIFLE", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_CARBINERIFLE.png", price = 40000},
            {itemType = "weapon", itemName = "WEAPON_BAT", itemLabel = "BAT", itemSrc = "http://103.48.192.184/inventory/items/WEAPON_BAT.png", price = 200000},
            {itemType = "item", itemName = "armor3", itemLabel = "Giáp Gang 3", itemSrc = "http://103.48.192.184/inventory/items/armor3.png", price = 22300},
        } 
    },
}