local looting = false
local islooted = false
Citizen.CreateThread(function()
    while true do
		Wait(1)
		if IsControlJustPressed(0,1101824977) then 
			local area = true
			local player = PlayerPedId()
			local coords = GetEntityCoords(player)
			local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
			local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
			local type = GetPedType(entityHit)
			local dead = IsEntityDead(entityHit)
			local human = IsPedHuman(entityHit)
			
			if type == 4 or dead then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(5)
							if IsControlJustReleased(0,1101824977) then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 250 then
									Wait(5)
									local lootcheck = entityHit;
										if lootcheck and human then
											looting = true
											local loot = math.random(1, 10)
											local lootpay = loot / 100
											local xppay = math.random(0, 2)
											local stuff = math.random(1,100)
											TriggerServerEvent("loot:addmoney", lootpay)
											TriggerServerEvent("loot:addxp", xppay)
											TriggerServerEvent("loot:giveitem", stuff)
										else
										looting = false
									end
									looting = false							
								end
							end
						end
					end
				--end
			end
    	end
    end
end)



