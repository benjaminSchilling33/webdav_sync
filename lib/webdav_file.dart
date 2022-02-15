import 'package:webdav_client/webdav_client.dart' as webdav;

class WebDavFile {
  webdav.File webDavFile;

  WebDavFile({required this.webDavFile});

  Map<String, dynamic> toJson() {
    return {
      'isDir': webDavFile.isDir,
      'path': webDavFile.path,
      'etag': webDavFile.eTag,
    };
  }
}
