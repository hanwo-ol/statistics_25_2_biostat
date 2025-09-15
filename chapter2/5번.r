# 라이브러리 로드
library(psych)
library(dplyr)
library(tidyr)
library(ggplot2)

low_group <- c(22.2, 97.8, 29.1, 37.0, 35.8, 44.2, 82.0, 56.0, 9.3, 19.9, 39.5, 12.8)
medium_group <- c(15.1, 23.2, 10.5, 13.9, 9.7, 19.0, 19.8, 9.1, 30.1, 15.5, 10.3, 11.0)
high_group <- c(10.2, 11.3, 11.4, 5.3, 14.5, 11.0, 13.6, 33.4, 25.0, 27.0, 36.3, 17.7)

nk_data <- data.frame(
  value = c(low_group, medium_group, high_group),
  group = factor(rep(c("Low", "Medium", "High"), each = 12))
)

nk_data$group <- factor(nk_data$group, levels = c("Low", "Medium", "High"))

# 가설 검정의 기준이 되는 유의수준을 0.05로 설정
alpha <- 0.05

desc_stats <- psych::describeBy(nk_data$value, group = nk_data$group, mat = TRUE, digits = 2)

View(desc_stats)


boxplot_nk <- ggplot2::ggplot(nk_data, ggplot2::aes(x = group, y = value, fill = group)) +
  ggplot2::geom_boxplot(alpha = 0.8) +
  ggplot2::labs(
    title = "NK Cell Activity by Stress Group",
    x = "SRRS Stress Group",
    y = "NK Cell Activity"
  ) +
  ggplot2::scale_fill_grey(start = 0.9, end = 0.5) + 
  ggplot2::theme_minimal(base_size = 14) +
  ggplot2::theme(legend.position = "none") 

print(boxplot_nk)


anova_result <- stats::aov(value ~ group, data = nk_data)

summary_anova <- summary(anova_result)
print(summary_anova)

p_value <- summary_anova[[1]][["Pr(>F)"]][1]
###############################내장패키지 사용하지 않고 분산분석표 계산해보기

low_group <- c(22.2, 97.8, 29.1, 37.0, 35.8, 44.2, 82.0, 56.0, 9.3, 19.9, 39.5, 12.8)
medium_group <- c(15.1, 23.2, 10.5, 13.9, 9.7, 19.0, 19.8, 9.1, 30.1, 15.5, 10.3, 11.0)
high_group <- c(10.2, 11.3, 11.4, 5.3, 14.5, 11.0, 13.6, 33.4, 25.0, 27.0, 36.3, 17.7)

groups_list <- list(low = low_group, medium = medium_group, high = high_group)
all_data <- unlist(groups_list)

# 그룹의 수 (k)
k <- length(groups_list)

# 전체 관측치의 수 (N)
N <- length(all_data)

# 각 그룹의 관측치 수 (n_i)
group_sizes <- sapply(groups_list, length)

# 전체 데이터의 평균 (Grand Mean)
grand_mean <- mean(all_data)

# 각 그룹의 평균
group_means <- sapply(groups_list, mean)

# 처리(집단 간) 자유도: df_Tr = k - 1
df_treatment <- k - 1

# 오차(집단 내) 자유도: df_E = N - k
df_error <- N - k

# 총 자유도: df_T = N - 1
df_total <- N - 1

# 처리제곱합 (SSTr): 각 그룹 평균과 전체 평균의 차이를 제곱한 값의 가중합
ss_treatment <- sum(group_sizes * (group_means - grand_mean)^2)

# 오차제곱합 (SSE): 각 그룹 내에서 관측치와 해당 그룹 평균의 차이를 제곱한 값의 합
ss_error <- sum(sapply(1:k, function(i) {
  sum((groups_list[[i]] - group_means[i])^2)
}))

# 총제곱합 (SST): 모든 관측치와 전체 평균의 차이를 제곱한 값의 합
ss_total <- sum((all_data - grand_mean)^2)

# 처리평균제곱 (MSTr): MSTr = SSTr / df_Tr
ms_treatment <- ss_treatment / df_treatment

# 오차평균제곱 (MSE): MSE = SSE / df_E
ms_error <- ss_error / df_error

f_value <- ms_treatment / ms_error


p_value <- pf(f_value, df_treatment, df_error, lower.tail = FALSE)

anova_table <- data.frame(
  "Df" = c(df_treatment, df_error, df_total),
  "Sum Sq" = c(ss_treatment, ss_error, ss_total),
  "Mean Sq" = c(ms_treatment, ms_error, NA),
  "F value" = c(f_value, NA, NA),
  "Pr(>F)" = c(p_value, NA, NA)
)

rownames(anova_table) <- c("Treatment (Group)", "Error (Residuals)", "Total")

print(format(anova_table, digits = 4, nsmall = 4))




##################등분산 체크#
low_group <- c(22.2, 97.8, 29.1, 37.0, 35.8, 44.2, 82.0, 56.0, 9.3, 19.9, 39.5, 12.8)
medium_group <- c(15.1, 23.2, 10.5, 13.9, 9.7, 19.0, 19.8, 9.1, 30.1, 15.5, 10.3, 11.0)
high_group <- c(10.2, 11.3, 11.4, 5.3, 14.5, 11.0, 13.6, 33.4, 25.0, 27.0, 36.3, 17.7)

nk_data <- data.frame(
  value = c(low_group, medium_group, high_group),
  group = factor(rep(c("Low", "Medium", "High"), each = 12))
)

levene_test_result <- car::leveneTest(value ~ group, data = nk_data)
print(levene_test_result)


alpha <- 0.05
p_value_levene <- levene_test_result$`Pr(>F)`[1]

if (p_value_levene > alpha) {
  cat("결과: 유의확률이 유의수준보다 큽니다 (p > 0.05).\n")
  cat("따라서 '그룹 간 분산이 같다'는 귀무가설을 기각할 수 없습니다.\n")
  cat("결론: 등분산성 가정이 충족되었으므로, 분산분석(ANOVA) 결과를 신뢰할 수 있습니다.\n")
} else {
  cat("결과: 유의확률이 유의수준보다 작습니다 (p <= 0.05).\n")
  cat("따라서 '그룹 간 분산이 같다'는 귀무가설을 기각합니다.\n")
  cat("결론: 등분산성 가정이 위배되었으므로, Welch's ANOVA와 같은 대안적인 분석 방법을 고려해야 합니다.\n")
}
