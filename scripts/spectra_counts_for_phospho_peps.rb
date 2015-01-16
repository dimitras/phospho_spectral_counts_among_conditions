# ruby spectra_counts_for_phospho_peps.rb ../results/spectra_counts_for_phospho_peps_R1.csv
# ruby spectra_counts_for_phospho_peps.rb ../results/spectra_counts_for_phospho_peps_R2.csv
# ruby spectra_counts_for_phospho_peps.rb ../results/spectra_counts_for_phospho_peps_R1-2.csv

require 'csv_parser_for_protein_hits'

# input files
# # soft1 vs stiff1 
# csvp_condition1 = CSVParserForProteinHits.open("../csvs/F003925_soft_piped.csv", 100)
# csvp_condition2 = CSVParserForProteinHits.open("../csvs/F003926_stiff_piped.csv", 100)
# modification = "Phospho"
# count_condition1 = "F003925_soft"
# count_condition2 = "F003926_stiff"

# # OTHER DATA
# # soft2 vs stiff2 
# csvp_condition1 = CSVParserForProteinHits.open("../csvs/F003928_soft2_piped.csv", 100)
# csvp_condition2 = CSVParserForProteinHits.open("../csvs/F003929_stiff2_piped.csv", 100)
# modification = "Phospho"
# count_condition1 = "F003928_soft2"
# count_condition2 = "F003929_stiff2"

# # soft1-2 vs stiff1-2
csvp_condition1 = CSVParserForProteinHits.open("../csvs/F003933_soft1-2_piped.csv", 100)
csvp_condition2 = CSVParserForProteinHits.open("../csvs/F003931_stiff1-2_piped.csv", 100)
modification = "Phospho"
count_condition1 = "F003933_soft1-2"
count_condition2 = "F003931_stiff1-2"

# output files
spectra_counts_mod_peps_ofile = ARGV[0]
# initialize arguments
spectra_counts_mod_peps_out = File.open(spectra_counts_mod_peps_ofile, "w")

# count the spectra for each condition
condition1_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition1.each_peptide do |peptide|
	if csvp_condition1.hits_for_mod_pep(peptide, modification)[peptide]
		condition1_mod_pep_hits[peptide] = csvp_condition1.hits_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition1_mod_pep_hits.inspect

condition2_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition2.each_peptide do |peptide|
	if csvp_condition2.hits_for_mod_pep(peptide, modification)[peptide]
		condition2_mod_pep_hits[peptide] = csvp_condition2.hits_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition2_mod_pep_hits.inspect

# create the ofile with the counts of peptide hits with phospho modification
spectra_counts_mod_peps_out.puts "Peptide, Protein accno, Protein description, #{count_condition1}, #{count_condition2}, Protein accno, Protein description"

all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition1_mod_pep_hits.each_key do |peptide|
	all_conditions_mod_pep_hits[peptide][0] = condition1_mod_pep_hits[peptide][0] #acc
	all_conditions_mod_pep_hits[peptide][1] = condition1_mod_pep_hits[peptide][1] #desc
	all_conditions_mod_pep_hits[peptide][2] = condition1_mod_pep_hits[peptide][2] #count
end
condition2_mod_pep_hits.each_key do |peptide|
	all_conditions_mod_pep_hits[peptide][3] = condition2_mod_pep_hits[peptide][2] #count
	all_conditions_mod_pep_hits[peptide][4] = condition2_mod_pep_hits[peptide][0] #acc
	all_conditions_mod_pep_hits[peptide][5] = condition2_mod_pep_hits[peptide][1] #desc
end

all_conditions_mod_pep_hits.each_key do |peptide|
	spectra_counts_mod_peps_out.puts '"' + peptide + '","' + all_conditions_mod_pep_hits[peptide].join('","') + '"'
end

spectra_counts_mod_peps_out.close
