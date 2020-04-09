# update R 

lib_loc <- "../R/x86_64-pc-linux-gnu-library/3.4"
to_install <- unname(installed.packages(lib.loc = lib_loc)[, "Package"])
to_install
install.packages(pkgs = to_install)