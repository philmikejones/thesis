load("data/res_weights_random.RData")
res_weights_random = res_weights

load("data/res_weights.RData")

all.equal(sum(res_weights), sum(res_weights_random))

stopifnot(all.equal(colnames(res_weights), colnames(res_weights_random)))

all.equal(lapply(res_weights, sum),
          lapply(res_weights_random, sum))

sum(res_weights_random - res_weights)
