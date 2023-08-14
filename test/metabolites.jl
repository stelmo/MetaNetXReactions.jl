@testset "Metabolites" begin
    m = get_metabolite_from_chebi(36986)

    @test m.id == "MNXM727488"
    @test m.name == "mesaconate"
    @test m.smiles == "C(=C\\C(=O)[O-])C(=O)[O-]"
    @test m.charge == -2
    @test m.formula == "C5H4O4"
    @test "mescon" in m.crossreferences["bigg.metabolite"]
end
