#! /bin/bash

#Use this script to generate correctly named links of a set of ORCA025-N401, monthly mean, data on JASMIN
#Correctly lables U V W T 
#Ariane namelist then has the following accepted format
  #prefix = 'ORCA025-N401_m_'
  #suffix = '.nc'
#You may want to create a file containing all the possible data, and then just index ariane accordingly, instead of generating a new folder for each run
  #i.e. 
  #line 33 & line 50 : for j in {1978..2010}
  # -> arine run of 1996-2010 would correspond to indexing ind0 = 217 & indn=396
#--------------------------------------------------------------------------------------#

#TODO:
  #Change the output directory to the directory you want to contain symbolic links
  #Change the dates to the desired range

#--------------------------------------------------------------------------------------#

#Set variables:
SOURCEDIR="/group_workspaces/jasmin2/nemo/vol1/ORCA025-N401/means/"
OUTDIR="/home/users/user_name/links_folder/"          #Output directory
ORCARUN="ORCA025-N401_m_"
ORCANAME="ORCA025-N401_"
MAXSIXE="%03d"            #This corresponds to a maxsize_xx key of 3 in the namelist
RUNTYPE="m*"


#Create links U V W
for i in U V W
  do
      n=$((1))
      for j in {1996..2010}
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

#Create links T (different due to UT VT and WT data files complicating life)
n=$((1))
for j in {1996..2010}
do
    for k in 01 02 03 04 05 06 07 08 09 10 11 12
    do
        filei=$SOURCEDIR${j}/$ORCANAME${j}m${k}T.nc
        prefix=$ORCARUN"T_"
        number=$(printf $MAXSIXE $n)
        suffix=".nc"
        fileo=$OUTDIR$prefix$number$suffix
        n=$((n+1))
        ln -s $filei $fileo
    done
done
