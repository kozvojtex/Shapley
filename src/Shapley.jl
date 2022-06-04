
module Shapley

export shapley
export Agent, Network

Base.@kwdef mutable struct Agent{T}
    model::T
    ps::Dict{Symbol, Vector}
    name::String
    data::Array{Float64, N} where N
    shapley::AbstractFloat = 0.0
    output::S = model(data)
end

Base.@kwdef mutable struct Network{T}
    model::T
    ps::Dict{Symbol, Vector}
    name::String
end

@doc """
    The Shapley algorithm for computing the Shapley values of a set of
    agents. The Shapley values are the expected utility of each agent in a set. 
    The algorithm is based on the following paper: 
    https://www.researchgate.net/publication/2707816_The_Shapley_value_algorithm_for_the_computation_of_expected_utility_of_a_set_of_agents
    """
function shapley(agents::Array{Agent}, network::Network, expected::Array{AbstractFloat, N, M}) where {T, N, M}
    # Compute the Shapley values of each agent
    for agent in agents
        agent.shapley = shapley_value(agent, network, expected)
    end
    # Sort the agents by their Shapley values
    agents = sort(agents, by={"shapley": "descending"})
    # Return the Shapley values of the agents
    return agents.map({"shapley": "shapley"})
end


function shapley_value(agent::Agent, network::Network, expected::Array{AbstractFloat, N, M}) where {T, N, M}
    # Compute the Shapley value of the agent
    
end
    

end # module
