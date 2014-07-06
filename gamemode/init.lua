------------------
--[[ PolyBase ]]--
--[[ Newbrict ]]--
------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "commands.lua" )
AddCSLuaFile( "dispatcher.lua" )
AddCSLuaFile( "utilities.lua" )

include( "shared.lua" )
print("[========POLYBASE LOADED========]")
local polyUsers = util.JSONToTable( file.Read( "polybase/users.txt", "DATA" ) )
polyPerms = util.JSONToTable( file.Read( "polybase/permissions.txt", "DATA" ) )

hook.Add("PlayerInitialSpawn", "Add Poly Level To Player", function ( ply )
	ply.polyLevel = 0
	for k, v in pairs ( polyUsers ) do 
		if( v.steamid == ply:SteamID64() ) then
			ply.polyLevel = v.level
			break
		end
	end
end )

hook.Add( "CheckPassword", "Bouncer", function ( steamID, ipAdress, svPassword, clPassword, name )
	for _, v in pairs (polyUsers) do
		if( v.level > 0 and steamID == v.steamid ) then
			return true
		end
	end
	print( name.." tried to connect" )
	return false, "This Server Is Under Development, Please Try Again Later!"
end )

hook.Add("PlayerNoClip", "DisableNoclip", function( ply )
	return ( ply.polyLevel >= polyPerms["noclip"] )
end )

