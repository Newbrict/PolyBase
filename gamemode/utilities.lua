------------------
--[[ PolyBase ]]--
--[[ Newbrict ]]--
------------------

--[[ Steam IDs ]]--

-- Modified from Zack Petty
function PolySteamConvert( id )
	if string.match( id, "^STEAM_[0-9]:[0-9]:[0-9]+$" ) then
		local parts = string.Explode( ':', string.sub(id,7) )
		local id_64 = (1197960265728 + tonumber(parts[2])) + (tonumber(parts[3]) * 2)
		local str = string.format('%f',id_64)
		return '7656'..string.sub( str, 1, string.find(str,'.',1,true)-1 )
	elseif tonumber( id ) then
		local id_64 = tonumber( id:sub(2) )
		local a = id_64 % 2 == 0 and 0 or  1
		local b = math.abs(6561197960265728 - id_64 - a) / 2
		local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
		return sid
	end
	return nil 
end

--[[ Player Management ]]--

function PolyGetPlayerByName( str )
	if not str then return {} end
	local matches = {}
	local partial = string.lower( str );
	for _, v in pairs( player.GetHumans() ) do
		if( string.find( string.lower( v:Name() ), partial, 1, true ) ) then
			matches[#matches+1] = v
		end
	end
	return matches
end

function PolyGetPlayerBySteam64( str )
	if not str then return {} end
	-- only use this if the id is purely numbers
	local id = string.match( str, "^[0-9]+$" )
	-- 17 is the steam64 length
	if( not (id and string.len( id ) == 17) ) then
		return {}
	end
	-- loop through and check to see if we have a matching id
	for _, v in pairs( player.GetHumans() ) do
		if( v:SteamID64() == id ) then
			return { v }
		end
	end
end

function PolyGetPlayerBySteamID( str )
	if not str then return {} end
	return PolyGetPlayerBySteam64( PolySteamConvert(str) )
end

--[[ Tables ]]--

function PolyUnion( table1, table2 )
	if not table2 then return table1 end
	for _, v in pairs( table2 ) do
		if( table.HasValue( table1, v ) ) then
			continue
		end
		table1[#table1 + 1] = v
	end
	return table1
end