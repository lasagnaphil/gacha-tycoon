Random = {
    coinFlip = function(prob)
        local n = love.math.random()
        return n <= prob
    end,
    dice = function(n)
        if type(n) == "number" then return love.math.random(1, n)
        elseif type(n) == "table" and n.type == "IntRange" then
            return love.math.random(n.min, n.max)
        end
    end,
    skewedDice = function(dist)
        assert(type(dist) == "table")
        local n = love.math.random()
        local i = 1
        local threshold = dist[i]
        while n > threshold and dist[i + 1] ~= nil do
            i = i + 1
            threshold = threshold + dist[i]
        end
        return i
    end,
}

return Random
