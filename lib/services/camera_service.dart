import 'package:image_picker/image_picker.dart';

class CameraService {
  final picker = ImagePicker();

  Future<XFile?> captureImage() async {
    return await picker.pickImage(source: ImageSource.camera);
  }
}
