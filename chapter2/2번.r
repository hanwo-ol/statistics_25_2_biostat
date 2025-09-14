#install.packages("psych")
library(psych)
library(ggplot2)

# 데이터 입력
lymphocyte <- c(9.0, 9.4, 4.7, 4.8, 8.9, 4.9, 8.4, 5.9, 6.3, 5.7,
                5.0, 3.5, 7.8, 10.4, 8.0, 8.0, 8.6, 7.0, 6.8, 7.1,
                5.7, 7.6, 6.2, 7.1, 7.4, 8.7, 4.9, 7.4, 6.4, 7.1,
                6.3, 8.8, 8.8, 5.2, 7.1, 5.3, 4.7, 6.4, 8.4, 8.3)

tumor_cell <- c(12.6, 14.6, 16.2, 23.9, 23.3, 17.1, 20.0, 21.0, 19.1, 19.4,
                16.7, 15.9, 15.8, 16.0, 17.9, 13.4, 19.1, 16.6, 18.9, 18.7,
                20.0, 17.8, 13.9, 22.1, 13.9, 18.3, 22.8, 13.0, 17.9, 15.2,
                17.7, 15.1, 16.9, 16.4, 22.8, 19.4, 19.6, 18.4, 18.2, 20.7)

# 기술 통계 분석을 위한 데이터 프레임 생성
value <- c(lymphocyte, tumor_cell)
group <- factor(rep(c("lymphocyte", "tumor_cell"), each = 40))
melanoma_data <- data.frame(group, value)

# psych::describeBy를 이용한 기술 통계치 산출
desc_stats <- describeBy(melanoma_data$value, group = melanoma_data$group)
print(desc_stats)

ggplot(melanoma_data, aes(x = group, y = value, fill = group)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Comparison of Diameters between Lymphocytes and Tumor Cells",
    x = "Cell Type",
    y = "Diameter (nm)"
  ) +
  theme_classic() + scale_fill_grey(start = 0.8, end = 0.5) +

  ylim(0, 30) +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.title = element_text(size = 12)
  )


# 5. Welch's t-test 수행
# H1: lymphocyte < tumor_cell 이므로 alternative="less"
t_test_result <- t.test(lymphocyte, tumor_cell, 
                        alternative = "less", 
                        var.equal = FALSE) # Welch's t-test

print(t_test_result)
