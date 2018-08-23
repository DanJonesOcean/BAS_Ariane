#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#  Plots a years worth of surface temperature in the southern ocean into an   #
#  output folder called surf_temp/, which it will create if it doesn't exist  #
#                                in the working dir                           #
# You can make a GIF if you have ImageMagick with:                            #
#  $ convert -resize 10% -delay 10 -loop 0 surf_temp/stemp_*.png stemp.gif'   #
# --------------------------------------------------------------------------- #
# Dave's handrolled modules.
import nemo

# Import required modules.
import os
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

plt.switch_backend('agg')

class bcolors:
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    OKYELLOW = '\033[93m'
    ENDC = '\033[0m'
# --------------------------------------------------------------------------- #

# Specify where the input data lives.
homedir = '/home/users/mbu66/'
nemodir = 'examples/data/ORCA025-N401_daily_all/'

# Pick the year to plot.
year = '2010'

# Make output directory if doesnt exist.
outdir = 'surf_temp/'
if os.path.exists(outdir):
  print bcolors.OKYELLOW + '{0} directory already exists'.format(outdir) + bcolors.ENDC
else:
  os.makedirs(outdir)
  print bcolors.OKBLUE + '{0} directory created'.format(outdir) + bcolors.ENDC

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Loop over days in the year 2010
for i in range(2338, 2411):
  # Specify the names of the different files that I want to load from.
  filename = ''.join([homedir, nemodir, 'ORCA025-N401_d_T_', str(i), '.nc'])
  gridfile = ''.join([homedir, 'examples/data/fields/mesh_hgr_matt.nc'])

  # --------------------------------------------------------------------------- #

  # Load the coordinates.
  gphit = np.squeeze(nemo.load_field('gphit', homedir, nemodir, gridfile, 'T'))
  glamt = np.squeeze(nemo.load_field('glamt', homedir, nemodir, gridfile, 'T'))
  gdept = np.squeeze(nemo.load_field('gdept_0', homedir, nemodir, gridfile))
  
  # Load the mask.
  tmask = np.squeeze(nemo.load_field('tmask',
                                   homedir, nemodir, gridfile, 'T'))[:,:,0:1]

  # Load the field and remask it.
  transect = nemo.load_field('sosstsst', homedir, nemodir, filename, 'T')
  transect = nemo.mask_field(transect, tmask)

  # --------------------------------------------------------------------------- #
  # Create a new figure window.
  #plt.figure(figsize=(12.0, 12.0))
  
  #Define the map as a ploar projection and fill in the background black.
  map = Basemap(projection='spaeqd', boundinglat=-10,
                lon_0=-150, round='true')
  map.drawmapboundary(fill_color='black')

  # Add zonal and meridional  gridlines.
  map.drawparallels(np.arange(-80, 0, 20), linewidth=0.25, color='w')
  map.drawmeridians(np.arange(-180, 180, 30), labels=12*[True], linewidth=0.25,
                    color='w')
  
  # Plot the contour.
  transplt = map.contourf(glamt.T, gphit.T, np.squeeze(transect).T,
                        np.arange(-2., 32., 1.),
                        latlon='true', cmap='viridis', vmin=-2., vmax=32,
                        extend='both')

  # Add a colour bar.
  cbar = map.colorbar(transplt, 'right', ticks=np.arange(-2., 32.01, 1.), pad=1.)

  # Save a hires version of the figure
  j = i - 2337
  myfig = ''.join([outdir, 'stemp_', str(j).zfill(2), '.png'])
  plt.savefig( myfig , bbox_inches='tight', dpi=1200)
  plt.close()

  # Anounce completion of plot.
  print bcolors.OKGREEN +'{0} {1}'.format('Completed', j ) + bcolors.ENDC

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Confirm completion.
print bcolors.OKBLUE + 'Done' + bcolors.ENDC

# --------------------------------------------------------------------------- #

