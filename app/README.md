
# Onboarding Guide

Welcome to this flutter getx, dio and shared preference boilerplate

## 🛠️ Setup Instructions

1.  **Configure Environment Variables**  
    Adjust your `.envied` file with the appropriate environment variables.
    
2.  **Install Requirements**  
    Make sure the following are installed and properly set up:
    
    -   Flutter SDK
        
    -   Dart SDK (usually comes with Flutter)
        
    -   Java Development Kit (JDK)
        
    -   Android Emulator / iOS Simulator
        
    -   Xcode (for iOS development)
        
    -   Android Studio (or your preferred IDE)
        
3.  **Clean & Get Packages**
    
    ```bash
    flutter clean
    flutter pub get
    
    ```
    
4.  **Run Code Generation**
    For generating encrypted env data in `/lib/env` folder
    
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    
    ```
    
5.  **(Optional) Fix Gradle Issues**  
    If you run into Gradle issues during build or run:
    
    ```bash
    cd android
    ./gradlew clean
    
    ```
    

Happy coding! ✨