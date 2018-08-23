#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#   Plots the mean sea surface temperature in the southern ocean and saves    #
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
homedir = '/home/users/mbu66/'
nemodir = '/group_workspaces/jasmin2/nemo/vol1/ORCA025-N401/means/'

# Pick the year to plot.
year = '2010'

# Specify the names of the different files that I want to load from.
filename = ''.join([nemodir, year, '/ORCA025-N401_2010y01T.nc'])
gridfile = ''.join([homedir, 'examples/data/fields/mesh_hgr_matt.nc'])

# --------------------------------------------------------------------------- #

# Load the coordinates.
gphit = np.squeeze(nemo.load_field('gphit', homedir, nemodir, gridfile, 'T'))
glamt = np.squeeze(nemo.load_field('glamt', homedir, nemodir, gridfile, 'T'))
gdept = np.squeeze(nemo.load_field('gdept_0', homedir, nemodir, gridfile))

# Load the masks.
tmask = np.squeeze(nemo.load_field('tmask', homedir, nemodir, gridfile, 'T'))

# Load the field and remask it.
ntemp = np.squeeze(nemo.load_field('votemper', homedir, nemodir, filename, 'T'))
ntemp = nemo.mask_field(ntemp, tmask)

#--------------------------------------------------------------------------- #
# Create a new figure window and title it.
plt.figure(figsize=(12.0, 12.0))
plt.title('Transect at 24N')

# Draw contour plot of temperature field.
transplt  = plt.contourf(np.repeat(glamt[820:1100, 612 : 613].T, 75, axis=0).T,
                      -np.repeat(gdept.T[:, None], 280, axis=1).T,
                      np.squeeze(ntemp[820:1100, 612:613, :]),
                      np.arange(-1., 30., .5),
                      cmap='viridis', vmin=-1., vmax=30.,
                      extend='both')

# Add a colour bar.
cbar = plt.colorbar(transplt, ticks=np.arange(-1., 30.01, 1.))
plt.show()

# Save a hires version of the figure
plt.savefig('24N_temp_profile_NA.png', bbox_inches='tight', dpi=1200)

#--------------------------------------------------------------------------- #

