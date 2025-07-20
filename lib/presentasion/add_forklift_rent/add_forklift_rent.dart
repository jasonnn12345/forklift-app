import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/renter_data.dart';
import 'package:flutter_pos/data/model/forklift_rent_data.dart';
import 'package:flutter_pos/presentasion/add_forklift/cubit/add_forklift_cubit.dart';
import 'package:flutter_pos/presentasion/add_forklift_rent/cubit/add_forklift_rent_cubit.dart';
import 'package:flutter_pos/presentasion/forklift_list/forklift_index_page.dart';
import 'package:flutter_pos/presentasion/renter_list/cubit/renter_index_cubit.dart';
import 'package:flutter_pos/presentasion/renter_list/renter_index_page.dart';
import 'package:intl/intl.dart';

import '../edit_forklift/edit_item_page.dart';
import '../forklift_list/cubit/forklift_index_cubit.dart';

class AddForkliftRentPage extends StatefulWidget {
  final ForkliftRentData? existingData;

  const AddForkliftRentPage({super.key, this.existingData});

  @override
  State<AddForkliftRentPage> createState() => _AddForkliftRentPageState();
}

class _AddForkliftRentPageState extends State<AddForkliftRentPage> {
  ForkliftData? selectedForklift;
  RenterData? selectedUser;
  final TextEditingController tanggalSewaController = TextEditingController();
  final TextEditingController durasiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      selectedUser = RenterData(
        idPenyewa: widget.existingData!.idPenyewaan,
        namaPenyewa: widget.existingData!.namaPenyewa,
        alamat: widget.existingData!.alamat,
        noTelp: widget.existingData!.noTelp,
      );
      selectedForklift = ForkliftData(
        id: widget.existingData!.idForklift,
        merek: widget.existingData!.merkForklift,
        kapasitas: widget.existingData!.kapasitasForklift,
        hargaSewa: widget.existingData!.hargaSewa,
      );
      tanggalSewaController.text = widget.existingData!.tanggalSewa
          .split('T')
          .first;
      durasiController.text = widget.existingData!.lamaSewa.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddRentCubit, AddRentState>(
      listener: (context, state) {
        if (state is AddRentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penyewaan berhasil disimpan')),
          );
          Navigator.pop(context, true);
        } else if (state is AddRentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.existingData != null ? "Edit Penyewaan" : "Tambah Penyewaan",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                          final user = await Navigator.push<RenterData>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                    RenterIndexCubit()..getRenterList(),
                                child: const RenterListPage(
                                  title: "Pilih Penyewa",
                                ),
                              ),
                            ),
                          );
                          if (user != null) {
                            setState(() => selectedUser = user);
                          }
                        },
                  child: _buildUserCard(selectedUser),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                          final forklift = await Navigator.push<ForkliftData>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                    ForkliftIndexCubit()..getForkliftList(),
                                child: ForkliftListPage(
                                  title: "Pilih Forklift",
                                ),
                              ),
                            ),
                          );
                          if (forklift != null) {
                            setState(() => selectedForklift = forklift);
                          }
                        },
                  child: _buildForkliftCard(selectedForklift),
                ),
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
                      tanggalSewaController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(date);
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
                    if (selectedUser == null ||
                        selectedForklift == null ||
                        tanggalSewaController.text.isEmpty ||
                        durasiController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Semua data wajib diisi')),
                      );
                      return;
                    }
                    if (widget.existingData != null) {
                      final lamaSewa = int.tryParse(durasiController.text) ?? 1;
                      final total = selectedForklift!.hargaSewa * lamaSewa;
                      context.read<AddRentCubit>().editForkliftRent(
                          id: widget.existingData!.idPenyewaan ,
                          penyewaId: selectedUser!.idPenyewa!,
                          forkliftId: selectedForklift!.id!,
                          tanggalSewa: tanggalSewaController.text,
                          lamaSewa: lamaSewa,
                          totalBiaya: total
                      );
                    } else {
                      final lamaSewa = int.tryParse(durasiController.text) ?? 1;
                      final total = selectedForklift!.hargaSewa * lamaSewa;
                      context.read<AddRentCubit>().createForkliftRent(
                        penyewaId: selectedUser!.idPenyewa!,
                        forkliftId: selectedForklift!.id!,
                        tanggalSewa: tanggalSewaController.text,
                        lamaSewa: lamaSewa,
                        totalBiaya: total,
                      );
                    }
                  },
                  child: Text(
                    widget.existingData != null ? "Update" : "Simpan",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(RenterData? renter) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: const Icon(Icons.person, color: Colors.teal),
        ),
        title: Text(
          renter != null ? renter.namaPenyewa : "Pilih Penyewa",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: renter != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No. HP: ${renter.noTelp}'),
                  const SizedBox(height: 4),
                  Text('Alamat: ${renter.alamat}'),
                ],
              )
            : null,
        trailing: renter != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => selectedUser = null),
              )
            : const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _buildForkliftCard(ForkliftData? forklift) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.forklift, color: Colors.blue),
        ),
        title: Text(
          forklift != null ? forklift.merek : "Pilih Forklift",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: forklift != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${forklift.kapasitas} Ton'),
                  const SizedBox(height: 4),
                  Text('Rp ${forklift.hargaSewa}'),
                ],
              )
            : null,
        trailing: forklift != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => selectedForklift = null),
              )
            : const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
