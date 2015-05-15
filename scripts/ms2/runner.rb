# USAGE: ruby ms2/runner.rb INPUT_diff_proteins_of_interest_with_modifications_ms2.csv diff-list_transitions.csv
# ruby ms2/runner.rb INPUT_ratio_proteins_of_interest_with_modifications_ms2.csv ratio-list_transitions.csv
# ruby ms2/runner.rb INPUT_glass_ms2.csv glass_transitions.csv
# ruby ms2/runner.rb INPUT_glass_unfiltered_ms2.csv glass_unfiltered_transitions.csv

require 'rubygems'
require 'fastercsv'
require 'ms2/pep'
require 'mascot/dat'
require 'gnuplot'

csvfile = ARGV[0]
outfile = ARGV[1]
# ionstables_file = ARGV[2]
foldername = '../samples/'
resultsfolder = '../results/ms2/'
# condition_names = ["F003933_soft_b1", "F003931_stiff_b1", "F003952_soft_b2", "F003953_stiff_b2"]
line_counter = 0
modifications = []
mod_positions = []
mod_positions_str = nil
spectrum = {}
# itf = File.open(resultsfolder + 'ionstables/' + ionstables_file,'w')

# plot the spectra
def gplot(peptide, title, assigned_ions, mzs, intensities, figure_filename)
	Gnuplot.open do |gp|
		Gnuplot::Plot.new( gp ) do |plot|
			plot.output figure_filename
			plot.terminal 'svg'
			plot.title  "Query title:#{title} of #{peptide}"
			plot.ylabel 'intensity'
			plot.xlabel 'm/z'
			x_vals = assigned_ions.collect{|mass| mass.first}
			y_vals = assigned_ions.collect{|arr| arr[1]}
			l_vals = assigned_ions.collect{|idx| idx[2]}
			
			plot.data << Gnuplot::DataSet.new( [mzs, intensities] ) do |ds|
				ds.with = 'impulses linecolor rgb "blue"'
				ds.linewidth = 1
				ds.notitle
			end
			
			plot.data << Gnuplot::DataSet.new( [x_vals, y_vals] ) do |ds|
				ds.with = 'impulses linecolor rgb "red"'
				ds.linewidth = 1.5
				ds.notitle
			end

			max_y_val = y_vals.max
			label_y_vals = y_vals.map{|value| value + max_y_val*0.05}
			plot.data << Gnuplot::DataSet.new( [x_vals, label_y_vals, l_vals] ) do |ds|
				ds.with = 'labels textcolor lt 1 rotate left'
				ds.notitle
			end
		end
	end
end

FasterCSV.open(resultsfolder + outfile,'w') do |csv|
	csv << %w{ Peptide Query Condition Accno Protein_description Modification Modified_peptide Spectrum_id Charge Ret_time Score Expect Parent_mz Calc_mass Delta MS2_mz MS2_int y_int_rank y_idx y_ion_seq y-1 y y+2 }
	
	in_peps_table = false
	FasterCSV.foreach(resultsfolder + csvfile) do |row|
		assigned_ions = Array.new()

		if row[0] == "Peptide"
			in_peps_table = true
			next
		end

		if in_peps_table == true
			peptide = row[0].to_s
			modifications.clear
			row[1].split(";").each do |mod|
				mod.scan(/Phospho\s\((\w+)\)/) #Phospho (ST)
				if $1
					modifications << $1
				end
			end
			modifications_str = modifications.join(",")
			mod_positions = row[2].split(",")
			accno = row[3].to_s
			desc = row[4].to_s
			query_no = row[5].to_i
			parent_mass = row[6].to_s
			calc_mass = row[7].to_s
			score = row[8].to_f
			delta = row[9].to_f
			cutoff = row[10].to_f
			condition = row[12].to_s

			# take the ions table from dat file
			filename = foldername + 'dats/' + condition +  '.dat'
			dat = Mascot::DAT.open(filename, true)
			spectrum = dat.query(query_no)
			title = spectrum.title
			charge = spectrum.charge
			rtinseconds = spectrum.rtinseconds
			ions1 = spectrum.peaks
			mzs = spectrum.mz
			intensities = spectrum.intensity

			pep = Pep.new(peptide, mzs, intensities, mod_positions)
			assigned_yions = pep.assigned_yions
			
			# Pick up the 3 most significant transitions from MS2 spectrum for each peptide & print transitions file
			ranked_idx = pep.ranked_yions_intensities_idx
			ranked_idx.each_with_index do |i,ii|
				if( assigned_yions[i] && !assigned_yions[i][0].nil? && 1
					assigned_yions[i][0] > 0 && ii < 3)
					yidx = assigned_yions[i][0] - 1
					csv << [
						peptide,
						query_no,
						condition,
						accno,
						desc,
						modifications_str,
						pep.to_s,
						title,
						charge,
						rtinseconds.to_f / 60 ,
						score,
						cutoff,
						parent_mass,
						calc_mass,
						delta,
						mzs[i],
						intensities[i],
						ii, # the mz intensity rank
						assigned_yions[i][0],
						pep.yions[yidx][0], # y ion sequence
						assigned_yions[i][1] - H ,
						assigned_yions[i][1],
						assigned_yions[i][1] + (H * 2)
					]
				end
			end
			

# 				# print the ionstable file
# 				itf.puts "#{repl_with_highest_score}, #{query_no}, #{peptide}"
# 				itf.puts(%w{ mass intensity y-index }.join(","))
# 				pep.print_all_yionstable_to_filehandle(itf)
# 
				# plot the spectra
				assigned_yionstable = pep.assigned_yionstable
				figure_filename = "#{resultsfolder}/figures/glass/#{peptide}_#{condition}_#{query_no}.svg"
				gplot(peptide, title, assigned_yionstable, mzs, intensities, figure_filename)
		end
	end
end

