function counting_sort(arr, n, max_val)
    local count = {}
    local output = {}
    
    -- Initialize count array
    for i = 0, max_val do
        count[i] = 0
    end
    
    -- Count occurrences
    for i = 1, n do
        count[arr[i]] = count[arr[i]] + 1
    end
    
    -- Change count[i] so that it contains position of this character in output array
    for i = 1, max_val do
        count[i] = count[i] + count[i - 1]
    end
    
    -- Build output array
    for i = n, 1, -1 do
        local val = arr[i]
        output[count[val]] = arr[i]
        count[val] = count[val] - 1
    end
    
    -- Copy output array to arr
    for i = 1, n do
        arr[i] = output[i]
    end
end

function generate_array(n, max_val)
    local arr = {}
    for i = 1, n do
        arr[i] = ((i - 1) * 7 + (i - 1) * (i - 1) * 3) % (max_val + 1)
    end
    return arr
end

if #arg < 1 then
    print('Usage: counting_sort <n>')
    os.exit(1)
end

local n = tonumber(arg[1])
if not n then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local max_val = 999
local arr = generate_array(n, max_val)

local start = os.clock()
counting_sort(arr, n, max_val)
local finish = os.clock()

-- Calculate checksum to verify correctness
local checksum = 0
for i = 1, n do
    checksum = checksum + arr[i]
end

local time_ms = math.floor((finish - start) * 1000)

print('Lua: counting_sort(' .. n .. ') = ' .. checksum)
print('Time: ' .. time_ms .. 'ms')