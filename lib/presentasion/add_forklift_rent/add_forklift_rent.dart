import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/renter_data.dart';
import 'package:flutter_pos/presentasion/forklift_list/forklift_index_page.dart';
import 'package:flutter_pos/presentasion/renter_list/cubit/renter_index_cubit.dart';
import 'package:flutter_pos/presentasion/renter_list/renter_index_page.dart';
import 'package:intl/intl.dart';

import '../edit_forklift/edit_item_page.dart';
import '../forklift_list/cubit/forklift_index_cubit.dart';

class AddForkliftRentPage extends StatefulWidget {
  const AddForkliftRentPage({super.key});

  @override
  State<AddForkliftRentPage> createState() => _AddForkliftRentPageState();
}

class _AddForkliftRentPageState extends State<AddForkliftRentPage> {
  ForkliftData? selectedForklift;
  RenterData? selectedUser; // ✅ Tambahkan ini
  final TextEditingController tanggalSewaController = TextEditingController();
  final TextEditingController durasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Penyewaan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Card pilih user
              GestureDetector(
                onTap: () async {
                  final user = await Navigator.push<RenterData>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => RenterIndexCubit()..getRenterList(),
                        child: const RenterListPage(title: "Pilih Penyewa"),
                      ),
                    ),
                  );


                  if (user != null) {
                    setState(() {
                      selectedUser = user;
                    });
                  }
                },
                child: Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.teal),
                        const SizedBox(width: 12),
                        Text(
                          selectedUser != null
                              ? "User: ${selectedUser!.namaPenyewa}"
                              : "Tap untuk pilih user",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              if (selectedUser != null) _buildUserCard(selectedUser!), // ✅ tampilkan jika sudah dipilih

              const SizedBox(height: 12),

              // ✅ Card pilih forklift
              GestureDetector(
                onTap: () async {
                  final forklift = await Navigator.push<ForkliftData>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                        ForkliftIndexCubit()..getForkliftList(),
                        child: ForkliftListPage(title: "Pilih Forklift"),
                      ),
                    ),
                  );

                  if (forklift != null) {
                    setState(() {
                      selectedForklift = forklift;
                    });
                  }
                },
                child: Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          selectedForklift != null
                              ? "Forklift: ${selectedForklift!.merek}"
                              : "Tap untuk pilih forklift",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              if (selectedForklift != null)
                _buildForkliftCard(selectedForklift!),

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
                    tanggalSewaController.text =
                        DateFormat('yyyy-MM-dd').format(date);
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
                  if (selectedUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih user terlebih dahulu')),
                    );
                    return;
                  }

                  if (selectedForklift == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih forklift terlebih dahulu')),
                    );
                    return;
                  }
                  final userId = selectedUser!.idPenyewa;
                  final forkliftId = selectedForklift!.id;
                  final tanggalSewa = tanggalSewaController.text;
                  final durasi = durasiController.text;

                  //note: tahan data nya disini

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
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'edit') {
              final updatedForklift = await Navigator.push<ForkliftData>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditForkliftPage(item: forklift),
                ),
              );
              if (updatedForklift != null) {
                setState(() {
                  selectedForklift = updatedForklift;
                });
              }
            } else if (value == 'delete') {
              setState(() {
                selectedForklift = null;
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(RenterData renter) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: const Icon(Icons.person, color: Colors.teal),
        ),
        title: Text(
          renter.namaPenyewa,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No. HP: ${renter.noTelp}'),
            const SizedBox(height: 4),
            Text('Alamat: ${renter.alamat}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              selectedUser = null;
            });
          },
        ),
      ),
    );
  }
}
