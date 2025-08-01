# expenses_snap_app

Flutter App that lets you capture your expenses image then generate the information

## Features

- Add expenses manually through a form
- Take pictures of bills to create expenses
- View expenses in a table format
- Categorize expenses as "Need" or "Desire"

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development

### Camera Access

The app uses the device camera to capture bill images. For this to work properly, the following permissions are required:

- **Android**: Camera permission in AndroidManifest.xml
- **iOS**: Camera usage description in Info.plist

These permissions are already included in the project files, but if you're forking this project, make sure they are present.

### Git Hooks

This project uses git hooks to enforce code quality before commits and pushes. The hooks are located in the `git-hooks` directory.

#### Setting Up Git Hooks

Git hooks are not automatically enabled when you clone a repository. To set up the hooks, you need to:

1. Make the hook scripts executable (on Unix-based systems):
   ```bash
   chmod +x git-hooks/*
   ```

2. Configure Git to use the hooks from the `git-hooks` directory:
   ```bash
   git config core.hooksPath git-hooks
   ```

#### Available Hooks

- **pre-push**: Runs all Flutter tests before allowing a push to the repository. If any tests fail, the push will be aborted.

#### Running Hooks Manually

You can also run the hooks manually:

```bash
sh git-hooks/pre-push
```

#### Bypassing Hooks

In case you need to bypass a hook (not recommended for regular development):

```bash
git push --no-verify
```

### Running Tests

To run all tests manually:

```bash
flutter test
