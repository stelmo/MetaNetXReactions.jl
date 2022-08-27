@testset "From Rhea reactions" begin 
    # PFL
    r = MetaNetXReactions.get_reaction_from_rhea(11844)

    @test r.id == "MNXR188637"
    @test "2.3.1.54" in r.classification
    @test all(in.(["11844", "11845", "11846", "11847"], Ref(r.crossreferences["rhea"])))
end