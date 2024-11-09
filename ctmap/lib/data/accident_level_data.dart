import 'package:ctmap/data/accident_level.dart';

List<AccidentLevel> accidentLevels = [
  AccidentLevel(
    level: 1, 
    name: 'Vụ va chạm giao thông',
    detail: 'Vụ tai nạn giao thông gây hậu quả dưới mức của vụ tai nạn giao thông gây hậu quả ít nghiêm trọng.\n'
  ),
  AccidentLevel(
    level: 2, 
    name: 'Vụ tai nạn giao thông gây hậu quả ít nghiêm trọng ',
    detail: 'Gây thương tích hoặc gây tổn hại cho sức khỏe của một người với tỷ lệ thương tật từ 11% đến dưới 61%.\nGây thương tích hoặc gây tổn hại cho sức khỏe của 02 người trở lên mà tổng tỷ lệ thương tật của những người này từ 11% đến dưới 61%;\n '
  ),
  AccidentLevel(
    level: 3, 
    name: 'Vụ tai nạn giao thông gây hậu quả nghiêm trọng ',
    detail: 'Làm chết 01 người.\nGây thương tích hoặc gây tổn hại cho sức khỏe của 01 người với tỷ lệ tổn thương cơ thể từ 61% trở lên;\n '
  ),
  AccidentLevel(
    level: 4, 
    name: 'Vụ tai nạn giao thông gây hậu quả rất nghiêm trọng ',
    detail: 'Làm chết 02 người.\nGây thương tích hoặc gây tổn hại cho sức khỏe của 02 người trở lên mà tổng tỷ lệ tổn thương cơ thể của những người này từ 122% đến 200%;\n '
  ),
  AccidentLevel(
    level: 5, 
    name: 'Vụ tai nạn giao thông gây hậu quả đặc biệt nghiêm trọng ',
    detail: 'Làm chết 03 người.\nGây thương tích hoặc gây tổn hại cho sức khỏe của 03 người trở lên mà tổng tỷ lệ tổn thương cơ thể của những người này từ 201% trở lên;\n '
  ),
];