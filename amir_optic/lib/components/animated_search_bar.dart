import 'package:amir_optic/constants/colors.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:theme_provider/theme_provider.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar(
      {Key? key,
      this.onSubmitted,
      required this.textEditingController,
      this.onCloseButton})
      : super(key: key);

  final void Function(String)? onSubmitted;
  final void Function()? onCloseButton;

  final TextEditingController textEditingController;

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      color: ThemeProvider.themeOf(context).id == "dark_theme"
          ? kDSearchBarBkColor
          : kLSearchBarBkColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.ease,
        width: isOpen
            ? getValueForScreenType(
                context: context,
                mobile: size.width * 0.6,
                tablet: size.width * 0.5,
                desktop: size.width * 0.3)
            : 60,
        height: 60,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedIconButton(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                disabledColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                icons: [
                  AnimatedIconItem(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color,
                      size: 22,
                    ),
                  ),
                  AnimatedIconItem(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).iconTheme.color,
                      size: 22,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: AnimatedOpacity(
                opacity: isOpen ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: widget.onSubmitted,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.search_clients.tr(),
                          border: InputBorder.none,
                        ),
                        controller: widget.textEditingController,
                      ),
                    ),
                    AnimatedIconButton(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            widget.textEditingController.clear();
                          });
                          if (widget.onCloseButton != null) {
                            widget.onCloseButton!();
                          }
                        },
                        icons: [
                          AnimatedIconItem(
                              icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color,
                            size: 22,
                          ))
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class AnimatedSearchBar extends StatefulWidget {
//   ///  width - double ,isRequired : Yes
//   ///  textController - TextEditingController  ,isRequired : Yes
//   ///  onSuffixTap - Function, isRequired : Yes
//   ///  rtl - Boolean, isRequired : No
//   ///  autoFocus - Boolean, isRequired : No
//   ///  style - TextStyle, isRequired : No
//   ///  closeSearchOnSuffixTap - bool , isRequired : No
//   ///  suffixIcon - Icon ,isRequired :  No
//   ///  prefixIcon - Icon  ,isRequired : No
//   ///  animationDurationInMilli -  int ,isRequired : No
//   ///  helpText - String ,isRequired :  No
//   /// inputFormatters - TextInputFormatter, Required - No

//   final double width;
//   final TextEditingController textController;
//   final Icon? suffixIcon;
//   final Icon? prefixIcon;
//   final String helpText;
//   final int animationDurationInMilli;
//   final Function onSuffixTap;
//   final bool rtl;
//   final bool fromCenter;
//   final bool autoFocus;
//   final TextStyle? style;
//   final bool closeSearchOnSuffixTap;
//   final Color? color;
//   final List<TextInputFormatter>? inputFormatters;

//   final Function onSubmitted;

//   const AnimatedSearchBar({
//     Key? key,

//     /// The width cannot be null
//     required this.width,

//     /// The textController cannot be null
//     required this.textController,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.helpText = "Search...",

//     /// choose your custom color
//     this.color = Colors.white,

//     /// The onSuffixTap cannot be null
//     required this.onSuffixTap,
//     this.animationDurationInMilli = 375,

//     /// make the search bar to open from right to left
//     this.rtl = false,

//     // make the search bar to open from center to sides
//     this.fromCenter = false,

//     /// make the keyboard to show automatically when the searchbar is expanded
//     this.autoFocus = false,

//     /// TextStyle of the contents inside the searchbar
//     this.style,

//     /// close the search on suffix tap
//     this.closeSearchOnSuffixTap = false,

//     /// can add list of inputformatters to control the input
//     this.inputFormatters,
//     required this.onSubmitted,
//   }) : super(key: key);

//   @override
//   _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
// }

// ///toggle - 0 => false or closed
// ///toggle 1 => true or open
// int toggle = 0;

// class _AnimatedSearchBarState extends State<AnimatedSearchBar>
//     with SingleTickerProviderStateMixin {
//   ///initializing the AnimationController
//   late AnimationController _con;
//   FocusNode focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
//     _con = AnimationController(
//       vsync: this,

//       /// animationDurationInMilli is optional, the default value is 375
//       duration: Duration(milliseconds: widget.animationDurationInMilli),
//     );
//   }

//   unfocusKeyboard() {
//     final FocusScopeNode currentScope = FocusScope.of(context);
//     if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100.0,

//       ///if the rtl is true, search bar will be from right to left
//       alignment: widget.fromCenter
//           ? Alignment.center
//           : widget.rtl
//               ? Alignment.centerRight
//               : const Alignment(-1.0, 0.0),

//       ///Using Animated container to expand and shrink the widget
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: widget.animationDurationInMilli),
//         height: 48.0,
//         width: (toggle == 0) ? 48.0 : widget.width,
//         curve: Curves.easeOut,
//         decoration: BoxDecoration(
//           /// can add custom color or the color will be white
//           color: widget.color,
//           borderRadius: BorderRadius.circular(30.0),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               spreadRadius: -10.0,
//               blurRadius: 10.0,
//               offset: Offset(0.0, 10.0),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             ///Using Animated Positioned widget to expand and shrink the widget
//             AnimatedPositioned(
//               duration: Duration(milliseconds: widget.animationDurationInMilli),
//               top: 6.0,
//               right: 7.0,
//               curve: Curves.easeOut,
//               child: AnimatedOpacity(
//                 opacity: (toggle == 0) ? 0.0 : 1.0,
//                 duration: const Duration(milliseconds: 200),
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     /// can add custom color or the color will be white
//                     color: widget.color,
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   child: AnimatedBuilder(
//                     child: GestureDetector(
//                       onTap: () {
//                         try {
//                           ///trying to execute the onSuffixTap function
//                           widget.onSuffixTap();

//                           ///closeSearchOnSuffixTap will execute if it's true
//                           if (widget.closeSearchOnSuffixTap) {
//                             unfocusKeyboard();
//                             setState(() {
//                               toggle = 0;
//                             });
//                           }
//                         } catch (e) {
//                           ///print the error if the try block fails
//                           print(e);
//                         }
//                       },

//                       ///suffixIcon is of type Icon
//                       child: widget.suffixIcon ??
//                           const Icon(
//                             Icons.close,
//                             size: 20.0,
//                           ),
//                     ),
//                     builder: (context, widget) {
//                       ///Using Transform.rotate to rotate the suffix icon when it gets expanded
//                       return Transform.rotate(
//                         angle: _con.value * 2.0 * pi,
//                         child: widget,
//                       );
//                     },
//                     animation: _con,
//                   ),
//                 ),
//               ),
//             ),
//             AnimatedPositioned(
//               duration: Duration(milliseconds: widget.animationDurationInMilli),
//               left: (toggle == 0) ? 20.0 : 40.0,
//               curve: Curves.easeOut,
//               top: 11.0,

//               ///Using Animated opacity to change the opacity of th textField while expanding
//               child: AnimatedOpacity(
//                 opacity: (toggle == 0) ? 0.0 : 1.0,
//                 duration: const Duration(milliseconds: 200),
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 10),
//                   alignment: Alignment.topCenter,
//                   width: widget.width / 1.7,
//                   child: TextField(
//                     textInputAction: TextInputAction.done,
//                     onSubmitted: (value) {
//                       widget.onSubmitted();
//                     },

