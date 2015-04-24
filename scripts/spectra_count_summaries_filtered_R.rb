# ruby spectra_count_summaries_filtered_R.rb ../results/phospho_summaries_filtered_R_.csv
# formula to sort commons in excel: =IF(AND(D2>=1,E2>=1),1, 0)

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


# create filtered lists for peptides for either of the conditions, with count >2 in both experiments
cond1_filtered = Hash.new {|h,k| h[k] = [] }
condition1_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][2].to_i > 2 && condition3_mod_pep_hits[peptide][2].to_i > 2) || (condition2_mod_pep_hits[peptide][2].to_i > 2 && condition4_mod_pep_hits[peptide][2].to_i > 2)
		cond1_filtered[peptide] = condition1_mod_pep_hits[peptide]
	end
end

cond2_filtered = Hash.new {|h,k| h[k] = [] }
condition2_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][2].to_i > 2 && condition3_mod_pep_hits[peptide][2].to_i > 2) || (condition2_mod_pep_hits[peptide][2].to_i > 2 && condition4_mod_pep_hits[peptide][2].to_i > 2)
		cond2_filtered[peptide] = condition2_mod_pep_hits[peptide]
	end
end

cond3_filtered = Hash.new {|h,k| h[k] = [] }
condition3_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][2].to_i > 2 && condition3_mod_pep_hits[peptide][2].to_i > 2) || (condition2_mod_pep_hits[peptide][2].to_i > 2 && condition4_mod_pep_hits[peptide][2].to_i > 2)
		cond3_filtered[peptide] = condition3_mod_pep_hits[peptide]
	end
end

cond4_filtered = Hash.new {|h,k| h[k] = [] }
condition4_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][2].to_i > 2 && condition3_mod_pep_hits[peptide][2].to_i > 2) || (condition2_mod_pep_hits[peptide][2].to_i > 2 && condition4_mod_pep_hits[peptide][2].to_i > 2)
		cond4_filtered[peptide] = condition4_mod_pep_hits[peptide]
	end
end


# list with all peptides of both conditions in both experiments
all_peptides = {}
all_peptides = cond1_filtered.merge(cond2_filtered)
all_peptides = all_peptides.merge(cond3_filtered)
all_peptides = all_peptides.merge(cond4_filtered)


# create output file
results_xlsx = Axlsx::Package.new
results_wb = results_xlsx.workbook

# create sheet1 - peptides with count>2 in any of the soft and stiff conditions, but in both experiments
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "soft-stiff") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", "b1_abs_log_ratio", count_condition3, count_condition4, "b2_ratio", "b2_abs_log_ratio", "average over ratios", "correlation_for_soft", "correlation_for_stiff", "Protein of interest? (Y/N)"]
	all_peptides.each_key do |peptide|
		if cond1_filtered[peptide][2].to_i > 2 && !cond1_filtered[peptide][2].nil?
			all_conditions_mod_pep_hits[peptide][2] = cond1_filtered[peptide][2] #count
		else
			all_conditions_mod_pep_hits[peptide][2] = condition1_mod_pep_hits[peptide][2]	
		end
		if cond2_filtered[peptide][2].to_i > 2 && !cond2_filtered[peptide][2].nil?
			all_conditions_mod_pep_hits[peptide][3] = cond2_filtered[peptide][2] #count
		else
			all_conditions_mod_pep_hits[peptide][3] = condition2_mod_pep_hits[peptide][2]	
		end
		if cond3_filtered[peptide][2].to_i > 2 && !cond3_filtered[peptide][2].nil?
			all_conditions_mod_pep_hits[peptide][4] = cond3_filtered[peptide][2] #count
		else
			all_conditions_mod_pep_hits[peptide][4] = condition3_mod_pep_hits[peptide][2]	
		end
		if cond4_filtered[peptide][2].to_i > 2 && !cond4_filtered[peptide][2].nil?
			all_conditions_mod_pep_hits[peptide][5] = cond4_filtered[peptide][2] #count
		else
			all_conditions_mod_pep_hits[peptide][5] = condition4_mod_pep_hits[peptide][2]	
		end

		accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
		accnos.uniq!

		all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
		all_conditions_mod_pep_hits[peptide][1] = cond1_filtered[peptide][1] #desc
		

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

# create sheet2 - common peptides between b1 & b2 samples in soft condition only (shouldn't be identified in stiff condition), with count >1
condition13_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "soft-only") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition3, "correlation", "Protein of interest? (Y/N)"]
	condition3_only_mod_pep_hits.each_key do |peptide|
		if condition3_only_mod_pep_hits[peptide][2].to_i > 1 && condition1_only_mod_pep_hits[peptide][2].to_i > 1
			accnos = [condition1_only_mod_pep_hits[peptide][0], condition3_only_mod_pep_hits[peptide][0]]
			accnos.uniq!

			condition13_only_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
			condition13_only_mod_pep_hits[peptide][1] = condition3_only_mod_pep_hits[peptide][1] #desc
			condition13_only_mod_pep_hits[peptide][2] = condition1_only_mod_pep_hits[peptide][2] #count
			condition13_only_mod_pep_hits[peptide][3] = condition3_only_mod_pep_hits[peptide][2] #count
			sheet.add_row [peptide, condition13_only_mod_pep_hits[peptide][0], condition13_only_mod_pep_hits[peptide][1],condition13_only_mod_pep_hits[peptide][2], condition13_only_mod_pep_hits[peptide][3]]
		end
	end
end

# create sheet3 - common peptides between b1 & b2 samples in stiff condition only (shouldn't be identified in soft condition), with count >1
condition24_only_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "stiff-only") do |sheet|
	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition2, count_condition4, "correlation", "Protein of interest? (Y/N)"]
	condition4_only_mod_pep_hits.each_key do |peptide|
		if condition4_only_mod_pep_hits[peptide][2].to_i > 1 && condition2_only_mod_pep_hits[peptide][2].to_i > 1
			accnos = [condition2_only_mod_pep_hits[peptide][0], condition4_only_mod_pep_hits[peptide][0]]
			accnos.uniq!

			condition24_only_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
			condition24_only_mod_pep_hits[peptide][1] = condition4_only_mod_pep_hits[peptide][1]
			condition24_only_mod_pep_hits[peptide][2] = condition2_only_mod_pep_hits[peptide][2] #count
			condition24_only_mod_pep_hits[peptide][3] = condition4_only_mod_pep_hits[peptide][2] #count
			sheet.add_row [peptide, condition24_only_mod_pep_hits[peptide][0], condition24_only_mod_pep_hits[peptide][1],condition24_only_mod_pep_hits[peptide][2], condition24_only_mod_pep_hits[peptide][3]]
		end
	end	
end

# write xlsx file
results_xlsx.serialize(spectra_counts_mod_peps_ofile)

