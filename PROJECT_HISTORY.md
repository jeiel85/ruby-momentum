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
  - `.github/workflows/ci.yml`: 
    - `bundler-cache: true` 제거 및 수동 `bundle install` 방식으로 변경 (Gemfile.lock 불일치로 인한 frozen mode 에러 해결)
    - `bin/` 디렉토리 내 실행 파일들에 대한 실행 권한 부여 (`git update-index --chmod=+x`)
    - 테스트 실행 전 `db:migrate`를 명시적으로 실행하도록 수정 (구버전 schema.rb로 인한 마이그레이션 누락 방지)
- 스타일 및 린트 이슈 수정:
  - 여러 컨트롤러 파일 끝에 개행 추가
  - `Gemfile` 및 컨트롤러 내 배열 대괄호 공백 규칙 준수
  - `PostsController`: 불필요한 `return` 제거
  - `Users::OmniauthCallbacksController`: 문자열 따옴표 스타일 수정
- CI 최적화 및 최종 버그 수정:
  - `.github/workflows/ci.yml`: `system-test` 작업 제거 (테스트 코드 부재로 인한 실패 방지)
  - `app/models/post.rb`: `validates`를 `validate`로 수정하여 사용자 정의 유효성 검사 오류 해결
- 테스트 코드 및 데이터 보완:
  - `test/fixtures/posts.yml`: 포스트와 유저 간의 연결 정보 추가 (테스트 중 nil 에러 방지)
  - `test/controllers/posts_controller_test.rb`: Devise 테스트 헬퍼 추가 및 테스트 전 로그인 처리 (인증 추가에 따른 대응)
- 스타일 및 린트 이슈 최종 해결:
  - 모든 모델 및 컨트롤러 파일 끝에 개행 추가
  - `config/initializers/devise.rb`: 문자열 따옴표 및 배열 공백 규칙 준수
- UI 개선 및 기능 보완: 
  - `application.html.erb`: Stripe JS SDK 추가 및 네비게이션에 배지 포함 이름 표시
  - `_post.html.erb`: 실제 작성자 정보 표시
  - `index.html.erb`: 포스트 본인 여부에 따른 수정/팁 버튼 조건부 표시 로직 추가
- 실행 환경 최적화:
  - `bin/` 디렉토리 내의 모든 Ruby 스크립트에서 shebang 라인을 `#!/usr/bin/env ruby.exe`에서 `#!/usr/bin/env ruby`로 수정하여 호환성 확보

## 2026-04-22
- 코드 스타일 및 린트 오류 수정:
  - `Users::OmniauthCallbacksController`: `Style/StringLiterals` 준수를 위해 홑따옴표를 큰따옴표로 수정
  - `LikesController`, `CommentsController`, `BookmarksController`, `Admin::DashboardController`: 파일 끝에 누락된 줄 바꿈(newline) 추가
  - `CommentsController`, `Gemfile`: 배열 대괄호 내 공백 추가 (`Layout/SpaceInsideArrayBrackets` 준수)
- 모델 버그 수정:
  - `Post` 모델: `validates :validate_image`를 `validate :validate_image`로 수정하여 사용자 정의 유효성 검사 메서드가 올바르게 호출되도록 수정

## 2026-04-23
- 코드 스타일 및 린트 오류 수정:
  - `Like`, `Comment`, `Bookmark` 모델 파일 끝에 개행(newline) 추가
  - `Tips`, `Subscriptions`, `Reports`, `Comments` 컨트롤러 파일 끝에 개행(newline) 추가
  - `Report` 모델: 배열 대괄호 내 공백 추가 (`Layout/SpaceInsideArrayBrackets` 준수)
- 테스트 데이터 수정:
  - `test/fixtures/users.yml`: 유저 이메일 중복 방지를 위해 더 고유한 이메일 형식으로 업데이트

## 2026-05-13
- 문서 정리 및 로드맵 체계화:
  - `README.md` 주요 기능을 GitHub 이슈 기반 카테고리별로 재구성 (사용자 경험, 수익화, 보안/운영, 인프라, 마케팅)
  - OPEN 이슈(#6, #8, #9, #20)를 로드맵 테이블로 추가하여 진행 상황 추적 가능하도록 개선
  - `PROJECT_HISTORY.md`에 본 작업 내역 기록

## 2026-04-24
- 데이터베이스 스키마 변경:
  - `posts` 테이블에 `user_id` 외래 키 추가 (`AddUserToPosts` 마이그레이션)
- 코드 스타일 및 린트 오류 수정:
  - 지정된 모델 및 컨트롤러 파일 끝에 누락된 줄 바꿈(newline) 추가
  - `config/initializers/devise.rb`: 문자열 따옴표 스타일 수정 및 배열 대괄호 내 공백 추가
  - `app/models/user.rb`: 배열 대괄호 내 공백 추가
- CI/CD 및 빌드 자동화 상태 검토:
  - 현재 상태: `.github/workflows/ci.yml`을 통한 테스트, 린트, 보안 스캔 자동화 완료.
  - 개선 필요 사항: Docker 이미지 빌드 및 레지스트리(GHCR) Push 자동화 미비, Kamal/Render 배포 로직이 자리표시자 상태임.
  - 제안: 컨테이너 기반 배포를 위한 Docker 빌드 파이프라인 구축 및 실제 배포 스크립트 활성화 권장.
- CD 파이프라인(배포 자동화) 구축:
  - `config/deploy.yml`: Kamal 레지스트리를 `localhost:5555`에서 GitHub Container Registry(`ghcr.io`)로 변경하고 인증 방식 설정.
  - `.github/workflows/release.yml`: master 브랜치 푸시 시 `bin/kamal build --push`를 통해 Docker 이미지를 자동으로 빌드하고 GHCR에 푸시하도록 설정. (실제 서버 정보 및 SSH 키 세팅 시 자동 배포도 즉시 가능하도록 주석 처리된 배포 스크립트 포함)
