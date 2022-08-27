module MetaNetXReactions

using HTTP, JSON, DocStringExtensions, Term, Scratch, Serialization

# cache data using Scratch.jl
CACHE_LOCATION::String = ""
#=
Update these cache directories, this is where each cache type gets stored.
These directories are saved to in e.g. _cache("reaction_from_rhea", rid, rr) in utils.jl
=#
const CACHE_DIRS = ["reaction_from_rhea"]

function __init__()
    global CACHE_LOCATION = @get_scratch!("metanetx_data")

    for dir in CACHE_DIRS
        !isdir(joinpath(CACHE_LOCATION, dir)) && mkdir(joinpath(CACHE_LOCATION, dir))
    end

    if isfile(joinpath(CACHE_LOCATION, "version.txt"))
        vnum = read(joinpath(CACHE_LOCATION, "version.txt"))
        if String(vnum) != string(Base.VERSION)
            Term.tprint("""
                        {red} Caching uses Julia's serializer, which is incompatible
                        between different versions of Julia. Please clear the cache with
                        `clear_cache!()` before proceeding. {/red}
                        """)
        end
    else
        write(joinpath(CACHE_LOCATION, "version.txt"), string(Base.VERSION))
    end
end

const Maybe{T} = Union{T,Nothing}
const ENDPOINT_URL = "https://rdf.metanetx.org/sparql"

include("cache.jl")
include("sparql.jl")
include("types.jl")
include("utils.jl")

export clear_cache!,
    get_reaction_from_rhea

end
