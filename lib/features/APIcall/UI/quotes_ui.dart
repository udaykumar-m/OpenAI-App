import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/custom_tooltip.dart';
import '../bloc/quotes_bloc.dart';

class Quotes extends StatelessWidget {
  const Quotes({super.key, this.onNewQuote});

  final void Function(String)? onNewQuote;

  @override
  Widget build(BuildContext context) {
    return QuotesBody(onNewQuote: onNewQuote);
  }
}

class QuotesBody extends StatefulWidget {
  const QuotesBody({
    super.key,
    this.onNewQuote,
  });

  final void Function(String)? onNewQuote;

  @override
  State<QuotesBody> createState() => _QuotesBodyState();
}

class _QuotesBodyState extends State<QuotesBody> {
  var copyText = '';

  @override
  void initState() {
    context.read<QuotesBloc>().add(GetQuotesInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: 'The Quote is copied!',
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: copyText));
      },
      child: Card(
        shadowColor: Colors.black87,
        child: BlocBuilder<QuotesBloc, QuotesState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case QuotesLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case QuotesSuccessfullState:
                final responseState = state as QuotesSuccessfullState;
                copyText = utf8.decode(
                    (responseState.quotes.choices?[0].message?.content)
                        .toString()
                        .runes
                        .toList());
                widget.onNewQuote?.call(copyText);
                return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(copyText),
                    ],
                  ),
                );
              case QuotesErrorState:
                return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
