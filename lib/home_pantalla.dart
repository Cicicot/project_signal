import 'package:crud_yt_basic/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void _refreshData() async{
    final data = await SQLHelper.getAllData();
    if (!mounted) return;
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
  }

  

  Future<void> _addData() async{
    await SQLHelper.createData(_titleController.text, _descriptionController.text);
    if (!mounted) return;
    _refreshData();
  }

  Future<void> _updateData(int id) async{
    await SQLHelper.updateData(id, _titleController.text, _descriptionController.text);
    if (!mounted) return;
    _refreshData();
  }

  //Delete Data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text( 'Data deleted.' ), 
      )
    );
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void showBottomSheet(int? id) async{
    if ( id != null ) {
      final existingData =
      _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context, 
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description'
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null){
                    await _addData();
                  }
                  if (id != null){
                    await _updateData(id);
                  }
                  if (!mounted) return;
                  _titleController.text = '';
                  _descriptionController.text = '';
                  //Hide bottom sheet
                  Navigator.of(context).pop();
                  // print('added');
                }, 
                child: Padding(
                  padding: const EdgeInsets.all( 18 ),
                  child: Text(
                    id == null ? 'Add Data' : 'Update Data',
                    style: const TextStyle( fontSize: 18, fontWeight: FontWeight.w500 ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 218, 191, 191),
        appBar: AppBar(
          centerTitle: true,
          title: const Text( 'CRUD Operations' ),
        ),
        body: _isLoading
              ? const Center(
                child: Text( 'Tabla vacía' ) //CircularProgressIndicator()
              )
              : ListView.builder(
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text( _allData[index]['title'] ),
                    ), 
                    subtitle: Text( _allData[index]['description'] ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(_allData[index]['id']);
                          }, 
                          icon: const Icon( Icons.edit, color: Colors.indigo )
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteData(_allData[index]['id']);
                          }, 
                          icon: const Icon( Icons.delete, color: Colors.redAccent )
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: _allData.length,
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null), //() => showBottomSheet(null)
        child: const Icon( Icons.add ),
      ),
    );
  }
}