# H0: 두 집단의 모분산은 동일하다 (sigma_old^2 = sigma_new^2)
# H1: 두 집단의 모분산은 동일하지 않다 (sigma_old^2 != sigma_new^2)

# 유의수준(alpha) 사전 설정
alpha <- 0.05

old_fertilizer <- c(48.2, 54.6, 58.3, 47.8, 51.4, 52.0, 55.2, 49.1, 49.9, 52.6)
new_fertilizer <- c(52.3, 57.4, 55.6, 53.2, 61.3, 58.0, 59.8, 54.8, 51.2, 46.2)

df <- data.frame(
  height = c(old_fertilizer, new_fertilizer),
  fertilizer_type = factor(
    rep(c("Old", "New"), each = 10),
    levels = c("Old", "New") # 순서 지정
  )
)

#install.packages("psych")
library(psych)
library(ggplot2)

descriptive_stats <- describeBy(height ~ fertilizer_type, data = df)
print(descriptive_stats)

df <- data.frame(
  height = c(old_fertilizer, new_fertilizer),
  fertilizer_type = factor(
    rep(c("Old", "New"), each = 10),
    levels = c("Old", "New")
  )
)


boxplot_gg <- ggplot(df, aes(x = fertilizer_type, y = height, fill = fertilizer_type)) +
  geom_boxplot(alpha = 0.8) +         
  stat_summary(fun = mean, geom = "point", shape = 4, size = 3, color = "black") + 
  scale_fill_grey(start = 0.8, end = 0.5) + 
  
  ylim(35, 70) +
  
  theme_classic() +               
  
  labs(        
    title = "Distribution of Plant Height by Fertilizer Type",
    x = "Fertilizer Type",
    y = "Height (cm)"
  ) +
  
  theme(
    legend.position = "none", 
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14), 
    axis.title = element_text(size = 12) 
  )

print(boxplot_gg)

s_old_sq <- var(old_fertilizer)
s_new_sq <- var(new_fertilizer)
n_old <- length(old_fertilizer)
n_new <- length(new_fertilizer)

cat(paste("  - 표본 크기(n_old):", n_old, "\n"))
cat(paste("  - 표본 분산(s_old^2):", round(s_old_sq, 4), "\n\n"))
cat(paste("  - 표본 크기(n_new):", n_new, "\n"))
cat(paste("  - 표본 분산(s_new^2):", round(s_new_sq, 4), "\n\n"))


if (s_new_sq > s_old_sq) {
  F_statistic <- s_new_sq / s_old_sq
  df_num <- n_new - 1 # 분자의 자유도
  df_den <- n_old - 1 # 분모의 자유도
  cat("F-통계량 계산: s_new^2 / s_old^2\n")
} else {
  F_statistic <- s_old_sq / s_new_sq
  df_num <- n_old - 1 # 분자의 자유도
  df_den <- n_new - 1 # 분모의 자유도
  cat("F-통계량 계산: s_old^2 / s_new^2\n")
}

p_value <- 2 * pf(F_statistic, df1 = df_num, df2 = df_den, lower.tail = FALSE)

cat(paste("F-통계량:", round(F_statistic, 3), "\n"))
cat(paste("자유도 (분자, 분모):", df_num, ",", df_den, "\n"))
cat(paste("유의확률 (p-value):", round(p_value, 4), "\n"))


if (p_value < alpha) {
  cat(paste0("유의확률(p-value) ", round(p_value, 4), "은(는) 유의수준 ", alpha, "보다 작으므로, 귀무가설을 기각합니다.\n"))
  cat("결론: 기존 비료와 새로운 비료에 따른 식물 성장의 분산은 통계적으로 유의미한 차이가 있습니다.\n")
} else {
  cat(paste0("유의확률(p-value) ", round(p_value, 4), "은(는) 유의수준 ", alpha, "보다 크거나 같으므로, 귀무가설을 기각할 수 없습니다.\n"))
  cat("결론: 기존 비료와 새로운 비료에 따른 식물 성장의 분산이 통계적으로 유의미하게 다르다고 할 수 없습니다. (등분산성 가정 만족)\n")
}

# 검증)))) R 내장 함수 var.test() 결과와 비교해봐도 동일한 결론을 얻을 수 있음.
cat("\n\n--- 참고: R 내장 함수 var.test() 결과와 비교 ---\n")
print(var.test(new_fertilizer, old_fertilizer))
