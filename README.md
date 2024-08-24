# Habit Tracker App

## Overview

The Habit Tracker App is a user-friendly mobile application that allows users to create, manage, and track their daily habits. It is designed to help users form positive habits by providing features like habit management, reminders, progress tracking, and visualizations of habit performance. The app is built using Flutter, ensuring compatibility across both iOS and Android platforms.

## Features

### 1. User Authentication
- **Firebase Authentication**: Users can register and log in using their email and password.
- **Secure and persistent login sessions**.

### 2. Habit Management
- **Create, Edit, Delete Habits**: Users can add new habits, edit existing ones, and delete habits that they no longer want to track.
- **Mark Habits as Completed**: Users can mark habits as done for each day.

### 3. Habit Tracking
- **Calendar View**: Displays daily habit completion using a calendar view, helping users visualize their progress over time.
- **Heatmap Visualization**: Visualizes habit performance with varying color intensities based on activity.

### 4. Notifications
- **Reminders**: Users can set reminders for each habit to stay on track. Notifications will alert users at the set times.

### 5. Progress Overview
- **Dashboard**: Shows overall progress, including streaks and habit completion rates.
- **Habit Trends**: Users can view trends to understand their habit performance over time.

### 6. Statistics
- **Charts and Graphs**: The Statistics page displays bar charts and other visualizations to help users analyze their habit trends and performance.



## Technical Details

### 1. Architecture
- **Clean Architecture**: The app is structured following the principles of clean architecture to ensure maintainability and scalability.
- **State Management**: Riverpod is used for state management, providing a reactive and robust solution.
![Architecture Diagram](https://github.com/ManojTammineedi/HabitTracker/blob/main/lib/images/Architecture.png?raw=true)

### 2. Responsiveness
- **Cross-Platform Compatibility**: The app is responsive and works seamlessly across different screen sizes and orientations on both iOS and Android.
- **Adaptive Layouts**: Ensures a consistent and pleasant user experience across various devices.

### 3. Testing
- **Unit Tests**: Critical parts of the application are covered by unit tests to ensure reliability and prevent regressions.

## Getting Started

### Prerequisites
- **Flutter SDK**: Ensure that Flutter is installed on your machine. [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Firebase Project**: Set up a Firebase project and enable Firebase Authentication and Realtime Database.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ManojTammineedi/HabitTracker.git
2. Navigate to the project directory:
    ```bash
    cd habit-tracker-app
3. Install dependencies:
    ```bash
    flutter pub get
4. Configure Firebase:
- Download the google-services.json file for Android and GoogleService-Info.plist file for iOS from your Firebase project.
- Place these files in the appropriate directories (android/app and ios/Runner).

5. Running the App
- Run the app on your desired platform:
     ```bash
     flutter run
### Demo
- **Video Walkthrough:** A short video walkthrough highlighting the main features and user flow is available  [check here](https://drive.google.com/file/d/17zDkWiR90kO3H11QvbJuUf1ksC_tvZDx/view?usp=sharing)
### License
 This project is licensed under the MIT License - see the LICENSE file for details.
