# ruby spectra-counts_filters_phospho-residues_ms2.rb ../results/ms2/proteins_of_interest_with_modifications_ms2.csv

require 'csv_parser_for_protein_hits'
require 'rubygems'
require 'axlsx'

# input
csvp_condition1 = CSVParserForProteinHits.open("../samples/csvs/soft_b1.csv", 100)
csvp_condition2 = CSVParserForProteinHits.open("../samples/csvs/stiff_b1.csv", 100)
csvp_condition3 = CSVParserForProteinHits.open("../samples/csvs/soft_b2.csv", 100)
csvp_condition4 = CSVParserForProteinHits.open("../samples/csvs/stiff_b2.csv", 100)
modification = "Phospho"
count_condition1 = "soft_b1"
count_condition2 = "stiff_b1"
count_condition3 = "soft_b2"
count_condition4 = "stiff_b2"

# output files
spectra_counts_mod_peps_ofile = ARGV[0]

# count the spectra for each condition
condition1_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition1.each_peptide do |peptide|
	if csvp_condition1.hit_objs_for_mod_pep(peptide, modification)[peptide]
		condition1_mod_pep_hits[peptide] = csvp_condition1.hit_objs_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition1_mod_pep_hits.inspect

condition2_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition2.each_peptide do |peptide|
	if csvp_condition2.hit_objs_for_mod_pep(peptide, modification)[peptide]
		condition2_mod_pep_hits[peptide] = csvp_condition2.hit_objs_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition2_mod_pep_hits.inspect

condition3_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition3.each_peptide do |peptide|
	if csvp_condition3.hit_objs_for_mod_pep(peptide, modification)[peptide]
		condition3_mod_pep_hits[peptide] = csvp_condition3.hit_objs_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition3_mod_pep_hits.inspect

condition4_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
csvp_condition4.each_peptide do |peptide|
	if csvp_condition4.hit_objs_for_mod_pep(peptide, modification)[peptide]
		condition4_mod_pep_hits[peptide] = csvp_condition4.hit_objs_for_mod_pep(peptide, modification)[peptide]
	end
end
# puts condition4_mod_pep_hits.inspect


# create filtered lists for peptides with count >2 in both experiments, but in same condition
cond1_filtered = Hash.new {|h,k| h[k] = [] }
condition1_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][1].to_i > 2 && condition3_mod_pep_hits[peptide][1].to_i > 2) || (condition2_mod_pep_hits[peptide][1].to_i > 2 && condition4_mod_pep_hits[peptide][1].to_i > 2)
		cond1_filtered[peptide] = condition1_mod_pep_hits[peptide]
	end
end

cond2_filtered = Hash.new {|h,k| h[k] = [] }
condition2_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][1].to_i > 2 && condition3_mod_pep_hits[peptide][1].to_i > 2) || (condition2_mod_pep_hits[peptide][1].to_i > 2 && condition4_mod_pep_hits[peptide][1].to_i > 2)
		cond2_filtered[peptide] = condition2_mod_pep_hits[peptide]
	end
end

cond3_filtered = Hash.new {|h,k| h[k] = [] }
condition3_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][1].to_i > 2 && condition3_mod_pep_hits[peptide][1].to_i > 2) || (condition2_mod_pep_hits[peptide][1].to_i > 2 && condition4_mod_pep_hits[peptide][1].to_i > 2)
		cond3_filtered[peptide] = condition3_mod_pep_hits[peptide]
	end
end

cond4_filtered = Hash.new {|h,k| h[k] = [] }
condition4_mod_pep_hits.each_key do |peptide|
	if (condition1_mod_pep_hits[peptide][1].to_i > 2 && condition3_mod_pep_hits[peptide][1].to_i > 2) || (condition2_mod_pep_hits[peptide][1].to_i > 2 && condition4_mod_pep_hits[peptide][1].to_i > 2)
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
results_xlsx.use_autowidth = true
results_wb = results_xlsx.workbook

