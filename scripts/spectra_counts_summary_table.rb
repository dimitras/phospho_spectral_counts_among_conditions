# ruby spectra_counts_summary_table.rb ../results/spectra_counts_for_phospho_soft_stiff_b1_b2.csv
# formula to sort commons in excel: =IF(AND(D2>=1,E2>=1),1, 0)

require 'csv_parser_for_protein_hits'

# 
csvp_condition1 = CSVParserForProteinHits.open("../csvs/F003933_soft1-2_piped.csv", 100)
csvp_condition2 = CSVParserForProteinHits.open("../csvs/F003931_stiff1-2_piped.csv", 100)
csvp_condition3 = CSVParserForProteinHits.open("../treps/F003952_phospho_soft_treps_piped.csv", 100)
csvp_condition4 = CSVParserForProteinHits.open("../treps/F003953_phospho_stiff_treps_piped.csv", 100)
modification = "Phospho"
count_condition1 = "F003933_soft_b1_2treps"
count_condition2 = "F003931_stiff_b1_2treps"
count_condition3 = "F003952_soft_b2_3treps"
count_condition4 = "F003953_stiff_b2_3treps"

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


condition3_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition3.each_peptide do |peptide|
	if csvp_condition3.hits_for_mod_pep(peptide, modification)[peptide]
		condition3_mod_pep_hits[peptide] = csvp_condition3.hits_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition3_mod_pep_hits.inspect

condition4_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition4.each_peptide do |peptide|
	if csvp_condition4.hits_for_mod_pep(peptide, modification)[peptide]
		condition4_mod_pep_hits[peptide] = csvp_condition4.hits_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition4_mod_pep_hits.inspect

# create the ofile with the counts of peptide hits with phospho modification
spectra_counts_mod_peps_out.puts "Peptide, Protein accno(s), Protein description(s), #{count_condition1}, #{count_condition2}, #{count_condition3}, #{count_condition4}, Protein of interest? (Y/N)"

all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
	
condition4_mod_pep_hits.each_key do |peptide|
	if condition3_mod_pep_hits.has_key?(peptide) && condition2_mod_pep_hits.has_key?(peptide) && condition1_mod_pep_hits.has_key?(peptide)
		all_conditions_mod_pep_hits[peptide][0] = condition4_mod_pep_hits[peptide][0] #accno
		all_conditions_mod_pep_hits[peptide][1] = condition4_mod_pep_hits[peptide][1] #desc
		all_conditions_mod_pep_hits[peptide][2] = condition1_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][3] = condition2_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][4] = condition3_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][5] = condition4_mod_pep_hits[peptide][2] #count	
	end
end

all_conditions_mod_pep_hits.each_key do |peptide|
	spectra_counts_mod_peps_out.puts '"' + peptide + '","' + all_conditions_mod_pep_hits[peptide].join('","') + '"'
end

spectra_counts_mod_peps_out.close