//                     ///Text Controller. you can manipulate the text inside this textField by calling this controller.
//                     controller: widget.textController,
//                     inputFormatters: widget.inputFormatters,
//                     focusNode: focusNode,
//                     cursorRadius: const Radius.circular(10.0),
//                     cursorWidth: 2.0,
//                     onEditingComplete: () {
//                       /// on editing complete the keyboard will be closed and the search bar will be closed
//                       unfocusKeyboard();
//                       setState(() {
//                         toggle = 0;
//                       });
//                     },

//                     ///style is of type TextStyle, the default is just a color black
//                     style: widget.style ?? const TextStyle(color: Colors.black),
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.only(bottom: 5),
//                       isDense: true,
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       labelText: widget.helpText,
//                       labelStyle: const TextStyle(
//                         color: Color(0xff5B5B5B),
//                         fontSize: 17.0,
//                         fontWeight: FontWeight.w300,
//                       ),
//                       alignLabelWithHint: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20.0),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             ///Using material widget here to get the ripple effect on the prefix icon
//             Material(
//               /// can add custom color or the color will be white
//               color: widget.color,
//               borderRadius: BorderRadius.circular(30.0),
//               child: IconButton(
//                 splashRadius: 19.0,

//                 ///if toggle is 1, which means it's open. so show the back icon, which will close it.
//                 ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
//                 ///prefixIcon is of type Icon
//                 icon: widget.prefixIcon != null
//                     ? toggle == 1
//                         ? const Icon(Icons.arrow_back_ios)
//                         : widget.prefixIcon!
//                     : Icon(
//                         toggle == 1 ? Icons.arrow_back_ios : Icons.search,
//                         size: 20.0,
//                       ),
//                 onPressed: () {
//                   setState(
//                     () {
//                       ///if the search bar is closed
//                       if (toggle == 0) {
//                         toggle = 1;
//                         setState(() {
//                           ///if the autoFocus is true, the keyboard will pop open, automatically
//                           if (widget.autoFocus) {
//                             FocusScope.of(context).requestFocus(focusNode);
//                           }
//                         });

//                         ///forward == expand
//                         _con.forward();
//                       } else {
//                         ///if the search bar is expanded
//                         toggle = 0;

//                         ///if the autoFocus is true, the keyboard will close, automatically
//                         setState(() {
//                           if (widget.autoFocus) unfocusKeyboard();
//                         });

//                         ///reverse == close
//                         _con.reverse();
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
