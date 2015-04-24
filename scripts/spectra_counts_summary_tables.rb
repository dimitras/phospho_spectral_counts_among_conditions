# ruby spectra_counts_summary_tables.rb ../results/phospho_soft_stiff_b1_b2_summaries_v2.csv
# formula to sort commons in excel: =IF(AND(D2>=1,E2>=1),1, 0)
# formula to count non blank cells in excel: =COUNTIF(D2:D967,">=1")

require 'csv_parser_for_protein_hits'
require 'rubygems'
require 'axlsx'

# input
csvp_condition1 = CSVParserForProteinHits.open("../csvs/F003933_soft1-2_piped.csv", 100)
csvp_condition2 = CSVParserForProteinHits.open("../csvs/F003931_stiff1-2_piped.csv", 100)
csvp_condition3 = CSVParserForProteinHits.open("../b2_treps/F003952_phospho_soft_treps_piped.csv", 100)
csvp_condition4 = CSVParserForProteinHits.open("../b2_treps/F003953_phospho_stiff_treps_piped.csv", 100)
modification = "Phospho"
count_condition1 = "soft_b1_count"
count_condition2 = "stiff_b1_count"
count_condition3 = "soft_b2_count"
count_condition4 = "stiff_b2_count"

# output files
spectra_counts_mod_peps_ofile = ARGV[0]


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


# create the redundant lists for soft-only and stiff-only conditions
# soft1
condition1_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition1_mod_pep_hits.each_key do |peptide|
	if !condition2_mod_pep_hits.has_key?(peptide) && !condition4_mod_pep_hits.has_key?(peptide)
		condition1_only_mod_pep_hits[peptide] = condition1_mod_pep_hits[peptide]
	end
end
#soft3
condition3_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition3_mod_pep_hits.each_key do |peptide|
	if !condition2_mod_pep_hits.has_key?(peptide) && !condition4_mod_pep_hits.has_key?(peptide)
		condition3_only_mod_pep_hits[peptide] =  condition3_mod_pep_hits[peptide]
	end
end
#stiff2
condition2_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition2_mod_pep_hits.each_key do |peptide|
	if !condition1_mod_pep_hits.has_key?(peptide) && !condition3_mod_pep_hits.has_key?(peptide)
		condition2_only_mod_pep_hits[peptide] =  condition2_mod_pep_hits[peptide]
	end
end
#stiff4
condition4_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition4_mod_pep_hits.each_key do |peptide|
	if !condition1_mod_pep_hits.has_key?(peptide) && !condition3_mod_pep_hits.has_key?(peptide)
		condition4_only_mod_pep_hits[peptide] =  condition4_mod_pep_hits[peptide]
	end
end


# create the redundant lists for peptides identified in both soft and stiff conditions
# soft but not only in soft
condition1_common_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition1_mod_pep_hits.each_key do |peptide|
	if condition2_mod_pep_hits.has_key?(peptide) || condition4_mod_pep_hits.has_key?(peptide)
		condition1_common_mod_pep_hits[peptide] =  condition1_mod_pep_hits[peptide]
	end
end
condition3_common_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition3_mod_pep_hits.each_key do |peptide|
	if condition2_mod_pep_hits.has_key?(peptide) || condition4_mod_pep_hits.has_key?(peptide)
		condition3_common_mod_pep_hits[peptide] =  condition3_mod_pep_hits[peptide]
	end
end
# stiff but not only in stiff
condition2_common_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition2_mod_pep_hits.each_key do |peptide|
	if condition1_mod_pep_hits.has_key?(peptide) || condition3_mod_pep_hits.has_key?(peptide)
		condition2_common_mod_pep_hits[peptide] =  condition2_mod_pep_hits[peptide]
	end
end
condition4_common_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
condition4_mod_pep_hits.each_key do |peptide|
	if condition1_mod_pep_hits.has_key?(peptide) || condition3_mod_pep_hits.has_key?(peptide)
		condition4_common_mod_pep_hits[peptide] =  condition4_mod_pep_hits[peptide]
	end
end


# create output file
results_xlsx = Axlsx::Package.new
results_wb = results_xlsx.workbook

