import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkome_front/presentation/widgets/utils/modal_view.dart';
import 'package:inkome_front/presentation/widgets/utils/base_text_form_field.dart';
import 'package:inkome_front/presentation/widgets/utils/custom_button.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

class AdTagEditor extends StatefulWidget {
  final void Function(String)? onFieldSubmitted;
  final List<String>? tags;
  final Function(List<String>)? onTagsChanged;

  const AdTagEditor({
    Key? key,
    this.tags,
    this.onTagsChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  TagEditorWidgetState createState() => TagEditorWidgetState();
}

class TagEditorWidgetState extends State<AdTagEditor> {
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _tags = widget.tags ?? [];
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
    });
    _notifyTagsChanged();
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    _notifyTagsChanged();
  }

  void _notifyTagsChanged() {
    if (widget.onTagsChanged != null) {
      widget.onTagsChanged!(_tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_tags.isNotEmpty)
          const TextView(
            color: Colors.black,
            text: 'Tags:',
            fontWeight: FontWeight.bold,
          ),
        SizedBox(height: _tags.isNotEmpty ? 15 : 0),
        _buildChipView(),
        SizedBox(height: _tags.isNotEmpty ? 15 : 0),
        Center(
          child: CustomButton(
            onPressed: () {
              _showAddTagDialog(context);
            },
            text: 'Agregar Tag',
          ),
        ),
      ],
    );
  }

  Widget _buildChipView() {
    return Wrap(
      spacing: 8,
      runSpacing: 2,
      children: _tags.map((tag) {
        return Chip(
          backgroundColor: Colors.black,
          label: TextView(
            text: tag,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          deleteIcon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              CupertinoIcons.xmark,
              color: Colors.black,
              size: 11,
            ),
          ),
          onDeleted: () {
            _removeTag(tag);
          },
        );
      }).toList(),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        String newTag = '';
        return ModalView(
          heightFactor: .3,
          widthFactor: .9,
          content: Column(
            children: [
              const TextView(
                text: 'Agregar Tag',
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
              const Spacer(),
              BaseTextFormField(
                onChange: (value, _) {
                  newTag = value!;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(
                      CupertinoIcons.tag_circle,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '# type a tag'),
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  if (newTag.isNotEmpty) {
                    _addTag(newTag);
                  }
                  Navigator.pop(context);
                },
                text: 'Agregar',
              ),
            ],
          ),
        );
      },
    );
  }
}
