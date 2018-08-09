# BAS_Ariane_matter
Resources and script files used to operate Ariane on Jasmin throughout my 10 week REP at BAS in summer 2018

## Make_ariane:
```Describes how I installed ariane in my home directory on Jasmin ```

## Mesh_grid:
```Describes how to make a complete mesh_hgr.nc file for ariane from the NEMO resources```

## ORCA025-N401_naming:
```Contains scripts and instructions to create symbolic links to the NEMO data with the correct name format ```

## Example_Scripts:
```Contains some examples of the files I used to run some Ariane experiments, and their output.```

### Tips and Tricks:
- 'nohup ariane' allows you to close your terminal window
- use nedit to edit the segrid.
  - preferences > wrap = none 
  - preferences > Text Fonts > -misc-fixed-medium-r-normal--6-60-75-75-c-40-iso8859-1         i.e. font size 6
  - use scroll bars to navigate, don't use the scroll wheel or 2 finger drag because it is laggy
  - use 'ctrl+click' and drag to select horizontal or vertical regions and then the macro 'fill Sel. w/ char' to replace the
    selections with numbers. Much better than doing it by hand.
- add a surface lid to try prevent node dropping
