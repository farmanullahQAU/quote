import 'package:flutter/material.dart';
import 'package:myapp/models/topics.dart';

const primaryColor = 0xff0cc0df;
const primaryColor2 = 0xff8965e9;
const primaryColor3 = 0xff24a7e9;

const primaryColor4 = 0xfffea33e;
const primaryColor5 = 0xff16b876;

const backgroundColorDark = 0xff121212;

const String accountsStorageKey = "ACCOUNTS_STORAGEKEY";

const String walletStorageKey = "walletStorageKey";
const String passwordStorageKey = "passwordStorageKey";

const String primaryColorKey = "colorKey";
const String selectedNetworkKey = "selectedNetworkKey";
const String allTestChainsKey = "allTestChainsKey";
const String allMainChainsKey = "allMainChainsKey";
const String themeModeKey = "themeModeKey";
double initialFontSize = 20.0;

Color initialTxtColor = Colors.white;

final List<Color> colors = [
  Colors.black,
  Colors.white,
  Colors.grey[900]!,
  Colors.grey[700]!,
  Colors.red[900]!,
  Colors.red[700]!,
  Colors.red[500]!,
  Colors.pink[900]!,
  Colors.pink[700]!,
  Colors.pink[500]!,
  Colors.purple[900]!,
  Colors.purple[700]!,
  Colors.purple[500]!,
  Colors.deepPurple[900]!,
  Colors.deepPurple[700]!,
  Colors.deepPurple[500]!,
  Colors.deepPurple[300]!,
  Colors.indigo[900]!,
  Colors.indigo[700]!,
  Colors.indigo[500]!,
  Colors.indigo[300]!,
  Colors.blue[900]!,
  Colors.blue[700]!,
  Colors.blue[500]!,
  Colors.blue[300]!,
  Colors.green[900]!,
  Colors.green[700]!,
  Colors.green[500]!,
  Colors.green[300]!,
  Colors.teal[900]!,
  Colors.teal[700]!,
  Colors.teal[500]!,
  Colors.teal[300]!,
  Colors.orange[900]!,
  Colors.orange[700]!,
  Colors.orange[500]!,
  Colors.orange[300]!,
];

