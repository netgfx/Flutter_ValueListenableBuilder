import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:flutter_valuenotifierbuilder/particle_emitter.dart';

import 'shape_master.dart';

class SpriteWidget extends StatefulWidget {
  final BoxConstraints viewportConstraints;
  final Offset particlePoint;
  SpriteWidget({Key? key, required this.viewportConstraints, required this.particlePoint}) : super(key: key);

  @override
  _SpriteWidgetState createState() => _SpriteWidgetState();
}

class _SpriteWidgetState extends State<SpriteWidget> with TickerProviderStateMixin {
  late AnimationController _spriteController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _spriteController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _spriteController.repeat();
    print("re-run");
  }

  @override
  void dispose() {
    _spriteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        key: UniqueKey(),
        isComplex: true,
        willChange: true,
        child: Container(),
        // painter: ParticleEmitter(
        //     listenable: _controller,
        //     controller: _controller,
        //     particleSize: Size(50, 50),
        //     minParticles: 50,
        //     center: Offset.zero,
        //     color: _color,
        //     radius: 10,
        //     type: ShapeType.Circle,
        //     endAnimation: EndAnimation.SCALE_DOWN,
        //     particleType: ParticleType.FIRE,
        //     spreadBehaviour: SpreadBehaviour.CONTINUOUS,
        //     minimumSpeed: 0.1,
        //     maximumSpeed: 0.2,
        //     timeToLive: {"min": 50, "max": 250},
        //     hasBase: true,
        //     blendMode: BlendMode.srcOver,
        //     delay: 2)
        //             //
        //             // FOUNTAIN
        //             //
        painter: ParticleEmitter(
            listenable: _spriteController,
            particleSize: Size(64, 64),
            minParticles: 40,
            center: Offset.zero,
            color: null,
            radius: 10,
            type: ShapeType.Star5,
            endAnimation: EndAnimation.FADE_OUT,
            particleType: ParticleType.FOUNTAIN,
            spreadBehaviour: SpreadBehaviour.CONTINUOUS,
            minimumSpeed: 0.1,
            maximumSpeed: 0.5,
            timeToLive: {"min": 500, "max": 2000},
            hasBase: false,
            blendMode: BlendMode.srcOver,
            hasWalls: true,
            wallsObj: {"bottom": (widget.viewportConstraints.maxHeight - widget.particlePoint.dy).toInt()},
            delay: 100),
      ),
    );
  }
}
