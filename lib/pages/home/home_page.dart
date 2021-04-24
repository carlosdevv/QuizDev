import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quiz_dev/core/app_colors.dart';
import 'package:quiz_dev/pages/challenge/challenge_page.dart';
import 'package:quiz_dev/pages/challenge/widgets/quiz/quiz.dart';
import 'package:quiz_dev/pages/home/home_controller.dart';
import 'package:quiz_dev/pages/home/home_state.dart';
import 'package:quiz_dev/pages/home/widgets/appbar/app_bar.dart';
import 'package:quiz_dev/pages/home/widgets/level_button/level_button.dart';
import 'package:quiz_dev/pages/home/widgets/quiz_card/quiz_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();

    controller.getUser();
    controller.getQuizzes();

    //addListener vai "ouvir" o controller e toda vez que houver
    // uma alteração nele vai ocorrer um setState (atualizar a tela).
    // No caso, a alteração foi a mudança de estado de loading para success.
    controller.stateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.state == HomeState.success) {
      return Scaffold(
        appBar: AppBarWidget(user: controller.user!),
        body: Column(
          children: [levelButtonRow(), SizedBox(height: 24), quizCardsGrid()],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
          ),
        ),
      );
    }
  }

  Expanded quizCardsGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: EdgeInsets.only(left: 20, right: 20),
        physics: BouncingScrollPhysics(),
        children: controller.quizzes!
            .map((e) => QuizCardWidget(
                  title: e.title,
                  completed: '${e.questionAnswered} de ${e.questions.length}',
                  percent: e.questionAnswered / e.questions.length,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChallengePage(
                                  title: e.title,
                                  questions: e.questions,
                                  percent:
                                      e.questionAnswered / e.questions.length,
                                )));
                  },
                ))
            .toList(),
      ),
    );
  }

  Container levelButtonRow() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 24),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LevelButtonWidget(
                  label: 'Fácil',
                ),
                LevelButtonWidget(
                  label: 'Médio',
                ),
                LevelButtonWidget(
                  label: 'Difícil',
                ),
                LevelButtonWidget(
                  label: 'Perito',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
