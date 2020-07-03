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
	TriggerEvent("vorp:addXp", _source, 0, xppay)
	TriggerClientEvent("vorp:TipRight", _source, 'XP Added', 3000)
end)


