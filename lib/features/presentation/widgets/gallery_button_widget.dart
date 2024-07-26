import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
import 'package:valuefinder/features/presentation/bloc/camera_state.dart';
import 'package:valuefinder/features/presentation/bloc/camera_event.dart';

class GalleryButtonWidget extends StatelessWidget {
  const GalleryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        gradient: const LinearGradient(
          colors: [Color(0xff2753cf), Color(0xffc882ff), Color(0xff46edfe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xff0e235a),
            borderRadius: BorderRadius.circular(90),
          ),
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<CameraBloc>().add(PickImageEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
