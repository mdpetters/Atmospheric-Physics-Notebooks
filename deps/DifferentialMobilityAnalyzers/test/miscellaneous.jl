x = figure("Helvetica", 2, 5.5, 2, 8)
@test x == 0

pwd()
cd("../docs/")
𝕟, rawdp, rawc, Nt_TSI = loadtsidata();
@test round.(Int,Nt_TSI[[1,10]]) == [197,4979]
cd("../test/")
