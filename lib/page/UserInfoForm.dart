import 'package:flutter/material.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  bool _saveData = false; // ตัวเลือกบันทึกข้อมูล

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_saveData) {
        // Logic สำหรับบันทึกข้อมูลลง DB
        print('บันทึกข้อมูล: $_name');
      } else {
        // กรณีไม่บันทึกข้อมูล
        print('ไม่ได้บันทึกข้อมูล');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลเบื้องต้น'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อ'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('ต้องการบันทึกข้อมูล'),
                value: _saveData,
                onChanged: (value) {
                  setState(() {
                    _saveData = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
