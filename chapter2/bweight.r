bweight_data <- read.csv("C:/Users/11015/Downloads/bweight.csv")
bweight_data$MomSmoke <- factor(bweight_data$MomSmoke, labels = c("N", "S"))
bweight_data$MomEdLevel <- factor(bweight_data$MomEdLevel)

summary(bweight_data[, c("Weight", "MomWtGain")])
table(bweight_data$MomSmoke)
table(bweight_data$MomEdLevel)
library(ggplot2)

ggplot(bweight_data, aes(x = MomSmoke, y = Weight)) +
  geom_boxplot(fill = "grey80", color = "black") +
  facet_wrap(~ MomEdLevel, labeller = label_both) + 
  labs(
    title = "어머니 교육 수준 및 흡연 여부에 따른 신생아 체중",
    x = "어머니 흡연 여부",
    y = "신생아 체중 (g)"
  ) +
  theme_bw() # 흑백 테마

ggplot(bweight_data, aes(x = MomEdLevel, y = Weight)) +
  geom_boxplot(fill = "grey80", color = "black") +
  facet_wrap(~ MomSmoke, labeller = label_both) + 
  labs(
    title = "어머니 교육 수준 및 흡연 여부에 따른 신생아 체중",
    x = "어머니 흡연 여부",
    y = "신생아 체중 (g)"
  ) +
  theme_bw() # 흑백 테마


# 이원분산분석(Two-Way ANOVA) 모델링
aov_result <- aov(Weight ~ MomSmoke * MomEdLevel, data = bweight_data)
summary(aov_result)

tukey_edlevel <- TukeyHSD(aov_result, which = "MomEdLevel")
print(tukey_edlevel)

bweight_data$Group <- interaction(bweight_data$MomSmoke, bweight_data$MomEdLevel, sep = ":")

aov_interaction <- aov(Weight ~ Group, data = bweight_data)

tukey_interaction_correct <- TukeyHSD(aov_interaction)

print(tukey_interaction_correct) 
interaction.plot(
  x.factor = bweight_data$MomEdLevel,
  trace.factor = bweight_data$MomSmoke,
  response = bweight_data$Weight,
  fun = mean, type = "b", col = c("blue", "red"), pch = c(19, 17), lwd = 2,
  main = "Interaction Plot", xlab = "Mother's Education Level", ylab = "Mean Newborn Weight (g)"
)


ggplot(bweight_data, aes(x = MomWtGain, y = Weight)) +
  geom_point(alpha = 0.1) +  
  geom_smooth(method = "lm", color = "blue") + 
  labs(
    title = "임신 중 체중 증가와 신생아 체중의 관계",
    x = "어머니 체중 증가량 (lbs)",
    y = "신생아 체중 (g)"
  ) +
  theme_minimal()

# 2. 상관계수 계산
cor(bweight_data$MomWtGain, bweight_data$Weight)



ggplot(bweight_data, aes(x = MomWtGain, y = Weight, color = MomSmoke)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", se = FALSE) + # 그룹별 회귀선 (se=FALSE는 신뢰구간 제거)
  labs(
    title = "흡연 여부에 따른 '체중증가-신생아체중' 관계 비교",
    x = "어머니 체중 증가량 (lbs)",
    y = "신생아 체중 (g)"
  ) +
  theme_minimal()

# 비흡연 그룹
lm_nonsmoker <- lm(Weight ~ MomWtGain, data = subset(bweight_data, MomSmoke == "N"))
summary(lm_nonsmoker)

# 흡연 그룹
lm_smoker <- lm(Weight ~ MomWtGain, data = subset(bweight_data, MomSmoke == "S"))
summary(lm_smoker)
