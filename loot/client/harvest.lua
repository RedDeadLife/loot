local looting, active = false, false
local skinnable = true
local skinPrompt , pickupPromt
local skingroup = group
local prompt, prompt2, prompt3 = false, false, false


Citizen.CreateThread(function()
	SetuppickupPrompt()
	SetupskinPrompt()
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
		--[[getting model number for hide loot system]]
		local model = GetEntityModel(entityHit)
		--[[now how good is it?]]
		local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)

		if not IsPedInAnyVehicle(player, true) then
			local shape = true
            while shape do
        	--[[ Looting carcusses of small game and birds]]
		    --[[ E key is tied to the skinning R key is tied to the Pick-up ]]
		    if type == 28 and skinnable then --check cfg to see if its a small PED to loot right away,
			    PromptSetEnabled(skinPrompt, true)
			    PromptSetVisible(skinPrompt, true)
			    --if not smallgame then -- smallgame should look at the cfg for if its needed
			        PromptSetEnabled(pickupPrompt, true)
			        PromptSetVisible(pickupPrompt, true)
			    --end
			    TriggerEvent("vorp:TipBottom", "Find Loot for "..model, 4000) --remove after debugging
			    Wait(1000)
			    if PromptHasHoldModeCompleted(skinPrompt) then --this one works
				    PromptSetEnabled(skinPrompt, false)
				    PromptSetVisible(skinPrompt, false)
				    prompt = false
				    prompt2 = false
				    skinnable = false
					    if smallGame then
                            CheckGameType(model)
					    else
                            CheckGameType(model)
					    end
				    break
			    end
			    if PromptHasHoldModeCompleted(pickupPrompt) then -- not working
				    PromptSetEnabled(pickupPrompt, false)
				    PromptSetVisible(pickupPrompt, false)
				    prompt = false
				    prompt2 = false
				    skinnable = false
				    print("PickUP Carcuss")
				    break
			    end
            end
		end
		--[[ Looting carcusses of small game and birds]]
		--[[ E key is tied to the skinning R key is tied to the Pick-up ]]
		if type == 28 and skinnable then --check cfg to see if its a small PED to loot right away,
			PromptSetEnabled(skinPrompt, true)
			PromptSetVisible(skinPrompt, true)
			--if not smallgame then -- smallgame should look at the cfg for if its needed
			PromptSetEnabled(pickupPrompt, true)
			PromptSetVisible(pickupPrompt, true)
			--end
			TriggerEvent("vorp:TipBottom", "Find Loot for "..model, 4000) --remove after debugging
			Wait(1000)
			if PromptHasHoldModeCompleted(skinPrompt) then --this one works
				PromptSetEnabled(skinPrompt, false)
				PromptSetVisible(skinPrompt, false)
				prompt = false
				prompt2 = false
				skinnable = false
					if smallGame then
                        AnimLooting()
					else
                    CheckGameType(model)
                        AnimSkinning()
					end
				break
			end
			if PromptHasHoldModeCompleted(pickupPrompt) then -- not working
				PromptSetEnabled(pickupPrompt, false)
				PromptSetVisible(pickupPrompt, false)
				prompt = false
				prompt2 = false
				skinnable = false
				print("PickUP Carcuss")
				break
			end
		end
	end
end)

function CheckGameType(model)
	print("Got the"..type.." and the "..model.." now...")
	print("goto config...")
	print("using model number, match to loot")
	print("place loot into player inv")
	DeletePed(dead)	--doesnt delete the PED 

end

function AnimLooting()
	--freeze players in place with the anime switch with harv anime
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
	Wait(6000)
	ClearPedTasksImmediately(PlayerPedId())
end
function AnimSkinning()
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