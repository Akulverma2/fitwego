import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitwego/models/training_model.dart';
import 'package:fitwego/theme/app_theme.dart';

// ── Constants & Helpers ──────────────────────────────────────────────────────

const kMapBg = Color(0xFF0F0F1E);
const kPartnerBlue = AppTheme.primaryBlue;
const kFeaturedGold = AppTheme.featuredGold;

// ── Training Screen ──────────────────────────────────────────────────────────

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _sheetController = DraggableScrollableController();
  bool _isMapMode = false; 
  GymCentre? _selectedGym;
  String _activeFilter = 'All';
  
  final List<String> _filters = ['All', 'Premium', 'Budget', 'Strength', 'Yoga', 'HIIT', 'Pilates', 'Pool', 'Spa'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  List<DiscoveryTrainer> get _filteredTrainers => TrainingDemoData.trainers;
  
  List<GymCentre> get _filteredGyms {
    if (_activeFilter == 'All') return TrainingDemoData.partnerGyms;
    if (_activeFilter == 'Premium') return TrainingDemoData.partnerGyms.where((g) => g.type == 'Premium').toList();
    if (_activeFilter == 'Budget') return TrainingDemoData.partnerGyms.where((g) => g.type == 'Budget').toList();
    return TrainingDemoData.partnerGyms.where((g) => g.services.contains(_activeFilter)).toList();
  }

  void _onTapGymMarker(GymCentre gym) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedGym = gym);
    _sheetController.animateTo(0.4, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _isMapMode ? _buildMapView() : _buildListView(),
    );
  }

  // ── List View (Discover Trainers) ──────────────────────────────────────────

  Widget _buildListView() {
    final query = _searchController.text.toLowerCase();
    
    List<DiscoveryTrainer> filterTrainers(List<DiscoveryTrainer> list) {
      if (query.isEmpty) return list;
      return list.where((t) => 
        t.name.toLowerCase().contains(query) || 
        t.specialty.toLowerCase().contains(query) ||
        t.gymName.toLowerCase().contains(query)
      ).toList();
    }

    final myCommunityTrainers = filterTrainers(TrainingDemoData.myCommunityTrainers);
    final exploreTrainers = filterTrainers(TrainingDemoData.exploreTrainers);

    return Scaffold(
      key: const ValueKey('list'),
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isMap: false),
            _buildToggleBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTrainerList(myCommunityTrainers),
                  _buildTrainerList(exploreTrainers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerList(List<DiscoveryTrainer> trainers) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: trainers.length,
      itemBuilder: (context, index) => _buildTrainerCard(trainers[index]),
    );
  }

  Widget _buildHeader({required bool isMap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_mma, color: AppTheme.primaryBlue, size: 26),
                  const SizedBox(width: 10),
                  const Text(
                    'Training', 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _isMapMode = !isMap),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(isMap ? Icons.format_list_bulleted : Icons.map_outlined, color: AppTheme.primaryBlue, size: 14),
                      const SizedBox(width: 4),
                      Text(isMap ? 'List' : 'Centres', style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isMap) ...[
            const SizedBox(height: 16),
            _buildSearchBar(),
          ]
        ],
      ),
    );
  }

  Widget _buildSearchBar({bool floating = false}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: floating ? Colors.black.withOpacity(0.8) : AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: AppTheme.textGrey),
          hintText: 'Search trainers, gyms, specialties...',
          hintStyle: const TextStyle(color: AppTheme.textGrey),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.primaryBlue, size: 18),
            onPressed: () => _showFilterSheet(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Trainers', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Strength', 'Yoga', 'HIIT', 'Pilates', 'Cardio', 'Powerlifting', 'Bodybuilding', 'Dance'].map((spec) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = spec;
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(spec, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(20)),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(20)),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.textGrey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          dividerColor: Colors.transparent,
          tabs: const [Tab(text: 'FitWeGo+'), Tab(text: 'Explore')],
        ),
      ),
    );
  }

  Widget _buildTrainerCard(DiscoveryTrainer t) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrainerProfileScreen(trainer: t)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'profile-${t.id}',
                  child: Stack(
                    children: [
                      CircleAvatar(radius: 35, backgroundImage: NetworkImage(t.imageUrl)),
                      if (t.isPremium)
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle),
                            child: const Icon(Icons.star, color: Colors.white, size: 12),
                          ),
                        ),
                    ],
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
                            child: Text(t.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          ),
                          if (t.isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFD700).withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5))),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, color: Color(0xFFFFD700), size: 12),
                                  SizedBox(width: 4),
                                  Text('FitWeGo', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${t.specialty} • ${t.gymName}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(t.tagline, style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TrainerProfileScreen(trainer: t)));
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
                      if (t.isPremium) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening chat with ${t.name}...')));
                      } else {
                        // Demo action for Explore trainers
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connect request sent to ${t.name}')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.isPremium ? AppTheme.primaryBlue : Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t.isPremium ? Icons.chat_bubble_rounded : Icons.person_add_alt_1, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(t.isPremium ? 'Message' : 'Connect', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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

  // ── Map View (Customized for Gym Centres) ──────────────────────────────────

  Widget _buildMapView() {
    return Scaffold(
      key: const ValueKey('map'),
      backgroundColor: kMapBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: _filteredGyms.map((g) => _buildGymMarker(g, constraints)).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _isMapMode = false),
                          child: _floatingButton(Icons.format_list_bulleted),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSearchBar(floating: true)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMapFilters(),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.12, 0.4, 0.9],
            builder: (context, scrollController) {
              return _buildBottomSheet(scrollController);
            },
          ),
        ],
      ),
    );
  }

  Widget _floatingButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildMapFilters() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final active = _activeFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppTheme.primaryBlue : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: active ? AppTheme.primaryBlue : Colors.white.withOpacity(0.1)),
              ),
              child: Text(filter, style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGymMarker(GymCentre g, BoxConstraints constraints) {
    final x = constraints.maxWidth * g.mapX;
    final y = constraints.maxHeight * g.mapY;
    final selected = _selectedGym?.id == g.id;

    return Positioned(
      left: x - 20,
      top: y - 20,
      child: GestureDetector(
        onTap: () => _onTapGymMarker(g),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(selected ? 4 : 2),
              decoration: BoxDecoration(
                color: g.isFeatured ? kFeaturedGold : (g.isPartner ? kPartnerBlue : Colors.white),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: g.logoUrl.isNotEmpty 
                  ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(g.logoUrl, width: 20, height: 20, fit: BoxFit.contain))
                  : Icon(
                      g.isFeatured ? Icons.star : Icons.fitness_center, 
                      color: g.isFeatured ? kFeaturedGold : (g.isPartner ? kPartnerBlue : Colors.white), 
                      size: 16
                    ),
              ),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                child: Text(g.name.split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(ScrollController sc) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
          if (_selectedGym != null) _buildSelectedGymSummary(_selectedGym!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nearby Centres', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Text('${_filteredGyms.length} found', style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: sc,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredGyms.length,
              itemBuilder: (context, index) {
                final g = _filteredGyms[index];
                return _buildSheetGymItem(g);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedGymSummary(GymCentre g) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(g.images.first, width: 80, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(g.address, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: kFeaturedGold, size: 12),
                    const SizedBox(width: 4),
                    Text(g.rating.toString(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text(g.distance, style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showGymDetails(g),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetGymItem(GymCentre g) {
    return GestureDetector(
      onTap: () => setState(() => _selectedGym = g),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _selectedGym?.id == g.id ? AppTheme.primaryBlue.withOpacity(0.3) : Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.network(g.logoUrl, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                Text('${g.type} • ${g.distance}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 10)),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 12),
          ],
        ),
      ),
    );
  }

  void _showGymDetails(GymCentre g) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GymProfileSheet(gym: g),
    );
  }
}

// ── Gym Profile Sheet ────────────────────────────────────────────────────────

class _GymProfileSheet extends StatelessWidget {
  final GymCentre gym;
  const _GymProfileSheet({required this.gym});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: gym.images.length,
                    itemBuilder: (context, index) => Image.network(gym.images[index], fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 20, left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gym.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(gym.address, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      ],
                    ),
                    if (gym.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: kFeaturedGold.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: kFeaturedGold)),
                        child: const Text('PREMIUM', style: TextStyle(color: kFeaturedGold, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(gym.rating.toString(), 'Rating'),
                    _buildStat(gym.reviewsCount.toString(), 'Reviews'),
                    _buildStat(gym.distance, 'Away'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Available Trainers', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: gym.trainers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final t = gym.trainers[index];
                      return Column(
                        children: [
                          CircleAvatar(radius: 25, backgroundImage: NetworkImage(t.imageUrl)),
                          const SizedBox(height: 4),
                          Text(t.name.split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Membership Plans', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...gym.membershipPlans.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(p.features.join(' • '), style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(p.price, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Join Gym Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10)),
      ],
    );
  }
}

// ── Map Painter ──────────────────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    
    final roadPaint = Paint()..color = Colors.white.withOpacity(0.08)..strokeWidth = 15;
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), roadPaint);

    final parkPaint = Paint()..color = Colors.green.withOpacity(0.05);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.6, 100, 150), parkPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Trainer Profile Screen ───────────────────────────────────────────────────

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
                  
                  if (trainer.portfolioWritten.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Portfolio & Experience', Icons.article_outlined),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
                      ),
                      child: Text(
                        trainer.portfolioWritten,
                        style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.6, letterSpacing: 0.2),
                      ),
                    ),
                  ],

                  if (trainer.portfolioImages.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: trainer.portfolioImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(trainer.portfolioImages[index], width: 200, height: 140, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  if (trainer.servicesOffered.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Services Offered', Icons.fitness_center),
                    const SizedBox(height: 12),
                    _buildChips(trainer.servicesOffered, AppTheme.primaryBlue),
                  ],

                  if (trainer.certifications.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Certifications', Icons.workspace_premium),
                    const SizedBox(height: 12),
                    _buildListItems(trainer.certifications),
                  ],

                  if (trainer.achievements.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Achievements', Icons.emoji_events),
                    const SizedBox(height: 12),
                    _buildListItems(trainer.achievements),
                  ],

                  if (trainer.programsCreated.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Programs Created', Icons.menu_book),
                    const SizedBox(height: 12),
                    _buildPrograms(trainer.programsCreated),
                  ],
                  
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(trainer.isPremium ? 'Opening chat with ${trainer.name}...' : 'Connect request sent to ${trainer.name}')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: trainer.isPremium ? AppTheme.primaryBlue : AppTheme.cardColor,
                  side: trainer.isPremium ? BorderSide.none : BorderSide(color: AppTheme.primaryBlue.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  trainer.isPremium ? 'Message Trainer' : 'Connect with Trainer',
                  style: TextStyle(color: trainer.isPremium ? Colors.white : AppTheme.primaryBlue, fontSize: 15, fontWeight: FontWeight.bold),
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
