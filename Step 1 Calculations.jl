# First, we create functions which output the order of a simple group, given its family and parameters
# n is used to represent the rank of group, while q is a prime power representing the order of the base field for lie type groups
function AnOrder(n) # Alternating Groups: n > 4
    return factorial(big(n))/2
end
function AnqOrder(n, q) # Projective Special Linear Groups: n > 0
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n
        j = j*(q^(i+1)-1)
    end
    return q^((n+1)*n/2)*j/gcd(n+1,q-1)
end
function BnqOrder(n, q) # Orthogonal Groups in Odd Dimension: n > 1
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n
        j = j*(q^(2*i)-1)
    end
    if q == 2 && n == 2
        return q^(n^2)*j/gcd(2,q-1)/2
    else
        return q^(n^2)*j/gcd(2,q-1)
    end
end
function CnqOrder(n, q) # Symplectic Groups: n > 2
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n
        j = j*(q^(2*i)-1)
    end
    return q^(n^2)*j/gcd(2,q-1)
end
function DnqOrder(n, q) # Orthogonal Groups in Even Dimension: n > 3
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n - 1
        j = j*(q^(2*i)-1)
    end
    return (q^n-1)*q^(n*(n-1))*j/gcd(4,q^n-1)
end
function E6qOrder(q) # Chevally Exceptional Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,5,6,8,9,12]
        j = j*(q^i-1)
    end
    return q^36*j/gcd(3,q-1)
end
function E7qOrder(q) # Chevally Exceptional Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,6,8,10,12,14,18]
        j = j*(q^i-1)
    end
    return q^63*j/gcd(2,q-1)
end
function E8qOrder(q) # Chevally Exceptional Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,8,12,14,18,20,24,30]
        j = j*(q^i-1)
    end
    return q^120*j
end
function F4qOrder(q) # Chevally Exceptional Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,6,8,12]
        j = j*(q^i-1)
    end
    return q^24*j
end
function G2qOrder(q) # Chevally Exceptional Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,6]
        j = j*(q^i-1)
    end
    return q^6*j
end
function Anq2Order(n, q) # Projective Special Unitary Groups: n > 1
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n
        j = j*(q^(i+1)-(-1^(i+1)))
    end
    return q^(n*(n+1)/2)*j/gcd(n+1,q+1)
end
function Dnq2Order(n, q) # Twisted Orthogonal Chevally Groups: n > 3
    n = BigInt(n)
    q = BigInt(q)
    j = 1
    for i in 1:n
        j = j*(q^(2*i)-1)
    end
    return q^(n*(n+1))*(q^n+1)*j/gcd(4,q^n+1)
end
function E6q2Order(q) # Twisted Exceptional Chevally Group: q is a Prime Power
    q = BigInt(q)
    j = 1
    for i in [2,5,6,8,9,12]
        j = j*(q^i-(-1)^i)
    end
    return q^36*j/gcd(3,q+1)
end
function D4q3Order(q)  # Twisted Exceptional Chevally Group: q is a Prime Power
    q = BigInt(q)
    return q^12*(q^8+q^4+1)*(q^6-1)*(q^2-1)
end
function B2q2Order(q) # Suzuki Groups: q is a Prime Power
    q = BigInt(q)
    return q^(2)*(q^(2)+1)*(q-1)
end
function F4q2Order(q) # Ree Groups in Characteristic 2: q = 2 ^ (2m+1)
    q = BigInt(q)
    return q^12*(q^6+1)*(q^4-1)*(q^3+1)*(q-1)
end
function F2Order() # Tits Group
    return 17971200
end
function G2q2Order(q) # Ree Groups in Characteristic 3: q = 3 ^ (3m+1)
    q = BigInt(q)
    return q^3*(q^3+1)*(q-1)
end

# Now, we create functions which, given the order of a sporadic group, check which simple groups of each family have order dividing the order of the sporadic group
# To do this, (when applicable) we first find a maximal value for n for which the simple group has order not greater than that of the sporadic group
# Then, for each possible value of n, we check which values of q make the group order divide
# To make this check doable, we note the following:
    # For any Lie type group, q divides the order of the group
    # For any sporadic group, the largest powers of prime dividing the order of the group is at most:
    # 2^46, 3^20, 5^9, 7^6, 11^2, 13^1, 17^1, 19^1, 23^1, 29^1, 31^1, 37^1, 41^1, 47^1, 59^1, 67^1, 71^1
# Thus, we only need to check prime powers q which divide one of these numbers
# Here, we create a list of all such possible prime powers
global allpossibleq = []
for pa in [[2,46],[3,20],[5,9],[7,6],[11,2],[13,1],[17,1],[19,1],[23,1],[29,1],[31,1],[37,1],[41,1],[47,1],[59,1],[67,1],[71,1]]
    for a in 1:pa[2]
        append!(allpossibleq, BigInt(pa[1])^a)
    end
