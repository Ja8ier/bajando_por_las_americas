local Queue = {}

Queue.__index = Queue

function Queue.new()

    local self = setmetatable({}, Queue)

    self.items = {}

    return self
end

function Queue:enqueue(item)

    table.insert(self.items, item)
end

function Queue:dequeue()

    if #self.items == 0 then
        return nil
    end

    return table.remove(self.items, 1)
end

function Queue:isEmpty()

    return #self.items == 0
end

function Queue:peek()

    return self.items[1]
end

return Queue