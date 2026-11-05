# Easy Shop

A complete Flutter e-commerce application for clients and store administrators. Easy Shop provides product discovery, cart and favorites management, checkout, order tracking, location selection, and a dedicated administration experience for managing the store catalog and orders.

## App preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/fa1354a2-9243-4f9b-bb18-5d118328d2de" alt="Easy Shop app preview 1" width="240">
  <img src="https://github.com/user-attachments/assets/1e022ffd-fa6a-48cd-ae70-8cfaa3855b59" alt="Easy Shop app preview 2" width="240">
</p>

> **Project status:** The application is actively structured around a remote REST API. Configure the API environment and credentials before deploying it to production.

## Features

### Client experience

- Client registration and login
- OTP verification and OTP resend flow
- Browse products and categories
- Product search and product details
- Add and remove cart items
- Favorites management
- Checkout with delivery address and map location
- Payment processing through the configured payment gateway
- Order history and order details
- Profile viewing and editing
- Profile picture upload

### Store administrator experience

- Administrator registration with business information
- Upload commercial registration, tax card, and profile picture
- OTP verification and login
- Dashboard with store and order overview
- Create, edit, view, and delete products
- Product visibility and inventory management
- Create, edit, and delete categories
- View orders and order details
- Administrator profile management

### Location and media

- Current-location detection
- Interactive map picker using OpenStreetMap tiles
- Image uploads for products and profiles
- Multipart form submissions for registration and catalog management

## Technology stack

- **Flutter** and **Dart**
- **flutter_bloc** for state management
- **get_it** for dependency injection
- **Dio** for HTTP communication and interceptors
- **flutter_secure_storage** for secure local token storage
- **flutter_map** with **OpenStreetMap** tiles
- **geolocator** and **latlong2** for location services
- **image_picker** for selecting images

## Architecture

The codebase follows a feature-first Clean Architecture structure:

```text
lib/
├── core/
│   ├── di/              # Dependency injection
│   ├── errors/          # Exceptions, failures, and result handling
│   ├── helpers/         # Storage, location, and file-upload helpers
│   ├── network/         # Dio client, API constants, and interceptors
│   ├── routing/         # Routes and application navigation
│   ├── theme/           # Colors, typography, and application theme
│   ├── usecase/         # Shared use-case abstractions
│   └── widgets/         # Reusable UI components
├── features/
│   ├── auth/
│   ├── cart/
│   ├── categories/
│   ├── checkout/
│   ├── favorites/
│   ├── home/
│   ├── maps/
│   ├── orders/
│   ├── products/
│   └── profile/
└── main.dart
```

Each business feature is separated into `data`, `domain`, and `presentation` layers. Cubits handle presentation state, repositories abstract data access, and use cases keep business operations independent from the UI.

## Requirements

- Flutter SDK with Dart **3.12.2 or newer**
- Android Studio or Xcode for mobile development
- A configured Easy Shop-compatible REST API
- Location permissions enabled on the target device when using the map picker

## Getting started

1. Clone the repository:

   ```bash
   git clone https://github.com/teto06920623/easy_shop.git
   cd easy_shop
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure the API in `lib/core/network/api_constants.dart`:

   - Set the API base URL for the environment you want to use.
   - Provide the API key through a secure environment/configuration mechanism for production builds.
   - Confirm that the backend exposes the client and administrator endpoints used by the app.

4. Run static analysis:

   ```bash
   flutter analyze
   ```

5. Run the application:

   ```bash
   flutter run
   ```

## Build commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Platform configuration

### Android

The Android app declares Internet access and coarse/fine location permissions in `android/app/src/main/AndroidManifest.xml`. Users must grant location access when the application requests it.

### iOS

Add the appropriate location usage description keys to the iOS Runner configuration before distributing an iOS build. Review the `ios/Runner/Info.plist` file and provide clear user-facing explanations for location access.

### Web

The project includes Flutter Web support. Location availability depends on browser permissions and a secure context such as HTTPS. OpenStreetMap tiles also require appropriate attribution and responsible usage in production.

## API integration

The API base URL and endpoint paths are centralized in `lib/core/network/api_constants.dart`. The application currently integrates endpoints for:

- Client and administrator authentication
- OTP verification and resend
- Profiles
- Categories
- Products
- Favorites
- Cart items
- Orders and order details
- Payments

The checkout flow sends delivery coordinates, address, selected products, quantities, prices, and payment method to the backend. Payment processing is configured for the backend payment gateway and should be validated against the deployment environment before release.

## Security notes

- Do not commit production API keys or other secrets to source control.
- Use environment-specific configuration or a secrets manager for release builds.
- Never use real customer data while testing.
- Validate authentication, authorization, file uploads, and payment callbacks on the server as well as in the app.
- Review and rotate any credential that has previously been exposed in a public repository.

## Development guidelines

- Keep new business functionality inside the relevant feature under `lib/features/`.
- Preserve the `data` / `domain` / `presentation` separation.
- Reuse shared widgets, error handling, routing, and network helpers from `lib/core/`.
- Add or update tests when introducing new use cases, repositories, or state transitions.
- Run `flutter analyze` before opening a pull request.

## License

No license has been specified yet. Add a `LICENSE` file before distributing or reusing this project publicly.

## Contact

For questions or contributions, open an issue or pull request in the repository:

<https://github.com/teto06920623/easy_shop>
