# Using Mosek as the SDP solver
model = SOSModel(with_optimizer(Mosek.Optimizer))
