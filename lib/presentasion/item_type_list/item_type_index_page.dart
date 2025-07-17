import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentasion/add_item_type/add_item_type.dart';
import 'package:flutter_pos/presentasion/edit_item_type/edit_item_page.dart';
import 'package:flutter_pos/presentasion/item_type_list/cubit/item_type_index_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Load data saat pertama kali page dibuka
    context.read<ItemTypeIndexCubit>().index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Tombol refresh (optional)
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ItemTypeIndexCubit>().index();
            },
          ),
        ],
      ),
      body: BlocBuilder<ItemTypeIndexCubit, ItemTypeIndexState>(
        builder: (context, state) {
          if (state is ItemTypeIndexLoaded) {
            if (state.itemTypes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada jenis barang',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap tombol + untuk menambah jenis barang',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ItemTypeIndexCubit>().index();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.itemTypes.length,
                  itemBuilder: (context, index) {
                    ItemType itemType = state.itemTypes[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(
                          itemType.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          itemType.status,
                          style: TextStyle(
                            color: itemType.status.toLowerCase() == 'active' 
                                ? Colors.green 
                                : Colors.orange,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.category,
                            color: Colors.blue,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Edit',
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditItemPage(item: itemType),
                                  ),
                                );
                                // Refresh data setelah edit
                                if (result == true) {
                                  context.read<ItemTypeIndexCubit>().index();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Hapus',
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, itemType);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          if (state is ItemTypeIndexError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ItemTypeIndexCubit>().index();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is ItemTypeIndexLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data...'),
              ],
            ),
          );
        },
      ),
      // Tombol untuk menambah item type baru
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddItemTypePage(),
            ),
          );
          // Refresh data setelah tambah
          if (result == true) {
            context.read<ItemTypeIndexCubit>().index();
          }
        },
        tooltip: 'Tambah Jenis Barang',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ItemType itemType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus "${itemType.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     // Panggil fungsi delete di cubit
            //     context.read<ItemTypeIndexCubit>().delete(itemType.id!);
            //   },
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.red,
            //   ),
            //   child: Text('Hapus'),
            // ),
          ],
        );
      },
    );
  }
}