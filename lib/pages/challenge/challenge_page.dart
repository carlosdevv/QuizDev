import 'package:flutter/material.dart';

import 'package:quiz_dev/global/models/question_model.dart';
import 'package:quiz_dev/pages/challenge/challenge_controller.dart';
import 'package:quiz_dev/pages/challenge/widgets/next_button/next_button.dart';
import 'package:quiz_dev/pages/challenge/widgets/question_indicator/question_indicator.dart';
import 'package:quiz_dev/pages/challenge/widgets/quiz/quiz.dart';
import 'package:quiz_dev/pages/result/result_page.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;
  final double percent;

  const ChallengePage({
    Key? key,
    required this.questions,
    required this.title,
    required this.percent,
  }) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final controller = ChallengeController();
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  void onSelected(bool value) {
    if (value) {
      controller.qtdHits++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SafeArea(
            top: true,
            child: Column(
              children: [
                //buildar so o que vai ser modificado
                ValueListenableBuilder<int>(
                  valueListenable: controller.currentPageNotifier,
                  builder: (context, value, _) => QuestionIndicatorWidget(
                    currentPage: value,
                    length: widget.questions.length,
                  ),
                ),
              ],
            )),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onSelected: onSelected,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: NextButtonWidget.white(
                label: 'Voltar',
                onTap: () {
                  if (pageController.page == 0) {
                    Navigator.pop(context);
                  } else {
                    pageController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  }
                },
              )),
              SizedBox(width: 7),
              ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => value == widget.questions.length
                    ? Expanded(
                        child: NextButtonWidget.green(
                        label: 'Confirmar',
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        result: controller.qtdHits,
                                        title: widget.title,
                                        length: widget.questions.length,
                                      )));
                        },
                      ))
                    : Expanded(
                        child: NextButtonWidget.green(
                        label: 'Avançar',
                        onTap: () {
                          pageController.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.linear);
                        },
                      )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
