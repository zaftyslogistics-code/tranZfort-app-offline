import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tranzfort_tms/presentation/providers/suggestion_provider.dart';

/// Smart Location Field with Auto-Complete Suggestions
class SmartLocationField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const SmartLocationField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  ConsumerState<SmartLocationField> createState() => _SmartLocationFieldState();
}

class _SmartLocationFieldState extends ConsumerState<SmartLocationField> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChange);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _loadSuggestions();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        _removeOverlay();
      });
    }
  }

  void _onTextChange() {
    if (_focusNode.hasFocus) {
      _loadSuggestions();
    }
  }

  Future<void> _loadSuggestions() async {
    final query = widget.controller.text;
    final suggestionsAsync = ref.read(locationSuggestionsProvider(query));
    
    suggestionsAsync.when(
      data: (suggestions) {
        setState(() {
          _suggestions = suggestions;
          _showSuggestions = suggestions.isNotEmpty;
        });
        
        if (_showSuggestions) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: context.size?.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, context.size?.height ?? 0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      widget.controller.text = suggestion;
                      _removeOverlay();
                      _focusNode.unfocus();
                      if (widget.onChanged != null) {
                        widget.onChanged!(suggestion);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: const Icon(Icons.location_on),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    _removeOverlay();
                  },
                )
              : null,
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}
