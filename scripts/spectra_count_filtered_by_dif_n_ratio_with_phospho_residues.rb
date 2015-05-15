# ruby spectra_count_filtered_by_dif_n_ratio_with_phospho_residues.rb ../results/proteins_of_interest_with_modifications.csv
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


# create filtered lists for peptides with count >2 in both experiments, but in same condition
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


# list with all peptides with count >2 in both experiments, but in same condition
all_peptides = {}
all_peptides = cond1_filtered.merge(cond2_filtered)
all_peptides = all_peptides.merge(cond3_filtered)
all_peptides = all_peptides.merge(cond4_filtered)


# create output file
results_xlsx = Axlsx::Package.new
results_wb = results_xlsx.workbook

proteins_of_interest_array = ["VDIITEEMPENALPSDEDDKDPNDPYR", "SQEMVHLVNK", "DPQTLDSSVGRPEDSSLTQDEDR", "SPDTSAYCYETMEK", "SVSPGVTQAVVEEHCASPEEK", "AAVGVTGNDITTPPNKEPPPSPEK", "VLLAADSEEEGDFPSGR", "QLHIEGASLELSDDDTESK", "SLEDESQETFGSLEK", "DELHIVEAEAMNYEGSPIK", "AAVQELSGSILTSEDPEER", "TGDLGIPPNPEDRSPSPEPIYNSEGK", "ATDAEADVASLNR", "GDSETDLEALFNAVMNPK", "VTLQDYHLPDSDEDEETAIQR", "ISDPLTSSPGR", "TASGSSVTSLEGTR", "LPTKPETSFEEGDGR", "DDSPKEYTDLEVSNK"]
proteins_of_interest_hash = Hash[proteins_of_interest_array.map {|x| [x, '']}]

# create sheet1 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and count dif>=2
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "by_count_diff") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-difference (among the conditions of the same experiment) >=2"], :style => title
	sheet.merge_cells "A1:J1"
	sheet.add_row ["Peptide", "Modification", "Modified positions seq", "Mod. position indexes", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_difference", count_condition3, count_condition4, "b2_difference"], :style => title
	all_peptides.each_key do |peptide|

		if !cond1_filtered[peptide][2].nil?
			count1 = cond1_filtered[peptide][2].to_i
		else
			count1 = condition1_mod_pep_hits[peptide][2].to_i
		end
		if !cond2_filtered[peptide][2].nil?
			count2 = cond2_filtered[peptide][2].to_i
		else
			count2 = condition2_mod_pep_hits[peptide][2].to_i
		end
		if !cond3_filtered[peptide][2].nil?
			count3 = cond3_filtered[peptide][2].to_i
		else
			count3 = condition3_mod_pep_hits[peptide][2].to_i
		end
		if !cond4_filtered[peptide][2].nil?
			count4 = cond4_filtered[peptide][2].to_i
		else
			count4 = condition4_mod_pep_hits[peptide][2].to_i
		end
		
		if (count1-count2>0 && count3-count4>0) || (count1-count2<0 && count3-count4<0) || (count1-count2==0 && count3-count4==0)
			if (count1-count2).abs>=2 && (count3-count4).abs>=2
				all_conditions_mod_pep_hits[peptide][2] = count1 #count
				all_conditions_mod_pep_hits[peptide][3] = count2 #count
				all_conditions_mod_pep_hits[peptide][4] = count3 #count
				all_conditions_mod_pep_hits[peptide][5] = count4 #count

				accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
				accnos.uniq!
				accnos.delete_if {|x| x.nil?}

				descs = [cond1_filtered[peptide][1], cond2_filtered[peptide][1], cond3_filtered[peptide][1], cond4_filtered[peptide][1]]
				descs.uniq!
				descs.delete_if {|x| x.nil?}

				if cond1_filtered[peptide][3]
					tmp1 = "c1: " + cond1_filtered[peptide][3]
				end
				if cond2_filtered[peptide][3]
					tmp2 = "c2: " + cond2_filtered[peptide][3]
				end
				if cond3_filtered[peptide][3]
					tmp3 = "c3: " + cond3_filtered[peptide][3]
				end
				if cond4_filtered[peptide][3]
					tmp4 = "c4: " + cond4_filtered[peptide][3]
				end
				modifications = [tmp1, tmp2, tmp3, tmp4]
				modifications.delete_if {|x| x.nil?}

				mod_positions = [cond1_filtered[peptide][4], cond2_filtered[peptide][4], cond3_filtered[peptide][4], cond4_filtered[peptide][4]]
				mod_positions.delete_if {|x| x.nil?}
				# puts 'pos-str'
				# puts mod_positions.inspect

				mod_positions_idxs = [cond1_filtered[peptide][5], cond2_filtered[peptide][5], cond3_filtered[peptide][5], cond4_filtered[peptide][5]]
				mod_positions_idxs.delete_if {|x| x.nil?}
				
				all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
				all_conditions_mod_pep_hits[peptide][1] = descs.join(" | ") #desc
				all_conditions_mod_pep_hits[peptide][6] = modifications.join(" | ") #modification
				all_conditions_mod_pep_hits[peptide][7] = mod_positions.join(" | ") #modified position
				all_conditions_mod_pep_hits[peptide][8] = mod_positions_idxs.join(" | ") #modified position indexes

				if !all_conditions_mod_pep_hits[peptide][2].nil? && !all_conditions_mod_pep_hits[peptide][3].nil?
					b1_difer = all_conditions_mod_pep_hits[peptide][2].to_i - all_conditions_mod_pep_hits[peptide][3].to_i
				end
				if !all_conditions_mod_pep_hits[peptide][4].nil? && !all_conditions_mod_pep_hits[peptide][5].nil?
					b2_difer = all_conditions_mod_pep_hits[peptide][4].to_i - all_conditions_mod_pep_hits[peptide][5].to_i
				end
				
				if proteins_of_interest_hash[peptide]
					sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][6], all_conditions_mod_pep_hits[peptide][7], all_conditions_mod_pep_hits[peptide][8], all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_difer, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5], b2_difer]
				end
			end
		end
	end
