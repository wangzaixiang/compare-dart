function prime_sieve(n)
    local is_prime = {}
    for i = 0, n do
        is_prime[i] = true
    end
    is_prime[0] = false
    is_prime[1] = false
    
    local i = 2
    while i * i <= n do
        if is_prime[i] then
            local j = i * i
            while j <= n do
                is_prime[j] = false
                j = j + i
            end
        end
        i = i + 1
    end
    
    local count = 0
    for i = 2, n do
        if is_prime[i] then
            count = count + 1
        end
    end
    
    return count
end

if #arg < 1 then
    print('Usage: prime_sieve <n>')
    os.exit(1)
end

local n = tonumber(arg[1])
if not n then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local start = os.clock()
local count = prime_sieve(n)
local finish = os.clock()

local time_ms = math.floor((finish - start) * 1000)

print('Lua: prime_sieve(' .. n .. ') = ' .. count)
print('Time: ' .. time_ms .. 'ms')