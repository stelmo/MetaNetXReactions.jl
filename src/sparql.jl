#=
SPARQL queries
=#

_from_rhea_reaction_body(rid::Int64) = """
PREFIX mnx: <https://rdf.metanetx.org/schema/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rhea: <http://rdf.rhea-db.org/>
SELECT *
WHERE{
    ?reac mnx:reacXref rhea:$(rid) .
    ?reac ?side ?part .
}
"""