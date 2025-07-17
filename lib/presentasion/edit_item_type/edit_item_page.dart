import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentasion/edit_item_type/cubit/edit_item_cubit.dart';


class EditItemPage extends StatefulWidget {
  final ItemType item;
  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController codeController;
late TextEditingController nameController;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Item")),
      body: BlocProvider(
        create: (context) => EditItemCubit(),
        child: BlocConsumer<EditItemCubit, EditItemState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: codeController = TextEditingController(
                      text: widget.item.code,
                    ),
                    decoration: InputDecoration(labelText: "Code"),
                  ),
                  TextField(
                    controller: nameController = TextEditingController(
                      text: widget.item.name,
                    ),
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  DropdownButtonFormField(
                    value: selectedStatus = widget.item.status,
                    items: [
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(
                        value: "Non-Active",
                        child: Text("Non-Active"),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedStatus = val),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final code = codeController.text;
                      final name = nameController.text;
                      if (code.isEmpty ||
                          name.isEmpty ||
                          selectedStatus == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Semua field harus diisi"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      context.read<EditItemCubit>().update(
                            widget.item.id,
                            code,
                            name,
                            selectedStatus!,
                          );
                    },
                    child: Text("Update"),
                  )
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is EditItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
