@polyvar x z
@variable(model, t)
p = x^4 + x^2 - 3*x^2*z^2 + z^6 - t
@constraint(model, p >= 0)
@objective(model, Max, t)
optimize!(model)
println("Solution: $(value(t))")
# Returns the lower bound -.17700
