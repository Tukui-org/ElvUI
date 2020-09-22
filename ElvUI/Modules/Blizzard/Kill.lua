local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:GetModule('Blizzard')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function AcknowledgeTips()
	for frame in _G.HelpTip.framePool:EnumerateActive() do
		frame:Acknowledge()
	end
end

function B:DisableHelpTip()
	if not E.global.general.disableTutorialButtons then return end

	AcknowledgeTips()
	hooksecurefunc(_G.HelpTip, 'Show', AcknowledgeTips)
end