end

# # create sheet2 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and ratio >=2
# all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

# results_wb.add_worksheet(:name => "by_ratio>=2") do |sheet|
# 	title = results_wb.styles.add_style(:b => true)
# 	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-ratio (among the conditions of the same experiment) >=2"], :style => title
# 	sheet.merge_cells "A1:J1"
# 	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", count_condition3, count_condition4, "b2_ratio", "Protein of interest? (Y/N)"], :style => title
# 	all_peptides.each_key do |peptide|

# 		if !cond1_filtered[peptide][2].nil?
# 			count1 = cond1_filtered[peptide][2].to_i
# 		else
# 			count1 = condition1_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond2_filtered[peptide][2].nil?
# 			count2 = cond2_filtered[peptide][2].to_i
# 		else
# 			count2 = condition2_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond3_filtered[peptide][2].nil?
# 			count3 = cond3_filtered[peptide][2].to_i
# 		else
# 			count3 = condition3_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond4_filtered[peptide][2].nil?
# 			count4 = cond4_filtered[peptide][2].to_i
# 		else
# 			count4 = condition4_mod_pep_hits[peptide][2].to_i
# 		end
		
# 		if (count1-count2>0 && count3-count4>0) || (count1-count2<0 && count3-count4<0) || (count1-count2==0 && count3-count4==0)

# 			if !count1.nil? && !count2.nil? && !count1.zero? && !count2.zero?
# 				b1_ratio = count1.to_f / count2.to_f
# 			end
# 			if !count3.nil? && !count4.nil? && !count3.zero? && !count4.zero?
# 				b2_ratio = count3.to_f / count4.to_f
# 			end

