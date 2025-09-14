### psych (버전 2.5.6 기준으로 작성했음)

### `describeBy`: 그룹별 기본 요약 통계

#### **Description (설명)**

그룹화 변수(grouping variable)를 기준으로 기본 요약 통계를 보고합니다. 이 기능은 그룹화 변수가 특정 실험 변수이고, 데이터를 플롯(plotting)을 위해 집계해야 할 때 유용합니다. `by`와 `describe` 함수를 부분적으로 감싼 래퍼(wrapper) 함수입니다.

#### **Usage (사용법)**

```R
describeBy(x, group=NULL, mat=FALSE, type=3, digits=15, data, ...)
describe.by(x, group=NULL, mat=FALSE, type=3, ...) # 더 이상 사용되지 않음(deprecated) ################################
```

#### **Value (결과값)**

그룹별로 분류된 관련 통계치를 담은 data.frame입니다.

*   **item name**: 항목 이름
*   **item number**: 항목 번호
*   **number of valid cases**: 유효한 케이스 수
*   **mean**: 평균
*   **standard deviation**: 표준편차
*   **median**: 중앙값
*   **mad**: 중앙값 절대 편차 (중앙값 기준)
*   **minimum**: 최솟값
*   **maximum**: 최댓값
*   **skew**: 왜도 (비대칭도)
*   **standard error**: 표준오차

#### **Arguments (인수)**

*   **x**: `data.frame` 또는 `matrix`입니다. `statsBy` 함수의 참고사항을 확인하세요.
*   **group**: 그룹화 변수 또는 그룹화 변수들의 리스트입니다. (수식(formula) 모드로 함수를 호출하는 경우 무시될 수 있습니다.)
*   **mat**: 리스트(list) 대신 행렬(matrix) 형태로 결과를 출력합니다.
*   **type**: 계산할 왜도(skew)와 첨도(kurtosis)의 유형을 지정합니다.
*   **digits**: 행렬(matrix) 결과를 출력할 때, 몇 자리의 숫자로 보고할지를 지정합니다.
*   **data**: 수식(formula) 입력을 사용할 경우 필요합니다.
*   **...**: `describe` 함수로 전달될 파라미터들입니다.

#### **Author (작성자)**

William Revelle

#### **Details (세부 정보)**

`type` 파라미터는 계산할 왜도(skew)와 첨도(kurtosis)의 버전을 지정합니다. 더 자세한 정보는 `describe` 함수를 참고하세요.

대안 함수인 `statsBy`는 각 그룹의 평균, 개수(n), 표준편차를 리스트 형태로 반환합니다. 이 함수는 특히 `cor.wt` 함수를 사용하여 그룹 평균의 가중 상관관계(weighted correlations)를 찾을 때 유용합니다. 더 중요하게는, 상관관계를 그룹 내(within-group)와 그룹 간(between-group)으로 적절하게 분해합니다.

`cohen.d` 함수는 두 그룹에 대해 작동합니다. 이 함수는 데이터를 평균 차이로 변환하고 그룹 내 표준편차를 통합(pools)합니다. Cohen's d 통계량과 다변량 일반화 버전인 마할라노비스 거리(Mahalanobis D)를 반환합니다.

여러 다른 그룹화 변수에 대한 기술 통계를 얻으려면, `group` 인자가 리스트(list) 형태인지 확인해야 합니다. 여러 그룹화 변수와 함께 행렬(matrix) 결과를 출력하는 경우, 그룹화 변수의 값들이 결과물에 추가됩니다.

2020년 7월부터는 그룹화 변수를 수식(formula) 모드로 지정할 수 있습니다 (아래 예제 참고).

#### **Examples (예제)**

```R
# 예제 코드 실행하기 (Run this code)

data(sat.act)
describeBy(sat.act, sat.act$gender) # 그룹화 변수가 하나일 때
describeBy(sat.act ~ gender) # 전체 데이터셋에 대해 수식(formula)으로 입력
describeBy(SATV + SATQ ~ gender, data=sat.act) # 수식을 사용할 때 데이터셋 지정
#describeBy(sat.act, list(sat.act$gender, sat.act$education)) # 그룹화 변수가 두 개일 때 (리스트 사용)
describeBy(sat.act ~ gender + education) # 그룹화 변수가 두 개일 때 (수식 사용)
des.mat <- describeBy(age ~ education, mat=TRUE, data=sat.act) # 결과를 matrix(data.frame) 형태로 출력
des.mat <- describeBy(age ~ education + gender, data=sat.act, 
                      mat=TRUE, digits=2) # matrix 결과를 소수점 둘째 자리까지 반올림하여 출력
```
