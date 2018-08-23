#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#   Plots a years worth of salinity transects at 24N into an output folder    #
# called salfig/, which it will create if it doesn't exist in the working dir #
# You can make a GIF if you have ImageMagick with:                            #
#      $ convert -resize 10% -delay 10 -loop 0 salfig/sal_*.png sal.gif'      #
# --------------------------------------------------------------------------- #
# Dave's handrolled modules.
import nemo

# Import required modules.
import os
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# When on external server
#plt.switch_backend('agg')

# Define a few colours
class bcolours:
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    OKYELLOW = '\033[93m'
    ENDC = '\033[0m'
# --------------------------------------------------------------------------- #

# Specify where the input data lives.
homedir = '/home/users/mbu66/'
nemodir = '/group_workspaces/jasmin2/nemo/vol1/ORCA025-N401/means/'

# Pick the year to plot.
year = '2010'

# Make output directory if doesnt exist.
outdir = 'salfig/'
if os.path.exists(outdir):
  print bcolours.OKYELLOW + '{0} directory already exists'.format(outdir) + bcolours.ENDC
else:
  os.makedirs(outdir)
  print bcolours.OKBLUE + '{0} directory created'.format(outdir) + bcolours.ENDC

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Loop over months in the year .
for i in range(1,13):
  # Specify the names of the different files that I want to load from.
  filename = ''.join([nemodir, year, '/ORCA025-N401_2010m', str(i).zfill(2), 'T.nc'])
  gridfile = ''.join([homedir, 'examples/data/fields/mesh_hgr_matt.nc'])

  # --------------------------------------------------------------------------- #

  # Load the coordinates.
  gphit = np.squeeze(nemo.load_field('gphit', homedir, nemodir, gridfile, 'T'))
  glamt = np.squeeze(nemo.load_field('glamt', homedir, nemodir, gridfile, 'T'))
  gdept = np.squeeze(nemo.load_field('gdept_0', homedir, nemodir, gridfile))

  # Load the mask
  tmask_1 = np.squeeze(nemo.load_field('tmask', homedir, nemodir, gridfile, 'T'))

  # Load the field and remask it.
  ntemp = np.squeeze(nemo.load_field('vosaline', homedir, nemodir, filename, 'T'))
  ntemp = nemo.mask_field(ntemp, tmask_1)

  # --------------------------------------------------------------------------- #
  # Create a new figure window.
  plt.figure(figsize=(12.0, 12.0))

  # Draw the contour plot.
  transplt = plt.contourf(np.repeat(gphit[1039:1040, :].T, 75, axis=1),
                        -np.repeat(gdept.T[:, None], 1021, axis=1).T,
                        np.squeeze(ntemp[1039:1040, :, :]),
                        np.arange(34., 38., .05),
                        cmap='viridis', vmin=34., vmax=38.,
                        extend='both')

  # Add a colour bar.
  cbar = plt.colorbar(transplt, ticks=np.arange(34., 38.01, .5))

  # Save a hires version of the figure
  myfig = ''.join([outdir, '/sal_', str(i).zfill(2), '.png'])
  plt.savefig(myfig, bbox_inches='tight', dpi=1200)
  # Anounce completion of plot.
  print bcolours.OKGREEN +'{0} {1}'.format('Completed', j ) + bcolours.ENDC

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Confirm completion.
print bcolours.OKBLUE + 'Done' + bcolours.ENDC

# --------------------------------------------------------------------------- #