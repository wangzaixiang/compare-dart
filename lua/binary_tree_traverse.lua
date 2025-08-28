local Node = {}
Node.__index = Node

function Node:new(data)
    local node = {
        data = data,
        left = nil,
        right = nil
    }
    setmetatable(node, Node)
    return node
end

function build_tree(depth, counter)
    if depth <= 0 then
        return nil
    end
    
    local node = Node:new(counter[1])
    counter[1] = counter[1] + 1
    node.left = build_tree(depth - 1, counter)
    node.right = build_tree(depth - 1, counter)
    return node
end

function traverse_in_order(node)
    if node == nil then
        return 0
    end
    
    local sum = 0
    sum = sum + traverse_in_order(node.left)
    sum = sum + node.data
    sum = sum + traverse_in_order(node.right)
    return sum
end

if #arg < 1 then
    print('Usage: binary_tree_traverse <depth>')
    os.exit(1)
end

local depth = tonumber(arg[1])
if not depth then
    print('Invalid number: ' .. arg[1])
    os.exit(1)
end

local counter = {0}

local start = os.clock()
local root = build_tree(depth, counter)
local sum = traverse_in_order(root)
local finish = os.clock()

local time_ms = math.floor((finish - start) * 1000)

print('Lua: binary_tree_traverse(' .. depth .. ') = ' .. sum)
print('Time: ' .. time_ms .. 'ms')