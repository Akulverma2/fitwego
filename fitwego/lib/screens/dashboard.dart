import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/mobile_scanner.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Map<String, List<String>> meals = {
    "Breakfast": [],
    "Lunch": [],
    "Snacks": [],
    "Dinner": [],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  Widget animated(double delay, Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final value =
            Curves.easeOut.transform((_controller.value - delay).clamp(0, 1));
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  Widget card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => const QuickAddSheet(),
          );
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              animated(
                0.0,
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              animated(
                0.1,
                card(
                  Column(
                    children: [
                      const Text(
                        "Calories",
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 20),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 0.7),
                        duration: const Duration(milliseconds: 1200),
                        builder: (context, value, _) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 10,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "840",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Remaining",
                                    style: TextStyle(color: Colors.white54),
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _Stat("2160", "Base"),
                          _Stat("1320", "Food"),
                          _Stat("0", "Exercise"),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              animated(
                0.2,
                Row(
                  children: [
                    Expanded(
                      child: _activityCard(
                        "Steps",
                        Icons.directions_walk,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _activityCard(
                        "Workout",
                        Icons.fitness_center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              animated(
                0.3,
                card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weight Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                            bottom: 20,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration:
                                const Duration(milliseconds: 1400),
                            builder: (context, value, _) {
                              return CustomPaint(
                                painter: _UpgradedGraphPainter(value),
                                size: Size.infinite,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              animated(
                0.4,
                Column(
                  children: [
                    _mealCard("Breakfast"),
                    const SizedBox(height: 12),
                    _mealCard("Lunch"),
                    const SizedBox(height: 12),
                    _mealCard("Snacks"),
                    const SizedBox(height: 12),
                    _mealCard("Dinner"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              animated(
                0.5,
                _diaryHistoryCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealCard(String title) {
    final items = meals[title]!;

    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () => _addFoodDialog(title),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const Text(
              "No items added yet",
              style: TextStyle(color: Colors.white38),
            )
          else
            Column(
              children: items.map((food) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Text("• ",
                          style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Text(
                          food,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            )
        ],
      ),
    );
  }

  void _addFoodDialog(String mealType) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text(
            "Add to $mealType",
            
          ),
          content: TextField(
        
            controller: controller,
            
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    meals[mealType]!.add(controller.text);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }

  Widget _diaryHistoryCard() {
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Diary History",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _diaryItem("Apr 18", "1850 cal"),
          _diaryItem("Apr 19", "2110 cal"),
          _diaryItem("Apr 20", "1320 cal"),
        ],
      ),
    );
  }

  Widget _diaryItem(String date, String calories) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              calories,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityCard(String title, IconData icon) {
    return card(
      Column(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 28),
          const SizedBox(height: 10),
          const Text(
            "0",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class QuickAddSheet extends StatelessWidget {
  const QuickAddSheet({super.key});

  Widget addBox(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.3,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(onTap:(){Navigator.pop(context);Navigator.push(context,MaterialPageRoute(builder:(_)=>const LogFoodPage()));},child:addBox(Icons.search, "Log Food", Colors.blue)),
              GestureDetector(
  onTap: () async {
    Navigator.pop(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BarcodeScannerPage(),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${result['name']} - ${result['calories']}"),
        ),
      );
    }
  },
  child: addBox(Icons.qr_code_scanner, "Barcode Scan", Colors.red),
),
              addBox(Icons.mic, "Voice Log", Colors.purple),
              addBox(Icons.camera_alt, "Meal Scan", Colors.teal),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.water_drop, color: Colors.lightBlue),
                  title: Text("Water", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.monitor_weight, color: Colors.green),
                  title: Text("Weight", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.local_fire_department,
                      color: Colors.orange),
                  title: Text("Exercise",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogFoodPage extends StatefulWidget {
 const LogFoodPage({super.key});
 @override
 State<LogFoodPage> createState() => _LogFoodPageState();
}

class _LogFoodPageState extends State<LogFoodPage> {
 final TextEditingController search = TextEditingController();
 final List<Map<String,String>> foods = [
  {'name':'White rice, cooked','cal':'121 cal, 1.0 cup'},
  {'name':'Banana','cal':'105 cal, 1 medium'},
  {'name':'Chicken Breast','cal':'165 cal, 100g'},
 ];

 @override
 Widget build(BuildContext context){
  return Scaffold(
   backgroundColor: AppTheme.bgColor,
   appBar: AppBar(
    backgroundColor: AppTheme.bgColor,
    elevation: 0,
    leading: IconButton(
     icon: const Icon(Icons.arrow_back,color: Colors.white),
     onPressed: ()=>Navigator.pop(context),
    ),
    title: const Text('Select a Meal',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
    centerTitle: true,
   ),
   body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Container(
       padding: const EdgeInsets.symmetric(horizontal:16),
       decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryBlue),
        borderRadius: BorderRadius.circular(28),
       ),
       child: TextField(
        controller: search,
        decoration: const InputDecoration(
         icon: Icon(Icons.search,color: Colors.white54),
         hintText: 'Search for a food',
         hintStyle: TextStyle(color: Colors.white54),
         border: InputBorder.none,
        ),
       ),
      ),
      const SizedBox(height:18),
      const Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
        Text('All',style:TextStyle(color:AppTheme.primaryBlue,fontWeight:FontWeight.bold)),
        Text('My Meals',style:TextStyle(color:Colors.white54)),
        Text('My Recipes',style:TextStyle(color:Colors.white54)),
        Text('My Foods',style:TextStyle(color:Colors.white54)),
       ],
      ),
      const SizedBox(height:18),
      Row(
       children:[
        Expanded(child:_foodAction(Icons.mic,'Voice Log')),
        const SizedBox(width:12),
        Expanded(
  child: GestureDetector(
    onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BarcodeScannerPage(),
        ),
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${result['name']} - ${result['calories']}",
            ),
          ),
        );
      }
    },
    child: _foodAction(Icons.qr_code_scanner, 'Scan a Barcode'),
  ),
),
       ],
      ),
      const SizedBox(height:28),
      const Text('Suggestions',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
      const SizedBox(height:16),
      Expanded(
       child: ListView.builder(
        itemCount: foods.length,
        itemBuilder:(context,i){
         final item=foods[i];
         return Container(
          margin: const EdgeInsets.only(bottom:14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
           color: AppTheme.cardColor,
           borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:[
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children:[
              Text(item['name']!,style: const TextStyle(color: Colors.white)),
              Text(item['cal']!,style: const TextStyle(color:Colors.white54)),
             ],
            ),
            IconButton(
             icon: const Icon(Icons.add,color:AppTheme.primaryBlue),
             onPressed:(){Navigator.pop(context);},
            ),
           ],
          ),
         );
        },
       ),
      ),
     ],
    ),
   ),
  );
 }

 Widget _foodAction(IconData icon,String title){
  return Container(
   padding: const EdgeInsets.all(22),
   decoration: BoxDecoration(
    color: AppTheme.cardColor,
    borderRadius: BorderRadius.circular(14),
   ),
   child: Column(
    children:[
     Icon(icon,color:AppTheme.primaryBlue,size:34),
     const SizedBox(height:10),
     Text(title,style: const TextStyle(color: Colors.white)),
    ],
   ),
  );
 }
}

class _UpgradedGraphPainter extends CustomPainter {
  final double progress;
  _UpgradedGraphPainter(this.progress);

  final List<double> data = [65, 68, 66, 69, 68, 71];

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal == 0) ? 1 : (maxVal - minVal);

    double dx(int i) => (i / (data.length - 1)) * size.width;
    double dy(double v) =>
        size.height - ((v - minVal) / range) * size.height;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = dx(i) * progress;
      final y = dy(data[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = dx(i - 1) * progress;
        final prevY = dy(data[i - 1]);

        path.cubicTo(
          (prevX + x) / 2,
          prevY,
          (prevX + x) / 2,
          y,
          x,
          y,
        );
      }
    }

    final paint = Paint()
      ..color = AppTheme.primaryBlue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}
