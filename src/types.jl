"""
$(TYPEDEF)

A struct for storing MetaNetX reaction information. Focusses on the
cross references.

$(FIELDS)
"""
@with_repr mutable struct MetaNetXReaction
    id::String
    classification::Vector{String} # EC number
    crossreferences::Dict{String,Vector{String}}
end

MetaNetXReaction() = MetaNetXReaction("", String[], Dict{String,Vector{String}}())

"""
$(TYPEDEF)

A struct for storing MetaNetX metabolite information. Focusses on the
cross references.

$(FIELDS)
"""
@with_repr mutable struct MetaNetXMetabolite
    id::String
    name::String
    smiles::String
    inchi::String
    inchikey::String
    charge::Maybe{Int64}
    formula::String
    crossreferences::Dict{String,Vector{String}}
end

MetaNetXMetabolite() =
    MetaNetXMetabolite("", "", "", "", "", nothing, "", Dict{String,Vector{String}}())
