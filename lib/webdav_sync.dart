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
  WebDavDirectory tld =
      await getFilesInDirRecursively(client, webDir, webdav.File());

  await fetchFilesRecursively(client, tld, targetDir);
}

Future fetchFilesRecursively(
    webdav.Client client, WebDavDirectory directory, String targetDir) async {
  for (WebDavFile f in directory.webDavFiles) {
    print(
        'fetching file: ${f.webDavFile.name} to $targetDir/${f.webDavFile.path}');
    await client.read2File(
        f.webDavFile.path!, '$targetDir/${f.webDavFile.path}');
  }

  for (WebDavDirectory d in directory.subDirectories) {
    print('creating directory: $targetDir${d.webDavFile.path}');
    await Directory('$targetDir${d.webDavFile.path}').create();
    await fetchFilesRecursively(client, d, targetDir);
  }
}

Future<WebDavDirectory> getFilesInDirRecursively(
    webdav.Client client, String webDir, webdav.File thisFile) async {
  WebDavDirectory wdd = WebDavDirectory(
      subDirectories: List.empty(growable: true),
      webDavFiles: List.empty(growable: true),
      webDavFile: thisFile);

  List<webdav.File> files = await client.readDir(webDir);
  for (webdav.File f in files) {
    if (f.isDir!) {
      wdd.subDirectories
          .add(await getFilesInDirRecursively(client, f.path!, f));
    } else {
      wdd.webDavFiles.add(WebDavFile(webDavFile: f));
    }
  }
  return wdd;
}
