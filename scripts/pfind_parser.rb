require 'spectra_hit'

class TxtParserForSpectra
	attr_accessor :filename, :cutoff

	def initialize(filename, cutoff)
		@filename = filename
		@cutoff = cutoff.to_f
		@filehandle = File.new(filename)
		@spectrum_index = {}
		create_pep_index
	end

	def self.open(filename, cutoff)
		txtp = TxtParserForSpectra.new(filename, cutoff)
		if block_given?
			txtp.each do |hit|
				yield hit
			end
		else
			return txtp
		end
	end

	# ?
	def create_spectra_index()
		in_spectrum = false
		@filehandle.each do |line|
			line_pos = @filehandle.pos - line.length
			spectrum_hit = 0
			if line.include? "[Spectrum"
				in_spectrum = true
				spectrum_hit = line.split('Spectrum')[1].split(']')[0].to_i
				next
			end
			if in_spectrum == true
				if !@spectrum_index.has_key?(spectrum_hit)
					@spectrum_index[spectrum_hit] = []
				end
				@spectrum_index[spectrum_hit] << line_pos
			end
		end
	end

	def hits_for_mod_pep(peptide, modification)
		hits = []
		hits = protein_hits(peptide)
		hits_count_per_peptide ={} #= Hash.new {|h,k| h[k] = [] }
		count = 0
		hits.each do |hit|
			if hit.pep_var_mod.include? modification
				if !hits_count_per_peptide.has_key?(hit.pep_seq)
					count = 1
					hits_count_per_peptide[hit.pep_seq] = [hit.prot_acc , hit.prot_desc, count]
				else
					count += 1
					hits_count_per_peptide[hit.pep_seq] = [hit.prot_acc , hit.prot_desc, count]
				end
			end
			# puts peptide + ": " + hits_count_per_peptide[hit.pep_seq].inspect
		end
		return hits_count_per_peptide
	end

	def highest_scored_hit_for_mod_pep(peptide, modification)
		highest_scored_hit = nil
		hits = []
		hits = protein_hits(peptide)
		score = 0
		hits.each do |hit|
			if (hit.pep_score.to_f >= score) && (hit.pep_var_mod.include? modification)
				score = hit.pep_score
				highest_scored_hit = hit	
			end
		end
		return highest_scored_hit
	end

	def highest_scored_hit_for_non_mod_pep(peptide, modification)
		highest_scored_hit = nil
		hits = []
		hits = protein_hits(peptide)
		score = 0
		hits.each do |hit|
			if (hit.pep_score.to_f >= score) && (!hit.pep_var_mod.include? modification)
				score = hit.pep_score
				highest_scored_hit = hit	
			end
		end
		return highest_scored_hit
	end

	def highest_scored_hit_for_pep(peptide)
		highest_scored_hit = nil
		hits = []
		hits = protein_hits(peptide)
		score = 0
		hits.each do |hit|
			if hit.pep_score.to_f >= score
				score = hit.pep_score
				highest_scored_hit = hit	
			end
		end
		return highest_scored_hit
	end

	def each()
		@pep_index.each_key do |key|
			hits = []
			@pep_index[key].each do |hit_pos|
				hit = hit_from_pos(hit_pos)
				hits << hit
			end
			yield hits
		end
	end
	
	def each_hit()
		@pep_index.each_key do |key|
			@pep_index[key].each do |hit_pos|
				yield hit_from_pos(hit_pos)
			end
		end
	end

	def each_peptide()
		@pep_index.each_key do |key|
			yield key
		end
	end

	def has_peptide(peptide)
		if @pep_index.has_key?(peptide)
			return true
		else
			return false
		end
	end

	def hit_from_pos(hit_pos)
		@filehandle.pos = hit_pos
		hit = line_parse(@filehandle.readline)
		# hit.rank = @rank_index[hit_pos.to_s]
		return hit
	end

	def protein_hits(peptide)
		hits = []
		if !@pep_index.has_key?(peptide)
			return hits
		end
		@pep_index[peptide].each do |hit_pos|
			hit = hit_from_pos(hit_pos)
			hits << hit
		end
		return hits
	end

	def spectra_hits(peptide)
		spectra = []

		return spectra
	end
	
	def line_parse(line)
		(score, e_value, mh, matched_peaks, matched_intensity, pep_seq, miss_cleave, proteins, protein_ids, prev_next_aa, pro_start_pos, modify_pos, modify_name, mod_site, delta_mass) = line.chomp.split("|")
		return ProteinHit.new(score, e_value, mh, matched_peaks, matched_intensity, pep_seq, miss_cleave, proteins, protein_ids, prev_next_aa, pro_start_pos, modify_pos, modify_name, mod_site, delta_mass)
	end

end

