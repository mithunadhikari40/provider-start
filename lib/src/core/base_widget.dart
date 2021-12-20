import 'package:flutter/material.dart';
import 'package:places/src/viewmodels/base_view_model.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends BaseViewModel> extends StatefulWidget {
  final T model;
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Widget? child;

  final void Function(T model)? onModelReady;

  const BaseWidget(
      {Key? key,
      required this.model,
      required this.builder,
      this.child,
      this.onModelReady})
      : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseViewModel> extends State<BaseWidget<T>> {
  late T _model;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady!(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
