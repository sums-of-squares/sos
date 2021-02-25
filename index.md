---
layout: default
---

## Introduction

In this guide we explain how to perform basic sum of squares (SOS) computations,
and provide numerical examples of sum of squares programming/optimization using
solvers. Depending on which mathematical computer language/environment you are
most familiar with, you may use *either* of the following tools:

- Macaulay2: [SumsOfSquares.m2](https://github.com/diegcif/SumsOfSquares.m2)
- MATLAB: [SOSTOOLS](https://www.cds.caltech.edu/sostools/)
- Julia: [SumOfSquares.jl](https://github.com/JuliaOpt/SumOfSquares.jl)
- Python: [SumOfSquares.py](https://github.com/yuanchenyang/SumOfSquares.py)

At a high level, these tools parse an SOS problem expressed in
terms of polynomials, into a semidefinite optimization problem (SDP)
which is later solved numerically using a backend SDP solver.

In the simple examples below, we provide implementations using either
of these tools. Just click on the corresponding tab to see the code,
which you can then copy and paste into the corresponding program.

For more advanced problems, please look at the exercises for the [AMS Short
Course on Sums of Squares](exercises.html).

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
installPackage "SumsOfSquares"

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
# Download SumOfSquares.py from github and run from the terminal:
# $ python setup.py install
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

Once installed, the following lines must be entered at the beginning of each session.

<!-- +++++++++++++ MACAULAY2 +++++++++++++ -->
{% capture macaulay2_code %}
needsPackage( "SumsOfSquares" );

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
import sympy as sp
import numpy as np
from SumOfSquares import SOSProblem, poly_opt_prob
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}



### Backend SDP Solvers

SOS computations rely on semidefinite programming (SDP) solvers.
The following solvers are available as of December 2018:

- Macaulay2: [CSDP](https://github.com/coin-or/Csdp/wiki) (preinstalled), [MOSEK](https://www.mosek.com/), [SDPA](http://sdpa.sourceforge.net/).
- MATLAB: [CDCS](https://github.com/oxfordcontrol/CDCS), [CSDP](https://github.com/coin-or/Csdp/wiki), [MOSEK](https://www.mosek.com/), [SDPA](http://sdpa.sourceforge.net/), [SDPNAL](http://www.math.nus.edu.sg/~mattohkc/SDPNALplus.html), [SDPT3](http://www.math.nus.edu.sg/~mattohkc/SDPT3.html), [SeDuMi](http://sedumi.ie.lehigh.edu/).
- Julia: [CDCS](https://github.com/oxfordcontrol/CDCS.jl), [COSMO](https://github.com/oxfordcontrol/COSMO.jl), [CSDP](https://github.com/JuliaOpt/CSDP.jl), [MOSEK](https://github.com/JuliaOpt/Mosek.jl), [ProxSDP](https://github.com/mariohsouto/ProxSDP.jl), [SCS](https://github.com/JuliaOpt/SCS.jl), [SDPA](https://github.com/JuliaOpt/SDPA.jl), [SDPAFamily](https://github.com/ericphanson/SDPAFamily.jl), [SDPNAL](https://github.com/JuliaOpt/SDPNAL.jl), [SDPT3](https://github.com/JuliaOpt/SDPT3.jl), [SeDuMi](https://github.com/JuliaOpt/SeDuMi.jl).
- Python: [MOSEK](https://github.com/JuliaOpt/Mosek.jl), [CVXOPT](http://cvxopt.org/)


## Examples

### Example 1: Checking if a polynomial is SOS

Here we find an SOS decomposition for the polynomial
$$p = 2 x^4 + 2 x^3 y - x^2 y^2 + 5 y^4$$.

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
# Defines symbolic variables and polynomial
x, y = sp.symbols('x y')
p = 2*x**4 + 2*x**3*y - x**2*y**2 + 5*y**4
prob = SOSProblem()

# Adds Sum-of-Squares constaint and solves problem
const = prob.add_sos_constraint(p, [x, y])
prob.solve()

# Prints Sum-of-Squares decomposition
print(sum(const.get_sos_decomp()))
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}


We next consider the Motzkin polynomial, $$p = x^4 y^2 + x^2 y^4 - 3 x^2 y^2 +
1$$, which is nonnegative but no SOS decomposition exists.

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y = sp.symbols('x y')
p = x**4*y**2 + x**2*y**4 - 3*x**2*y**2 + 1
prob = SOSProblem()
prob.add_sos_constraint(p, [x, y])
prob.solve() # Raises SolutionFailure error due to infeasibility
{% endcapture %}


{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

### Example 2: Parametric SOS problems

In the next example we consider the variables $$s$$, $$t$$ as parameters, and find
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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y, s, t = sp.symbols('x y s t')
p = s*x**6 + t*y**6 - x**4*y**2 - x**2*y**4 - x**4 \
    + 3*x**2*y**2 - y**4 - x**2 - y**2 + 1
prob = SOSProblem()
prob.add_sos_constraint(p, [x, y])
sv, tv = prob.sym_to_var(s), prob.sym_to_var(t)
prob.solve()
prob.set_objective('min', sv+tv)
print(sv.value, tv.value)
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

We can also do parameter optimization with $$s$$ and $$t$$. Among the values of $$s$$
and $$t$$ that make the polynomial a sum-of-squares, we look for those with the
minimum value of $$s+t$$.

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y, s, t = sp.symbols('x y s t')
p = s*x**6 + t*y**6 - x**4*y**2 - x**2*y**4 - x**4 \
    + 3*x**2*y**2 - y**4 - x**2 - y**2 + 1
prob = SOSProblem()
prob.add_sos_constraint(p, [x, y])
sv, tv = prob.sym_to_var(s), prob.sym_to_var(t)
prob.set_objective('min', sv+tv)
prob.solve()
print(sv.value, tv.value)
# returns s ~ 1.203, t ~ 1.203
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

Finally, we consider a problem involving multiple SOS constraints. Suppose we
want to find the smallest $$t$$ so that both $$p_1 = t(1+xy)^2 - xy + (1-y)^2$$ and
$$p_2 = (1-xy)^2+xy+t(1+y)^2$$ are sums of squares.

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y, t = sp.symbols('x y t')
p1 = t*(1 + x*y)**2 - x*y + (1 - y)**2
p2 = (1 - x*y)**2 + x*y + t*(1 + y)**2
prob = SOSProblem()
prob.add_sos_constraint(p1, [x, y])
prob.add_sos_constraint(p2, [x, y])
tv = prob.sym_to_var(t)
prob.set_objective('min', tv)
prob.solve()
print(tv.value)
# returns t ~ 0.25
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

### Example 3: Global polynomial optimization

Consider the polynomial $$p = x^4+x^2-3 x^2 z^2+z^6$$.  We may find a lower
bound on $$p$$ by looking for the largest value of $$t$$ so that $$p - t$$ is a
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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y, t = sp.symbols('x y t')
p = x**4 + x**2 - 3*x**2*y**2 + y**6
prob = SOSProblem()
# Use Newton polytope reduction
prob.add_sos_constraint(p-t, [x, y], sparse=True)
prob.set_objective('max', prob.sym_to_var(t))
prob.solve()
print(prob.value)
# Returns the lower bound -.177979
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y, t = sp.symbols('x y t')
p = x**4 + x**2 - 3*x**2*y**2 + y**6
prob = poly_opt_prob([x, y], p)
prob.solve()
print(prob.value)
# Returns the lower bound -.177979
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

### Example 4: Constrained polynomial optimization

Consider minimizing a polynomial $$f(x)$$ subject to equations $$h_i(x)=0$$ and
inequalities $$g_j(x)\geq 0$$. Given a degree bound-$$2d$$, we can find a lower
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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y = sp.symbols('x y')
prob = poly_opt_prob([x, y], x - y, eqs=[x**2-x, y**2-y], deg=1)
prob.solve()
print(prob.value)
# returns t = -1
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

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

<!-- +++++++++++++++ PYTHON +++++++++++++++ -->
{% capture python_code %}
x, y = sp.symbols('x y')
prob = poly_opt_prob([x, y], x + y, eqs=[x**2+y**2-1, y-x**2-0.5],
                     ineqs=[x, y-0.5], deg=2)
prob.solve()
print(prob.value)
# returns t ~ 1.3911
{% endcapture %}

{% include nav-tabs.html macaulay2=macaulay2_code matlab=matlab_code julia=julia_code python=python_code%}

### Example 5: Dual formulation and Pseudoexpectations

The dual of a SOS problem can be interpreted as optimizing linear functionals of
low-degree polynomials, also known as
[pseudoexpectations](https://www.sumofsquares.org/public/lec01-2_definitions.html#sec-pseudo-distributions). Using
[SumOfSquares.py](https://github.com/yuanchenyang/SumOfSquares.py), we can
specify constraints in terms of pseudoexpectations, as well as extract the
pseudoexpectation corresponding to the dual of a SOS constraint.

The following example explicitly computes an infeasibility certificate for
writing the Motzkin polynomial $$p(x, y) = x^4 y^2 + x^2 y^4 - 3 x^2 y^2 + 1$$ as
a sum of squares, a pseudoexpectation where $$\tilde{\mathbb{E}}[p(x,y)] = -1$$.

{% capture python_code %}
x, y = sp.symbols('x y')
p = x**4*y**2 + x**2*y**4 - 3*x**2*y**2 + 1 # Motzkin polynomial
prob = SOSProblem()
# A degree 6 pseudoexpectation operator in variables x and y
PEx = prob.get_pexpect([x, y], 6)
prob.add_constraint(PEx(p) == -1)
prob.solve()

# After solving, we can compute PEx on any suitable polynomial
# in x and y of degree at most 6
print(PEx(x**2*y**4 + x*y + 3))
{% endcapture %}

{% include python-tabs.html python=python_code%}

Every SOS constraint has an associated pseudoexpectation, we can access it for
use in rounding algorithms. The next example presents both the primal and dual
SOS relaxations of the following optimization problem over the sphere:

$$
    \max_{x,y,z} \quad (x+\phi y)(x-\phi y)(y+\phi z)(y-\phi z)(z+\phi x)(z-\phi x)
    \quad\text{ s.t. }\quad
    x^2 + y^2 + z^2 = 1.
$$

{% capture python_code %}
x, y, z, t= sp.symbols('x y z t')
phi = (1+np.sqrt(5))/2
x2 = x**2 + y**2 + z**2
f = (x+phi*y)*(x-phi*y)*(y+phi*z)*(y-phi*z)*(z+phi*x)*(z-phi*x)

p = t * x2**3 - f
prob_p = SOSProblem()
const_p = prob_p.add_sos_constraint(p, [x, y, z])
tv = prob_p.sym_to_var(t)
prob_p.set_objective('min', tv)
prob_p.solve()

prob_d = SOSProblem()
PEx = prob_d.get_pexpect([x, y, z], 6, hom=True)
prob_d.add_constraint(PEx(x2**3) == 1)
prob_d.set_objective('max', PEx(f))
prob_d.solve()

# prob_p.value ~= prob_d.value (up to numerical error)
{% endcapture %}

{% include python-tabs.html python=python_code%}

After solving the SOS relaxation, we can produce a feasible solution using the
following rounding algorithm:

1. Sample $$v$$ uniformly at random from the sphere
2. Compute $$M = \tilde{\mathbb{E}}_x[\langle v, x \rangle^4 xx^T]$$
3. Return the normalized top eigenvector of $$M$$

We can implement this rounding algorithm using either the primal or dual
formulation:

{% capture python_code %}
def sample_M_entries():
    v = np.random.normal(size=3)
    v = v/np.linalg.norm(v)
    p = (a*x+b*y+c*z)**4
    return [m*p for m in (x*x, y*y, z*z, x*y, x*z, y*z)]

def round_top_eig(Mxx, Myy, Mzz, Mxy, Mxz, Myz):
    M = np.array([[Mxx, Mxy, Mxz], [Mxy, Myy, Myz], [Mxz, Myz, Mzz]])
    v = np.linalg.eigh(M)[1][:,-1]
    return v / np.linalg.norm(v)

def round_primal():
    moments = [float(const_p.pexpect(e)) for e in sample_M_entries()]
    return round_top_eig(*moments)

def round_dual():
    moments = [float(PEx(e)) for e in sample_M_entries()]
    return round_top_eig(*moments)

# round_primal() or round_dual() produces a feasible solution
# sampled from the rounding algorithm
{% endcapture %}

{% include python-tabs.html python=python_code%}
