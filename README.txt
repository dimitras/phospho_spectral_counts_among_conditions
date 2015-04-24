#1st version
Count the spectra for each phospho peptide, for both conditions.
Put the counts in different columns, for all phospho peptides of each condition (not only the common ones).

Replicates
Separate search
2 soft replicates search
2 stiff replicates search

Add prot accno + desc at counts file

#2nd version

added 3 more replicates for soft and 3 for stiff
1 search per condition

count the peptide spectra identified in each experiment in both conditions
that is:
in B1 experiment count soft and stiff
and in B2 experiment count soft and stiff

calculate ratios between conditions but in the same experiment, averages between experiments, correlation per condition between the experiments

#3rd version: we want to see if there is reproducibility between the experiments under the same condition

add filters and keep the peptides that have counts >2 (arbitrarily chosen) between experiments but same condition
with the same count-difference direction 
and count dif>=2
or ratio >=2
or ratio >=1.5

also with modified ratios: with reversed ratio for the negative direction

