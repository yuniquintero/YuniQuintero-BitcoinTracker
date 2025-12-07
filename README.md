# YuniQuintero-BitcoinTracker

Bitcoin price history for the last two weeks and detail viewer for USD, EUR and GBP currencies built with SwiftUI.

## How to run
- Requirements: Xcode 15+ (iOS Simulator target set to iOS 15.6+ per project settings) and Swift 5.
- Open `YuniQuintero-BitcoinTracker.xcodeproj` in Xcode.
- Select the `YuniQuintero-BitcoinTracker` scheme and press Run to launch on the simulator.
- To run on a physical device: connect an iOS device (15.6+), pick it as the run destination in Xcode, then Run.

## API configuration
- The Coingecko base URL `https://api.coingecko.com/api/v3/coins/bitcoin` and endpoints live in `Core/Networking/Endpoints.swift`.
- The API key and header field are defined in `APIConstants` (`Endpoints.swift`). Update `apiKey` and `apiHeaderField` there if you need different credentials or headers.
- For fetching price history over a specified interval, the endpoint used was `/market_chart`.
- For fetching price details for a specific date, the endpoint used was `/history`.

## Tests
- Unit tests live in `YuniQuintero-BitcoinTrackerTests/YuniQuintero_BitcoinTrackerTests.swift`.

## Solution description
- Architecture: lightweight MVVM with SwiftUI. Views stay declarative, focusing only on layout and navigation, view models own state changes, data fetching async methods and data formatting, and services isolate networking behavior. MVVM was chosen because it is easy to test and iterate without tangling UI with API calls, also, due to the size of this project.
- `PriceListViewModel` manages price history list and detail fetching when selecting a row, tracks state (`idle/loading/loaded/failed`), and formats dates for UI (`MMM d, yyyy`) and API (`yyyy-MM-dd`).
- `PriceListView` shows the history list with reusable view component `PriceRowView`, overlays a loading indicator, and shows fetching errors via alert with retry option.
- `PriceDetailViewModel` carries the selected date and detail payload to the view; `PriceDetailView` renders it.
- Networking: `APIClient` builds GET requests and decodes responses; `BitcoinPriceService` composes endpoints/params structure from `Endpoints.swift`; view models depend on the service protocol so tests can inject `MockBitcoinPriceService`.