final List<String> fontFamilies = [
  'Roboto',
  'Lato',
  'Open Sans',
  'Montserrat',
  'Raleway',
  'Poppins',
  'Oswald',
  'Merriweather',
  'Playfair Display',
  'Nunito',
  'Rubik',
  'Ubuntu',
  'Work Sans',
  'Quicksand',
  'Titillium Web',
  'Josefin Sans',
  'Cabin',
  'Bitter',
  'Karla',
  'Libre Franklin',
  'Abril Fatface',
  'Cormorant Garamond',
  'Crimson Text',
  'Dosis',
  'Fira Sans',
  'Heebo',
  'Hind',
  'Inconsolata',
  'Julius Sans One',
  'Kanit',
  'Libre Baskerville',
  'Noto Sans',
  'PT Sans',
  'PT Serif',
  'Sarabun',
  'Sora',
  'Spectral',
  'Syne',
  'Zilla Slab',
  'Manrope',
  'Mulish',
  'Prompt',
  'Raleway Dots',
  'Satisfy',
  'Tajawal',
  'Vollkorn',
  'Yanone Kaffeesatz',
  'Yellowtail',
  'Yeseva One'
];
final List<Category> topics = [
  Category(
    name: 'General',
    subTopics: [
      SubTopic(title: 'Daily Motivation', icon: Icons.language),
      SubTopic(title: 'Self-Reflection', icon: Icons.favorite),
      SubTopic(title: 'Mindset', icon: Icons.mood, isLocked: true),
      SubTopic(title: 'Gratitude', icon: Icons.edit),
      SubTopic(title: 'Perspective', icon: Icons.lightbulb, isLocked: true),
      SubTopic(title: 'Positivity', icon: Icons.sentiment_satisfied_alt),
      SubTopic(title: 'Growth Mindset', icon: Icons.eco),
    ],
  ),
  Category(
    name: 'For You',
    subTopics: [
      SubTopic(
          title: 'Mind and Body Balance',
          icon: Icons.fitness_center,
          isLocked: true),
      SubTopic(
          title: 'Mental Health',
          icon: Icons.health_and_safety,
          isLocked: true),
      SubTopic(title: 'Spirituality', icon: Icons.spa, isLocked: true),
      SubTopic(
          title: 'Personal Development', icon: Icons.person, isLocked: true),
      SubTopic(
          title: 'Self-Care', icon: Icons.self_improvement, isLocked: true),
      SubTopic(title: 'Meditation', icon: Icons.bedtime, isLocked: true),
      SubTopic(
          title: 'Healthy Habits', icon: Icons.local_hospital, isLocked: true),
    ],
  ),
  Category(
    name: 'Hard Times',
    subTopics: [
      SubTopic(title: 'Courage', icon: Icons.shield),
      SubTopic(title: 'Perseverance', icon: Icons.sports_handball),
      SubTopic(title: 'Healing', icon: Icons.healing),
      SubTopic(title: 'Overcoming Adversity', icon: Icons.trending_up),
      SubTopic(title: 'Inner Strength', icon: Icons.fitness_center),
      SubTopic(title: 'Survival', icon: Icons.surround_sound),
    ],
  ),
  Category(
    name: 'Philosophy',
    subTopics: [
      SubTopic(title: 'Absurdism', icon: Icons.public),
      SubTopic(title: 'Nihilism', icon: Icons.brightness_3),
      SubTopic(title: 'Utilitarianism', icon: Icons.people),
      SubTopic(title: 'Virtue Ethics', icon: Icons.balance),
      SubTopic(title: 'Determinism', icon: Icons.timeline),
      SubTopic(title: 'Epistemology', icon: Icons.search),
    ],
  ),
  Category(
    name: 'Inspiration',
    subTopics: [
      SubTopic(title: 'Entrepreneurship', icon: Icons.business_center),
      SubTopic(title: 'Vision', icon: Icons.visibility),
      SubTopic(title: 'Ambition', icon: Icons.emoji_flags),
      SubTopic(title: 'Empowerment', icon: Icons.trending_up),
      SubTopic(title: 'Dreams', icon: Icons.nightlight_round),
      SubTopic(title: 'Motivational Stories', icon: Icons.import_contacts),
      SubTopic(title: 'Goal Achievement', icon: Icons.check_circle),
    ],
  ),
  Category(
    name: 'Relationships',
    subTopics: [
      SubTopic(title: 'Trust Building', icon: Icons.lock),
      SubTopic(title: 'Conflict Resolution', icon: Icons.mediation),
      SubTopic(title: 'Support Systems', icon: Icons.support),
      SubTopic(title: 'Compassion', icon: Icons.favorite_border),
      SubTopic(title: 'Romantic Love', icon: Icons.favorite),
      SubTopic(title: 'Parenting', icon: Icons.child_care),
    ],
  ),
  Category(
    name: 'Career',
    subTopics: [
      SubTopic(title: 'Leadership', icon: Icons.leaderboard),
      SubTopic(title: 'Teamwork', icon: Icons.group),
      SubTopic(title: 'Work-Life Balance', icon: Icons.timelapse),
      SubTopic(title: 'Career Growth', icon: Icons.trending_up),
      SubTopic(title: 'Networking', icon: Icons.network_cell),
      SubTopic(title: 'Productivity', icon: Icons.timer),
      SubTopic(title: 'Workplace Ethics', icon: Icons.verified_user),
    ],
  ),
  Category(
    name: 'Success',
    subTopics: [
      SubTopic(title: 'Financial Success', icon: Icons.attach_money),
      SubTopic(title: 'Professional Success', icon: Icons.business),
      SubTopic(title: 'Personal Success', icon: Icons.person_pin),
      SubTopic(title: 'Success Mindset', icon: Icons.psychology),
      SubTopic(title: 'Success Habits', icon: Icons.how_to_reg),
      SubTopic(title: 'Overcoming Failure', icon: Icons.replay),
      SubTopic(title: 'Resilience', icon: Icons.restore),
    ],
  ),
  Category(
    name: 'Creativity',
    subTopics: [
      SubTopic(title: 'Innovation', icon: Icons.lightbulb),
      SubTopic(title: 'Artistic Expression', icon: Icons.brush),
      SubTopic(title: 'Problem Solving', icon: Icons.psychology_alt),
      SubTopic(title: 'Design Thinking', icon: Icons.design_services),
      SubTopic(title: 'Storytelling', icon: Icons.book),
      SubTopic(title: 'Creative Writing', icon: Icons.edit),
    ],
  ),
  Category(
    name: 'Mindfulness',
    subTopics: [
      SubTopic(title: 'Meditation', icon: Icons.bedtime),
      SubTopic(title: 'Breathing Exercises', icon: Icons.air),
      SubTopic(title: 'Gratitude Practices', icon: Icons.local_florist),
      SubTopic(title: 'Mindful Eating', icon: Icons.local_dining),
      SubTopic(title: 'Body Awareness', icon: Icons.fitness_center),
      SubTopic(title: 'Focus & Concentration', icon: Icons.center_focus_strong),
      SubTopic(title: 'Mindful Movement', icon: Icons.directions_run),
    ],
  ),
  Category(
    name: 'Life Lessons',
    subTopics: [
      SubTopic(title: 'Patience', icon: Icons.hourglass_bottom),
      SubTopic(title: 'Gratitude', icon: Icons.sentiment_satisfied_alt),
      SubTopic(title: 'Kindness', icon: Icons.volunteer_activism),
      SubTopic(title: 'Empathy', icon: Icons.handshake),
      SubTopic(title: 'Self-Discipline', icon: Icons.self_improvement),
      SubTopic(title: 'Adaptability', icon: Icons.transform),
      SubTopic(title: 'Wisdom', icon: Icons.school),
    ],
  ),
];
