@polyvar x y
@variable(model, t)
S = @set x^2 + y^2 == 1 && y - x^2 == 0.5 && x >=0 && y>=0.5
@constraint(model, x + y >= t, domain = S, maxdegree = 2)
@objective(model, Max, t)
solve(model)
println("Solution: $(getvalue(t))")
# Returns t ~ 1.3911
