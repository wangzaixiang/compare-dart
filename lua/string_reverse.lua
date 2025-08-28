function reverse_string(str)
    local chars = {}
    for i = 1, #str do
        chars[i] = string.sub(str, i, i)
    end
    
    local start = 1
    local end_pos = #chars
    
    while start < end_pos do
        chars[start], chars[end_pos] = chars[end_pos], chars[start]
        start = start + 1
        end_pos = end_pos - 1
    end
    
    return table.concat(chars)
end

function generate_string(length)
    local chars = {}
    for i = 1, length do
        chars[i] = string.char(65 + ((i - 1) % 26)) -- 'A' + (i % 26)
    end
    return table.concat(chars)
end

if #arg < 1 then
    print('Usage: string_reverse <length>')
    os.exit(1)
end

local length = tonumber(arg[1])
if not length then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local str = generate_string(length)

local start = os.clock()
local reversed = reverse_string(str)
local finish = os.clock()

-- Calculate checksum to verify correctness
local checksum = 0
for i = 1, #reversed do
    checksum = checksum + string.byte(reversed, i)
end

local time_ms = math.floor((finish - start) * 1000)

print('Lua: string_reverse(' .. length .. ') = ' .. checksum)
print('Time: ' .. time_ms .. 'ms')