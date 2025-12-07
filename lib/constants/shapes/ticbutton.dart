import 'package:flutter/material.dart';

Widget ticlist_mini(bool tap, double wid, Color? color, bool isBackground) {
  bool isSelected = tap, isGlowing = false;

  return StatefulBuilder(
    builder: (context, set) {
      glowOff() => Future.delayed(const Duration(milliseconds: 700), () {
        if (context.mounted) set(() => isGlowing = false);
      });

      return InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          set(() {
            isSelected = !isSelected;
          });
          if (isSelected) {
            isGlowing = true;
            glowOff();
          }
        },
        child: Container(
          padding: EdgeInsets.all(wid * 0.01),
          decoration: BoxDecoration(
            color:
                isBackground
                    ? isSelected
                        ? Colors.black
                        : Colors.black12
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: isGlowing ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.local_fire_department_sharp,
                  size: wid * 0.075 + 5,
                  color: Colors.orangeAccent.withOpacity(0.5),
                  shadows: [
                    Shadow(
                      color: Colors.orangeAccent.withOpacity(0.8),
                      blurRadius: 25,
                    ),
                  ],
                ),
              ),
              isSelected
                  ? ShaderMask(
                    shaderCallback:
                        (r) => const LinearGradient(
                          colors: [Color(0xFFFFBF00), Color(0xFFFF0000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(r),
                    child: Icon(
                      Icons.local_fire_department_sharp,
                      color: Colors.white,
                      size: wid * 0.075,
                    ),
                  )
                  : Icon(
                    Icons.local_fire_department_outlined,
                    color: color,
                    size: wid * 0.075,
                  ),
            ],
          ),
        ),
      );
    },
  );
}
