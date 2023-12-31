import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newapp/screens/home_screens.dart';
import 'package:newapp/services/category_service.dart';

import '../screens/categories_screen.dart';
import '../screens/todos_by_category.dart';

class DrawerNavigation extends StatefulWidget {


  @override
   _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList =<Widget>[];
  CategoryService _categoryService =CategoryService();
  @override
  initState(){
    super.initState();
    getAllCategories();
  }

  getAllCategories() async{
    var categories=await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
       
        _categoryList.add(InkWell(
          onTap: (() => Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosByCategory(category:category ['name'],)))),
          child: ListTile(
           title: Text(category['name']),
          ),
        ));
      });
    });
  }
@override
  Widget build(BuildContext context) {
    return Container(
           child: Drawer(
        child:ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/previews/004/773/704/original/a-girl-s-face-with-a-beautiful-smile-a-female-avatar-for-a-website-and-social-network-vector.jpg'),
               ),
            accountName: Text('Tharani Jayasekara'), 
            accountEmail: Text('tharanijayasekara99@gmail.com'),
            decoration: BoxDecoration(color: Colors.blue),
            ),
             ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),
        ), 
          ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen())),
        ),   
          Divider(),
          Column(
           children: _categoryList, 
          )
          ],   
        ),
      ),
    );
  }
}