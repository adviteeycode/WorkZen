# WorkZen — Smart Human Resource Management System

A multi-tenant HRMS built with Flutter and Firebase, designed to simplify HR operations with attendance tracking, leave management, payroll processing, and role-based access control.

## Features

### Current Implementation
- **Multi-tenant Architecture**: Companies can manage multiple employees under one account.
- **Role-Based Access Control**: Admin, HR Officer, Payroll Officer, and Employee roles.
- **Employee Management**: Full CRUD operations for employee profiles with base salary tracking.
- **Attendance Tracking**: Check-in and check-out functionality with timestamp recording.
- **Responsive Web UI**:
  - AppBar with company logo, tab indicator, theme toggle, check-in/out button, and profile menu.
  - Vertical sidebar navigation with role-aware tabs.
  - Employee cards grid with edit/delete options (admin only).

### Planned Features
- Leave application and approval workflows.
- Payroll processing and payslip generation (per-company payruns).
- Attendance and payroll analytics with charts and metrics.
- Advanced settings and user management.  
- Auto-calculation includes:
  - Basic salary  
  - Deductions  
  - PF contribution  
  - Professional tax  
- Generate downloadable payslips  
- Supports monthly payruns  

---

### 📊 Dashboard & Analytics
- Attendance charts  
- Employee directory  
- Payroll summaries  
- Quick insights for HR & Admin  

---

## Getting Started

### Prerequisites
- Flutter SDK (^3.9.2) with web support enabled.
- Firebase project configured with Authentication and Firestore.

### Setup Instructions

#### 1. Firebase Configuration
Ensure your `lib/firebase_options.dart` is properly configured. If not already set up:
```bash
flutter pub add firebase_core firebase_auth cloud_firestore
flutterfire configure
```

#### 2. Firestore Security Rules
Replace your Firestore rules with the following to enable multi-tenant isolation:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - only accessible by the user themselves
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }

    // Companies collection - accessible by users with that companyId
    match /companies/{companyId} {
      allow read: if request.auth != null;
      allow create: if request.auth.token.email_verified;
      allow update, delete: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';

      // Employees subcollection
      match /employees/{employeeId} {
        allow read, write: if request.auth != null;
      }
    }

    // Attendance collection
    match /attendance/{attendanceId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### 3. Install Dependencies
```bash
cd d:\workzen
flutter pub get
```

#### 4. Run the App (Web)
```bash
flutter run -d chrome
# or use web-server for a server-based preview
flutter run -d web-server
```

#### 5. Test User Setup
1. Open the login page.
2. Register a new user (automatically assigned as 'employee' role).
3. **Create an Admin User** (via Firebase Console):
   - Go to Firestore → `users` collection.
   - Find your user document and update the `role` field to `admin` and add `companyId: null`.

4. **Create a Company** (as admin user):
   - After login, use the **+** button on the dashboard to create a company.

5. **Add Employees** (as admin in company dashboard):
   - Click "Add Employee" and fill in name, email, and base salary.

## Project Structure

```
lib/
├── main.dart                          # App entry point with auth wrapper
├── services/
│   └── auth_service.dart              # Firebase Authentication service
├── providers/
│   └── role_provider.dart             # Role and user data state management
├── pages/
│   ├── login_page.dart                # Login and registration
│   ├── dashboard_page.dart            # Company list and selection
│   └── company_dashboard_page.dart    # Company workspace with tabs
├── theme/
│   ├── provider/
│   │   └── theme_provider.dart        # Theme toggle (light/dark)
│   └── themes/
│       ├── light_theme.dart
│       └── dark_theme.dart
└── routes/
    └── app_routes.dart                # Route definitions
```

## Firestore Data Structure

```
companies/
├── {companyId}
│   ├── name: string
│   ├── createdAt: timestamp
│   └── employees/ (subcollection)
│       └── {employeeId}
│           ├── name: string
│           ├── email: string
│           ├── baseSalary: number
│           └── createdAt: timestamp

users/
├── {uid}
│   ├── email: string
│   ├── role: string (admin | hr | payroll | employee)
│   ├── companyId: string (null for admin)
│   └── createdAt: timestamp

attendance/
├── {userId-date}
│   ├── userId: string
│   ├── companyId: string
│   ├── checkIn: timestamp
│   ├── checkOut: timestamp (optional)
│   └── createdAt: timestamp
```

## Key Components

### CompanyDashboardPage
The main workspace for managing a company. Features:
- **AppBar Controls**:
  - Company logo and name on the left.
  - Tab indicator in the center.
  - Theme toggle button.
  - Check-in/Check-out popup menu.
  - Profile menu (Edit Profile / Logout).

- **Vertical Navigation Rail**:
  - Employees (always visible).
  - Attendance, Payroll, Leaves tabs.
  - Settings tab (admin only).

### EmployeesTabContent
Admin-only features:
- Add Employee dialog with name, email, base salary.
- Edit Employee dialog to update details.
- Delete Employee with confirmation.
- Employee cards in a 3-column grid layout.

## Role Permissions

| Feature | Admin | HR Officer | Payroll Officer | Employee |
|---------|-------|-----------|-----------------|----------|
| Create/Edit/Delete Employee | ✓ | ✓ | - | - |
| View Attendance | ✓ | ✓ | ✓ | Own only |
| Approve Leaves | ✓ | ✓ | ✓ | - |
| View Payroll | ✓ | - | ✓ | - |
| Generate Payslips | ✓ | - | ✓ | - |
| Edit Settings | ✓ | - | - | - |

## HRMS Terminology

- **Payroll:** Process of calculating and distributing employee salaries, wages, bonuses, and deductions based on attendance.
- **Payslip:** Official document showing detailed breakdown of earnings, deductions, and net pay.
- **Payrun:** A specific payroll cycle or period during which salaries are processed and paid.
- **Time-Off:** Period where an employee is officially permitted to be absent (vacation, sick leave, personal leave).
- **Wage:** Monetary compensation paid to an employee for work during a specific period.
- **PF Contribution:** Retirement benefit scheme (typically 12% of basic salary from both employee and employer).
- **Professional Tax:** Small monthly tax levied by state government on individuals earning through employment.

## Next Steps

1. **Implement Attendance Tab**:
   - Calendar view of attendance records.
   - Monthly/daily summaries.

2. **Implement Leave Management**:
   - Leave application form.
   - Approval/rejection workflows.
   - Leave balance tracking.

3. **Implement Payroll Tab**:
   - Payrun creation and processing.
   - Automatic salary calculation (base + PF + tax deductions).
   - Payslip generation and download.

4. **Implement Analytics Dashboard**:
   - Attendance metrics and charts.
   - Leave utilization summary.
   - Payroll trends and reports.

## Tech Stack

| Layer        | Technology |
|--------------|------------|
| Frontend     | Flutter Web |
| State Mgmt   | Provider |
| Backend/DB   | Firebase (Auth, Firestore) |
| Deployment   | Firebase Hosting, Netlify, Vercel, or similar |

## License  
Open source, available under the MIT license for personal and educational use.

## Support
For issues or feature requests, please submit a GitHub issue or reach out to the maintainers.



