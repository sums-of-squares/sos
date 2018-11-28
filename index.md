---
layout: default
---

# Introduction

# Software to install

# Checking if polynomial is sum-of-squares

{% capture macaulay2_code %}
needsPackage( "SOS", Configuration=>{"CSDPexec"=>"SDPsolvers/csdp","SDPAexec"=>"SDPsolvers/sdpa"} )

-- Motzkin polynomial
R = QQ[x,y,z]
h = x^2 + y^2 + z^2
f1 = library("Motzkin",R)
sol1 = solveSOS (f1*h, Solver=>"CSDP")
g1 = sosPoly sol1
{% endcapture %}

{% capture matlab_code %}
% SOSDEMO1 --- Sum of Squares Test
% Section 3.1 of SOSTOOLS User's Manual
%

clear; echo on;
syms x1 x2;
vartable = [x1, x2];
% =============================================
% First, initialize the sum of squares program
prog = sosprogram(vartable);   % No decision variables.

% =============================================
% Next, define the inequality

% p(x1,x2) >=  0
p = 2*x1^4 + 2*x1^3*x2 - x1^2*x2^2 + 5*x2^4;
prog = sosineq(prog,p);


% =============================================
% And call solver
prog = sossolve(prog);

% =============================================
% Program is feasible, thus p(x1,x2) is an SOS.
echo off;
{% endcapture %}

{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

# Create symbolic variables (not JuMP decision variables)
@polyvar x1 x2

# Create a Sum of Squares JuMP model with the Mosek solver
m = SOSModel(solver = MosekSolver())

# Create a JuMP decision variable for the lower bound
@variable m γ

# f(x) is the Goldstein-Price function
f1 = x1+x2+1
f2 = 19-14*x1+3*x1^2-14*x2+6*x1*x2+3*x2^2
f3 = 2*x1-3*x2
f4 = 18-32*x1+12*x1^2+48*x2-36*x1*x2+27*x2^2

f = (1+f1^2*f2)*(30+f3^2*f4)

# Constraints f(x) - γ to be sum of squares
@constraint m f >= γ

@objective m Max γ

status = solve(m)

# The lower bound found is 3
println(getobjectivevalue(m))
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}
