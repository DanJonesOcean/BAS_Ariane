#!/usr/bin/env python2.7
# --------------------------------------------------------------------------- #
#  Plots a years worth of temperature transects at 24N into an output folder  #
#  called temp/, which it will create if it doesn't exist in the working dir  #
# You can make a GIF if you have ImageMagick with:                            #
#       $ convert -resize 10% -delay 10 -loop 0 temp/temp_*.png temp.gif'     #
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
outdir = 'temp/'
if os.path.exists(outdir):
  print bcolours.OKYELLOW + '{0} directory already exists'.format(outdir) + bcolours.ENDC
else:
  os.makedirs(outdir)
  print bcolours.OKBLUE + '{0} directory created'.format(outdir) + bcolours.ENDC

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
# Loop through months in the year
for i in range(1,13):
  
  # Specify the names of the different files that I want to load from.
  # Concatenate directory with the month as a string.
  filename = ''.join([nemodir, year, '/ORCA025-N401_2010m', str(i).zfill(2), 'T.nc'])
  gridfile = ''.join([homedir, 'examples/data/fields/mesh_hgr_matt.nc'])

  # --------------------------------------------------------------------------- #

  # Load the coordinates.
  gphit = np.squeeze(nemo.load_field('gphit', homedir, nemodir, gridfile, 'T'))
  glamt = np.squeeze(nemo.load_field('glamt', homedir, nemodir, gridfile, 'T'))
  gdept = np.squeeze(nemo.load_field('gdept_0', homedir, nemodir, gridfile))
  
  # Load the mask.
  tmask = np.squeeze(nemo.load_field('tmask', homedir, nemodir, gridfile, 'T'))

  # Load the field and remask it.
  ntemp = np.squeeze(nemo.load_field('votemper', homedir, nemodir, filename, 'T'))
  ntemp = nemo.mask_field(ntemp, tmask)

  #--------------------------------------------------------------------------- #
  # Create a new figure window and title it.
  plt.figure(figsize=(12.0, 12.0))
  plt.title('Transect at 24N')

  # Draw contour plot of the field.
  # Plot limits [820:1100] and [612 : 613] ==> NA basin transect at 24N
  transplt  = plt.contourf(np.repeat(glamt[820:1100, 612 : 613].T, 75, axis=0).T,
                        -np.repeat(gdept.T[:, None], 280, axis=1).T,
                        np.squeeze(ntemp[820:1100, 612:613, :]),
                        np.arange(-1., 30., .5),
                        cmap='viridis', vmin=-1., vmax=30.,
                        extend='both')

  # Add a colour bar.
  cbar = plt.colorbar(transplt, ticks=np.arange(-1., 30.01, 1.))

  # Save a hires version of the figure
  myfig = ''.join([outdir,'temp_', str(i).zfill(2), '.png' ])
  plt.savefig(myfig, bbox_inches='tight', dpi=1200)

  # Anounce completion of plot.
  print bcolours.OKGREEN +'{0} {1}'.format('Completed', j ) + bcolours.ENDC

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Confirm completion.
print bcolours.OKBLUE + 'Done' + bcolours.ENDC

# --------------------------------------------------------------------------- #

