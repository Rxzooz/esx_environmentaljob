local CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask = {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false
ESX = nil
local isBusyReviveenvironmental = false
local isOnDuty = false -- addon service by wesam
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function GetExtraLabel(state)
    if state then
        return '<span style="color:green;">مفعل</span>'
    elseif not state then
        return '<span style="color:darkred;">غير مفعل</span>'
    end
end

function ToggleVehicleExtra(vehicle, extraId, extraState)
    SetVehicleExtra(vehicle, extraId, extraState)
end

function OpenLiveryMenu()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        local vehicle  = GetVehiclePedIsIn(playerPed, false)
        local LiveryCount = GetVehicleLiveryCount(vehicle)
        local elements = {
            { label = '<span style="color:Red;">الملصقات و الأكسترا</span>', value = 'title'}
        }
        for i=1,LiveryCount do
            table.insert(elements, {label = 'الملصق '..i, value = i, type = "livery"})
        end
		for i=0, 12 do
			if DoesExtraExist(vehicle, i) then
				local state = IsVehicleExtraTurnedOn(vehicle, i) == 1
				table.insert(elements, {label = ('اكسسوار <span style="color:darkgoldenrod;">%s</span>: %s'):format(i, GetExtraLabel(state)), state = state, extraId = i, type = "extra"})
			end
		end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery',
        {
            title    = 'قائمة الملصقات',
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            if not (data.current.value == 'title') then
				if data.current.type == "livery" then
					local currentLivery = GetVehicleLivery(vehicle)
					if not (currentLivery == data.current.value) then
						SetVehicleLivery(vehicle, data.current.value)
					end
				elseif data.current.type == "extra" then
					ToggleVehicleExtra(vehicle, data.current.extraId, data.current.state)
					OpenLiveryMenu()
				end
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    else
        ESX.ShowNotification('يجب أن تكون داخل السيارة')
    end
end

function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject
		if skin.sex == 0 then
			uniformObject = Config.Uniforms[uniform].male
		else
			uniformObject = Config.Uniforms[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	end)
end


function AccsMenu(job, grade)
	local elements2 = {}
	if job == 'environmental' then
		table.insert(elements2, {label = '<font color=gray>سترة المارشل</font>', value = 'bullet_environmental'})
		table.insert(elements2, {label = 'ازالة <font color=gray>سترة</font>', value = 'remove_bullet_wear'})
		table.insert(elements2, {label = '<font color=#808080>سترة FBI</font>', value = 'boreh_add'})
		if grade >= 7 then
			table.insert(elements2, {label = '<font color=#66FF66>حزام</font>', value = 'hzam'})
			table.insert(elements2, {label = '<font color=#66FF66>ازالة الحزام</font>', value = 'remove_hzam'})
			table.insert(elements2, {label = '<font color=#FF0000>خوذة حماية الرأس مفتوحة</font>', value = 'helmet_open_environmental'})
			table.insert(elements2, {label = '<font color=#FF0000>خوذة حماية الرأس مغلقة</font>', value = 'helmet_close_environmental'})
			table.insert(elements2, {label = '<font color=#808080>كاب تدريب</font>', value = 'helmet_2_1'})
		--	table.insert(elements2, {label = '<font color=#808080>بريهة اسود</font>', value = 'helmet_2_2'})
			table.insert(elements2, {label = '<font color=#808080>ازالة اي غطاء راس</font>', value = 'helmet_remove'})
			table.insert(elements2, {label = 'سلاح على قدم واحده', value = 'weapon_one_in_rgl'})
			table.insert(elements2, {label = 'ازالة سلاح على قدم واحده', value = 'remove_weapon_one_in_rgl'})
		end
	end
	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'cloakroom_accs', {
		title    = '<font color=ef6c00>قائمة الإكسسوارات</font>',
		align = 'top-left', 
		elements = elements2
	}, function(data2, menu2)
		if data2.current.value == 'bullet_environmental' then
			setUniform("bullet_environmental", PlayerPedId())
			AddArmourToPed(PlayerPedId(), 100)
			SetPedArmour(PlayerPedId(), 100)
		elseif data2.current.value == "remove_bullet_wear" then
			setUniform("remove_bullet_wear", PlayerPedId())
			AddArmourToPed(PlayerPedId(), 0)
			SetPedArmour(PlayerPedId(), 0)
		else
			setUniform(data2.current.value, PlayerPedId())
		end
	end, function(data2, menu2) 
		menu2.close()
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local gradee = ESX.PlayerData.job.grade
	local grade = ESX.PlayerData.job.grade_name
	local gradel = ESX.PlayerData.job.grade_label

	local elements = {
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = "تسجيل دخول بنفس اللبس", value = 'login'},
		--[[
		{label = _U('bullet_wear'), uniform = 'bullet_wear'},
		--{label = _U('gilet_wear'), uniform = 'gilet_wear'},
		{label = _U('rsme_wear'), uniform = 'rsme_wear'},
		{label = '<font color=green>'..gradel..' 💂‍</font>', uniform = grade}
		--]]
	}
	if gradee >= 0 then
		table.insert(elements, {label = '<font color=deb887> أدارة المارشل - كم طويل 👨‍✈️</font>', uniform = gradee, type = '7rs_1'})
	end
	if gradee >= 0 then
		table.insert(elements, {label = '<font color=deb887> أدارة المارشل - كم قصير 👨‍✈️</font>', uniform = gradee, type = '7rs_2'})
	end

	if gradee >= 4 then
		table.insert(elements, {label = '<font color=deb887> أدارة المارشل - تدخل سريع 👨‍✈️</font>', uniform = gradee, type = '7rs_3'})
	end
	if gradee >= 0 then
		table.insert(elements, {label = '<font color=deb887> أدارة المارشل - FBI 👨‍✈️</font>', uniform = gradee, type = '7rs_4'})
	end
	if gradee >= 0 then
		table.insert(elements, {label = '<font color=deb887> أدارة المارشل - التدريب 👨‍✈️</font>', uniform = gradee, type = '7rs_5'})
	end
	if grade == 'bosstwo' then    --17
	    table.insert(elements, {label = '<font color=cc0000>نائب قائد أدارة المارشل - أدارة المارشل 🚧</font>', uniform = gradee})
		for i = 0, 16 do 
			table.insert(elements, {label = '<font color=cc0000>رتبة رقم '..i..' - أدارة المارشل 🚧</font>', uniform = 0})
		end
		-- table.insert(elements, {label = '<font color=616161>القوات الخاصة 💂</font>', uniform = 'bullet_swat'}) -- القوات الخاصة

	elseif grade == 'boss' then    --18
	    table.insert(elements, {label = '<font color=cc0000>قائد أدارة المارشل - أدارة المارشل 🚧</font>', uniform = gradee})
		-- table.insert(elements, {label = '<font color=616161>القوات الخاصة 💂</font>', uniform = 'bullet_swat'}) -- القوات الخاصة
		for i = 0, 16 do 
			table.insert(elements, {label = '<font color=cc0000>رتبة رقم '..i..' - أدارة المارشل 🚧</font>', uniform = i })
		end
	end

	table.insert(elements, {label = '<font color=ef6c00>قائمة الإكسسوارات</font>', value = 'accs'})

	if Config.EnableCustomPeds then
		for k,v in ipairs(Config.CustomPeds.shared) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end

		for k,v in ipairs(Config.CustomPeds[grade]) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)
		if data.current.uniform then
			setUniform2(data.current.uniform, playerPed, data.current.type, grade)
		end
		if data.current.value == 'citizen_wear' then
			TriggerServerEvent('esx_mecanojob:n89andzaed', 'na89_environmental')
		    playerInService = false -- addon service
			if Config.EnableCustomPeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.EnableESXService then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'environmental')

						TriggerServerEvent('esx_service:disableService', 'environmental')
						TriggerEvent('esx_environmentaljob:updateBlip')
						ESX.ShowNotification(_U('service_in'), "error")
					end
				end, 'environmental')
			end
		end

		if data.current.value == "login" then
			isOnDuty = true -- addon service
			ESX.ShowNotification(_U('service_in'), "success")
			playerInService = true
			TriggerServerEvent('esx_environmentaljob:sendToAllPlayersNotficiton', ESX.PlayerData.job.grade_label)
		end

		if data.current.value == "accs" then
			AccsMenu(ESX.PlayerData.job.name, ESX.PlayerData.job.grade)
		end

		if Config.EnableESXService and data.current.value ~= 'citizen_wear' then
			local awaitService

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					if Config.MaxInService == -1 then
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							
							awaitService = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'environmental')
							TriggerEvent('esx_environmentaljob:updateBlip')
							ESX.ShowNotification(_U('service_in'), "success")
						end, 'environmental')
					else 
						awaitService = true
						playerInService = true

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'environmental')
						TriggerEvent('esx_environmentaljob:updateBlip')
						ESX.ShowNotification(_U('service_in'), "success")
					end

				else
					awaitService = true
				end
			end, 'environmental')

			while awaitService == nil do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not awaitService then
				return
			end
		end

		if data.current.uniform == 'bullet_swat' then
			isOnDuty = true -- addon service
			setUniform("bullet_swat", playerPed)
			ESX.ShowNotification(_U('service_in'), "success")
			playerInService = true
			TriggerServerEvent('esx_environmentaljob:sendToAllPlayersNotficiton', ESX.PlayerData.job.grade_label)
		elseif data.current.uniform == 'bullet_wear' then
			setUniform("bullet_wear", playerPed)
		elseif data.current.uniform then
			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
				isOnDuty = true -- addon service
				--setUniform(data.current.uniform, playerPed)
				ESX.ShowNotification(_U('service_in'), "success")
				playerInService = true
				TriggerServerEvent('esx_environmentaljob:sendToAllPlayersNotficiton', ESX.PlayerData.job.grade_label)
			end, 'environmental')
		elseif data.current.value == 'freemode_ped' then
			local modelHash

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)
					SetPedDefaultComponentVariation(PlayerPedId())

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('buy_weapons'), value = 'buy_weapons'}
	}

	if Config.EnableArmoryManagement then
		table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		table.insert(elements, {label = _U('put_weapon'),     value = 'put_weapon'})
		table.insert(elements, {label = _U('remove_object'),  value = 'get_stock'})
		table.insert(elements, {label = _U('deposit_object'), value = 'put_stock'})
	end

	table.insert(elements, {label = 'أخذ مكبر صوت من الخزنة', value = 'get_megaphone'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'get_megaphone' then
			TriggerServerEvent('yusuf:getMegaphone')
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

local bulletproof_cooltime = 0

function OpenPersonalMenu()

	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade

	local elements = {}
		table.insert(elements2, {label = '<font color=gray>سترة المارشل</font>', value = 'bullet_environmental'})
		table.insert(elements2, {label = 'ازالة <font color=gray>سترة المارشل</font>', value = 'remove_bullet_wear'})
		table.insert(elements2, {label = '<font color=#808080>سترة FBI</font>', value = 'boreh_add'})
		if grade >= 7 then
			table.insert(elements2, {label = '<font color=#66FF66>حزام</font>', value = 'hzam'})
			table.insert(elements2, {label = '<font color=#66FF66>ازالة الحزام</font>', value = 'remove_hzam'})
			table.insert(elements2, {label = '<font color=#FF0000>خوذة حماية الرأس مفتوحة</font>', value = 'helmet_open_environmental'})
			table.insert(elements2, {label = '<font color=#FF0000>خوذة حماية الرأس مغلقة</font>', value = 'helmet_close_environmental'})
			table.insert(elements2, {label = '<font color=#808080>كاب تدريب</font>', value = 'helmet_2_1'})
			--table.insert(elements2, {label = '<font color=#808080>بريهة اسود</font>', value = 'helmet_2_2'})
			table.insert(elements2, {label = '<font color=#808080>ازالة اي غطاء راس</font>', value = 'helmet_remove'})
			table.insert(elements2, {label = 'سلاح على قدم واحده', value = 'weapon_one_in_rgl'})
			table.insert(elements2, {label = 'ازالة سلاح على قدم واحده', value = 'remove_weapon_one_in_rgl'})
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personal_menu',
	{
		title    = _U('personal_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data2, menu2)

		if data2.current.value == 'bullet_environmental' then
			setUniform("bullet_environmental", PlayerPedId())
			AddArmourToPed(PlayerPedId(), 100)
			SetPedArmour(PlayerPedId(), 100)
		--[[	Citizen.CreateThread(function()
				bulletproof_cooltime = Config.bulletproof_cooltime
				while bulletproof_cooltime ~= 0 do
					Citizen.Wait(60000)
					bulletproof_cooltime = bulletproof_cooltime -1
				end
			end)]]
		elseif data2.current.value == "remove_bullet_wear" then
			setUniform("remove_bullet_wear", PlayerPedId())
			AddArmourToPed(PlayerPedId(), 0)
			SetPedArmour(PlayerPedId(), 0)
		else
			--setUniform(data2.current.value, PlayerPedId())
		end

	end, function(data2, menu2)
		menu2.close()
	end)
end



function OpenenvironmentalActionsMenu()      
    local grade = ESX.PlayerData.job.grade

	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = '<span style="color:">🧑🏻 التعامل مع الأفراد</span>', value = 'citizen_interaction'},
		{label = '<span style="color:">🚗 التعامل مع المركبات</span>', value = 'vehicle_interaction'},
		{label = _U('object_spawner'), value = 'object_spawner'},
		{label = "<span style='color:#FF0000'>معلومات الأستنفارات ⚠️</span>", value = "get_info_astnfar"},
		{label = '<span style="color:#7CFC00">حالة أفراد أدارة المارشل 🕴</span>', value = "status_environmental"}
	}
	


	if grade >= 1 then
		table.insert(elements, {label = _U('Panic_Button_Menu'), value = 'Panic_Button_Menu'})
	end

	table.insert(elements, {label = _U('personal_menu'), value = 'personal_menu'})

	--table.insert(elements, {label = "موقع التصدير 🛳️", value = 'mina'})

	table.insert(elements, {label = "<font color=green>تغيير المسمى الميداني 🎫</font>", value = "change_name_in_radio"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'environmental_actions', {
		title    = '<span style="color:#7FFF00">أدارة المارشل</span>',
		align    = 'top-left',
		elements = elements
		}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'), value = 'identity_card'},
				{label = _U('search'), value = 'search'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
				{label = _U('fine'), value = 'fine'},
				{label = _U('unpaid_bills'), value = 'unpaid_bills'},
				{label = _U('jail_menu'), value = 'jail_menu'},
				{label = _U('criminalrecordsenvironmental'), value = 'criminalrecordsenvironmental'}
				--{label = _U('community_service'), value = 'communityservice'}
			}
			if Config.EnableLicenses then
				table.insert(elements, {label = _U('license_check'), value = 'license'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = '<span style="color:#7CFC00">🧑🏻 التعامل مع الأفراد</span>',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'search' then
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then 
					    TriggerEvent('esx_misc:togglehandcuff')
					elseif action == 'drag' then
					    TriggerServerEvent('esx_misc:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
					    TriggerServerEvent('esx_misc:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_misc:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					elseif action == 'jail_menu' then
						ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "مدة السجن"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("يجب ان يكون الوقت ب الدقائق")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("No players nearby!")
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "سبب السجن"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								ESX.ShowNotification("سجب ملئ سبب سجن الاعب")
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("لايوجد لاعب قريب منك")
								else
								  	TriggerServerEvent("esx_jail:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)	
                    elseif action == 'criminalrecordsenvironmental' then -- criminalrecordsenvironmental
						OpenCriminalRecordsenvironmental(closestPlayer)						
					elseif action == 'communityservice' then
                    	SendToCommunityService(GetPlayerServerId(closestPlayer))				
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == "status_environmental" then
			ESX.TriggerServerCallback("esx_environmentaljob:getStatusenvironmental", function(data)
				local elements = {}
				for k,v in pairs(data) do
					table.insert(elements, {label = data[k].label})
				end
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "status_environmental", {
					title = '<span style="color:#7CFC00">حالة أفراد أدارة المارشل 🕴</span>',
					align = "top-left",
					elements = elements
				}, function(data, menu)
				end, function(data, menu)
					menu.close()
				end)
			end)
		elseif data.current.value == "get_info_astnfar" then
			local elements = {}
			ESX.TriggerServerCallback("esx_wesam:esx_misc:getListAstnfarStateTrue", function(data)
				for k,v in pairs(data) do
					table.insert(elements, {label = "<span style='color:#FF0000'>استنفار</span> رقم <font color=orange>" .. k .. "</font>", value = v})
				end
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "astnfar_list", {
					title = "قائمة <span style='color:#FF0000'>الأستنفارات</span>",
					align = "top-left",
					elements = elements
				}, function(data, menu)
					local elements2 = {}
					ESX.TriggerServerCallback("esx_wesam:esx_misc:getListPlayerInAstnfar", function(data_2)
						for k,v in pairs(data_2) do
							table.insert(elements2, {label = v.label})
						end
						ESX.UI.Menu.Open("default", GetCurrentResourceName(), "astnfar_list_2", {
							title = "قائمة <span style='color:#FF0000'>الأستنفارات</span>",
							align = "top-left",
							elements = elements2
						}, function(data2, menu2)
						end, function(data2, menu2)
							menu2.close()
						end)
					end, data.current.value)
				end, function(data, menu)
					menu.close()
				end)
			end)
		elseif data.current.value == "get_info_closest_player" then
			local eeee = {}
			local ped222 = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
			for k_s,playerNearby_s in ipairs(ped222) do
				ESX.TriggerServerCallback('esx_adminjob:getNameplayer', function(name_player_s)
					table.insert(eeee, {label = name_player_s.name, playerId = name_player_s.id, coords_player = name_player_s.coords_player})
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stretcher_menu3', {
						title		= 'حدد من الشخص',
						align		= 'top-left',
						elements	= eeee
					}, function(data3, menu3)
						menu3.close()
						TriggerEvent("esx_wesam:getInfoPlayerenvironmentalJob", data3.current.playerId)
					end, function(data3, menu3)
						menu2.close()
				end)
				end, GetPlayerServerId(playerNearby_s))
			end
		elseif data.current.value == "get_my_info_environmental_job" then
			TriggerEvent("esx_wesam:getInfoPlayerenvironmentalJob", GetPlayerServerId(PlayerId()))
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				--table.insert(elements, {label = _U('impound'), value = 'impound'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = '<span style="color:#FFFF00">🚗 التعامل مع المركبات</span>',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
						  DoActionImpound(10000)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'environmental_menu_revive' then
			ESX.TriggerServerCallback('getPlayerCheckOnlineBywesam:check', function(add_msafen)
				if add_msafen then
					ESX.ShowNotification('لايمكن انعاش الاعب لوجود مسعفين')
				elseif not add_msafen then
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					isBusyReviveenvironmental = true
					local eeee = {}
					local ped222 = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
					for k_s,playerNearby_s in ipairs(ped222) do
						ESX.TriggerServerCallback('esx_adminjob:getNameplayer', function(name_player_s)
							table.insert(eeee, {label = name_player_s.name, playerId = name_player_s.id, coords_player = name_player_s.coords_player})
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stretcher_menu3',
							{
								title		= 'حدد من المسقط',
								align		= 'top-left',
								elements	= eeee
							}, function(data3, menu3)
								menu3.close()
								revivePlayer(data3.current.playerId)
							end, function(data3, menu3)
								menu3.close()
						end)
						end, GetPlayerServerId(playerNearby_s))
					end
				end
			end, 'ambulance')
		elseif data.current.value == 'object_spawner' then
			TriggerEvent('zahya_objects:openSpawnMenu')
			--ExecuteCommand("objectspawn")
		elseif data.current.value == 'Panic_Button_Menu' then
			local elements = {
						{label = _U('ports_PB_Menu'),			value = 'ports_PB_Menu'},
						{label = _U('banks_PB_Menu'),			value = 'banks_PB_Menu'},
						{label = _U('public_garage_PB_Menu'),	value = 'public_garage_PB_Menu'},
						{label = _U('Other_PB_Menu'),			value = 'Other_PB_Menu'},
						{label = _U('my_place_PB_Menu'),		value = 'my_place_PB_Menu'},
			}
		
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'Panic_Button_Menu',
			{
				title    = _U('Panic_Button_Menu'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value
				local label = data2.current.label
				
				--START
				if action == 'ports_PB_Menu' then
				--start ports
					local elements = {
					{label = _U('sea_port'),				value = 'sea_port'},
					{label = _U('seaport_west'),			value = 'seaport_west'},
					{label = _U('international_airport'),	value = 'international_airport'},
					{label = _U('sandy_airport'),			value = 'sandy_airport'},
					{label = _U('farm_airport'),			value = 'farm_airport'},
					}
				
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'ports_PB_Menu',
					{
						title    = _U('Panic_Button_Menu')..' - '.._U('ports_PB_Menu'),
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3)
						local action = data3.current.value
						
						if action == 'sea_port' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'sea_port')
						elseif action == 'seaport_west' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'seaport_west')
						elseif action == 'international_airport' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'international_airport')
						elseif action == 'sandy_airport' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'sandy_airport')
						elseif action == 'farm_airport' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'farm_airport')
						end
						
					end, function(data3, menu3)
						menu3.close()
					end)
				--end ports
				elseif action == 'banks_PB_Menu' then
				--start banks
					--start menu
					local elements = {
						--add menu elements
						
						{label = _U('pacific_bank'),value = 'pacific_bank'},
						{label = _U('paleto_bank'),	value = 'paleto_bank'},
						{label = _U('sandy_bank'),	value = 'sandy_bank'},
					}
				
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'banks_PB_Menu',
					{
						title    = _U('Panic_Button_Menu')..' - '.._U('banks_PB_Menu'), --menu tittle
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3) --change data menu number
						local action = data3.current.value
						--add if statment to excute
						if action == 'pacific_bank' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'pacific_bank')
						elseif action == 'paleto_bank' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'paleto_bank')
						elseif action == 'sandy_bank' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'sandy_bank')
						end
						
					end, function(data3, menu3) --change data menu number
						menu3.close()
					end)
					--end menu	
				--end banks
				elseif action == 'public_garage_PB_Menu' then
				--start public_garage
					--start menu
					local elements = {
						--add menu elements
						{label = _U('public_car_garage_los_santos'),value = 'public_car_garage_los_santos'},
						{label = _U('public_car_garage_sandy'),		value = 'public_car_garage_sandy'},
						{label = _U('public_car_garage_paleto'),	value = 'public_car_garage_paleto'},
					}
				
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'public_garage_PB_Menu',
					{
						title    = _U('Panic_Button_Menu')..' - '.._U('public_garage_PB_Menu'), --menu tittle
						align    = 'top-left',
						elements = elements
					}, function(data3, menu3) --change data menu number
						local action = data3.current.value
						--add if statment to excute
						if action == 'public_car_garage_los_santos' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'public_car_garage_los_santos')
						elseif action == 'public_car_garage_sandy' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'public_car_garage_sandy')
						elseif action == 'public_car_garage_paleto' then
							TriggerServerEvent("esx_misc:TogglePanicButton", 'public_car_garage_paleto')
						end
						
					end, function(data4, menu4) --change data menu number
						menu4.close()
					end)
					--end menu	
				--end public_garage
				elseif action == 'Other_PB_Menu' then
					--start 
						--start menu
						local elements = {
							--add menu elements
							{label = _U('alshaheed_gardeen'),			value = 'alshaheed_gardeen'},
							--{label = _U('army_base'),					value = 'army_base'},
							--{label = _U('white_house'),					value = 'white_house'},
							--{label = _U('cardealer_new'),				value = 'cardealer_new'},
							--{label = _U('aucation_house'),				value = 'aucation_house'},
						}
					
						ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'Other_PB_Menu',
						{
							title    = _U('Panic_Button_Menu')..' - '.._U('Other_PB_Menu'), --menu tittle
							align    = 'top-left',
							elements = elements
						}, function(data3, menu3) --change data menu number
							local action = data3.current.value
							--add if statment to excute
							if action == 'alshaheed_gardeen' then
								TriggerServerEvent("esx_misc:TogglePanicButton", 'alshaheed_gardeen')
							elseif action == 'army_base' then
								TriggerServerEvent("esx_misc:TogglePanicButton", 'army_base')
							elseif action == 'white_house' then
								TriggerServerEvent("esx_misc:TogglePanicButton", 'white_house')
							elseif action == 'cardealer_new' then
								TriggerServerEvent("esx_misc:TogglePanicButton", 'cardealer_new')
							elseif action == 'aucation_house' then
								TriggerServerEvent("esx_misc:TogglePanicButton", 'aucation_house')	
							end
							
						end, function(data3, menu3) --change data menu number
							menu3.close()
						end)
						--end menu	
				elseif action == 'my_place_PB_Menu' then
					local ped = PlayerPedId()
								local pedCoords = GetEntityCoords(ped)
								TriggerEvent("zahya_police_safe_zone:TogglePanicButton", pedCoords, 'my_location', 250.0)
				end		
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'mina' then
			local elements = {
			  	{label = _U('sea_port_close'), value = 'sea_port_close'},
				{label = _U('seaport_west_close'), value = 'seaport_west_close'},
				{label = _U('internationa_close'), value = 'internationa_close'},
			}
			if grade >= 7 then
			table.insert(elements,  {label = '⚓  تحويل موقع<span style="color:yellow;"> التصدير </span>', value = 'convert'})
		else
			table.insert(elements, {label = '<font color=gray>تحويل موقع التصدير متاح من رتبة ملازم</font>'})
		end	
			if grade >= 7 then
				table.insert(elements,  {label = '⚓  افتتاح<span style="color:yellow;"> التوسعات </span>', value = 'afttah_altws3at'})
			else
				table.insert(elements, {label = '<font color=gray>افتتاح التوسعات متاح من رتبة ملازم</font>'})
			end	
	  
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mina', {
			  title    = "🛳️ الميناء",
			  align    = 'bottom-right',
			  elements = elements
			}, function(data2, menu2)
			
			local action = data2.current.value
			local label = data2.current.label
			
			  if action == 'sea_port_close' or action == 'seaport_west_close' or action == 'internationa_close' then
				 -------------------------------
		    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_menu', {
                    title    = 'تأكيد أعلان '..label,
                    align    = 'bottom-right',
                    elements = {
							{label = '<span style="color:red">رجوع</span>',  value = 'no'},
							{label = '<span style="color:green">نعم</span>', value = 'yes'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'yes' then
							local pedCoords = vector3(1025.65,-3116.86,5.9)
							TriggerEvent("zahya_police_safe_black_zone:TogglePort", pedCoords, 'restricted_area', 320.0)
							TriggerServerEvent("esx_misc:TogglePanicButton", action)
						--	TriggerServerEvent("esx_misc:TogglePanicButton", action)
						end
						menu2.close()
					end, function(data2, menu2) menu2.close() end)
			-------------------------------
			  elseif data2.current.value == 'afttah_altws3at' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
					title    = "افتتاح توسعة",
					align    = 'bottom-right',
					elements = {
					  {label = 'توسعة <span style="color:green">1', value = 'tws3h_1'},
					  {label = 'توسعة <span style="color:green">2', value = 'tws3h_2'},
					  {label = 'توسعة <span style="color:green">3', value = 'tws3h_3'},
					  {label = 'توسعة <span style="color:green">4', value = 'tws3h_4'}
					}
				  }, function(data2, menu2)
					if data2.current.value == 'tws3h_1' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf2irm_menu', {
							title    = 'تأكيد تحويل موقع التصدير الى 1 الميناء البحري توسعة ' .. '<span style="color:green"> توسعة 1',
							align    = 'bottom-right',
							elements = {
							  {label = '<span style="color:red">رجوع</span>',  value = 'no'},
							  {label = '<span style="color:green">نعم</span>', value = 'yes'},
						  }
					  }, function(data3, menu3)
						  if data3.current.value == 'yes' then
							TriggerServerEvent("esx_misc:togglePort", 11)
						  end
						  menu3.close()
					  end, function(data3, menu3) menu3.close() end)
					elseif data2.current.value == 'tws3h_2' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf2irm_menu', {
							title    = 'تأكيد تحويل موقع التصدير الى 2 الميناء البحري توسعة ' .. '<span style="color:green"> توسعة 2',
							align    = 'bottom-right',
							elements = {
							  {label = '<span style="color:red">رجوع</span>',  value = 'no'},
							  {label = '<span style="color:green">نعم</span>', value = 'yes'},
						  }
					  }, function(data3, menu3)
						  if data3.current.value == 'yes' then
							TriggerServerEvent("esx_misc:togglePort", 12)
						  end
						  menu3.close()
					  end, function(data3, menu3) menu3.close() end)
					elseif data2.current.value == 'tws3h_3' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf2irm_menu', {
							title    = 'تأكيد تحويل موقع التصدير الى 3 الميناء البحري توسعة ' .. '<span style="color:green"> توسعة 3',
							align    = 'bottom-right',
							elements = {
							  {label = '<span style="color:red">رجوع</span>',  value = 'no'},
							  {label = '<span style="color:green">نعم</span>', value = 'yes'},
						  }
					  }, function(data3, menu3)
						  if data3.current.value == 'yes' then
							TriggerServerEvent("esx_misc:togglePort", 13)
						  end
						  menu3.close()
					  end, function(data3, menu3) menu3.close() end)
					elseif data2.current.value == 'tws3h_4' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf2irm_menu', {
							title    = 'تأكيد تحويل موقع التصدير الى 4 الميناء البحري توسعة ' .. '<span style="color:green"> توسعة 4',
							align    = 'bottom-right',
							elements = {
							  {label = '<span style="color:red">رجوع</span>',  value = 'no'},
							  {label = '<span style="color:green">نعم</span>', value = 'yes'},
						  	}
					  	}, function(data3, menu3)
						  	if data3.current.value == 'yes' then
								TriggerServerEvent("esx_misc:togglePort", 14)
						  	end
						  		menu3.close()
					  	end, function(data3, menu3) 
							menu3.close() 
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			  elseif data2.current.value == 'convert' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				  title    = "تحويل الموانئ",
				  align    = 'bottom-right',
				  elements = {
					{label = 'الميناء البحري الرئيسي', value = 'main'},
					{label = 'الميناء البحري الغربي', value = 'west'},
					--{label = 'مطار الملك عبدالعزيز الدولي', value = 'airport'}
					{label = '<font color=gray>مطار الملك عبدالعزيز الدولي متاح لالرقابة و التفتيش فقط</font>'}
				  }
				}, function(data2, menu2)
				  if data2.current.value == 'main' then
				    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf2irm_menu', {
                  title    = 'تأكيد تحويل موقع التصدير الى الميناء البحري الرئيسي',
                  align    = 'bottom-right',
                  elements = {
					{label = '<span style="color:red">رجوع</span>',  value = 'no'},
					{label = '<span style="color:green">نعم</span>', value = 'yes'},
				}
			}, function(data3, menu3)
				if data3.current.value == 'yes' then
					TriggerServerEvent("esx_misc:togglePort", 1)
				end
				menu3.close()
			end, function(data3, menu3) menu3.close() end)
			elseif data2.current.value == 'west' then
				  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_mdenu', {
                  title    = 'تأكيد تحويل موقع التصدير الى الميناء البحري الغربي',
                  align    = 'bottom-right',
                  elements = {
					{label = '<span style="color:red">رجوع</span>',  value = 'no'},
					{label = '<span style="color:green">نعم</span>', value = 'yes'},
				}
			}, function(data3, menu3)
				if data3.current.value == 'yes' then
					TriggerServerEvent("esx_misc:togglePort", 2)
				end
				menu3.close()
			end, function(data3, menu3) menu3.close() end)
				  elseif data2.current.value == 'airport' then
				    ESX.UI.Menu.CloseAll()				  
					local msg = '<font size=5 color=white>جاري التنفيذ'
				    TriggerEvent('pogressBar:drawBar', 1000, msg)
					Citizen.Wait(1050)			
					TriggerEvent("wesam:client:mina:airport")
					ExecuteCommand("changemina 3")
				  end
				end, function(data2, menu2)
				  menu2.close()
				end)
			  end
			end, 
			function(data2, menu2)
			  menu2.close()
			end)		 
		elseif data.current.value == 'personal_menu' then
			OpenPersonalMenu()			 
		elseif data.current.value == "change_name_in_radio" then
            ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "change_name_in_radio_menu", {
                title = "اكتب المسمى الميداني الجديد"
            }, function(data, menu)
                local name_new = data.value
                if name_new == nil or name_new == "" then
                    ESX.ShowNotification("رجاء اكتب اي شي")
                else
                    menu.close()
                    ExecuteCommand("nameinradio " .. name_new)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
	end, function(data, menu)
		menu.close()
	end)
