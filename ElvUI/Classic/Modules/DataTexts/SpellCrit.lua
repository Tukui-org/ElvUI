local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local strjoin = strjoin
local GetSpellCritChance = GetSpellCritChance
local CRIT_ABBR = CRIT_ABBR

local displayString, lastPanel = ''

local function OnEvent(self)
	self.text:SetFormattedText(displayString, CRIT_ABBR, GetSpellCritChance())

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin('', '%s: ', hex, '%.2f%%|r')

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Spell Crit Chance', _G.STAT_CATEGORY_ENHANCEMENTS, {'UNIT_STATS', 'UNIT_AURA', 'PLAYER_DAMAGE_DONE_MODS'}, OnEvent, nil, nil, nil, nil, 'Spell Crit Chance')
