// import 'package:flutter/material.dart';
// import 'package:ticpin/constants/models/user/user.dart';
// import 'package:ticpin/constants/models/user/userservice.dart';
// import 'package:ticpin/constants/size.dart';

// class TicListButton extends StatefulWidget {
//   final String itemId;
//   final TicListItemType itemType;
//   // final bool isInTicList;
//   final VoidCallback onToggle;
//   // final double wid;
//   final Color? color;
//   final bool isBackground;

//   // ignore: use_super_parameters
//   const TicListButton({
//     Key? key,
//     required this.itemId,
//     required this.itemType,
//     // required this.isInTicList,
//     required this.isBackground,
//     // required this.wid,
//     this.color,
//   required  this.onToggle,
//   }) : super(key: key);

//   @override
//   State<TicListButton> createState() => _TicListButtonState();
// }

// class _TicListButtonState extends State<TicListButton> {
//   final UserService _userService = UserService();
//   bool _isLoading = false;
//   bool isGlowing = false;
//   bool isInTicList = false;

//   void _showSnackBar(String message, Color backgroundColor) {
//     if (!mounted) return;

//     // Use a try-catch to handle cases where context is invalid
//     try {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: backgroundColor,
//           duration: Duration(seconds: 1),
//         ),
//       );
//     } catch (e) {
//       // Silently fail if scaffold messenger is unavailable
//       debugPrint('Could not show snackbar: $e');
//     }
//   }

//   Future<void> _toggleTicList() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       if (isInTicList) {
//         await _userService.removeFromTicList(widget.itemId, widget.itemType);
//         _showSnackBar('Removed from TicList', Colors.orange);

//         if (mounted) {
//           setState(() => isGlowing = true);
//           Future.delayed(const Duration(milliseconds: 700), () {
//             if (mounted) setState(() => isGlowing = false);
//           });
//         }
//       } else {
//         await _userService.addToTicList(widget.itemId, widget.itemType);
//         _showSnackBar('Added to TicList', Colors.green);
//       }

//       // widget.onToggle?.call();
//     } catch (e) {
//       _showSnackBar('Error: ${e.toString()}', Colors.red);
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
import 'package:flutter/material.dart';
import 'package:ticpin/constants/models/user/user.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';

class TicListButton extends StatefulWidget {
  final String itemId;
  final TicListItemType itemType;
  final VoidCallback? onToggle;
  final Color? color;
  final bool isBackground;

  const TicListButton({
    Key? key,
    required this.itemId,
    required this.itemType,
    required this.isBackground,
    this.color,
    this.onToggle,
  }) : super(key: key);

  @override
  State<TicListButton> createState() => _TicListButtonState();
}

