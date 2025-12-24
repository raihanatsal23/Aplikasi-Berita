import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/trending_card.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/shimmer_loading.dart';
import 'news_detail_page.dart';
import 'trending_page.dart';
import 'latest_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _trendingPageController = PageController(
    viewportFraction: 0.85,
  );

  String _selectedCategory = 'All';
  int _currentTrendingPage = 0;

  @override
  void initState() {
    super.initState();
    _trendingPageController.addListener(() {
      int next = _trendingPageController.page!.round();
      if (_currentTrendingPage != next) {
        setState(() {
          _currentTrendingPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _trendingPageController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<NewsBloc>().add(SearchNews(query));
    } else {
      context.read<NewsBloc>().add(LoadLatestNews(
            category: AppConstants.categoryMapping[_selectedCategory]!,
          ));
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
    });
    context.read<NewsBloc>().add(LoadLatestNews(
          category: AppConstants.categoryMapping[category]!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ← FIX
      appBar: AppBar(
        title: Text(
          'Homepage',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600], // ← FIX
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDarkMode ? Colors.white : Colors.black87, // ← FIX
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Notifications coming soon',
                    style: GoogleFonts.inter(),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NewsBloc>().add(RefreshNews());
        },
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const SingleChildScrollView(
                child: ShimmerLoading(),
              );
            }

            if (state is NewsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            isDarkMode ? Colors.white : Colors.black87, // ← FIX
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600], // ← FIX
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NewsBloc>().add(LoadTrendingNews());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is NewsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _onSearch,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: GoogleFonts.inter(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[500],
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.tune,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              onPressed: () {},
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Trending Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trending',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.black87, // ← FIX
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrendingPage(
                                    trendingNews: state.trendingNews,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF0066FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Trending List with PageView Swipe
                    SizedBox(
                      height: 320,
                      child: state.trendingNews.isEmpty
                          ? Center(
                              child: Text(
                                'No trending news',
                                style: GoogleFonts.inter(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600], // ← FIX
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                // PageView
                                Expanded(
                                  child: PageView.builder(
                                    controller: _trendingPageController,
                                    itemCount: state.trendingNews.length,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentTrendingPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      final article = state.trendingNews[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: TrendingCard(
                                          article: article,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetailPage(
                                                  article: article,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Page Indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    state.trendingNews.length > 5
                                        ? 5
                                        : state.trendingNews.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        _trendingPageController.animateToPage(
                                          index,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: _currentTrendingPage == index
                                            ? 24
                                            : 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: _currentTrendingPage == index
                                              ? const Color(0xFF0066FF)
                                              : (isDarkMode
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300]), // ← FIX
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Latest Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Latest',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.black87, // ← FIX
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LatestPage(
                                    latestNews: state.latestNews,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF0066FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Category Chips
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: AppConstants.categories.length,
                        itemBuilder: (context, index) {
                          final category = AppConstants.categories[index];
                          return CategoryChip(
                            label: category,
                            isSelected: category == _selectedCategory,
                            onTap: () => _onCategorySelected(category),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Latest News List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: state.latestNews.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'No news found',
                                  style: GoogleFonts.inter(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600], // ← FIX
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: state.latestNews.map((article) {
                                return NewsCard(
                                  article: article,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailPage(
                                          article: article,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
