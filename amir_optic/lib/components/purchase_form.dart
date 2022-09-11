import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:amir_optic/classes/purchase_form_controller.dart';
import 'package:amir_optic/components/loading_indicator.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amir_optic/models/purchase.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({
    Key? key,
    required this.purchaseFormController,
  }) : super(key: key);

  final PurchaseFormController purchaseFormController;

  @override
  PurchaseFormState createState() => PurchaseFormState();
}

class PurchaseFormState extends State<PurchaseForm> {
  late final TextEditingController _dateFormFieldController;

  @override
  void initState() {
    _dateFormFieldController = TextEditingController(
        text:
            "${widget.purchaseFormController.purchase.purchasedAt.toDate().day}/${widget.purchaseFormController.purchase.purchasedAt.toDate().month}/${widget.purchaseFormController.purchase.purchasedAt.toDate().year}");
    widget.purchaseFormController.addListener((calledFunction) {
      if (calledFunction == "changePurchaseType") {
        _dateFormFieldController.text =
            "${widget.purchaseFormController.purchase.purchasedAt.toDate().day}/${widget.purchaseFormController.purchase.purchasedAt.toDate().month}/${widget.purchaseFormController.purchase.purchasedAt.toDate().year}";
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _dateFormFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget form;

    if (widget.purchaseFormController.purchaseType == PurchaseType.glasses) {
      form = _glassesForm();
    } else {
      form = _contactLensesForm();
    }

    return Center(
      child: SizedBox(
        width: 400,
        child: form,
      ),
    );
  }

  Form _glassesForm() {
    /*
    Returns form for the glasses purchase
    */

    return Form(
      key: widget.purchaseFormController.glassesFormKey,
      child: Column(
        children: [
          if (!kIsWeb) _buildPurchaseImage(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<PurchaseStatus>(
              value: widget.purchaseFormController.purchase.purchaseStatus,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabled: widget.purchaseFormController.enabled,
                icon: const Icon(
                  Icons.details_rounded,
                  color: Colors.green,
                ),
                labelText: LocaleKeys.purchase_status.tr(),
                hintText: LocaleKeys.purchase_status.tr(),
              ),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
              items: [
                DropdownMenuItem<PurchaseStatus>(
                  value: PurchaseStatus.ready,
                  child: Text(LocaleKeys.ready.tr()),
                ),
                DropdownMenuItem<PurchaseStatus>(
                  value: PurchaseStatus.notReady,
                  child: Text(LocaleKeys.not_ready.tr()),
                ),
              ],
              onChanged: !widget.purchaseFormController.enabled
                  ? null
                  : (value) {
                      if (value != null) {
                        widget.purchaseFormController.purchase.purchaseStatus =
                            value;
                      }
                    },
            ),
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.person,
            initialValue: widget.purchaseFormController.purchase.optometrist,
            label: LocaleKeys.optometrist.tr(),
            onChanged: (p0) {
              widget.purchaseFormController.purchase.optometrist = p0;
            },
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.lightbulb_outline,
            initialValue: widget.purchaseFormController.purchase.purchaseCause,
            label: LocaleKeys.purchase_cause.tr(),
            onChanged: (p0) {
              widget.purchaseFormController.purchase.purchaseCause = p0;
            },
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.R_VA,
                  label: "VA",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.R_VA = p0;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.R,
                  label: "R",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.R = p0;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.L_VA,
                  label: "VA",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.L_VA = p0;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.L,
                  label: "L",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.L = p0;
                  },
                ),
              ),
            ],
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.remove_red_eye_sharp,
            initialValue: widget.purchaseFormController.purchase.PD,
            label: "PD",
            onChanged: (p0) {
              widget.purchaseFormController.purchase.PD = p0;
            },
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.remove_red_eye_sharp,
            initialValue: widget.purchaseFormController.purchase.ADD,
            label: "ADD",
            onChanged: (p0) {
              widget.purchaseFormController.purchase.ADD = p0;
            },
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.remove_red_eye_sharp,
            initialValue: widget.purchaseFormController.purchase.H,
            label: "H",
            onChanged: (p0) {
              widget.purchaseFormController.purchase.H = p0;
            },
          ),
          _buildTextField(
            maxLines: 5,
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.details,
            initialValue: widget.purchaseFormController.purchase.frameDetails,
            label: LocaleKeys.frame_details.tr(),
            textInputType: TextInputType.multiline,
            onChanged: (p0) {
              widget.purchaseFormController.purchase.frameDetails = p0;
            },
          ),
          _buildTextField(
            maxLines: 5,
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.comment,
            initialValue: widget.purchaseFormController.purchase.comments,
            label: LocaleKeys.comments.tr(),
            textInputType: TextInputType.multiline,
            onChanged: (p0) {
              widget.purchaseFormController.purchase.comments = p0;
            },
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            textInputType: TextInputType.number,
            label: LocaleKeys.price.tr(),
            icon: Icons.attach_money,
            iconColor: Colors.green,
            initialValue:
                widget.purchaseFormController.purchase.price.toString(),
            enabled: widget.purchaseFormController.enabled,
            onChanged: (value) {
              if (double.tryParse(value) != null) {
                widget.purchaseFormController.purchase.price =
                    double.parse(value);
              }
            },
            validator: (value) {
              if (double.tryParse(value!) == null) {
                return LocaleKeys.price_field_type_error.tr();
              }
            },
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            icon: Icons.date_range,
            label: LocaleKeys.purchase_date.tr(),
            enabled: widget.purchaseFormController.enabled,
            controller: _dateFormFieldController,
            readOnly: true,
            onTap: () async {
              var picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now());

              if (picked != null) {
                setState(() {
                  widget.purchaseFormController.purchase.purchasedAt =
                      Timestamp.fromDate(picked);
                  _dateFormFieldController.text =
                      "${widget.purchaseFormController.purchase.purchasedAt.toDate().day}/${widget.purchaseFormController.purchase.purchasedAt.toDate().month}/${widget.purchaseFormController.purchase.purchasedAt.toDate().year}";
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Form _contactLensesForm() {
    /*
    Returns form for the contact lenses purchase
    */

    return Form(
      key: widget.purchaseFormController.contactLensesFormKey,
      child: Column(
        children: [
          if (!kIsWeb) _buildPurchaseImage(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<PurchaseStatus>(
              value: widget.purchaseFormController.purchase.purchaseStatus,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabled: widget.purchaseFormController.enabled,
                icon: const Icon(
                  Icons.details_rounded,
                  color: Colors.green,
                ),
                labelText: LocaleKeys.purchase_status.tr(),
                hintText: LocaleKeys.purchase_status.tr(),
              ),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
              items: [
                DropdownMenuItem<PurchaseStatus>(
                  value: PurchaseStatus.ready,
                  child: Text(LocaleKeys.ready.tr()),
                ),
                DropdownMenuItem<PurchaseStatus>(
                  value: PurchaseStatus.notReady,
                  child: Text(LocaleKeys.not_ready.tr()),
                ),
              ],
              onChanged: !widget.purchaseFormController.enabled
                  ? null
                  : (value) {
                      if (value != null) {
                        widget.purchaseFormController.purchase.purchaseStatus =
                            value;
                      }
                    },
            ),
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.person,
            initialValue: widget.purchaseFormController.purchase.optometrist,
            label: LocaleKeys.optometrist.tr(),
            onChanged: (p0) {
              widget.purchaseFormController.purchase.optometrist = p0;
            },
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.lightbulb_outline,
            initialValue: widget.purchaseFormController.purchase.purchaseCause,
            label: LocaleKeys.purchase_cause.tr(),
            onChanged: (p0) {
              widget.purchaseFormController.purchase.purchaseCause = p0;
            },
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.R,
                  label: "R",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.R = p0;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.R_VA,
                  label: "VA",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.R_VA = p0;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.L,
                  label: "L",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.L = p0;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildTextField(
                  enabled: widget.purchaseFormController.enabled,
                  icon: Icons.remove_red_eye_sharp,
                  initialValue: widget.purchaseFormController.purchase.L_VA,
                  label: "VA",
                  onChanged: (p0) {
                    widget.purchaseFormController.purchase.L_VA = p0;
                  },
                ),
              ),
            ],
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.remove_red_eye_sharp,
            initialValue: widget.purchaseFormController.purchase.BC,
            label: "BC",
            onChanged: (p0) {
              widget.purchaseFormController.purchase.BC = p0;
            },
          ),
          _buildTextField(
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.remove_red_eye_sharp,
            initialValue: widget.purchaseFormController.purchase.D,
            label: "D",
            onChanged: (p0) {
              widget.purchaseFormController.purchase.D = p0;
            },
          ),
          _buildTextField(
            maxLines: 5,
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.details,
            initialValue: widget.purchaseFormController.purchase.details,
            label: LocaleKeys.details.tr(),
            textInputType: TextInputType.multiline,
            onChanged: (p0) {
              widget.purchaseFormController.purchase.details = p0;
            },
          ),
          _buildTextField(
            maxLines: 5,
            textDirection: ui.TextDirection.rtl,
            enabled: widget.purchaseFormController.enabled,
            icon: Icons.comment,
            initialValue: widget.purchaseFormController.purchase.comments,
            label: LocaleKeys.comments.tr(),
            textInputType: TextInputType.multiline,
            onChanged: (p0) {
              widget.purchaseFormController.purchase.comments = p0;
            },
          ),
          _buildTextField(
            initialValue:
                widget.purchaseFormController.purchase.price.toString(),
            enabled: widget.purchaseFormController.enabled,
            label: LocaleKeys.price.tr(),
            icon: Icons.attach_money,
            iconColor: Colors.green,
            textInputType: TextInputType.number,
            textDirection: ui.TextDirection.rtl,
            onChanged: (value) {
              if (double.tryParse(value) != null) {
                widget.purchaseFormController.purchase.price =
                    double.parse(value);
              }
            },
            validator: (value) {
              if (double.tryParse(value!) == null) {
                return LocaleKeys.price_field_type_error.tr();
              }
            },
          ),
          _buildTextField(
            textDirection: ui.TextDirection.rtl,
            icon: Icons.date_range,
            label: LocaleKeys.purchase_date.tr(),
            enabled: widget.purchaseFormController.enabled,
            controller: _dateFormFieldController,
            readOnly: true,
            onTap: () async {
              var picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now());

              if (picked != null) {
                setState(() {
                  widget.purchaseFormController.purchase.purchasedAt =
                      Timestamp.fromDate(picked);
                  _dateFormFieldController.text =
                      "${widget.purchaseFormController.purchase.purchasedAt.toDate().day}/${widget.purchaseFormController.purchase.purchasedAt.toDate().month}/${widget.purchaseFormController.purchase.purchasedAt.toDate().year}";
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseImage() {
    /*
    Returns the image of the purchase
    */

    late Widget _purchaseImage; // Will contain the purchase's image widget

    // If there is no image
    if (widget.purchaseFormController.pickedImage == null) {
      _purchaseImage = CircleAvatar(
        radius: 80,
        child:
            widget.purchaseFormController.purchaseType == PurchaseType.glasses
                ? Image.asset(
                    "assets/images/glasses.png",
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.remove_red_eye,
                    size: 100,
                  ),
      );
    } else {
      // Reads the purchase's image file and return Image widget
      _purchaseImage = FutureBuilder<Uint8List>(
        future: widget.purchaseFormController.pickedImage!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(
              radius: 80,
              child: Text(LocaleKeys.error.tr()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return CircleAvatar(
            radius: 80,
            backgroundImage: MemoryImage(snapshot.data!),
          );
        },
      );
    }

    return Column(
      children: [
        OpenContainer(
          tappable: widget.purchaseFormController.pickedImage != null,
          openElevation: 0,
          closedElevation: 0,
          closedColor: Colors.transparent,
          openBuilder: (context, action) => Scaffold(
            appBar: AppBar(),
            body: FutureBuilder<Uint8List>(
                future:
                    widget.purchaseFormController.pickedImage!.readAsBytes(),
                builder: (context, snasphot) {
                  if (snasphot.hasError) {
                    return Center(
                      child: Text(LocaleKeys.error.tr()),
                    );
                  }

                  if (snasphot.connectionState == ConnectionState.waiting) {
                    return LoadingIndicator(
                      title: LocaleKeys.loading.tr(),
                    );
                  }
                  return Center(
                      child: InteractiveViewer(
                          child: Image.memory(snasphot.data!)));
                }),
          ),
          closedBuilder: (context, action) => _purchaseImage,
        ),
        IconButton(
            onPressed: !widget.purchaseFormController.enabled
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) {
                            return SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(LocaleKeys.replace_image.tr()),
                                    onTap: changePurchaseImageOnClick,
                                  ),
                                  ListTile(
                                    title: Text(LocaleKeys.remove_image.tr()),
                                    onTap: removePurchaseImageOnClick,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
            icon: const Icon(Icons.edit)),
      ],
    );
  }

  Future<XFile?> pickImage(ImageSource? imageSource) async {
    /*
    Pickes image and returns it as XFile object
    */
    return await ImagePicker().pickImage(source: imageSource!);
  }

  void changePurchaseImageOnClick() {
    /*
    Called when the change purchase's image button is clicked
    */
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return SizedBox(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    trailing: const Icon(Icons.collections),
                    title: Text(LocaleKeys.gallery.tr()),
                    onTap: () async {
                      widget.purchaseFormController.pickedImage =
                          await pickImage(ImageSource.gallery);
                      Navigator.of(context).pop(); // Closes second bottom sheet
                      Navigator.of(context).pop(); // Closes first bottom sheet

                      if (widget.purchaseFormController.pickedImage != null) {
                        setState(() {});
                      }
                    },
                  ),
                  ListTile(
                    trailing: const Icon(Icons.camera),
                    title: Text(LocaleKeys.camera.tr()),
                    onTap: () async {
                      widget.purchaseFormController.pickedImage =
                          await pickImage(ImageSource.camera);
                      Navigator.of(context).pop(); // Closes second bottom sheet
                      Navigator.of(context).pop(); // Closes first bottom sheet

                      if (widget.purchaseFormController.pickedImage != null) {
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void removePurchaseImageOnClick() {
    /*
    Called when the remove purchase's image button is clicked
    */
    setState(() {
      widget.purchaseFormController.pickedImage = null;
    });
    Navigator.of(context).pop(); // Closes bottom sheet
  }

  Widget _buildTextField({
    GlobalKey<FormState>? key,
    String? label,
    IconData? icon,
    Color? iconColor,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    ui.TextDirection textDirection = ui.TextDirection.ltr,
    String? initialValue,
    bool enabled = true,
    TextInputType textInputType = TextInputType.text,
    TextEditingController? controller,
    void Function()? onTap,
    bool readOnly = false,
    int? maxLines = 1,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    // With border
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: textInputAction,
        minLines: 1,
        maxLines: maxLines,
        key: key,
        readOnly: readOnly,
        onTap: onTap,
        textDirection: textDirection,
        controller: controller,
        initialValue: initialValue,
        enabled: enabled,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(color: enabled ? null : Colors.grey),
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintTextDirection: textDirection,
          labelText: label,
          hintText: label,
          icon: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
