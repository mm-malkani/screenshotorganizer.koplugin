# ScreenshotOrganizer for KOReader

**ScreenshotOrganizer** is a lightweight, background-running plugin for KOReader that automatically sorts your screenshots into neat, book-titled folders. It eliminates clutter by transforming the default flat screenshot directory into an organized library.

## How it Works

The plugin monitors your screenshot directories every 10 seconds. When it detects a new screenshot, it "scrapes" the book title directly from the filename created by KOReader, cleans it up, and moves the file into a dedicated subfolder.

### The "Pretty Name" Transformation
The plugin is designed to handle messy Kindle/Calibre filenames by removing technical metadata:
* **Original Filename:** `Reader_Isles of the Emberdark - Brandon Sanderson (79).epub_p559_2026-01-07.png`
* **Organized Folder:** `Isles of the Emberdark - Brandon Sanderson`

## Features

* **Zero-Touch Automation**: Once installed, it works silently in the background. No manual triggers or menus are required.
* **Intelligent Filename Scraper**: Specifically built for Kindle devices to ensure book detection works even when system globals are unreliable.
* **Smart Title Formatting**: Automatically removes underscores, file extensions, and trailing version numbers (like `(v1)` or `(79)`).
* **Multi-Path Support**: Scans all likely Kindle storage locations, including `/mnt/us/koreader/screenshots`, `/mnt/us/screenshots`, and `/mnt/base-us/`.
* **Performance Optimized**: Uses efficient LuaJIT FFI calls for file operations to ensure zero impact on page-turn speed or battery life.

## Installation

1.  Connect your e-reader to your computer via USB.
2.  Navigate to your KOReader plugins directory (usually `koreader/plugins/`).
3.  Create a new folder named `screenshotorganizer.koplugin`.
4.  Place your `main.lua` and `_meta.lua` files inside that folder.
5.  Safely eject and restart KOReader.

## Troubleshooting

* **First Run**: After taking a screenshot, allow up to 10–15 seconds for the background loop to process the file.
* **Logs**: You can verify the plugin is active by checking the `crash.log` file in your KOReader root directory. Look for:
    `INFO ScreenshotOrganizer: Plugin Initialized (Pretty-Name Scraper)`
* **Manual Check**: Ensure the plugin is enabled under **Tools** -> **More Tools** -> **Plugin Management** in the KOReader menu.

## Compatibility

* **Devices**: Optimized for Amazon Kindle (Basic, Paperwhite, Oasis, Scribe), but compatible with any hardware running KOReader.
* **Formats**: Supports screenshots taken from EPUB, PDF, MOBI, AZW3, and DJVU.

## License

MIT - This plugin is free software. You are welcome to modify and redistribute it.