end

  function DoActionImpound(waitime)
	  disableAllControlActions = true
	  local playerPed = PlayerPedId()
	  local coords    = GetEntityCoords(playerPed)
	  local found = false
	  
	  for locationNumber,data in pairs(Config.impound.location) do	
		--   local dist = GetDistanceBetweenCoords(coords,data.coords)
		  local dist = #(coords - data.coords)
		  if dist <= data.radius then
			  found = true
			  Citizen.CreateThread(function()
				  while disableAllControlActions do
					  Citizen.Wait(0)
					  DisableAllControlActions(0) --disable all control (comment it if you want to detect how many time key pressed)
					  EnableControlAction(0, 249, true)  -- N
					  EnableControlAction(0, 311, true)  -- K
					  EnableControlAction(0, 1, true) -- Disable pan
					  EnableControlAction(0, 2, true) -- Disable tilt
				  end
			  end)
			  
			  if IsPedSittingInAnyVehicle(playerPed) then
				  ESX.ShowNotification(_U('inside_vehicle'))
				  return
			  end
			  
			  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				  local vehicle = nil
			  
				  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
				  --vehicle = ESX.Game.GetVehicleInDirection()
				  
				  if DoesEntityExist(vehicle) then
					  --------------------------
					  ESX.TriggerServerCallback('esx_environmentaljob:canMechanicImpound', function(canImpound)
						  if canImpound then
							  TriggerEvent('pogressBar:drawBar', waitime, '<font size=5>حجز المركبة')
							  Citizen.Wait(1500)
							  TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							  Citizen.CreateThread(function()
								  Citizen.Wait(waitime-3000)
								  --ESX.Game.DeleteVehicle(vehicle)
								  AdvancedOnesyncDeleteVehicle(vehicle)
								  ClearPedTasksImmediately(playerPed)
								--  TriggerServerEvent('esx_environmentaljob:impoundvehicle', vehicle)
								  Citizen.Wait(1500)
								  disableAllControlActions = false
								  if Config.EnableJobLogs == true then
									  --TriggerServerEvent('esx_joblogs:AddInLog', "mecano", "del_vehicle", GetPlayerName(PlayerId()))
								  end
							  end)
						  else
							  disableAllControlActions = false
						  end
					  end,locationNumber)
				  else
					  ESX.ShowNotification(_U('no_vehicle_nearby'))
					  disableAllControlActions = false
				  end	
			  else
				  ESX.ShowNotification(_U('no_vehicle_nearby'))
				  disableAllControlActions = false
			  end
		  end	
	  end
	  if not found then 
			TriggerEvent("pNotify:SendNotification", {
		text = "<h1><center><font color=orange><i>يجب سحب المركبة الى أقرب كراج حجز</font> او لأقرب مركز حراسات</i></font></h1></b></center> <br /><br /><div align='right'> <b style='color:White;font-size:50px'><font size=5 color=White><font color=green></font>",
		type = 'alert',
		queue = left,
		timeout = 4500,
		killer = false,
		theme = "gta",
		layout = "CenterLeft",
	})
	--PlaySoundFrontend(source, "OTHER_TEXT", "HUD_AWARDS", true)
		  
		  disableAllControlActions = true
		  EnableControlAction(0, 249, true)  -- N
		  EnableControlAction(0, 311, true)  -- K
	  end
  end

  function AdvancedOnesyncDeleteVehicle(vehicle)
	  ESX.Game.DeleteVehicle(vehicle)
	  
	  local entity = vehicle
	  carModel = GetEntityModel(entity)
	  carName = GetDisplayNameFromVehicleModel(carModel)
	  NetworkRequestControlOfEntity(entity)
	  
	  local timeout = 2000
	  while timeout > 0 and not NetworkHasControlOfEntity(entity) do
		  Wait(100)
		  timeout = timeout - 100
	  end
  
	  SetEntityAsMissionEntity(entity, true, true)
	  
	  local timeout = 2000
	  while timeout > 0 and not IsEntityAMissionEntity(entity) do
		  Wait(100)
		  timeout = timeout - 100
	  end
  
	  Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
	  
	  if (DoesEntityExist(entity)) then 
		  DeleteEntity(entity)
	  end 
  end
  function revivePlayer(closestPlayer)
	isBusyReviveenvironmental = true
	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			--TriggerServerEvent('esx_ambulancejob:setPlayerDeadAnim', closestPlayer, true)
			ESX.TriggerServerCallback("esx_ambulancejob:checkPlayerIsDead", function(data)
				if data then
					local playerPed = PlayerPedId()
					local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
					ESX.ShowNotification(_U('revive_inprogress'))
					--TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 8.0, 'ems', 0.8)
					local position = GetEntityCoords(PlayerPedId())
					PlayerPanicSound(position)
					for i=1, 15 do
						Citizen.Wait(900)

						ESX.Streaming.RequestAnimDict(lib, function()
							TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
						end)
					end

					TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
					TriggerServerEvent('esx_ambulancejob:revive', closestPlayer)
					--TriggerServerEvent('esx_ambulancejob:setPlayerDeadAnim', closestPlayer, false)
					Timmingg = 60
				else
					ESX.ShowNotification(_U('player_not_unconscious'))
				end
			end, closestPlayer)
		else
			ESX.ShowNotification(_U('not_enough_medikit'))
		end
		isBusyReviveenvironmental = false
	end, 'medikit')
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {
			{label = _U('name', data.name)},
			{label = _U('job', ('%s - %s'):format(data.job, data.grade))}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = _U('sex', _U(data.sex))})
			table.insert(elements, {label = _U('dob', data.dob)})
			table.insert(elements, {label = _U('height', data.height)})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenCriminalRecordsenvironmental(closestPlayer) -- سجل أدارة المارشل
    ESX.TriggerServerCallback('esx_qalle_brottsregister:grab_environmental', function(crimes)

        local elements = {}

        table.insert(elements, {label = 'إضافة سجل حراسات أمنية', value = 'crime'})
        table.insert(elements, {label = '----= السجلات =----', value = 'spacer'})

        for i=1, #crimes, 1 do
            table.insert(elements, {label = crimes[i].date .. ' - ' .. crimes[i].crime, value = crimes[i].crime, name = crimes[i].name})
        end


        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'brottsregister',
            {
                title    = 'سجل أدارة المارشل',
				align = 'bottom-right',
                elements = elements
            },
        function(data2, menu2)

            if data2.current.value == 'crime' then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'brottsregister_second',
                    {
                        title = 'التهمة?'
                    },
                function(data3, menu3)
                    local crime = (data3.value)

                    if crime == tonumber(data3.value) then
                        ESX.ShowNotification('حصل خطئ')
                        menu3.close()               
                    else
                        menu2.close()
                        menu3.close()
                        TriggerServerEvent('esx_qalle_brottsregister:add_environmental', GetPlayerServerId(closestPlayer), crime)
                        ESX.ShowNotification('تم إضافة سجل أدارة المارشل بنجاح')
                        Citizen.Wait(100)
                        OpenCriminalRecords(closestPlayer)
                    end

                end,
            function(data3, menu3)
                menu3.close()
            end)               
        end

        end,
        function(data2, menu2)
            menu2.close()
        end)

    end, GetPlayerServerId(closestPlayer))
