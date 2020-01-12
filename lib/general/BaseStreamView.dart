import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Widget WidgetFunction<T>(BuildContext context, T data);

class StreamBuilderWithLoader<T> extends StatelessWidget {
  final Stream<T> stream;
  final WidgetFunction<T> builder;

  StreamBuilderWithLoader({@required this.stream, @required this.builder});

  @override
  Widget build(BuildContext context) => Container(
      child: StreamBuilder(
          stream: stream,
          builder: (BuildContext content, AsyncSnapshot<T> asyncSnapshot) =>
              (asyncSnapshot.hasData)
                  ? builder(context, asyncSnapshot.data)
                  : Center(child: CircularProgressIndicator())));
}
