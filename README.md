# Arena Fortune Wheel

This is a project for creating a fortune wheel for drawing gadgets during [Marco Arena](https://www.linkedin.com/in/marcoarena) community events.

Made with [Flutter](https://flutter.dev/) and ❤️ by [Dario Varriale](https://www.linkedin.com/in/dario-varriale/).

## Installation and Usage

To start the project, you need to have `FVM`, the Flutter version manager, installed. If you haven't installed it yet, you can do so by following [these instructions](https://fvm.app/documentation/getting-started/installation).

Once `FVM` is installed, you can clone the project and install the correct version of Flutter with the following command:

```bash
fvm install
```

Next, you can install the project dependencies with the command:

```bash
fvm flutter pub get
```

### Starting the Application

To start the application, first run the command to generate the necessary files:

```bash
fvm dart run build_runner build
```

Finally, you can start the application with the command:

```bash
fvm flutter run
```

### Build Web App

To build the web app, run the command:

```bash
fvm flutter build web --base-href="/arena-fortune-wheel/"
```
