# Experimenting with EESSI

## The environment before and after the EESSI initialisation

Test with `test-environment.slurm`.

Initialisation script used: `/cvmfs/software.eessi.io/versions/2025.06/init/lmod/bash`.

-   The initialisation script does purge the modules before re-initialising LMOD.

    This will not work properly in a container though as the module files themselves
    are usually not available to execute.

-   After the initialisation, only the `EESSI/2025.06` module is loaded.

