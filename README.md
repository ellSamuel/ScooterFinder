# ScooterFinder
Part of TIER Mobile Code Challenge

Scooter finder is an iOS app with the purpose, as the name indicates, of finding a scooter nearby.


## Installation
Download or clone the project to your mac. Change the bundle identifier if needed. Hit run.


## Features

### Data
Data is fetched from the server when the app is launched. Fetched data (vehicles) is stored in phone memory. During the next launch, stored data is used to display annotations to the user while fetching new data.

### Location
The user is asked to give location permission as soon as he launches the app.
- If the user denies access, he can continue using the app, but without some functionality (nearest vehicle selection, distance to selected vehicle).
- If the user grants access, as soon as the location is received and the user didn't select any vehicle, the nearest vehicle is selected. With granted permission, a distance from the selected user is computed and displayed in the bottom view.

### Annotations
Vehicles on a map have custom views. There is a custom view also for a cluster of multiple annotations.

### Dark mode
Dark mode is supported.

### Tests
Integration tests are included.

### Network connectivity
An offline banner is displayed when the network connection is lost.


## Not complete
- Updating distance from the selected vehicle
- Compass in detail view
- Last data update info and retry button


## Credits
Icons by Icons8.
