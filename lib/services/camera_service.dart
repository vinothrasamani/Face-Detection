import 'package:image_picker/image_picker.dart';

class CameraService {
  ImagePicker _controller = ImagePicker();

  Future<XFile?> captureImage() async {
    return await _controller.pickImage(source: ImageSource.camera);
  }
}
