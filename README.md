# Ruby Momentum

Google OAuth 인증, 실시간 업데이트, 이미지 업로드를 지원하는 Ruby on Rails 소셜 포스팅 애플리케이션입니다.

## 🚀 데모

- **랜딩 페이지** (GitHub Pages): https://jeiel85.github.io/ruby-momentum/
- **Live Demo** (Render): https://ruby-momentum.onrender.com *(Render 무료 티어 — 첫 접속 시 ~30초 콜드스타트 가능)*

> 두 링크 모두 실제 배포가 완료된 후 활성화됩니다. 배포 가이드는 아래 [Render 배포](#render-배포) 섹션 참고.

## 주요 기능

### 사용자 경험
- **Google 소셜 로그인** — Devise + OmniAuth를 통한 Google 계정 로그인
- **포스트 관리** — 이미지 첨부가 가능한 게시글 작성, 조회, 수정, 삭제
- **실시간 업데이트** — ActionCable(Hotwire Turbo Streams)을 통해 새 게시글 및 댓글 즉시 반영
- **소셜 상호작용** — 좋아요, 북마크, 실시간 댓글 (#7)

### 수익화
- **프리미엄 구독** — Stripe 연동 월간/연간 멤버십 (#10, #19)
- **크리에이터 후원** — 게시글별 소액 후원(Tips) 기능 (#19)

### 보안 및 운영
- **Rate Limiting** — Rack::Attack 기반 무차별 대입 및 도배 방어 (#12)
- **파일 업로드 보안** — 악성 스크립트 차단 및 확장자/용량 검증 (#14)
- **콘텐츠 신고** — 부적절한 컨텐츠 사용자 신고 및 관리자 리뷰 (#13)
- **관리자 백오피스** — ActiveAdmin 기반 유저/게시글 관리 대시보드 (#16)

### 인프라
- **클라우드 스토리지** — AWS S3 / CloudFront CDN을 통한 이미지 제공 (#15)
- **백그라운드 Job** — 이미지 리사이징 등 무거운 작업 비동기 처리 (#21)
- **CI/CD 파이프라인** — GitHub Actions 기반 테스트/린트/보안 스캔 및 Docker 빌드 자동화
- **프로덕션 배포** — Docker + Kamal 배포 지원

### 마케팅 / 성장
- **SEO 최적화** — 메타 태그, Open Graph, 동적 사이트맵 (#3, #17)
- **소셜 공유** — 게시글 SNS 공유 버튼 및 링크 복사 (#5)
- **사용자 분석** — Google Analytics / Plausible 연동 (#4)

## 🗺 로드맵

| 이슈 | 작업 내용 | 상태 |
|------|----------|:----:|
| [#6](https://github.com/jeiel85/ruby-momentum/issues/6) | 프로필 관리 시스템 — 닉네임, 소개글, 아바타 편집 | ⬜ |
| [#8](https://github.com/jeiel85/ruby-momentum/issues/8) | 통합 알림 시스템 — In-app + Email 알림 | ⬜ |
| [#9](https://github.com/jeiel85/ruby-momentum/issues/9) | 포스트 검색 및 해시태그 분류 — 전문 검색 | ⬜ |
| [#20](https://github.com/jeiel85/ruby-momentum/issues/20) | 보안 고도화 — CSP, 의존성 취약점 스캔 | ⬜ |

## 기술 스택

| 구분 | 기술 |
|------|------|
| 프레임워크 | Ruby on Rails 8.1 |
| 언어 | Ruby 3.4.9 |
| 인증 | Devise + OmniAuth Google OAuth2 |
| 결제 | Stripe API |
| 프론트엔드 | Hotwire (Turbo + Stimulus) + Tailwind CSS |
| 데이터베이스 | PostgreSQL (운영) / SQLite (개발) |
| 파일 저장소 | Active Storage (Local / S3 / R2) |
| 실시간 통신 | ActionCable |
| 배포 | Kamal / Docker |

## 시작하기

### 사전 요구사항

- Ruby 3.4.9
- Bundler
- SQLite3 (개발 환경)
- Google OAuth2 클라이언트 ID 및 시크릿
- Stripe API 키 (결제 기능 사용 시)

### 설치 및 실행

```bash
# 저장소 클론
git clone https://github.com/jeiel85/ruby-momentum.git
cd ruby-momentum

# 의존성 설치
bundle install

# 환경변수 설정
cp .env.example .env
# .env 파일을 열어 필요한 정보를 입력하세요.

# 데이터베이스 생성 및 마이그레이션
rails db:create db:migrate db:seed

# 개발 서버 실행
bin/dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000)에 접속하세요.

## 환경변수

| 변수명 | 설명 |
|--------|------|
| `GOOGLE_CLIENT_ID` | Google OAuth2 클라이언트 ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth2 클라이언트 시크릿 |
| `STRIPE_PUBLISHABLE_KEY` | Stripe 공개 키 |
| `STRIPE_SECRET_KEY` | Stripe 비밀 키 |
| `STRIPE_WEBHOOK_SECRET` | Stripe 웹훅 서명 시크릿 |
| `STRIPE_PREMIUM_MONTHLY_PRICE_ID` | 프리미엄 월간 구독 상품 ID |
| `STRIPE_PREMIUM_YEARLY_PRICE_ID` | 프리미엄 연간 구독 상품 ID |
| `ACTIVE_STORAGE_SERVICE` | 스토리지 서비스 (local, amazon, r2) |
| `DATABASE_URL` | PostgreSQL 연결 URL (운영 환경) |
| `SECRET_KEY_BASE` | Rails 시크릿 키 (운영 환경) |

## 프로젝트 구조

```
app/
├── controllers/
│   ├── posts_controller.rb                      # 게시글 CRUD
│   └── users/
│       └── omniauth_callbacks_controller.rb     # Google OAuth 콜백 처리
├── models/
│   ├── user.rb                                  # Devise + Google OmniAuth
│   └── post.rb                                  # 게시글 (이미지 첨부 + Turbo 브로드캐스트)
└── views/
    └── posts/                                   # 게시글 뷰
```

## Render 배포

이 앱은 Render 배포를 위해 `render.yaml` Blueprint로 구성되어 있습니다.

- **Web Service** — Puma 웹 서버 (`startCommand: bundle exec puma -C config/puma.rb`)
- **Database** — Render PostgreSQL (Blueprint에서 자동 프로비저닝)
- **빌드 명령어** — `bundle install && rails assets:precompile && rails db:migrate`
- **헬스체크** — `/up` (Rails 기본 health endpoint)

### 배포 절차

1. Render 대시보드 → **New +** → **Blueprint** → 본 GitHub 리포지토리 연결
2. `render.yaml`을 인식하면 web 서비스 + PostgreSQL이 자동 생성됨
3. 자동 생성 환경변수: `DATABASE_URL`, `SECRET_KEY_BASE` *(generateValue)*, `RAILS_ENV`, `RAILS_LOG_TO_STDOUT`, `RAILS_SERVE_STATIC_FILES` 등
4. **수동 입력 환경변수** (Render 대시보드 → Environment 탭):
   - `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`
   - `STRIPE_PUBLISHABLE_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`
   - `STRIPE_PREMIUM_MONTHLY_PRICE_ID`, `STRIPE_PREMIUM_YEARLY_PRICE_ID`
5. Google Cloud Console → OAuth 클라이언트 설정에서 **승인된 리디렉션 URI**에 `https://<your-app>.onrender.com/users/auth/google_oauth2/callback` 추가
6. (선택) `ACTIVE_STORAGE_SERVICE`는 기본 `local`이며, S3/R2 사용 시 별도 키 추가

### GitHub Pages 랜딩 페이지

`docs/` 디렉토리에 정적 랜딩 페이지가 있습니다. GitHub 리포지토리 **Settings → Pages → Branch: `master` / `/docs`**로 설정하면 자동 배포됩니다. 배포 후 `docs/index.html` 하단 스크립트의 `DEMO_URL`을 실제 Render URL로 교체하세요.

## 라이선스

MIT
