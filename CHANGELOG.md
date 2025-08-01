# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-02

### Added
- Initial project setup with Flutter
- Expense form page with fields: expense name, amount, date, and type (Need/Desire)
- Home page with expense table display
- Expense input type dialog for choosing input method (manual or camera)
- Camera screen for capturing bill pictures
- Expense table component for displaying expense data
- Unit tests and widget tests for all components and pages
- Git hooks for running tests on pre-push
- Comprehensive documentation in README.md

### Changed
- Removed default Flutter counter app
- Modified ExpenseTable component to be more testable (removed Expanded widget at root)

### Fixed
- ExpenseTable styling tests to avoid brittle UI assertions
- Dialog navigation and snackbar tests for ExpenseInputTypeDialog
- Form radio button selection tests for ExpenseFormPage

## [0.1.0] - 2025-07-31

### Added
- Project initialization
- Basic app structure
- Flutter dependencies setup (intl, camera packages)
