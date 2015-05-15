# ruby glass_spectra_count.rb ../results/ms2/INPUT_glass_ms2.xlsx

require 'csv_parser_for_protein_hits'
require 'rubygems'
require 'axlsx'

# input
csvp = CSVParserForProteinHits.open("../samples/csvs/glass.csv", 100) # piped
modification = "Phospho"
condition = "glass"

# output files
spectra_counts_mod_peps_ofile = ARGV[0]

proteins_of_interest_array = ["VDIITEEMPENALPSDEDDKDPNDPYR", "SQEMVHLVNK", "DPQTLDSSVGRPEDSSLTQDEDR", "SPDTSAYCYETMEK", "SVSPGVTQAVVEEHCASPEEK", "AAVGVTGNDITTPPNKEPPPSPEK", "VLLAADSEEEGDFPSGR", "QLHIEGASLELSDDDTESK", "SLEDESQETFGSLEK", "DELHIVEAEAMNYEGSPIK", "AAVQELSGSILTSEDPEER", "TGDLGIPPNPEDRSPSPEPIYNSEGK", "ATDAEADVASLNR", "GDSETDLEALFNAVMNPK", "VTLQDYHLPDSDEDEETAIQR", "ISDPLTSSPGR", "TASGSSVTSLEGTR", "LPTKPETSFEEGDGR", "DDSPKEYTDLEVSNK"]
proteins_of_interest_hash = Hash[proteins_of_interest_array.map {|x| [x, '']}]

# count the spectra
mod_pep_hits = Hash.new {|h,k| h[k] = []}
csvp.each_peptide do |peptide|
	if csvp.hit_objs_for_mod_pep(peptide, modification)[peptide]
		mod_pep_hits[peptide] = csvp.hit_objs_for_mod_pep(peptide, modification)[peptide]
	end
end

# create filtered list for peptides with count >0
filtered_mod_pep_hits = Hash.new {|h,k| h[k] = [] }
mod_pep_hits.each_key do |peptide|
	if (mod_pep_hits[peptide][1].to_i > 0)
		filtered_mod_pep_hits[peptide] = mod_pep_hits[peptide]
	end
end

# create output file
results_xlsx = Axlsx::Package.new
results_xlsx.use_autowidth = true
results_wb = results_xlsx.workbook

# create sheet - peptides with count>2
all_conditions_mod_pep_hits = Hash.new {|h,k| h[k] = [] }

results_wb.add_worksheet(:name => "glass_spectra_counts") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Peptide", "Modification(s)", "Modified position(s)", "Protein accno", "Protein description", "Query", "Observed mass", "Calculated mass", "Score", "Delta", "Cutoff", "Spectra count"], :style => title
	
	filtered_mod_pep_hits.each_key do |peptide|
		count=0
		if !filtered_mod_pep_hits[peptide][1].nil?
			count = filtered_mod_pep_hits[peptide][1].to_i
		else
			count = mod_pep_hits[peptide][1].to_i
		end
		
		# grab the highest scored peptide
		score = 0
		highest_scored_hit = nil
		if !filtered_mod_pep_hits[peptide][0].nil?
			filtered_mod_pep_hits[peptide][0].each do |hit|
				if (hit.pep_score.to_f >= score)
					score = hit.pep_score
					highest_scored_hit = hit	
				end
			end
		end

		# grab the details for the highest scored pep in each condition
		if !highest_scored_hit.nil?
			accno = highest_scored_hit.prot_acc
			desc = highest_scored_hit.prot_desc
			mod = highest_scored_hit.pep_var_mod
			mod_pos = highest_scored_hit.pep_var_mod_pos
			query = highest_scored_hit.pep_query
			calc_mr = highest_scored_hit.pep_calc_mr
			exp_mr = highest_scored_hit.pep_exp_mr
			delta = highest_scored_hit.pep_delta
			expect =  highest_scored_hit.pep_expect
			# mod positions indexes
			position_hash = Hash.new {|h,k| h[k] = [] }
			positions_array = mod_pos.split(".")[1].split(".")[0].split("")
			positions_array.each_with_index do |item,idx|; position_hash[item]<<idx+1; end
			mod_positions_idxs = position_hash['2'].concat(position_hash['3']).join(",")
		end
		
		if proteins_of_interest_hash[peptide]
			sheet.add_row [peptide, mod, mod_positions_idxs, accno, desc, query, exp_mr, calc_mr, score, delta, expect, count]
		end
			
	end
end

# write xlsx file
results_xlsx.serialize(spectra_counts_mod_peps_ofile)

