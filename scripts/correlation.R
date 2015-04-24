# R --vanilla < correlation.R

##### SOFT
# # read file
# peptides <- read.csv("../results/correlation_for_soft.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_soft.pdf")
# plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft condition")
# abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# # pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# # symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
# dev.off()


##### STIFF
# # read file
# peptides <- read.csv("../results/correlation_for_stiff.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_stiff.pdf")
# plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff condition")
# abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
# dev.off()


##### SOFT ONLY
# # read file
# peptides <- read.csv("../results/correlation_for_soft_only.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_soft_only.pdf")
# plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft-only condition")
# abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# # pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# # symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
# dev.off()


##### STIFF ONLY
# # read file
# peptides <- read.csv("../results/correlation_for_stiff_only.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_stiff_only.pdf")
# plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff-only condition")
# abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
# dev.off()


##### FILTERED

##### SOFT
# # read file
# peptides <- read.csv("../results/correlation_for_soft_filtered.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_soft_filtered.pdf")
# plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft condition")
# abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# # pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# # symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
# dev.off()


##### STIFF
# # read file
# peptides <- read.csv("../results/correlation_for_stiff_filtered.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_stiff_filtered.pdf")
# plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff condition")
# abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
# dev.off()


##### SOFT ONLY
# # read file
# peptides <- read.csv("../results/correlation_for_soft_only_filtered.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_soft_only_filtered.pdf")
# plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft-only condition")
# abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# # pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# # symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
# dev.off()


##### STIFF ONLY
# # read file
# peptides <- read.csv("../results/correlation_for_stiff_only_filtered.csv", header=T, sep=",")

# # attach to variables
# attach(peptides)

# # correlation
# cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# # plot
# pdf("../results/correlation_for_stiff_only_filtered.pdf")
# plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff-only condition")
# abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
# dev.off()




##### SHORTENED

##### SOFT
read file
peptides <- read.csv("../results/correlation_for_soft_shortened.csv", header=T, sep=",")

# attach to variables
attach(peptides)

# correlation
cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# plot
pdf("../results/correlation_for_soft_shortened.pdf")
plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft condition")
abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
dev.off()


##### STIFF
# read file
peptides <- read.csv("../results/correlation_for_stiff_shortened.csv", header=T, sep=",")

# attach to variables
attach(peptides)

# correlation
cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# plot
pdf("../results/correlation_for_stiff_shortened.pdf")
plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff condition")
abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
dev.off()


#### SOFT ONLY
# read file
peptides <- read.csv("../results/correlation_for_soft_only_shortened.csv", header=T, sep=",")

# attach to variables
attach(peptides)

# correlation
cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete")

# plot
pdf("../results/correlation_for_soft_only_shortened.pdf")
plot(soft_b1_count, soft_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for soft-only condition")
abline(lm(soft_b2_count ~ soft_b1_count), col="blue")
# pairs(~soft_b1_count + soft_b2_count, data=peptides, main="correlation b1-b2")
# symnum(clS <- cor(soft_b1_count, soft_b2_count, method="spearman", use = "complete"))
dev.off()


#### STIFF ONLY
# read file
peptides <- read.csv("../results/correlation_for_stiff_only_shortened.csv", header=T, sep=",")

# attach to variables
attach(peptides)

# correlation
cor(stiff_b1_count, stiff_b2_count, method="spearman", use = "complete")

# plot
pdf("../results/correlation_for_stiff_only_shortened.pdf")
plot(stiff_b1_count, stiff_b2_count, xlab="b1_count", ylab="b2_count", pch=21, main="correlation for stiff-only condition")
abline(lm(stiff_b2_count ~ stiff_b1_count), col="blue")
dev.off()