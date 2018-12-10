using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek
using SemialgebraicSetst

# Using Mosek as the SDP solver
model = SOSModel(solver = MosekSolver())
