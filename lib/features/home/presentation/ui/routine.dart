import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../bloc/routine_bloc.dart';
import '../bloc/routine_event.dart';
import '../bloc/routine_state.dart';
import '../../../add_post/presentation/ui/post_add.dart';
import 'routine_details.dart';
import '../../../../injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Widget _imageDisplay(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Image.file(File(imagePath)),
    );
  }

  @override
  void initState() {
    postBloc.add(RoutineInitialEvent());
    super.initState();
  }

  void refreshPage() {
    postBloc.add(RoutineInitialEvent());
  }

  RoutineBloc postBloc = sl<RoutineBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoutineBloc, RoutineState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is RoutineActionState,
      buildWhen: (previous, current) => current is! RoutineActionState,
      listener: (context, state) {
        if (state is RoutineNavigateToAddPostActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddPost(),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is RoutineNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddPost(
                postModel: state.routineModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is RoutineNavigateToUpdatePageActionState) {
        } else if (state is RoutineItemSelectedActionState) {
        } else if (state is RoutineItemDeletedActionState) {
        } else if (state is RoutineItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case RoutineLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case RoutineLoadedSuccessState:
            final successState = state as RoutineLoadedSuccessState;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  postBloc.add(PostAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(AppStrings.titleLabel),
                    TextButton(
                      onPressed: () async {
                        postBloc.add(PostDeleteAllButtonClickedEvent());
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: ColorManager.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: ListView.builder(
                itemCount: successState.routineModelList.length,
                itemBuilder: (context, index) {
                  var postModel = successState.routineModelList[index];
                  return ListTile(
                    tileColor: postModel.isSelected == 0 ? ColorManager.white : ColorManager.grey,
                    onLongPress: () async {
                      postBloc.add(RoutineTileLongPressEvent(postModel));
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RoutineDetailsPage(
                            routineModel: postModel,
                          ),
                        ),
                      );
                    },
                    title: Text(postModel.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(postModel.content),
                        _imageDisplay(postModel.imagePath),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                postBloc.add(RoutineTileNavigateEvent(postModel));
                              },
                              child: const Text(AppStrings.edit),
                            ),
                            TextButton(
                              onPressed: () {
                                postBloc.add(PostDeleteButtonClickedEvent(postModel));
                              },
                              child: const Text(AppStrings.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          case RoutineErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
