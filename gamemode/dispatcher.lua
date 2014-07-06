------------------
--[[ PolyBase ]]--
--[[ Newbrict ]]--
------------------

PolyMsgs = {}

function PolyMessenger ( args )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCENTER, args )
	end
end