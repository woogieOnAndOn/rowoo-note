# 실행 전 세팅
## 필요한 Secrets
* ACCOUNT_ID
* AWS_ROLE_ARN

## 1. aws 자격 증명 공급자 추가
* 공급자 유형 = OpenID Connect
* 공급자 URL = https://token.actions.githubusercontent.com
* 대상 = sts.amazonaws.com

## 2. aws 역할 추가
* 신뢰할 수 있는 엔터티 유형 = 웹 자격 증명
* 자격 증명 공급자 = token.actions.githubusercontent.com
* Audience = sts.amazonaws.com
* 권한 정책 = AdministratorAccess
* 신뢰할 수 있는 엔터티 선택에서 **token.actions.githubusercontent.com:aud**에 `"token.actions.githubusercontent.com:sub": "repo:<your_github_account>/<your_repository_name>:*"` 추가

## 3. github repository secrets 추가
* 위 단계에서 생성된 역할의 ARN을 **AWS_ROLE_ARN**으로 등록
* aws 계정의 account id를 **ACCOUNT_ID**로 등록
