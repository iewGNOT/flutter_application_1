import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_error_state.dart';
import 'app_loading_state.dart';

typedef AppAsyncDataBuilder<T> = Widget Function(BuildContext context, T data);
typedef AppAsyncErrorBuilder =
    Widget Function(BuildContext context, Object error);

final class AppAsyncValueView<T> extends StatelessWidget {
  const AppAsyncValueView({
    super.key,
    required this.value,
    required this.fallbackErrorMessage,
    required this.builder,
    this.onRetry,
    this.loadingBuilder,
    this.errorBuilder,
    this.loadingMessage,
  });

  final AsyncValue<T> value;
  final String fallbackErrorMessage;
  final AppAsyncDataBuilder<T> builder;
  final FutureOr<void> Function()? onRetry;
  final WidgetBuilder? loadingBuilder;
  final AppAsyncErrorBuilder? errorBuilder;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () =>
          loadingBuilder?.call(context) ??
          AppLoadingState(message: loadingMessage),
      error: (error, _) =>
          errorBuilder?.call(context, error) ??
          AppErrorState.fromError(
            error: error,
            fallbackMessage: fallbackErrorMessage,
            onRetry: onRetry == null
                ? null
                : () {
                    onRetry!.call();
                  },
          ),
      data: (data) => builder(context, data),
    );
  }
}
