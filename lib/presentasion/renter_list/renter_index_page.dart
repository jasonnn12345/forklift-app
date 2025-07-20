import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/renter_data.dart';
import 'package:flutter_pos/presentasion/renter_list/cubit/renter_index_cubit.dart';

class RenterListPage extends StatefulWidget {
  const RenterListPage({super.key, required this.title});
  final String title;

  @override
  State<RenterListPage> createState() => _RenterListPageState();
}

class _RenterListPageState extends State<RenterListPage> {
  final RenterIndexCubit _renterCubit = RenterIndexCubit();

  @override
  void initState() {
    super.initState();
    _renterCubit.getRenterList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _renterCubit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: BlocBuilder<RenterIndexCubit, RenterIndexState>(
          builder: (context, state) {
            if (state is RenterIndexLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RenterIndexLoaded) {
              if (state.renterList.isEmpty) {
                return const Center(child: Text("Belum ada penyewa."));
              }

              return ListView.builder(
                itemCount: state.renterList.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final renter = state.renterList[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: const Icon(Icons.person, color: Colors.teal),
                      ),
                      title: Text(
                        renter.namaPenyewa,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Alamat: ${renter.alamat}"),
                          Text("No. Telp: ${renter.noTelp}"),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditRenterDialog(context, renter);
                          } else if (value == 'delete' && renter.idPenyewa != null) {
                            _confirmDelete(context, renter.idPenyewa!);
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
                      onTap: () {
                        Navigator.pop(context, renter); // mengembalikan renter yang dipilih
                      },
                    ),
                  );
                },
              );
            } else if (state is RenterIndexError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Belum ada data"));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddRenterDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddRenterDialog(BuildContext context) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final telpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tambah Penyewa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama Penyewa'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat Penyewa'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: telpController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (namaController.text.isEmpty ||
                              alamatController.text.isEmpty ||
                              telpController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Harap isi semua field")),
                            );
                            return;
                          }

                          _renterCubit.createRenter(
                            namaPenyewa: namaController.text,
                            alamatPenyewa: alamatController.text,
                            noTelp: telpController.text,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditRenterDialog(BuildContext context, RenterData renter) {
    final namaController = TextEditingController(text: renter.namaPenyewa);
    final alamatController = TextEditingController(text: renter.alamat);
    final telpController = TextEditingController(text: renter.noTelp);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Edit Penyewa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama Penyewa'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat Penyewa'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: telpController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (namaController.text.isEmpty ||
                              alamatController.text.isEmpty ||
                              telpController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Harap isi semua field")),
                            );
                            return;
                          }

                          _renterCubit.editRenter(
                            id: renter.idPenyewa!,
                            namaPenyewa: namaController.text,
                            alamatPenyewa: alamatController.text,
                            noTelp: telpController.text,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _confirmDelete(BuildContext context, int idPenyewa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah kamu yakin ingin menghapus penyewa ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _renterCubit.deleteRenter(idPenyewa);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}
