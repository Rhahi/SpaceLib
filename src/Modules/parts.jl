struct Resource
    name::String
    density::Float32 # kg/l
    amount::Float32 # l
end

function contents(part::SCR.Part)
    resources = Vector{Resource}()
    for r in SCH.All(SCH.Resources(part))
        if SCH.Enabled(r)
            res = Resource(SCH.Name(r), SCH.Amount(r), SCH.Density(r))
            push!(resources, res)
        end
    end
    return resources
end

function mass(resources::Vector{Resource})
    return sum([r.density * r.amount for r in resources])
end
