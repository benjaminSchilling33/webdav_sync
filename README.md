# webdav_sync
A webdav sync CLI application written in Dart.

This application is not running as a daemon.
To regularly sync files, set up a cron job or similar.

## Command-line Usage

```bash
> dart run webdav_sync --help
-h, --[no-]help         Print this help text.
-f, --[no-]fetchOnly    Only fetch files, don`t upload, usually used for back-up use cases.
-u, --baseUrl           WebDav server base URL.
-r, --webDir            WebDav directory for file sync.
-t, --targetDir         Directory that will be synced with webDir directory.
-d, --[no-]daemonize    Run the application as a daemon, regularly checking for new files.
-i, --interval          Sync interval in minutes if running as daemon.
```

## Building the application