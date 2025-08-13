# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Project

Time on Rails is a time tracking application built as an alternative to Harvest. It's a Rails 8.0.1 application using SQLite, Tailwind CSS, and Devise for authentication. The application allows users to track time spent on projects with start/stop functionality and generate reports.

## Development Commands

### Setup
```bash
bundle install            # Install Ruby dependencies
bin/rails db:setup        # Create and setup database
bin/rails db:migrate      # Run migrations
```

### Development Server
```bash
bin/rails server          # Start Rails server (port 3000)
bin/rails tailwindcss:watch  # Watch and compile Tailwind CSS
```

Or use the Procfile for concurrent processes:
```bash
foreman start -f Procfile.dev
```

### Testing
```bash
bin/rails test            # Run all tests except system tests
bin/rails test:system     # Run system tests
bin/rails test:db         # Reset database and run tests
```

### Code Quality
```bash
bundle exec rubocop       # Run RuboCop linter
bundle exec brakeman      # Run security scanner
```

### Database
```bash
bin/rails db:reset        # Drop, create, migrate, and seed database
bin/rails db:seed         # Load seed data
```

## Application Architecture

### Models
- **User**: Devise-managed user accounts with authentication
- **Project**: User-owned projects for organizing work sessions
- **Work**: Time tracking entries linked to projects and users

### Key Relationships
- User has many Projects and Works
- Work belongs to both User and Project
- Projects act as containers for organizing time entries

### Core Features
- **Time Tracking**: Start/stop timers for work sessions
- **Project Management**: Create and organize projects
- **Reports**: Monthly time summaries grouped by project
- **User Authentication**: Devise-powered login/registration

### Controllers
- **WorksController**: Main interface for time tracking (index is root path)
- **ProjectsController**: Project CRUD operations  
- **ReportsController**: Time reporting and analytics

### Time Tracking Logic
- Works can be started/stopped with automatic time calculation
- Only one work session can be active per user at a time
- Starting a new work session automatically stops any running sessions
- Time is stored in seconds in the `duration` field
- Active sessions track `started_at` timestamp for real-time calculation

### Routes Structure
- Root path: `/` (works#index)
- Works: `/works` with start/stop member actions
- Projects: `/projects` 
- Reports: `/reports` with month/year filtering
- Authentication: Devise routes at `/users`

### Frontend
- Tailwind CSS for styling
- Stimulus controllers for JavaScript interactions
- Turbo for SPA-like navigation
- ERB templates with responsive design