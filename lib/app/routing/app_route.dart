enum AppRoute {
  dashboard(name: 'dashboard', path: '/'),
  tasks(name: 'tasks', path: '/tasks'),
  focusSession(name: 'focus-session', path: '/focus'),
  rewardCards(name: 'reward-cards', path: '/rewards'),
  gacha(name: 'gacha', path: '/gacha'),
  profileStats(name: 'profile-stats', path: '/profile');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}
