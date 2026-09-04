# NOVA E-Commerce App

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Onboarding & Preferences Flow

The onboarding feature was implemented using a feature-based architecture and Cubit for state
management.

### Architecture

- Data Layer
    - Models
    - Repository

- Logic Layer
    - Onboarding Cubit
    - Onboarding States

- Presentation Layer
    - Screens
    - Reusable Widgets

---

## Screens

### 1. Onboarding

<img src="screenshots/onboarding_1.png" width="250">
<img src="screenshots/onboarding_2.png" width="250">
<img src="screenshots/onboarding_3.png" width="250">

### 2. Preferences

<img src="screenshots/preview_style.png" width="250">

<img src="screenshots/preview_colors.png" width="250">

### 3. Personalization Ready

<img src="screenshots/personalization_ready.png" width="250">

---

## State Management

The feature uses Cubit for managing:

- Onboarding pages
- User preferences
- Color selection
- Style selection