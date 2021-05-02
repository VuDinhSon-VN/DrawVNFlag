import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Center(
          child: CustomPaint(
            painter: MyCustomPaint(100),
            size: Size(300, 200),
          ),
        ),
      )
    );
  }
}

class MyCustomPaint extends CustomPainter{
  final double radius;

  MyCustomPaint(this.radius);
   
  @override
  void paint(Canvas canvas, Size size) {
     //diện tích lá cờ
     final double width = size.width;
     final double height = size.width*2/3; 
     final double r = width/5;
     
     //tạo màu cho lá cờ
     final Paint redPaint = Paint()
     ..color = Colors.red
     ..style = PaintingStyle.fill;

       //vẽ lá cờ 
     canvas.drawRect(Rect.fromLTRB(0,0, width, height), redPaint);

      //cấu hình 5 điểm của ngôi sao
      //Ta có: OA = OB = OC = OD = OE = r nên ta tìm được ngay tọa độ điểm A (0, r)A(0,r)
      // 5 điểm A, B, C, D, E tạo ra 5 dây cung bằng nhau nên tạo ra 5 góc ở tâm bằng nhau. 
      // Vì vậy ta có thể tính được góc AOB = 360° / 5 = 72° 
      // Từ đó ta tính được |xB| = FB = OB * sin(72°) và ∣yB∣ = OF = OB * cos(72°).
      // Vì điểm B nằm ở góc phần tư thứ nhất (chiều dương Ox và chiều dương Oy) 
      // nên tọa độ điểm B (r * sin(72°), r * cos(72°))B(r∗sin(72°),r∗cos(72°))
      // Vì điểm E đối xứng với điểm B qua Oy nên ta tìm được luôn tọa độ điểm E(−xB,yB)
      // Kẻ OG vuông góc với CD => OG vừa là đường cao vừa là tia phân giác của góc COD => góc COG = 72/2 = 36 độ
      // Từ đó ta tính được |xC|= GC = OC*sin(36) và |yC| = OG = OC * cos(36°). 
      // Vì điểm C nằm ở góc phần tư thứ IV (chiều dương Ox, chiều âm Oy) 
      // nên tọa độ điểm C (r * sin(36°), -r * cos(36°))C(r∗sin(36°),−r∗cos(36°)) 
      // Vì điểm D đối xứng với điểm C qua Oy nên ta tìm được tọa độ điểm D (-xC, yC).
      final pointA = Offset(0, -r);
      final pointB = Offset(r * sin(72.toRadian()), -r * cos(72.toRadian()));
      final pointC = Offset(r * sin(36.toRadian()), r * cos(36.toRadian()));
      final pointD = Offset(-pointC.dx, pointC.dy); 
      final pointE = Offset(-pointB.dx, pointB.dy); 

      //vẽ ngôi sao
     final Path path = Path()
     //di chuyển tạo độ bắt đầu từ (0,0) đến tọa độ bắt đầu vẽ
     ..moveTo(pointA.dx, pointA.dy)
     //bắt đầu vẽ nối 5 điểm
     ..lineTo(pointC.dx, pointC.dy)
     ..lineTo(pointE.dx, pointE.dy)
     ..lineTo(pointB.dx, pointB.dy)
     ..lineTo(pointD.dx, pointD.dy)
     ..close();

     final Paint yellowPaint = Paint()
     ..color = Colors.yellow
     ..style = PaintingStyle.fill;
     
    //tọa độ tính toán của tâm ngôi sao
    final point0 = Offset(0, 0);

    //tọa độ thật của tâm ngôi sao
    final pointI = Offset(width/2, height/2);

    //vector tịnh tiến IO
    final translateVector = pointI - point0;

    //thực hiện phép tính tịnh tiến
    final realPath = path.shift(translateVector); 

     canvas.drawPath(realPath, yellowPaint);
    }
  
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
  
}
//Vì hàm sin, cos trong thư viện dart:math của Dart sử dụng đơn vị radian 
//nên trước tiên ta cần viết một extension function cho phép chuyển đổi đơn vị độ sang đơn vị radian.
extension NumberUtil on num{
  num toRadian(){
    return this * pi/180;
  }
}