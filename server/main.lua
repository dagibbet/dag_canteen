

exports['qbr-core']:CreateUseableItem("canteen", function(source, item)	
	local _source = source
	local User = exports['qbr-core']:GetPlayer(_source)	
	local uses = item.info.uses
	local info = {}
	if uses == 0 then
		User.Functions.RemoveItem("canteen", 1, item.slot) 
		User.Functions.AddItem("emptycanteen", 1)
		TriggerClientEvent('QBCore:Notify', _source, 9,  'It is empty.', 6000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
	else
		info.uses = item.info.uses - 1
		User.Functions.RemoveItem("canteen", 1, item.slot)
		User.Functions.AddItem("canteen", 1, false, info)
		TriggerClientEvent('dag_canteen:client:drink', _source, item)
	end
end)

exports['qbr-core']:CreateUseableItem("emptycanteen", function(source, item)	
	local _source = source
	local User = exports['qbr-core']:GetPlayer(_source)		
	TriggerClientEvent('dag_canteen:client:StartFilling', _source, item)
end)

RegisterNetEvent("dag_canteen:server:fillup")
AddEventHandler("dag_canteen:server:fillup", function(item)
	local _source = source
	local User = exports['qbr-core']:GetPlayer(_source)		
    local r = 1
    local _source = source 
	local info = {}
    if r then
		info.uses = 4
		User.Functions.RemoveItem("emptycanteen", 1, item.slot) 
		User.Functions.AddItem("canteen", 1, false, info)
		TriggerClientEvent('QBCore:Notify', _source, 9,  Config.fullup, 6000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end)

