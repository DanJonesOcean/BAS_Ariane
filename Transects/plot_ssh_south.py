#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#   Plots the mean sea surface height in the southern ocean and saves it in   #
#                                the working dir                              #
# --------------------------------------------------------------------------- #
# Dave's handrolled modules.
import nemo

# Import required modules.
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# When on external server
#plt.switch_backend('agg')

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
tmask = np.squeeze(nemo.load_field('tmask',
                                   homedir, nemodir, gridfile, 'T'))[:, :, 0:1]

# Load the field and remask it.
transect = nemo.load_field('sossheig', homedir, nemodir, filename, 'T')
transect = nemo.mask_field(transect, tmask)

#--------------------------------------------------------------------------- #
# Create a new figure window.
plt.figure(figsize=(12.0, 12.0))

#Define polar projection map and fill background black.
map = Basemap(projection='spaeqd', boundinglat=-10,
              lon_0=-150, round='true')
map.drawmapboundary(fill_color='aqua')

# Plot the contour.
transplt = map.contourf(glamt.T, gphit.T, np.squeeze(transect).T,
                      np.arange(-2., 2., 0.025),
                      latlon='true', cmap='viridis', vmin=-2., vmax=2,
                      extend='both')

# Add a colour bar.
cbar = map.colorbar(transplt, 'right', ticks=np.arange(-2., 2.01, 0.25), pad=0.75)

# Print the plot to screen
plt.show()

# Save a hires version of the figure
plt.savefig('ssh_firstplot', bbox_inches='tight', dpi=1200)

