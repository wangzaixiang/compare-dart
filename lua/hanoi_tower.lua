local move_count = 0

function hanoi_tower(n, from, to, aux)
    if n == 1 then
        move_count = move_count + 1
        return
    end
    
    hanoi_tower(n - 1, from, aux, to)
    move_count = move_count + 1
    hanoi_tower(n - 1, aux, to, from)
end

if #arg < 1 then
    print('Usage: hanoi_tower <n>')
    os.exit(1)
end

local n = tonumber(arg[1])
if not n then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

move_count = 0

local start = os.clock()
hanoi_tower(n, 'A', 'C', 'B')
local finish = os.clock()

local time_ms = math.floor((finish - start) * 1000)

print('Lua: hanoi_tower(' .. n .. ') = ' .. move_count)
print('Time: ' .. time_ms .. 'ms')