function matrix_multiply(a, b, c, size)
    for i = 1, size do
        for j = 1, size do
            c[i][j] = 0
            for k = 1, size do
                c[i][j] = c[i][j] + a[i][k] * b[k][j]
            end
        end
    end
end

function allocate_matrix(size)
    local matrix = {}
    for i = 1, size do
        matrix[i] = {}
        for j = 1, size do
            matrix[i][j] = 0
        end
    end
    return matrix
end

function init_matrix(matrix, size, seed_offset)
    for i = 1, size do
        for j = 1, size do
            matrix[i][j] = ((i - 1) * 3 + (j - 1) * 7 + seed_offset) % 100
        end
    end
end

if #arg < 1 then
    print('Usage: matrix_multiply <size>')
    os.exit(1)
end

local size = tonumber(arg[1])
if not size then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local a = allocate_matrix(size)
local b = allocate_matrix(size)
local c = allocate_matrix(size)

init_matrix(a, size, 0)
init_matrix(b, size, 1)

local start = os.clock()
matrix_multiply(a, b, c, size)
local finish = os.clock()

-- Calculate checksum to verify correctness
local checksum = 0
for i = 1, size do
    for j = 1, size do
        checksum = checksum + c[i][j]
    end
end

local time_ms = math.floor((finish - start) * 1000)

print('Lua: matrix_multiply(' .. size .. ') = ' .. checksum)
print('Time: ' .. time_ms .. 'ms')