# iOS Build Instructions for Tranzfort TMS

## 📱 iOS Project Location
The complete iOS project is located at:
```
c:\Users\marte\Desktop\ZAFTYS\tranzfort-app\ios_build\
```

## 🛠️ Build Requirements (Mac Only)
- macOS 10.15 or later
- Xcode 12.0 or later
- iOS SDK 13.0 or later
- CocoaPods installed
- Physical iOS device or iOS Simulator

## 📋 Step-by-Step Build Instructions

### 1. Setup Environment (on Mac)
```bash
# Install CocoaPods if not already installed
sudo gem install cocoapods

# Navigate to the iOS project directory
cd ios_build/ios

# Install iOS dependencies
pod install
```

### 2. Open in Xcode
```bash
# Open the workspace in Xcode
open Runner.xcworkspace
```

### 3. Configure Xcode Project
1. **Select Team**: In Xcode, select your Apple Developer team
2. **Bundle Identifier**: Change to your unique bundle ID (e.g., com.yourcompany.tranzforttms)
3. **Signing**: Configure automatic or manual signing
4. **Deployment Target**: Ensure iOS 13.0+ is set

### 4. Build Options

#### Option A: Build for Simulator
```bash
cd ios_build
flutter build ios --simulator
```

#### Option B: Build for Physical Device
```bash
cd ios_build
flutter build ios
```

#### Option C: Build IPA for Distribution
```bash
cd ios_build
flutter build ios --release
```

### 5. Install on Device

#### Method A: Direct Install via Xcode
1. Connect your iOS device to Mac
2. Select your device in Xcode
3. Click "Run" (▶) button

#### Method B: Install via IPA
1. Build the IPA file using Option C
2. Use Apple Configurator 2 or iTunes to install
3. Or use Xcode: Window > Devices and Simulators > + Install App

#### Method C: Install via TestFlight
1. Upload to App Store Connect
2. Create TestFlight build
3. Invite testers or install yourself

## 🔧 iOS Configuration Features Included

### ✅ Permissions Configured
- Camera access for document capture
- Photo library access for image selection
- Location services for GPS tracking
- Contacts access for driver/party import
- Calendar access for trip scheduling
- Bluetooth for device connectivity
- Face ID for secure authentication
- Notifications for alerts and updates

### ✅ Features Enabled
- Deep linking (tranzfort:// scheme)
- File sharing and document management
- Background location tracking
- Push notifications
- Siri integration
- Document type associations (PDF, Images, Excel)

### ✅ Security Features
- App Transport Security configured
- Face ID authentication support
- Secure file handling
- Background processing enabled

## 📱 Testing Instructions

### Core Features to Test:
1. **Vehicle Management** - Add/edit vehicles with photos
2. **Driver Management** - Add drivers with license tracking
3. **Trip Management** - Create and track trips
4. **Expense Management** - Add expenses with receipt photos
5. **Payment Management** - Track payments and balances
6. **Document Management** - Upload and manage documents
7. **Reports & Analytics** - View charts and reports
8. **Dashboard** - Interactive dashboard with real-time data
9. **Search** - Global search across all modules
10. **User Management** - Login and user authentication
11. **Settings** - System configuration
12. **Backup & Restore** - Data protection features

### iOS-Specific Testing:
- Camera integration for document capture
- Photo library access
- Location services permissions
- Push notifications
- Deep linking from other apps
- File sharing with other apps
- Face ID authentication
- Background location tracking
- Siri integration (if enabled)

## 🚨 Troubleshooting

### Common Issues:
1. **Build Errors**: Run `flutter clean` and `flutter pub get`
2. **Pod Install Issues**: Run `pod deintegrate` then `pod install`
3. **Signing Issues**: Check Apple Developer account and certificates
4. **Permission Errors**: Ensure Info.plist has correct permissions
5. **Device Not Recognized**: Check USB connection and trust computer

### Debug Commands:
```bash
# Clean build
flutter clean
flutter pub get

# Check doctor
flutter doctor -v

# Verbose build
flutter build ios --verbose

# Check devices
flutter devices
```

## 📦 Project Structure
```
ios_build/
├── lib/                    # Flutter app code
├── ios/                    # iOS native code
│   ├── Runner.xcworkspace  # Xcode workspace
│   ├── Runner.xcodeproj    # Xcode project
│   ├── Podfile            # CocoaPods dependencies
│   └── Runner/            # iOS app configuration
├── pubspec.yaml           # Flutter dependencies
└── README.md             # This file
```

## 🎯 Next Steps
1. Copy the `ios_build` folder to a Mac
2. Follow the build instructions above
3. Test all features on your iOS device
4. Provide feedback on iOS-specific functionality

## 📞 Support
If you encounter any issues during iOS build or testing, please provide:
- Error messages from Xcode
- Flutter doctor output
- iOS version and device model
- Specific feature that's not working

---
**Note**: iOS development requires a Mac computer. The build files are ready for compilation on macOS with Xcode.
