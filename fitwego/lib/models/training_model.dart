// ── Training Screen Models & Demo Data ────────────────────────────────────────

import 'package:flutter/material.dart';

enum SessionStatus { notStarted, inProgress, completed }
enum ProgramCategory { workout, yoga, diet }
enum ProgramDifficulty { beginner, intermediate, advanced }
enum UserGoal { fatLoss, muscleGain, flexibility }
enum WellnessType { breathing, meditation, recovery }
enum TrainerStatus { available, busy, inSession }

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

class GymMembershipPlan {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  const GymMembershipPlan({required this.name, required this.price, required this.period, required this.features});
}

class GymReview {
  final String userName;
  final String comment;
  final double rating;
  final String date;
  const GymReview({required this.userName, required this.comment, required this.rating, required this.date});
}

class GymCentre {
  final String id;
  final String name;
  final String logoUrl;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final String distance;
  final String address;
  final bool isPartner;
  final bool isVerified;
  final bool isFeatured;
  final String type; // 'Premium', 'Budget', 'Standard'
  final bool isOpenNow;
  final List<DiscoveryTrainer> trainers;
  final List<GymMembershipPlan> membershipPlans;
  final List<GymReview> reviews;
  final List<String> services; // ['Yoga', 'Strength', 'Pool', etc]
  final double mapX;
  final double mapY;
  final int popularityScore;

