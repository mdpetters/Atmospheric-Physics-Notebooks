using Gadfly, Printf, DataFrames, Dates, CSV, Colors, LsqFit, Interact


compute_mode = button("Calculate PM2.5 From Fit"; value=0)

map(m->fitit(1,m),observe(on_mode))
map(m->fitit(2,m),observe(tw_mode))
map(m->fitit(3,m),observe(th_mode))
map(m->fitit(4,m),observe(fo_mode))