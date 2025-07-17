import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentasion/item_type_list/cubit/item_type_index_cubit.dart';
import 'package:flutter_pos/presentasion/item_type_list/item_type_index_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(create: (context) => ItemTypeIndexCubit(),
      child: const MyHomePage(title: "Daftar Jenis Barang"),)
    );
  }
}
