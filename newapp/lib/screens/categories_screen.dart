import 'package:flutter/material.dart';
import 'package:newapp/modules/category.dart';
import 'package:newapp/screens/home_screens.dart';
import 'package:newapp/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categortDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  
  List<Category> _categoryList = <Category>[];
  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategortDescriptionController = TextEditingController();
  @override
  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();


  getAllCategories() async{
  _categoryList=<Category>[];
  var categories=await _categoryService.readCategories();
  categories.forEach((category){
    setState(() {
      var categoryModel=Category();
      categoryModel.name= category['name'];
      categoryModel.description= category['description'];
      categoryModel.id= category['id'];
     _categoryList.add(categoryModel);
     });
  });
 }
_editCategory(BuildContext context, categoryId) async{
  category = await _categoryService.readCategoryById(categoryId);
  setState(() {
    _editCategoryNameController.text =  category[0]['name'] ?? 'No name';
    _editCategortDescriptionController.text =
      category[0]['description'] ?? 'No Description';
  });
  _editFormDialog(context);
}

  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder:(param){
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            onPressed: () =>Navigator.pop(context), 
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: ()async{
             _category.name = _categoryNameController.text;
             _category.description = _categortDescriptionController.text;
             var result = await _categoryService.saveCategory(_category);
            if (result > 0){
              getAllCategories();
              Navigator.pop(context);
               _showsuccessSnackBar(Text('Saved'));
             }

            }, 
            child: Text('Save'),
          ),
        ],
        title: Text('Categories form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category'
                ),
              ),
              TextField(
                controller: _categortDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description'
                ),
              )
            ],
          ),
        ),
      );
    } );
  }

  _editFormDialog(BuildContext context){
    return showDialog(
      context: context, 
      barrierDismissible: true, 
      builder:(param){
        return AlertDialog(
        actions: <Widget>[
          TextButton(
            onPressed: () =>Navigator.pop(context), 
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: ()async{
             _category.id =  category[0]['id'];
             _category.name = _editCategoryNameController.text;
             _category.description = _editCategortDescriptionController.text;
             var result = await _categoryService.updateCategory(_category);
             if (result > 0){
              Navigator.pop(context);
              getAllCategories();
              _showsuccessSnackBar(Text('Updated'));
             }


            }, 
            child: Text('Update'),
          ),
        ],
        title: Text('Edit Categories form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category'
                ),
              ),
              TextField(
                controller: _editCategortDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description'
                ),
              )
            ],
          ),
        ),
      );
    } );
  }

   _deleteFormDialog(BuildContext context, categoryId){
    return showDialog(
      context: context, 
      barrierDismissible: true, 
      builder:(param){
        return AlertDialog(
        actions: <Widget>[
          TextButton(
            onPressed: () =>Navigator.pop(context), 
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: ()async{
             var result = await _categoryService.deleteCategory(categoryId);
             if (result > 0){
              Navigator.pop(context);
              getAllCategories();
              _showsuccessSnackBar(Text('Deleted'));
             }


            }, 
            child: Text('Delete'),
          ),
        ],
        title: Text('Are you sure you want to delete this?'),
       
      );
    } );
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
        leading: ElevatedButton(onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),child: Icon(Icons.arrow_back)  ),
        title: Text('Categories'),
      ),
      body:  ListView.builder(itemCount:_categoryList.length,itemBuilder: (context, index){
        return Padding(
          padding:  EdgeInsets.only(top:8.0, left:16.0, right: 16.0),
          child: Card(
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.edit),onPressed:(){
                _editCategory(context, _categoryList[index].id);
              }),
 title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
    children: <Widget>[
    Text(_categoryList[index].name),
    IconButton(icon: Icon(
      Icons.delete, 
      color: Colors.red,
 ),
          onPressed:(){
            _deleteFormDialog(context, _categoryList[index].id);
          })
                ],
              ),
             ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
         _showFormDialog(context);
      }, child: Icon(Icons.add)),
    );
  }
}