end
sort!(allpossibleq)
# Now, here are the functions for checking order divisibility
function AnOrderDivisible(order)
    possiblen = []
    maxn = 5
    testOrder = AnOrder(maxn)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = AnOrder(maxn)
    end
    maxn = maxn - 1
    for n in 5:maxn
        if order % AnOrder(n) == 0
            append!(possiblen, n)
        end
    end
    return(possiblen)
end
function AnqOrderDivisible(order)
    possiblenq = []
    maxn = 1
    testOrder = AnqOrder(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = AnqOrder(maxn, 2)
    end
    maxn = maxn - 1
    for n in 1:maxn
        for q in allpossibleq
            if order % AnqOrder(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function BnqOrderDivisible(order)
    possiblenq = []
    maxn = 2
    testOrder = BnqOrder(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = BnqOrder(maxn, 2)
    end
    maxn = maxn - 1
    for n in 2:maxn
        for q in allpossibleq
            if order % BnqOrder(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function CnqOrderDivisible(order)
    possiblenq = []
    maxn = 3
    testOrder = CnqOrder(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = CnqOrder(maxn, 2)
    end
    maxn = maxn - 1
    for n in 3:maxn
        for q in allpossibleq
            if order % CnqOrder(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function DnqOrderDivisible(order)
    possiblenq = []
    maxn = 4
    testOrder = DnqOrder(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = DnqOrder(maxn, 2)
    end
    maxn = maxn - 1
    for n in 4:maxn
        for q in allpossibleq
            if order % DnqOrder(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function E6qOrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % E6qOrder(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function E7qOrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % E7qOrder(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function E8qOrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % E8qOrder(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function F4qOrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % F4qOrder(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function G2qOrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % G2qOrder(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function Anq2OrderDivisible(order)
    possiblenq = []
    maxn = 2
    testOrder = Anq2Order(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = Anq2Order(maxn, 2)
    end
    maxn = maxn - 1
    for n in 2:maxn
        for q in allpossibleq
            if order % Anq2Order(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function Dnq2OrderDivisible(order)
    possiblenq = []
    maxn = 4
    testOrder = Dnq2Order(maxn, 2)
    while testOrder <= order
        maxn = maxn + 1
        testOrder = Dnq2Order(maxn, 2)
    end
    maxn = maxn - 1
    for n in 4:maxn
        for q in allpossibleq
            if order % Dnq2Order(n, q) == 0
                append!(possiblenq, [[n,q]])
            end
        end
    end
    return(possiblenq)
end
function E6q2OrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % E6q2Order(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function D4q3OrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % D4q3Order(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function B2q2OrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % B2q2Order(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function F4q2OrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % F4q2Order(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end
function F2OrderDivisible(order)
    if order % F2Order() == 0
        return true
    else
        return false
    end
end
function G2q2OrderDivisible(order)
    possibleq = []
    for q in allpossibleq
        if order % G2q2Order(q) == 0
            append!(possibleq, q)
        end
    end
    return(possibleq)
end

function orderDivisible(order) # We output all the possible simple groups whose order divides that of the sporadic group
    println("Sporadic group of order: ", order, " has order divible by the orders of the following simple groups:")
    for n in AnOrderDivisible(order)
        print("\$\\mathrm{A}_{", n, "}\$, ")
    end
    for nq in AnqOrderDivisible(order)
        if nq ∉ [[1,2], [1,3], [1,4], [1,5], [2,2], [1,9], [3,2]]
            print("\$\\mathrm{PSL}_{", nq[1] + 1, "}(", nq[2],")\$, ")
        end
    end
    for nq in BnqOrderDivisible(order)
        if nq == [2,2]
            print("\$\\mathrm{O}_{", 2*nq[1]+1, "}(", nq[2],")'\$, ")
        else
            print("\$\\mathrm{O}_{", 2*nq[1]+1, "}(", nq[2],")\$, ")
        end
    end
    for nq in CnqOrderDivisible(order)
        print("\$\\mathrm{PSp}_{", 2*nq[1], "}(", nq[2],")\$, ")
    end
    for nq in DnqOrderDivisible(order)
        print("\$\\mathrm{O}^+_{", 2*nq[1], "}(", nq[2],")\$, ")
    end
    for q in E6qOrderDivisible(order)
        print("\$\\mathrm{E}_6(", q, ")\$, ")
    end
    for q in E7qOrderDivisible(order)
        print("\$\\mathrm{E}_7(", q, ")\$, ")
    end
    for q in E8qOrderDivisible(order)
        print("\$\\mathrm{E}_8(", q, ")\$, ")
    end
    for q in F4qOrderDivisible(order)
        print("\$\\mathrm{F}_4(", q, ")\$, ")
    end
    for q in G2qOrderDivisible(order)
        if q == 2
            print("\$\\mathrm{G}_2(2)'\$, ")
        else
            print("\$\\mathrm{G}_2(", q, ")\$, ")
        end
    end
    for nq in Anq2OrderDivisible(order)
        if nq ∉ [[2,2], [3,2]]
            print("\$\\mathrm{PSU}_{", nq[1]+1, "}(", nq[2],")\$, ")
        end
    end
    for nq in Dnq2OrderDivisible(order)
        print("\$\\mathrm{O}^-_{", 2*nq[1], "}(", nq[2],")\$, ")
    end
    for q in E6q2OrderDivisible(order)
        print("\$ ^2\\mathrm{E}_6(", q, ")\$, ")
    end
    for q in D4q3OrderDivisible(order)
        print("\$ ^3\\mathrm{D}_4(", q, ")\$, ")
    end
    for q in B2q2OrderDivisible(order)
        if q in [2^3,2^5,2^7,2^9,2^11,2^13]
            print("\$ ^2\\mathrm{B}_2(", q, ")\$, ")
        end
    end
    for q in F4q2OrderDivisible(order)
        if q in [2^3,2^5,2^7,2^9,2^11,2^13]
            print("\$ ^2\\mathrm{F}_4(", q, ")\$, ")
        end
    end
    if F2OrderDivisible(order)
        print("\$ ^2\\mathrm{F}_4(2)'\$, ")
    end
    for q in G2q2OrderDivisible(order)
        if q in [3^3,3^5,3^7,3^9,3^11,3^13]
            print("\$ ^2\\mathrm{G}_2(", q, ")\$, ")
        end
    end
    println("")
    println("")
end

# Now that we have a list of all the possible simple groups whose order divides that of the sporadic group, we check through these to see which have order dividing at least three of the codegrees of the sporadic group in question
# For each sporadic group, the following function outputs which simple groups satisfy and the number of codegrees of the sporadic group which divide the order of the simple group
function codegreesDivisible(order, codSet)
    for n in AnOrderDivisible(order)
        testOrder = AnOrder(n)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of A_", n, " divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of A_", n, ".")
        end
    end
    for nq in AnqOrderDivisible(order)
        testOrder = AnqOrder(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of A_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of A_", nq[1], "(", nq[2],").")
        end
    end
    for nq in BnqOrderDivisible(order)
        testOrder = BnqOrder(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of B_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of B_", nq[1], "(", nq[2],").")
        end
    end
    for nq in CnqOrderDivisible(order)
        testOrder = CnqOrder(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of C_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of C_", nq[1], "(", nq[2],").")
        end
    end
    for nq in DnqOrderDivisible(order)
        testOrder = DnqOrder(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of D_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of D_", nq[1], "(", nq[2],").")
        end
    end
    for q in E6qOrderDivisible(order)
        testOrder = E6qOrder(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of E_6(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of E_6(", q, ").")
        end
    end
    for q in E7qOrderDivisible(order)
        testOrder = E7qOrder(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of E_7(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of E_7(", q, ").")
        end
    end
    for q in E8qOrderDivisible(order)
        testOrder = E8qOrder(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of E_8(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of E_8(", q, ").")
        end
    end
    for q in F4qOrderDivisible(order)
        testOrder = F4qOrder(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of F_4(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of F_4(", q, ").")
        end
    end
    for q in G2qOrderDivisible(order)
        testOrder = G2qOrder(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of G_2(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of G_2(", q, ").")
        end
    end
    for nq in Anq2OrderDivisible(order)
        testOrder = Anq2Order(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2A_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2A_", nq[1], "(", nq[2],").")
        end
    end
    for nq in Dnq2OrderDivisible(order)
        testOrder = Dnq2Order(nq[1], nq[2])
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2D_", nq[1], "(", nq[2],") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2D_", nq[1], "(", nq[2],").")
        end
    end
    for q in E6q2OrderDivisible(order)
        testOrder = E6q2Order(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2E_6(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2E_6(", q, ").")
        end
    end
    for q in D4q3OrderDivisible(order)
        testOrder = D4q3Order(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^3D_4(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^3D_4(", q, ").")
        end
    end
    for q in B2q2OrderDivisible(order)
        testOrder = B2q2Order(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2B_2(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2B_2(", q, ").")
        end
    end
    for q in F4q2OrderDivisible(order)
        testOrder = F4q2Order(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2F_4(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2F_4(", q, ").")
        end
    end
    if F2OrderDivisible(order)
        testOrder = F2Order()
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2F_2(2)' divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2F_2(2)'.")
        end
    end
    for q in G2q2OrderDivisible(order)
        testOrder = G2q2Order(q)
        counter = 0
        for codegree in codSet
            if testOrder % codegree == 0
                counter = counter + 1
            end
        end
        if counter > 3
            println("The order of ^2G_2(", q,") divides ", order, " and the sporadic group of order ", order, " has ", counter, " codegrees which divide the order of ^2G_2(", q, ").")
        end
    end
end

# Now, we just need to input the orders and codegree sets of the sporadic groups and run the function above for each:
orders = [7920,95040,443520,10200960,244823040,175560,604800,50232960,86775571046077562880,495766656000,42305421312000,4157776806543360000,64561751654400,4089470473293004800,1255205709190661721292800,44352000,898128000,4030387200,145926144000,448345497600,460815505920,273030912000000,51765179004000000,90745943887872000,4154781481226426191177580544000000,808017424794512875886459904961710757005754368000000000]
codegreeSets = [[ 1, 144, 176, 180, 495, 720, 792 ], [ 1, 540, 660, 792, 960, 1440, 1728, 1760, 2112, 5940, 8640 ], [ 1, 1152, 1584, 1920, 2112, 2880, 4480, 8064, 9856, 21120 ],[ 1, 5040, 9856, 10304, 11385, 13248, 40320, 44160, 44352, 226688, 463680 ],[ 1, 23552, 42240, 44160, 46080, 69552, 73920, 107520, 120960, 138240, 193536,
  236544, 247296, 317952, 506880, 967680, 971520, 1059840, 5440512, 10644480 ],[ 1, 840, 1320, 1463, 2280, 2310, 3135 ],[ 1, 1800, 2016, 2100, 2688, 2700, 3200, 3456, 3780, 4800, 6720, 8640, 9600, 16800,
  28800, 43200 ],[ 1, 16320, 18240, 20655, 25920, 26163, 31104, 41344, 44064, 61560, 77760, 155040, 155520, 590976 ],[ 1, 28405923840, 31815106560, 32222969856, 38263800960, 43362811904, 43786049417,
  45581598720, 47103344640, 54953902080, 57472450560, 60013150208, 73271869440,
  73326919680, 73381969920, 79683158016, 79932948480, 85374812160, 98022932480,
  109907804160, 110383595520, 125608919040, 175852486656, 188413378560, 219815608320,
  220311060480, 236988702720, 288900513792, 334041219072, 376826757120, 910664663040,
  2450515820544, 2637787299840, 2685937909760, 20223035965440, 25498610565120,
  48835700981760, 73096016953344, 97598130094080, 97744673832960, 289863515504640,
  65097952772751360 ],[ 1, 1944000, 1959552, 1987200, 2012040, 2187000, 2239488, 2688000, 2799360, 3827250,
  5313000, 5440512, 6123600, 6735960, 7838208, 8553600, 12317184, 15552000, 15676416,
  19008000, 21555072, 24057000, 51508224, 55987200, 69984000, 89424000, 123171840,
  140842800, 244944000, 279936000, 553311000, 1802787840, 1959552000, 21555072000 ],[ 1, 20185088, 20412000, 20736000, 21102592, 21233664, 21772800, 23054625, 23887872,
  32768000, 32845824, 49545216, 63700992, 66355200, 75694080, 90439680, 91570176,
  95551488, 98304000, 106168320, 114688000, 135168000, 148635648, 167215104,
  172032000, 176947200, 186624000, 191102976, 199065600, 229376000, 238878720,
  326592000, 371589120, 464257024, 668860416, 955514880, 1130496000, 1327104000,
  1337720832, 1839366144, 3344302080, 4069785600, 4395368448, 5971968000,
  10510663680, 18579456000, 20901888000, 23887872000, 153837895680, 167215104000,
  1839366144000 ],[ 1, 7536640000, 7962624000, 8239303800, 8257536000, 8281128960, 8599633920,
  8847360000, 8955765000, 10319560704, 10734796800, 11547360000, 12716605440,
  13436928000, 13759414272, 13872660480, 14192640000, 14834368512, 15571353600,
  16052649984, 16124313600, 16515072000, 16817061888, 17199267840, 18929272320,
  19289340000, 19707494400, 20038287360, 20242759680, 20639121408, 21756735000,
  22359048192, 22364160000, 22574039040, 25433210880, 27583756200, 37838389248,
  39171686400, 41278242816, 45416448000, 48771072000, 49662885888, 53508833280,
  62426972160, 63700992000, 68797071360, 72253440000, 75246796800, 80621568000,
  89181388800, 94466211840, 102991297500, 103514112000, 131681894400, 160526499840,
  167692861440, 168552824832, 171992678400, 178872385536, 192675840000, 193133445120,
  197520261120, 207028224000, 254332108800, 334430208000, 429981696000, 450861465600,
  544997376000, 716636160000, 756767784960, 1014068160000, 1444738498560,
  1476034560000, 1686896640000, 1719926784000, 2022633897984, 2282486169600,
  2347700060160, 2866544640000, 2898395136000, 4768727040000, 5056584744960,
  6171097300992, 6449725440000, 8608233553920, 11036196864000, 12039487488000,
  13243436236800, 43823734456320, 51502252032000, 93908002406400, 110361968640000,
  152299516723200, 241030539509760, 469540012032000, 2347700060160000,
  13905608048640000, 15064408719360000 ],[ 1, 23654400, 25259850, 26873856, 27869184, 31492800, 31850496, 34406400, 36044800,
  44778825, 47029248, 47443968, 53747712, 65691648, 66355200, 68812800, 75694080,
  80621568, 89579520, 95551488, 107495424, 110854656, 111476736, 111820800,
  111974400, 143327232, 161243136, 174182400, 178913280, 201553920, 214990848,
  222953472, 313528320, 429981696, 465813504, 564350976, 796262400, 859963392,
  1289945088, 1343692800, 1433272320, 1478062080, 2015539200, 2149908480, 4729798656,
  6019743744, 20961607680, 21499084800, 45148078080, 64497254400, 150493593600,
  827714764800 ],[ 1, 7309688832, 7739670528, 7763558400, 8103943809, 8230010880, 8578662400,
  11287019520, 11609505792, 11904278400, 11972302848, 12168817920, 12697896960,
  13060694016, 14145331200, 14149085184, 14213283840, 14285134080, 15459028200,
  15479341056, 15527116800, 16721510400, 18865446912, 18919194624, 19349176320,
  19680460800, 20065812480, 23219011584, 24552574200, 26726049792, 30656102400,
  41739376140, 43535646720, 52242776064, 55615300650, 62078607360, 69657034752,
  71425670400, 72559411200, 73365626880, 84652646400, 85136375808, 96745881600,
  100131987456, 108839116800, 116095057920, 139314069504, 143667634176, 152374763520,
  180592312320, 191556845568, 193491763200, 201231433728, 217379635200, 228562145280,
  270888468480, 338610585600, 383113691136, 386983526400, 448961356800, 465589555200,
  547596806400, 609499054080, 739090759680, 1044855521280, 1760775045120,
  1828497162240, 2095152998400, 2437996216320, 4806335397888, 4884699561984,
  5030785843200, 5180741959680, 5433248710656, 14627977297920, 14898865766400,
  36569943244800, 38311369113600, 67044895948800, 132396738969600, 158469754060800,
  804538751385600, 1139763231129600, 5229501884006400 ],[ 1, 3056202399744, 3134566563840, 3735358488576, 3813536563200, 4450310553600,
  4479818047488, 4740548198400, 5015306502144, 5572562780160, 5634815778900,
  6094990540800, 6345388002447, 6582589784064, 6817431436200, 7031383654400,
  7401059942400, 7829681989248, 8029628006400, 8149873065984, 8290811510784,
  8356803436800, 8617953544200, 8815968460800, 8828957491200, 9009678705300,
  9597266446950, 10584509644800, 11284439629824, 11519532122112, 12259638116352,
  16221381967872, 16278356694600, 16761223987200, 17631936921600, 18642099974400,
  19664496230400, 22568879259648, 23144221900800, 26934053437440, 27862813900800,
  28211099074560, 31345665638400, 32483055666600, 33618226397184, 33957804441600,
  34054550323200, 35263873843200, 42630105268224, 45137758519296, 50153065021440,
  58237634617344, 73139886489600, 73539870243840, 86523783413760, 90275517038592,
  123423558451200, 132944804388864, 137920928808960, 147158085519900, 175535727575040,
  193951306137600, 217341172460160, 250765325107200, 382277806718976, 391193907167232,
  394955387043840, 534835419955200, 814987306598400, 938628543283200, 993030687424512,
  1128443962982400, 1173581721501696, 1974776935219200, 3023877182054400,
  4460880041164800, 7874423029186560, 8386219384897536, 11190402632908800,
  15798215481753600, 25672100157849600, 30964502344237056, 34990121696624640,
  38367094741401600, 258037519535308800, 753048271296921600, 782779008241631232,
  2259144813890764800, 5031731630938521600, 21838399867610726400,
  144759048459308236800, 1255205709190661721292800 ],[ 1, 13860, 16128, 17600, 23040, 25344, 31500, 32000, 42000, 49500, 53760, 57600,
  64000, 192000, 253440, 288000, 576000, 2016000 ],[ 1, 86400, 91125, 93312, 108864, 112000, 162000, 176000, 189000, 199584, 255150,
  513216, 1002375, 1166400, 3564000, 3888000, 40824000 ],[ 1, 172800, 182784, 187425, 193536, 230400, 279888, 293760, 338688, 351232, 370440,
  526848, 537600, 617400, 642600, 926100, 987840, 2099160, 3161088, 3916800, 5927040,
  26342400, 79027200 ],[ 1, 1228500, 1319500, 1382400, 1425060, 1484800, 1536000, 1597440, 1792000, 1916928,
  1935360, 2048000, 2211840, 2304000, 2764800, 3207168, 3328000, 4176000, 5324800,
  5404672, 6144000, 6709248, 7127040, 39936000, 44544000, 186368000, 359424000,
  386048000 ],[ 1, 1801800, 1843200, 2150400, 2274480, 2322432, 2365440, 2653560, 2737152, 3061800,
  3369600, 4478976, 4792320, 5068800, 5613300, 5971968, 6735960, 6967296, 6998400,
  8294400, 8957952, 11197440, 17915904, 23654400, 28385280, 29859840, 31352832,
  37324800, 41803776, 75479040, 89579520, 130636800, 447897600, 574801920,
  1231718400, 3135283200 ],[ 1, 1968624, 2222297, 2621696, 2623995, 2722048, 3214080, 3939840, 5417280, 7112448,
  7856640, 7902720, 8749440, 12224520, 14224896, 17225460, 17781120, 34450920,
  42106680 ],[ 1, 46448640, 51200000, 53504000, 56770560, 59850000, 65691648, 70400000, 79734375,
  85322160, 91437500, 98058240, 102600000, 113400000, 114960384, 134400000,
  168000000, 173250000, 200475000, 201600000, 230400000, 256000000, 259200000,
  380160000, 416047104, 418037760, 672000000, 729000000, 746496000, 1008000000,
  1020600000, 1275750000, 3942400000, 4147200000, 7776000000, 16128000000,
  29030400000, 30643200000, 31104000000, 81648000000, 359251200000, 2052864000000 ],[ 1, 729000000, 797537664, 924000000, 962793216, 976800000, 1132866000, 1134000000,
  1172232000, 1200765625, 1336414464, 1403325000, 1530900000, 1683990000, 1749600000,
  1798200000, 1899450000, 2289515625, 2428864704, 2694384000, 2814000000, 3061800000,
  4374000000, 4811400000, 9622800000, 10357875000, 12247200000, 16839900000,
  17094000000, 33734232000, 44906400000, 135594000000, 431146546875, 1074546000000,
  1132866000000, 20873056050000 ],[ 1, 476672000, 815173632, 995328000, 1118208000, 1172791872, 1189773312, 1244364800,
  1755758592, 2047032000, 2257403904, 2974593375, 3144241152, 4255027200, 4998537216,
  5486745600, 7838208000, 8384643072, 13552261632, 13607129088, 18381717504,
  18590208000, 22009688064, 22154771457, 26873856000, 35271936000, 37035532800,
  53152848000, 94810963968, 116453376000, 118214656000, 616271265792, 1055246745600,
  1481421312000, 2939139883008, 2962842624000, 3360960884736, 22009688064000,
  365911064064000 ],[ 1, 251077388622888960, 292162779488452608, 296460339904512000, 298028167216496640,
  318463255756800000, 334407263412289536, 350492915404031400, 365044965908152320,
  408880886579200000, 409983359385600000, 422012903705542656, 432932703436800000,
  433983836552953856, 434169654018048000, 434691492544512000, 451046133412875000,
  473520144384000000, 482955440947200000, 495275012731699200, 497491628173295616,
  528361508044800000, 529043763599769600, 536515235020800000, 539689578777280512,
  541042184237875200, 548456466021875712, 595282467225600000, 599161950122803200,
  620845906412961792, 647667324341452800, 693385017824378880, 757459057933025280,
  790273982464000000, 795332010829676544, 800273618496000000, 844507393504051200,
  876488338465357824, 894748512183386112, 899332341799845888, 908950869519630336,
  959140517310889984, 977501812477132800, 981891371394662400, 990677827584000000,
  1014454095446016000, 1021167026250448896, 1082084368475750400, 1132130770517753856,
  1168651117953810432, 1197665030787563520, 1353958066055282688, 1388992423526400000,
  1407031286169600000, 1428351366387990528, 1489791223899095040, 1521681143169024000,
  1572187120532437500, 1590664021659353088, 1619660501220851712, 1704282880349306880,
  1956291506130124800, 2154355595673600000, 2298682146816000000, 2427160677580800000,
  2474142754406400000, 2726852608558891008, 2847831323207270400, 2986552856993071104,
  3030528924057600000, 3466925089121894400, 3798116133349883904, 3984426968316641280,
  4290873340723200000, 4916932193864908800, 4972701391257600000, 5064154844466511872,
  5133137722956840960, 5357975137733836800, 5779442840371200000, 5811976588492800000,
  6136821071216640000, 6247511584092979200, 6267133814951116800, 6362656086637412352,
  6427581148745957376, 6978086948044800000, 7141756831939952640, 7370163879936000000,
  9822954419178700800, 10736982146200633344, 11394348400049651712,
  11902928053233254400, 14608138974422630400, 15947855409960714240,
  18368716131532800000, 19684467268034494464, 19698438006374400000,
  22848042364682895360, 25529175656261222400, 29516088999936000000,
  33645895719321600000, 34772791748198400000, 35067548978380800000,
  43743260595632209920, 46356494345501147136, 53022134055311769600,
  88216802898739200000, 101445409544601600000, 107474677762778726400,
  108341409035059200000, 117692525916979200000, 169075682574336000000,
  185908857531436892160, 194635191660463521792, 208301240931581952000,
  215875831510912204800, 238599603248902963200, 321379057437297868800,
  349426684268189319168, 382797912578457600000, 394582064964682383360,
  405781638178406400000, 417208449109510324224, 495828204519424000000,
  508850174275721625600, 566708908798771200000, 620358968447147704320,
  627693471557222400000, 676032209205225062400, 676302730297344000000,
  858958571696050667520, 949529033337470976000, 1014019925791997952000,
  1583089431080022835200, 2166828180701184000000, 3791082584954791526400,
  6479304781559098245120, 6533022140596224000000, 7532930331143936409600,
  7749928324222156800000, 13414599915993877708800, 16423054160604898000896,
  26485177313761689600000, 38346364807859404800000, 45753859919009632223232,
  51659423786548026408960, 54780521154084864000000, 151544833720660367769600,
  307569801063038976000000, 332335161668114841600000, 447374256091693056000000,
  898736534123403490099200, 971796300732511027200000, 984223363401724723200000,
  1292414517598224384000000, 2952670090205174169600000, 11668952196490848318259200,
  11951283698449514496000000, 65396174590470153830400000, 435026726623562327654400000,
  439252700539334075980185600, 3646547561403390099456000000,
  43164318541649017621708800000, 950533397672483685924864000000 ],[ 1, 3121886130664334738168217600, 3340751819938073245072265625,
  3802609456660282150653788160, 3894677586780800513539571712,
  3974228958570750610652528640, 4032206836607609300267827200,
  4076697908635552972800000000, 4540282874326155264000000000,
  4594463680606765056000000000, 4647375873084648082504679424,
  4690988726758730559494553600, 4950580283367333994967334912,
  5001288051104723522027520000, 5813553889957089406710937500,
  5916296284641165312000000000, 5936605762127502234982809600,
  5975267654148695145622536192, 6201820487799013376000000000,
  6236024715386558548706250000, 6437500255456985088000000000,
  6465062295166318018560000000, 6513202803115998708468750000,
  6668417059689710223360000000, 7016167995938116668569419776,
  7817951988511408128000000000, 9084581921031192576000000000,
  9373032013535083677037363200, 9622144626164330680509530112,
  10436346646107015610368000000, 10829559753949052928000000000,
  11696013227744821248000000000, 12141447071358793236961296384,
  12561256287341305039473868800, 12674621526138421248000000000,
  13024544247964853049600000000, 13827061077344366100480000000,
  14337625322706960384000000000, 15743354151812186332427452416,
  15977393906675351900966092800, 18563535119679750144000000000,
  18966888527633055744000000000, 19237844078027813683200000000,
  19348000106608630334855577600, 19358838593116331964358459392,
  21002851810476136857600000000, 21656444273800842517216837632,
  23960999952796719513600000000, 23987890321057004912640000000,
  27174004259295269376000000000, 29380403078120470346307993600,
  32917980958700234342400000000, 35710918203575107584000000000,
  50158110183130556006400000000, 54119794628387129704132870800,
  63870441474174935535452160000, 80609448654425680806942867456,
  84233548770903392256000000000, 84236062379830935552000000000,
  85238439518479880775417200640, 85812945083604452182218750000,
  91051799820627534151680000000, 96260883798263322378240000000,
  102919897947547326070684385280, 106779600834123693571700686848,
  109548427495335758937716686848, 113510059749783502848000000000,
  146535730833827907436921875000, 151483020601518046461296640000,
  164008832782370592522240000000, 190600910839633021500936683520,
  201787017716605401668958289920, 223258013963472863232000000000,
  228428199549995392696320000000, 246158364117452193792000000000,
  326135832690844237824000000000, 364572368613559640228194418688,
  370362367945834758144000000000, 485971095615510675456000000000,
  505291836590492750008069128192, 593454477184801406189568000000,
  778732498465893384192000000000, 1171435782746318831616000000000,
  1171441732684773064704000000000, 1233314569147253495954197708800,
  1288956054463553727083724609375, 1346649085461946957824000000000,
  1351679977880649990144000000000, 1863815325104316874752000000000,
  2058057677936235344465001185280, 2066492729522749786030080000000,
  2298558757971828639006720000000, 2440028495193132603801600000000,
  2663392400026704680460862095360, 2911349800309081656642659942400,
  3089039493744622385930761666560, 3098231975541268709923859988480,
  3667364159441942347776000000000, 3706019109499125251105095680000,
  4224727020497748272614314344448, 4998588732004917129593556566016,
  5400651916738896382656000000000, 5512627389140098602762240000000,
  7014476612025004258239499468800, 7074661372139893948416000000000,
  8872644481440560405544960000000, 9335684801608657856888832000000,
  11435231592151580990165540143104, 13315216418213406651187200000000,
  18817183118152295180840120352768, 19607525211966364844208294985728,
  25477731249808751858810880000000, 32751930388666011762032640000000,
  37058818495321067649846843801600, 40817384252616405417984000000000,
  63077055049349021564928000000000, 79644711790301427384975360000000,
  111806758939836168903243438489600, 123050416959236201250816000000000,
  144855905422641010311168000000000, 176917492208156343020940165120000,
  339077503665583752944955477196800, 343580811539022130603622400000000,
  456989620685330898254705832493056, 545854642497676315174625133723648,
  597201300490177348632576000000000, 672651827008206129856512000000000,
  879773288090321261061734400000000, 1041129168917257132449016200560640,
  1169057187696951945068544000000000, 1255939576117611476224573440000000,
  1261426702069449640378368000000000, 2126843963745364534099968000000000,
  2822834686410514481283072000000000, 4686891395766802320457728000000000,
  5181489564592441645313556480000000, 6195723296300505668741980603023360,
  10450759906246751554709233525063680, 16287484393246913912320819200000000,
  17054875484851816587035934720000000, 25594618332245150433647001600000000,
  26221097312344317285000806400000000, 28266203056854841530205349294899200,
  92300609423737961914773121951334400, 95546063795817563379644497920000000,
  224093302892373336039081277548134400, 230635791214443490525052928000000000,
  270558383606678735674952122368000000, 323150711414224940515196928000000000,
  2404515951474692478816391004160000000, 2780816372861778912067190784000000000,
  3217930279162306211385863717466931200, 13386681484630975696090725089280000000,
  20373343908422018477957327093760000000, 53235575620573170346676453376000000000,
  89973487489390003241081248418730344448, 340343275618597806238825709568000000000,
  727980050838549140239091572408320000000, 773319753144016517455776055296000000000,
  3625349713670864333173929541632000000000, 4246189839016690865526093643776000000000,
  6437835585927049385280225694187520000000, 22337464582345463126291625541632000000000,
  208294058924931652646229944303616000000000,
  2752536692223635423434322755977216000000000,
  41736302435368310930376155027472384000000000,
  43585323793784816536110247358496768000000000,
  958946690787650831064335863951392768000000000,
  37940654995338888008103155831949754368000000000,
  4104048723325593758153115835098564919296000000000 ]]

println("First, we check Lemma 2.4:")
for order in orders
    orderDivisible(order)
end
# Note that some of these are not actually simple groups because we do not check all the conditions (such as restricting q to the correct characteristic)
# However, after the next check, we only get simple groups so this does not matter
println("")
println("Now, we check Lemma 2.7:")
for i in 1:length(orders)
    codegreesDivisible(orders[i], codegreeSets[i])
end

######## RESULTS ########
# We get the following output:
# The order of D_4(3) divides 4089470473293004800 and the sporadic group of order 4089470473293004800 has 4 codegrees which divide the order of D_4(3).
# The order of G_2(4) divides 145926144000 and the sporadic group of order 145926144000 has 4 codegrees which divide the order of G_2(4).
# The order of D_4(2) divides 448345497600 and the sporadic group of order 448345497600 has 5 codegrees which divide the order of D_4(2).
# These three sporadic groups are (in order) Fi_23, Ru, and Suz
# These three simple groups of Lie type are (in order) O_8^+(3), G_2(4), and O_8^+(2) which are all in the ATLAS
#########################
