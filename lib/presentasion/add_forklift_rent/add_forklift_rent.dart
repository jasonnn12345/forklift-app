import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/presentasion/forklift_list/forklift_index_page.dart';
import 'package:intl/intl.dart';

import '../forklift_list/cubit/forklift_index_cubit.dart';

class AddForkliftRentPage extends StatefulWidget {
  const AddForkliftRentPage({super.key});

  @override
  State<AddForkliftRentPage> createState() => _AddForkliftRentPageState();
}

class _AddForkliftRentPageState extends State<AddForkliftRentPage> {
  ForkliftData? selectedForklift;
  final TextEditingController tanggalSewaController = TextEditingController();
  final TextEditingController durasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Penyewaan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // scroll jika layar kecil
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final _selectedForklift = await Navigator.push<ForkliftData>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ForkliftIndexCubit()..getForkliftList(),
                        child: ForkliftListPage(title: "List Forklift"),
                      ),
                    ),
                  );

                  if (_selectedForklift != null) {
                    setState(() {
                      selectedForklift = _selectedForklift;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedForklift != null
                              ? 'Ganti Forklift'
                              : 'Pilih Forklift',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Tampilkan forklift card jika sudah dipilih
              if (selectedForklift != null) _buildForkliftCard(selectedForklift!),

              const SizedBox(height: 16),

              TextField(
                controller: tanggalSewaController,
                decoration: const InputDecoration(labelText: 'Tanggal Sewa'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    tanggalSewaController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                readOnly: true,
              ),

              const SizedBox(height: 12),

              TextField(
                controller: durasiController,
                decoration: const InputDecoration(labelText: 'Durasi (hari)'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (selectedForklift == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih forklift terlebih dahulu')),
                    );
                    return;
                  }

                  final forkliftId = selectedForklift!.id;
                  final tanggalSewa = tanggalSewaController.text;
                  final durasi = durasiController.text;

                  // TODO: kirim ke Cubit atau API
                  print('Forklift ID: $forkliftId, Tanggal: $tanggalSewa, Durasi: $durasi');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Penyewaan berhasil disimpan'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForkliftCard(ForkliftData forklift) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.forklift, color: Colors.blue),
        ),
        title: Text(
          forklift.merek,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${forklift.kapasitas} Ton'),
            const SizedBox(height: 4),
            Text('Rp ${forklift.hargaSewa}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () {
            setState(() {
              selectedForklift = null;
            });
          },
        ),
      ),
    );
  }

}
