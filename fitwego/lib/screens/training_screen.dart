import 'package:flutter/material.dart';
import 'package:fitwego/models/training_model.dart';
import 'package:fitwego/theme/app_theme.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final _myCommunityTrainers = TrainingDemoData.myCommunityTrainers;
  final _exploreTrainers = TrainingDemoData.exploreTrainers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderAndSearch(),
            _buildToggleBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTrainerList(_myCommunityTrainers),
                  _buildTrainerList(_exploreTrainers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Trainers',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: AppTheme.textGrey),
                hintText: 'Search by name, gym, specialty...',
                hintStyle: const TextStyle(color: AppTheme.textGrey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: AppTheme.primaryBlue),
                  onPressed: _showFilterSheet,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filters', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Reset', style: TextStyle(color: AppTheme.textGrey)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Experience Level', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['Any', '1-3 Years', '3-5 Years', '5+ Years'].map((e) {
                  final isSelected = e == 'Any';
                  return ChoiceChip(
                    label: Text(e, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textGrey, fontSize: 12)),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryBlue,
                    backgroundColor: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    showCheckmark: false,
                    onSelected: (val) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Specialty', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', 'Strength', 'Yoga', 'HIIT', 'Pilates', 'Diet & Nutrition', 'Rehab'].map((e) {
                  final isSelected = e == 'All';
                  return ChoiceChip(
                    label: Text(e, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textGrey, fontSize: 12)),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryBlue,
                    backgroundColor: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    showCheckmark: false,
                    onSelected: (val) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filters applied!')));
                  },
                  child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.textGrey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'FitWeGo+'),
            Tab(text: 'Explore'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerList(List<DiscoveryTrainer> trainers) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        return _buildTrainerCard(trainers[index]);
      },
    );
  }

  Widget _buildTrainerCard(DiscoveryTrainer trainer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrainerProfileScreen(trainer: trainer)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'profile-${trainer.id}',
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(trainer.imageUrl),
                    backgroundColor: AppTheme.bgColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              trainer.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (trainer.isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, color: Color(0xFFFFD700), size: 12),
                                  SizedBox(width: 4),
                                  Text('FitWeGo', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trainer.specialty,
                        style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.textGrey, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              trainer.gymName,
                              style: const TextStyle(color: AppTheme.textGrey, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '"${trainer.tagline}"',
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem('${trainer.experienceYears} yrs', 'Experience'),
                Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
                _statItem('${trainer.rating} ⭐', '${trainer.reviewsCount} Reviews'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TrainerProfileScreen(trainer: trainer)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryBlue.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Profile', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (trainer.isPremium) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connecting with ${trainer.name}...')));
                      } else {
                        _showSubscribeDialog(trainer);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: trainer.isPremium ? AppTheme.primaryBlue : Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(trainer.isPremium ? Icons.chat_bubble_rounded : Icons.lock_outline, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(trainer.isPremium ? 'Message' : 'Connect', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10)),
      ],
    );
  }

  void _showSubscribeDialog(DiscoveryTrainer trainer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Unlock Premium Access 💎', style: TextStyle(color: Colors.white)),
        content: Text(
          'Subscribe to FitWeGo Premium to message ${trainer.name} and get personalized workout & diet plans.',
          style: const TextStyle(color: AppTheme.textGrey, height: 1.5, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later', style: TextStyle(color: AppTheme.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Redirecting to subscription...')));
            },
            child: const Text('Subscribe Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trainer Profile Screen
// ─────────────────────────────────────────────────────────────────────────────

class TrainerProfileScreen extends StatelessWidget {
  final DiscoveryTrainer trainer;

  const TrainerProfileScreen({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.cardColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'profile-${trainer.id}',
                    child: Image.network(trainer.imageUrl, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppTheme.bgColor.withOpacity(0.9), AppTheme.bgColor],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (trainer.isPremium)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
                            ),
                            child: const Text('FitWeGo Premium Trainer', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        Text(
                          trainer.name,
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainer.specialty,
                          style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickStats(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('About Me', Icons.person_outline),
                  const SizedBox(height: 12),
                  Text(
                    '"${trainer.tagline}"',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dedicated to helping clients achieve their fitness goals through scientifically proven methods and sustainable lifestyle changes.',
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Services Offered', Icons.fitness_center),
                  const SizedBox(height: 12),
                  _buildChips(trainer.servicesOffered, AppTheme.primaryBlue),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Certifications', Icons.workspace_premium),
                  const SizedBox(height: 12),
                  _buildListItems(trainer.certifications),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Portfolio & Achievements', Icons.emoji_events),
                  const SizedBox(height: 12),
                  _buildListItems(trainer.achievements),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Programs Created', Icons.menu_book),
                  const SizedBox(height: 12),
                  _buildPrograms(trainer.programsCreated),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: trainer.isPremium ? AppTheme.primaryBlue : Colors.white10,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  trainer.isPremium ? 'Message Trainer' : 'Subscribe to Connect',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _statBox('${trainer.experienceYears}', 'Years Exp')),
        const SizedBox(width: 12),
        Expanded(child: _statBox('${trainer.rating} ⭐', '${trainer.reviewsCount} Revs')),
        const SizedBox(width: 12),
        Expanded(child: _statBox('100+', 'Clients')),
      ],
    );
  }

  Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildChips(List<String> items, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(item, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }

  Widget _buildListItems(List<String> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 16),
              const SizedBox(width: 12),
              Expanded(child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 13))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrograms(List<String> items) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_circle_fill, color: AppTheme.primaryBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          ),
        );
      }).toList(),
    );
  }
}
