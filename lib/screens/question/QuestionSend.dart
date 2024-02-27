import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:inkozi/UTILIS/text_style.dart';
import '../../model/QuestionModel.dart';
import '../../repo/ques_repo.dart';
import '../../widgets/widget.dart';

class QuestionSend extends StatefulWidget {
  final String selectedCategoryId;

  const QuestionSend({super.key, required this.selectedCategoryId});

  static const String routeName = '/questionsend';

  static Route route() {
    // Define and initialize selectedCategoryId
    String selectedCategoryId = 'defaultCategoryID';

    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => QuestionSend(selectedCategoryId: selectedCategoryId),
    );
  }

  @override
  State<QuestionSend> createState() => _QuestionSendState();
}

class _QuestionSendState extends State<QuestionSend> {
  //
  List<CategoryQuestions>? questions = [];
  List<String> selectedQuestionIds = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      final QuestionRepository questionRepository = QuestionRepository();
      final QuestionModel questionData = await questionRepository
          .getCategoryQuestions(int.parse(widget.selectedCategoryId));

      setState(() {
        questions = questionData.categoryQuestions;
      });
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWithTitle(
                title: "Lawyer's Question",
              ),
              //
              //
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child:
                        Text('Your Question has been already sent to Lawyer.'),
                  ),
                ),
              )
              // Container(
              //   height: MediaQuery.of(context).size.height / 1.7,
              //   child: ListView.builder(
              //     itemCount: questions?.length,
              //     itemBuilder: (context, index) {
              //       final question = questions?[index];
              //       return CheckboxListTile(
              //         title: Text(
              //           //
              //           question?.question ?? 'No question available',
              //           //
              //           style: CustomTextStyle.tpr15normal,
              //         ),
              //         checkColor: Colors.white,
              //         activeColor: Colors.green,
              //         value: selectedQuestionIds.contains(question?.id),
              //         onChanged: (bool? value) {
              //           setState(() {
              //             if (value != null && value) {
              //               // Add the question id to the selectedQuestionIds list
              //               selectedQuestionIds.add(question?.id ?? '');
              //             } else {
              //               // Remove the question id from the selectedQuestionIds list
              //               selectedQuestionIds.remove(question?.id);
              //             }
              //           });
              //         },
              //       );
              //     },
              //   ),
              // ),
              //
            ],
          ),
          ////////////
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text('Go For More Search'),
              ),
              RoundedForwardBtn(
                width: 240.w,
                onTap: () {
                  Navigator.pushNamed(context, '/searchselection');
                },
              ),
            ],
          ),
          //
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

///
/// Questions

class QuestionsOfLawyer extends StatefulWidget {
  const QuestionsOfLawyer({super.key, required this.question});

  final String question;

  @override
  State<QuestionsOfLawyer> createState() => _QuestionsOfLawyerState();
}

class _QuestionsOfLawyerState extends State<QuestionsOfLawyer> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /** Checkbox Widget **/
        Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.green,
          value: this.value,
          onChanged: (bool? value) {
            setState(() {
              this.value = value!;
            });
          },
        ), //Checkbox
        SizedBox(width: 10), //SizedBox
        SizedBox(
          width: 250.w,
          child: Text(
            'Are Your Available to Chat with me ?? ',
            style: CustomTextStyle.tpr15normal,
          ),
        ), //Text
      ], //<Widget>[]
    );
  }
}
