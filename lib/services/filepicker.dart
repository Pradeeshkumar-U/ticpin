import 'package:file_picker/file_picker.dart';

class FileHandler{
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      
    );
    return result;
  }

  Future uploadFile() async {
    // Your file upload logic here
  }
}