import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

// ignore: must_be_immutable
class TheatreBuilder extends StatefulWidget {
  TheatreBuilder({super.key, required this.theatre});
  List<String> theatre;

  @override
  State<TheatreBuilder> createState() => _TheatreBuilderState();
}

class _TheatreBuilderState extends State<TheatreBuilder> {
  Sizes size = Sizes();
  bool isSelected = false;
  bool isGlowing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.safeHeight * 0.05),
            moviesInTheatreList(),
            SizedBox(height: size.safeHeight * 0.05),
            moviesInTheatreList(),
          ],
        ),
      ),
    );
  }

  Column moviesInTheatreList() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.safeWidth * 0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.safeHeight * 0.135,
                    width: size.safeWidth * 0.24,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Movie Title',
                          style: TextStyle(
                            fontFamily: 'Semibold',
                            fontSize: size.safeWidth * 0.035,
                          ),
                        ),
                        Text(
                          'Details | Languages',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.03,
                          ),
                        ),
                        Text(
                          'Genre',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: size.safeWidth * 0.05),
              child: Container(
                height: size.safeWidth * 0.07,
                width: size.safeWidth * 0.07,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: StatefulBuilder(
                    builder: (context, set) {
                      glowOff() =>
                          Future.delayed(const Duration(milliseconds: 700), () {
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
                          // padding: EdgeInsets.all(size.safeWidth * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
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
                                  size: size.safeWidth * 0.06 + 3,
                                  color: Colors.orangeAccent.withOpacity(0.5),
                                  shadows: [
                                    Shadow(
                                      color: Colors.orangeAccent.withOpacity(
                                        0.8,
                                      ),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                              ),
                              isSelected
                                  ? ShaderMask(
                                    shaderCallback:
                                        (r) => const LinearGradient(
                                          colors: [
                                            Color(0xFFFFBF00),
                                            Color(0xFFFF0000),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ).createShader(r),
                                    child: Icon(
                                      Icons.local_fire_department_sharp,
                                      color: Colors.white,
                                      size: size.safeWidth * 0.06,
                                    ),
                                  )
                                  : Icon(
                                    Icons.local_fire_department_outlined,
                                    color: blackColor.withAlpha(200),
                                    size: size.safeWidth * 0.06,
                                  ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 7,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 10,
              childAspectRatio: (1 / 0.5),
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.safeHeight * 0.1,

                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black45),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black12,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '11:22 AM',
                            style: TextStyle(fontFamily: 'Medium'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'ATMOS',
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: size.safeWidth * 0.025,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
