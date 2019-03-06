@polyvar x y
@variable(model, t)
p1 = t*(1 + x*y)^2 - x*y + (1 - y)^2
p2 = (1 - x*y)^2 + x*y + t*(1 + y)^2
@constraint(model, p1 >= 0)
@constraint(model, p2 >= 0)
@objective(model, Min, t)
optimize!(model)
println("Solution: $(value(t))")
# Returns t ~ 0.25
