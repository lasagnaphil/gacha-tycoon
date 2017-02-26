local swords = require "swords"

statCalc = function()
    local accProb = 1
    for i, sword in ipairs(swords) do
        accProb = accProb * sword.prob
        print(string.format("%30s%10d%10d%10f%10f", sword.name, sword.value, sword.upgradeCost, sword.prob, accProb))
    end
end

return statCalc
