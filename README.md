# Ruby Momentum

A Ruby on Rails social posting application with Google OAuth authentication, real-time updates, and image upload support.

## Features

- **Google OAuth Login** — Sign in with your Google account via Devise + OmniAuth
- **Posts** — Create, read, update, and delete posts with optional image attachments
- **Real-time Updates** — New posts appear instantly via ActionCable (Hotwire Turbo Streams)
- **Responsive UI** — Styled with Tailwind CSS
- **Production Ready** — Deployed on [Render](https://render.com) with PostgreSQL

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 8.1 |
| Language | Ruby 3.4.9 |
| Auth | Devise + OmniAuth Google OAuth2 |
| Frontend | Hotwire (Turbo + Stimulus) + Tailwind CSS |
| Database | PostgreSQL (production) / SQLite (development) |
| File Storage | Active Storage |
| Real-time | ActionCable |
| Deployment | Render |

## Getting Started

### Prerequisites

- Ruby 3.4.9
- Bundler
- SQLite3 (development)
- A Google OAuth2 client ID and secret

### Setup

```bash
# Clone the repo
git clone https://github.com/<your-username>/ruby-momentum.git
cd ruby-momentum

# Install dependencies
bundle install

# Configure environment variables
cp .env.example .env
# Edit .env and fill in your Google OAuth credentials:
# GOOGLE_CLIENT_ID=...
# GOOGLE_CLIENT_SECRET=...

# Set up the database
rails db:create db:migrate db:seed

# Start the development server
bin/dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `GOOGLE_CLIENT_ID` | Google OAuth2 client ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth2 client secret |
| `DATABASE_URL` | PostgreSQL connection URL (production) |
| `SECRET_KEY_BASE` | Rails secret key base (production) |

## Project Structure

```
app/
├── controllers/
│   ├── posts_controller.rb         # CRUD for posts
│   └── users/
│       └── omniauth_callbacks_controller.rb  # Google OAuth callback
├── models/
│   ├── user.rb                     # Devise + Google OmniAuth
│   └── post.rb                     # Post with image attachment & Turbo broadcasts
└── views/
    └── posts/                      # Post views
```

## Deployment (Render)

This app is configured for deployment on Render with:

- **Web Service** — Puma web server
- **Database** — Render PostgreSQL (production)
- **Build command** — `bundle install && rails assets:precompile && rails db:migrate`
- **Start command** — `bundle exec puma -C config/puma.rb`

Set the environment variables listed above in the Render dashboard before deploying.

## License

MIT
