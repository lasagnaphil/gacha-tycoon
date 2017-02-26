function IntRange(min, max)
    return {
        type = "IntRange",
        min = min,
        max = max
    }
end

local gachaData = {
    class = {
        swords = {
            IntRange(1, 4),
            IntRange(5, 8),
            IntRange(9, 13),
            IntRange(14, 17)
        }
    },
    prob = {
        regular = {
            swords = {
                0.70, 0.20, 0.07, 0.03
            }
        },
        legendary = {
            swords = {
                0, 0.60, 0.30, 0.10
            }
        },
    }
}

return gachaData
