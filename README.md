# Cloudbase
Go back to the start of time, where DataStores weren't complex.
# Installation
Copying [```Cloudbase.lua```](https://github.com/SiangStudioGit/Cloudbase/blob/main/Cloudbase.lua) to ```ServerStorage```. Make sure it's a ModuleScript named ```Cloudbase```.
# Concept
The concept of Cloudbase is to provide one DataStore, and just one, in order to completely removes complications. It's faster and lighter on the server, and provides a simple API.
# How does it work?
Simple. We have a ```DatabaseFunctions``` table and a ```Cloudbase``` table. What we do, is define our functions on ```DatabaseFunctions```, and then when you call ```GetDB```, iterate through each function and return an instance of it. This means that you don't have to type ```DatabaseFunctions:Set("hello", "key", "value")``` - simply just type ```Cloudbase:GetDB("hello"):Set("key", "value")``` instead.

*TIP*: If you don't like SentenceCase DatabaseFunctions, you can use lowercase. For example: ```GetDB("hello"):set("key", "value")```
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