  const GymCentre({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.address,
    this.isPartner = true,
    this.isVerified = true,
    this.isFeatured = false,
    this.type = 'Standard',
    this.isOpenNow = true,
    this.trainers = const [],
    this.membershipPlans = const [],
    this.reviews = const [],
    this.services = const [],
    this.mapX = 0.5,
    this.mapY = 0.5,
    this.popularityScore = 0,
  });
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
  final List<String> portfolioImages;
  final String portfolioWritten;
  final int reviewsCount;
  // Map discovery fields
  final TrainerStatus status;
  final String distance;

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
    this.portfolioImages = const [],
    this.portfolioWritten = '',
    this.reviewsCount = 0,
    this.status = TrainerStatus.available,
    this.distance = '1.0 km',
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
    AssignedProgram(id: 'w3', name: 'Core Blast', category: ProgramCategory.workout, difficulty: ProgramDifficulty.beginner, duration: '2 weeks', sessionsPerWeek: '3 days/week', completedSessions: 2, totalSessions: 6, exercises: [
      ProgramExercise(name: 'Crunches', detail: '3 sets × 20 reps'),
      ProgramExercise(name: 'Plank', detail: '3 sets × 60 sec'),
      ProgramExercise(name: 'Russian Twists', detail: '3 sets × 30 reps'),
      ProgramExercise(name: 'Leg Raises', detail: '3 sets × 15 reps'),
    ]),
    AssignedProgram(id: 'w4', name: 'Cardio Endurance', category: ProgramCategory.workout, difficulty: ProgramDifficulty.intermediate, duration: '6 weeks', sessionsPerWeek: '4 days/week', completedSessions: 12, totalSessions: 24, exercises: [
      ProgramExercise(name: 'Treadmill Sprints', detail: '10 intervals (30s on/30s off)'),
      ProgramExercise(name: 'Jump Rope', detail: '5 sets × 3 min'),
      ProgramExercise(name: 'Rowing Machine', detail: '2000m row'),
      ProgramExercise(name: 'Burpees', detail: '4 sets × 15 reps'),
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

  static const List<DiscoveryTrainer> trainers = [
    DiscoveryTrainer(
      id: 't1', name: 'Aryan Kapoor', imageUrl: 'https://i.pravatar.cc/150?img=12', gymName: 'FitWeGo Elite', specialty: 'Strength',
      experienceYears: 7, rating: 4.9, tagline: 'Lifting heavier, living better.', isPremium: true, reviewsCount: 142,
      achievements: ['Top Trainer 2023'], certifications: ['NSCA-CSCS'], programsCreated: ['Power Push-Pull'], servicesOffered: ['Personal Training'],
      portfolioImages: ['https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500'],
      portfolioWritten: 'Transformed over 50 clients last year with specialized hypertrophy and strength conditioning protocols. Known for detailed biomechanical analysis and injury prevention techniques.',
    ),
    DiscoveryTrainer(
      id: 't2', name: 'Priya Sharma', imageUrl: 'https://i.pravatar.cc/150?img=5', gymName: 'FitWeGo Elite', specialty: 'Yoga',
      experienceYears: 5, rating: 4.8, tagline: 'Find your inner flow.', isPremium: true, reviewsCount: 89,
      achievements: ['RYT-500'], certifications: ['Yoga Alliance'], programsCreated: ['Morning Flow'], servicesOffered: ['Yoga Classes'],
      portfolioWritten: 'Specializes in Vinyasa flow and restorative yoga. Helped hundreds of clients improve flexibility, reduce stress, and achieve mental clarity through mindful movement and breathwork.',
    ),
    DiscoveryTrainer(
      id: 't3', name: 'Marcus Bell', imageUrl: 'https://i.pravatar.cc/150?img=11', gymName: 'PowerHouse Gym', specialty: 'HIIT',
      experienceYears: 6, rating: 4.7, tagline: 'Shred fat fast.', reviewsCount: 201,
      achievements: ['CrossFit Games Regional Competitor'], certifications: ['ACE Certified', 'Kettlebell Level 2'], programsCreated: ['30-Day Shred', 'Kettlebell Core'], servicesOffered: ['Group Classes', '1-on-1 HIIT'],
      portfolioWritten: 'Designed intense, calorie-burning routines that push clients beyond their limits. Specializes in short-duration, high-impact workouts that deliver maximum results.',
      portfolioImages: ['https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=500'],
    ),
    DiscoveryTrainer(
      id: 't4', name: 'Emma Davis', imageUrl: 'https://i.pravatar.cc/150?img=9', gymName: 'Zen Fitness', specialty: 'Pilates',
      experienceYears: 9, rating: 4.9, tagline: 'Core strength specialist.', reviewsCount: 310,
      achievements: ['Pilates Instructor of the Year'], certifications: ['PMA-CPT', 'Barre Certified'], programsCreated: ['Core Control', 'Postural Correction'], servicesOffered: ['Reformer Pilates', 'Mat Pilates'],
      portfolioWritten: 'Focuses on building foundational core strength, improving posture, and rehabilitating injuries. Believes in the mind-body connection to achieve lasting wellness.',
      portfolioImages: ['https://images.unsplash.com/photo-1518611012118-696072aa579a?q=80&w=500'],
    ),
    DiscoveryTrainer(
      id: 't5', name: 'Zoe Carter', imageUrl: 'https://i.pravatar.cc/150?img=4', gymName: 'Aqua Wellness Club', specialty: 'Water Aerobics',
      experienceYears: 4, rating: 4.8, tagline: 'Low impact, high results.', reviewsCount: 156, isPremium: true,
      achievements: ['Certified Aquatics Pro'], certifications: ['AEA Certified'], programsCreated: ['Aqua Burn', 'Senior Splash'], servicesOffered: ['Water Aerobics', 'Swim Coaching'],
      portfolioWritten: 'Specializes in aquatic fitness for all ages. Provides joint-friendly resistance training that builds strength and cardiovascular endurance without the impact of land workouts.',
      portfolioImages: ['https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=500'],
    ),
    DiscoveryTrainer(
      id: 't6', name: 'David Kim', imageUrl: 'https://i.pravatar.cc/150?img=8', gymName: 'Flex Factory', specialty: 'Bodybuilding',
      experienceYears: 10, rating: 4.9, tagline: 'Sculpt your dream physique.', reviewsCount: 420, isPremium: true,
      achievements: ['Mr. Olympia Competitor'], certifications: ['IFBB Pro', 'NASM CPT'], programsCreated: ['Mass Builder', 'Contest Prep'], servicesOffered: ['Posing Coaching', 'Hypertrophy Training'],
      portfolioWritten: 'Expert in extreme body transformation and contest preparation. Uses scientific principles to maximize muscle growth and minimize body fat safely.',
      portfolioImages: ['https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=500'],
    ),
    DiscoveryTrainer(
      id: 't7', name: 'Sarah Jones', imageUrl: 'https://i.pravatar.cc/150?img=1', gymName: 'Iron Grip Budget Gym', specialty: 'Powerlifting',
      experienceYears: 5, rating: 4.6, tagline: 'Lift heavy, stay humble.', reviewsCount: 98,
      achievements: ['State Deadlift Record Holder'], certifications: ['USAPL Coach'], programsCreated: ['Intro to Powerlifting'], servicesOffered: ['Form Checking', 'Strength Cycles'],
      portfolioWritten: 'Passionate about helping beginners discover their absolute strength. Focuses heavily on the big three: squat, bench, and deadlift with perfect mechanics.',
      portfolioImages: ['https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=500'],
    ),
    DiscoveryTrainer(
      id: 't8', name: 'Leo Martinez', imageUrl: 'https://i.pravatar.cc/150?img=13', gymName: 'Independent', specialty: 'Dance Fitness',
      experienceYears: 3, rating: 4.5, tagline: 'Sweat with a smile.', reviewsCount: 245,
      achievements: ['Zumba Jammer'], certifications: ['Zumba Basic 1 & 2'], programsCreated: ['Cardio Fiesta'], servicesOffered: ['Group Dance Classes', 'Event Warm-ups'],
      portfolioWritten: 'Brings high energy and infectious rhythms to every class. Makes fitness feel like a party while burning hundreds of calories per session.',
      portfolioImages: ['https://images.unsplash.com/photo-1524594152303-9fd13543fe6e?q=80&w=500'],
    ),
  ];

  static List<DiscoveryTrainer> get myCommunityTrainers => trainers.where((t) => t.isPremium).toList();
  static List<DiscoveryTrainer> get exploreTrainers => trainers.where((t) => !t.isPremium).toList();

  static final List<GymCentre> partnerGyms = [
    GymCentre(
      id: 'g1',
      name: 'FitWeGo Elite Centre',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/69/69840.png',
      images: [
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800',
        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800',
      ],
      rating: 4.9,
      reviewsCount: 1240,
      distance: '0.8 km',
      address: '12th Floor, Blue Tower, Business Bay',
      isFeatured: true,
      type: 'Premium',
      services: ['Strength', 'Yoga', 'Pool', 'Steam'],
      popularityScore: 98,
      mapX: 0.45,
      mapY: 0.40,
      trainers: [trainers[0], trainers[1]],
      membershipPlans: [
        GymMembershipPlan(name: 'Basic', price: '₹2,999', period: '/month', features: ['Gym Access', 'Locker']),
        GymMembershipPlan(name: 'Pro', price: '₹4,999', period: '/month', features: ['Gym + Pool', '1 Personal Training/mo']),
      ],
      reviews: [
        GymReview(userName: 'Rahul M.', comment: 'Best gym in the area! Very clean.', rating: 5.0, date: '2 days ago'),
      ],
    ),
    GymCentre(
      id: 'g2',
      name: 'PowerHouse Gym',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/2964/2964514.png',
      images: [
        'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=800',
      ],
      rating: 4.6,
      reviewsCount: 850,
      distance: '2.1 km',
      address: 'Ground Floor, Metro Mall, Sector 4',
      type: 'Standard',
      services: ['Crossfit', 'Strength', 'Boxing'],
      popularityScore: 82,
      mapX: 0.25,
      mapY: 0.65,
      trainers: [trainers[2]],
    ),
    GymCentre(
      id: 'g3',
      name: 'Zen Fitness Studio',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3048/3048374.png',
      images: [
        'https://images.unsplash.com/photo-1599447421416-3414500d18a5?q=80&w=800',
      ],
      rating: 4.8,
      reviewsCount: 420,
      distance: '3.5 km',
      address: 'Suite 405, Wellness Plaza',
      type: 'Premium',
      services: ['Pilates', 'Yoga', 'Meditation'],
      popularityScore: 75,
      mapX: 0.75,
      mapY: 0.30,
      trainers: [trainers[3]],
    ),
    GymCentre(
      id: 'g4',
      name: 'Iron Grip Budget Gym',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3144/3144983.png',
      images: ['https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=800'],
      rating: 4.2,
      reviewsCount: 310,
      distance: '1.2 km',
      address: 'Basement, Market Square',
      type: 'Budget',
      services: ['Strength', 'Cardio'],
      mapX: 0.8,
      mapY: 0.8,
    ),
    GymCentre(
      id: 'g5',
      name: 'Aqua Wellness Club',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/2964/2964514.png',
      images: ['https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800'],
      rating: 4.7,
      reviewsCount: 520,
      distance: '4.0 km',
      address: 'Riverside Drive',
      type: 'Premium',
      services: ['Pool', 'Yoga', 'Spa'],
      mapX: 0.15,
      mapY: 0.15,
      isFeatured: true,
    ),
    GymCentre(
      id: 'g6',
      name: 'Flex Factory',
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/69/69840.png',
      images: ['https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800'],
      rating: 4.4,
      reviewsCount: 200,
      distance: '0.5 km',
      address: 'Downtown Main St',
      type: 'Budget',
      services: ['Strength'],
      mapX: 0.5,
      mapY: 0.2,
    ),
  ];
}
