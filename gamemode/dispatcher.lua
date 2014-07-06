------------------
--[[ PolyBase ]]--
--[[ Newbrict ]]--
------------------

PolyMsgs = {}

function PolyMessanger ( args )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCENTER, args )
	end
end