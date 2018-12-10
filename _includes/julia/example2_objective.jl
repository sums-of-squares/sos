@polyvar x y
@variable(model, s)
@variable(model, t)
p = s*x^6+t*y^6-x^4*y^2-x^2*y^4-x^4+3*x^2*y^2-y^4-x^2-y^2+1
@constraint(model, p >= 0)
@objective(model, Min, s+t)
solve(model)
println("Solution: [ $(getvalue(s)), $(getvalue(t)) ]")
# returns s ~ 1.203, t ~ 1.203
