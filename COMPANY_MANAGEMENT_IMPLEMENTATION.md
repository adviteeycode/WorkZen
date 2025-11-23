# WorkZen - Company Management System

## Overview

This implementation provides a complete company management system for the WorkZen application, featuring:

- **Home Page**: Display all registered companies with detailed information
- **Company Registration Page**: Register new companies with comprehensive details
- **Company Management**: Edit, delete, and manage company information
- **Firebase Integration**: Store company data in Firestore with real-time updates

## Project Structure

```
lib/
├── models/
│   └── company.dart              # Company data models
├── services/
│   └── company_service.dart      # Firebase Firestore operations
├── providers/
│   └── company_provider.dart     # State management using Provider
├── pages/
│   ├── home_page.dart            # Company list display
│   └── company_registration_page.dart  # Company form (Create/Edit)
├── routes/
│   └── app_routes.dart           # Route definitions
├── main.dart                      # App entry point
└── theme/                         # Theme configuration
```

## Features Implemented

### 1. Company Model (`lib/models/company.dart`)

The `Company` class includes all required fields:

```dart
class Company {
  String companyId              // Auto-generated document ID
  String companyName            // Required: Official company name
  String? companyEmail          // Primary company email
  String? companyPhone          // Contact number
  Address? address              // Address details
  String? logo                  // Firebase Storage URL for logo
  String? industry              // Business industry type
  Subscription? subscription    // Subscription plan details
  Settings? settings            // Company settings
  DateTime createdAt            // Registration date
  DateTime updatedAt            // Last modification date
  bool isActive                 // Account status
}
```

**Related Models:**
- `Address`: Street, City, State, Country, Zip Code
- `Subscription`: Plan, Start Date, End Date, Active Status, Max Employees
- `Settings`: Payroll Cycle, Working Days, PF Rate, PT Rate, Currency

### 2. Company Service (`lib/services/company_service.dart`)

Handles all Firebase Firestore operations:

- `createCompany()`: Register a new company
- `getAllCompanies()`: Fetch all registered companies
- `getCompanyById()`: Get specific company details
- `updateCompany()`: Modify company information
- `deleteCompany()`: Remove a company
- `toggleCompanyStatus()`: Activate/deactivate company
- `getCompaniesStream()`: Real-time company updates

### 3. Company Provider (`lib/providers/company_provider.dart`)

State management using Provider pattern:

- `loadCompanies()`: Load all companies from Firestore
- `createCompany()`: Create new company and reload
- `updateCompany()`: Update existing company
- `deleteCompany()`: Delete company
- `toggleCompanyStatus()`: Change company status
- `getCompanyById()`: Fetch single company
- Error handling and loading states

### 4. Home Page (`lib/pages/home_page.dart`)

Main company list interface featuring:

- **Company Cards**: Display company information with logo, contact details, address
- **Company Status**: Visual indicator (Active/Inactive)
- **Actions**: Edit, Delete, and toggle status
- **Quick Registration**: Floating action button to register new companies
- **Empty State**: User-friendly message when no companies exist
- **Error Handling**: Display and retry error messages
- **Loading State**: Circular progress indicator while fetching data

**Company Card Sections:**
- Company header with logo, name, industry, and status
- Contact information (email, phone)
- Address details
- Subscription information (plan, max employees)
- Settings (currency, payroll cycle, tax rates)

### 5. Company Registration Page (`lib/pages/company_registration_page.dart`)

Comprehensive form for company registration and editing:

**Company Information Section:**
- Company Name (required)
- Email
- Phone
- Industry

**Address Section:**
- Street
- City & State (side by side)
- Country & Zip Code (side by side)

**Subscription Section:**
- Plan
- Max Employees

**Settings Section:**
- Payroll Cycle
- Working Days
- PF Rate & PT Rate (side by side)
- Currency (default: INR)

**Logo Management:**
- Logo upload via image picker
- Display selected logo or placeholder
- Support for network and local file images

### 6. Updated App Routes (`lib/routes/app_routes.dart`)

Route definitions for navigation:
- `/` → HomePage
- `/register-company` → CompanyRegistrationPage

## Usage

### Register a Company

1. Click the **"New Company"** floating action button on home page
2. Fill in the company details
3. Upload company logo (optional)
4. Click **"Register Company"**

### View Companies

Home page automatically loads and displays all registered companies in card format with:
- Company logo and basic information
- Active/Inactive status
- Contact details
- Address
- Subscription and settings information

### Edit Company

1. Click the menu icon (three dots) on any company card
2. Select **"Edit"**
3. Modify the company details
4. Click **"Update Company"**

### Delete Company

1. Click the menu icon on the company card
2. Select **"Delete"**
3. Confirm deletion in the dialog

## Firebase Firestore Collection

**Collection:** `companies`

**Document Structure:**
```json
{
  "companyId": "auto-generated",
  "companyName": "string",
  "companyEmail": "string",
  "companyPhone": "string",
  "address": {
    "street": "string",
    "city": "string",
    "state": "string",
    "country": "string",
    "zipCode": "string"
  },
  "logo": "string (url)",
  "industry": "string",
  "subscription": {
    "plan": "string",
    "startDate": "timestamp",
    "endDate": "timestamp",
    "isActive": "boolean",
    "maxEmployees": "number"
  },
  "settings": {
    "payrollCycle": "string",
    "workingDays": "string",
    "pfRate": "number",
    "ptRate": "number",
    "currency": "string"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isActive": "boolean"
}
```

## Dependencies Used

- `provider: ^6.1.5+1` - State management
- `firebase_core: ^4.2.1` - Firebase initialization
- `cloud_firestore: ^6.1.0` - Database operations
- `image_picker: ^1.2.1` - Logo upload functionality
- `flutter/material` - UI components

## Integration with Main App

The home page is set as the default `home` route in `main.dart`. The app initializes:

1. **CompanyProvider**: Manages company state
2. **ThemeProvider**: Manages app theme (existing)

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CompanyProvider()),
  ],
  child: const WorkZen(),
)
```

## Error Handling

- Validation for required fields
- Firebase exception handling with user-friendly messages
- Network error recovery with retry option
- Loading states during async operations

## Future Enhancements

- Company logo upload to Firebase Storage
- Search and filter companies
- Export company data
- Bulk operations (import/export CSV)
- Company analytics dashboard
- Employee management per company
- Payroll management integration
