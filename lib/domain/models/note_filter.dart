enum NoteSortBy {
  updatedAtDesc,
  updatedAtAsc,
  createdAtDesc,
  createdAtAsc,
  titleAsc,
  titleDesc,
}

enum NoteSection {
  all,
  favorites,
  archived,
  trash,
}

class NoteFilter {
  final String searchQuery;
  final String? selectedCategoryId;
  final Set<String> selectedTagIds;
  final NoteSection section;
  final NoteSortBy sortBy;
  final bool onlyPinned;

  const NoteFilter({
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedTagIds = const {},
    this.section = NoteSection.all,
    this.sortBy = NoteSortBy.updatedAtDesc,
    this.onlyPinned = false,
  });

  NoteFilter copyWith({
    String? searchQuery,
    String? Function()? selectedCategoryId,
    Set<String>? selectedTagIds,
    NoteSection? section,
    NoteSortBy? sortBy,
    bool? onlyPinned,
  }) {
    return NoteFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId != null ? selectedCategoryId() : this.selectedCategoryId,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      section: section ?? this.section,
      sortBy: sortBy ?? this.sortBy,
      onlyPinned: onlyPinned ?? this.onlyPinned,
    );
  }

  bool get hasActiveFilter =>
      searchQuery.trim().isNotEmpty ||
      selectedCategoryId != null ||
      selectedTagIds.isNotEmpty ||
      onlyPinned;
}
