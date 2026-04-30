// ── Training Screen Models & Demo Data ────────────────────────────────────────

import 'package:flutter/material.dart';

enum SessionStatus { notStarted, inProgress, completed }
enum ProgramCategory { workout, yoga, diet }
enum ProgramDifficulty { beginner, intermediate, advanced }
enum UserGoal { fatLoss, muscleGain, flexibility }
enum WellnessType { breathing, meditation, recovery }

// ── Models ────────────────────────────────────────────────────────────────────

class TrainingTrainer {
  final String name;
  final String imageUrl;
  final String gymName;
  final String specialty;
  final int experienceYears;
  final double rating;
  final String badge;

  const TrainingTrainer({
    required this.name,
    required this.imageUrl,
    required this.gymName,
    required this.specialty,
    required this.experienceYears,
    required this.rating,
    required this.badge,
  });
}

class TodaySession {
  final String title;
  final String type;
  final String duration;
  final String time;
  final SessionStatus status;
  final String emoji;

  const TodaySession({
    required this.title,
    required this.type,
    required this.duration,
    required this.time,
    required this.status,
    required this.emoji,
  });
}

class ProgramExercise {
  final String name;
  final String detail;
  const ProgramExercise({required this.name, required this.detail});
}

class AssignedProgram {
  final String id;
  final String name;
  final ProgramCategory category;
  final ProgramDifficulty difficulty;
  final String duration;
  final String sessionsPerWeek;
  final List<ProgramExercise> exercises;
  final int completedSessions;
  final int totalSessions;

  const AssignedProgram({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.sessionsPerWeek,
    required this.exercises,
    required this.completedSessions,
    required this.totalSessions,
  });

  double get progressRatio =>
      totalSessions == 0 ? 0 : completedSessions / totalSessions;

  String get difficultyLabel {
    switch (difficulty) {
      case ProgramDifficulty.beginner: return 'Beginner';
      case ProgramDifficulty.intermediate: return 'Intermediate';
      case ProgramDifficulty.advanced: return 'Advanced';
    }
  }

  String get categoryLabel {
    switch (category) {
      case ProgramCategory.workout: return 'Workout';
      case ProgramCategory.yoga: return 'Yoga';
      case ProgramCategory.diet: return 'Diet';
    }
  }
}

class WeekDay {
  final String day;
  final int workoutsCompleted;
  final bool isToday;
  const WeekDay({required this.day, required this.workoutsCompleted, required this.isToday});
}

class TrainingProgress {
  final int currentStreak;
  final int totalCompleted;
  final int weeklyGoal;
  final int weeklyDone;
  final List<WeekDay> weekDays;
  final double weightChange;
  final String strengthGain;
  final List<double> weeklyConsistency; // last 4 weeks as percentages (0-1)

  const TrainingProgress({
    required this.currentStreak,
    required this.totalCompleted,
    required this.weeklyGoal,
    required this.weeklyDone,
    required this.weekDays,
    this.weightChange = -2.0,
    this.strengthGain = '+2kg Bench Press',
    this.weeklyConsistency = const [0.8, 0.6, 0.9, 0.6],
  });
}

class SmartSuggestion {
  final String text;
  final IconData icon;
  final Color color;
  const SmartSuggestion({required this.text, required this.icon, required this.color});
}

class Badge {
  final String name;
  final String emoji;
  final String earnedDate;
  final bool isNew;
  const Badge({required this.name, required this.emoji, required this.earnedDate, this.isNew = false});
}

class LeaderboardEntry {
  final String name;
  final String imageUrl;
  final int points;
  final int rank;
  final bool isCurrentUser;
  const LeaderboardEntry({required this.name, required this.imageUrl, required this.points, required this.rank, this.isCurrentUser = false});
}

class UpcomingSession {
  final String date;
  final String time;
  final String trainerName;
  final String type;
  final bool isBookable;
  const UpcomingSession({required this.date, required this.time, required this.trainerName, required this.type, this.isBookable = false});
}