proteins_of_interest_array = ["VDIITEEMPENALPSDEDDKDPNDPYR", "SQEMVHLVNK", "DPQTLDSSVGRPEDSSLTQDEDR", "SPDTSAYCYETMEK", "SVSPGVTQAVVEEHCASPEEK", "AAVGVTGNDITTPPNKEPPPSPEK", "VLLAADSEEEGDFPSGR", "QLHIEGASLELSDDDTESK", "SLEDESQETFGSLEK", "DELHIVEAEAMNYEGSPIK", "AAVQELSGSILTSEDPEER", "TGDLGIPPNPEDRSPSPEPIYNSEGK", "ATDAEADVASLNR", "GDSETDLEALFNAVMNPK", "VTLQDYHLPDSDEDEETAIQR", "ISDPLTSSPGR", "TASGSSVTSLEGTR", "LPTKPETSFEEGDGR", "DDSPKEYTDLEVSNK"]
proteins_of_interest_hash = Hash[proteins_of_interest_array.map {|x| [x, '']}]

# create sheet1 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and count dif>=2
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "by_count_diff") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-difference (among the conditions of the same experiment) >=2"], :style => title
	sheet.merge_cells "A1:AU1"
	sheet.add_row ["", count_condition1, "", "", "", "", "", "", "", "", "", "", count_condition2, "", "", "", "", "", "", "", "", "", "", count_condition3, "", "", "", "", "", "", "", "", "", "", count_condition4, "", "", "", "", "", "", "", "", "", ""], :style => title
	sheet.merge_cells "B2:L2"
	sheet.merge_cells "M2:W2"
	sheet.merge_cells "X2:AH2"
	sheet.merge_cells "AI2:AS2"
	sheet.add_row ["Peptide", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "b1_count_diff", "b2_count_diff"], :style => title
	all_peptides.each_key do |peptide|

		if !cond1_filtered[peptide][1].nil?
			count1 = cond1_filtered[peptide][1].to_i
		else
			count1 = condition1_mod_pep_hits[peptide][1].to_i
		end
		if !cond2_filtered[peptide][1].nil?
			count2 = cond2_filtered[peptide][1].to_i
		else
			count2 = condition2_mod_pep_hits[peptide][1].to_i
		end
		if !cond3_filtered[peptide][1].nil?
			count3 = cond3_filtered[peptide][1].to_i
		else
			count3 = condition3_mod_pep_hits[peptide][1].to_i
		end
		if !cond4_filtered[peptide][1].nil?
			count4 = cond4_filtered[peptide][1].to_i
		else
			count4 = condition4_mod_pep_hits[peptide][1].to_i
		end

		# grab the highest scored peptide
		score_c1 = 0
		highest_scored_hit_c1 = nil
		if !cond1_filtered[peptide][0].nil?
			cond1_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c1)
					score_c1 = hit.pep_score
					highest_scored_hit_c1 = hit	
				end
			end
		end

		score_c2 = 0
		highest_scored_hit_c2 = nil
		if !cond2_filtered[peptide][0].nil?
			cond2_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c2)
					score_c2 = hit.pep_score
					highest_scored_hit_c2 = hit	
				end
			end
		end

		score_c3 = 0
		highest_scored_hit_c3 = nil
		if !cond3_filtered[peptide][0].nil?
			cond3_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c3)
					score_c3 = hit.pep_score
					highest_scored_hit_c3 = hit	
				end
			end
		end

		score_c4 = 0
		highest_scored_hit_c4 = nil
		if !cond4_filtered[peptide][0].nil?
			cond4_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c4)
					score_c4 = hit.pep_score
					highest_scored_hit_c4 = hit	
				end
			end
		end

		# grab the details for the highest scored pep in each condition
		if !highest_scored_hit_c1.nil?
			accno1 = highest_scored_hit_c1.prot_acc
			desc1 = highest_scored_hit_c1.prot_desc
			mod1 = highest_scored_hit_c1.pep_var_mod
			mod_pos1 = highest_scored_hit_c1.pep_var_mod_pos
			query1 = highest_scored_hit_c1.pep_query
			calc_mr1 = highest_scored_hit_c1.pep_calc_mr
			exp_mr1 = highest_scored_hit_c1.pep_exp_mr
			delta1 = highest_scored_hit_c1.pep_delta
			expect1 =  highest_scored_hit_c1.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos1.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs1 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c2.nil?
			accno2 = highest_scored_hit_c2.prot_acc
			desc2 = highest_scored_hit_c2.prot_desc
			mod2 = highest_scored_hit_c2.pep_var_mod
			mod_pos2 = highest_scored_hit_c2.pep_var_mod_pos
			query2 = highest_scored_hit_c2.pep_query
			calc_mr2 = highest_scored_hit_c2.pep_calc_mr
			exp_mr2 = highest_scored_hit_c2.pep_exp_mr
			delta2 = highest_scored_hit_c2.pep_delta
			expect2 =  highest_scored_hit_c2.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos2.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs2 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c3.nil?
			accno3 = highest_scored_hit_c3.prot_acc
			desc3 = highest_scored_hit_c3.prot_desc
			mod3 = highest_scored_hit_c3.pep_var_mod
			mod_pos3 = highest_scored_hit_c3.pep_var_mod_pos
			query3 = highest_scored_hit_c3.pep_query
			calc_mr3 = highest_scored_hit_c3.pep_calc_mr
			exp_mr3 = highest_scored_hit_c3.pep_exp_mr
			delta3 = highest_scored_hit_c3.pep_delta
			expect3 =  highest_scored_hit_c3.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos3.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs3 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c4.nil?
			accno4 = highest_scored_hit_c4.prot_acc
			desc4 = highest_scored_hit_c4.prot_desc
			mod4 = highest_scored_hit_c4.pep_var_mod
			mod_pos4 = highest_scored_hit_c4.pep_var_mod_pos
			query4 = highest_scored_hit_c4.pep_query
			calc_mr4 = highest_scored_hit_c4.pep_calc_mr
			exp_mr4 = highest_scored_hit_c4.pep_exp_mr
			delta4 = highest_scored_hit_c4.pep_delta
			expect4 =  highest_scored_hit_c4.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos4.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs4 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		accnos = [accno1, accno2, accno3, accno4]
		descs = [desc1, desc2, desc3, desc4]
		modifications = [mod1, mod2, mod3, mod4]
		mod_positions_idxs = [mod_positions_idxs1, mod_positions_idxs2, mod_positions_idxs3, mod_positions_idxs4]
		queries = [query1, query2, query3, query4]
		calc_masses = [calc_mr1, calc_mr2, calc_mr3, calc_mr4]
		exp_masses = [exp_mr1, exp_mr2, exp_mr3, exp_mr4]
		highest_scores = [score_c1, score_c2, score_c3, score_c4]
		deltas = [delta1, delta2, delta3, delta4]
		cutoffs = [expect1, expect2, expect3, expect4]
		
		if (count1-count2>0 && count3-count4>0) || (count1-count2<0 && count3-count4<0) || (count1-count2==0 && count3-count4==0)
			if (count1-count2).abs>=2 && (count3-count4).abs>=2
				all_conditions_mod_pep_hits[peptide][2] = count1 #count
				all_conditions_mod_pep_hits[peptide][3] = count2 #count
				all_conditions_mod_pep_hits[peptide][4] = count3 #count
				all_conditions_mod_pep_hits[peptide][5] = count4 #count

				if !all_conditions_mod_pep_hits[peptide][2].nil? && !all_conditions_mod_pep_hits[peptide][3].nil?
					b1_difer = all_conditions_mod_pep_hits[peptide][2].to_i - all_conditions_mod_pep_hits[peptide][3].to_i
				end
				if !all_conditions_mod_pep_hits[peptide][4].nil? && !all_conditions_mod_pep_hits[peptide][5].nil?
					b2_difer = all_conditions_mod_pep_hits[peptide][4].to_i - all_conditions_mod_pep_hits[peptide][5].to_i
				end

				if proteins_of_interest_hash[peptide]
					sheet.add_row [peptide, modifications[0], mod_positions_idxs[0], accnos[0], descs[0], queries[0], exp_masses[0], calc_masses[0], highest_scores[0], deltas[0], cutoffs[0], all_conditions_mod_pep_hits[peptide][2], modifications[1], mod_positions_idxs[1], accnos[1], descs[1], queries[1], exp_masses[1], calc_masses[1], highest_scores[1], deltas[1], cutoffs[1], all_conditions_mod_pep_hits[peptide][3], modifications[2], mod_positions_idxs[2], accnos[2], descs[2], queries[2], exp_masses[2], calc_masses[2], highest_scores[2], deltas[2], cutoffs[2], all_conditions_mod_pep_hits[peptide][4], modifications[3], mod_positions_idxs[3], accnos[3], descs[3], queries[3], exp_masses[3], calc_masses[3], highest_scores[3], deltas[3], cutoffs[3], all_conditions_mod_pep_hits[peptide][5], b1_difer, b2_difer]
				end
			end
		end
	end
