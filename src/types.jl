"""
$(TYPEDEF)

A struct for storing MetaNetXReaction reaction information. Focusses on the
cross references.

$(FIELDS)
"""
@with_repr mutable struct MetaNetXReaction
    id :: String
    classification :: Vector{String} # EC number
    crossreferences :: Dict{String, Vector{String}}
end

MetaNetXReaction() = MetaNetXReaction("", String[], Dict{String, Vector{String}}())