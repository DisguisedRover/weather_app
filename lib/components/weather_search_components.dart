import 'package:flutter/material.dart';

class WeatherSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback onLocationPressed;

  const WeatherSearch({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    required this.onLocationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white24),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter City',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.7),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onLocationPressed,
              ),
            ),
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}

class RecentSearches extends StatelessWidget {
  final List<String> searches;
  final Function(String) onSearchSelected;

  const RecentSearches({
    Key? key,
    required this.searches,
    required this.onSearchSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Recent Searches',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: searches.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: GestureDetector(
                      onTap: () => onSearchSelected(searches[index]),
                      child: Text(
                        searches[index],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
