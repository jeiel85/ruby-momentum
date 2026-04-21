# Ruby Momentum

Google OAuth 인증, 실시간 업데이트, 이미지 업로드를 지원하는 Ruby on Rails 소셜 포스팅 애플리케이션입니다.

## 주요 기능

- **Google 소셜 로그인** — Devise + OmniAuth를 통한 Google 계정 로그인
- **포스트 관리** — 이미지 첨부가 가능한 게시글 작성, 조회, 수정, 삭제
- **실시간 업데이트** — ActionCable(Hotwire Turbo Streams)을 통해 새 게시글 및 댓글 즉시 반영
- **소셜 기능** — 게시글 좋아요, 북마크, 실시간 댓글 기능
- **수익화(Monetization)** — Stripe 연동 프리미엄 구독(Premium Membership) 및 창작자 팁(Tips) 기능
- **클라우드 스토리지** — AWS S3 / Cloudflare R2를 통한 이미지 CDN 구성
- **반응형 UI** — Tailwind CSS로 스타일링된 모던한 인터페이스
- **프로덕션 배포** — Docker + Kamal 배포 지원

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

이 앱은 Render 배포를 위해 다음과 같이 구성되어 있습니다.

- **Web Service** — Puma 웹 서버
- **Database** — Render PostgreSQL
- **빌드 명령어** — `bundle install && rails assets:precompile && rails db:migrate`
- **시작 명령어** — `bundle exec puma -C config/puma.rb`

배포 전 Render 대시보드에서 위 환경변수를 설정해주세요.

## 라이선스

MIT
