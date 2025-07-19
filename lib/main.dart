import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentasion/forklift_list//cubit/forklift_index_cubit.dart';
import 'package:flutter_pos/presentasion/forklift_list/forklift_index_page.dart';
import 'package:flutter_pos/presentasion/forklift_rent_list/cubit/forklift_rent_index_cubit.dart';
import 'package:flutter_pos/presentasion/forklift_rent_list/forklift_rent_index_page.dart';

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
      home: BlocProvider(create: (context) => ForkliftRentIndexCubit(),
      child: const MyHomePage(title: "Daftar Rental Forklift"),)
    );
  }
}
