import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<String> provinces;

  const CustomTable({Key? key, required this.provinces}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 10.0,
      dividerThickness: 1.0, 
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      columns: [
        DataColumn(
          label: Text(
            'STT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Tỉnh thành',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows: List.generate(
        provinces.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(provinces[index])),
          ],
        ),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  final List<String> provinces = ['Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách tỉnh thành'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTableTheme(
          data: DataTableThemeData(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
          ),
          child: CustomTable(provinces: provinces),
        ),
      ),
    );
  }
}
