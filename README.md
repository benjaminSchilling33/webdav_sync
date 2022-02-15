# webdav_sync
A webdav sync CLI application written in Dart.

## Implemented features

| Feature                            | Status |
| ---------------------------------- | ------ |
| Fetch only                         | X      |
| Incremental sync (comparing ETags) |        |
| Daemonize                          |        |
| Bi-directional sync                |        |


## Command-line Usage

```bash
> dart run webdav_sync --help
-h, --[no-]help           Print this help text.
-f, --[no-]fetchOnly      Only fetch files, don`t upload, usually used for back-up use cases.
-u, --baseUrl             WebDav server base URL.
-r, --webDir              WebDav directory for file sync.
-t, --targetDir           Directory that will be synced with webDir directory.
-c, --[no-]incremental    Download files only if they have changed.
                          Stores a JSON file with meta-data besides the files in the directory given by targetDir.
-d, --[no-]daemonize      Run the application as a daemon, regularly checking for new files.
-i, --interval            Sync interval in minutes if running as daemon.
```

## Run for development purposes

E.g.:
```bash
dart run webdav_sync --fetchOnly --baseUrl "<URL to your webdav server>" --webDir "<Directory to be synced>" --targetDir "<Path to local target directory>"
```

## Building a stand-alone executable

Windows:
```bash
dart compile exe bin/webdav_sync.dart -o bin/webdav_sync.exe
```

Linux
```bash
dart compile exe bin/webdav_sync.dart -o bin/webdav_sync
```