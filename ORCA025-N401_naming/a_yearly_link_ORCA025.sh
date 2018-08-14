#! /bin/bash

#Use this script to generate correctly named links of a set of ORCA025-N401, yearly mean, data on JASMIN
#Correctly lables U V W T 
#Ariane namelist then has the following accepted format
  #prefix = 'ORCA025-N401_y_'
  #suffix = '.nc'
#You may want to create a file containing all the possible data, and then just index ariane accordingly, instead of generating a new folder for each run
  #i.e. 
  #line 33: for j in {1978..2010}
  # -> arine run of 1996-2010 would correspond to indexing ind0 = 19 & indn= 33
#--------------------------------------------------------------------------------------#

#TODO:
  #Change the output directory to the directory you want to contain symbolic links
  #Change the dates to the desired range

#--------------------------------------------------------------------------------------#

#Set variables:
SOURCEDIR="/group_workspaces/jasmin2/nemo/vol1/ORCA025-N401/means/"
OUTDIR="/home/users/user_name/links_folder/"        #Output directory
ORCARUN="ORCA025-N401_y_"
ORCANAME="ORCA025-N401_"
MAXSIXE="%02d"                #This corresponds to a maxsize_xx key of 2 in the namelist
RUNTYPE="y01"


#Create links U V W
for i in U V W T
  do
      n=$((1))
      for j in {1996..2010}   #Dates
      do
          for k in `ls -1 $SOURCEDIR$j/$ORCANAME$j$RUNTYPE$i.nc`
          do
              filei=$k
              prefix=$ORCARUN$i"_"
              number=$(printf $MAXSIXE $n)
              suffix=".nc"
              fileo=$OUTDIR$prefix$number$suffix
              n=$((n+1))
              ln -s $filei $fileo
           done
      done
  done
