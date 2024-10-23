import 'package:aiu_project/common/extensions/space_exs.dart';
import 'package:aiu_project/features/personalization/screens/task/widgets/task_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';

class HomeViewTaskBody extends StatefulWidget {
  HomeViewTaskBody({
    super.key,
  });

  @override
  State<HomeViewTaskBody> createState() => _HomeViewTaskBodyState();
}

class _HomeViewTaskBodyState extends State<HomeViewTaskBody> {
  final List<int> testing = [1, 2, 3];
 // Пример данных для списка задач
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Custom App Bar
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress indicator
                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      value: 1 / 3, // Пример значения прогресса
                      backgroundColor: Colors.grey,
                      valueColor:
                      AlwaysStoppedAnimation(TColors.primaryTaskColor),
                    ),
                  ),

                  // Space
                  25.w,

                  // Info Task Level
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TTexts.taskTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      3.h,
                      Text(
                        "1 of 3 Task", // Пример текста
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  )
                ],
              ),
            ),

            // Divider
            const Padding(
              padding: EdgeInsets.only(top: TSizes.sm),
              child: Divider(
                thickness: 2,
                indent: 100,
              ),
            ),

            // Tasks or Animation based on the list state
            Expanded(
              child: testing.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeIn(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(TImages.lottieUrl1,
                          animate:
                          testing.isNotEmpty ? false :true), // Всегда анимация при пустом списке
                    ),
                  ),
                  FadeInUp(
                      from: 30, child: const Text(TTexts.doneAllTask)),
                ],
              )
                  : ListView.builder(
                itemCount: testing.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(testing[index].toString()),
                    // Уникальный ключ для каждого элемента
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      setState(() {
                        // Удаляем элемент из списка
                        testing.removeAt(index);
                      });

                      // Можно добавить Snackbar или другое уведомление, если нужно
                    },
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete_outline,
                            color: TColors.grey),
                        8.w,
                        const Text(TTexts.deletedTask,
                            style: TextStyle(color: TColors.grey)),
                      ],
                    ),
                    child: const TaskWidget(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}