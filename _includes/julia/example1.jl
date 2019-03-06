# Create symbolic variables
@polyvar x y
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4

# We want constraint `p` to be a sum of squares
@constraint model p >= 0

optimize!(model)
# Solution status is `OPTIMAL` which means `p` is a sum of squares
@show termination_status(model)