# 			if !b1_ratio.nil? && !b2_ratio.nil? && b1_ratio>=2 && b2_ratio>=2
# 				all_conditions_mod_pep_hits[peptide][2] = count1 #count
# 				all_conditions_mod_pep_hits[peptide][3] = count2 #count
# 				all_conditions_mod_pep_hits[peptide][4] = count3 #count
# 				all_conditions_mod_pep_hits[peptide][5] = count4 #count

# 				accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
# 				accnos.uniq!
# 				accnos.delete_if {|x| x.nil?}

# 				descs = [cond1_filtered[peptide][1], cond2_filtered[peptide][1], cond3_filtered[peptide][1], cond4_filtered[peptide][1]]
# 				descs.uniq!
# 				descs.delete_if {|x| x.nil?}

# 				all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
# 				all_conditions_mod_pep_hits[peptide][1] = descs.join(" | ") #desc

# 				sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_ratio, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5], b2_ratio]
# 			end
# 		end
# 	end
# end

# # create sheet3 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and ratio >=1.5
# all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

# results_wb.add_worksheet(:name => "by_ratio>=1.5") do |sheet|
# 	title = results_wb.styles.add_style(:b => true)
# 	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-ratio (among the conditions of the same experiment) >=1.5"], :style => title
# 	sheet.merge_cells "A1:J1"
# 	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", count_condition3, count_condition4, "b2_ratio", "Protein of interest? (Y/N)"], :style => title
# 	all_peptides.each_key do |peptide|

# 		if !cond1_filtered[peptide][2].nil?
# 			count1 = cond1_filtered[peptide][2].to_i
# 		else
# 			count1 = condition1_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond2_filtered[peptide][2].nil?
# 			count2 = cond2_filtered[peptide][2].to_i
# 		else
# 			count2 = condition2_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond3_filtered[peptide][2].nil?
# 			count3 = cond3_filtered[peptide][2].to_i
# 		else
# 			count3 = condition3_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond4_filtered[peptide][2].nil?
# 			count4 = cond4_filtered[peptide][2].to_i
# 		else
# 			count4 = condition4_mod_pep_hits[peptide][2].to_i
# 		end
		
# 		if (count1-count2>0 && count3-count4>0) || (count1-count2<0 && count3-count4<0) || (count1-count2==0 && count3-count4==0)

# 			if !count1.nil? && !count2.nil? && !count1.zero? && !count2.zero?
# 				b1_ratio = count1.to_f / count2.to_f
# 			end
# 			if !count3.nil? && !count4.nil? && !count3.zero? && !count4.zero?
# 				b2_ratio = count3.to_f / count4.to_f
# 			end

# 			if !b1_ratio.nil? && !b2_ratio.nil? && b1_ratio>=1.5 && b2_ratio>=1.5
# 				all_conditions_mod_pep_hits[peptide][2] = count1 #count
# 				all_conditions_mod_pep_hits[peptide][3] = count2 #count
# 				all_conditions_mod_pep_hits[peptide][4] = count3 #count
# 				all_conditions_mod_pep_hits[peptide][5] = count4 #count

# 				accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
# 				accnos.uniq!
# 				accnos.delete_if {|x| x.nil?}

# 				descs = [cond1_filtered[peptide][1], cond2_filtered[peptide][1], cond3_filtered[peptide][1], cond4_filtered[peptide][1]]
# 				descs.uniq!
# 				descs.delete_if {|x| x.nil?}

# 				all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
# 				all_conditions_mod_pep_hits[peptide][1] = descs.join(" | ") #desc

# 				sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_ratio, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5], b2_ratio]
# 			end
# 		end
# 	end
# end

# # create sheet4 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and ratio >=2, with reversed ratio for the negative direction
# all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

# results_wb.add_worksheet(:name => "by_mod_ratio>=2") do |sheet|
# 	title = results_wb.styles.add_style(:b => true)
# 	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-ratio (among the conditions of the same experiment) >=2, with reversed ratio for the negative direction"], :style => title
# 	sheet.merge_cells "A1:J1"
# 	sheet.add_row ["Peptide", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", count_condition3, count_condition4, "b2_ratio", "Protein of interest? (Y/N)"], :style => title
# 	all_peptides.each_key do |peptide|

