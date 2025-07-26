# Dartverein

A Flutter application for managing dart tournaments and tracking player statistics.

## Project Structure

```
Dartverein/
├── lib/                    # Flutter app source code
│   ├── components/         # Reusable UI components
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API and business logic
│   ├── theme/             # App theming
│   └── utils/             # Utility functions
├── backend/               # Spring Boot backend
│   ├── src/main/java/     # Java source code
│   ├── src/main/resources/ # Configuration files
│   └── Dockerfile         # Docker configuration
├── test/                  # Flutter tests
├── .github/workflows/     # CI/CD pipelines
└── assets/               # App assets (images, etc.)
```

## Features

- **Player Management**: Add, edit, and manage dart players
- **Game Tracking**: Track dart games and scores
- **Statistics**: View player statistics and performance metrics
- **Authentication**: User login and registration
- **Responsive Design**: Works on mobile and tablet devices

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.24.0)
- Java 17
- MySQL 8.0
- Docker (optional, for containerized deployment)

### Local Development

1. **Backend Setup**:
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```

2. **Flutter Setup**:
   ```bash
   flutter pub get
   flutter run
   ```

### Database Configuration

The backend connects to MySQL database. Update `backend/src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/dartverein
spring.datasource.username=your_username
spring.datasource.password=your_password
```

## Deployment

### Backend Deployment with Docker

```bash
cd backend
docker build -t dartverein-backend .
docker run -p 8081:8081 -e SPRING_DATASOURCE_URL=... dartverein-backend
```

### Flutter Build

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release
```

## CI/CD Pipeline

This project includes GitHub Actions workflows for:

- **Backend Deployment**: Automatic deployment to server on main branch push
- **Flutter Build**: Build and test Flutter app for Android and iOS
- **Testing**: Automated testing for both backend and frontend

### Required GitHub Secrets

Set these secrets in your GitHub repository:

- `SERVER_HOST`: Your deployment server IP (217.154.69.39)
- `SERVER_USER`: SSH username for server access
- `SERVER_SSH_KEY`: Private SSH key for server access
- `DB_PASSWORD`: MySQL database password
- `CODECOV_TOKEN`: Token for code coverage reporting (optional)

## API Endpoints

The backend provides RESTful APIs:

- `GET /api/players` - Get all players
- `POST /api/players` - Create new player
- `GET /api/games` - Get all games
- `POST /api/games` - Create new game
- `GET /api/statistics` - Get player statistics

## Architecture

- **Frontend**: Flutter with Dart
- **Backend**: Spring Boot with Java 17
- **Database**: MySQL 8.0
- **Authentication**: JWT tokens
- **Deployment**: Docker containers on Linux server

## Testing

```bash
# Flutter tests
flutter test

# Backend tests
cd backend
./mvnw test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is private and proprietary.
