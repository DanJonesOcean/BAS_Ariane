#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#   		Plots a temperature transect along 57N and saves	      #
#                          it in the working dir                              #
# --------------------------------------------------------------------------- #
# Dave's handrolled modules.
import nemo

# Import required modules.
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# --------------------------------------------------------------------------- #

# Specify where the input data lives.
homedir = '/Users/mbk'
nemodir = '/Documents/BAS/Ariane/ariane-2.2.8_04/'

# Pick the year to plot.
year = '2010'

# Specify the names of the different files that I want to load from.
filename = 'course/DATA/ORCA025-N401_20000105d05T.nc'
gridfile = 'Fields/mesh_hgr_matt.nc'

# --------------------------------------------------------------------------- #

# Load the coordinates.
gphit = np.squeeze(nemo.load_field('gphit', homedir, nemodir, gridfile, 'T'))
glamt = np.squeeze(nemo.load_field('glamt', homedir, nemodir, gridfile, 'T'))
gdept = np.squeeze(nemo.load_field('gdepw_0', homedir, nemodir, gridfile))

# Load the masks.
tmask = np.squeeze(nemo.load_field('tmask', homedir, nemodir, gridfile, 'T'))

# Load the fields and remask them.
ntemp = np.squeeze(nemo.load_field('votemper', homedir, nemodir, filename, 'T'))
ntemp = nemo.mask_field(ntemp, tmask)

#--------------------------------------------------------------------------- #
# Create a new figure window and title it.
plt.figure(figsize=(12.0, 12.0))
plt.title('Temperature transect at 57N')

# Draw contour plot of temperature field.
transplt  = plt.contourf(np.repeat(glamt[950:1120, 770 : 771].T, 75, axis=0).T,
                      -np.repeat(gdept.T[:, None], 170, axis=1).T,
                      np.squeeze(ntemp[950:1120, 770 : 771, :]),
                      np.arange(2., 3.6, .01),
                      cmap='viridis', vmin=2., vmax=3.6,
                      extend='both')

contours = plt.contour(np.repeat(glamt[950:1120, 770 : 771].T, 75, axis=0).T,
                      -np.repeat(gdept.T[:, None], 170, axis=1).T,
                      np.squeeze(ntemp[950:1120, 770 : 771, :]),
                      np.arange(2., 3.6, .1), colors='black')
plt.clabel(contours, inline=True, fontsize=8)
# Add a colour bar.
cbar = plt.colorbar(transplt, ticks=np.arange(2., 3.6, 0.1))
plt.show()

# Save a hires version of the figure
plt.savefig('57N_temp_profile_NA.png', bbox_inches='tight', dpi=1200)

#--------------------------------------------------------------------------- #

