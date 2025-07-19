import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/presentasion/add_forklift/add_forklift.dart';
import 'package:flutter_pos/presentasion/edit_forklift//cubit/edit_forklift_cubit.dart';
import 'package:flutter_pos/presentasion/edit_forklift/edit_item_page.dart';
import 'package:flutter_pos/presentasion/forklift_list//cubit/forklift_index_cubit.dart';

class ForkliftListPage extends StatefulWidget {
  const ForkliftListPage({super.key, required this.title});

  final String title;

  @override
  State<ForkliftListPage> createState() => _ForkliftListPageState();
}

class _ForkliftListPageState extends State<ForkliftListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ForkliftIndexCubit>().getForkliftList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ForkliftIndexCubit>().getForkliftList();
            },
          ),
        ],
      ),
      body: BlocBuilder<ForkliftIndexCubit, ForkliftIndexState>(
        builder: (context, state) {
          if (state is ForkliftIndexLoaded) {
            if (state.forklifts.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ForkliftIndexCubit>().getForkliftList();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.forklifts.length,
                itemBuilder: (context, index) {
                  final forklift = state.forklifts[index];
                  return _buildForkliftCard(context, forklift);
                },
              ),
            );
          }

          if (state is ForkliftIndexError) {
            return _buildErrorState(state.message);
          }

          return _buildLoadingState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddForkliftPage()),
          );

          if (result == true) {
            context.read<ForkliftIndexCubit>().getForkliftList();
            print("Data berhasil ditambahkan");
          }

        },
        tooltip: 'Tambah Forklift',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildForkliftCard(BuildContext context, ForkliftData forklift) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.forklift, color: Colors.blue),
        ),
        title: Text(
          forklift.merek,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forklift.kapasitas.toString(),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              'Rp ${forklift.hargaSewa}',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String value) async {
            if (value == 'edit') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditForkliftPage(item: forklift),
                ),
              );
              if (result == true) {
                context.read<ForkliftIndexCubit>().getForkliftList(); // refresh data
              }
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(context, forklift);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
          icon: Icon(Icons.more_vert),
        ),
        onTap: (){
          Navigator.pop(context, forklift);
        },
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada forklift yang tersedia',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah forklift',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ForkliftIndexCubit>().getForkliftList();
            },
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
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

  void _showDeleteConfirmationDialog(BuildContext parentContext, ForkliftData forklift) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus "${forklift.merek}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                parentContext.read<ForkliftIndexCubit>().deleteForklift(forklift.id);
                Navigator.of(context).pop();
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
