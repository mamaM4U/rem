class ProjectConfig {
  final String workspaceName;
  final bool includeArona;
  final bool includePlana;
  final bool includeArisu;
  final AronaConfig? aronaConfig;
  final PlanaConfig? planaConfig;
  final ArisuConfig? arisuConfig;

  ProjectConfig({
    required this.workspaceName,
    required this.includeArona,
    required this.includePlana,
    required this.includeArisu,
    this.aronaConfig,
    this.planaConfig,
    this.arisuConfig,
  });
}

class AronaConfig {
  final String packageName;
  final String displayName;
  final String bundleIdBase;
  final List<String> flavors;

  AronaConfig({
    required this.packageName,
    required this.displayName,
    required this.bundleIdBase,
    this.flavors = const ['local', 'dev', 'prod'],
  });
}

class PlanaConfig {
  final String packageName;
  final String databaseName;

  PlanaConfig({
    required this.packageName,
    required this.databaseName,
  });
}

class ArisuConfig {
  final String packageName;

  ArisuConfig({
    required this.packageName,
  });
}