class WellnessItem {
  final String title;
  final String emoji;
  final String duration;
  final WellnessType type;
  final String description;
  const WellnessItem({required this.title, required this.emoji, required this.duration, required this.type, required this.description});
}

class GoalConfig {
  final String label;
  final String emoji;
  final Color accentColor;
  final String subtitle;
  const GoalConfig({required this.label, required this.emoji, required this.accentColor, required this.subtitle});
}

class ProgressStatConfig {
  final String emoji;
  final String label;
  final Color color;
  const ProgressStatConfig({required this.emoji, required this.label, required this.color});
}

class InteractionButtonConfig {
  final IconData icon;
  final String label;
  final Color color;
  const InteractionButtonConfig({required this.icon, required this.label, required this.color});
}

class DiscoveryTrainer {
  final String id;
  final String name;
  final String imageUrl;
  final String gymName;
  final String specialty;
  final int experienceYears;
  final double rating;
  final String tagline;
  final bool isPremium;
  final List<String> certifications;
  final List<String> achievements;
  final List<String> programsCreated;
  final List<String> servicesOffered;
  final int reviewsCount;

  const DiscoveryTrainer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.gymName,
    required this.specialty,
    required this.experienceYears,
    required this.rating,
    required this.tagline,
    this.isPremium = false,
    this.certifications = const [],
    this.achievements = const [],
    this.programsCreated = const [],
    this.servicesOffered = const [],
    this.reviewsCount = 0,
  });
}

// ── Demo Data ─────────────────────────────────────────────────────────────────

class TrainingDemoData {
  static const List<ProgressStatConfig> progressStats = [
    ProgressStatConfig(emoji: '🔥', label: 'Day Streak', color: Colors.orange),
    ProgressStatConfig(emoji: '✅', label: 'Completed', color: Color(0xFF00E676)),
    ProgressStatConfig(emoji: '🎯', label: 'This Week', color: Color(0xFF00B8FF)),
  ];

  static const List<InteractionButtonConfig> interactionButtons = [
    InteractionButtonConfig(icon: Icons.chat_bubble_outline, label: 'Ask Doubts', color: Color(0xFF00B8FF)),
    InteractionButtonConfig(icon: Icons.star_border, label: 'Feedback', color: Colors.amber),
  ];

  static const Map<UserGoal, GoalConfig> goalConfigs = {
    UserGoal.fatLoss: GoalConfig(label: 'Fat Loss', emoji: '🔥', accentColor: Color(0xFFFF6B35), subtitle: 'Burn & shred mode'),
    UserGoal.muscleGain: GoalConfig(label: 'Muscle Gain', emoji: '💪', accentColor: Color(0xFF00B8FF), subtitle: 'Build & grow mode'),
    UserGoal.flexibility: GoalConfig(label: 'Flexibility', emoji: '🧘', accentColor: Color(0xFF7C4DFF), subtitle: 'Stretch & flow mode'),
  };

  static const TrainingTrainer trainer = TrainingTrainer(
    name: 'Aryan Kapoor',
    imageUrl: 'https://i.pravatar.cc/150?img=12',
    gymName: 'FitWeGo Premier Gym',
    specialty: 'Strength & Conditioning',
    experienceYears: 7,
    rating: 4.9,
    badge: 'Elite Coach',
  );

  static const List<TodaySession> todaySessions = [
    TodaySession(title: 'Chest & Triceps Day', type: 'Workout', duration: '50 min', time: '7:00 AM', status: SessionStatus.completed, emoji: '🏋️'),
    TodaySession(title: 'Morning Flow Yoga', type: 'Yoga', duration: '25 min', time: '8:00 AM', status: SessionStatus.inProgress, emoji: '🧘'),
    TodaySession(title: 'Evening Cardio Burn', type: 'Cardio', duration: '30 min', time: '6:00 PM', status: SessionStatus.notStarted, emoji: '🔥'),
  ];

