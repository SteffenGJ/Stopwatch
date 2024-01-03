import "dart:async";
import "package:flutter/material.dart";
import "package:stopwatch/platform_alert.dart";

class StopWatch extends StatefulWidget {
  final String? name;
  final String? email;
  static const route = "/stopwatch";

  const StopWatch({super.key, this.name, this.email});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool isTicking = false;
  int milliseconds = 0;
  Timer? timer;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  void _onTick(Timer timer) {
    setState(() {
      milliseconds += 100;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);

    setState(() {
      isTicking = true;
      laps.clear();
    });
  }

  void _stopTimer(BuildContext context) {
    timer?.cancel();
    setState(() {
      isTicking = false;
    });
    // final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    // final alert = PlatformAlert(
    //     title: "Run Completed!",
    //     message: "Total Run Rime is ${_secondsText(totalRuntime)}");
    // alert.show(context);
    final controller =
        showBottomSheet(context: context, builder: _buildRunCompleteSheet);

    Future.delayed(Duration(seconds: 5)).then((_) {
      controller.close();
    });
  }

  Widget _buildRunCompleteSheet(BuildContext context) {
    final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
        child: Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Run finished!", style: textTheme.headlineMedium),
            Text("Total run time is ${_secondsText(totalRuntime)}"),
          ],
        ),
      ),
    ));
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return "$seconds seconds";
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });
    scrollController.animateTo(
      laps.length * itemHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? name = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? "Stopwatch"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lap ${laps.length + 1}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    _secondsText(milliseconds),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text("Start"),
                        onPressed: isTicking ? null : _startTimer,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: Text("Lap"),
                        onPressed: isTicking ? _lap : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Builder(builder: (context) {
                        return TextButton(
                          onPressed:
                              isTicking ? () => _stopTimer(context) : null,
                          child: Text("Stop"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                  controller: scrollController,
                  itemExtent: itemHeight,
                  itemCount: laps.length,
                  itemBuilder: ((context, index) {
                    final milliseconds = laps[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      title: Text("Lap ${index + 1}"),
                      trailing: Text(_secondsText(milliseconds)),
                    );
                  })),
            ),
          )
        ],
      ),
    );
  }
}
