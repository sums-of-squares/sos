@polyvar x z
@variable(model, t)
p = x^4 + x^2 - 3*x^2*z^2 + z^6 - t
@constraint(model, p >= 0)
@objective(model, Max, t)
solve(model)
println("Solution: $(getvalue(t))")
# Returns the lower bound -.17700
