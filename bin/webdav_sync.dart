import 'package:args/args.dart';
import 'package:webdav_sync/webdav_sync.dart' as webdav_sync;

void main(List<String> arguments) {
  var parser = ArgParser();
  parser.addFlag('help', abbr: 'h', help: 'Print this help text.');
  parser.addFlag(
    'fetchOnly',
    abbr: 'f',
    help: 'Only fetch files, don`t upload, usually used for back-up use cases.',
  );
  parser.addOption(
    'baseUrl',
    abbr: 'u',
    help: 'WebDav server base URL.',
  );
  parser.addOption(
    'webDir',
    abbr: 'r',
    help: 'WebDav directory for file sync.',
  );
  parser.addOption(
    'targetDir',
    abbr: 't',
    help: 'Directory that will be synced with webDir directory.',
  );
  parser.addFlag(
    'incremental',
    abbr: 'c',
    help:
        'Download files only if they have changed.\nStores a JSON file with meta-data besides the files in the directory given by targetDir.',
  );
  parser.addFlag(
    'daemonize',
    abbr: 'd',
    help: 'Run the application as a daemon, regularly checking for new files.',
  );
  parser.addOption(
    'interval',
    abbr: 'i',
    help: 'Sync interval in minutes if running as daemon.',
  );
  ArgResults results = parser.parse(arguments);

  if (results['help'] ||
      !results.options.contains('baseUrl') ||
      !results.options.contains('webDir') ||
      !results.options.contains('targetDir')) {
    print(parser.usage);
    return;
  }

  bool fetchOnly = results['fetchOnly'];
  String baseUrl = results['baseUrl'];
  String webDir = results['webDir'];
  String targetDir = results['targetDir'];
  if (fetchOnly) {
    webdav_sync.syncFiles(baseUrl, webDir, targetDir);
  }
}
