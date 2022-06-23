--credits to vorp_goldpanning

local entity
local Filling = false

local WaterTypes = {
    [1] =  {["name"] = "Sea of Coronado",       ["waterhash"] = -247856387, ["watertype"] = "lake"},
    [2] =  {["name"] = "San Luis River",        ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [3] =  {["name"] = "Lake Don Julio",        ["waterhash"] = -1369817450, ["watertype"] = "lake"},
    [4] =  {["name"] = "Flat Iron Lake",        ["waterhash"] = -1356490953, ["watertype"] = "lake"},
    [5] =  {["name"] = "Upper Montana River",   ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [6] =  {["name"] = "Owanjila",              ["waterhash"] = -1300497193, ["watertype"] = "lake"},
    [7] =  {["name"] = "Hawks Eye Creek",       ["waterhash"] = -1276586360, ["watertype"] = "creek"},
    [8] =  {["name"] = "Little Creek River",    ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [9] =  {["name"] = "Dakota River",          ["waterhash"] = 370072007, ["watertype"] = "river"},
    [10] =  {["name"] = "Beartooth Beck",       ["waterhash"] = 650214731, ["watertype"] = "river"},
    [11] =  {["name"] = "Lake Isabella",        ["waterhash"] = 592454541, ["watertype"] = "lake"},
    [12] =  {["name"] = "Cattail Pond",         ["waterhash"] = -804804953, ["watertype"] = "pond"},
    [13] =  {["name"] = "Deadboot Creek",       ["waterhash"] = 1245451421, ["watertype"] = "creek"},
    [14] =  {["name"] = "Spider Gorge",         ["waterhash"] = -218679770, ["watertype"] = "creek"},
    [15] =  {["name"] = "O'Creagh's Run",       ["waterhash"] = -1817904483, ["watertype"] = "lake"},
    [16] =  {["name"] = "Moonstone Pond",       ["waterhash"] = -811730579, ["watertype"] = "pond"},
    [17] =  {["name"] = "Kamassa River",        ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [18] =  {["name"] = "Elysian Pool",         ["waterhash"] = -105598602, ["watertype"] = "lake"},
	[19] =  {["name"] = "Heartland Overflow",   ["waterhash"] = 1755369577, ["watertype"] = "lake"},
    [20] =  {["name"] = "Bayou NWA",            ["waterhash"] = -557290573, ["watertype"] = "swamp"},
    [21] =  {["name"] = "Lannahechee River",    ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [22] =  {["name"] = "Calmut Ravine",        ["waterhash"] = 231313522, ["watertype"] = "lake"},
    [23] =  {["name"] = "Ringneck Creek",       ["waterhash"] = 2005774838, ["watertype"] = "creek"},
    [24] =  {["name"] = "Stillwater Creek",     ["waterhash"] = -1287619521, ["watertype"] = "creek"},
    [25] =  {["name"] = "Lower Montana River",  ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [26] =  {["name"] = "Aurora Basin",         ["waterhash"] = -196675805, ["watertype"] = "lake"},
    [27] =  {["name"] = "Arroyo De La Vibora",  ["waterhash"] = -49694339, ["watertype"] = "river"},
    [28] =  {["name"] = "Whinyard Strait",      ["waterhash"] = -261541730, ["watertype"] = "creek"},
    [29] =  {["name"] = "Hot Springs",          ["waterhash"] = 1175365009, ["watertype"] = "pond"},
    [30] =  {["name"] = "Barrow Lagoon",        ["waterhash"] = 795414694, ["watertype"] = "lake"},
    [31] =  {["name"] = "Dewberry Creek",       ["waterhash"] = 469159176, ["watertype"] = "creek"},
    [32] =  {["name"] = "Cairn Lake",           ["waterhash"] = -1073312073, ["watertype"] = "pond"},
    [33] =  {["name"] = "Mattlock Pond",        ["waterhash"] = 301094150, ["watertype"] = "pond"},
    [34] =  {["name"] = "Southfield Flats",     ["waterhash"] = -823661292, ["watertype"] = "pond"},
    --[35] =  {["name"] = "Bahia De La Paz",      ["waterhash"] = -1168459546, ["watertype"] = "ocean"}, -- Disabled Ocean Water
}


RegisterNetEvent('dag_canteen:client:StartFilling')
AddEventHandler('dag_canteen:client:StartFilling', function(item)
    if not Filling then 
        Filling = true
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local Water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x, coords.y, coords.z)
        local foundwater = false
        for k,v in pairs(WaterTypes) do
            if Water == WaterTypes[k]["waterhash"]  then
				if IsPedOnFoot(PlayerPedId()) then
                    if IsEntityInWater(PlayerPedId()) then
						foundwater = true
						CrouchAnimAndAttach()
						exports['qbr-core']:Notify(9, Config.fill_1, 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
						Wait(6000)
						ClearPedTasks(ped)
						w = 1
						local seconds = w/1
						for i=1,seconds,1 do
							Wait(335)
						end
						-- Wait(w)
						ClearPedTasks(ped)
						DeleteObject(entity)
						DeleteEntity(entity)
						TriggerServerEvent("dag_canteen:server:fillup", item)
						break
					end
				end
            end
        end
        Filling = false
        if foundwater == false then
            exports['qbr-core']:Notify(9, 'It is empty.', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
    end
end)

function CrouchAnimAndAttach()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
    local modelHash = GetHashKey("p_cs_canteen_hercule")
    LoadModel(modelHash)
    entity = CreateObject(modelHash, coords.x+0.3, coords.y,coords.z, true, false, false)
    SetEntityVisible(entity, true)
    SetEntityAlpha(entity, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
    SetModelAsNoLongerNeeded(modelHash)
    AttachEntityToEntity(entity,ped, boneIndex, 0.1, 0.0, -0.2, -100.0, -50.0, 0.0, false, false, false, true, 2, true)

    TaskPlayAnim(ped, dict, "inspectfloor_player", 1.0, 8.0, -1, 1, 0, false, false, false)
end



function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

RegisterNetEvent('dag_canteen:client:drink')
AddEventHandler('dag_canteen:client:drink', function()
	TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", exports['qbr-core']:GetPlayerData().metadata["thirst"] + math.random(40,60))
	drinkinganim()
end)

function drinkinganim()
    local ped = PlayerPedId()
    if IsPedMale(ped) then
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_DRINK_FLASK'), 10000, true, false, false, false)
        Wait(10000)
		exports['qbr-core']:Notify(9, Config.drink_1, 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        ClearPedTasksImmediately(PlayerPedId())
    else
      -- FEMALE SCENARIO
	    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_DRINKING'), 10000, true, false, false, false)
        Wait(10000)
		exports['qbr-core']:Notify(9, Config.drink_1, 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        ClearPedTasksImmediately(PlayerPedId())
    end
end