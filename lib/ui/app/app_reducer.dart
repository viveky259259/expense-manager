import 'package:expense_manager/data/models/app_state.dart';
import 'package:expense_manager/ui/addEntry/addEntry_reducer.dart';
import 'package:expense_manager/ui/dashboard/dashboard_reducer.dart';
import 'package:expense_manager/ui/home/home_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      homeState: homeReducer(state.homeState, action),
      addEntryState: addEntryReducer(state.addEntryState, action),
      dashboardState: dashboardReducer(state.dashboardState, action));
}
