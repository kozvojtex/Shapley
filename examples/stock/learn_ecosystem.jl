
using Maen
using StatsBase, Statistics, IterTools, MLDataPattern
using Flux, EvalMetrics
using Flux: @epochs
using BSON

#map(x->x[1].=x[2], zip(model_params, ecosystem[:model_params]))

println("Training...")

minibatchrun = (x) -> map(data->model(eco, data)[end], eachcol(x))

acc = (x, y) -> mean((reduce(vcat, minibatchrun(x)) .> .5) .== y)

loss = (x, y) -> Flux.huber_loss(reduce(vcat, minibatchrun(x)), y; δ=0.4)

cb = () -> println("accuracy = ", acc(data, labels), 
    " loss = ", loss(data, labels))

@epochs 3 Flux.Optimise.train!(
        loss, Flux.params(params_objects), repeatedly(minibatch, 1000), 
        ADAM(), cb = Flux.throttle(cb, 5))

println("total: accuracy = ", acc(data, labels), " loss = ", loss(data, labels))

println(binary_eval_report(reduce(vcat, testbatch()[2])[:,1], minibatchrun(testbatch()[1])))

#bson("model.bson", ecosystem=eco, ps=params_objects)