# create sheet1 - common peptides between soft and stiff conditions
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "soft-stiff") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", "b1_abs_log_ratio", count_condition3, count_condition4, "b2_ratio", "b2_abs_log_ratio", "average over ratios", "correlation_for_soft", "correlation_for_stiff", "Protein of interest? (Y/N)"]
	condition1_common_mod_pep_hits.each_key do |peptide|
		all_conditions_mod_pep_hits[peptide][0] = condition1_common_mod_pep_hits[peptide][0] #accno
		all_conditions_mod_pep_hits[peptide][1] = condition1_common_mod_pep_hits[peptide][1] #desc
		all_conditions_mod_pep_hits[peptide][2] = condition1_common_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][3] = condition2_common_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][4] = condition3_common_mod_pep_hits[peptide][2] #count
		all_conditions_mod_pep_hits[peptide][5] = condition4_common_mod_pep_hits[peptide][2] #count

		if !all_conditions_mod_pep_hits[peptide][2].nil? && !all_conditions_mod_pep_hits[peptide][3].nil?
			b1_ratio = all_conditions_mod_pep_hits[peptide][2].to_f / all_conditions_mod_pep_hits[peptide][3].to_f
			b1_abs_log_ratio = Math.log10(b1_ratio).abs
		end
		if !all_conditions_mod_pep_hits[peptide][4].nil? && !all_conditions_mod_pep_hits[peptide][5].nil?
			b2_ratio = all_conditions_mod_pep_hits[peptide][4].to_f / all_conditions_mod_pep_hits[peptide][5].to_f
			b2_abs_log_ratio = Math.log10(b2_ratio).abs
		end
		if !b1_ratio.nil? && !b2_ratio.nil?
			average_over_ratios = (b1_ratio + b2_ratio)/2
		end

		sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_ratio, b1_abs_log_ratio, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5],  b2_ratio, b2_abs_log_ratio, average_over_ratios]
	end
end

# create sheet2 - common peptides between b1 & b2 samples in soft condition only (shouldn't be identified in stiff condition)
condition13_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "soft-only") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition3, "Protein of interest? (Y/N)"]
	condition1_only_mod_pep_hits.each_key do |peptide|
		condition13_only_mod_pep_hits[peptide][0] = condition1_only_mod_pep_hits[peptide][0] #acc
		condition13_only_mod_pep_hits[peptide][1] = condition1_only_mod_pep_hits[peptide][1] #desc
		condition13_only_mod_pep_hits[peptide][2] = condition1_only_mod_pep_hits[peptide][2] #count
	end
	condition3_only_mod_pep_hits.each_key do |peptide|
		if condition13_only_mod_pep_hits[peptide][0].nil?
			condition13_only_mod_pep_hits[peptide][0] = condition3_only_mod_pep_hits[peptide][0]
			condition13_only_mod_pep_hits[peptide][1] = condition3_only_mod_pep_hits[peptide][1]
		elsif !condition13_only_mod_pep_hits[peptide][0].eql?(condition3_only_mod_pep_hits[peptide][0])
			condition13_only_mod_pep_hits[peptide][0]<< "|#{condition3_only_mod_pep_hits[peptide][0]}" #accno
			condition13_only_mod_pep_hits[peptide][1]<< "|#{condition3_only_mod_pep_hits[peptide][1]}" #desc
		end
		condition13_only_mod_pep_hits[peptide][3] = condition3_only_mod_pep_hits[peptide][2] #count
		sheet.add_row [peptide, condition13_only_mod_pep_hits[peptide][0], condition13_only_mod_pep_hits[peptide][1],condition13_only_mod_pep_hits[peptide][2], condition13_only_mod_pep_hits[peptide][3]]
	end
end

# create sheet3 - common peptides between b1 & b2 samples in stiff condition only (shouldn't be identified in soft condition)
condition24_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "stiff-only") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition2, count_condition4, "Protein of interest? (Y/N)"]
	condition2_only_mod_pep_hits.each_key do |peptide|
		condition24_only_mod_pep_hits[peptide][0] = condition2_only_mod_pep_hits[peptide][0] #acc
		condition24_only_mod_pep_hits[peptide][1] = condition2_only_mod_pep_hits[peptide][1] #desc
		condition24_only_mod_pep_hits[peptide][2] = condition2_only_mod_pep_hits[peptide][2] #count
	end
	condition4_only_mod_pep_hits.each_key do |peptide|
		if condition24_only_mod_pep_hits[peptide][0].nil?
			condition24_only_mod_pep_hits[peptide][0] = condition4_only_mod_pep_hits[peptide][0]
			condition24_only_mod_pep_hits[peptide][1] = condition4_only_mod_pep_hits[peptide][1]
		elsif !condition24_only_mod_pep_hits[peptide][0].eql?(condition4_only_mod_pep_hits[peptide][0])
			condition24_only_mod_pep_hits[peptide][0]<< "|#{condition4_only_mod_pep_hits[peptide][0]}" #accno
			condition24_only_mod_pep_hits[peptide][1]<< "|#{condition4_only_mod_pep_hits[peptide][1]}" #desc
		end
		condition24_only_mod_pep_hits[peptide][3] = condition4_only_mod_pep_hits[peptide][2] #count
		sheet.add_row [peptide, condition24_only_mod_pep_hits[peptide][0], condition24_only_mod_pep_hits[peptide][1],condition24_only_mod_pep_hits[peptide][2], condition24_only_mod_pep_hits[peptide][3]]
	end	
end

# write xlsx file
results_xlsx.serialize(spectra_counts_mod_peps_ofile)

