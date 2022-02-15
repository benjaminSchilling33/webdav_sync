import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:webdav_sync/webdav_file.dart';

class WebDavDirectory {
  List<WebDavDirectory> subDirectories;
  List<WebDavFile> webDavFiles;

  webdav.File webDavFile;

  WebDavDirectory({
    required this.subDirectories,
    required this.webDavFiles,
    required this.webDavFile,
  });
}
