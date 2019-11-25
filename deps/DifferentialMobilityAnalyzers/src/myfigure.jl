# +
# This file sets defaults for the Plots figure properties
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         May, 2018
#-
function figure(f, s, w, h, fs)
	m = fs == 8 ? 6 : 7
	font, lfont, ms = Plots.font(f, m*s),  Plots.font(f, (m-2)*s), 2*s
	font, lfont, ms = Plots.font(f, m*s),  Plots.font(f, (m-1)*s), 2*s
	default(size = (w*72*s,h*72*s), xtickfont = font, ytickfont = font,
		legendfont = lfont, guidefont = font, markersize = ms)
	return 0
end
