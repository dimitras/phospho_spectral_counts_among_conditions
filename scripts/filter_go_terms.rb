# USAGE:
# ruby filter_go_terms.rb ../results/GO_tables.xlsx ../results/GO_tables_filtered.xlsx

# retrieve genes from the protein description, keep only unique proteins

require 'rubygems'
require 'rubyXL'
require 'axlsx'

ifile = ARGV[0]
ofile = ARGV[1]

# initialize arguments
workbook = RubyXL::Parser.parse(ifile)

go_terms_list = {
	"actomyosin" => "Cytoskeleton",
	"stress fiber" => "Cytoskeleton",
	"actin" => "Cytoskeleton",
	"microtubule" => "Cytoskeleton",
	"myosin" => "Cytoskeleton",
	"cytoskeleton" => "Cytoskeleton",
	"cell-cell adhesion" => "Adhesion",
	"cell-matrix adhesion" => "Adhesion",
	"cell adhesion" => "Adhesion",
	"focal adhesion" => "Adhesion",
	"cell-cell contact" => "Adhesion",
	"cell-subrstate junction" => "Adhesion",
	"adherens junction" => "Adhesion",
	"adhesion" => "Adhesion",
	"motility" => "Migration",
	"lamellopodium" => "Migration",
	"ruffle" => "Migration",
	"migration" => "Migration",
	"cell-matrix adhesion" => "Matrix",
	"extracellular matrix" => "Matrix",
	"matrix" => "Matrix",
	"cell cycle" => "Proliferation",
	"cell proliferation" => "Proliferation",
	"cell division" => "Proliferation",
	"proliferation" => "Proliferation"
}


# read the lists (format: Term	Overlap	P-value	Adjusted P-value	Z-score	Combined Score	Genes)
bio_diff_list = Hash.new { |h,k| h[k] = [] }
worksheet1 = workbook[0]
array1 = worksheet1.extract_data
array1.each do |row|
	if (!row[0].include? "Term")
		go_terms_list.each_key do |term|
			if row[0].include?(term)
				row_updated = row << go_terms_list[term]
				bio_diff_list[row[0]] = row_updated
			end
		end	
	end
end

cell_diff_list = Hash.new { |h,k| h[k] = [] }
worksheet2 = workbook[1]
array2 = worksheet2.extract_data
array2.each do |row|
	if (!row[0].include? "Term")
		go_terms_list.each_key do |term|
			if row[0].include?(term)
				row_updated = row << go_terms_list[term]
				cell_diff_list[row[0]] = row_updated
			end
		end	
	end
end

bio_rat_list = Hash.new { |h,k| h[k] = [] }
worksheet3 = workbook[2]
array3 = worksheet3.extract_data
array3.each do |row|
	if (!row[0].include? "Term")
		go_terms_list.each_key do |term|
			if row[0].include?(term)
				row_updated = row << go_terms_list[term]
				bio_rat_list[row[0]] = row_updated
			end
		end	
	end
end

cell_rat_list = Hash.new { |h,k| h[k] = [] }
worksheet4 = workbook[3]
array4 = worksheet4.extract_data
array4.each do |row|
	if (!row[0].include? "Term")
		go_terms_list.each_key do |term|
			if row[0].include?(term)
				row_updated = row << go_terms_list[term]
				cell_rat_list[row[0]] = row_updated
			end
		end	
	end
end


# output
results_xlsx = Axlsx::Package.new
results_wb = results_xlsx.workbook

# create sheet
results_wb.add_worksheet(:name => "GO_Biological_Process_dif>=2") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Term","P-value","Adjusted P-value","Z-score","Combined Score","Genes","GO-Category"], :style => title
	bio_diff_list.each_key do |group_term|
		term = bio_diff_list[group_term][0]
		pvalue = bio_diff_list[group_term][2]
		adj_pvalue = bio_diff_list[group_term][3]
		zscore = bio_diff_list[group_term][4]
		comb_zscore = bio_diff_list[group_term][5]
		genes = bio_diff_list[group_term][6]
		go_category = bio_diff_list[group_term][7]
		row = sheet.add_row [term, pvalue, adj_pvalue, zscore, comb_zscore, genes, go_category]
	end
end

results_wb.add_worksheet(:name => "GO_Cellular_Component_dif>=2") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Term","P-value","Adjusted P-value","Z-score","Combined Score","Genes","GO-Category"], :style => title
	cell_diff_list.each_key do |group_term|
		term = cell_diff_list[group_term][0]
		pvalue = cell_diff_list[group_term][2]
		adj_pvalue = cell_diff_list[group_term][3]
		zscore = cell_diff_list[group_term][4]
		comb_zscore = cell_diff_list[group_term][5]
		genes = cell_diff_list[group_term][6]
		go_category = cell_diff_list[group_term][7]
		row = sheet.add_row [term, pvalue, adj_pvalue, zscore, comb_zscore, genes, go_category]
	end
end

results_wb.add_worksheet(:name => "GO_Biological_Process_rat>=1.5") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Term","P-value","Adjusted P-value","Z-score","Combined Score","Genes","GO-Category"], :style => title
	bio_rat_list.each_key do |group_term|
		term = bio_rat_list[group_term][0]
		pvalue = bio_rat_list[group_term][2]
		adj_pvalue = bio_rat_list[group_term][3]
		zscore = bio_rat_list[group_term][4]
		comb_zscore = bio_rat_list[group_term][5]
		genes = bio_rat_list[group_term][6]
		go_category = bio_rat_list[group_term][7]
		row = sheet.add_row [term, pvalue, adj_pvalue, zscore, comb_zscore, genes, go_category]
	end
end

results_wb.add_worksheet(:name => "GO_Cellular_Component_rat>=1.5") do |sheet|
	title = results_wb.styles.add_style(:b => true)
	sheet.add_row ["Term","P-value","Adjusted P-value","Z-score","Combined Score","Genes","GO-Category"], :style => title
	cell_rat_list.each_key do |group_term|
		term = cell_rat_list[group_term][0]
		pvalue = cell_rat_list[group_term][2]
		adj_pvalue = cell_rat_list[group_term][3]
		zscore = cell_rat_list[group_term][4]
		comb_zscore = cell_rat_list[group_term][5]
		genes = cell_rat_list[group_term][6]
		go_category = cell_rat_list[group_term][7]
		row = sheet.add_row [term, pvalue, adj_pvalue, zscore, comb_zscore, genes, go_category]
	end
end

# write xlsx file
results_xlsx.serialize(ofile)

