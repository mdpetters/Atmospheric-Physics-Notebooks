using DifferentialMobilityAnalyzers, Distributions
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

tests = ["dmafunctions",
         "sizedistribution",
         "inversion1",
         "inversion2",
         "inversion3",
         "coagulation"]

println("Running tests:")

for testfun in tests
    println(" * $(testfun)")
    include("$(testfun).jl")
end
