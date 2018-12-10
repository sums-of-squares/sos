@polyvar x y
@variable(model, t)
# We need to convert each equality to two inequalities
# to avoid numerical issues...
S = @set x^2 >= x && y^2 >= y && x^2 <= x && y^2 <= y
@constraint(model, x - y >= t, domain = S)
@objective(model, Max, t)
solve(model)
println("Solution: $(getvalue(t))")
# Returns t = -1
