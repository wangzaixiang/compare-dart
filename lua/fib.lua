#!/usr/bin/env lua

function fib(n)
    if n <= 1 then
        return n
    end
    return fib(n - 1) + fib(n - 2)
end

if not arg[1] then
    print("Usage: lua fib.lua <n>")
    os.exit(1)
end

local n = tonumber(arg[1])
local start_time = os.clock()
local result = fib(n)
local end_time = os.clock()

local time_ms = math.floor((end_time - start_time) * 1000)

print("Lua: fib(" .. n .. ") = " .. result)
print("Time: " .. time_ms .. "ms")