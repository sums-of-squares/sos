@polyvar x y
@variable(model, t)
S = @set x^2 == x && y^2 == y
@constraint(model, x - y >= t, domain = S, maxdegree=2)
@objective(model, Max, t)
optimize!(model)
println("Solution: $(value(t))")
# Returns t = -1
