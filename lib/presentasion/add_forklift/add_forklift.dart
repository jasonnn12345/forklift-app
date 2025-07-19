import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentasion/add_forklift//cubit/add_forklift_cubit.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddForkliftPage extends StatefulWidget {
  const AddForkliftPage({Key? key}) : super(key: key);

  @override
  State<AddForkliftPage> createState() => _AddForkliftPageState();
}

class _AddForkliftPageState extends State<AddForkliftPage> {
  final TextEditingController merekController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  String? status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Forklift")),
      body: BlocProvider(
        create: (context) => AddForkliftCubit(),
        child: BlocConsumer<AddForkliftCubit, AddItemState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: merekController,
                    decoration: InputDecoration(labelText: "Merek Forklift"),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: kapasitasController,
                    decoration: InputDecoration(labelText: "Kapasitas ForkLift"),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: hargaController,
                    decoration: InputDecoration(labelText: "Harga Sewa"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final merek = merekController.text;
                      final kapasitas = kapasitasController.text;
                      final hargaRaw = hargaController.text;
                      final harga = int.parse(parseCurrencyToNumber(hargaRaw));


                      context.read<AddForkliftCubit>().submit(
                        merek,
                        kapasitas,
                        harga,
                      );
                    },

                    child: Text("Simpan"),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is AddItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pop(context, true);
            }
            if (state is AddItemError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}

class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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

