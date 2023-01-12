using Primes
# This first function outputs the order of GL(n, p)
function GLnpOrder(n, p)
    n = BigInt(n)
    p = BigInt(p)
    j = 1
    for i in 0:(n-1)
        j = j * (p^n-p^i)
    end
    return(j)
end

# This function finds the possibilities for prime p and n > 1 such that p^n divides the order of the sporadic group
function possiblepn(order)
    possiblepn = []
    orderFact = factor(Vector, order)
    for p in orderFact
        power = count(x->(x==p), orderFact)
        if power > 1
            for j in 2:power
                append!(possiblepn, [[p, j]])
            end
        end
    end
    return(Set(possiblepn))
end

# Then, we check which of these possible p, n pairs also have GL(n, p) divisible by the order of the sporadic group
function dividesGL(order)
    possiblepn2 = []
    for pn in possiblepn(order)
        if GLnpOrder(pn[2], pn[1]) % order == 0
            append!(possiblepn2, [pn])
        end
    end
    return(possiblepn2)
end

# Now, we just print these possibilities for each sporadic group using a list of the orders of the spoardic groups
orders = [7920,95040,443520,10200960,244823040,175560,604800,50232960,86775571046077562880,495766656000,42305421312000,4157776806543360000,64561751654400,4089470473293004800,1255205709190661721292800,44352000,898128000,4030387200,145926144000,448345497600,460815505920,273030912000000,51765179004000000,90745943887872000,4154781481226426191177580544000000,808017424794512875886459904961710757005754368000000000]
for order in orders
    println("The following [p,n] combinations satisfy p^n divides ", order, " and ", order, " divides GL(n,p):")
    println(dividesGL(order))
end
