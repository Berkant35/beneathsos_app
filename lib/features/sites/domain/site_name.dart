/// Longest site name, in characters.
const maxSiteNameLength = 80;

/// Why a site name cannot be used.
sealed class SiteNameProblem {
  const SiteNameProblem();
}

/// Nothing but spaces.
final class EmptySiteName extends SiteNameProblem {
  /// Creates the problem.
  const EmptySiteName();
}

/// Longer than [maxSiteNameLength] after trimming.
final class SiteNameTooLong extends SiteNameProblem {
  /// Creates the problem.
  const SiteNameTooLong();
}

/// The name as stored: trimmed, or the problem with it.
({String? name, SiteNameProblem? problem}) checkSiteName(String raw) {
  final name = raw.trim();
  if (name.isEmpty) return (name: null, problem: const EmptySiteName());
  if (name.runes.length > maxSiteNameLength) {
    return (name: null, problem: const SiteNameTooLong());
  }
  return (name: name, problem: null);
}
