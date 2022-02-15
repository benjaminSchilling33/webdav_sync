import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:webdav_sync/webdav_file.dart';

class WebDavDirectory {
  List<WebDavDirectory> directories;
  List<WebDavFile> files;

  webdav.File self;

  WebDavDirectory({
    required this.directories,
    required this.files,
    required this.self,
  });

  Map<String, dynamic> toJson() {
    List jsonDirs = List.empty(growable: true);
    for (WebDavDirectory dir in directories) {
      jsonDirs.add(dir.toJson());
    }

    List jsonFiles = List.empty(growable: true);
    for (WebDavFile file in files) {
      jsonFiles.add(file.toJson());
    }
    return {
      'isDir': self.isDir,
      'path': self.path,
      'etag': self.eTag,
      'directories': jsonDirs,
      'files': jsonFiles,
    };
  }
}