# 		if !cond1_filtered[peptide][2].nil?
# 			count1 = cond1_filtered[peptide][2].to_i
# 		else
# 			count1 = condition1_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond2_filtered[peptide][2].nil?
# 			count2 = cond2_filtered[peptide][2].to_i
# 		else
# 			count2 = condition2_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond3_filtered[peptide][2].nil?
# 			count3 = cond3_filtered[peptide][2].to_i
# 		else
# 			count3 = condition3_mod_pep_hits[peptide][2].to_i
# 		end
# 		if !cond4_filtered[peptide][2].nil?
# 			count4 = cond4_filtered[peptide][2].to_i
# 		else
# 			count4 = condition4_mod_pep_hits[peptide][2].to_i
# 		end
		
# 		if count1-count2>0 && count3-count4>0
# 			if !count1.nil? && !count2.nil? && !count3.nil? && !count4.nil? && !count1.zero? && !count2.zero? && !count3.zero? && !count4.zero?
# 				b1_ratio = count1.to_f / count2.to_f
# 				b2_ratio = count3.to_f / count4.to_f
# 			end
# 		elsif count1-count2<0 && count3-count4<0
# 			if !count1.nil? && !count2.nil? && !count3.nil? && !count4.nil? && !count1.zero? && !count2.zero? && !count3.zero? && !count4.zero?
# 				b1_ratio = count2.to_f / count1.to_f
# 				b2_ratio = count4.to_f / count3.to_f
# 			end
# 		end

# 		if !b1_ratio.nil? && !b2_ratio.nil? && b1_ratio>=2 && b2_ratio>=2
# 			all_conditions_mod_pep_hits[peptide][2] = count1 #count
# 			all_conditions_mod_pep_hits[peptide][3] = count2 #count
# 			all_conditions_mod_pep_hits[peptide][4] = count3 #count
# 			all_conditions_mod_pep_hits[peptide][5] = count4 #count

# 			accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
# 			accnos.uniq!
# 			accnos.delete_if {|x| x.nil?}

# 			descs = [cond1_filtered[peptide][1], cond2_filtered[peptide][1], cond3_filtered[peptide][1], cond4_filtered[peptide][1]]
# 			descs.uniq!
# 			descs.delete_if {|x| x.nil?}

# 			all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
# 			all_conditions_mod_pep_hits[peptide][1] = descs.join(" | ") #desc

# 			sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_ratio, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5], b2_ratio]
# 		end
# 	end
# end

