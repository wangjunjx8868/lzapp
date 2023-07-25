import 'dart:io';
import 'dart:typed_data';
class UploadPoint {
  bool isSelectedFile=false;
  File? compressFile;
  Uint8List? ut8l;
  String fileName="";
  UploadPoint(this.isSelectedFile,this.compressFile);
}