  static const List<TodaySession> tomorrowSessions = [
    TodaySession(title: 'Back & Biceps Day', type: 'Workout', duration: '55 min', time: '7:00 AM', status: SessionStatus.notStarted, emoji: '🏋️'),
    TodaySession(title: 'Power Yoga', type: 'Yoga', duration: '30 min', time: '8:30 AM', status: SessionStatus.notStarted, emoji: '🧘'),
  ];

  static const List<SmartSuggestion> suggestions = [
    SmartSuggestion(text: 'You skipped leg day twice 🦵\nAdd a leg session this week', icon: Icons.warning_amber_rounded, color: Color(0xFFFF6B35)),
    SmartSuggestion(text: 'Try a lighter workout today 🧘\nYour body needs recovery', icon: Icons.self_improvement_rounded, color: Color(0xFF7C4DFF)),
    SmartSuggestion(text: 'Great 12-day streak! 🔥\nKeep pushing, champ!', icon: Icons.local_fire_department_rounded, color: Color(0xFFFF6B35)),
    SmartSuggestion(text: 'Drink more water 💧\nYou logged only 4 glasses', icon: Icons.water_drop_rounded, color: Color(0xFF00B8FF)),
  ];

  static const List<AssignedProgram> workoutPrograms = [
    AssignedProgram(id: 'w1', name: 'Power Push-Pull', category: ProgramCategory.workout, difficulty: ProgramDifficulty.intermediate, duration: '8 weeks', sessionsPerWeek: '5 days/week', completedSessions: 18, totalSessions: 40, exercises: [
      ProgramExercise(name: 'Bench Press', detail: '4 sets × 10 reps'),
      ProgramExercise(name: 'Pull-ups', detail: '3 sets × 8 reps'),
      ProgramExercise(name: 'Shoulder Press', detail: '3 sets × 12 reps'),
      ProgramExercise(name: 'Cable Rows', detail: '3 sets × 15 reps'),
      ProgramExercise(name: 'Tricep Dips', detail: '3 sets × 12 reps'),
    ]),
    AssignedProgram(id: 'w2', name: 'Leg Hypertrophy', category: ProgramCategory.workout, difficulty: ProgramDifficulty.advanced, duration: '4 weeks', sessionsPerWeek: '3 days/week', completedSessions: 5, totalSessions: 12, exercises: [
      ProgramExercise(name: 'Barbell Squats', detail: '5 sets × 8 reps'),
      ProgramExercise(name: 'Romanian Deadlift', detail: '4 sets × 10 reps'),
      ProgramExercise(name: 'Leg Press', detail: '4 sets × 15 reps'),
      ProgramExercise(name: 'Lunges', detail: '3 sets × 12 reps'),
      ProgramExercise(name: 'Calf Raises', detail: '4 sets × 20 reps'),
    ]),
  ];

  static const List<AssignedProgram> yogaPrograms = [
    AssignedProgram(id: 'y1', name: 'Morning Flow Series', category: ProgramCategory.yoga, difficulty: ProgramDifficulty.beginner, duration: '4 weeks', sessionsPerWeek: '6 days/week', completedSessions: 10, totalSessions: 24, exercises: [
      ProgramExercise(name: 'Sun Salutation', detail: '5 rounds · 10 min'),
      ProgramExercise(name: 'Warrior Pose', detail: '45 sec each side'),
      ProgramExercise(name: 'Downward Dog', detail: '60 sec hold'),
      ProgramExercise(name: 'Child\'s Pose', detail: '45 sec hold'),
      ProgramExercise(name: 'Seated Twist', detail: '30 sec each side'),
    ]),
    AssignedProgram(id: 'y2', name: 'Flexibility & Recovery', category: ProgramCategory.yoga, difficulty: ProgramDifficulty.intermediate, duration: '3 weeks', sessionsPerWeek: '4 days/week', completedSessions: 3, totalSessions: 12, exercises: [
      ProgramExercise(name: 'Hip Opener Flow', detail: '2 min hold'),
      ProgramExercise(name: 'Pigeon Pose', detail: '90 sec each side'),
      ProgramExercise(name: 'Hamstring Stretch', detail: '60 sec each side'),
      ProgramExercise(name: 'Spine Twist', detail: '45 sec each side'),
    ]),
  ];

