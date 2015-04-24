class ProteinHit
	attr_accessor :score, :e_value, :mh, :matched_peaks, :matched_intensity, :pep_seq, :miss_cleave, :proteins, :protein_ids, :prev_next_aa, :pro_start_pos, :modify_pos, :modify_name, :mod_site, :delta_mass

	def initialize(score, e_value, mh, matched_peaks, matched_intensity, pep_seq, miss_cleave, proteins, protein_ids, prev_next_aa, pro_start_pos, modify_pos, modify_name, mod_site, delta_mass)
		@score = score
		@e_value = e_value
		@mh = mh
		@matched_peaks = matched_peaks
		@matched_intensity = matched_intensity
		@pep_seq = pep_seq
		@miss_cleave = miss_cleave
		@proteins = proteins
		@protein_ids = protein_ids
		@prev_next_aa = prev_next_aa
		@pro_start_pos = pro_start_pos
		@modify_pos = modify_pos
		@modify_name = modify_name
		@mod_site = mod_site
		@delta_mass = delta_mass
	end
	
	def to_csv()
		hit = '"' + [@score, @e_value, @mh, @matched_peaks, @matched_intensity, @pep_seq, @miss_cleave, @proteins, @protein_ids, @prev_next_aa, @pro_start_pos, @modify_pos, @modify_name, @mod_site, @delta_mass].join('","') + '"'
		return hit
	end

end
	