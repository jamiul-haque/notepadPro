import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notepad/Controller/add_note_controller.dart';
import 'package:notepad/CustomFile/CustomColors/customColors.dart';
import 'package:notepad/CustomFile/CustomTextStyle/textStyle.dart';
import 'package:notepad/CustomFile/custom_toest.dart';

import 'package:notepad/Service/date_time.dart';
import 'package:notepad/model/add_note_model.dart';
import 'package:notepad/textField/custom_text_field.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final AddNoteController addNoteController = AddNoteController();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  double fontSize = 17;
  bool isBold = false;
  bool isItalic = false;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      print('Picked color ${pickerColor.value}');
    });
  }

  alartdialog() {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addNoteController.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: iconColor,
          ),
        ),
        title: const Text(
          'Add Notes',
          style: TappbarTitleStyle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                alartdialog();
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                width: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3)),
                    ],
                    color: Colors.black45,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: pickerColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.alarm,
              color: iconColor,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_validateForm()) {
                int id = await addNoteController.addNote(
                  AddNoteModel(
                      dateTime: DateTimeConvertion().datetimeToMilles(),
                      title: titleController.text,
                      content: contentController.text,
                      colorCode: pickerColor.value.toString(),
                      fontSize: fontSize,
                      isBold: isBold ? 1 : 0,
                      isItalic: isItalic ? 1 : 0),
                );
                if (id > 0) {
                  CustomTost().customToast('Succesfull');

                  Navigator.pop(context);
                } else {
                  CustomTost().customToast('Data insert fail');
                }
              } else {
                CustomTost().customToast('Please fill up empty field');
              }
            },
            icon: const Icon(
              Icons.check,
              color: iconColor,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: double.infinity,
            // color: Colors.grey,
            // height: 70,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      fontSize++;
                    });
                  },
                  icon: Icon(Icons.text_increase),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      fontSize--;
                    });
                  },
                  icon: Icon(Icons.text_decrease),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isBold) {
                        isBold = false;
                      } else {
                        isBold = true;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.format_bold,
                    color: isBold ? Colors.amber : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isItalic) {
                        isItalic = false;
                      } else {
                        isItalic = true;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.format_italic,
                    color: isItalic ? Colors.amber : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: addNoteController.entryFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleTextIField(controller: titleController, lable: 'Title'),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    color: pickerColor,
                    child: ContentTextField(
                        isItalic: isItalic,
                        isBold: isBold,
                        color: pickerColor,
                        controller: contentController,
                        fontSize: fontSize,
                        lable: 'Write something.....'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    bool _isValid = addNoteController.entryFormKey.currentState!.validate();

    if (titleController.text.isEmpty) {
      _isValid = false;
    } else if (contentController.text.isEmpty) {
      _isValid = false;
    }

    return _isValid;
  }
}
