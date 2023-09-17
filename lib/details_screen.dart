import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:travel_ui_flutter/models/movie.dart';

class DetailsScreen extends StatefulWidget {
  final Movie item;

  const DetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late ScrollController _scrollController;
  // late ValueNotifier<double> bottomPercentNotifier;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 300);
    // bottomPercentNotifier = ValueNotifier(1.0);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: CustomSliverAppBarDelegate(
              maxExtent: MediaQuery.of(context).size.height,
              minExtent: 380,
              builder: (percent) {
                final bottomPercent = (percent / 0.3).clamp(0.0, 1.0);

                return _MainImage(
                    item: widget.item,
                    topPercent: ((1 - percent) / 0.7).clamp(0.0, 1.0),
                    bottomPercent: bottomPercent);
              },
            ),
          ),
          const SliverToBoxAdapter(child: Placeholder()),
          const SliverToBoxAdapter(child: Placeholder()),
          const SliverToBoxAdapter(child: Placeholder()),
        ],
      ),
    );
  }
}

class TranslateAnimation extends StatelessWidget {
  const TranslateAnimation({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * value),
          child: child!,
        );
      },
      child: child,
    );
  }
}

class _MainImage extends StatelessWidget {
  const _MainImage({
    required this.item,
    required this.topPercent,
    required this.bottomPercent,
  });

  final double topPercent;
  final double bottomPercent;
  final Movie item;

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (paddingTop) * (1 - bottomPercent),
                  bottom: 160 * (1 - bottomPercent),
                ),
                child: Transform.scale(
                  scale: lerpDouble(1, 1.3, bottomPercent),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: 3,
                          controller: PageController(viewportFraction: 0.9),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: index == 2
                                  ? const EdgeInsets.only(right: 0)
                                  : const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  alignment: Alignment.topCenter,
                                  image: NetworkImage(item.posterPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            3,
                            (index) => Container(
                              margin: index == 2
                                  ? const EdgeInsets.only(right: 0)
                                  : const EdgeInsets.only(right: 10),
                              width: 15,
                              height: 5,
                              decoration: const BoxDecoration(
                                // shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: paddingTop + 10,
                left: -60 * (0.6 - bottomPercent),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
              ),
              Positioned(
                top: paddingTop + 10,
                right: -60 * (0.5 - bottomPercent),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.blue,
                ),
              ),
              Positioned(
                top: lerpDouble(-30, 140, topPercent)!
                    .clamp(paddingTop + 5, 140),
                left: lerpDouble(60, 60, topPercent)!.clamp(20, 50),
                child: AnimatedOpacity(
                  duration: const Duration(microseconds: 500),
                  opacity: bottomPercent < 1 ? 0 : 1,
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: Container(
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '123',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '123',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                RotatedBox(
                  quarterTurns: 2,
                  child: FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.lightbulb_circle,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    label: const RotatedBox(
                      quarterTurns: 2,
                      child: Text(
                        '123',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 10,
          ),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    ...List.generate(
                      3,
                      (index) => Align(
                        widthFactor: 0.7,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white54, width: 3),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(item.posterPath),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double percent) builder;

  const CustomSliverAppBarDelegate({
    required double maxExtent,
    required double minExtent,
    required this.builder,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
// https://www.youtube.com/watch?v=bEHPCwjLdno