
# +
# This file loads a TSI-AIM data file. A few elements are hardcoded. The
# function is thus not flexible. It's only use is to provide the data
# for a notebook to test the inversion routine. The file parses the
# different sections of the text file and places the resulting specta
# into a data structure.
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         April, 2018
#-

function loadtsidata()
    f = open("Data/20130618_1410_SMPS3_BP.txt")
    header = String[]
    for i in 1:21
        push!(header, readline(f))
    end

    Dp, dNdlog10D = Float64[], Array{Float64}[]
    for i in 1:107
        l = readline(f)
        x = split(l)
        push!(Dp,parse(Float64,x[1]))
        current = Float64[]
        for j = 2:length(x)
            push!(current, parse(Float64,x[j]))
        end
        push!(dNdlog10D, current)
    end
    dNdlog10D = hcat(dNdlog10D...)'

    de = Float64[]
    for i = 1:length(Dp)-1
        push!(de,sqrt(Dp[i]*Dp[i+1]))
    end
    de = [11.9709, de..., 562.341]

    footer = String[]
    for i in 1:26
        push!(footer, readline(f))
    end
    x = split(footer[end-1])
    Nt = Float64[]

    for j = 3:length(x)
        push!(Nt, parse(Float64,x[j]))
    end

    rawdp, rawc = Float64[], Array{Float64}[]
    for i in 1:1200
        l = readline(f)
        x = split(l)
        push!(rawdp,parse(Float64,x[2]))
        current = Float64[]
        for j = 3:2:length(x)
            push!(current, parse(Float64,x[j]))
        end
        push!(rawc, current)
    end
    rawc = hcat(rawc...)'
    close(f)

    𝕟 = SizeDistribution[]
    for s = 1:length(dNdlog10D[1,:])
        dlog10D = log10.(de[2:end]./de[1:end-1])
        dlnD = log.(de[2:end]./de[1:end-1])
        N = dNdlog10D[:,s].*dlog10D
        dNdlnD = N./dlnD
        push!(𝕟, SizeDistribution([],reverse(de),reverse(Dp),reverse(dlnD),
                            reverse(dNdlnD),reverse(N),:TSI))
    end

    𝕟, rawdp, rawc, Nt
end
