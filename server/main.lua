ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
Players = {}
local gangHouse = {}

ESX.RegisterServerCallback("lr_gang:callback:getGangData", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangName = xPlayer.job2.name
    local gangData = xPlayer.getJob2Data()
    local data = {}
    data.gangName = gangName
    data.gangSrc = gangData.job_logo
    data.gangText = gangData.job_slogan
    data.gangLevel = gangData.level
end)



--[[ o.gangData = {
    gangName = "",
    gangSrc = "",
    gangText = "",
    gangLevel = 1,
    gangMember = 0,
    members = {},
    store = {},
    gangGrade = {},
    upgradeUnlock = {},
    upgradeRequire = {},
} ]]


Gang = {}
Gang.__index = Gang

function Gang:Init(name, label, job_logo, job_slogan, level, point, inv_pos)
    print(house, "asd")
    local o = {}
    setmetatable(o, Gang)
    o.gangName = name
    o.gangLabel = label
    o.gangSrc = job_logo
    o.gangText = job_slogan
    o.gangLevel = level
    o.gangPoint = point
    o.gangMembers = 0
    o.members = {}
    o.inventoryPos = inv_pos
    o.store = Config.Upgrade[tonumber(o.gangLevel)].unlock
    o.gangGrade = {}
    o.upgradeUnlock = {}
    o.upgradeRequire = {}
    o.gangAccount = nil
    o.Inventory = nil
    TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..o.gangName, function(account)
        if account ~= nil then
            print(account.money)
            o.gangAccount = account
        end
    end)
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..o.gangName, function(inventory)
        o.Inventory = inventory
    end)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE job2 = @job2", {
        ['@job2'] = o.gangName
    }, function(result)
        local c = 0
        for i = 1, #result, 1 do 
            table.insert(o.members, {
                isOnline = false,
                name = result[i].name,
                grade = result[i].job2_grade,
                identifier = result[i].identifier
            })
            c = c + 1
        end
        o.gangMembers = c
    end)
    MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job", {
        ["@job"] = o.gangName
    }, function(result)
        for i = 1, #result, 1 do 
            table.insert(o.gangGrade, {
                name = result[i].name,
                label = result[i].label,
                grade = tonumber(result[i].grade)
            })
        end
    end)
    for i = 1, #Config.Upgrade[o.gangLevel + 1].unlock, 1 do 
        table.insert(o.upgradeUnlock, ("%s (%s)"):format(Config.Upgrade[o.gangLevel + 1].unlock[i].itemLabel, Config.Upgrade[o.gangLevel + 1].unlock[i].price))
    end
    if Config.Upgrade[o.gangLevel + 1].require.money ~= nil then 
        table.insert(o.upgradeRequire, ("%s $"):format(Config.Upgrade[o.gangLevel + 1].require.money))
    end
    if Config.Upgrade[o.gangLevel + 1].require.member ~= nil then 
        table.insert(o.upgradeRequire, ("C???n %s th??nh vi??n"):format(Config.Upgrade[o.gangLevel + 1].require.member))
    end
    if Config.Upgrade[o.gangLevel + 1].require.gem ~= nil then 
        table.insert(o.upgradeRequire, ("%s GEM"):format(Config.Upgrade[o.gangLevel + 1].require.gem))
    end
    if Config.Upgrade[o.gangLevel + 1].require.point ~= nil then 
        table.insert(o.upgradeRequire, ("%s ??i???m chi???n c??ng"):format(Config.Upgrade[o.gangLevel + 1].require.point))
    end
    TriggerEvent('esx_society:registerSociety', o.gangName, o.gangLabel, "society_"..o.gangName, "society_"..o.gangName, "society_"..o.gangName, {type = 'public'})
    print(o.gangName)
    return o    
end

