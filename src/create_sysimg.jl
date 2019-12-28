using Fezzik

Fezzik.trace()

include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Table 1.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 1.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 2.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Table 2.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 3.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 4.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 5.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 6.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 7.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 8.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Table 3.jl") 
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 9.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 10.jl")
include("../notebooks/Module 01 - Aerosol Dynamics/scripts/Aerosol Dynamics Figure 11.jl")

plt = aerosol_app3(10,0.0,7.0,1.2,0.0,7.0,1.2,0.0,7.0,1.2,0.0,7.0,1.2)
draw(SVG("foo.svg", 6Gadfly.inch, 4Gadfly.inch), plt)
rm("foo.svg")

Fezzik.brute_build_julia()

