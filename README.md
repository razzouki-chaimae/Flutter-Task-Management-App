# Flutter Task Management App
This is a simple Flutter app for managing tasks. It allows you to add, mark as completed, and delete tasks. The app communicates with a Node.js server to store and retrieve task data using a REST API.

# Prerequisites
Before running the app, make sure you have the following prerequisites:

- Flutter: Ensure that Flutter is installed on your development machine.

- Node.js: You'll need Node.js installed on your machine to run the server.

- MongoDB: The app uses MongoDB as the database for storing tasks.

# Features
- Add Task: Click the "+" button to add a new task. A dialog will appear, allowing you to enter the task title.

- Complete Task: Tap the checkbox next to a task to mark it as completed.

- Delete Task: Click the deletion button to delete an existing task. Confirm the deletion in a dialog.

# App Structure
The Flutter app is structured as follows:

- main.dart: This file contains the main entry point of the app. It initializes the app and sets up the TaskApp widget.

- the Task class represents a task. It includes a factory method for creating a Task object from JSON data.

- _TaskAppState class provides functions to communicate with the Node.js server, including fetching tasks, adding tasks, completing tasks, and deleting tasks.

# Important Notes
- Make sure your Node.js server is running and reachable from the Flutter app.

- The app communicates with the server using HTTP requests, so ensure that your server is properly configured to handle these requests.

- In a production environment, you should secure the communication between the app and the server using HTTPS.

- This app is a basic example for educational purposes. In a real-world application, you would implement user authentication and additional security measures.

# Demo
https://drive.google.com/file/d/1ogqIn-VKse7QgsNMr58qKt5UJ3uJLJKy/view?usp=sharing
