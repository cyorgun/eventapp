import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Tangsakpals extends StatefulWidget {
  ScreenshotController? screenshotController;

  Tangsakpals({super.key, this.screenshotController});

  @override
  State<Tangsakpals> createState() => _TangsakpalsState();
}

class _TangsakpalsState extends State<Tangsakpals> {
  Future<void> _captureAndShareImage() async {
    try {
      // Get application documents directory
      final directory = (await getApplicationDocumentsDirectory()).path;
      String fileName = 'Family Weekend - Ticket';

      // Capture the screenshot and save it in the documents directory
      final String? imagePath =
          await widget.screenshotController?.captureAndSave(
        directory,
        fileName: "$fileName.png",
      );

      if (imagePath != null) {
        // Share the image file
        await Share.shareXFiles([XFile('${imagePath}')],
            text: 'Check out this event ticket!');
      } else {
        print('Failed to capture screenshot.');
      }
    } catch (e) {
      print('Error capturing or sharing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: InkWell(
        onTap: () {
          _captureAndShareImage();
        },
        child: Container(
          height: 50.0,
          width: 150.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0), color: Colors.green),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.network(
                    "https://cdn-icons-png.freepik.com/256/3983/3983877.png?semt=ais_hybrid",
                    height: 40.0,
                    width: 40.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Share on WhatsApp",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
