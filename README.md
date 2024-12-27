

---

# UrbanCanteen User Booking App

The UrbanCanteen User Booking App is a part of the UrbanCanteen Food Ordering System designed to streamline the food ordering process for students. This app allows users to browse the menu, place orders, and receive real-time updates on their order status.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Order Status Workflow](#order-status-workflow)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

UrbanCanteen is a comprehensive food ordering system consisting of four applications:
1. **User Booking App**: For students to place food orders.
2. **Kitchen App**: For kitchen staff to manage and process orders.
3. **Management App**: For management to oversee orders and analyze food ordering data.
4. **Scanner App**: For verifying orders and updating their status.

## Features

- **Digital Menu**: Browse through a digital menu and view detailed descriptions of food items.
- **Order Placement**: Place orders directly through the app.
- **QR Code Generation**: Receive a unique QR code upon placing an order.
- **Real-Time Order Tracking**: Get updates on the status of your order.
- **Order Status Notifications**: Notifications for different stages of the order (Pending, Preparing, Ready for Pickup, Picked Up).
- **User Authentication**: Secure login and account management using Firebase.

## Installation

To set up the User Booking App, follow these steps:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/UrbanCanteen-UserBookingApp.git
    cd UrbanCanteen-UserBookingApp
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Configure Firebase:**

    - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
    - Add your Android and/or iOS app to the Firebase project.
    - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) files and place them in the respective directories:
        - `android/app/` for `google-services.json`
        - `ios/Runner/` for `GoogleService-Info.plist`
    - Follow the [FlutterFire documentation](https://firebase.flutter.dev/docs/overview) to set up Firebase in your Flutter project.

4. **Run the app:**

    ```bash
    flutter run
    ```

## Usage

### Placing an Order

1. **Browse Menu**: Open the app and browse through the available food items.
2. **Select Items**: Choose the items you wish to order and add them to your cart.
3. **Place Order**: Confirm your order and proceed to payment.
4. **Receive QR Code**: After placing the order, you will receive a unique QR code.

### Order Pickup Process

1. **Scan QR Code**: Go to the kitchen and scan your QR code using the Scanner App.
2. **Order Processing**: The kitchen staff will process your order based on the QR code.
3. **Order Status Updates**: Receive real-time updates on your order status (Pending, Preparing, Ready for Pickup, Picked Up).

## Order Status Workflow

1. **Pending**: Order has been placed but not yet processed by the kitchen.
2. **Preparing**: Kitchen staff are currently preparing the order.
3. **Ready for Pickup**: Order is ready for the user to pick up.
4. **Picked Up**: Order has been picked up by the user.

## Screenshots

![Home Screen](screenshots/home.png)
![Menu Screen](screenshots/menu.png)
![Order Summary](screenshots/order_summary.png)
![QR Code](screenshots/qr_code.png)
![Order Status](screenshots/order_status.png)

## Contributing

We welcome contributions from the community! To contribute to the UrbanCanteen User Booking App, follow these steps:

1. **Fork the repository:**

    Click the "Fork" button at the top right of the repository page.

2. **Clone your fork:**

    ```bash
    git clone https://github.com/yourusername/UrbanCanteen-UserBookingApp.git
    cd UrbanCanteen-UserBookingApp
    ```

3. **Create a new branch:**

    ```bash
    git checkout -b feature-name
    ```

4. **Make your changes and commit:**

    ```bash
    git commit -m "Add some feature"
    ```

5. **Push to your fork:**

    ```bash
    git push origin feature-name
    ```

6. **Create a pull request:**

    Open a pull request from your forked repository to the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or support, please contact:

- **Name**: Ashwin Raj Tunk
- **Email**: [tunkashwin96@gmail.com](mailto:tunkashwin96@gmail.com)
- **LinkedIn**: [linkedin.com/in/tunkashwinraj](https://www.linkedin.com/in/tunkashwinraj)

---
