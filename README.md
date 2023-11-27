# Repository storage for acs.jpclett.3c01790

Article DOI: `10.1021/acs.jpclett.3c01790`

The ground state energies can be found by running eT on the input files generated from the scripts in this repository.

- `pair-config-120k`
pair-config-120k contains all the input structures used to train the neural network potentials.
Each row is a xyz position (Ångström) of H-atoms.
Each two-rows is a H2-molecule.
Each four-rows is a (H2)_2 dimer.

- `pair2eTinput.jl`
Can be run using the Julia programming language.
Creates input files from the pair-config-120k file.
These input files can be run with eT_launch.py using eT 2.0.
(Tested with commit 78ee2c62b70862a991012b276d4c77213aad2cde)

- `pair2eTinput_old.jl`
Can be run using the Julia programming language.
Creates input files from the pair-config-120k file.
These input files can be run with older versions of eT.
QED-CCSD-SD-1-12 is only available in a custom older version of eT.
https://gitlab.com/torhaugl/eT branch QED-CC
(Tested with commit 0a77e7e856bb165e81138e22533bc054ccbe3931)

