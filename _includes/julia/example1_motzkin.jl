@polyvar x y
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
@constraint(model, p >= 0)
solve(model)
# Solution status is `Infeasible`