  static const TrainingProgress progress = TrainingProgress(
    currentStreak: 12, totalCompleted: 47, weeklyGoal: 5, weeklyDone: 3,
    weightChange: -2.0, strengthGain: '+2kg Bench Press',
    weeklyConsistency: [0.8, 0.6, 0.9, 0.6],
    weekDays: [
      WeekDay(day: 'M', workoutsCompleted: 2, isToday: false),
      WeekDay(day: 'T', workoutsCompleted: 1, isToday: false),
      WeekDay(day: 'W', workoutsCompleted: 2, isToday: false),
      WeekDay(day: 'T', workoutsCompleted: 0, isToday: true),
      WeekDay(day: 'F', workoutsCompleted: 0, isToday: false),
      WeekDay(day: 'S', workoutsCompleted: 0, isToday: false),
      WeekDay(day: 'S', workoutsCompleted: 0, isToday: false),
    ],
  );

  static const List<Badge> badges = [
    Badge(name: 'First Workout', emoji: '🏅', earnedDate: 'Apr 1'),
    Badge(name: '7-Day Streak', emoji: '🔥', earnedDate: 'Apr 10'),
    Badge(name: 'Consistency King', emoji: '👑', earnedDate: 'Apr 20', isNew: true),
    Badge(name: 'Yoga Master', emoji: '🧘', earnedDate: 'Apr 22', isNew: true),
    Badge(name: 'Early Bird', emoji: '🌅', earnedDate: 'Apr 25'),
    Badge(name: '50 Workouts', emoji: '💯', earnedDate: '', isNew: false),
  ];

