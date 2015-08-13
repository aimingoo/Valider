# Valider
The Valider module to check rate of invalid action/event/behaviour, and return a final status to you.

Valider include features:
- continuous invalid X times, or
- invalid X times in Y seconds

will report as once. and
- support multi-tags in a checker
- very clean & small, little memory, and faster!

# Install & Usage
download the Valider.lua file and put into lua search path or current directory.

load it as a file module from lua. use Valider:new() to get checker object.
```lua
local Valider = require('Valider')
local checker = Valider:new()

if checker:invalid('tag') then
	-- do something when status is invalid
	..
end
```

# Options

you can create checker with options.
```lua
local options = {
	-- count one continuous-invalid, when less maxContinuousInterval between two invalids
	maxContinuousInterval = 3,

	-- report as once when continuous-invalid count >= maxContinuous
	--	*) continuous invalid X times
	maxContinuous = 100,

	-- report as once when invalid count >= maxTimes, in maxSeconds
	--	*) invalid X times in Y seconds history
	maxTimes = 30,
	maxSeconds = 30,
}

-- get checker with options
--	*) or <nil> for default
local checker = Valider:new(options)

..
```

# Multi-tags checker
with tags, you can check multi source action/event/behaviour. the tag is anything(string/boolean/table in lua). for examples:
```lua
local checker = Valider:new()

if checker:invalid('network hardware invalid') then
	..
end

if checker:invalid('server connection lost') then
	..
end

if (checker:invalid(a_table_variant) or
	checker:invalid(a_boolean_variant) or
	checker:invalid(any_data_as_key_of_lua_table)) then
	..
end
```

# testcase or samples
some examples in testcase/t_base_demo.lua. require time.lua module and run it with luajit. the module  from:
- https://luapower.com/time/

and, install luajit in macos(only for the testcase):
```
> brew install luajit
```
run:
```
> git clone https://github.com/aimingoo/Valider
> cd Valider/testcase
> luajit t_base_demo.lua
```
