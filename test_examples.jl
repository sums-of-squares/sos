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
    @test status == :Optimal
end
@test_example "example1_motzkin" begin
    @test status == :Infeasible
end
@test_example "example2" begin
    @test getvalue(s) ≈  4.6555  rtol=1e-4
    @test getvalue(t) ≈  4.6555  rtol=1e-4
end
@test_example "example2_objective" begin
    @test getvalue(s) ≈  1.2032  rtol=1e-4
    @test getvalue(t) ≈  1.2032  rtol=1e-4
end
@test_example "example2_both" begin
    @test getvalue(t) ≈  1/4     rtol=1e-6
end
@test_example "example3" begin
    @test getvalue(t) ≈ -0.17700 rtol=1e-4
end
@test_example "example4" begin
    @test getvalue(t) ≈ -1       rtol=1e-6
end
@test_example "example4_inequalities" begin
    @test getvalue(t) ≈  1.3911  rtol=1e-4
end
