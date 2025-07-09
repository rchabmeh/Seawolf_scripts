#!/bin/bash
#Test to create back trajectory in hysplit

#run Rscript to create a singular control file
#note: the control file directory/inputs need to be manually done via the Rscript itself
#note: k needs to be manually set in the Rscript (k is receptor number)

Rscript /Users/reneechabot/Library/CloudStorage/GoogleDrive-renee.chabot@stonybrook.edu/.shortcut-targets-by-id/1GSVxGJlWo-R0hbtHEXmwYdG8xHXiGhzo/Shepson Group Drive/Renée/Research/R V Seawolf- Cruises/Seawolf_data/scripts/generate_single_control_file.R

#now let's create a .tdump file

/Users/reneechabot/hysplit/exec/hyts_std

