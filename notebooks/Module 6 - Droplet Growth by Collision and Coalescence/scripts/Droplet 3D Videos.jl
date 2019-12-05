using Makie

i = 1000   # number of drops in domain
lim = FRect3D((-0.4,-0.4,-0.4R),(0.8,0.8,0.8))
pos_func(dz) = rand(i).*1.0 .- 0.5 .+ dz
pos_func1(dz) = rand(i).*10.0 .- 10.0 .+ dz

x,y,z = pos_func(0.0),  pos_func(0.0), pos_func1(0.0)
scene  = Scene(resolution=(1920/2,1080/2), camera = cam3d!)
x1 = [-0.5,0.5,-0.5,0.5,-0.5,0.5,-0.5,0.5]
y1 = [-0.5,-0.5,-0.5,-0.5,0.5,0.5,0.5,0.5]
z1 = [0.5,0.5,-10,-10,0.5,0.5,-10,-10]
s1 = meshscatter!(scene,x1,y1,z1, color=[:darkgoldenrod3 for j = 1:8], markersize = [0.001 for j = 1:8], limits=lim)
s1 = meshscatter!(scene,x,y,z, color=[:darkgoldenrod3 for j = 1:i], markersize = [0.01 for j = 1:i], limits=lim)
s1 = meshscatter!(scene, [0.0],[0.0],[0.0], markersize = [0.05], color = [:steelblue3])

axis = scene[Axis] # get axis
axis[:names, :axisnames] = ("", "", "")
axis[:names][:textcolor] = ((:red, 1.0), (:blue, 1.0))
axis[:ticks][:textsize] = (0, 0)

display(scene)

# Vary these parameters to change fall velocity and density
# Droplet, domain size and velocity are hard-coded.
# Change domain size through x1,x2,x3 and random drop placement
# Change znew to initialize drop deep in domain for i < 1
# -10 = 5 mm depth
ztick = 2.0 # two ticks per mm
vt = 67.00  # 67 mm/s vertical fall velocity
fr = 120  # framerate
dz = vt/fr  # change in z in mm per frame
dzabs = dz*ztick  # change in relative units (1 mm/frame = 2 ticks)

Nd = 10000.0 # number per cm-3
jj = Nd*1e-3*1.25

record(scene, "o.mp4", 1:5*fr; framerate = fr) do j
    if j == 1
        AbstractPlotting.zoom!(scene, Point(0,0,0),5.1)
        translate!(scene, Vec3f0(0.5, 0.5, 0))
        rotate!(scene, Vec3f0(1, 0, 1), 0.0pi)
    end
    points = (s1[3][1])[]
    #znew = -100.0
    znew = -10.0
    (s1[3][1])[] = map(a->(points[a])[3] < 1 
                                ? points[a] .+ Point{3,Float32}([0,0.0,dzabs])  
                                : Point{3,Float32}([(rand(1))[1]-0.5,(rand(1))[1]-0.5,znew]), 1:i)

    (s1[3][:color])[] = [:darkgoldenrod3 for j = 1:i]
    (s1[3][:markersize])[] = [0.01 for j = 1:i]
end

