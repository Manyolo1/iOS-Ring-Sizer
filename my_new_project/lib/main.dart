import 'package:flutter/material.dart';

void main() => runApp(FingerSizerApp());

class FingerSizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        
      ),
      home: FingerSizerScreen(),
    );
  }
}

class FingerSizerScreen extends StatefulWidget {
  @override
  _FingerSizerScreenState createState() => _FingerSizerScreenState();
}

class _FingerSizerScreenState extends State<FingerSizerScreen> {
  double _fingerWidth = 4.0;  // Starting size set to 8 units
  double _minWidth = 1.0;     // Adjusted minimum width
  double _maxWidth = 8.0;    // Adjusted maximum width

  void _updateFingerWidth(double newWidth) {
    setState(() {
      _fingerWidth = newWidth.clamp(_minWidth, _maxWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            SizedBox(height: 20),
            Expanded(
              
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Choose the thickness\nof your finger',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Place your finger and adjust its\nsize along the borders',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                            
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomPaint(
                                  painter: FingerSizePainter(_fingerWidth, _minWidth, _maxWidth),
                                  size: Size(constraints.maxWidth, constraints.maxHeight),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text('Stop measurement'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Measurement Stopped"),
                                  content: Text(
                                    "Your finger width: ${_fingerWidth.toStringAsFixed(2)} units",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Okay"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 10,
                            activeTrackColor: Colors.orange,
                            inactiveTrackColor: Colors.orange.withOpacity(0.4),
                            thumbColor: Colors.orange,
                            overlayColor: Colors.orange.withOpacity(0.4),
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                          ),
                          child: Slider(
                            value: _fingerWidth,
                            min: _minWidth,
                            max: _maxWidth,
                            onChanged: _updateFingerWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}

class FingerSizePainter extends CustomPainter {
  final double fingerWidth;
  final double minWidth;
  final double maxWidth;

  FingerSizePainter(this.fingerWidth, this.minWidth, this.maxWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double rectangleHeight = size.height * 0.8;
    final double rectangleWidth = (fingerWidth / maxWidth) * size.width * 0.4;
    final double left = (size.width - rectangleWidth) / 2;
    final double top = (size.height - rectangleHeight) / 2;

    // Calculate corner radius based on the width of the rectangle
    final double cornerRadius = rectangleWidth * 0.2;

    // Draw rounded rectangle for finger measurement
    final RRect fingerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, rectangleWidth, rectangleHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(fingerRRect, paint);

    // Draw finger area with fill
    final fingerPaint = Paint()
      ..color = Colors.orange.withOpacity(1.0)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(fingerRRect, fingerPaint);
  }

  @override
  bool shouldRepaint(FingerSizePainter oldDelegate) => fingerWidth != oldDelegate.fingerWidth;
}