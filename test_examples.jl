using Test

include("_includes/julia/preamble_using.jl")

macro test_example(name, test_code)
    file = "_includes/julia/$name.jl"
    quote
        @testset "$($name)" begin
            include("_includes/julia/preamble.jl")
            include($file)
            $test_code
        end
    end
end

@test_example "example1" begin
    @test termination_status(model) == MOI.OPTIMAL
end
@test_example "example1_motzkin" begin
    @test termination_status(model) == MOI.INFEASIBLE
end
@test_example "example2" begin
    @test termination_status(model) == MOI.OPTIMAL
    @test value(s) ≈  4.2956  rtol=1e-4
    @test value(t) ≈  4.2956  rtol=1e-4
end
@test_example "example2_objective" begin
    @test value(s) ≈  1.2032  rtol=1e-4
    @test value(t) ≈  1.2032  rtol=1e-4
end
@test_example "example2_both" begin
    @test value(t) ≈  1/4     rtol=1e-6
end
@test_example "example3" begin
    @test value(t) ≈ -0.1778  rtol=1e-3
end
@test_example "example4" begin
    @test value(t) ≈ -1       rtol=1e-6
end
@test_example "example4_inequalities" begin
    @test value(t) ≈  1.3911  rtol=1e-4
end
