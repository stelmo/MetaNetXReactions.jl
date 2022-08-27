using MetaNetXReactions
using Test

@testset "MetaNetXReactions.jl" begin
    clear_cache!()
    include("reactions.jl")
    include("metabolites.jl")
end
