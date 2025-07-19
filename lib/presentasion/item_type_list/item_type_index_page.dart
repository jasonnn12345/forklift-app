import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/presentasion/add_forklift/add_item_type.dart';
import 'package:flutter_pos/presentasion/item_type_list/cubit/forklift_index_cubit.dart';

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
    context.read<ForkliftIndexCubit>().index();
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
              context.read<ForkliftIndexCubit>().index();
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
                context.read<ForkliftIndexCubit>().index();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.forklifts.length,
                itemBuilder: (context, index) {
                  final forklift = state.forklifts[index];
                  return _buildForkliftCard(forklift);
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
            context.read<ForkliftIndexCubit>().index();
            print("Data berhasil ditambahkan");
          }

        },
        tooltip: 'Tambah Forklift',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildForkliftCard(Forklift forklift) {
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
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          tooltip: 'Hapus',
          onPressed: () {
            _showDeleteConfirmationDialog(context, forklift);
          },
        ),
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
              context.read<ForkliftIndexCubit>().index();
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

  void _showDeleteConfirmationDialog(BuildContext context, Forklift forklift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus "${forklift.merek}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            // Tambahkan implementasi delete jika diperlukan
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     context.read<ForkliftIndexCubit>().delete(forklift.id);
            //   },
            //   child: Text('Hapus', style: TextStyle(color: Colors.red)),
            // ),
          ],
        );
      },
    );
  }
}
