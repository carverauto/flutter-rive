import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          model.fireTrigger(model.robotHop);
                        },
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          model.fireTrigger(model.manPoint);
                        },
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          model.fireTrigger(model.horseFist);
                        },
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                      ),
                    ],
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: RiveAnimation.asset(
                    'assets/animations/chase_app.riv',
                    stateMachines: const ['Theater'],
                    fit: BoxFit.cover,
                    onInit: (artboard) {
                      model.setStateMachine(artboard);
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class HomeViewModel extends BaseViewModel {
  StateMachineController? theaterController;

  SMITrigger? manPoint;
  SMITrigger? horseFist;
  SMITrigger? robotHop;

  void fireTrigger(SMITrigger? trigger) {
    trigger?.fire();
  }

  void setStateMachine(Artboard artboard) {
    if (theaterController == null) {
      theaterController = StateMachineController.fromArtboard(artboard, 'Crowd');
      artboard.addController(theaterController!);
      manPoint = theaterController!.findInput<bool>('Man Point Left') as SMITrigger;
      horseFist = theaterController!.findInput<bool>('Horse Fist') as SMITrigger;
      robotHop = theaterController!.findInput<bool>('Robot Hop') as SMITrigger;
      notifyListeners();
    }
  }
}