end


# create sheet2 - peptides with count>2 in the same condition (soft or stiff), but in both experiments, with the same count-difference direction and ratio >=1.5, with reversed ratio for the negative direction
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "by_mod_ratio>=1.5") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Filtered by: both experiments, same condition, same count-difference direction (among the conditions of the same experiment), count-ratio (among the conditions of the same experiment) >=1.5, with reversed ratio for the negative direction"], :style => title
	sheet.merge_cells "A1:AU1"
	sheet.add_row ["", count_condition1, "", "", "", "", "", "", "", "", "", "", count_condition2, "", "", "", "", "", "", "", "", "", "", count_condition3, "", "", "", "", "", "", "", "", "", "", count_condition4, "", "", "", "", "", "", "", "", "", ""], :style => title
	sheet.merge_cells "B2:L2"
	sheet.merge_cells "M2:W2"
	sheet.merge_cells "X2:AH2"
	sheet.merge_cells "AI2:AS2"
	sheet.add_row ["Peptide", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count", "b1_count_ratio", "b2_count_ratio"], :style => title
	all_peptides.each_key do |peptide|

		if !cond1_filtered[peptide][1].nil?
			count1 = cond1_filtered[peptide][1].to_i
		else
			count1 = condition1_mod_pep_hits[peptide][1].to_i
		end
		if !cond2_filtered[peptide][1].nil?
			count2 = cond2_filtered[peptide][1].to_i
		else
			count2 = condition2_mod_pep_hits[peptide][1].to_i
		end
		if !cond3_filtered[peptide][1].nil?
			count3 = cond3_filtered[peptide][1].to_i
		else
			count3 = condition3_mod_pep_hits[peptide][1].to_i
		end
		if !cond4_filtered[peptide][1].nil?
			count4 = cond4_filtered[peptide][1].to_i
		else
			count4 = condition4_mod_pep_hits[peptide][1].to_i
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

		# grab the highest scored peptide
		score_c1 = 0
		highest_scored_hit_c1 = nil
		if !cond1_filtered[peptide][0].nil?
			cond1_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c1)
					score_c1 = hit.pep_score
					highest_scored_hit_c1 = hit	
				end
			end
		end

		score_c2 = 0
		highest_scored_hit_c2 = nil
		if !cond2_filtered[peptide][0].nil?
			cond2_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c2)
					score_c2 = hit.pep_score
					highest_scored_hit_c2 = hit	
				end
			end
		end

		score_c3 = 0
		highest_scored_hit_c3 = nil
		if !cond3_filtered[peptide][0].nil?
			cond3_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c3)
					score_c3 = hit.pep_score
					highest_scored_hit_c3 = hit	
				end
			end
		end

		score_c4 = 0
		highest_scored_hit_c4 = nil
		if !cond4_filtered[peptide][0].nil?
			cond4_filtered[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score_c4)
					score_c4 = hit.pep_score
					highest_scored_hit_c4 = hit	
				end
			end
		end

		# grab the details for the highest scored pep in each condition
		if !highest_scored_hit_c1.nil?
			accno1 = highest_scored_hit_c1.prot_acc
			desc1 = highest_scored_hit_c1.prot_desc
			mod1 = highest_scored_hit_c1.pep_var_mod
			mod_pos1 = highest_scored_hit_c1.pep_var_mod_pos
			query1 = highest_scored_hit_c1.pep_query
			calc_mr1 = highest_scored_hit_c1.pep_calc_mr
			exp_mr1 = highest_scored_hit_c1.pep_exp_mr
			delta1 = highest_scored_hit_c1.pep_delta
			expect1 =  highest_scored_hit_c1.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos1.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs1 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c2.nil?
			accno2 = highest_scored_hit_c2.prot_acc
			desc2 = highest_scored_hit_c2.prot_desc
			mod2 = highest_scored_hit_c2.pep_var_mod
			mod_pos2 = highest_scored_hit_c2.pep_var_mod_pos
			query2 = highest_scored_hit_c2.pep_query
			calc_mr2 = highest_scored_hit_c2.pep_calc_mr
			exp_mr2 = highest_scored_hit_c2.pep_exp_mr
			delta2 = highest_scored_hit_c2.pep_delta
			expect2 =  highest_scored_hit_c2.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos2.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs2 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c3.nil?
			accno3 = highest_scored_hit_c3.prot_acc
			desc3 = highest_scored_hit_c3.prot_desc
			mod3 = highest_scored_hit_c3.pep_var_mod
			mod_pos3 = highest_scored_hit_c3.pep_var_mod_pos
			query3 = highest_scored_hit_c3.pep_query
			calc_mr3 = highest_scored_hit_c3.pep_calc_mr
			exp_mr3 = highest_scored_hit_c3.pep_exp_mr
			delta3 = highest_scored_hit_c3.pep_delta
			expect3 =  highest_scored_hit_c3.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos3.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs3 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		if !highest_scored_hit_c4.nil?
			accno4 = highest_scored_hit_c4.prot_acc
			desc4 = highest_scored_hit_c4.prot_desc
			mod4 = highest_scored_hit_c4.pep_var_mod
			mod_pos4 = highest_scored_hit_c4.pep_var_mod_pos
			query4 = highest_scored_hit_c4.pep_query
			calc_mr4 = highest_scored_hit_c4.pep_calc_mr
			exp_mr4 = highest_scored_hit_c4.pep_exp_mr
			delta4 = highest_scored_hit_c4.pep_delta
			expect4 =  highest_scored_hit_c4.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos4.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs4 = position_hash['2'].concat(position_hash['3']).join(",")
		end

		accnos = [accno1, accno2, accno3, accno4]
		descs = [desc1, desc2, desc3, desc4]
		modifications = [mod1, mod2, mod3, mod4]
		mod_positions_idxs = [mod_positions_idxs1, mod_positions_idxs2, mod_positions_idxs3, mod_positions_idxs4]
		queries = [query1, query2, query3, query4]
		calc_masses = [calc_mr1, calc_mr2, calc_mr3, calc_mr4]
		exp_masses = [exp_mr1, exp_mr2, exp_mr3, exp_mr4]
		highest_scores = [score_c1, score_c2, score_c3, score_c4]
		deltas = [delta1, delta2, delta3, delta4]
		cutoffs = [expect1, expect2, expect3, expect4]

		if !b1_ratio.nil? && !b2_ratio.nil? && b1_ratio>=1.5 && b2_ratio>=1.5
			all_conditions_mod_pep_hits[peptide][2] = count1 #count
			all_conditions_mod_pep_hits[peptide][3] = count2 #count
			all_conditions_mod_pep_hits[peptide][4] = count3 #count
			all_conditions_mod_pep_hits[peptide][5] = count4 #count

			if proteins_of_interest_hash[peptide]
				sheet.add_row [peptide, modifications[0], mod_positions_idxs[0], accnos[0], descs[0], queries[0], exp_masses[0], calc_masses[0], highest_scores[0], deltas[0], cutoffs[0], all_conditions_mod_pep_hits[peptide][2], modifications[1], mod_positions_idxs[1], accnos[1], descs[1], queries[1], exp_masses[1], calc_masses[1], highest_scores[1], deltas[1], cutoffs[1], all_conditions_mod_pep_hits[peptide][3], modifications[2], mod_positions_idxs[2], accnos[2], descs[2], queries[2], exp_masses[2], calc_masses[2], highest_scores[2], deltas[2], cutoffs[2], all_conditions_mod_pep_hits[peptide][4], modifications[3], mod_positions_idxs[3], accnos[3], descs[3], queries[3], exp_masses[3], calc_masses[3], highest_scores[3], deltas[3], cutoffs[3], all_conditions_mod_pep_hits[peptide][5], b1_ratio, b2_ratio]
			end
		end
	end
end

# write xlsx file
results_xlsx.serialize(spectra_counts_mod_peps_ofile)

