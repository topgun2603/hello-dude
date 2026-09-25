import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesu/features/home/online_tab.dart';
import 'package:pesu_api/api.dart';

OnlineCompanion c(
  String name, {
  String lang = 'ta',
  List<String>? langs,
  double? rating,
  int reviews = 0,
  bool busy = false,
  bool video = true,
  bool fav = false,
  int? price = 10,
}) => OnlineCompanion(
  id: name,
  badge: null,
  displayName: name,
  avatarId: 1,
  photoUrl: null,
  primaryLanguage: lang,
  languages: langs ?? [lang],
  rating: rating,
  ratingCount: reviews,
  audioEnabled: true,
  videoEnabled: video,
  busy: busy,
  isFavourite: fav,
  rates: CompanionRates(
    audioCoinsPerMin: price,
    videoCoinsPerMin: video ? 25 : null,
  ),
);

List<String> names(List<OnlineCompanion> l) =>
    l.map((e) => e.displayName).toList();

void main() {
  final all = [
    c('Priya', rating: 4.9, reviews: 10, busy: true),
    c(
      'Anu',
      lang: 'hi',
      langs: ['hi', 'en'],
      rating: 4.2,
      reviews: 40,
      price: 8,
      video: false,
    ),
    c('Kavya', rating: 4.5, reviews: 3, fav: true, price: 12),
    c('Meena', lang: 'te', price: null),
  ];

  test('recommended: free first, favourites next, then rating', () {
    expect(names(const OnlineFilter().apply(all)), [
      'Kavya',
      'Anu',
      'Meena',
      'Priya',
    ]);
  });

  test('sorts by rating, reviews, price and name', () {
    expect(names(const OnlineFilter(sort: OnlineSort.topRated).apply(all)), [
      'Priya',
      'Kavya',
      'Anu',
      'Meena',
    ]);
    expect(
      names(const OnlineFilter(sort: OnlineSort.mostReviewed).apply(all)).first,
      'Anu',
    );
    expect(names(const OnlineFilter(sort: OnlineSort.lowestPrice).apply(all)), [
      'Anu',
      'Priya',
      'Kavya',
      'Meena',
    ]); // 8, 10, 12, no price last
    expect(names(const OnlineFilter(sort: OnlineSort.name).apply(all)), [
      'Anu',
      'Kavya',
      'Meena',
      'Priya',
    ]);
  });

  test('search matches names and language names, case-insensitive', () {
    expect(names(const OnlineFilter(query: 'kav').apply(all)), ['Kavya']);
    expect(names(const OnlineFilter(query: 'english').apply(all)), ['Anu']);
  });

  test(
    'filters: language, free now, video, favourites; cleared keeps the sort',
    () {
      expect(names(const OnlineFilter(language: 'en').apply(all)), ['Anu']);
      expect(
        names(const OnlineFilter(freeOnly: true).apply(all)),
        isNot(contains('Priya')),
      );
      expect(
        names(const OnlineFilter(videoOnly: true).apply(all)),
        isNot(contains('Anu')),
      );
      expect(names(const OnlineFilter(favouritesOnly: true).apply(all)), [
        'Kavya',
      ]);
      final f = const OnlineFilter(
        query: 'x',
        freeOnly: true,
        sort: OnlineSort.name,
      ).cleared();
      expect(f.isFiltered, isFalse);
      expect(f.sort, OnlineSort.name);
    },
  );

  testWidgets(
    'Random FAB: label when expanded, icon only when collapsed, tap calls back',
    (t) async {
      var taps = 0;
      Widget fab(bool expanded) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: RandomFab(expanded: expanded, onPressed: () => taps++),
          ),
        ),
      );
      await t.pumpWidget(fab(true));
      expect(find.text('Random'), findsOneWidget);
      await t.tap(find.byType(RandomFab));
      expect(taps, 1);
      await t.pumpWidget(fab(false));
      await t.pumpAndSettle();
      expect(find.text('Random'), findsNothing);
      expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
    },
  );
}
