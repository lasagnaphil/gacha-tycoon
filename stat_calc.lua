statCalc = function()
    local swords = require "swords"
    local accProb = 1
    local accMoney = 0
    print(string.format("%30s%10s%10s%10s%10s %10s %10s", "Name", "Value", "UpgCost", "Prob", "AccProb", "AccMoney", "ExpMoney"))
    for i, sword in ipairs(swords) do
        accProb = accProb * sword.prob
        local prevAccMoney = accMoney
        accMoney = accMoney + sword.upgradeCost
        local expMoney
        if i == #swords then expMoney = 0
        else expMoney = sword.prob * swords[i + 1].value - swords[i].value - sword.upgradeCost end
        print(string.format("%30s%10d%10d%10f%10f %10d %10f", sword.name, sword.value, sword.upgradeCost, sword.prob, accProb, accMoney, expMoney))
    end
end

return statCalc
