import 'package:flutter/material.dart';
import 'package:todo_flutter_api/services/todo_service.dart';
import 'package:todo_flutter_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit ToDo' : 'Add ToDo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Sumbit'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // get the data from the form
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call Update Without todo data');
      return;
    }
    final id = todo['_id'];

    // submit updated to the server
    final isSuccess = await TodoService.updateTodo(id, body);
    // show success or fail message based on the status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updation successful');
    } else {
      showErrorMessage(context, message: 'Updation failed');
    }
  }

  Future<void> submitData() async {
    // submit data to the server
    final isSuccess = await TodoService.addTodo(body);
    // show success or fail message based on the status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Creation successful');
    } else {
      showErrorMessage(context, message: 'Creation failed');
    }
  }

  Map get body {
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
