---
layout: default
---

# Introduction

In this guide we will explain how to perform basic SOS computations using the following software:

- [SOSTOOLS](https://www.cds.caltech.edu/sostools/): Matlab
- [SOS.m2](https://github.com/parrilo/SOSm2): Macaulay2
- [SumOfSquares.jl](https://github.com/JuliaOpt/SumOfSquares.jl): Julia

We point out that other SOS tools are available, such as the Matlab libraries
[YALMIP](https://yalmip.github.io/tutorial/sumofsquaresprogramming/)
and
[GloptiPoly](http://homepages.laas.fr/henrion/software/gloptipoly/).

# Installation


# Example 1: Checking if polynomial is sum-of-squares

Here we find an SOS decomposition for the polynomial
$p = 2 x^4 + 2 x^3 y - x^2 y^2 + 5 y^4$.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage "SOS"

R = QQ[x,y];
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4;
sosPoly solveSOS p

-- returns the rational SOS decomposition
-- p = 5 (-(11/25)*x^2+y^2)^2 +  17/5*(5/17*x^2+x*y)^2 + 1568/2125 * x^4

{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
vartable = [x, y];
% Initialize the sum of squares program
prog = sosprogram(vartable);   % No decision variables.
% Define the inequality
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4;
prog = sosineq(prog,p);  %p(x,y)>=0
% Call solver
prog = sossolve(prog);

% Program is feasible, thus p(x,y) is an SOS.
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

We now consider the Motzkin polynomial, for which no SOS decomposition exists.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage "SOS"

R = QQ[x,y]
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
sosPoly solveSOS p

-- returns the message "dual infeasible"
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
vartable = [x, y];
% Initialize the sum of squares program
prog = sosprogram(vartable);   % No decision variables.
% Define the inequality
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
prog = sosineq(prog,p);  % p(x,y)>=0
% Call solver
prog = sossolve(prog);

% Program is infeasible.
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

# Example 2: Parametric SOS problems

In the next example we consider the variables $s$, $t$ as parameters, and find values for them such that the following polynomial is a sum-of-squares.
$$ s x^6+t y^6-x^4 y^2-x^2 y^4-x^4+3 x^2 y^2-y^4-x^2-y^2+1 $$

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage "SOS"

R = QQ[x,y][s,t]
p = s*x^6+t*y^6-x^4*y^2-x^2*y^4-x^4+3*x^2*y^2-y^4-x^2-y^2+1
sol = sosPoly solveSOS p
sol#Parameters

-- returns s = t = 135/4
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y z s t;
vartable = [x, y, z];
prog = sosprogram(vartable);
p = s*x^6+t*y^6-x^4*y^2-x^2*y^4-x^4+3*x^2*y^2-y^4-x^2-y^2+1
prog = sosineq(prog,p);  % p(x,y)>=0
prog = sossolve(prog);

% Returns the values ???
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

We now do parameter optimization.
Namely, we find the smallest value of $t$ that makes the following polynomial a sum-of-squares.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage "SOS"

R = QQ[x,y][s,t]
p = s*x^6+t*y^6-x^4*y^2-x^2*y^4-x^4+3*x^2*y^2-y^4-x^2-y^2+1
sol = solveSOS(p,t)
sol#Parameters

-- returns s = 1599609/256, t = 1
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y z s t;
vartable = [x, y, z];
prog = sosprogram(vartable);
p = s*x^6+t*y^6-x^4*y^2-x^2*y^4-x^4+3*x^2*y^2-y^4-x^2-y^2+1
prog = sosineq(prog,p); % p>=0
prog = sossolve(prog);

% Returns the values ???
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

Finally, we do parameter optimization with multiple SOS constraints.
This is not yet possible to do in Macaulay2.

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y z s t;
vartable = [x, y, z];
prog = sosprogram(vartable);
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
prog = sosineq(prog,p); % p>=0
prog = sossolve(prog);

% Returns the values ???
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
using MultivariatePolynomials
using JuMP
using PolyJuMP
using SumOfSquares
using DynamicPolynomials
using Mosek

{% endcapture %}

{% include nav-tabs.html matlab=matlab_code julia=julia_code %}
