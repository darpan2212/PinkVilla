import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pinkvilla/bloc/bloc.dart';
import 'package:pinkvilla/bloc_observer.dart';
import 'package:pinkvilla/screens/home/home_screen.dart';
import 'package:screen/screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  Screen.keepOn(true);
  runApp(PinkVillaApp());
}

class PinkVillaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: BlocProvider(
          create: (BuildContext context) {
            return VideoBloc(httpClient: http.Client())..add(VideoFetched());
          },
          child: HomeScreen(),
        ),
      ),
    );
  }
}
