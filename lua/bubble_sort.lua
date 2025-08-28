function bubble_sort(arr)
    local n = #arr
    for i = 1, n - 1 do
        for j = 1, n - i do
            if arr[j] > arr[j + 1] then
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
            end
        end
    end
end

function generate_array(n)
    math.randomseed(42) -- Fixed seed for reproducible results
    local arr = {}
    for i = 1, n do
        arr[i] = math.random(0, 9999)
    end
    return arr
end

if #arg < 1 then
    print('Usage: bubble_sort <n>')
    os.exit(1)
end

local n = tonumber(arg[1])
if not n then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local arr = generate_array(n)

local start = os.clock()
bubble_sort(arr)
local finish = os.clock()

local time_ms = math.floor((finish - start) * 1000)

print('Lua: bubble_sort(' .. n .. ') = sorted')
print('Time: ' .. time_ms .. 'ms')