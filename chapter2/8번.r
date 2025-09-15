# 유의수준(alpha) 설정
alpha <- 0.05

library(psych)
library(ggplot2)

# 데이터 벡터 생성
scores <- c(58, 62, 67, # 방법 1
            68, 70, 78, # 방법 2
            60, 65, 68, # 방법 3
            68, 80, 81, # 방법 4
            64, 69, 70) # 방법 5

# 독립변수(요인) 생성
method <- rep(paste0("method", 1:5), each = 3)
motiv <- rep(c("None", "Very Low", "Low"), times = 5)

# 데이터 프레임 생성
df <- data.frame(scores, method, motiv)

# 변수를 factor 형태로 변환
df$method <- as.factor(df$method)
df$motiv <- as.factor(df$motiv)

# 이원분산분석 모델링 (상호작용 항 없음)
# scores를 method와 motiv로 설명하는 모델
aov_model <- stats::aov(scores ~ method + motiv, data = df)

# 분산분석표(ANOVA table) 출력
summary(aov_model)

# Tukey의 HSD 다중비교 수행
tukey_result <- stats::TukeyHSD(aov_model)

# 다중비교 결과 출력
print(tukey_result)

# 'p adj' 열이 설정한 유의수준(alpha = 0.05)보다 작으면
# 해당 집단 쌍 간의 평균 차이가 통계적으로 유의하다고 해석한다.
