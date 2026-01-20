# Share App

Windows desktop application for quick file sharing via context menu integration.

## 🎯 Overview

Share App is a lightweight Windows utility that allows users to quickly share files through the Windows share menu. It's designed to integrate seamlessly with the Windows shell, providing instant file sharing capabilities with minimal UI overhead.

## ✨ Features

- **Quick File Sharing**: Share files directly from Windows context menu
- **Multiple File Support**: Share one or multiple files simultaneously
- **Auto-close**: Automatically closes after sharing or inactivity
- **Minimal UI**: Clean, distraction-free interface
- **Keyboard Support**: Press ESC to close instantly
- **Error Handling**: Robust error handling with `result_dart` pattern
- **Material 3 Design**: Modern UI following Material Design 3 guidelines

## 🏗️ Architecture

This is a **simple architecture** Windows desktop application with clear separation of concerns:

```
lib/
├── main.dart                      # App entry point
├── model/                         # Data models
│   ├── share_file.dart            # Shared file model
│   ├── failures.dart              # Error handling with result_dart
│   └── demo_args.dart             # Demo/test arguments
├── page/                          # UI pages
│   └── home_page.dart             # Main application UI
├── service/                       # Business logic
│   ├── share_file.service.dart    # File sharing operations
│   ├── args_decode.dart           # Command-line argument decoder
│   └── process_info.dart          # System process information
└── window.config/                 # Window management
    ├── window_config.dart         # Window initialization
    └── window_event.dart          # Window event handlers
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.3.4)
- Windows 10/11
- Visual Studio 2022 (with C++ desktop development workload)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/cesar-carlos/share_app.git
cd share_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run -d windows
```

## 📦 Building

### Release Build

```bash
flutter build windows --release
```

The executable will be located at:
```
build/windows/x64/runner/Release/share_app.exe
```

## 🔧 Configuration

### Window Settings

Configure window behavior in `lib/window.config/window_config.dart`:

```dart
WindowOptions(
  size: ui.Size(550, 700),
  minimumSize: ui.Size(550, 700),
  backgroundColor: Colors.transparent,
  titleBarStyle: TitleBarStyle.hidden,
  skipTaskbar: true,
)
```

### Auto-close Settings

Adjust auto-close delay in `lib/page/home_page.dart`:

```dart
const _autoCloseDelay = Duration(seconds: 30);
```

## 📖 Usage

### Command Line Arguments

The app accepts base64-encoded JSON arguments:

```json
{
  "ShareFilePaths": [
    {
      "Id": "file-id",
      "Name": "example.jpg",
      "Path": "C:\Users\...\Documents"
    }
  ]
}
```

Encode to base64 and pass as argument:
```bash
share_app.exe <base64-encoded-json>
```

### Demo Mode

Use demo arguments for testing (see `lib/model/demo_args.dart`):

```dart
// In main.dart, uncomment:
final String stringArgs = DemoArgs.args;
```

## 🛠️ Tech Stack

- **Flutter**: 3.3.4+
- **Dart**: 3.3.4+
- **Windows**: Windows desktop API
- **Packages**:
  - `share_plus: ^12.0.1` - File sharing
  - `window_manager: ^0.5.1` - Window management
  - `file_selector: ^1.1.0` - File selection
  - `result_dart: ^2.1.1` - Error handling

## 📂 Error Handling

The app uses `result_dart` for robust error handling:

```dart
Result<List<ShareFile>> result = ArgsDecode.exec(args);

result.fold(
  (files) {
    // Success: handle files
  },
  (error) {
    // Error: handle failure
    final failure = error as AppFailure;
    log('Error: ${failure.message}');
  },
);
```

### Failure Types

- **`ShareFailure`**: File sharing errors
- **`DecodeFailure`**: Argument decoding errors
- **`JsonParseFailure`**: JSON parsing errors

## 🧪 Development

### Code Style

This project follows:
- **Effective Dart** (2026 edition)
- **Flutter AI Rules**
- **Material 3 Guidelines**

Key principles:
- ✅ Type declarations for all variables
- ✅ `const` constructors for immutable widgets
- ✅ Arrow syntax for simple functions
- ✅ Trailing commas for multi-line statements
- ✅ Named constants (no magic numbers)

### Running Analysis

```bash
# Analyze code
dart analyze lib/

# Format code
dart format lib/
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Cesar Carlos**

- GitHub: [@cesar-carlos](https://github.com/cesar-carlos)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
