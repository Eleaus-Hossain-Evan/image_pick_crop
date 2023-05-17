import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int quality = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(
        imageQuality: quality,
      );
    } else {
      final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: quality,
      );
      if (file != null) {
        return [file];
      } else {
        return [];
      }
    }
  }

  Future<CroppedFile?> crop({
    required String filePath,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    return await _imageCropper.cropImage(
      sourcePath: filePath,
      cropStyle: cropStyle,
      // compressQuality: 100,
      // uiSettings: [
      //   IOSUiSettings(),
      //   AndroidUiSettings(),
      // ],
    );
  }
}
