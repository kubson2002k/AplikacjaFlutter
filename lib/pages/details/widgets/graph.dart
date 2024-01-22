import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SizedBox(
        width: double.infinity,
        child: GraphArea(),
      ),
    );
  }
}

class GraphArea extends StatefulWidget {
  const GraphArea({super.key});

  @override
  State<GraphArea> createState() => _GraphAreaState();
}

class _GraphAreaState extends State<GraphArea> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;


  List<DataPoint> data = [
    DataPoint(day: 1, steps: Random().nextInt(100)),
    DataPoint(day: 2, steps: Random().nextInt(100)),
    DataPoint(day: 3, steps: Random().nextInt(100)),
    DataPoint(day: 4, steps: Random().nextInt(100)),
    DataPoint(day: 5, steps: Random().nextInt(100)),
    DataPoint(day: 6, steps: Random().nextInt(100)),
    DataPoint(day: 7, steps: Random().nextInt(100)),
    DataPoint(day: 8, steps: Random().nextInt(100)),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = 
      AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GraphPainter(_animationController.view, data: data),
    );
  }
}
class GraphPainter extends CustomPainter {
  final List<DataPoint> data;
  final Animation<double> _size;

  GraphPainter(Animation<double> animation, {required this.data})
     : _size = Tween<double>(begin: 0, end: 1).animate(animation),
      super(repaint: animation);


  @override
  void paint(Canvas canvas, Size size) {    
    var xSpacing = size.width / (data.length -1);

    var  maxSteps = data
      .fold<DataPoint>(data[0], (p, c) => p.steps > c.steps ? p : c)
      .steps;

    var yRatio = size.height / maxSteps;
    var curveOffset = xSpacing * 0.3;

    List<Offset> offsets = [];
    
    var cx = 0.0;
    for(int i=0; i < data.length; i++){
      
      var y = size.height - (data[i].steps * yRatio * _size.value);

      offsets.add(Offset(cx, y));
      cx += xSpacing;
    }

    Paint linePaint = Paint()
      ..color = const Color(0xff30c3f9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    Paint shadowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.solid, 3)
      ..strokeWidth = 3.0;

    Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2,0), 
        Offset(size.width / 2, size.height), 
        [
          const Color(0xff30c3f9),
          Colors.white,
        ],
        )
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Paint dotOutlinePaint = Paint()
      ..color = Colors.white.withAlpha(200)
      ..strokeWidth = 9;

    Paint dotCenter = Paint()
      ..color = const Color(0xff30c3f9)
      ..strokeWidth = 8;

    Path linePath = Path();

    Offset c0ffset = offsets[0];

    linePath.moveTo(c0ffset.dx, c0ffset.dy);

    for(int i = 1; i < offsets.length; i++){
      var x = offsets[i].dx;
      var y = offsets[i].dy;
      var c1x = c0ffset.dx + curveOffset;
      var c1y = c0ffset.dy; 
      var c2x = x - curveOffset;
      var c2y = y;

      linePath.cubicTo(c1x, c1y, c2x, c2y, x,y); 
      c0ffset = offsets[i];
    }

    Path fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, shadowPaint);
    canvas.drawPath(linePath, linePaint);
    canvas.drawCircle(offsets[4], 12, dotOutlinePaint);
    canvas.drawCircle(offsets[4], 5, dotCenter);
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return data != oldDelegate.data;
  }

}


class DataPoint {
  final int day;
  final int steps;

  DataPoint({
    required this.day,
    required this.steps,
  });
}