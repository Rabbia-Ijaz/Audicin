_A music player app with step tracking and playlist recommendations._

## Description  
A SwiftUI-based music player app that combines step count tracking and music recommendations. The app displays the user's current step count and a weekly summary of activity, recommends playlists based on the user's activity level, and simulates track playback with an interactive progress bar.

## Features:  
- **Step Count View:** Step count current status along with the past week summary
- **Personalized Playlists:** Recommends playlists based on the user's activity level (step count).
- **Access to all Playlists:** Allows the user to browse and access all available playlists, but the app will prioritize displaying recommended playlists based on the step count.
- **Track Playback:** Real-time progress bar with play/pause and restart functionality.  
- **Track Information:** Displays track title, artist, and duration.

## Choices I made:  
- I used HealthKit data from the simulator for this task. This allows the step count to refresh every time the user updates the data in the Health app, ensuring up-to-date step count information.
- To simplify the handling of playlists, I used a playlists.json file to display data for all three playlists. This decision made it easier to manage and update the playlists without the need for a backend or database.
- I chose to simulate track playback instead of integrating a real music player backend for simplicity and to focus on UI/UX design and functionality.
- I chose a custom color palette to align with the theme of the app, ensuring a visually appealing design.

## Screenshots

<div style="display: flex; justify-content: space-around; align-items: center; flex-wrap: wrap;">
  <img src="https://github.com/user-attachments/assets/d3b91eb7-a57c-4864-a3c1-a09874fef243" alt="Main Screen" width="200"/>
  <img src="https://github.com/user-attachments/assets/38897ffc-5582-406d-8090-a65630c94257" alt="Playlist Screen (recommended)" width="200"/>
  <img src="https://github.com/user-attachments/assets/d7916d3b-0d8a-4d44-8334-748ed3e57e99" alt="Playlist Screen (all)" width="200"/>
  <img src="https://github.com/user-attachments/assets/2cd51fd3-ae1c-4c4c-929a-764766950fd2" alt="Track Screen" width="200"/>
</div>

## Trade-offs  
During the development, the following trade-offs were made:  
- **HealthKit Integration:** HealthKit data was integrated using the simulator rather than an actual iOS device. Unfortunately, my device broke down, and I am awaiting a replacement, which will allow me to test on a real device next month.
- **Real-time Step Count Updates:** Due to the use of the simulator for development and testing, the app does not support real-time step count updates. Simulators do not provide access to real-time HealthKit data. However, the app does update the step count every time the data is modified in the Health app, ensuring that the displayed step count remains up-to-date.
- **Simplified Playback:** To keep the focus on the user interface and overall user experience, I opted for a simulated track playback rather than implementing a full audio playback system. This choice simplified the development process while still providing an interactive playback simulation.
- **Playlist Data:** Playlist recommendations are based on predefined data in a playlist.json file. This simplifies the functionality and avoids the complexity of integrating a live backend or database for dynamic playlist management. 