end -- إنتهاء سجل أدارة المارشل

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_wesam:checkPlayerIsDead', function(data_check)
		if not data_check.status then
			ESX.TriggerServerCallback('esx_environmentaljob:getOtherPlayerData', function(data)
				local elements = {}

				for i=1, #data.accounts, 1 do
					if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
						table.insert(elements, {
							label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
							value    = 'black_money',
							itemType = 'item_account',
							amount   = data.accounts[i].money
						})

						break
					end
				end

				table.insert(elements, {label = _U('guns_label')})

				for i=1, #data.weapons, 1 do
					table.insert(elements, {
						label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
						value    = data.weapons[i].name,
						itemType = 'item_weapon',
						amount   = data.weapons[i].ammo
					})
				end

				table.insert(elements, {label = _U('inventory_label')})

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 then
						table.insert(elements, {
							label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
							value    = data.inventory[i].name,
							itemType = 'item_standard',
							amount   = data.inventory[i].count
						})
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
					title    = _U('search'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if data.current.value then
						TriggerServerEvent('esx_environmentaljob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
						OpenBodySearchMenu(player)
					end
				end, function(data, menu)
					menu.close()
				end)
			end, data_check.id_player)
		end
	end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3},		
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

local Cooldown_count = 0
	
function Cooldown(sec)
	CreateThread(function()
		Cooldown_count = sec
		while Cooldown_count ~= 0 do
			Cooldown_count = Cooldown_count - 1
			Wait(1000)
		end	
		Cooldown_count = 0
	end)	
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_environmentaljob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
            if Cooldown_count == 0 then
				Cooldown(10)
				billPass = 'a82mKba0bma2'
				if Config.EnablePlayerManagement then
					TriggerServerEvent('esx_billing:sendKBill_28vn2', billPass, GetPlayerServerId(player), 'society_environmental', _U('fine_total', data.current.fineLabel), data.current.amount)
				else
					TriggerServerEvent('esx_billing:sendKBill_28vn2', billPass, GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
				end
				ESX.UI.Menu.CloseAll()
			else
				ESX.ShowNotification('<font color=red>يجب الأنتظار</font>. <font color=orange>'..Cooldown_count..' ثانية')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if not data.value or length < 2 or length > 8 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
				ESX.TriggerServerCallback('esx_policejob:getRentedVehicleInfos', function(retrivedRentedInfo)
					local elements = {{label = _U('plate', retrivedInfo.plate)}}
					menu.close()

					if not retrivedInfo.owner then
						table.insert(elements, {label = _U('owner_unknown')})
					else
						table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
					end

					if retrivedRentedInfo.owner then
						table.insert(elements, {label = _U('renter', retrivedRentedInfo.owner)})			
					else
						table.insert(elements, {label = _U('not_rented')})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
						title    = _U('vehicle_info'),
						align    = 'top-left',
						elements = elements
					}, nil, function(data2, menu2)
						menu2.close()
					end)
				end, data.value)				
			end, data.value)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_environmentaljob:getOtherPlayerData', function(playerData)
		if playerData.licenses then
			for i=1, #playerData.licenses, 1 do
				if playerData.licenses[i].label and playerData.licenses[i].type then
					table.insert(elements, {
						label = playerData.licenses[i].label,
						type = playerData.licenses[i].type
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, playerData.name))
			TriggerServerEvent('esx_environmentaljob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)
			
			TriggerServerEvent('license_revokeLog:msg', ('سحب رخص أدارة المارشل '), "***سحب {"..data.current.label.." |"..data.current.type.."}***", " الحارس الذي سحب \n steam `"..GetPlayerName(PlayerId()).."` \n المواطن steam`"..GetPlayerName(player).."`", 15158332) -- justtest1

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bill.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function SendToCommunityService(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
		title = "قائمة الأعمال الشاقة",
	}, function (data2, menu)
		local community_services_count = tonumber(data2.value)
		
		if community_services_count == nil then
			ESX.ShowNotification('عدد اعمال شاقة خاطئ')
		else
			TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
	    ESX.TriggerServerCallback('esx_policejob:getRentedVehicleInfos', function(retrivedRentedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if not retrivedInfo.owner then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		if retrivedRentedInfo.owner then
			table.insert(elements, {label = _U('renter', retrivedRentedInfo.owner)})			
		else
			table.insert(elements, {label = _U('not_rented')})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
		end, vehicleData.plate)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_environmentaljob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_environmentaljob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_environmentaljob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	for k,v in ipairs(Config.AuthorizedWeapons[ESX.PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_environmentaljob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'top-left',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_environmentaljob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_environmentaljob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('environmental_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_environmentaljob:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_environmentaljob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_environmentaljob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('esx_environmentaljob:forceBlip')
	isOnDuty = false -- addon service
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_environmental'),
		number     = 'environmental',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkwshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHwshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'environmental' and ESX.PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_environmentaljob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Liverys' then
		CurrentAction     = 'menu_Liverys'
		CurrentActionMsg  = _U('open_Liverys')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Vehicles2' then
		CurrentAction     = 'menu_vehicle_spawner2'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Tasleem' then
		CurrentAction     = 'Tasleem'
		CurrentActionMsg  = _U('Tasleem')
		CurrentActionData = {station = station}
	elseif part == 'deleteRecord' then
		CurrentAction     = 'deleteRecord'
		CurrentActionMsg  = _U('deleteRecord')
		CurrentActionData = {station = station}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}		
	end
end)

AddEventHandler('esx_environmentaljob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_environmentaljob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'environmental' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity_'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_environmentaljob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_environmentaljob:handcuff')
AddEventHandler('esx_environmentaljob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed, true)
		DisplayRadar(false)

		if Config.EnableHandcuffTimer then
			if handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

			StartHandcuffTimer()
		end
	else
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('esx_environmentaljob:unrestrain')
AddEventHandler('esx_environmentaljob:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('esx_environmentaljob:drag')
AddEventHandler('esx_environmentaljob:drag', function(copId)
	if isHandcuffed then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

Citizen.CreateThread(function()
	local wasDragged

	while true do
		Citizen.Wait(100)
		local playerPed = PlayerPedId()

		if isHandcuffed and dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Citizen.Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(playerPed, true, false)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_environmentaljob:putInVehicle')
AddEventHandler('esx_environmentaljob:putInVehicle', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)

RegisterNetEvent('esx_environmentaljob:OutVehicle')
AddEventHandler('esx_environmentaljob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 64)
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 243, true) -- Animations 2 "`/~"
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.environmentalStations) do
		if k == "remove_sglat" then
			--print()
		else
			local blip = AddBlipForCoord(v.Blip.Coords)

			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, v.Blip.Display)
			SetBlipScale  (blip, v.Blip.Scale)
			SetBlipColour (blip, v.Blip.Colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('map_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Draw markers and more
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(PlayerPedId())
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.environmentalStations) do
				if k == "remove_sglat" then
					for i=1, #v, 1 do
						local distance = #(playerCoords - v[i].Pos)

						if distance < Config.DrawDistance then
							DrawMarker(Config.MarkerType.deleteRecord, v[i].Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, v[i].job, 'deleteRecord', i
							end
						end
					end
				else
					if ESX.PlayerData.job.name == 'environmental' then
						for i=1, #v.Cloakrooms, 1 do
							local distance = #(playerCoords - v.Cloakrooms[i])

							if distance < Config.DrawDistance then
								DrawMarker(Config.MarkerType.Cloakrooms, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
								letSleep = false

								if distance < Config.MarkerSize.x then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
								end
							end
						end

						for i=1, #v.Armories, 1 do
							local distance = #(playerCoords - v.Armories[i])

							if distance < Config.DrawDistance then
								DrawMarker(Config.MarkerType.Armories, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
								letSleep = false

								if distance < Config.MarkerSize.x then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
								end
							end
						end

						for i=1, #v.Vehicles, 1 do
							local distance = #(playerCoords - v.Vehicles[i].Spawner)

							if distance < Config.DrawDistance then
								DrawMarker(Config.MarkerType.Vehicles, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
								letSleep = false

								if distance < Config.MarkerSize.x then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
								end
							end
						end

						for i=1, #v.Helicopters, 1 do
							local distance =  #(playerCoords - v.Helicopters[i].Spawner)

							if distance < Config.DrawDistance then
								DrawMarker(Config.MarkerType.Helicopters, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
								letSleep = false

								if distance < Config.MarkerSize.x then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
								end
							end
						end

						if v.Liverys then

							for i=1, #v.Liverys, 1 do
								local distance = #(playerCoords - v.Liverys[i])

								if distance < 30 then
									DrawMarker(Config.MarkerType.Liverys, v.Liverys[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, true, false, false, false)
									letSleep = false

									if distance < Config.MarkerSize.x then
										isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Liverys', i
									end
								end
							end

						end

						if v.Tasleem then
							for i=1, #v.Tasleem, 1 do
								local distance = #(playerCoords - v.Tasleem[i])
								if distance < Config.DrawDistance then
									DrawMarker(Config.MarkerType.Tasleem, v.Tasleem[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
									letSleep = false

									if distance < Config.MarkerSize.x then
										isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Tasleem', i
									end
								end
							end
						end

						if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'bosstwo' or ESX.PlayerData.job.grade_name == 'boss' then
							for i=1, #v.BossActions, 1 do
								local distance = #(playerCoords - v.BossActions[i])

								if distance < Config.DrawDistance then
									DrawMarker(Config.MarkerType.BossActions, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
									letSleep = false

									if distance < Config.MarkerSize.x then
										isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
									end
								end
							end
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_environmentaljob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_environmentaljob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_environmentaljob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.environmentalStations) do
		if k == "remove_sglat" then
			--print()
		else
			local blip = AddBlipForCoord(v.Blip.Coords)

			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, v.Blip.Display)
			SetBlipScale  (blip, v.Blip.Scale)
			SetBlipColour (blip, v.Blip.Colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('map_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_barrier_wat_03b',
		'prop_mp_barrier_02b',
		'prop_bollard_02a',
		'prop_barier_conc_05c',
		'prop_barier_conc_02a',
		'prop_air_sechut_01',
		'prop_parasol_05',
		'prop_barier_conc_05b',
		'prop_barrier_wat_01a',
		'prop_worklight_03b',
		'prop_worklight_01a',
		'prop_generator_03b',
		'prop_helipad_01',
		'prop_fncsec_03d',
		'prop_fncsec_03b',
		'prop_trailer_01_new',
		'stt_prop_track_slowdown_t2',
		'stt_prop_track_slowdown',
		'v_ilev_chair02_ped',
		'prop_mp_barrier_01b',
		'prop_ld_binbag_01', --سرير الاسعاف
		'prop_roadcone02a',
		'prop_barrier_work05',
		'prop_mp_arrow_barrier_01',
		'p_ld_stinger_s',
		'prop_air_lights_02a',
		'prop_air_lights_02b',
		'prop_air_lights_03a',
		'prop_worklight_01a',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full',
		'prop_cctv_pole_02',
		'prop_bbq_1',
		'prop_doghouse_01',
		'prop_gazebo_02',
		'prop_parasol_01_b',
		'prop_ven_market_table1',
		'prop_table_03_chr',
		'prop_off_chair_05',
		'prop_air_sechut_01',
		'prop_sol_chair',
		'prop_cctv_unit_04',
		'prop_cctv_pole_02',
		'prop_cctv_pole_03',
		'prop_mp_barrier_01',
		'prop_inflatearch_01',
		'prop_inflategate_01',
		'prop_start_gate_01',
		'prop_golfflag',
		--'prop_bollard_01b',
		'prop_fncsec_04a',
		'prop_fncsec_03c',
		'prop_fncsec_03d',
		'prop_barier_conc_05c',
		'prop_barier_conc_05b',
		'prop_barier_conc_01c',
		'prop_barier_conc_02c',
		'prop_conc_sacks_02a',
		'prop_barrier_wat_01a',
		'prop_container_03_ld',
		'prop_container_ld_d',
		'prop_fruitstand_b',
		'prop_ind_light_04',
		'prop_generator_03b',
		--'prop_atm_01',
		'prop_vintage_pump',
		--'prop_laptop_lester',
		--'prop_till_01',
		'prop_helipad_01',
		'prop_radiomast01',
		--'prop_champset',
		--'prop_vend_soda_01',
		'prop_skate_halfpipe_cr',
		'prop_skate_kickers',
		'prop_skate_spiner',
		'prop_skate_flatramp',
		'prop_tri_finish_banner',
		'prop_tri_start_banner',
		'prop_tv_cam_02',
		'prop_trailer_01_new',
		'stt_prop_track_slowdown_t1',
		'stt_prop_track_slowdown_t2',
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance = #(playerCoords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_environmentaljob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_environmentaljob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)



-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job then

				if CurrentAction == 'menu_cloakroom' and ESX.PlayerData.job.name == 'environmental' then
					Citizen.CreateThread(function() -- نظام الوقوف المؤقت
						while disableAllControlActions do
							Citizen.Wait(0)
							DisableAllControlActions(0)  -- Disable all controls
							EnableControlAction(0, 1, true) -- Disable pan
							EnableControlAction(0, 2, true) -- Disable tilt
						end
					end)
					local waitingTime = 1500 --وقت التسجيل
					disableAllControlActions = true
					local msg = '<font size=5 color=white>جاري التنفيذ'
					TriggerEvent('pogressBar:drawBar', waitingTime, msg)
					Citizen.Wait(waitingTime +100) 
					disableAllControlActions = false
					OpenCloakroomMenu()	
			elseif CurrentAction == 'menu_Liverys' and ESX.PlayerData.job.name == 'environmental' then
					if playerInService then
						Citizen.CreateThread(function() -- نظام الوقوف المؤقت
							while disableAllControlActions do
								Citizen.Wait(0)
								DisableAllControlActions(0)  -- Disable all controls
								EnableControlAction(0, 1, true) -- Disable pan
								EnableControlAction(0, 2, true) -- Disable tilt
							end
						end)	
						disableAllControlActions = true
						local waitingTime = 1500 --وقت التسجيل
						local msg = '<font size=5 color=white>جاري التنفيذ'
						TriggerEvent('pogressBar:drawBar', waitingTime, msg)
						Citizen.Wait(waitingTime +100) 	
						disableAllControlActions = false
						OpenLiveryMenu()
					else
						ESX.ShowNotification(_U('service_not'), "error")
					end
				elseif CurrentAction == 'Tasleem' and ESX.PlayerData.job.name == 'environmental' then
					if playerInService then
						Citizen.CreateThread(function() -- نظام الوقوف المؤقت
							while disableAllControlActions do
								Citizen.Wait(0)
								DisableAllControlActions(0)  -- Disable all controls
								EnableControlAction(0, 1, true) -- Disable pan
								EnableControlAction(0, 2, true) -- Disable tilt
							end
						end)	
						disableAllControlActions = true
						local waitingTime = 1500 --وقت التسجيل
						local msg = '<font size=5 color=white>جاري التنفيذ'
						TriggerEvent('pogressBar:drawBar', waitingTime, msg)
						Citizen.Wait(waitingTime +100) 
						disableAllControlActions = false
						TriggerServerEvent('esx_environmentaljob:Tasleem')
					else
						ESX.ShowNotification(_U('service_not'), "error")
					end
				elseif CurrentAction == 'deleteRecord' then
					Citizen.CreateThread(function() -- نظام الوقوف المؤقت
						while disableAllControlActions do
							Citizen.Wait(0)
							DisableAllControlActions(0)  -- Disable all controls
							EnableControlAction(0, 1, true) -- Disable pan
							EnableControlAction(0, 2, true) -- Disable tilt
						end
					end)
					disableAllControlActions = true
					local waitingTime = 1500 --وقت التسجيل
					local msg = '<font size=5 color=white>جاري التنفيذ'
					TriggerEvent('pogressBar:drawBar', waitingTime, msg)
					Citizen.Wait(waitingTime +100) 
					disableAllControlActions = false
						deleteRecord(CurrentActionData.station)
				elseif CurrentAction == 'menu_armory' and ESX.PlayerData.job.name == 'environmental' then
					if playerInService then
						Citizen.CreateThread(function() -- نظام الوقوف المؤقت
							while disableAllControlActions do
								Citizen.Wait(0)
								DisableAllControlActions(0)  -- Disable all controls
								EnableControlAction(0, 1, true) -- Disable pan
								EnableControlAction(0, 2, true) -- Disable tilt
							end
						end)	
						disableAllControlActions = true
						local waitingTime = 1500 --وقت التسجيل
						local msg = '<font size=5 color=white>جاري التنفيذ'
						TriggerEvent('pogressBar:drawBar', waitingTime, msg)
						Citizen.Wait(waitingTime +100) 
						disableAllControlActions = false
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'), "error")
					end
				elseif CurrentAction == 'menu_vehicle_spawner' and ESX.PlayerData.job.name == 'environmental' then
					if playerInService then
						Citizen.CreateThread(function() -- نظام الوقوف المؤقت
							while disableAllControlActions do
								Citizen.Wait(0)
								DisableAllControlActions(0)  -- Disable all controls
								EnableControlAction(0, 1, true) -- Disable pan
								EnableControlAction(0, 2, true) -- Disable tilt
							end
						end)	
						disableAllControlActions = true
					local waitingTime = 1500 --وقت التسجيل
					local msg = '<font size=5 color=white>جاري التنفيذ'
					TriggerEvent('pogressBar:drawBar', waitingTime, msg)
					Citizen.Wait(waitingTime +100) 
					disableAllControlActions = false
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'), "error")
					end
				elseif CurrentAction == 'Helicopters' and ESX.PlayerData.job.name == 'environmental' then
					if playerInService then
						Citizen.CreateThread(function() -- نظام الوقوف المؤقت
							while disableAllControlActions do
								Citizen.Wait(0)
								DisableAllControlActions(0)  -- Disable all controls
								EnableControlAction(0, 1, true) -- Disable pan
								EnableControlAction(0, 2, true) -- Disable tilt
							end
						end)	
						disableAllControlActions = true
						local waitingTime = 1500 --وقت التسجيل
						local msg = '<font size=5 color=white>جاري التنفيذ'
						TriggerEvent('pogressBar:drawBar', waitingTime, msg)
						Citizen.Wait(waitingTime +100) 
						disableAllControlActions = false
						OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'), "error")
					end
				elseif CurrentAction == 'delete_vehicle' and ESX.PlayerData.job.name == 'environmental' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'environmental', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money	
				elseif CurrentAction == 'remove_entity' and ESX.PlayerData.job.name == 'environmental' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'environmental' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'environmental_actions') then
			if playerInService then
				if isBusyReviveenvironmental then
					ESX.ShowNotification('حاليا تجري لديك عمليات انعاش لايمكنك تكرير العملية')
				else
					OpenenvironmentalActionsMenu()
				end
			else
				ESX.ShowNotification(_U('service_not'), "error")
			end
		end

		if IsControlJustReleased(0, 38) and currentTask.busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(currentTask.task)
			ClearPedTasks(PlayerPedId())

			currentTask.busy = false
		end
	end
end)

local jobcolor = {
	['police'] = '<font color=#0070CD> الشرطة </font>',
	['environmental'] = '<font color=#558b2f> أدارة المارشل  </font>',
	['admin'] = '<font color=#3D3D3D> ادارة الرقابة و التفتيش </font>',
}

function remove_sglat()
    ESX.TriggerServerCallback('esx_qalle_brottsregister:grab_environmental', function(result)
		local elements = {}
		local have_any_b = false
        table.insert(elements, {label = '----= السجلات =----'})
		--table.insert(elements, {label = "<font color=green>تحديث</font> القائمة", value = "refresh"})
        for i=1, #result, 1 do
			have_any_b = true
            table.insert(elements, {label = result[i].label, value = result[i].id, name = result[i].name})
        end

		if not have_any_b then
			table.insert(elements, {label = "<font color=gray>لايوجد لديك اي سجل جنائي </font>"})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recorddd', {
			title    = 'السجل الجنائي',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == "refresh" then
				remove_sglat()
			else
				if data.current.value then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'record', {
						title    = ' تأكيد حذف القيد بمبلغ <font color=green>$</font>'..ESX.Math.GroupDigits(Config.DeleteRecordsMoney),
						align    = 'top-left',
						elements = {
							{label = '<font color=green>تأكيد</font>', value = 'show'},
							{label = '<font color=red>إلغاء</font>', value = 'no'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'show' then
							menu2.close()
							TriggerServerEvent('esx_qalle_brottsregister:remove_environmental', data.current.value)
							remove_sglat()
						elseif data2.current.value == 'no' then
							menu2.close()
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(PlayerId()))
end



RegisterNetEvent('esx_environmentaljob:showRecordsss')
AddEventHandler('esx_environmentaljob:showRecordsss', function()
	remove_sglat()
end)

function deleteRecord(station)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'record', {
		title    = 'عرض سجل '..jobcolor[station]..' بمبلغ <font color=green>$</font>'..ESX.Math.GroupDigits(Config.ShowRecordsMoney),
		align    = 'top-left',
		elements = {
			{label = '<font color=green>تأكيد عرض</font>', value = 'show'},
			{label = '<font color=red>إلغاء</font>', value = 'no'},
		}
	}, function(data2, menu2)
		if data2.current.value == 'show' then
			TriggerServerEvent('esx_environmentaljob:removedeleteRecordMoney', 'show', Config.ShowRecordsMoney, '', station)
			menu2.close()
		elseif data2.current.value == 'no' then
			ESX.UI.Menu.CloseAll()
		end
	end, function(data2, menu2)
		menu2.close()

		CurrentAction     = 'deleteRecord'
		CurrentActionMsg  = _U('deleteRecord')
		CurrentActionData = {station = station}
	end)
end

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_environmentaljob:updateBlip')
AddEventHandler('esx_environmentaljob:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.EnableESXService and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end

	-- Is the player a cop? In that case show all the blips for other cops
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'environmental' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'environmental' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_environmentaljob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_environmentaljob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_environmentaljob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'environmental')

		if Config.EnableESXService then
			TriggerServerEvent('esx_service:disableService', 'environmental')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_environmentaljob:unrestrain')
		handcuffTimer.active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-1448.71, -237.872, 49.813)
    SetBlipSprite(blip, 73)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("<FONT FACE='sharlock'>ﺲﺑﻼﻤﻟﺍ ﻞﺤﻣ ﺔﻗﺮس	")
    EndTextCommandSetBlipName(blip)
end)




function setUniform2(uniform, playerPed, type)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject
		if skin.sex == 0 then
			if type == '7rs_1' then
				print(uniform)
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 593,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 206,   ['pants_2'] = 0,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 247,  ['helmet_2'] = 2,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = 84,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_2' then
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 594,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 206,   ['pants_2'] = 0,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 247,  ['helmet_2'] = 2,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = 84,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_aboda7mshort' then
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 545,   ['torso_2'] = uniform,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 19,
					['pants_1'] = 14,   ['pants_2'] = 10,
					['shoes_1'] = 1,   ['shoes_2'] = 0,
					['helmet_1'] = 2,  ['helmet_2'] = 0,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = -1,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_aboda7m' then
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 546,   ['torso_2'] = uniform,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 17,
					['pants_1'] = 14,   ['pants_2'] = 10,
					['shoes_1'] = 1,   ['shoes_2'] = 0,
					['helmet_1'] = 2,  ['helmet_2'] = 0,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = -1,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_mdahmat' then
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 525,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 18,
					['pants_1'] = 14,   ['pants_2'] = 8,
					['shoes_1'] = 1,   ['shoes_2'] = 0,
					['helmet_1'] = 214,  ['helmet_2'] = 0,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = -1,      ['bproof_2'] = 0,
					['chain_1'] = 178,    ['chain_2'] = 0,
					['mask_1'] = 237,    ['mask_2'] = 0 
				}
			elseif type == '7rs_3' then
				print(uniform)
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 590,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 206,   ['pants_2'] = 0,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 244,  ['helmet_2'] = 1,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = 84,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_4' then
				print(uniform)
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 575,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 206,   ['pants_2'] = 0,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 232,  ['helmet_2'] = 1,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = 74,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			elseif type == '7rs_5' then
				uniformObject = { 
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 587,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 206,   ['pants_2'] = 0,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 247,  ['helmet_2'] = 0,
					['glasses_1'] = -1,     ['glasses_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['bproof_1'] = 81,      ['bproof_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['mask_1'] = -1,    ['mask_2'] = 0 
				}
			end
		else
			-- لا للفتيات
		end
		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	end)
end
