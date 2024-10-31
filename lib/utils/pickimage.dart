import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  final image = FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}

Future<FilePickerResult?> pickPost() async {
  final image = FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4']);
  return image;
}
