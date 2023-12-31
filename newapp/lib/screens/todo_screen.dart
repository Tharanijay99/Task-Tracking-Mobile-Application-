import 'package:flutter/material.dart';
import 'package:newapp/modules/category.dart';
import 'package:newapp/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:newapp/services/todo_service.dart';

import '../modules/todo.dart';

class TodoScreen extends StatefulWidget {
  

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoService ? _todoService;
  List<Todo> _todoList = <Todo>[];
  var _todoTitleController = TextEditingController();
  
  var _todoDescriptionController = TextEditingController();
  
  var _todoDateController = TextEditingController();
  
  var _selectedValue;
  
  var _categories = <DropdownMenuItem>[];
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  getAllTodos() async{
    _todoService = TodoService();
    _todoList = <Todo>[];

  var todos = await _todoService?.readTodos();

  todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);

      });
  });
  }


  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category['name']),
        value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async{
    var _pickedDate = await showDatePicker(
      context: context, 
      initialDate: _dateTime, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100));

    if(_pickedDate!=null){
      setState(() {
        _dateTime= _pickedDate;
        _todoDateController.text=DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

   _showsuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Remind me Title'
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write Remind me Description'
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Choose a Date',
                prefixIcon: InkWell(
                  onTap: (){
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: Text('Category'),
              onChanged: (value){
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: ()async{
              var todoObject = Todo();
              
              todoObject.title = _todoTitleController.text;
              todoObject.description=_todoDescriptionController.text;
              todoObject.isFinished= 0;
              todoObject.category=_selectedValue.toString();
              todoObject.todoDate = _todoDateController.text;

              var _todoService = TodoService();
              var result = await _todoService.saveTodo(todoObject);

              if(result>0){
                _showsuccessSnackBar(Text('created'));
                getAllTodos();
                Navigator.pop(context);
              }
              print(result);
            }, 
            child: Text('save'), )
          ],
        ),
      ),
    );
  }
}