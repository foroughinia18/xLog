-- base
local xlogwebhook = GetConvar('xlogwebhook', 'none')
-- connect
local function OnPlayerConnecting(name, setKickReason, deferrals)
	local name = ''
	local steam = 'steam:'
	local license = 'license:'
	local discord = 'discord:'
	local ip = ''
	name = GetPlayerName(source)
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steam = v
		end
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		end
		if string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		end
	end
	ip = GetPlayerEP(source)
	if name == nil then
		name = ''
	end
	if steam == nil then
		steam = 'steam:'
	end
	if license == nil then
		license = 'license:'
	end
	if discord == nil then
		discord = 'discord:'
	end
	if ip == nil then
		ip = ''
	end
	if xlogwebhook ~= 'none' then
		PerformHttpRequest(xlogwebhook, function(err, text, headers) end, 'POST', json.encode({content = '**Player Connecting**```name:'..name..'\n'..steam..'\n'..license..'\n'..discord..'\nip:'..ip..'```'}), { ['Content-Type'] = 'application/json' })
	end
end
AddEventHandler('playerConnecting', OnPlayerConnecting)
-- drop
local function OnPlayerDropped(reason)
	local name = GetPlayerName(source)
	if name == nil then
		name = ''
	end
	local ip = GetPlayerEP(source)
	if ip == nil then
		ip = ''
	end
	local reason = reason
	if reason == nil then
		reason = ''
	end
	if xlogwebhook ~= 'none' then
		PerformHttpRequest(xlogwebhook, function(err, text, headers) end, 'POST', json.encode({content = '**Player Dropped**```name:'..name..'\nreason:'..reason..'\nip:'..ip..'```'}), { ['Content-Type'] = 'application/json' })
	end
end
AddEventHandler('playerDropped', OnPlayerDropped)
-- chat
AddEventHandler('chatMessage', function(source, author, message)
	local name = GetPlayerName(source)
	if name == nil then
		name = ''
	end
	local ip = GetPlayerEP(source)
	if ip == nil then
		ip = ''
	end
	if xlogwebhook ~= 'none' then
		PerformHttpRequest(xlogwebhook, function(err, text, headers) end, 'POST', json.encode({content = '**Player Chatting**```name:'..name..'\nmessage:'..message..'\nip:'..ip..'```'}), { ['Content-Type'] = 'application/json' })
	end
end)
-- resource name
Citizen.CreateThread(function()
	while true do
		if GetCurrentResourceName() ~= 'xLog' then
			print('Change resource ' .. GetCurrentResourceName() .. ' name to xLog')
		end
		Citizen.Wait(60000)
	end
end)
