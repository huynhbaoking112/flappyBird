import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/barriers.dart';
import 'package:flutter_application_1/components/bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//bird variable
  double birdYaxis = 0;
  double birdXaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0; //equal to birdYaxis
  bool gameHasStarted = false;
  bool gameOver = false;
  static double barrierXone = 0.5;
  double barrierXtwo = barrierXone + 1;
  double score = 0;
  double maxScore = 0;

//bird action
  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = (-4.9) * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

    
      if (birdYaxis >= 1) {
        timer.cancel();
        setState(() {
          gameOver = true;
          if(score > maxScore){
             maxScore = score;;
          }
          score = 0;
        });
      }else if(barrierXone < barrierXtwo  ){
        if((birdYaxis >=0.3 || birdYaxis <= -0.4)  ){
          timer.cancel();
        setState(() {
          gameOver = true;
          if(score > maxScore){
             maxScore = score;;
          }
          score = 0;
        });
        }
      }else if(barrierXone > barrierXtwo  ){
        if((birdYaxis >=0.4 || birdYaxis <= -0.4) &&  (barrierXtwo - birdXaxis < 0.2  && barrierXtwo - birdXaxis > 0)){
          timer.cancel();
        setState(() {
          gameOver = true;
          if(score > maxScore){
             maxScore = score;;
          }
          score = 0;
        });
        }
      }

      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += 2;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += 2;
        } else {
          barrierXtwo -= 0.05;
        }
      });

       
        if((barrierXone < 0.05 && barrierXone > 0 ) || (barrierXtwo < 0.09 && barrierXtwo > 0.04 ) ){
        setState(() {
          score += 10 ;
        });
      }

    });
  }

  void playAgain() {
    setState(() {
      gameOver = false;
      birdYaxis = 0;
      birdXaxis = 0;
      time = 0;
      initialHeight = 0;
      gameHasStarted = false;
      barrierXone = 0.5;
      barrierXtwo = barrierXone + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    if (gameHasStarted) {
                      jump();
                    } else {
                      startGame();
                    }
                  },
                  child: AnimatedContainer(
                    alignment: Alignment(birdXaxis, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const MyBird(),
                  ),
                ),
                gameHasStarted
                    ? Container()
                    : Container(
                        alignment: const Alignment(0, -0.3),
                        child: const Text(
                          'T A P T O P L A Y',
                          style: TextStyle(
                              wordSpacing: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(barrierXone, 1.1),
                  child:  MyBarrier(size: MediaQuery.of(context).size.height / 2 * 0.4),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(barrierXone, -1.1),
                  child: MyBarrier(size: MediaQuery.of(context).size.height / 2 * 0.4),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(barrierXtwo, -1.1),
                  child: MyBarrier(size: MediaQuery.of(context).size.height / 2 * 0.3),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(barrierXtwo, 1.1),
                  child: MyBarrier(size: MediaQuery.of(context).size.height / 2 * 0.5),
                ),
                gameOver
                    ? Align(
                        alignment: const Alignment(0, 0),
                        child: ElevatedButton(
                            onPressed: playAgain,
                            child: const Text(
                              "P L A Y A G A I N",
                            )))
                    : Container(),
              ])),
          Container(height: 15, color: Colors.green),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(color: Colors.brown),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SCORE',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(score.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 25))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('BEST',
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                    Text(maxScore.toString(),
                        style:const TextStyle(color: Colors.white, fontSize: 25))
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
