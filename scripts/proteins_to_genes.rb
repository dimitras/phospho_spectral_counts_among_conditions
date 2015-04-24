# USAGE:
# ruby proteins_to_genes.rb ../results/filt-by_both-exps_same-cond_with-count-difs-n-ratios_.xlsx ../results/genes_lists.xlsx

# retrieve genes from the protein description, keep only unique proteins

require 'rubygems'
require 'rubyXL'
require 'axlsx'

ifile = ARGV[0]
ofile = ARGV[1]

# initialize arguments
workbook = RubyXL::Parser.parse(ifile)

# read the lists (format: prot_acc	prot_desc	pep_score	pep_expect	pep_seq)
unique_list = Hash.new { |h,k| h[k] = [] }
worksheet = workbook[0]
array = worksheet.extract_data
array.each do |row|
	if (!row[0].include? "Filtered") && (!row[1].include? "Peptide")
		if !unique_list.has_key?(row[0]) && !unique_list.has_key?(row[1])
			if row[2].include? "GN="
				genename = row[2].split("GN=")[1].split(" ")[0].to_s
				row_updated = row << genename
				unique_list[row[1]] = row_updated
			end
		end
	end
end

unique_list2 = Hash.new { |h,k| h[k] = [] }
worksheet2 = workbook[3]
array2 = worksheet2.extract_data
array2.each do |row|
	if (!row[0].include? "Filtered") && (!row[1].include? "Peptide")
		if !unique_list2.has_key?(row[0]) && !unique_list2.has_key?(row[1])
			if row[2].include? "GN="
				genename = row[2].split("GN=")[1].split(" ")[0].to_s
				row_updated = row << genename
				unique_list2[row[1]] = row_updated
			end
		end
	end
end


# output
results_xlsx = Axlsx::Package.new
results_wb = results_xlsx.workbook

# create sheet
results_wb.add_worksheet(:name => "genes list, by dif>=2") do |sheet|
	sheet.add_row ["pep_seq", "prot_acc", "prot_desc", "genename"]
	unique_list.each_key do |prot|
		pep_seq = unique_list[prot][0]
		prot_acc = unique_list[prot][1]
		prot_desc = unique_list[prot][2]
		genename = unique_list[prot][10]
		row = sheet.add_row [pep_seq, prot_acc, prot_desc, genename]
	end
end

results_wb.add_worksheet(:name => "genes list, by mod.ratio>=1.5") do |sheet|
	sheet.add_row ["pep_seq", "prot_acc", "prot_desc", "genename"]
	unique_list2.each_key do |prot|
		pep_seq = unique_list2[prot][0]
		prot_acc = unique_list2[prot][1]
		prot_desc = unique_list2[prot][2]
		genename = unique_list2[prot][10]
		row = sheet.add_row [pep_seq, prot_acc, prot_desc, genename]
	end
end

# write xlsx file
results_xlsx.serialize(ofile)

