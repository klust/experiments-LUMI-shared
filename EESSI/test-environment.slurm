#!/usr/bin/bash
#SBATCH --job-name=test-environment
#SBATCH --output=%x-%j.out
#SBATCH --time=00:10:00
#SBATCH --partition=small
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --network=single_node_vni,job_vni,def_tles=0
#SBATCH --constraint=eessi

function echopath { # Show PATH-style variables in an easier-to-interpret way

    echo "$1=" ;
    eval echo \$$1 | tr ":" "\n" | nl - ;
}
declare -fx echopath

echo -e "Module list at the start:\n$(module list 2>&1)\n\n\n"
echo -e "Environment variables starting with CRAY_ at the start:\n$(env | grep CRAY_)\n\n\n"
echo -e "PATH at the start: $(echopath PATH)\n\n"
echo -e "MODULEPATH at the start: $(echopath MODULEPATH)\n\n"

# Configure the EESSI environment and load the modules we need for our test
echo "Now initialising EESSI..."
source /cvmfs/software.eessi.io/versions/2025.06/init/lmod/bash
echo -e "\n\n\n"

echo -e "Module list after EESSI initialisation:\n$(module list 2>&1)\n\n\n"
echo -e "Environment variables starting with CRAY_ after EESSI initialisation:\n$(env | grep CRAY_)\n\n\n"
echo -e "PATH after EESSI initialisation: $(echopath PATH)\n\n"
echo -e "MODULEPATH after EESSI initialisation: $(echopath MODULEPATH)\n\n"


