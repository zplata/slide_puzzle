// ignore: duplicate_ignore
// ignore_for_file: library_private_types_in_public_api, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PuzzleContainer extends StatelessWidget {
  const PuzzleContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/rive/birb.riv',
      artboard: 'LayoutStatic',
      animations: ['Animation 1'],
      fit: BoxFit.cover,
    );
  }
}

class StarAnimation extends StatelessWidget {
  const StarAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/rive/birb.riv',
      animations: ['starBurst'],
      fit: BoxFit.cover,
      artboard: 'starSingle',
    );
  }
}

class TileAnimation extends StatefulWidget {
  const TileAnimation({
    Key? key,
    required this.wasPressed,
    required this.clickCallback,
    required this.resetPressedCallback,
    required this.isCorrectPlace,
  }) : super(key: key);

  final bool wasPressed;
  final bool isCorrectPlace;
  final void Function(SMITrigger) clickCallback;
  final void Function() resetPressedCallback;

  @override
  _TileAnimation createState() => _TileAnimation();
}

class _TileAnimation extends State<TileAnimation> {
  SMIBool? _isHovering;
  SMITrigger? _offTrigger;

  int test = 0;

  void onTryStateChange(String a, String b) {
    // When the 'off' animation of the state machine is triggered, reset the parent
    // '_wasPressed' state variable to restore the number on the tile
    if (b == 'on') {
      widget.resetPressedCallback();
    }
  }

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(
          artboard,
          'tileAnimateSm',
          onStateChange: onTryStateChange,
        );

    artboard.addController(controller!);
    _isHovering = controller.findInput<bool>('hover') as SMIBool?;
    _offTrigger = controller.findInput<bool>('offTrigger') as SMITrigger?;
  }

  @override
  void didUpdateWidget(TileAnimation oldWidget) {
    if (oldWidget.wasPressed == false &&
        widget.wasPressed == true &&
        _offTrigger != null) {
      widget.clickCallback(_offTrigger!);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHovering?.value = true;
      },
      onExit: (_) {
        _isHovering?.value = false;
      },
      child: RiveAnimation.asset(
        'assets/rive/birb.riv',
        artboard: 'tileAnimate',
        onInit: _onRiveInit,
        fit: BoxFit.cover,
      ),
    );
  }
}

class StaticBirdAnimation extends StatefulWidget {
  const StaticBirdAnimation({Key? key}) : super(key: key);

  @override
  _StaticBirdAnimation createState() => _StaticBirdAnimation();
}

class _StaticBirdAnimation extends State<StaticBirdAnimation> {
  // StateMachineInput Boolean (abbr. SMIBool)
  // This input will control whether Dash dances
  SMIBool? _isDancing;

  void _onRiveInit(Artboard artboard) {
    // Instance a State Machine Controller from the
    // "birb" state machine in our editor
    final controller = StateMachineController.fromArtboard(artboard, 'birb');

    // Associate the controller to the artboard
    artboard.addController(controller!);

    // Find the name of the input from the state machine controller and set it
    _isDancing = controller.findInput<bool>('dance') as SMIBool?;

    // Don't let Dash dance when the animation renders
    setState(() {
      if (_isDancing != null) {
        _isDancing!.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isDancing?.value != null) {
          _isDancing?.value = !_isDancing!.value;
        }
      },
      child: RiveAnimation.asset(
        'assets/rive/birb.riv',
        artboard: 'birb',
        stateMachines: const ['birb'],
        onInit: _onRiveInit,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return RiveAnimation.asset('assets/rive/birb.riv',
  //       artboard: 'birb', onInit: _onRiveInit);
  // }
}

// ignore: public_member_api_docs
class WhitespaceBirdAnimation extends StatefulWidget {
  // ignore: public_member_api_docs
  const WhitespaceBirdAnimation({Key? key}) : super(key: key);

  @override
  _WhitespaceBirdAnimation createState() => _WhitespaceBirdAnimation();
}

class _WhitespaceBirdAnimation extends State<WhitespaceBirdAnimation> {
  SMIBool? _isTileBirdUp;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'tileBird');
    artboard.addController(controller!);
    _isTileBirdUp = controller.findInput<bool>('on') as SMIBool?;
    setState(() {
      if (_isTileBirdUp != null) {
        _isTileBirdUp!.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isTileBirdUp?.value = true,
      onExit: (_) => _isTileBirdUp?.value = false,
      child: RiveAnimation.asset(
        'assets/rive/birb.riv',
        artboard: 'tileBird',
        onInit: _onRiveInit,
      ),
    );
  }
}
