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
            IntRange(14, 15)
        }
    },
    prob = {
        regular = {
            swords = {
                0.72, 0.20, 0.075, 0.005
            }
        },
        legendary = {
            swords = {
                0.10, 0.60, 0.25, 0.05
            }
        },
    }
}

return gachaData
