import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testbdgtt/ultis/icons_list.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = "";
  List<Map<String, dynamic>> categorylist = [];
  
  final scrollController = ScrollController();
  var appIcons = AppIcons();
  var addCat = {
      "name": "All",
      "icon": FontAwesomeIcons.cartPlus,
  };
  @override
  void initState(){
    super.initState();
    setState(() {
      categorylist = appIcons.homeExpensesCategories;
      categorylist.insert(0, addCat);
    });
  }
  // scrollToSelectMonth(){
  //   final selectedMonthIndex = months.indexOf(currentMonth);
  //   if(selectedMonthIndex != -1){
  //     final scrollOffset = (selectedMonthIndex * 100.0) - 170;
  //     scrollController.animateTo(
  //       scrollOffset,
  //       duration: Duration(milliseconds: 500), curve: Curves.ease);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
        controller: scrollController,
        itemCount: categorylist.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          var data = categorylist[index];
          return GestureDetector(
          onTap: (){
            setState(() {
              currentCategory = data['name'];
              widget.onChanged(data['name']);
            });
          },
          child: Container(
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: currentCategory == data['name'] 
              ? Color(0xFFFB8C2B)
              : Colors.deepOrangeAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20) 
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(data['icon'], 
                  size: 15,
                  color: currentCategory == data['name'] 
                          ? Colors.white
                          : Colors.black,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    data['name'], 
                    style: TextStyle(
                        color: currentCategory == data['name'] 
                          ? Colors.white
                          : Colors.black,
                        ),),
                ],
              )),
          ),
        );
      }),
    );
  }
}