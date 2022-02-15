import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load, env;

import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:webdav_sync/webdav_directory.dart';
import 'package:webdav_sync/webdav_file.dart';

void syncFiles(String baseUrl, String webDir, String targetDir) async {
  // Read username & password from file
  load();
  String username = env['USERNAME']!;
  String password = env['PASSWORD']!;
  webdav.Client client = webdav.newClient(baseUrl,
      user: username, password: password, debug: false);

  // Get all files
  WebDavDirectory tld = await getFilesInDirRecursively(
      client, webDir, webdav.File(isDir: true, path: '/', eTag: ''));

  await fetchFilesRecursively(client, tld, targetDir);

  print(jsonEncode(tld.toJson()));
  await File('$targetDir/webdav_sync_meta_data.json')
      .writeAsString(jsonEncode(tld.toJson()));
}

Future fetchFilesRecursively(
    webdav.Client client, WebDavDirectory directory, String targetDir) async {
  for (WebDavFile f in directory.files) {
    print(
        'fetching file: ${f.webDavFile.name} to $targetDir${f.webDavFile.path} - ETag: ${f.webDavFile.eTag}');
    await client.read2File(
        f.webDavFile.path!, '$targetDir${f.webDavFile.path}');
  }

  for (WebDavDirectory d in directory.directories) {
    print('creating directory: $targetDir${d.self.path}');
    await Directory('$targetDir${d.self.path}').create();
    await fetchFilesRecursively(client, d, targetDir);
  }
}

Future<WebDavDirectory> getFilesInDirRecursively(
    webdav.Client client, String webDir, webdav.File thisFile) async {
  WebDavDirectory wdd = WebDavDirectory(
      directories: List.empty(growable: true),
      files: List.empty(growable: true),
      self: thisFile);

  List<webdav.File> files = await client.readDir(webDir);
  for (webdav.File f in files) {
    if (f.isDir != null && f.isDir == true) {
      wdd.directories.add(await getFilesInDirRecursively(client, f.path!, f));
    } else {
      wdd.files.add(WebDavFile(webDavFile: f));
    }
  }
  return wdd;
}