class _TicListButtonState extends State<TicListButton> {
  final UserService _userService = UserService();
  bool _isLoading = false;
  bool isGlowing = false;
  bool isInTicList = false;

  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    _checkInitialTicList();
  }

  Future<void> _checkInitialTicList() async {
    // Check Firestore if item is already in TicList
    final inList = await _userService.isInTicList(
      widget.itemId,
      widget.itemType,
    );
    if (mounted) setState(() => isInTicList = inList);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _toggleTicList() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      if (isInTicList) {
        await _userService.removeFromTicList(widget.itemId, widget.itemType);
        _showSnackBar('Removed from TicList', Colors.orange);
        setState(() {
          isInTicList = false;
          isGlowing = true;
        });
      } else {
        await _userService.addToTicList(widget.itemId, widget.itemType);
        _showSnackBar('Added to TicList', Colors.green);
        setState(() {
          isInTicList = true;
          isGlowing = true;
        });
      }

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => isGlowing = false);
      });

      widget.onToggle?.call();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, set) {
        return InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: _isLoading ? null : _toggleTicList,
          child: Container(
            padding: EdgeInsets.all(size.safeWidth * 0.01),
            decoration: BoxDecoration(
              color:
                  widget.isBackground
                      ? isInTicList
                          ? Colors.black
                          : Colors.black12
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                isInTicList
                    ? AnimatedOpacity(
                      opacity: isGlowing ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.local_fire_department_sharp,
                        size: size.safeWidth * 0.075 + 5,
                        color: Colors.orangeAccent.withOpacity(0.5),
                        shadows: [
                          Shadow(
                            color: Colors.orangeAccent.withOpacity(0.8),
                            blurRadius: 25,
                          ),
                        ],
                      ),
                    )
                    : AnimatedOpacity(
                      opacity: isGlowing ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.local_fire_department_sharp,
                        size: size.safeWidth * 0.075 + 5,
                        color: Colors.transparent,
                        shadows: [
                          // Shadow(
                          //   color: Colors.orangeAccent.withOpacity(0.8),
                          //   blurRadius: 25,
                          // ),
                        ],
                      ),
                    ),
                isInTicList
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
                        size: size.safeWidth * 0.075,
                      ),
                    )
                    : Icon(
                      Icons.local_fire_department_outlined,
                      color: widget.color,
                      size: size.safeWidth * 0.075,
                    ),
              ],
            ),
          ),
        );
      },
    );

    // class _TicListButtonState extends State<TicListButton> {
    //   final UserService _userService = UserService();
    //   bool _isLoading = false;
    //   bool isGlowing = false;

    //   Future<void> _toggleTicList() async {
    //     setState(() => _isLoading = true);

    //     try {
    //       if (widget.isInTicList) {
    //         await _userService.removeFromTicList(widget.itemId, widget.itemType);
    //         if (mounted) {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: Text('Removed from TicList'),
    //               backgroundColor: Colors.orange,
    //               duration: Duration(seconds: 1),
    //             ),
    //           );
    //         }

    //         isGlowing = true;
    //         Future.delayed(const Duration(milliseconds: 700), () {
    //           if (context.mounted) setState(() => isGlowing = false);
    //         });
    //       } else {
    //         await _userService.addToTicList(widget.itemId, widget.itemType);
    //         if (mounted) {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: Text('Added to TicList'),
    //               backgroundColor: Colors.green,
    //               duration: Duration(seconds: 1),
    //             ),
    //           );
    //         }
    //       }

    //       if (widget.onToggle != null) {
    //         widget.onToggle!();
    //       }
    //     } catch (e) {
    //       if (mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text('Error: ${e.toString()}'),
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       }
    //     } finally {
    //       if (mounted) {
    //         setState(() => _isLoading = false);
    //       }
    //     }
    //   }

    //   @override
    //   Widget build(BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (context, set) {
    //         return InkWell(
    //           splashFactory: NoSplash.splashFactory,
    //           onTap: _isLoading ? null : _toggleTicList,
    //           // onTap:  () {
    //           //   set(() {
    //           //     isSelected = !isSelected;
    //           //   });
    //           //   if (isSelected) {
    //           //     isGlowing = true;
    //           //     glowOff();
    //           //   }
    //           // },
    //           child: Container(
    //             padding: EdgeInsets.all(widget.wid * 0.01),
    //             decoration: BoxDecoration(
    //               color:
    //                   widget.isBackground
    //                       ? widget.isInTicList
    //                           ? Colors.black
    //                           : Colors.black12
    //                       : Colors.transparent,
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             child: Stack(
    //               alignment: Alignment.center,
    //               children: [
    //                 AnimatedOpacity(
    //                   opacity: isGlowing ? 1 : 0,
    //                   duration: const Duration(milliseconds: 300),
    //                   child: Icon(
    //                     Icons.local_fire_department_sharp,
    //                     size: widget.wid * 0.075 + 5,
    //                     color: Colors.orangeAccent.withOpacity(0.5),
    //                     shadows: [
    //                       Shadow(
    //                         color: Colors.orangeAccent.withOpacity(0.8),
    //                         blurRadius: 25,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 widget.isInTicList
    //                     ? ShaderMask(
    //                       shaderCallback:
    //                           (r) => const LinearGradient(
    //                             colors: [Color(0xFFFFBF00), Color(0xFFFF0000)],
    //                             begin: Alignment.topCenter,
    //                             end: Alignment.bottomCenter,
    //                           ).createShader(r),
    //                       child: Icon(
    //                         Icons.local_fire_department_sharp,
    //                         color: Colors.white,
    //                         size: widget.wid * 0.075,
    //                       ),
    //                     )
    //                     : Icon(
    //                       Icons.local_fire_department_outlined,
    //                       color: widget.color,
    //                       size: widget.wid * 0.075,
    //                     ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     );
    // return IconButton(
    //   onPressed: ,
    //   icon:
    //       _isLoading
    //           ? SizedBox(
    //             width: 20,
    //             height: 20,
    //             child: CircularProgressIndicator(strokeWidth: 2),
    //           )
    //           : Icon(
    //             widget.isInTicList ? Icons.bookmark : Icons.bookmark_border,
    //             color: widget.isInTicList ? Colors.red : blackColor,
    //           ),
    // );
  }
}

// Widget ticlist_mini(
//   bool tap,
//   double wid,
//   Color? color,
//   bool isBackground,
//   String itemId,
//   TicListItemType itemType,
//   bool isInTicList,
//   VoidCallback? onToggle,
// ) {
//   bool isSelected = tap, 
//   final UserService _userService = UserService();
//   bool _isLoading = false;

//   Future<void> _toggleTicList() async {
//     setState(() => _isLoading = true);

//     try {
//       if (widget.isInTicList) {
//         await _userService.removeFromTicList(widget.itemId, widget.itemType);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Removed from TicList'),
//               backgroundColor: Colors.orange,
//               duration: Duration(seconds: 1),
//             ),
//           );
//         }
//       } else {
//         await _userService.addToTicList(widget.itemId, widget.itemType);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Added to TicList'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 1),
//             ),
//           );
//         }
//       }

//       if (onToggle != null) {
//         onToggle!();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

 
// }
