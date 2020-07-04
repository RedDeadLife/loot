Inventory = {}
RegisterServerEvent('loot:addmoney')
AddEventHandler('loot:addmoney', function(price)
	local _source = source
	local _price = tonumber(price)
	TriggerEvent("vorp:addMoney", _source, 0, _price)
end)

RegisterServerEvent('loot:addxp')
AddEventHandler('loot:addxp', function(xppay)
	local _source = source
	local _xppay = tonumber(xppay)
	TriggerEvent("vorp:addXp", _source, xppay)
	TriggerClientEvent("vorp:TipRight", _source, xppay..' XP', 3000)
end)

RegisterServerEvent('loot:giveitem')
AddEventHandler('loot:giveitem', function(item)
	local _item = item
    local _source = source
	local randomitem =  math.random(1,5)
	Inventory = call
	--Inventory.addItem(_source, _item, randomitem)
	TriggerClientEvent("vorp:TipRight", _source,"loot is comeing soon", 3000)
end)
