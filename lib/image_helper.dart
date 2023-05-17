import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  ImageHelper({
    required ImagePicker? imagePicker,
    required ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();
}
