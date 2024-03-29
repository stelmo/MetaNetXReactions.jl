#=
SPARQL queries
=#

_from_rhea_reaction_body(rid::Int64) = """
PREFIX mnx: <https://rdf.metanetx.org/schema/>
PREFIX rhea: <http://rdf.rhea-db.org/>
SELECT *
WHERE{
    ?reac a mnx:REAC .
    ?reac mnx:reacXref rhea:$(rid) .
    ?reac ?side ?part .
}
"""

_from_chebi_metabolite_body(cid::Int64) = """
PREFIX mnx: <https://rdf.metanetx.org/schema/>
PREFIX chebi: <https://identifiers.org/CHEBI:>
SELECT *
WHERE {
    ?met a mnx:CHEM .
    ?met mnx:chemXref chebi:$(cid) .
    ?met ?side ?part .
}

"""

_from_chebi_metantex_body(cid::Int64) = """
PREFIX mnx: <https://rdf.metanetx.org/schema/>
PREFIX chebi: <https://identifiers.org/CHEBI:>
SELECT *
WHERE {
    ?met a mnx:CHEM .
    ?met mnx:chemXref chebi:$(cid) .
}

"""

_from_metanetx_metabolite_body(str::String) = """
PREFIX mnx: <https://rdf.metanetx.org/schema/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
WHERE {
    ?met a mnx:CHEM .
    ?met rdfs:label \"$(str)\" .
    ?met ?side ?part .
}

"""
