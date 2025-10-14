import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/Open_ai_model.dart';
import 'package:openai_app/features/APIcall/repo/tabs_api.dart';

part 'tabs_event.dart';
part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  TabsBloc() : super(TabsInitial()) {
    on<GetTabsAPI>(GetTabsAPIEvent);
  }

  FutureOr<void> GetTabsAPIEvent(
      GetTabsAPI event, Emitter<TabsState> emit) async {
    emit(TabsAPILoadingState());
    try {
      OpenAiRes? tabsAPI =
          await TabsAPI.GetTabsAPI(event.searchText, event.queryText);
      if (tabsAPI != null) {
        emit(TabsAPISuccessfullState(TabsAPI: tabsAPI));
      } else {
        emit(TabsAPIErrorState());
      }
    } catch (e) {
      print('Error in TabsBloc: $e');
      emit(TabsAPIErrorState());
    }
  }
}
