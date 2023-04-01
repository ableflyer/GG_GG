import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;

class oyoCamera extends StatelessWidget {
  final List<CameraDescription> cameras;

  oyoCamera(this.cameras);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movenet Widget"),
      ),
      body: Stack(
        children: [
          CameraPreview(CameraController(cameras[0], ResolutionPreset.medium)),
          StreamBuilder<dynamic>(
            stream: _poseStream(),
            builder: (context, snapshot) {
              return CustomPaint(
                painter: _PosePainter(snapshot.data),
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<dynamic> _poseStream() async* {
    CameraController controller = CameraController(
        cameras[0], ResolutionPreset.medium);
    await controller.initialize();

    await Tflite.loadModel(
      model: "assets/lite-model_movenet_singlepose_lightning_3.tflite",
      numThreads: 1,
      isAsset: true,
    );

    yield* Stream.periodic(Duration(milliseconds: 100)).asyncMap((_) async {
      try {
        final img = await controller.takePicture();
        final imgBytes = await img.readAsBytes();
        final decodedImage = imglib.decodeImage(imgBytes);

        final croppedImage = imglib.copyCrop(decodedImage!, 0, 0, 192, 192);
        final inputImage = croppedImage.getBytes();

        final inputShape = [1, 192, 192, 3];
        final outputShape = [1, 1, 17, 3];

        await Tflite.runModelOnBinary(
          binary: inputImage,
          inputShape: inputShape,
          outputShape: outputShape,
          threshold: 0.4,
        );

        final pose = Tflite.getOutputTensor(0);

        return pose;
      } catch (e) {
        print(e);
        return null;
      }
    });
  }
}

class _PosePainter extends CustomPainter {
  final dynamic _pose;

  _PosePainter(this._pose);

  @override
  void paint(Canvas canvas, Size size) {
    if (_pose == null) {
      return;
    }

    final pose = _pose[0][0];

    final edges = {
      [0, 1]: 'm',
      [0, 2]: 'c',
      [1, 3]: 'm',
      [2, 4]: 'c',
      [0, 5]: 'm',
      [0, 6]: 'c',
      [5, 7]: 'm',
      [7, 9]: 'm',
      [6, 8]: 'c',
      [8, 10]: 'c',
      [5, 6]: 'y',
      [5, 11]: 'm',
      [6, 12]: 'c',
      [11, 12]: 'y',
      [11, 13]: 'm',
      [13, 15]: 'm',
      [12, 14]: 'c',
      [14, 16]: 'c'
    };

    final confidenceThreshold = 0.4;
    final keypoints = pose
        .map((kp) => [
        kp['x'],
        kp['y'],
        kp['confidence']
        ])
        .toList();
    // Draw keypoints
    for (var i = 0; i < keypoints.length; i++) {
      final kp = keypoints[i];

      if (kp[2] < confidenceThreshold) {
        continue;
      }

      final paint = Paint()
        ..color = _getColorFromKeypointIndex(i)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(
          Offset(kp[0] * size.width, kp[1] * size.height), 10, paint);
    }

// Draw edges
    for (final edge in edges.entries) {
      final i1 = edge.key[0];
      final i2 = edge.key[1];
      final color = _getColorFromEdgeType(edge.value);

      final kp1 = keypoints[i1];
      final kp2 = keypoints[i2];

      if (kp1[2] < confidenceThreshold || kp2[2] < confidenceThreshold) {
        continue;
      }

      final paint = Paint()
        ..color = color
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
          Offset(kp1[0] * size.width, kp1[1] * size.height),
          Offset(kp2[0] * size.width, kp2[1] * size.height),
          paint);
    }
  }

  Color _getColorFromKeypointIndex(int index) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
      Colors.lime,
      Colors.amber,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.lightGreenAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.yellowAccent
    ];
    return colors[index % colors.length];
  }
  Color _getColorFromEdgeType(String type) {
    switch (type) {
      case 'm':
        return Colors.red;
      case 'c':
        return Colors.green;
      case 'y':
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}