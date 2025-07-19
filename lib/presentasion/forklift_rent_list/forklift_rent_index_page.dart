import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_rent_data.dart';
import 'package:flutter_pos/presentasion/forklift_rent_list/cubit/forklift_rent_index_cubit.dart';

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
          //hold dlu
          // final result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => AddPenyewaanPage()),
          // );
          //
          // if (result == true) {
          //   context.read<PenyewaanCubit>().fetchPenyewaan();
          // }
        },
        tooltip: 'Tambah Penyewaan',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPenyewaanCard(Penyewaan penyewaan) {
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
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${penyewaan.merkForklift} (${penyewaan.kapasitasForklift})'),
            SizedBox(height: 4),
            Text('Tgl Sewa: ${penyewaan.tanggalSewa}'),
            Text('Lama Sewa: ${penyewaan.lamaSewa} hari'),
            SizedBox(height: 4),
            Text('Total: Rp ${penyewaan.totalBiaya}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
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