function Gang:UpdateData()
    self.upgradeUnlock = {}
    self.upgradeRequire = {}
    self.store = Config.Upgrade[tonumber(self.gangLevel)].unlock
    TriggerEvent("esx_addonaccount:getSharedAccount", self.gangName, function(account)
        if account ~= nil then
            self.gangAccount = account
        end
    end)
    for i = 1, #Config.Upgrade[self.gangLevel + 1].unlock, 1 do 
        table.insert(self.upgradeUnlock, ("%s (%s)"):format(Config.Upgrade[self.gangLevel + 1].unlock[i].itemLabel, Config.Upgrade[self.gangLevel + 1].unlock[i].price))
    end
    if Config.Upgrade[self.gangLevel + 1].require.money ~= nil then 
        table.insert(self.upgradeRequire, ("%s $"):format(Config.Upgrade[self.gangLevel + 1].require.money))
    end
    if Config.Upgrade[self.gangLevel + 1].require.member ~= nil then 
        table.insert(self.upgradeRequire, ("C???n %s th??nh vi??n"):format(Config.Upgrade[self.gangLevel + 1].require.member))
    end
    if Config.Upgrade[self.gangLevel + 1].require.gem ~= nil then 
        table.insert(self.upgradeRequire, ("%s GEM"):format(Config.Upgrade[self.gangLevel + 1].require.gem))
    end
    if Config.Upgrade[self.gangLevel + 1].require.point ~= nil then 
        table.insert(self.upgradeRequire, ("%s ??i???m chi???n c??ng"):format(Config.Upgrade[self.gangLevel + 1].require.point))
    end
end

function Gang:UpdateInventoryPos(coords)
    print(self.gangName, json.encode(coords))
    self.inventoryPos = coords
    MySQL.Async.execute("UPDATE jobs SET inventory_pos = @inventory_pos WHERE name = @name", {
        ['@name'] = self.gangName,
        ['@inventory_pos'] = json.encode(coords)
    }, function(rowChanged)
        self:SyncData()
    end)
end

function Gang:SyncData()
    for k, v in pairs(self.members) do 
        if v.id ~= nil then 
            TriggerClientEvent("lr_gang:client:syncGangData", v.id, self)
        end
    end
end

function Gang:UpdateMemberStatus(playerId, identifier, status)
    for k, v in pairs(self.members) do 
        if v.identifier == identifier then 
            self.members[k].isOnline = status
            self.members[k].id = playerId
        end
    end
end

function Gang:RemoveMember(identifier)
    for i = 1, #self.members, 1 do 
        if self.members[i].identifier == identifier then 
            table.remove(self.members, i)
            self:SyncData()
            break
        end
    end
end

function Gang:AddMember(xPlayer)
    table.insert(self.members, {
        isOnline = true,
        name = xPlayer.name,
        grade = xPlayer.job2.grade,
        identifier = xPlayer.identifier
    })
    self:SyncData()
end

function Gang:EditMember(identifier, key, val)
    for i=1, #self.members, 1 do 
        if self.members[i].identifier == identifier then 
            self.members[i][key] = val
            break
        end
    end
    self:SyncData()
end

function Gang:Upgrade()
    local require = Config.Upgrade[self.gangLevel + 1].require
    local canUpgrade = true
    for k, v in pairs(require) do 
        if k == "money" then 
            --[[ if self:GetMoney() < v then 
                canUpgrade = false
                print(self:GetMoney(), v)
            end ]]
            self:GetMoney(function()
                if self.gangAccount.money < v then 
                    canUpgrade = false
                end
            end)
        elseif k == "member" then 
            if self.gangMembers < v then 
                canUpgrade = false
                print(self.gangMembers, v)
            end
        elseif k == "point" then 
            if self.gangPoint < v then 
                canUpgrade = false
                print(self.gangPoint, v)
            end
        end
    end
    print(canUpgrade)
    if canUpgrade then 
        for k, v in pairs(require) do 
            if k == "money" then 
                self:GetMoney(function()
                    if self.gangAccount.money >= v then 
                        self:RemoveMoney(v)
                        self.gangLevel = self.gangLevel + 1
                        self:UpdateData()
                    end
                end)
            elseif k == "point" then 
                if self.gangPoint >= v then 
                    self:RemovePoint(v)
                end
            end
        end
        MySQL.Async.execute("UPDATE jobs SET level = @level WHERE name = @name", {
            ['@level'] = self.gangLevel,
            ['@name'] = self.gangName
        })
        self:SyncData()

    end
end

function Gang:RemovePoint(point)
    if point <= self.gangPoint then 
        self.gangPoint = self.gangPoint - point
        MySQL.Async.execute("UPDATE jobs SET jobPoint = @point WHERE name = @name", {
            ['@name'] = self.gangName,
            ['@point'] = self.gangPoint
        })
    end
