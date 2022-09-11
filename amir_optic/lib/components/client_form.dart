import 'package:amir_optic/classes/client_form_controller.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClientForm extends StatefulWidget {
  const ClientForm({Key? key, required this.clientFormController})
      : super(key: key);

  final ClientFormController clientFormController;

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  Widget buildIcon(int index) {
    if (index == widget.clientFormController.client.phoneNumbers.length - 1) {
      return IconButton(
          onPressed: !widget.clientFormController.enabled
              ? null
              : () {
                  widget.clientFormController.client.phoneNumbers.add("");

                  setState(() {});
                },
          icon: const Icon(Icons.add));
    }

    return Container();
  }

  String? idValidator(String? id) {
    if (id == null || id.isEmpty) {
      return null;
      // return LocaleKeys.field_empty_error.tr();
    }

    // Checks if the id is valid
    if (id.length != 9) {
      return LocaleKeys.id_field_length_error.tr();
    }

    List<int> idCharacters = [];
    int index = 0;
    for (var num in id.characters) {
      idCharacters.add((int.parse(num) * ((index % 2 == 0) ? 1 : 2)));
      index++;
    }

    idCharacters = idCharacters.map((e) {
      if (e > 9) {
        return int.parse(e.toString()[0]) + int.parse(e.toString()[1]);
      }

      return e;
    }).toList();

    int result = 0;
    for (var element in idCharacters) {
      result += int.parse("$element");
    }

    if (result % 10 == 0) return null;

    return LocaleKeys.id_field_invalid_error.tr();
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    for (var digit in value.characters) {
      if (double.tryParse(digit) == null) {
        return LocaleKeys.invalid_phone_number_type.tr();
      }
    }
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.field_empty_error.tr();
    }

    for (var char in value.characters) {
      if (double.tryParse(char) != null) {
        return LocaleKeys.invalid_name_type.tr();
      }
    }

    if (value.endsWith(" ")) {
      return LocaleKeys.end_with_space_error.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Form(
          key: widget.clientFormController.formKey,
          child: Column(
            children: [
              _buildTextField(
                enabled: widget.clientFormController.enabled,
                initialValue: widget.clientFormController.client.id,
                label: LocaleKeys.id.tr(),
                icon: Icons.insert_drive_file,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.clientFormController.client.id = value;
                },
                validator: idValidator,
              ),
              _buildTextField(
                enabled: widget.clientFormController.enabled,
                initialValue: widget.clientFormController.client.firstName,
                label: LocaleKeys.first_name.tr(),
                icon: Icons.account_circle_outlined,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  widget.clientFormController.client.firstName = value;
                },
                validator: nameValidator,
              ),
              _buildTextField(
                enabled: widget.clientFormController.enabled,
                initialValue: widget.clientFormController.client.lastName,
                label: LocaleKeys.last_name.tr(),
                icon: Icons.account_circle_outlined,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  widget.clientFormController.client.lastName = value;
                },
                validator: nameValidator,
              ),
              Column(
                children: List.generate(
                  widget.clientFormController.client.phoneNumbers.length,
                  (index) => Slidable(
                    enabled: widget.clientFormController.enabled &&
                        widget.clientFormController.client.phoneNumbers.length >
                            1,
                    startActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        label: LocaleKeys.delete.tr(),
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (context) {
                          widget.clientFormController.client.phoneNumbers
                              .removeAt(index);
                          setState(() {});
                        },
                      )
                    ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            enabled: widget.clientFormController.enabled,
                            initialValue: widget.clientFormController.client
                                .phoneNumbers[index],
                            label: LocaleKeys.phone_number.tr(),
                            icon: Icons.phone,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              widget.clientFormController.client
                                  .phoneNumbers[index] = value;
                            },
                            validator: phoneNumberValidator,
                          ),
                        ),
                        buildIcon(index),
                      ],
                    ),
                  ),
                ),
              ),
              _buildTextField(
                enabled: widget.clientFormController.enabled,
                initialValue: widget.clientFormController.client.address,
                label: LocaleKeys.address.tr(),
                icon: Icons.home,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  widget.clientFormController.client.address = value;
                },
              ),
              _buildTextField(
                enabled: widget.clientFormController.enabled,
                initialValue: widget.clientFormController.client.comments,
                label: LocaleKeys.comments.tr(),
                icon: Icons.comment,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  widget.clientFormController.client.comments = value;
                },
                maxLines: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: widget.clientFormController.client.hmo == ""
                      ? null
                      : widget.clientFormController.client.hmo,
                  decoration: InputDecoration(
                    enabled: widget.clientFormController.enabled,
                    border: const OutlineInputBorder(),
                    icon: const Icon(
                      Icons.local_hospital,
                      color: Colors.green,
                    ),
                    labelText: LocaleKeys.hmo.tr(),
                    hintText: LocaleKeys.hmo.tr(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.hmo_field_empty_error.tr();
                    }
                  },
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color),
                  items: <String>[
                    "כללית",
                    "לאומית",
                    'מכבי',
                    "מאוחדת",
                    "לקוח פרטי"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                      ),
                    );
                  }).toList(),
                  onChanged: !widget.clientFormController.enabled
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              widget.clientFormController.client.hmo = value;
                            });
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required String? initialValue,
      bool enabled = true,
      IconData? icon,
      void Function(String)? onChanged,
      String? Function(String?)? validator,
      TextInputType? keyboardType = TextInputType.text,
      int maxLines = 1,
      TextInputAction textInputAction = TextInputAction.next}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enabled,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: 1,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            hintText: label,
            icon: Icon(icon)),
      ),
    );
  }
}
