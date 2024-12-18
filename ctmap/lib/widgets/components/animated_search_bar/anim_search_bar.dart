// ignore_for_file: avoid_print

import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'location_nominatim.dart';
class AnimSearchBar extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController textController;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final Function onSuffixTap;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final Color? textFieldColor;
  final Color? searchIconColor;
  final Color? textFieldIconColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool boxShadow;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final Function(int) searchBarOpen;

  // Additional properties for initial colors
  final Color initialBackgroundColor;
  final Color initialIconColor;

  const AnimSearchBar({
    super.key,
    required this.width,
    required this.height,
    required this.textController,
    required this.onSuffixTap,
    required this.onSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText = "Tìm kiếm",
    this.animationDurationInMilli = 375,
    this.rtl = true,
    this.autoFocus = false,
    this.style,
    this.closeSearchOnSuffixTap = false,
    this.color = AppColors.white,
    this.textFieldColor = AppColors.red,
    this.searchIconColor = AppColors.white,
    this.textFieldIconColor = AppColors.white,
    this.inputFormatters,
    this.boxShadow = true,
    this.textInputAction = TextInputAction.done,
    required this.searchBarOpen,
    // Initial colors
    this.initialBackgroundColor = AppColors.white,
    this.initialIconColor = AppColors.red,
  });

  @override
  State <AnimSearchBar> createState() => _AnimSearchBarState();
}

int toggle = 0;
String textFieldValue = '';

class _AnimSearchBarState extends State<AnimSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _con = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Align(
        alignment: widget.rtl ? Alignment.centerRight : const Alignment(-1.0, 0.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: widget.animationDurationInMilli),
          height: widget.height,
          width: (toggle == 0) ? 50 : widget.width,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: toggle == 1 ? widget.textFieldColor : widget.initialBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: !widget.boxShadow
                ? null
                : [
                    const BoxShadow(
                      color: Colors.black26,
                      spreadRadius: -10.0,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: widget.animationDurationInMilli),
                top: 0.0,
                right: 10.0,
                bottom: 0.0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: (toggle == 0) ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: AnimatedBuilder(
                      builder: (context, widget) {
                        return Transform.rotate(
                          angle: _con.value * 2.0 * pi,
                          child: widget,
                        );
                      },
                      animation: _con,
                      child: GestureDetector(
                        onTap: () {
                          try {
                            widget.onSuffixTap();
                            if (textFieldValue == '') {
                              unfocusKeyboard();
                              setState(() {
                                toggle = 0;
                              });
                              _con.reverse();
                            }
                            widget.textController.clear();
                            textFieldValue = '';
                            if (widget.closeSearchOnSuffixTap) {
                              unfocusKeyboard();
                              setState(() {
                                toggle = 0;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: widget.suffixIcon ??
                            Icon(
                              Icons.close,
                              size: 30.0,
                              color: widget.textFieldIconColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: widget.animationDurationInMilli),
                left: (toggle == 0) ? 20.0 : 40.0,
                curve: Curves.easeOut,
                top: 11.0,
                child: AnimatedOpacity(
                  opacity: (toggle == 0) ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: widget.width - 90,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TypeAheadField<Location>(
                          textFieldConfiguration: TextFieldConfiguration(
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: widget.textController,
                            inputFormatters: widget.inputFormatters,
                            focusNode: focusNode,
                            textInputAction: widget.textInputAction,
                            cursorRadius: const Radius.circular(10.0),
                            cursorWidth: 1.0,
                            onChanged: (value) {
                              textFieldValue = value;
                            },
                            onSubmitted: (value) {
                              widget.onSubmitted(value);
                              unfocusKeyboard();
                              setState(() {
                                toggle = 0;
                              });
                              widget.textController.clear();
                            },
                            onEditingComplete: () {
                              unfocusKeyboard();
                              setState(() {
                                toggle = 0;
                              });
                            },
                            style: widget.style ?? const TextStyle(color: AppColors.white),
                            cursorColor: AppColors.white,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(bottom: 5),
                              isDense: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: widget.helpText,
                              labelStyle: const TextStyle(
                                color: AppColors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                              ),
                              alignLabelWithHint: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            if (pattern.isEmpty) {
                              return [];
                            }
                            return await searchLocation(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              leading: const Icon(
                                AppIcons.location,
                                color: AppColors.red,
                              ),
                              title: Text(
                                suggestion.displayName,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                              textColor: AppColors.black,
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            widget.textController.text = suggestion.displayName;
                            widget.onSubmitted(suggestion.displayName);
                          },
                          noItemsFoundBuilder: (context) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Không tìm thấy',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    if (toggle == 0) {
                      toggle = 1;
                      if (widget.autoFocus) {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                      _con.forward();
                    } else {
                      toggle = 0;
                      if (widget.autoFocus) unfocusKeyboard();
                      _con.reverse();
                    }
                  });
                  widget.searchBarOpen(toggle);
                },
                child: IconButton(
                  splashRadius: 19.0,
                  icon: widget.prefixIcon != null
                      ? toggle == 1
                          ? Icon(
                              Icons.arrow_back,
                              color: widget.textFieldIconColor,
                            )
                          : widget.prefixIcon!
                      : Icon(
                          toggle == 1 ? Icons.arrow_back : Icons.search,
                          color: toggle == 0
                              ? widget.initialIconColor
                              : widget.textFieldIconColor,
                          size: 30.0,
                        ),
                  onPressed: () {
                    setState(
                      () {
                        if (toggle == 0) {
                          toggle = 1;
                          setState(() {
                            if (widget.autoFocus) {
                              FocusScope.of(context).requestFocus(focusNode);
                            }
                          });
                          _con.forward();
                        } else {
                          toggle = 0;
                          setState(() {
                            if (widget.autoFocus) unfocusKeyboard();
                          });
                          _con.reverse();
                        }
                      },
                    );
                    widget.searchBarOpen(toggle);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