end

function Gang:RemoveMoney(money)
    if self.gangAccount.money >= money then
        self.gangAccount.removeMoney(money)
        TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..self.gangName, function(account)
            if account ~= nil then
                self.gangAccount = account
                self:SyncData()
            end
        end)
        return true
    else
        return false
    end
end

function Gang:AddMoney(money)
    self.gangAccount.addMoney(money)
    TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..self.gangName, function(account)
        if account ~= nil then
            self.gangAccount = account
            self:SyncData()
        end
    end)
end

function Gang:UpdatePoint(newPoint)
    self.gangPoint = self.gangPoint + 1
end

function Gang:GetMoney(cb)
    TriggerEvent("esx_addonaccount:getSharedAccount", "society_"..self.gangName, function(account)
        if account ~= nil then
            self.gangAccount = account
            cb()
        end
    end)
end

function Gang:GetItem()
    return(self.Inventory.getItem)
end

function Gang:AddItem(name, count)
    self.Inventory.addItem(name, count)
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..self.gangName, function(inventory)
        self.Inventory = inventory
    end)
end

function Gang:RemoveItem(name, count)
    if self.Inventory.getItem(name).count >= count then 
        self.Inventory.removeItem(name, count)
        TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..self.gangName, function(inventory)
            self.Inventory = inventory
        end)
    end
end

Gangs = {}

MySQL.ready(function()
    print("SQL TASK")
    MySQL.Async.fetchAll("SELECT * FROM jobs", {}, function(result)
        for i = 1, #result, 1 do
            print(result[i].name)
            Gangs[result[i].name] = Gang:Init(result[i].name, result[i].label, result[i].job_logo, result[i].job_slogan, result[i].level, result[i].jobPoint, json.decode(result[i].inventory_pos))
        end
    end)
end)


ESX.RegisterServerCallback("lr_gang:callback:getGangData", function(source, cb, gangName)
    TriggerClientEvent("lr_gang:client:syncBlip", source, gangHouse)
    if Gangs[gangName] then 
        cb(Gangs[gangName])
    end
end)

AddEventHandler("lr_gang:getGangData", function(gangName, cb)
    if Gangs[gangName] then 
        cb(Gangs[gangName])
    end
end)

