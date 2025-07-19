import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/presentasion/edit_forklift//cubit/edit_forklift_cubit.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditForkliftPage extends StatefulWidget {
  final Forklift item;

  const EditForkliftPage({super.key, required this.item});

  @override
  State<EditForkliftPage> createState() => _EditForkliftPageState();
}

class _EditForkliftPageState extends State<EditForkliftPage> {
  late TextEditingController merekController;
  late TextEditingController kapasitasController;
  late TextEditingController hargaController;

  @override
  void initState() {
    super.initState();
    merekController = TextEditingController(text: widget.item.merek);
    kapasitasController = TextEditingController(text: widget.item.kapasitas.toString());
    hargaController = TextEditingController(
      text: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
          .format(widget.item.hargaSewa),
    );
  }

  @override
  void dispose() {
    merekController.dispose();
    kapasitasController.dispose();
    hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Forklift")),
      body: BlocProvider(
        create: (_) => EditForkliftCubit(),
        child: BlocConsumer<EditForkliftCubit, EditForkliftState>(
          listener: (context, state) {
            if (state is EditForkliftSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pop(context, true);
            } else if (state is EditForkliftError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: merekController,
                    decoration: const InputDecoration(labelText: "Merek Forklift"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: kapasitasController,
                    decoration: const InputDecoration(labelText: "Kapasitas ForkLift"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hargaController,
                    decoration: const InputDecoration(labelText: "Harga Sewa"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final merek = merekController.text.trim();
                      final kapasitas = kapasitasController.text.trim();
                      final hargaRaw = hargaController.text;

                      if (merek.isEmpty || kapasitas.isEmpty || hargaRaw.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Semua field harus diisi")),
                        );
                        return;
                      }

                      final harga = int.tryParse(parseCurrencyToNumber(hargaRaw)) ?? 0;

                      context.read<EditForkliftCubit>().update(
                        widget.item.id,
                        merek,
                        kapasitas,
                        harga,
                      );
                    },
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    if (newText.isEmpty) return newValue.copyWith(text: '');

    int value = int.parse(newText);
    String formatted = _formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String parseCurrencyToNumber(String formatted) {
  return formatted.replaceAll(RegExp(r'[^0-9]'), '');
}
