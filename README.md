BansheeStatistics
=================

A small compilation of R files producing some interesing statistics about your Banshee music collection

License
-------
The BansheeStatistics script is released under GPL v3 or newer. A complete license file can be found under LICENSE.

Requirements
------------
1. Banshee must be installed and used
2. `~/.config/banshee-1/banshee.db` must exist and be readable
3. A local R installation
4. Different R packages (see Dependencies)

Installation
------------
1. Extract the BansheeStatistics archive (seems like you already have)
2. Install R on your system (`yum install R` or `apt-get install R`)
3. Install package dependencies

Dependencies
-------------------
1. RSQLite
2. hexbin

    install.packages("RSQLite")
    install.packages("hexbin")

Usage
-----
1. Open a terminal and `cd` to the extracted folder
2. `./BansheeStatistics.sh`
3. View the generated PNG files