RegisterNetEvent("lr_gang:server:changeLogo")
AddEventHandler("lr_gang:server:changeLogo", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job2.grade_name == "boss" then
        xPlayer.updateJob2Logo(data)
        Gangs[xPlayer.job2.name].gangSrc = data
        Gangs[xPlayer.job2.name]:SyncData()
    else
        ESX.ShowNotification("B???n kh??ng ????? quy???n h???n")
    end
end)
RegisterNetEvent("lr_gang:server:changeSlogan")
AddEventHandler("lr_gang:server:changeSlogan", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.job2.grade_name == "boss" then
        Gangs[xPlayer.job2.name].gangText = data
        xPlayer.updateJob2Slogan(data)
        Gangs[xPlayer.job2.name]:SyncData()
    else
        ESX.ShowNotification("B???n kh??ng ????? quy???n h???n")
    end
end)
RegisterNetEvent("lr_gang:server:quitGang")
AddEventHandler("lr_gang:server:quitGang", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setJob2("unemployed2", 0)
    Gangs[xPlayer.job2.name]:RemoveMember(xPlayer.identifier)
end)
RegisterNetEvent("lr_gang:server:promote")
AddEventHandler("lr_gang:server:promote", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job2.grade_name == "boss" then 
        local tPlayer = ESX.GetPlayerFromIdentifier(data.identifier)
        if tPlayer then 
            tPlayer.setJob2(xPlayer.job2.name, tonumber(data.grade))
            xPlayer.showNotification("~g~ TH??NH C??NG ~w~")
        else
            MySQL.Async.execute("UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier", {
                ['@identifier'] = data.identifier,
                ['@job2'] = xPlayer.job2.name,
                ['job2_grade'] = tonumber(data.grade)
            }, function(rowChanged)
                if rowChanged > 0 then 
                    xPlayer.showNotification("~g~ TH??NH C??NG ~w~")
                end
            end)
        end
        Gangs[xPlayer.job2.name]:EditMember(data.identifier, "grade", tonumber(data.grade))
    else
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n")
    end
end)
RegisterNetEvent("lr_gang:server:fireMember")
AddEventHandler("lr_gang:server:fireMember", function(data)
    print(data.identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job2.grade_name == "boss" then
        local tPlayer = ESX.GetPlayerFromIdentifier(data.identifier)
        if tPlayer then 
            print("asdasd")
            tPlayer.setJob2("unemployed2", 0)
            xPlayer.showNotification("~g~ TH??NH C??NG ~w~")
        else
            MySQL.Async.execute("UPDATE users SET job2 = 'unemployed2', job2_grade = 0 WHERE identifier = @identifier", {
                ['@identifier'] = data.identifier
            }, function(rowChanged)
                if rowChanged > 0 then 
                    xPlayer.showNotification("~g~ TH??NH C??NG ~w~")
                end
            end)
        end
        Gangs[xPlayer.job2.name]:RemoveMember(data.identifier)
    else
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n")
    end   
end)
RegisterNetEvent("lr_gang:server:buy")
AddEventHandler("lr_gang:server:buy", function(data)
    print(json.encode(data))
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job2.grade_name == "boss" then
        if Gangs[xPlayer.job2.name] then
           -- print(Gangs[xPlayer.job2.name]:GetMoney(), data.price)
            Gangs[xPlayer.job2.name]:GetMoney(function()
                if Gangs[xPlayer.job2.name].gangAccount.money >= tonumber(data.price) then 
                    Gangs[xPlayer.job2.name]:RemoveMoney(tonumber(data.price))
                    if data.itemType == "weapon" then 
                        TriggerEvent("weapon_system:server:getPlayerData", source, function(playerData)
                            print(playerData.getAmmo("AMMO_PISTOL"))
                            playerData.addWeapon(data.itemName)
                        end)
                    elseif data.itemType == "item" then 
                        xPlayer.addInventoryItem(data.itemName, 1)
                    end
                else
                    xPlayer.showNotification("Gang c???a b???n kh??ng ????? ti???n")
                end
            end)
            
        end
    else
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n")
    end  
end)
RegisterNetEvent("lr_gang:server:upgrade")
AddEventHandler("lr_gang:server:upgrade", function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobName = xPlayer.job2.name
    if xPlayer.job2.grade_name == "boss" then
        if Gangs[jobName] then
            Gangs[xPlayer.job2.name]:Upgrade()
        end
    else
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n")
    end   
    
end)

AddEventHandler("lr_gang:server:updatePoint", function(gangName)
    Gangs[gangName]:UpdatePoint()
end)

AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    local jobName = xPlayer.job2.name
    if Gangs[jobName] then
        Gangs[jobName]:UpdateMemberStatus(playerId, xPlayer.identifier, true)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    Wait(5000)
    if resourceName == GetCurrentResourceName() then 
        local xPlayers = ESX.GetPlayers()
        for k, v in pairs(xPlayers) do 
            local xPlayer = ESX.GetPlayerFromId(v)
            if Gangs[xPlayer.job2.name] then
                Gangs[xPlayer.job2.name]:UpdateMemberStatus(v, xPlayer.identifier, true)
            end
        end
    end
end)
--[[ TriggerEvent('esx:setJob2', self.source, self.job2, lastJob)]]
AddEventHandler("esx:setJob2", function(playerId, job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if Gangs[lastJob.name] then 
        Gangs[lastJob.name]:RemoveMember(xPlayer.identifier)
        Gangs[lastJob.name].gangMembers = Gangs[lastJob.name].gangMembers - 1
    end
    if Gangs[job.name] then 
        Gangs[job.name]:AddMember(xPlayer)
        Gangs[job.name].gangMembers = Gangs[job.name].gangMembers + 1
    end
end)



RegisterNetEvent("lr_gang:server:createGang")
AddEventHandler("lr_gang:server:createGang", function(gangName, gangLabel)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= 1000000 and not Gangs[gangName] then 
        xPlayer.removeMoney(1000000)
        ESX.AddJob(gangName, gangLabel)
        Wait(2000)
        TriggerEvent("esx_addonaccount:registerGang", gangName, gangLabel)
        TriggerEvent("esx_addoninventory:registerGang", gangName, gangLabel)
        TriggerEvent('esx_society:registerSociety', gangName, gangLabel, "society_"..gangName, "society_"..gangName, "society_"..gangName, {type = 'public'})
        TriggerEvent("lr_societydata:server:registerSociety", gangName)
        MySQL.Async.fetchAll("SELECT * FROM jobs WHERE name = @name", {
            ['@name'] = gangName
        }, function(result)
            Gangs[result[1].name] = Gang:Init(result[1].name, result[1].label, result[1].job_logo, result[1].job_slogan, result[1].level, result[1].jobPoint)
            xPlayer.setJob2(gangName, 3)
            xPlayer.showNotification(("%s ???? ???????c ????ng k??, b???n s??? l??m ch??? c???a %s"):format(gangName, gangLabel))
        end)
        
    else
        xPlayer.showNotification("Kh??ng ????? ~y~1.000.000$~w~ ????? t???o b??ng ?????nh")
    end
end)

RegisterNetEvent("lr_gang:server:changeInventory")
AddEventHandler("lr_gang:server:changeInventory", function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job2.grade_name == "boss" then
        if Gangs[xPlayer.job2.name] then
            local house = nil
            for k, v in pairs(gangHouse) do 
                if v.owner == xPlayer.job2.name then 
                    house = v
                end
            end
            if house ~= nil then 
                local distance = math.sqrt((coords.x - house.x)^2 + (coords.y - house.y)^2)
                print(distance)
                if distance <= 50.0 then 
                    Gangs[xPlayer.job2.name]:UpdateInventoryPos(coords)
                    xPlayer.showNotification("Th??nh c??ng")
                else
                    xPlayer.showNotification("B???n ph???i ?????t kho ????? trong khu v???c nh?? Gang c???a b???n")
                end
            else
                xPlayer.showNotification("Gang c???a b???n  nh?? n??n kh??ng th??? ?????t kho ?????")
            end
        end
    else
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n")
    end  
end)

RegisterNetEvent("lr_gang:server:setHouse")
AddEventHandler("lr_gang:server:setHouse", function(index, sprite)
    print(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(gangHouse) do 
        if v.owner == xPlayer.job2.name then 
            xPlayer.showNotification("B??ng ?????ng c???a b???n ???? c?? nh?? r???i, n???u mu???n ?????i vui l??ng li??n h??? ADMIN")
            return
        end
    end 
    if xPlayer.job2.grade_name == "boss" then 
        print(":asdasd")
        if Gangs[xPlayer.job2.name].gangLevel >= 3 then
            Gangs[xPlayer.job2.name].gangHouse = gangHouse[index]
            gangHouse[index].owner = xPlayer.job2.name
            gangHouse[index].sprite = tonumber(sprite)
            MySQL.Async.execute("UPDATE lr_ganghouse SET owner = @owner, sprite = @sprite WHERE id = @id", {
                ['@id'] = gangHouse[index].id,
                ['@owner'] = xPlayer.job2.name,
                ['@sprite'] = tonumber(sprite)
            }, function()
                TriggerClientEvent("lr_gang:client:syncBlip", -1, gangHouse)
            end)
        else
            xPlayer.showNotification("Gang c???a b???n ch??a ?????t c???p 2 ????? s??? d???ng ch???c n??ng n??y")
        end
    end
end)

ESX.RegisterServerCallback("lr_gang:callback:canSetHouse", function(source, cb, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(gangHouse) do 
        if v.owner == xPlayer.job2.name then 
            xPlayer.showNotification("B??ng ?????ng c???a b???n ???? c?? nh?? r???i, n???u mu???n ?????i vui l??ng li??n h??? ADMIN")
            cb(false)
            return
        end
    end 
    if xPlayer.job2.grade_name == "boss" then 
        cb(true)
    else
        cb(false)
        xPlayer.showNotification("B???n kh??ng ????? quy???n h???n ????? th???c hi???n ??i???u n??y")
    end
end)

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM lr_ganghouse", {}, function(result)
        print(json.encode(result))
        gangHouse = result
    end)
end)