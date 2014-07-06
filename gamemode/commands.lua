------------------
--[[ PolyBase ]]--
--[[ Newbrict ]]--
------------------
-- Constants
local POLY_KICK 	= 1
local POLY_KICK_S 	= 2
local POLY_KICK_A 	= 3
local POLY_KICK_AS 	= 4

PolyCmds = {}
PolyCmds["kick"] = function( args, ply ) return PolyKickHandler( ply, args, POLY_KICK ) end
PolyCmds["silentkick"] = function( args, ply ) return PolyKickHandler( ply, args, POLY_KICK_S ) end
PolyCmds["test"] = function( args, ply ) return PolyTesting( args, ply ) end

hook.Add( "PlayerSay", "CommandIntercept", function( ply, text, team )
	-- 33 == '!'
	if( string.byte( text ) != 33 ) then
		return text
	else
		return PolyCommander( ply, string.sub(text, 2) )
	end
end )

function PolyCommander( ply, str )
	local cmdTokens = string.Explode( " ", str )
	local cmd = table.remove( cmdTokens, 1 )
	if( PolyCmds[cmd] ) then
		-- We send ( args, ply ) since some funcs don't take ply
		return PolyCmds[cmd](cmdTokens, ply)
	else
		return "Invalid Command: " .. cmd
	end
end

function PolyTesting( args, ply )
	print(PolySteamConvert( "STEAM_0:1:17414189" ))
	--[[
	local Test1 = {"One","Two","Three", "Four"}
	local Test2 = {"Four", "Five", "Six"}
	PolyUnion( Test1, Test2 )
	print( table.concat( Test1, " " ) )
	]]--
end

--[[ Kicks ]]--

function PolyKickHandler( ply, args, ktype )
	if( ply.polyLevel <= polyPerms["kick"] ) then
		PolyMessanger( "You do not have permissions to kick" )
	end
	-- get all the possible targets
	local targets = {}
	-- partial name
	targets = PolyUnion(targets, PolyGetPlayerByName(args[1]))
	-- steam 64
	targets = PolyUnion(targets, PolyGetPlayerBySteam64(args[1]))
	-- steam id
	targets = PolyUnion(targets, PolyGetPlayerBySteamID(args[1]))

	-- compile the reason
	local reason = table.concat( args, " ", 2, #args )
	if( reason == "" ) then
		reason = "No Reason"
	end

	if( ktype == POLY_KICK ) then
		-- only kick if we have exactly 1 match
		if( #targets < 1 ) then
			PolyMessenger( "No player via \"" .. args[1] .. "\"" )
			return ""
		elseif( #targets > 1 ) then
			PolyMessenger( "Ambiguous player selection, be more specific" )
			return ""
		end
		PolyKick( ply, targets[1], reason )
	end
	if( ktype == POLY_KICK_S ) then
		-- only kick if we have exactly 1 match
		if( #targets < 1 ) then
			PolyMessenger( "No player via \"" .. args[1] .. "\"" )
			return ""
		elseif( #targets > 1 ) then
			PolyMessenger( "Ambiguous player selection, be more specific" )
			return ""
		end
		PolySilentKick( ply, targets[1], reason )
	end
	return ""
end

function PolyKick( ply, target, reason )
	PolySilentKick( ply, target, reason )
	-- print the kick message
	PolyMessenger( ply:Nick().." kicked "..target:Nick()..": "..reason )
end

function PolySilentKick( ply, target, reason )
	if( IsValid( target ) ) then
		target:Kick( "Kicked: " .. reason )
	end
end