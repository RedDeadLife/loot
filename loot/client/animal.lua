local collected, active = false, true -- active used for debugging
local skinnable = true
local skinPrompt , pickupPrompt
local skingroup = promptgroup
local prompt, prompt2  =  false, false
local Trapper, Butcher = false, false

Citizen.CreateThread(function()
	SetupskinPrompt() 

    while true do
	Wait(0)
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	local entityHit = 0
	local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 10, player)
	local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	local type = GetPedType(entityHit)
	local dead = IsEntityDead(entityHit)
	local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
	local model = GetEntityModel(entityHit)
	local quality = Citizen.InvokeNative(0x7BCC6087D130312A,  entityHit) 

	if type == 28 and not IsPedInAnyVehicle(player, true) then
			for i, row in pairs(Animal)do	
				if skinnable and dead then
					if model == Animal[i]["model"] then
						PromptSetEnabled(skinPrompt, true) --skinning prompt
						PromptSetVisible(skinPrompt, true)
						if PromptHasHoldModeCompleted(skinPrompt) then 
								PromptSetEnabled(skinPrompt, false)
								PromptSetVisible(skinPrompt, false)
								PromptSetEnabled(pickupPrompt, false)
								PromptSetVisible(pickupPrompt, false)
								SkinningAnimation()
								TriggerServerEvent("loot:addxp", 20)
								TriggerServerEvent("loot:add", Animal[i]["item"]) 
							if quality == 1 then
								TriggerServerEvent("loot:add", Animal[i]["poor"])
							elseif quality == 2 then
								TriggerServerEvent("loot:add", Animal[i]["item2"])
								TriggerServerEvent("loot:add", Animal[i]["good"])
							elseif quality == 3 then
								TriggerServerEvent("loot:add", Animal[i]["item2"])									
								TriggerServerEvent("loot:add",  Animal[i]["perfect"])
							end
								--removes dead PED and creates a Carcass 
							SetEntityAsMissionEntity(entityHit)
 
							carcuss = Animal[i]["carcuss"]
								Citizen.CreateThread(function() -- Cleanup function
							    local object = CreateObject(carcuss, coords.x +1 , coords.y +1,  coords.z, true, true, false)
									PlaceObjectOnGroundProperly(object)
									Citizen.Wait(60000)
									DeleteObject(object)
								end)
								DeleteEntity(entityHit) 
								skinnable = false
							prompt,prompt2 = false, false
							break
						end
						--start of pickup
						if PromptHasHoldModeCompleted(pickPrompt) then
							PromptSetEnabled(skinPrompt, false)
							PromptSetVisible(skinPrompt, false)
							PromptSetEnabled(pickupPrompt, false)
							PromptSetVisible(pickupPrompt, false)
							print("pickup carcass")
						end
						-- used to make sure all PEDs can be Added 
					if active and not model then
						Citizen.CreateThread(function()
						print(model)
						Citizen.Wait(3000)
					end)
						end
					end
				end
			end
		end
	end
end)


function playAnim(dict,name)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, name, 8.0, 8.0, 2000, 0, 0, true, 0, false, 0, false)  
end
function SkinningAnimation()
	playAnim("mech_skin@deer@dress_field_mg2","enter_drawn_lf")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","bc_cut")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","skin_pull")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","skin_cut_idle")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","skin_cut")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","skin_pull")
		Wait(2000)
	playAnim("mech_skin@deer@dress_field_mg2","skin_wrap_up")
		Wait(2100)
	ClearPedTasksImmediately(PlayerPedId())
end
function SetupskinPrompt()
	Citizen.CreateThread(function()
        local str = 'SKIN'
		skinPrompt = PromptRegisterBegin()
		PromptSetGroup(promptgroup)
        PromptSetControlAction(skinPrompt, 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(skinPrompt, str)
        PromptSetEnabled(skinPrompt, false)
        PromptSetVisible(skinPrompt, false)
        PromptSetHoldMode(skinPrompt, true)
		PromptRegisterEnd(skinPrompt)
    end)
end



-- if Need be I can add a trapper-butcher NPC to this
--[[ its currently set for all items to be sold to any vendor   ]]

Citizen.CreateThread(function()
	if Trapper then
		for i, row in pairs(NPC)do
		end
	end
end)
Citizen.CreateThread(function()
	if Butcher then
		for i, row in pairs(NPC)do
		end
	end
end)
