class Responsive {
  static bool isDesktop(double width) => width > 1024;
  static bool isTablet(double width) => width > 600 && width <= 1024;
  static bool isMobile(double width) => width <= 600;
}



// LayoutBuilder(
//   builder: (context, constraints) {
//     if (Responsive.isDesktop(constraints.maxWidth)) {
//       return const MainLayout();
//     } else {
//       return const Center(child: Text("Mobile Layout"));
//     }
//   },
// )