function quicksort(arr, low, high)
    if low < high then
        local pi = partition(arr, low, high)
        quicksort(arr, low, pi - 1)
        quicksort(arr, pi + 1, high)
    end
end

function partition(arr, low, high)
    local pivot = arr[high]
    local i = low - 1
    
    for j = low, high - 1 do
        if arr[j] < pivot then
            i = i + 1
            arr[i], arr[j] = arr[j], arr[i]
        end
    end
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1
end

function generate_array(n)
    math.randomseed(42)
    local arr = {}
    for i = 1, n do
        arr[i] = math.random(0, 9999)
    end
    return arr
end

if #arg < 1 then
    print('Usage: quicksort <n>')
    os.exit(1)
end

local n = tonumber(arg[1])
if not n then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local arr = generate_array(n)

local start = os.clock()
quicksort(arr, 1, n)
local finish = os.clock()

local time_ms = math.floor((finish - start) * 1000)

print('Lua: quicksort(' .. n .. ') = sorted')
print('Time: ' .. time_ms .. 'ms')