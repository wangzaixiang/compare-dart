function mandelbrot(x0, y0, max_iter)
    local x = 0.0
    local y = 0.0
    local iteration = 0
    
    while x*x + y*y <= 4.0 and iteration < max_iter do
        local xtemp = x*x - y*y + x0
        y = 2*x*y + y0
        x = xtemp
        iteration = iteration + 1
    end
    return iteration
end

if #arg < 1 then
    print('Usage: mandelbrot <size>')
    os.exit(1)
end

local size = tonumber(arg[1])
if not size then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local max_iter = 100

local start = os.clock()

local count = 0
for py = 0, size - 1 do
    for px = 0, size - 1 do
        local x0 = (px - size/2.0) * 3.0 / size
        local y0 = (py - size/2.0) * 3.0 / size
        local iter = mandelbrot(x0, y0, max_iter)
        if iter < max_iter then
            count = count + 1
        end
    end
end

local finish = os.clock()
local time_ms = math.floor((finish - start) * 1000)

print('Lua: mandelbrot(' .. size .. ') = ' .. count)
print('Time: ' .. time_ms .. 'ms')