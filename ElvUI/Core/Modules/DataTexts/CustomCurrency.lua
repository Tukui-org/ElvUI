local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local _G = _G
local tremove, next = tremove, next
local ipairs, pairs, strjoin = ipairs, pairs, strjoin

local defaults = { showIcon = true, nameStyle = 'full', showMax = true, currencyTooltip = true }

local function OnEvent(self)
	local info = DT:CurrencyInfo(self.name)
	local currency = E.global.datatexts.customCurrencies[self.name]
	if info and currency then
		local style = currency.nameStyle
		local displayString

		if style ~= 'none' then
			displayString = strjoin(': ', style == 'full' and currency.name or E:AbbreviateString(currency.name), '%d')
		end

		if currency.showMax and info.maxQuantity and info.maxQuantity > 0 then
			displayString = strjoin(' ', displayString, '/', info.maxQuantity)
		end

		self.icon:SetTexture(info.iconFileID)
		self.icon:SetShown(currency.showIcon)
		self.text:SetFormattedText(displayString or '%d', info.quantity)
	end
end

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:SetCurrencyByID(self.name)
	DT.tooltip:Show()
end

local function RegisterNewDT(currencyID)
	local info = DT:CurrencyInfo(currencyID)
	if not info then return end

	--Save info to persistent storage, stored with ID as key
	G.datatexts.customCurrencies[currencyID] = defaults
	E.global.datatexts.customCurrencies[currencyID] = E:CopyTable({ name = info.name }, defaults)

	--Register datatext
	local data = DT:RegisterDatatext(currencyID, _G.CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, info.name)
	data.isCurrency = true

	DT:UpdateQuickDT()
end

function DT:RegisterCustomCurrencyDT(currencyID)
	if currencyID then
		RegisterNewDT(currencyID)
	else
		--We called this in DT:Initialize, so load all the stored currency datatexts
		for id, info in pairs(E.global.datatexts.customCurrencies) do
			G.datatexts.customCurrencies[id] = defaults
			info = E:CopyTable(info, defaults, true)

			local data = DT:RegisterDatatext(id, _G.CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, info.name)
			data.isCurrency = true
		end
	end
end

function DT:RemoveCustomCurrency(currencyName)
	local menuIndex = DT:GetMenuListCategory(_G.CURRENCY)
	local quickList = DT.QuickList[menuIndex]
	if quickList then
		if not next(E.global.datatexts.customCurrencies) then
			DT.QuickList[menuIndex] = nil
		else
			local menuList = quickList.menuList

			for i, info in ipairs(menuList) do
				if info.text == currencyName then
					tremove(menuList, i)
					break
				end
			end
		end
	end

	DT:SortMenuList(DT.QuickList)
end
