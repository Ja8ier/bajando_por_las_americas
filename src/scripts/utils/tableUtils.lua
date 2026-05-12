local tableUtils = {}

function tableUtils.removeByValue(t, value)
    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
        end
    end
end

return tableUtils