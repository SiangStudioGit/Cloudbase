# Cloudbase
It's faster and lighter on the server, and provides a simple API.
# Installation
Copying ```[Cloudbase.lua](https://github.com/SiangStudioGit/Cloudbase/blob/main/Cloudbase.lua)``` to ```ServerStorage```. Make sure it's a ModuleScript named ```Cloudbase```.
# Usage
To use Cloudbase, here's a simple showcase down below.
```lua
-- Importing Cloudbase:
local ServerStorage = game:GetService("ServerStorage")
local Cloudbase = require(ServerStorage:WaitForChild("Cloudbase"))

-- Getting a DataStore:
local Database = Cloudbase:GetDB("names")

-- Setting data:
Database:Set("Cloudbase", "Database")

-- You can use lowercase versions of functions as well:
Database:set("Construct", "Developer")

-- Getting data:
Database:Get("Construct") -- "Developer"

-- Check for data:
Database:Has("Construct") -- true

-- Remove data:
Database:Remove("Construct")
