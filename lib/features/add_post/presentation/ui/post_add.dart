import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../injection_container.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../core/model/routine_model.dart';
import '../bloc/post_add_bloc.dart';
import '../bloc/post_add_event.dart';
import '../bloc/post_add_state.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
    this.routineModel,
  });

  final RoutineModel? routineModel;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    if (widget.routineModel != null) {
      sourceController.text = widget.routineModel!.source;
      descriptionController.text = widget.routineModel!.description;
      postAddBloc.add(PostAddReadyToUpdateEvent(widget.routineModel!));
    } else {
      postAddBloc.add(PostAddInitialEvent());
    }
    super.initState();
  }

  final PostAddBloc postAddBloc = sl<PostAddBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostAddBloc, PostAddState>(
      bloc: postAddBloc,
      listenWhen: (previous, current) => current is PostAddActionState,
      buildWhen: (previous, current) => current is! PostAddActionState,
      listener: (context, state) {
        if (state is AddPostSavedState) {
          sourceController.clear();
          descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddPostUpdatedState) {
          sourceController.clear();
          descriptionController.clear();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.titleLabel),
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: sourceController,
                decoration: const InputDecoration(labelText: AppStrings.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: AppStrings.content),
              ),
            ),
            const SizedBox(height: 20),
            state.imagePath == null
                ? const Text('no image')
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(File(state.imagePath!)),
                  ),
            ElevatedButton(
              onPressed: () async {
                var source = sourceController.text;
                var description = descriptionController.text;
                if (source.isNotEmpty && description.isNotEmpty) {
                  if (widget.routineModel != null) {
                    var updatedPost = RoutineModel(
                      id: widget.routineModel!.id,
                      couchId: widget.routineModel!.coachId,
                      description: descriptionController.text,
                      source: sourceController.text,
                    );
                    postAddBloc.add(PostAddUpdateButtonPressEvent(updatedPost));
                  } else {
                    var newPost = RoutineModel(
                      id: 0,
                      couchId: 0,
                      description: descriptionController.text,
                      source: sourceController.text,
                    );
                    postAddBloc.add(PostAddSaveButtonPressEvent(newPost));
                  }
                }
              },
              child: Text(
                widget.routineModel == null ? AppStrings.addPost : AppStrings.updatePost,
              ),
            ),
          ]),
        );
      },
    );
  }
}
