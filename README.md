# MetaNetXReactions.jl

[repostatus-url]: https://www.repostatus.org/#active
[repostatus-img]: https://www.repostatus.org/badges/latest/active.svg

[![repostatus-img]][repostatus-url]


This is a simple package you can use to query reactions from MetaNetX.
```julia
using MetaNetXReactions # load module

r = get_reaction_from_rhea(11844) # get some data using Rhea reaction id

m = get_metabolite_from_chebi(36986) # get some data using chebi id
```