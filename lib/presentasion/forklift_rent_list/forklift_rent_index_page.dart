import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_rent_data.dart';
import 'package:flutter_pos/presentasion/add_forklift_rent/add_forklift_rent.dart';
import 'package:flutter_pos/presentasion/forklift_rent_list/cubit/forklift_rent_index_cubit.dart';
import 'package:intl/intl.dart';
import '../add_forklift_rent/cubit/add_forklift_rent_cubit.dart';

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
    context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
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
              context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
            },
          ),
        ],
      ),
      body: BlocBuilder<ForkliftRentIndexCubit, ForkliftRentIndexState>(
        builder: (context, state) {
          if (state is ForkliftRentIndexLoaded) {
            if (state.forkliftRent.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.forkliftRent.length,
                itemBuilder: (context, index) {
                  final penyewaan = state.forkliftRent[index];
                  return _buildPenyewaanCard(penyewaan);
                },
              ),
            );
          }

          if (state is ForkliftRentIndexError) {
            return _buildErrorState(state.message);
          }

          return _buildLoadingState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddRentCubit(),
                child: const AddForkliftRentPage(),
              ),
            ),
          );

          if (result == true) {
            context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
          }
        },
        tooltip: 'Tambah Penyewaan',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPenyewaanCard(ForkliftRentData penyewaan) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.assignment, color: Colors.green),
        ),
        title: Text(
          penyewaan.namaPenyewa,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forklift: ${penyewaan.merkForklift} (${penyewaan.kapasitasForklift} ton)'),
            Text('ID Forklift: ${penyewaan.idForklift}'),
            Text('ID Penyewaan: ${penyewaan.idPenyewaan}'),
            SizedBox(height: 4),
            Text('Tanggal Sewa: ${formatTanggal(penyewaan.tanggalSewa)}'),
            Text('Lama Sewa: ${penyewaan.lamaSewa} hari'),
            SizedBox(height: 4),
            Text('Total Biaya: Rp ${penyewaan.totalBiaya}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'edit') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => AddRentCubit(),
                    child: AddForkliftRentPage(existingData: penyewaan),
                  ),
                ),
              );
              if (result == true) {
                context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
              }
            }
            else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Hapus Penyewaan'),
                  content: Text('Yakin ingin menghapus penyewaan ini?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
                  ],
                ),
              );

              if (confirm == true) {
                await context.read<ForkliftRentIndexCubit>().deleteForklift(penyewaan.idPenyewaan);

              }
            }

          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada penyewaan',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah penyewaan',
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
          Text('Terjadi Kesalahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ForkliftRentIndexCubit>().getAllForkliftRentList();
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
}

String formatTanggal(String isoDate) {
  final date = DateTime.parse(isoDate); // Tanpa toLocal()
  return DateFormat('dd-MM-yyyy').format(date); // Hasil: 30-06-2025
}




