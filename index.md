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
$2 x^4 + 2 x^3 y - x^2 y^2 + 5 y^4$.

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
syms x y s t;
vartable = [x, y];
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
Namely, among the values of $s,t$ that make the polynomial a sum-of-squares, we look for values with the smallest value of $t$.

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
syms x y s t;
vartable = [x, y];
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

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
This is not yet possible to do in Macaulay2.
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y s t;
vartable = [x, y];
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

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

# Example 3: Global polynomial optimization

Consider the polynomial 
$p = x^4+x^2-3 x^2 z^2+z^6$.
We may find a lower bound on $p$ by looking for the largest value of $t$ that makes $p - t$ is a sum-of-squares.
This can be is a parametric SOS problem

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,z][t];
p = x^4+x^2-3*x^2*z^2+z^6
sol = solveSOS (p-t, -t, RoundTol=>12);
sol#Parameters

-- returns the rational lower bound -729/4096
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x z t;
vartable = [x, z];
prog = sosprogram(vartable);
p = x^4+x^2-3*x^2*z^2+z^6
prog = sosineq(prog,p-t); % p-t>=0
prog = sossolve(prog);

% Returns the lower bound -.177979
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

Alternatively, all software have a simplified notation for finding this lower bound.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,z];
p = x^4+x^2-3*x^2*z^2+z^6
(t,sol) = lowerBound (p, RoundTol=>12);

-- returns t = -729/4096
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x z;
p = x^4+x^2-3*x^2*z^2+z^6
[t,vars,xopt] = findbound(p)

% Returns t = -.177979
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

# Example 4: Constrained polynomial optimization

We illustrate how to compute the SOS relaxation of degree-$2d$.
First we consider an example with only equalities constraints:
$$
    \min_{x,y} \quad x-y
    \quad\text{ s.t. }\quad 
    x^2 - x = y^2 - y = 0.
$$

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,y];
d = 1;
f = x - y;
h = matrix{{x^2 - x, y^2 - y}};
(t,sol,mult) = lowerBound (p, h, 2*d);

-- returns t = -1
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
d = 1;
f = x - y;
h = [x^2 - x, y^2 - y];
[t,vars,xopt] = findbound(f, [], h, 2*d)

% Returns t = -1
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

Now we consider an input with equalities and  inequalities:
$$
    \min_{x,y} \quad x+y
    \quad\text{ s.t. }\quad 
    x^2 + y^2 = 1, \;
    y - x^2 = 0.5, \;
    x \geq 0, \;
    y \geq 0.5.
$$

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
This is not yet possible to do in Macaulay2.
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
d = 2;
f = x+y;
g = [x, y-0.5];
h = [x^2+y^2-1, y-x^2-0.5];
[t,vars,opt] = findbound(f,g,h,2*d);

% Returns t = 1.3911
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
