function override_error(class, method)
    error("Did not override method " .. method .. " in class " .. class)
end
