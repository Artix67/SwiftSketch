# SwiftSketch
### PnP Final

## Introduction
SwiftSketch is a standalone drawing tool tailored for small to mid-sized construction companies and contractors who need a fast, intuitive way to create on-site sketches and designs. It’s designed for professionals in landscaping and hardscaping who may not be advanced technology users but are comfortable with mobile devices and apps. SwiftSketch provides a simple interface to create architectural drawings associated with product layers, making it easy for sales teams to present dynamic pricing options on the spot.

Engineers on this project should focus on delivering a responsive, user-friendly experience that allows users to create and edit designs quickly with minimal steps. Core functionalities include essential drawing tools, shape templates, and the ability to layer products over designs while maintaining high performance and reliability. SwiftSketch will eventually integrate with the broader suite of construction-focused apps, pulling in data like product details and pricing for seamless updates during client presentations. The app operates independently now, providing a specialized tool for sketching and design needs.


### Team:
Taylor Ogburn - jtogburn@gmail.com

Robert Sanders - robert.sanders67@gmail.com

Cameron Gwinn - camerongwinn1990@gmail.com

Daniel Eldridge - mervhd@gmail.com

## Features

### Minimum Viable Product (A Features) - In Progress
1. The user can draw using a simple, drag-and-drop interface with line tools.
1. The user will have access to a toolbar containing essential drawing tools.
1. The user can zoom in and out of their drawing for detailed adjustments.
1. The user will be able to pan (scroll) around their drawing with ease.
1. The user can customize stroke color and thickness for all drawing tools.
1. The user can save preset colors and stroke thicknesses for frequent use.
1. Users can access a basic shape library, including squares, circles, rectangles, triangles, and polygons.
1. For precise placement, the user can snap lines and shapes to points or grids.
1. The user can apply a grid overlay with 10px increments and snap objects within 20px.
1. Users can add labels to their drawings with customizable font styles and sizes.
1. The user can save, load, delete, and modify drawings stored locally on the device using SwiftData.
1. The user will have access to essential measurement tools, allowing length and area annotations on shapes.
1. Users can export their drawings as PDF files for easy sharing and documentation.

### Alpha (B Features) - Coming Soon...
1. The user can create layered drawings, distinguishing between materials like concrete and grass.
1. The user will have access to pre-made templates for common project types, such as patios and driveways.
1. Users can add detailed annotations or material lists as popovers within their drawings.
1. The user will be able to save different variations of a project as “Options” for easy comparison.
1. Users can add GPS location metadata to their drawings, marking addresses and coordinates.
1. The user can store frequently used shapes for reuse in future projects.

### Beta  (C Feature) - Coming Soon...
1. The user can overlay their drawing on top of an image taken from the camera for reference.
1. The user can attach photos to specific locations within the drawing, viewable as popovers.
1. The user will have customizable toolbars for quicker access to preferred tools.
1. The user will have the option for multi-device collaboration, enabling two users to work on the same drawing in real time.
1. The user can export drawings in various file formats beyond PDF.
1. The user can overlay satellite images on the drawing for accurate tracing and layout.

## Technologies
SwiftSketch utilizes the following technologies:
- **Flutter**: Primary framework for building a consistent and high-quality user interface across iOS and Android platforms.
- **Dart**: The programming language is optimized for performance and easy cross-platform compilation.
- **Firebase**: Supports cloud storage, synchronization, and user authentication across both platforms.
- **Google Maps API**: Provides GPS metadata, satellite image overlays, and geographic context.
- **Zapier API**: Enables automation and integration with other construction industry software.
- **Algolia**: Offers powerful search capabilities within the app.

## Installation
To install SwiftSketch:
1. Download the app from the iOS App Store or Google Play Store.
2. Open the app and follow the on-screen instructions to sign in or explore in Guest Mode.
3. Begin creating and managing your architectural drawings on your mobile device.

### For new users
The app is designed for intuitive use, with a simple interface that allows for immediate sketching and design after installation.

## Development Setup
For developers interested in setting up SwiftSketch for development:
1. **Environment Setup**: Ensure you have Flutter and Dart installed.
2. **Clone the Repository**: `git clone https://github.com/SwiftSketch/SwiftSketch.git`
3. **Install Dependencies**: Run `flutter pub get` in the project directory.
4. **Run the Application**: Use `flutter run` to start the app on an emulator or physical device.

## License
SwiftSketch is released under the MIT License, encouraging wide usage and collaborative improvement.

## Contributors
- Taylor Ogburn
- Robert Sanders
- Cameron Gwinn
- Daniel Eldridge

## Project Status
SwiftSketch is currently in the **Alpha** phase, with ongoing development to add new features and enhance stability.