  static const List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(name: 'Vikram S.', imageUrl: 'https://i.pravatar.cc/150?img=3', points: 2340, rank: 1),
    LeaderboardEntry(name: 'Priya N.', imageUrl: 'https://i.pravatar.cc/150?img=5', points: 2180, rank: 2),
    LeaderboardEntry(name: 'You', imageUrl: 'https://i.pravatar.cc/150?img=8', points: 1950, rank: 3, isCurrentUser: true),
    LeaderboardEntry(name: 'Arjun M.', imageUrl: 'https://i.pravatar.cc/150?img=7', points: 1820, rank: 4),
    LeaderboardEntry(name: 'Sneha R.', imageUrl: 'https://i.pravatar.cc/150?img=9', points: 1650, rank: 5),
  ];

  static const List<UpcomingSession> upcomingSessions = [
    UpcomingSession(date: 'Tomorrow', time: '7:00 AM', trainerName: 'Aryan', type: 'Strength Training'),
    UpcomingSession(date: 'Fri, May 2', time: '8:30 AM', trainerName: 'Aryan', type: 'HIIT Circuit'),
    UpcomingSession(date: 'Sat, May 3', time: '10:00 AM', trainerName: 'Aryan', type: 'Yoga & Recovery', isBookable: true),
  ];

  static const List<WellnessItem> wellnessItems = [
    WellnessItem(title: 'Box Breathing', emoji: '🌬️', duration: '5 min', type: WellnessType.breathing, description: 'Inhale 4s → Hold 4s → Exhale 4s → Hold 4s\nRepeat for 5 minutes.\nCalms the nervous system.'),
    WellnessItem(title: 'Focus Meditation', emoji: '🧠', duration: '10 min', type: WellnessType.meditation, description: 'Close your eyes. Focus on your breath.\nLet thoughts pass like clouds.\n10 minutes of stillness.'),
    WellnessItem(title: 'Foam Roll Recovery', emoji: '🧊', duration: '15 min', type: WellnessType.recovery, description: 'Quads: 2 min each\nHamstrings: 2 min each\nBack: 3 min\nCalves: 2 min each'),
  ];

  static const List<DiscoveryTrainer> myCommunityTrainers = [
    DiscoveryTrainer(
      id: 'dc1',
      name: 'Aryan Kapoor',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
      gymName: 'FitWeGo Premier Gym',
      specialty: 'Strength & Conditioning',
      experienceYears: 7,
      rating: 4.9,
      tagline: 'Helping 100+ clients lift heavier and live better.',
      isPremium: true,
      reviewsCount: 142,
      achievements: ['Top Trainer 2023', 'NSCA Certified', '100+ Transformations'],
      certifications: ['CSCS (NSCA)', 'ACE Personal Trainer', 'Precision Nutrition L1'],
      programsCreated: ['Power Push-Pull (8 Weeks)', 'Leg Hypertrophy (4 Weeks)'],
      servicesOffered: ['Personal Training', 'Online Coaching', 'Diet Plans'],
    ),
    DiscoveryTrainer(
      id: 'dc2',
      name: 'Priya Sharma',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      gymName: 'FitWeGo Premier Gym',
      specialty: 'Yoga & Mobility',
      experienceYears: 5,
      rating: 4.8,
      tagline: 'Find your balance and breathe through the pain.',
      isPremium: true,
      reviewsCount: 89,
      achievements: ['RYT-500 Certified', '500-hr Training'],
      certifications: ['RYT-500', 'Prenatal Yoga', 'Mindfulness Coach'],
      programsCreated: ['Morning Flow Series', 'Flexibility & Recovery'],
      servicesOffered: ['Yoga Sessions', 'Mobility Workshops', 'Meditation'],
    ),
  ];

  static const List<DiscoveryTrainer> exploreTrainers = [
    DiscoveryTrainer(
      id: 'ex1',
      name: 'Marcus Bell',
      imageUrl: 'https://i.pravatar.cc/150?img=11',
      gymName: 'PowerZone Gym',
      specialty: 'HIIT & Cardio',
      experienceYears: 6,
      rating: 4.7,
      tagline: 'Burn fat fast and build endurance.',
      isPremium: false,
      reviewsCount: 201,
      achievements: ['Top HIIT Coach', '50kg Weight Loss Records'],
      certifications: ['ACE Certified', 'TRX Pro'],
      programsCreated: ['30-Day Shred', 'Cardio Blast'],
      servicesOffered: ['HIIT Classes', 'Online Coaching'],
    ),
    DiscoveryTrainer(
      id: 'ex2',
      name: 'Emma Davis',
      imageUrl: 'https://i.pravatar.cc/150?img=9',
      gymName: 'Zen Fitness Studio',
      specialty: 'Pilates',
      experienceYears: 9,
      rating: 4.9,
      tagline: 'Core strength and posture improvement specialist.',
      isPremium: false,
      reviewsCount: 310,
      achievements: ['Pilates Alliance Certified', 'Rehab Expert'],
      certifications: ['NPCP', 'Balanced Body Instructor'],
      programsCreated: ['Core Foundation', 'Post-Rehab Pilates'],
      servicesOffered: ['Pilates Sessions', 'Posture Assessment'],
    ),
    DiscoveryTrainer(
      id: 'ex3',
      name: 'Rohan Mehta',
      imageUrl: 'https://i.pravatar.cc/150?img=8',
      gymName: 'Iron Core Athletics',
      specialty: 'Fat Loss & Diet',
      experienceYears: 4,
      rating: 4.6,
      tagline: 'Transforming bodies with sustainable diets.',
      isPremium: false,
      reviewsCount: 56,
      achievements: ['100+ Diet Plans Crafted'],
      certifications: ['Certified Nutritionist'],
      programsCreated: ['Keto Starter', 'Sustainable Fat Loss'],
      servicesOffered: ['Diet Planning', 'Online Coaching'],
    ),
  ];
}
