local DataStoreService = game:GetService("DataStoreService")
local Database = DataStoreService:GetDataStore("CloudbaseService")

local Cloudbase = {}
local DatabaseFunctions = {}
local Cache = {}
local Queue = {}

function addToQueue(fn)
	Queue[os.time()] = fn
end

function Cloudbase:GetDB(name)
	local new = {}
	new.name = name
	coroutine.resume(
		coroutine.create(
			function()
				for k, v in pairs(DatabaseFunctions) do
					local fn = function(...)
						local args = {...}
						return v(unpack(new), unpack(args))
					end
					new[k] = fn
					new[string.lower(k)] = fn
				end
			end
		)
	)
	return new
end

function DatabaseFunctions:Set(store, key, value, shouldSave)
	store = store.name
	Cache[store .. key] = value
	if shouldSave == nil or shouldSave == true then
		addToQueue(
			function()
				Database:SetAsync(store .. key, value)
			end
		)
	end
	return value
end

function DatabaseFunctions:Get(store, key)
	store = store.name
	if not (not Cache[store .. key]) then
		return Cache[store .. key]
	else
		local val = Database:GetAsync(store .. key)
		Cache[store .. key] = val
		return val
	end
end

function DatabaseFunctions:Delete(store, key)
	store = store.name
	addToQueue(
		function()
			Database:RemoveAsync(store .. key)
		end
	)
	Cache[store .. key] = nil
	return true
end

function DatabaseFunctions:Has(store, key)
	store = store.name
	if not (not Cache[store .. key]) then
		return not (not Cache[store .. key])
	else
		return not (not Database:GetAsync(store .. key))
	end
end

function DatabaseFunctions:Save(store, key)
	store = store.name
	if Cache[store .. key] == nil then
		return false
	else
		addToQueue(
			function()
				Database:SetAsync(store .. key, Cache[store .. key])
			end
		)
		return true
	end
end

function DatabaseFunctions:Fetch(store, key)
	store = store.name
	addToQueue(function()
		local value = Database:GetAsync(store .. key)
		Cache[store .. key] = value
	end)
	return true
end

function Cloudbase:EndQueue()
	for _k, v in pairs(Queue) do
		local _s, _e =
			pcall(
				function()
					v()
				end
			)
	end
end

coroutine.wrap(
	function()
		while wait(10) do
			if #Queue > 0 then
				for k, v in pairs(Queue) do
					local s, e =
						pcall(
							function()
								v()
							end
						)
					if e or not s then
						break
					else
						Queue[k] = nil
					end
				end
			end
		end
	end
)()

game:BindToClose(function()
	print("The queue is now ending to ensure that no data is lost.")
	Cloudbase:EndQueue()
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
	for k: string, _v in pairs(Cache) do
		if string.find(k, player.UserId) then
			local store = k:gsub(player.UserId, "")
			local key = k:gsub(store, "")
			Database:SetAsync(store .. key, Cache[store .. key])
			Cache[k] = nil
		end

		if string.find(k, player.Name) then
			local store = k:gsub(player.Name, "")
			local key = k:gsub(store, "")
			Database:SetAsync(store .. key, Cache[store .. key])
			Cache[k] = nil
		end
	end
end)

return Cloudbase
