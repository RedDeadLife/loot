local looting, collected, active = false, false, false
local skinnable = true
local skinPrompt , pickupPromt, collectPrompt
local skingroup = group
local prompt, prompt2, prompt3 = false, false, false
AcitveType = {}


Citizen.CreateThread(function()
	--SetuppickupPrompt() -- commented since it isnt working atm
	SetupskinPrompt()
	SetupCollectPrompt()
	Citizen.InvokeNative(0x4CC5F2FC1332577F, 1058184710) --[[removes player cards, and Ammo(sadly).]]
    while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local entityHit = 0
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
		local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		local type = GetPedType(entityHit)
		local dead = IsEntityDead(entityHit)
		local PressTime = 0
		local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
		local model = GetEntityModel(entityHit)

		if IsControlJustPressed(0,1101824977) and not IsPedInAnyVehicle(player, true) and not looting then
			local shape = true
			while shape do
				Wait(0)
				if type == 4 and dead then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(0)
							if IsControlJustReleased(0,1101824977) then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 250 then
									looting = false
									Wait(500)
									local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
									if lootedcheck then
										local loot = math.random(1, 10)
										local lootpay = loot / 100
										local xppay = math.random(0, 2)
										TriggerServerEvent("loot:addmoney", lootpay)
										TriggerServerEvent("loot:addxp", xppay)
										TriggerServerEvent("loot:giveItem")
									else
										looting = false
									end
									looting = false
								end
							end
						end	
					end	
				end
			end
		end
		--[[ E key is tied to the skinning R key is tied to the Pick-up. This makes it Controller and KB friendly ]]
		if type == 28 and skinnable then --and not IsPedInAnyVehicle(player, true) then -- Some reason the prompts hangs up
			AttachEntityToEntity(dead, player, 0, 0.0, 1.0, -0.7, 0.0, 0.0, 0.0, true, false, false, false, false)
			PromptSetEnabled(skinPrompt, true)
			PromptSetVisible(skinPrompt, true)
			if PromptHasHoldModeCompleted(skinPrompt) then --this one works
				print("starting to skin")
				PromptSetEnabled(skinPrompt, false)
				PromptSetVisible(skinPrompt, false)
				prompt = false
				prompt2 = false
				skinnable = false
					for i, row in pairs(Animal) do
						if model == Animal[i]["model"] then
							print("Animal List", model)
								AnimLooting()
								TriggerServerEvent("loot:add", Animal[i]["item"])
								TriggerServerEvent("loot:addxp", 20)
								--TODO Change Animal to a skinned model
								DeletePed(dead)
						end
					
					end

					for i, row in pairs(Critter)do	
						if model == Critter[i]["model"] then
							AnimLooting()
							TriggerServerEvent("loot:add", Critter[i]["item"])
							TriggerServerEvent("loot:addxp", 10)
							--TODO delete ped
							DeletePed(dead)	--doesnt delete the PED 
						end
					end
				break
			end
			if PromptHasHoldModeCompleted(pickupPrompt) then -- not working bypass for now
				PromptSetEnabled(pickupPrompt, false)
				PromptSetVisible(pickupPrompt, false)
				prompt = false
				prompt2 = false
				skinnable = false
				print("PickUP Carcuss")
				break
			end
		end
		--[[check coords vs cfg before prompts]]
		--if coords < 2 then
			if not collected then
			PromptSetEnabled(collectPrompt, true)
			PromptSetVisible(collectPrompt, true)
			end
			--for i, row in pairs(Collectable)do
				if PromptHasHoldModeCompleted(collectPrompt) then
					PromptSetEnabled(collectPrompt, false)
					PromptSetVisible(collectPrompt, false)
					collected = true
					TriggerServerEvent("loot:addxp", 100)
					AnimLooting()
				end
			--end
		--end
	end
end)

function AnimLooting()
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
	Wait(2000)
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_BOOK_GROUND_PICKUP'), 10000, true, false, false, false)
	Wait(2000)
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_STAND_WAITING'), 10000, true, false, false, false)--change this to standin up
	Wait(2000)
	ClearPedTasksImmediately(PlayerPedId())
end

function SetupskinPrompt()
	Citizen.CreateThread(function()
        local str = 'SKIN'
        skinPrompt = PromptRegisterBegin()
        PromptSetControlAction(skinPrompt, 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(skinPrompt, str)
        PromptSetEnabled(skinPrompt, false)
        PromptSetVisible(skinPrompt, false)
        PromptSetHoldMode(skinPrompt, true)
		PromptRegisterEnd(skinPrompt)
    end)
end
function SetuppickupPrompt()
	Citizen.CreateThread(function()
        local str = 'PICK-UP'
        pickupPrompt = PromptRegisterBegin()
        PromptSetControlAction(pickupPrompt, 0xE30CD707)--[[R]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(pickupPrompt, str)
        PromptSetEnabled(pickupPrompt, false)
        PromptSetVisible(pickupPrompt, false)
        PromptSetHoldMode(pickupPrompt, true)
        PromptRegisterEnd(pickupPrompt)
    end)
end
function SetupCollectPrompt()
	Citizen.CreateThread(function()
        local str = 'Collect'
        collectPrompt = PromptRegisterBegin()
        PromptSetControlAction(pickupPrompt, 0xDFF812F9)--[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(collectPrompt, str)
        PromptSetEnabled(collectPrompt, false)
        PromptSetVisible(collectPrompt, false)
        PromptSetHoldMode(collectPrompt, true)
        PromptRegisterEnd(collectPrompt)
    end)
end

--Intitialise Collectables
function StartCollectables()
	ActiveType[Type] = {}
	print("Adding collectables to Map")
	for i, row in pairs(Collectable) do
		SpawnItem(item, prop)
	end
end
--Spawn Items
function SpawnItem(item, prop)
	while not HasModelLoaded(prop)do
		Citizen.Wait(1)
	end
	print("Collectable Spawned")
end
--collect item
function CollectItem(item, type)
	print("Collectable Collected")
	Wait(500)
	DespawnCollectable(item)
end
--Despawn Items after collected
function DespawnCollectable(item)
	print("Despawned Collectable")
end