# create sheet5 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and ratio >=1.5, with reversed ratio for the negative direction
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "by_mod_ratio>=1.5") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-ratio (among the conditions of the same experiment) >=1.5, with reversed ratio for the negative direction"], :style => title
	sheet.merge_cells "A1:J1"
	sheet.add_row ["Peptide", "Modification", "Modified positions seq", "Mod. position indexes", "Protein accno(s)", "Protein description(s)", count_condition1, count_condition2, "b1_ratio", count_condition3, count_condition4, "b2_ratio"], :style => title
	all_peptides.each_key do |peptide|

		if !cond1_filtered[peptide][2].nil?
			count1 = cond1_filtered[peptide][2].to_i
		else
			count1 = condition1_mod_pep_hits[peptide][2].to_i
		end
		if !cond2_filtered[peptide][2].nil?
			count2 = cond2_filtered[peptide][2].to_i
		else
			count2 = condition2_mod_pep_hits[peptide][2].to_i
		end
		if !cond3_filtered[peptide][2].nil?
			count3 = cond3_filtered[peptide][2].to_i
		else
			count3 = condition3_mod_pep_hits[peptide][2].to_i
		end
		if !cond4_filtered[peptide][2].nil?
			count4 = cond4_filtered[peptide][2].to_i
		else
			count4 = condition4_mod_pep_hits[peptide][2].to_i
		end
		
		if count1-count2>0 && count3-count4>0
			if !count1.nil? && !count2.nil? && !count3.nil? && !count4.nil? && !count1.zero? && !count2.zero? && !count3.zero? && !count4.zero?
				b1_ratio = count1.to_f / count2.to_f
				b2_ratio = count3.to_f / count4.to_f
			end
		elsif count1-count2<0 && count3-count4<0
			if !count1.nil? && !count2.nil? && !count3.nil? && !count4.nil? && !count1.zero? && !count2.zero? && !count3.zero? && !count4.zero?
				b1_ratio = count2.to_f / count1.to_f
				b2_ratio = count4.to_f / count3.to_f
			end
		end

		if !b1_ratio.nil? && !b2_ratio.nil? && b1_ratio>=1.5 && b2_ratio>=1.5
			all_conditions_mod_pep_hits[peptide][2] = count1 #count
			all_conditions_mod_pep_hits[peptide][3] = count2 #count
			all_conditions_mod_pep_hits[peptide][4] = count3 #count
			all_conditions_mod_pep_hits[peptide][5] = count4 #count

			accnos = [cond1_filtered[peptide][0], cond2_filtered[peptide][0], cond3_filtered[peptide][0], cond4_filtered[peptide][0]]
			accnos.uniq!
			accnos.delete_if {|x| x.nil?}

			descs = [cond1_filtered[peptide][1], cond2_filtered[peptide][1], cond3_filtered[peptide][1], cond4_filtered[peptide][1]]
			descs.uniq!
			descs.delete_if {|x| x.nil?}

			if cond1_filtered[peptide][3]
				tmp1 = "c1: " + cond1_filtered[peptide][3]
			end
			if cond2_filtered[peptide][3]
				tmp2 = "c2: " + cond2_filtered[peptide][3]
			end
			if cond3_filtered[peptide][3]
				tmp3 = "c3: " + cond3_filtered[peptide][3]
			end
			if cond4_filtered[peptide][3]
				tmp4 = "c4: " + cond4_filtered[peptide][3]
			end
			modifications = [tmp1, tmp2, tmp3, tmp4]
			modifications.delete_if {|x| x.nil?}

			mod_positions = [cond1_filtered[peptide][4], cond2_filtered[peptide][4], cond3_filtered[peptide][4], cond4_filtered[peptide][4]]
			mod_positions.delete_if {|x| x.nil?}

			mod_positions_idxs = [cond1_filtered[peptide][5], cond2_filtered[peptide][5], cond3_filtered[peptide][5], cond4_filtered[peptide][5]]
			mod_positions_idxs.delete_if {|x| x.nil?}

			all_conditions_mod_pep_hits[peptide][0] = accnos.join("|") #accnos
			all_conditions_mod_pep_hits[peptide][1] = descs.join(" | ") #desc
			all_conditions_mod_pep_hits[peptide][6] = modifications.join(" | ") #modification
			all_conditions_mod_pep_hits[peptide][7] = mod_positions.join(" | ") #modified position
			all_conditions_mod_pep_hits[peptide][8] = mod_positions_idxs.join(" | ") #modified position indexes

			if proteins_of_interest_hash[peptide]
				sheet.add_row [peptide, all_conditions_mod_pep_hits[peptide][6], all_conditions_mod_pep_hits[peptide][7], all_conditions_mod_pep_hits[peptide][8], all_conditions_mod_pep_hits[peptide][0], all_conditions_mod_pep_hits[peptide][1], all_conditions_mod_pep_hits[peptide][2], all_conditions_mod_pep_hits[peptide][3], b1_ratio, all_conditions_mod_pep_hits[peptide][4], all_conditions_mod_pep_hits[peptide][5], b2_ratio]
			end
		end
	end
end

# write xlsx file
results_xlsx.serialize(spectra_counts_mod_peps_ofile)

