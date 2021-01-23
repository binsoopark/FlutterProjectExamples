import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'place.dart';
import 'picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final Place place;
  CameraScreen(this.place);

  @override
  _CameraScreenState createState() => _CameraScreenState(this.place);
}

class _CameraScreenState extends State<CameraScreen> {
  final Place place;
  CameraController _controller;
  List<CameraDescription> cameras;
  CameraDescription camera;
  Widget cameraPreview;
  Image image;

  _CameraScreenState(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Take Picture'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                final path = join(
                  (await getTemporaryDirectory()).path, '${DateTime.now()}.png',);
                // 사진을 찍고, 저장된 위치를 기록합니다
                XFile xFile = await _controller.takePicture();
                xFile.saveTo(path);
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => PictureScreen(path, place)
                );
                Navigator.push(context, route);

              },
            )
          ],
        ),
        body: Container(
          child: cameraPreview,
        )
    );
  }

  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras.length != 0) {
      camera = cameras.first;
    }
  }

  @override
  void initState() {
    setCamera().then((_) {
      _controller = CameraController(
// 사용 가능한 카메라 목록에서 특정 카메라를 가져옵니다
        camera,
// 사용할 해상도를 정의합니다
        ResolutionPreset.medium,
      );
      _controller.initialize().then((snapshot) {
        cameraPreview = Center(child: CameraPreview(_controller));
        setState(() {
          cameraPreview = cameraPreview;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
