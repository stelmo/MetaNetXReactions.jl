
"""
$(TYPEDSIGNATURES)

Shortcut for `get(get(dict, key1, Dict()), key2, nothing)`.
"""
_double_get(dict, key1, key2; default = nothing) =
    get(get(dict, key1, Dict()), key2, default)

"""
$(TYPEDSIGNATURES)

A simple SPARQL query that returns all the data matching `query` from  the
Rhea endpoint. Returns `nothing` if the query errors. Can retry at most
`max_retries` before giving up. 
"""
function _request_data(query; max_retries = 5)
    retry_counter = 0
    req = nothing
    while retry_counter <= max_retries
        retry_counter += 1
        try
            req = HTTP.request(
                "POST",
                ENDPOINT_URL,
                [
                    "Accept" => "application/sparql-results+json",
                    "Content-type" => "application/x-www-form-urlencoded",
                ],
                Dict("query" => query),
            )
        catch
            req = nothing
        end
    end
    return req
end

"""
$(TYPEDSIGNATURES)

Parse a json string returned by a rhea request into a dictionary.
"""
function _parse_json(unparsed_json)
    parsed_json = Dict{String,Vector{String}}()
    !haskey(unparsed_json, "results") && return parsed_json
    !haskey(unparsed_json["results"], "bindings") && return parsed_json
    unparsed_json["results"]["bindings"]
end

"""
$(TYPEDSIGNATURES)

Combine [`_request_data`](@ref) with [`_parse_json`](@ref).
"""
function _parse_request(args...; kwargs...)
    req = _request_data(args...; kwargs...)
    isnothing(req) && return nothing
    preq = _parse_json(JSON.parse(String(req.body)))
    isempty(preq) ? nothing : preq
end

"""
$(TYPEDSIGNATURES)

Get reaction data corresponding to the Rhea id `rid`. This function is cached
automatically by default, use `should_cache` to change this behavior.
"""
function get_reaction_from_rhea(rid::Int64; should_cache = true)
    _is_cached("reaction_from_rhea", rid) && return _get_cache("reaction_from_rhea", rid)

    rxn_vec = _parse_request(_from_rhea_reaction_body(rid))
    isnothing(rxn_vec) && return nothing

    rr = MetaNetXReaction()
    db = Dict{String,Vector{String}}()
    for rxn in rxn_vec
        reac = last(split(rxn["reac"]["value"], "/"))
        side = last(split(rxn["side"]["value"], "/"))
        part = last(split(rxn["part"]["value"], "/"))

        if rr.id == ""
            rr.id = reac
        elseif rr.id != reac
            throw(error("Multiple reaction IDs found."))
        end

        if side == "reacXref"
            if contains(rxn["part"]["value"], "identifiers.org")
                db_name = first(split(part, ":"))
                db_link = last(split(part, ":"))
                if haskey(db, db_name)
                    db_link ∉ db[db_name] && push!(db[db_name], db_link)
                else
                    db[db_name] = [db_link]
                end
            end
        elseif side == "classification"
            part ∉ rr.classification && push!(rr.classification, part)
        end
    end
    rr.crossreferences = db

    should_cache && _cache("reaction_from_rhea", rid, rr)

    return rr
end

"""
$(TYPEDSIGNATURES)

Internal helper function to construct a metabolite from a parsed sparql query.
"""
function _metabolite(met_vec)

    mm = MetaNetXMetabolite()
    db = Dict{String,Vector{String}}()
    for _met in met_vec
        met = last(split(_met["met"]["value"], "/"))
        side = last(split(_met["side"]["value"], "/"))
        part = last(split(_met["part"]["value"], "/"))

        if mm.id == ""
            mm.id = met
        elseif mm.id != met
            throw(error("Multiple metabolite IDs found."))
        end

        if side == "chemXref"
            if contains(_met["part"]["value"], "identifiers.org")
                db_name = first(split(part, ":"))
                db_link = last(split(part, ":"))
                if haskey(db, db_name)
                    db_link ∉ db[db_name] && push!(db[db_name], db_link)
                else
                    db[db_name] = [db_link]
                end
            end
        elseif side == "rdf-schema#comment"
            mm.name = part
        elseif side == "inchi"
            mm.inchi = part
        elseif side == "inchikey"
            mm.inchikey = part
        elseif side == "charge"
            mm.charge = parse(Int64, part)
        elseif side == "formula"
            mm.formula = part
        elseif side == "smiles"
            mm.smiles = part
        end
    end
    mm.crossreferences = db

    return mm
end

"""
$(TYPEDSIGNATURES)

Get metabolite data corresponding to the ChEBI id `cid`. This function is cached
automatically by default, use `should_cache` to change this behavior.
"""
function get_metabolite_from_chebi(cid::Int64; should_cache = true)
    _is_cached("metabolite_from_chebi", cid) &&
        return _get_cache("metabolite_from_chebi", cid)

    met_vec = _parse_request(_from_chebi_metabolite_body(cid))
    isnothing(met_vec) && return nothing

    mm = _metabolite(met_vec)

    should_cache && _cache("metabolite_from_chebi", cid, mm)

    return mm
end

"""
$(TYPEDSIGNATURES)

Get metabolite data corresponding to the MetaNetX id `id`. This function is cached
automatically by default, use `should_cache` to change this behavior.
"""
function get_metabolite_from_metanetx(id::String; should_cache = true)
    _is_cached("metabolite_from_metanetx", id) &&
        return _get_cache("metabolite_from_metanetx", id)

    met_vec = _parse_request(_from_metanetx_metabolite_body(id))
    isnothing(met_vec) && return nothing

    mm = _metabolite(met_vec)

    should_cache && _cache("metabolite_from_metanetx", id, mm)

    return mm
end

"""
$(TYPEDSIGNATURES)

"""
function get_chebi_to_metanetx_map(cid::Int64; should_cache = true)
    _is_cached("chebi_metanetx", cid) && return _get_cache("chebi_metanetx", cid)

    met_vec = _parse_request(_from_chebi_metantex_body(cid))
    isnothing(met_vec) && return nothing
    mids = unique([last(split(_met["met"]["value"], "/")) for _met in met_vec])

    should_cache && _cache("chebi_metanetx", cid, mids)

    return mids
end
