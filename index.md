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
$p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4$.

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
clear; echo on;
syms x y;
vartable = [x, y];
% First, initialize the sum of squares program
prog = sosprogram(vartable);   % No decision variables.

% Next, define the inequality

% p(x,y) >=  0
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4;
prog = sosineq(prog,p);

% And call solver
prog = sossolve(prog);

% Program is feasible, thus p(x,y) is an SOS.
echo off;
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

R = QQ[x,y,z]
p = x^4*y^2+x^2*y^4-3*x^2*y^2+1
sosPoly solveSOS p

-- returns the message "dual infeasible"
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
% SOSDEMO1 --- Sum of Squares Test
% Section 3.1 of SOSTOOLS User's Manual
%

clear; echo on;
syms x1 x2;
vartable = [x1, x2];
% First, initialize the sum of squares program
prog = sosprogram(vartable);   % No decision variables.

% Next, define the inequality

% p(x1,x2) >=  0
p = 2*x1^4 + 2*x1^3*x2 - x1^2*x2^2 + 5*x2^4;
prog = sosineq(prog,p);

% And call solver
prog = sossolve(prog);

% Program is feasible, thus p(x1,x2) is an SOS.
echo off;
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

# Example 2: 
