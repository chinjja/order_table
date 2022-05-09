import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_table/data/data.dart';
import 'package:order_table/presentation/bloc/layout_bloc.dart';
import 'package:order_table/presentation/models/model_item.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LayoutBloc(context.read<Repository>())..add(const LayoutFetched()),
      child: const LayoutView(),
    );
  }
}

class LayoutView extends StatelessWidget {
  const LayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final path =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (path == null) return;
            context.read<LayoutBloc>().add(LayoutAdded(path.path));
          },
        )
      ]),
      body: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          switch (state.status) {
            case LayoutStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LayoutStatus.success:
              return LayoutItemView(state: state);
            case LayoutStatus.failure:
              return Center(child: Text('oops: ${state.error}'));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

class LayoutItemView extends StatefulWidget {
  const LayoutItemView({
    Key? key,
    required this.state,
  }) : super(key: key);

  final LayoutState state;

  @override
  State<LayoutItemView> createState() => _LayoutItemViewState();
}

class _LayoutItemViewState extends State<LayoutItemView> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return GestureDetector(
      onTap: () {
        context.read<LayoutBloc>().add(const LayoutUnselected());
      },
      onScaleUpdate: (details) {
        context.read<LayoutBloc>().add(LayoutScaled(
              details.focalPointDelta,
              details.scale,
            ));
      },
      child: widget.state.list.isEmpty
          ? const Center(child: Text('EMPTY'))
          : Stack(
              children: state.list.map((e) {
                final x = e.item.x + state.offset.dx;
                final y = e.item.y + state.offset.dy;
                return Positioned(
                    key: Key('${e.item.id}'),
                    left: x * state.scale,
                    top: y * state.scale,
                    width: e.item.width * state.scale,
                    height: e.item.height * state.scale,
                    child: Image.file(File(e.item.path)));
              }).toList(),
            ),
    );
  }
}
