# 프로젝트 이력 관리

## 2026-04-21
- 프로젝트 분석 및 CI 에러 조사 시작
- `.github/workflows/ci.yml` 분석: Brakeman, Bundler Audit, RuboCop, Unit Test, System Test 수행 확인
- 주요 버그 및 스타일 위반 사항 수정:
  - `User` 모델: 중복된 `devise :validatable` 제거
  - `SubscriptionsController`: 
    - 스트라이프 세션 생성 시 `user_id` 메타데이터 추가
    - 웹훅 처리 로직에서 메타데이터를 이용한 유저 조회 방식으로 수정 (기존 버그 해결)
  - `CreateTips` 마이그레이션: `recipient_id` 중복 인덱스 제거
  - `Tip` 모델: `USD` 메서드를 `usd`로 변경 (스타일 가이드 준수)
  - `PostsController`:
    - `before_action :authenticate_user!` 추가 (보안 강화)
    - 포스트 생성 시 `current_user`와 연동하도록 수정 (필수 필드 누락 버그 해결)
    - 포스트 수정/삭제 시 본인 확인 로직 추가 (보안 강화)
    - `index` 액션에서 최신 포스트 순으로 정렬하도록 수정
- CI 설정 수정:
  - `.github/workflows/ci.yml`: `bundler-cache: true` 제거 및 수동 `bundle install` 방식으로 변경 (Gemfile.lock 불일치로 인한 frozen mode 에러 해결)
- UI 개선 및 기능 보완: 
  - `application.html.erb`: Stripe JS SDK 추가 및 네비게이션에 배지 포함 이름 표시
  - `_post.html.erb`: 실제 작성자 정보 표시
  - `index.html.erb`: 포스트 본인 여부에 따른 수정/팁 버튼 조건부 표시 로직 추가
