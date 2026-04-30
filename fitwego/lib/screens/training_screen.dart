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
  final _trainer = TrainingDemoData.trainer;
  final _todaySessions = TrainingDemoData.todaySessions;
  final _progress = TrainingDemoData.progress;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAppBar()),
          SliverToBoxAdapter(child: _buildTrainerCard()),
          SliverToBoxAdapter(child: _buildTodayPlan()),
          SliverToBoxAdapter(child: _buildProgramsSection()),
          SliverToBoxAdapter(child: _buildProgressSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          children: [
            const Text(
              'My Trainer Hub',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No new notifications')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(_trainer.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _trainer.name,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '⭐ ${_trainer.badge}',
                              style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _trainer.gymName,
                        style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _trainerStat('${_trainer.experienceYears}+ Yrs', 'Experience'),
                _trainerStat('${_trainer.rating} ⭐', 'Rating'),
                _trainerStat(_trainer.specialty.split(' ').first, 'Specialty'),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _showMessageDialog();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Message Trainer', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trainerStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildTodayPlan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Plan 🔥",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_todaySessions.where((s) => s.status == SessionStatus.completed).length}/${_todaySessions.length} done',
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._todaySessions.map((s) => _buildSessionCard(s)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(TodaySession session) {
    Color statusColor;
    IconData statusIcon;

    switch (session.status) {
      case SessionStatus.completed:
        statusColor = const Color(0xFF00E676);
        statusIcon = Icons.check_circle_rounded;
        break;
      case SessionStatus.inProgress:
        statusColor = Colors.orange;
        statusIcon = Icons.play_circle_fill_rounded;
        break;
      case SessionStatus.notStarted:
        statusColor = AppTheme.primaryBlue;
        statusIcon = Icons.play_circle_outline_rounded;
        break;
    }

    final isCompleted = session.status == SessionStatus.completed;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCompleted ? 'Already completed!' : 'Starting ${session.title}...'),
            backgroundColor: statusColor,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? AppTheme.cardColor.withOpacity(0.5) : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: session.status == SessionStatus.inProgress ? Colors.orange.withOpacity(0.3) : Colors.white.withOpacity(0.05),
            width: session.status == SessionStatus.inProgress ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(session.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: TextStyle(
                      color: isCompleted ? AppTheme.textGrey : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: isCompleted ? AppTheme.textGrey.withOpacity(0.5) : AppTheme.textGrey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${session.time} · ${session.duration}',
                        style: TextStyle(color: isCompleted ? AppTheme.textGrey.withOpacity(0.5) : AppTheme.textGrey, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          session.type,
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(statusIcon, color: statusColor, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Programs',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textGrey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: '🏋️ Workouts'),
                Tab(text: '🧘 Yoga'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: _tabController,
            builder: (context, _) {
              final programs = _tabController.index == 0 ? TrainingDemoData.workoutPrograms : TrainingDemoData.yogaPrograms;
              return Column(
                children: programs.map((p) => _buildProgramCard(p)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(AssignedProgram program) {
    final color = program.category == ProgramCategory.workout ? AppTheme.primaryBlue : const Color(0xFF7C4DFF);
    return GestureDetector(
      onTap: () => _showProgramDetail(program),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    program.category == ProgramCategory.workout ? Icons.fitness_center : Icons.self_improvement,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(program.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${program.duration} · ${program.sessionsPerWeek}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    program.difficultyLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${program.completedSessions} / ${program.totalSessions} sessions', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                Text('${(program.progressRatio * 100).toInt()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: program.progressRatio,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProgramDetail(AssignedProgram program) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
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
              Text(program.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${program.duration} · ${program.sessionsPerWeek} · ${program.difficultyLabel}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 14)),
              const SizedBox(height: 24),
              const Text('Exercises', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: program.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = program.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('${index + 1}', style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exercise.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(exercise.detail, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Progress',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _progressStatCard(TrainingDemoData.progressStats[0].emoji, '${_progress.currentStreak}', TrainingDemoData.progressStats[0].label, TrainingDemoData.progressStats[0].color)),
              const SizedBox(width: 12),
              Expanded(child: _progressStatCard(TrainingDemoData.progressStats[1].emoji, '${_progress.totalCompleted}', TrainingDemoData.progressStats[1].label, TrainingDemoData.progressStats[1].color)),
              const SizedBox(width: 12),
              Expanded(child: _progressStatCard(TrainingDemoData.progressStats[2].emoji, '${_progress.weeklyDone}/${_progress.weeklyGoal}', TrainingDemoData.progressStats[2].label, TrainingDemoData.progressStats[2].color)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _interactionButton(
                  icon: TrainingDemoData.interactionButtons[0].icon,
                  label: TrainingDemoData.interactionButtons[0].label,
                  color: TrainingDemoData.interactionButtons[0].color,
                  onTap: _showMessageDialog,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _interactionButton(
                  icon: TrainingDemoData.interactionButtons[1].icon,
                  label: TrainingDemoData.interactionButtons[1].label,
                  color: TrainingDemoData.interactionButtons[1].color,
                  onTap: _showFeedbackDialog,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressStatCard(String emoji, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _interactionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Message ${_trainer.name}', style: const TextStyle(color: Colors.white)),
        content: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: AppTheme.textGrey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.textGrey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryBlue)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent!')));
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    int selectedStars = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Give Feedback', style: TextStyle(color: Colors.white)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStars = index + 1;
                    });
                  },
                  child: Icon(
                    index < selectedStars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: AppTheme.textGrey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                onPressed: selectedStars > 0 ? () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted!')));
                } : null,
                child: const Text('Submit'),
              ),
            ],
          );
        }
      ),
    );
  }
}
