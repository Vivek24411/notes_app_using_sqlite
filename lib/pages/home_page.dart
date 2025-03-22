import 'package:flutter/material.dart';
import 'package:notes_app_using_sqlite/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
 @override
 State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 TextEditingController titleController = TextEditingController();
 TextEditingController descController = TextEditingController();
 List<Map<String, dynamic>> allNotes = [];
 DBhelper? dbref;
 var errMsg = "";

 @override
 void initState() {
  super.initState();
  dbref = DBhelper.getInstance;
  getNotes();
 }

 void getNotes() async {
  allNotes = await dbref!.getAllNotes();
  setState(() {});
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text("My Notes"),
   ),
   body: allNotes.isNotEmpty
       ? ListView.builder(
       itemCount: allNotes.length,
       itemBuilder: (_, index) {
        return ListTile(
         leading: Text((index+1).toString()),
         title: Text(allNotes[index]["title"]),
         subtitle: Text(allNotes[index]["desc"]),
         trailing: SizedBox(
          width: 50,
          child: Container(
           width: 50,
            child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              InkWell(
                  onTap: (){
                   showModalBottomSheet(context: context, builder: (context){
                    titleController.text = allNotes[index]["title"];
                    descController.text = allNotes[index]["desc"];

                    return Container(
                    padding: EdgeInsets.all(11),
                    width: double.infinity,
                    child: Column(
                    children: [
                    Text(
                    "Update Note",
                    style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                    hintText: "Enter title here",
                    label: Text("Title"),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    ),
                    ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                    hintText: "Enter desc here",
                    label: Text("Desc"),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    ),
                    ),
                    ),
                    SizedBox(height: 11),
                    Row(
                    children: [
                    Expanded(
                    child: OutlinedButton(
                    onPressed: () async {
                    var title = titleController.text;
                    var desc = descController.text;
                    if (title.isNotEmpty && desc.isNotEmpty) {
                    bool check = await dbref!.updateNote(
                    mTitle: title, mDesc: desc, sno: allNotes[index]["s_no"]);
                    if (check) {
                    getNotes();
                    }
                    Navigator.pop(context);
                    } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all details")));
                    }
                    titleController.clear();
                    descController.clear();
                    },
                    child: Text("Update"),
                    style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(
                    width: 4,
                    color: Colors.black,
                    ),
                    ),
                    ),
                    ),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                    child: OutlinedButton(
                    onPressed: () {
                    Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(
                    width: 4,
                    color: Colors.black,
                    ),
                    ),
                    ),
                    ),
                    ),
                    ],
                    ),
                    ],
                    ),
                    );
                   });
                  },
                  child: Icon(Icons.add,color: Colors.green,)),
              InkWell(
               onTap: ()async{
              bool check =  await dbref!.deleteNote(sno: allNotes[index]["s_no"]);
              if(check){
               getNotes();
              }
               },
                  child: Icon(Icons.delete, color: Colors.red,)),
             ],
            ),
          ),
         ),
        );
       })
       : Center(child: Text("No Notes Yet")),
   floatingActionButton: FloatingActionButton(
    onPressed: () async {
     showModalBottomSheet(
      context: context,
      builder: (context) {
       return Container(
        padding: EdgeInsets.all(11),
        width: double.infinity,
        child: Column(
         children: [
          Text(
           "Add Note",
           style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
           ),
          ),
          SizedBox(height: 11),
          TextField(
           controller: titleController,
           decoration: InputDecoration(
            hintText: "Enter title here",
            label: Text("Title"),
            focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(11),
            ),
            enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(11),
            ),
           ),
          ),
          SizedBox(height: 11),
          TextField(
           controller: descController,
           maxLines: 4,
           decoration: InputDecoration(
            hintText: "Enter desc here",
            label: Text("Desc"),
            enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(11),
            ),
            focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(11),
            ),
           ),
          ),
          SizedBox(height: 11),
          Row(
           children: [
            Expanded(
             child: OutlinedButton(
              onPressed: () async {
               var title = titleController.text;
               var desc = descController.text;
               if (title.isNotEmpty && desc.isNotEmpty) {
                bool check = await dbref!.addNote(
                    mTitle: title, mDesc: desc);
                if (check) {
                 getNotes();
                }
                Navigator.pop(context);
               } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all details")));
               }
               titleController.clear();
               descController.clear();
              },
              child: Text("Add"),
              style: OutlinedButton.styleFrom(
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
                side: BorderSide(
                 width: 4,
                 color: Colors.black,
                ),
               ),
              ),
             ),
            ),
            SizedBox(width: 11),
            Expanded(
             child: OutlinedButton(
              onPressed: () {
               Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: OutlinedButton.styleFrom(
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
                side: BorderSide(
                 width: 4,
                 color: Colors.black,
                ),
               ),
              ),
             ),
            ),
           ],
          ),
         ],
        ),
       );
      },
     );
    },
    child: Icon(Icons.add),
   ),
  );
 }
}