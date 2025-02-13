import 'package:flutter/material.dart';
import 'package:fund_manager/utils/common.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tab_viewmodel.dart';
import 'package:fund_manager/views/dashboard.dart';
import 'package:fund_manager/views/history_view.dart';
import 'package:fund_manager/views/savings_entry_view.dart';
import 'package:fund_manager/views/withdrawal_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabViewModel = Provider.of<TabViewModel>(context);

    return Scaffold(
      body: IndexedStack(
        index: tabViewModel.selectedTab,
        children: [
          MainScreen(),
          SavingsEntryScreen(),
          WithdrawalScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: tabViewModel.selectedTab,
          onTap: (index) {
            tabViewModel.changeTab(index);
          },
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14.0,
          unselectedFontSize: 13.0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          items: [
            buildAnimatedTabItem(
              label: "Home",
              activeIcon: "assets/icons/home.png",
              inactiveIcon: "assets/icons/home_disable.png",
              index: 0,
              selectedIndex: tabViewModel.selectedTab,
            ),
            buildAnimatedTabItem(
              label: "Saving Entry",
              activeIcon: "assets/icons/rupee.png",
              inactiveIcon: "assets/icons/rupee_disable.png",
              index: 1,
              selectedIndex: tabViewModel.selectedTab,
            ),
            buildAnimatedTabItem(
              label: "Withdraw",
              activeIcon: "assets/icons/money.png",
              inactiveIcon: "assets/icons/money_disable.png",
              index: 2,
              selectedIndex: tabViewModel.selectedTab,
            ),
            buildAnimatedTabItem(
              label: "History",
              activeIcon: "assets/icons/history.png",
              inactiveIcon: "assets/icons/history_disable.png",
              index: 3,
              selectedIndex: tabViewModel.selectedTab,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem buildAnimatedTabItem({
    required String label,
    required String activeIcon,
    required String inactiveIcon,
    required int index,
    required int selectedIndex,
  }) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.25 : 1.0, // Zoom in when selected
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutBack, // Adds a slight bounce effect
        child: Image.asset(
          isSelected ? activeIcon : inactiveIcon,
          width: 22,
          height: 22,
        ),
      ),
      label: label,
    );
  }
}
