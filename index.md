---
layout: default
---

## Introduction

In this guide we explain how to perform basic sum of squares (SOS)
computations. Depending on which mathematical computer
language/environment you are most familiar with, you may use *either*
of the following tools:

- Macaulay2: [SOS.m2](https://github.com/diegcif/SOSm2)
- MATLAB: [SOSTOOLS](https://www.cds.caltech.edu/sostools/)
- Julia: [SumOfSquares.jl](https://github.com/JuliaOpt/SumOfSquares.jl)

At a high level, these tools parse an SOS problem expressed in
terms of polynomials, into a semidefinite optimization problem (SDP)
which is later solved numerically using a backend SDP solver.

In the simple examples below, we provide implementations using either
of these tools. Just click on the corresponding tab to see the code,
which you can then copy and paste into the corresponding program.

For more advanced problems, please look at the exercises for the [AMS Short Course on Sums of Squares](exercises.html).

We point out that other SOS tools are also available, mainly in MATLAB, such as
[YALMIP](https://yalmip.github.io/tutorial/sumofsquaresprogramming/)
and
[GloptiPoly](http://homepages.laas.fr/henrion/software/gloptipoly/).


## Installation and configuration

Here are simple instructions to install and configure the desired
tools. Recall that for either choice, a backend SDP solver is needed,
so you may need to install that too. Please see the full documentation
of each package for additional details.

### Main package

For installation, type the following commands.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
installPackage "SemidefiniteProgramming"
installPackage "SOS"

{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
% Download SOSTOOLS and save it in some directory.
% The following code has been tested with SOSTOOLS release v3.03
% Start MATLAB, go to this directory, and run the script:
addsostools
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/install.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

Once installed, the following lines must be entered at the beginning of each session.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage( "SOS" );

-- the default solver is CSDP
-- it can be changed with the command
changeSolver ("MOSEK", "/path/to/mosek")
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
% Make sure SOSTOOLS package is listed under "Set Path"

% Set backend solver, in this case CSDP
options.solver='csdp';
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/preamble_using.jl %}

{% include julia/preamble.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}





### Backend SDP Solvers

SOS computations rely on semidefinite programming (SDP) solvers.
The following solvers are available as of December 2018:

- Macaulay2: [CSDP](https://github.com/coin-or/Csdp/wiki) (preinstalled), [MOSEK](https://www.mosek.com/), [SDPA](http://sdpa.sourceforge.net/).
- MATLAB: [SeDuMi](http://sedumi.ie.lehigh.edu/), [MOSEK](https://www.mosek.com/), [SDPT3](http://www.math.nus.edu.sg/~mattohkc/SDPT3.html), [CSDP](https://github.com/coin-or/Csdp/wiki), [SDPNAL](http://www.math.nus.edu.sg/~mattohkc/SDPNALplus.html), [CDCS](https://github.com/oxfordcontrol/CDCS) and [SDPA](http://sdpa.sourceforge.net/).
- Julia: [CSDP](https://github.com/coin-or/Csdp/wiki), [MOSEK](https://www.mosek.com/), [SCS](https://github.com/cvxgrp/scs), [SDPA](http://sdpa.sourceforge.net/), [SeDuMi](https://github.com/blegat/SeDuMi.jl).



## Examples

### Example 1: Checking if a polynomial is SOS

Here we find an SOS decomposition for the polynomial
$p = 2 x^4 + 2 x^3 y - x^2 y^2 + 5 y^4$.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,y];
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4;
sosPoly solveSOS p
-- returns the rational SOS decomposition
-- p = 5 (-(11/25)*x^2+y^2)^2 +  17/5*(5/17*x^2+x*y)^2 + 1568/2125 * x^4
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
p = 2*x^4 + 2*x^3*y - x^2*y^2 + 5*y^4;
[Q, Z] = findsos(p, options)
% Returns matrices Q and Z so that Z.'*Q*Z = p
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example1.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

We next consider the Motzkin polynomial, $p = x^4 y^2 + x^2 y^4 - 3 x^2 y^2 +
1$, which is nonnegative but no SOS decomposition exists.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,y]
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
sosPoly solveSOS p
-- returns the message "dual infeasible"
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
p = x^4*y^2 + x^2*y^4 - 3*x^2*y^2 + 1
[Q,Z] = findsos(p, options);
% Program is infeasible, no sum-of-squares solution found
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example1_motzkin.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

### Example 2: Parametric SOS problems

In the next example we consider the variables $s$, $t$ as parameters, and find
values for them such that the following polynomial is a sum-of-squares.

$$ p = s x^6+t y^6-x^4 y^2-x^2 y^4-x^4+3 x^2 y^2-y^4-x^2-y^2+1 $$

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,y][s,t]
p = s*x^6 + t*y^6 - x^4*y^2 - x^2*y^4 - x^4 + 3*x^2*y^2 - y^4 - x^2 - y^2 + 1
sol = solveSOS p
sol#Parameters
-- returns s = t = 135/4
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y s t;
p = s*x^6 + t*y^6 - x^4*y^2 - x^2*y^4 - x^4 + 3*x^2*y^2 - y^4 - x^2 - y^2 + 1

prog = sosprogram([x;y], [s;t]);
prog = sosineq(prog, p); % p is sos
prog = sossolve(prog, options);
sosgetsol(prog, [s,t])
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example2.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

We can also do parameter optimization with $s$ and $t$. Among the values of $s$
and $t$ that make the polynomial a sum-of-squares, we look for those with the
minimum value of $s+t$.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,y][s,t]
p = s*x^6 + t*y^6 - x^4*y^2 - x^2*y^4 - x^4 + 3*x^2*y^2 - y^4 - x^2 - y^2 + 1
sol = solveSOS(p,s+t)
sol#Parameters
-- returns s = t = 645962169/536870912 ~ 1.203
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y s t;
p = s*x^6 + t*y^6 - x^4*y^2 - x^2*y^4 - x^4 + 3*x^2*y^2 - y^4 - x^2 - y^2 + 1

prog = sosprogram([x;y], [s;t]);
prog = sosineq(prog, p);     % p is sos
prog = sossetobj(prog, s+t); % minimizes s+t
prog = sossolve(prog, options);
sosgetsol(prog, [s,t])
% returns s ~ 1.203, t ~ 1.203
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example2_objective.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

Finally, we consider a problem involving multiple SOS constraints. Suppose we
want to find the smallest $t$ so that both $p_1 = t(1+xy)^2 - xy + (1-y)^2$ and
$p_2 = (1-xy)^2+xy+t(1+y)^2$ are sums of squares.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
This is not yet possible in Macaulay2.
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y t;
p1 = t*(1 + x*y)^2 - x*y + (1 - y)^2;
p2 = (1 - x*y)^2 + x*y + t*(1 + y)^2;

prog = sosprogram([x;y], [t]);
prog = sosineq(prog, p1);   % p1 is sos
prog = sosineq(prog, p2);   % p2 is sos
prog = sossetobj(prog, t); % minimizes t
prog = sossolve(prog, options);
sosgetsol(prog, t)
% returns t = 0.25
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example2_both.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

### Example 3: Global polynomial optimization

Consider the polynomial $p = x^4+x^2-3 x^2 z^2+z^6$.  We may find a lower
bound on $p$ by looking for the largest value of $t$ so that $p - t$ is a
sum-of-squares. This can be formulated using techniques similar to the previous
section.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
R = QQ[x,z][t];
p = x^4 + x^2 - 3*x^2*z^2 + z^6
sol = solveSOS (p-t, -t, RoundTol=>12);
sol#Parameters
-- returns the rational lower bound -729/4096
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x z t;
p = x^4 + x^2 - 3*x^2*z^2 + z^6

prog = sosprogram([x;z], [t]);
prog = sosineq(prog, p-t);  % p - t is sos
prog = sossetobj(prog, -t); % maximizes t
prog = sossolve(prog, options);
sosgetsol(prog, t)
% Returns the lower bound -.177979
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example3.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

Alternatively, some tools have a simplified way for finding this lower bound.

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
[t,vars,xopt] = findbound(p, options)
% Returns t = -.177979
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
# Not available in SumOfSquares.jl
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

### Example 4: Constrained polynomial optimization

Consider minimizing a polynomial $f(x)$ subject to equations $h_i(x)=0$ and
inequalities $g_j(x)\geq 0$. Given a degree bound-$2d$, we can find a lower
bound based on SOS.  The next example has only equality constraints:

$$ \min_{x,y} \quad x-y \quad\text{ s.t. }\quad x^2 - x = y^2 - y = 0.$$

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
<!-- using raw environment to escape double curly braces -->
{% capture macaulay2_code %}
{% raw %}
R = QQ[x,y];
d = 1;
f = x - y;
h = matrix{{x^2 - x, y^2 - y}};
(t,sol,mult) = lowerBound (f, h, 2*d);
-- returns t = -1
{% endraw %}
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
d = 1;
obj = x - y;
ineqs = [];
eqs = [x^2 - x, y^2 - y];
[t,vars,xopt] = findbound(obj, ineqs, eqs, 2*d, options)
% Returns t = -1
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example4.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}

Now consider a problem with equalities and inequalities:

$$
    \min_{x,y} \quad x+y
    \quad\text{ s.t. }\quad
    x^2 + y^2 = 1, \;
    y - x^2 = 0.5, \;
    x \geq 0, \;
    y \geq 0.5.
$$

When solving constrained optimization problems, one usually also have to specify
a degree bound to indicate the level of the sum-of-squares hierarchy to use. The
higher the degree the better the relaxation, but it comes at a cost of
increased computation time.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
This is not yet possible in Macaulay2.
{% endcapture %}

<!-- ++++++++++++++ MATLAB +++++++++++++++ -->
{% capture matlab_code %}
syms x y;
d = 2;
obj = x + y;
ineqs = [x, y - 0.5];
eqs = [x^2 + y^2 - 1, y - x^2 - 0.5];
[t,vars,xopt] = findbound(obj, ineqs, eqs, 2*d, options)
% Returns t ~ 1.3911
{% endcapture %}

<!-- +++++++++++++++ JULIA +++++++++++++++ -->
{% capture julia_code %}
{% include julia/example4_inequalities.jl %}
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code %}
