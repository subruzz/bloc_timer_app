import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/ticker.dart';

import 'package:timer_app/timer/bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Timer')),
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Actions(
               
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);

    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}

class Actions extends StatelessWidget {
  final value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              controller: value,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...switch (state) {
                  TimerInitial() => [
                      FloatingActionButton(
                          child: const Icon(Icons.play_arrow),
                          onPressed: () {
                            print(value.text);
                            context.read<TimerBloc>().add(TimerStarted(
                                duration:
                                    value.text .isNotEmpty ? int.parse(value.text): state.duration));
                          }),
                    ],
                  TimerRunInProgress() => [
                      FloatingActionButton(
                        child: const Icon(Icons.pause),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerPaused()),
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ],
                  TimerRunPause() => [
                      FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerResumed()),
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ],
                  TimerRunComplete() => [
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ]
                }
              ],
            ),
          ],
        );
      },
    );
  }
}
