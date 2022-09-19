import 'package:choicedrop/APIS/model/products.dart';
import 'package:choicedrop/LogIn/helpers/ImageGuard.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:choicedrop/StoreHome/Gridlayout.dart';
import 'package:choicedrop/StoreHome/tabcategories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:math' as math;

enum FilterTabs {
  All,
//   Categories,
//   Type,
//   Usage,
}

typedef void FilterTabCallback(FilterTabs tab);

class StoreHome extends StatefulWidget {
  final dynamic products;

  final double collapsedHeight;
  final double expandedHeight;

  int colorVal;

  StoreHome(
      {Key key,
      @required this.products,
      this.collapsedHeight,
      this.expandedHeight,
      this.colorVal})
      : super(key: key);

  @override
  State createState() => _StoreHome(products, expandedHeight, collapsedHeight);
}

class _StoreHome extends State<StoreHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int colorVal;

  TabController _tabController;
  var filteredProducts;
  double cartTotal = 0;
  List suggestList = [];

//Ratings
  int starCount = 5;
  double rating = 4.5;

  List<Products> products;
  dynamic id;

//Products
  var productList;
  bool priceSorted = false;
  bool _priceSorted = false;
  bool _thcSorted = false;
  bool _cbdSorted = false;
  bool _showFab = true;
  int _shippingIconNum = 0;

  final double expandedHeight;
  final double collapsedHeight;

  double get minExtent => collapsedHeight;
  double get maxExtent => math.max(expandedHeight, minExtent);

  _StoreHome(this.products, this.expandedHeight, this.collapsedHeight);

  List filterDropdown = [
    'Price: Low-High',
    'Price: High-Low',
    'THC: High-Low',
    'THC: Low-High',
    'Only CBD',
  ];

  List _shippingIndicatorIcons = [
    Container(
      child: Icon(
        FontAwesomeIcons.car,
        color: Colors.black,
        size: 25,
      ),
    ),
    Container(
      child: Icon(
        FontAwesomeIcons.truck,
        color: Colors.black,
        size: 25,
      ),
    ),
    Row(
      children: [
        Icon(
          FontAwesomeIcons.car,
          color: Colors.black,
          size: 25,
        ),
        Icon(
          FontAwesomeIcons.truck,
          color: Colors.black,
          size: 25,
        ),
      ],
    ),
  ];

  List _buttonColors = [Colors.white, Colors.black];

  List _tabDetails = [
    '',
    // 'Category',
    // 'Type',
    // 'Usage',
  ];

  //Dropdown
  Color dropdownTextColor = Colors.white;
  int _currentCat = -1;
  int filterNumb = 0;
  int categoryNumber = 5;
  bool buttonPressed = false;
  var cannaIcon;
  FilterTabs selectedTab = FilterTabs.All;
  var nproducs;
  Future _setProducts;

  String finalDate = '';
  String dateName;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  getCurrentDate() {
    var date = new DateTime.now();

    print("weekday is ${date.weekday}");

    switch (date.weekday) {
      case 1:
        setState(() {
          dateName = 'Monday';
        });
        break;
      case 2:
        setState(() {
          dateName = 'Tuesday';
        });
        break;
      case 3:
        setState(() {
          dateName = 'Wednesday';
        });
        break;
      case 4:
        setState(() {
          dateName = 'Thursday';
        });
        break;
      case 5:
        setState(() {
          dateName = 'Friday';
        });
        break;
      case 6:
        setState(() {
          dateName = 'Saturday';
        });
        break;
      case 7:
        setState(() {
          dateName = 'Sunday';
        });
        break;

      default:
    }
  }

  void _handleTabSelection() {
    setState(() {
      widget.colorVal = 0xff3f51b5;
      filterNumb = _tabController.index;

      print(_tabController.index);
    });
  }

  void priceSort(List list) {
    list.sort((a, b) => _priceSorted ? a.compareTo(b) : b.compareTo(a));
    _priceSorted = !_priceSorted;
  }

  _changedDropDownItem(int newValue) {
    setState(() {
      selectedTab = FilterTabs.values[newValue];

      _currentCat = -1;
    });
    _fabShown(newValue);
  }

  void _fabShown(tab) {
    if (tab == 0) {
      setState(() {
        _showFab = true;
      });
    } else {
      _showFab = false;
    }
  }

  // int compareProductBySmallestSize(Product lhs, Product rhs) {
  //   var lhsPrice = lhs.sizes[0].price;
  //   var rhsPrice = rhs.sizes[0].price;
  //   return lhsPrice.compareTo(rhsPrice);
  // }

  // int compareProductByLargestSize(Product rhs, Product lhs) {
  //   var lhsPrice = rhs.sizes[0].price;
  //   var rhsPrice = lhs.sizes[0].price;
  //   return rhsPrice.compareTo(lhsPrice);
  // }

  // int compareTHCByLargestSize(Product rhs, Product lhs) {
  //   var lhsPrice = rhs.thcContent;
  //   var rhsPrice = lhs.thcContent;
  //   return rhsPrice.compareTo(lhsPrice);
  // }

  // int compareTHCBySmallestSize(Product lhs, Product rhs) {
  //   var lhsPrice = lhs.thcContent;
  //   var rhsPrice = rhs.thcContent;
  //   return lhsPrice.compareTo(rhsPrice);
  // }

  // int compareCBDByLargestSize(Product rhs, Product lhs) {
  //   var lhsPrice = rhs.cbdContent;
  //   var rhsPrice = lhs.cbdContent;
  //   return rhsPrice.compareTo(lhsPrice);
  // }

  // int compareCBDBySmallestSize(Product lhs, Product rhs) {
  //   var lhsPrice = lhs.cbdContent;
  //   var rhsPrice = rhs.cbdContent;
  //   return lhsPrice.compareTo(rhsPrice);
  // }

  // void _sortProductsDropDown(_fabSort, sortList) {
  //   switch (_fabSort) {
  //     case 0:
  //       print('Name Sort');
  //       break;
  //     case 1:
  //       if (_priceSorted = !_priceSorted) {
  //         setState(() {
  //           print('Sort by Lowest Price');

  //           sortList = sortList.sort(compareProductBySmallestSize);
  //         });
  //       } else {
  //         setState(() {
  //           print('Sort by Highest Price');

  //           sortList = sortList.sort(compareProductByLargestSize);
  //         });
  //       }

  //       break;
  //     case 2:
  //       setState(() {
  //         if (_thcSorted = !_thcSorted) {
  //           print('Sort By Highest Grade THC');
  //           setState(() {
  //             sortList = sortList.sort(compareTHCByLargestSize);
  //           });
  //         } else {
  //           setState(() {
  //             print('Sort By Lowest Grade THC');

  //             sortList = sortList.sort(compareTHCBySmallestSize);
  //           });
  //         }
  //       });

  //       break;
  //     case 3:
  //       setState(() {
  //         if (_cbdSorted = !_cbdSorted) {
  //           print('Sort By Highest Grade CBD');
  //           setState(() {
  //             sortList = sortList.sort(compareCBDByLargestSize);
  //           });
  //         } else {
  //           setState(() {
  //             print('Sort By Lowest Grade CBD');

  //             sortList = sortList.sort(compareCBDBySmallestSize);
  //           });
  //         }
  //       });
  //       break;
  //   }
  // }

  //Drop down

  List<ProductsInHeading> _getProductsInHeadings(List<Products> items) {
    switch (selectedTab) {
      case FilterTabs.All:
        return TabCategories.all
            .map((e) => ProductsInHeading(e, items))
            .toList();
        break;

      // case FilterTabs.Type:
      //   // usage might be wrong, I'm not sure
      //   final Map<String, List<Products>> allTypes =
      //       Map.fromEntries(TabCategories.type.map((e) => MapEntry(e, [])));

      //   Map<String, List<Products>> headingItems =
      //       items.fold(allTypes, (type, element) {
      //     if (!type.containsKey(element.type)) {
      //       return type;
      //     }

      //     return type..update(element.type, (value) => value..add(element));
      //   });

      //   print("Relief headingItems: $headingItems");
      //   return headingItems.entries
      //       .map((e) => ProductsInHeading(e.key, e.value..sort()))
      //       .toList()
      //     ..sort();
      //   break;
      // case FilterTabs.Categories:
      //   // usage might be wrong, I'm not sure
      //   final Map<String, List<Products>> allCategories =
      //       Map.fromEntries(TabCategories.category.map((e) => MapEntry(e, [])));

      //   Map<String, List<Products>> headingItems =
      //       items.fold(allCategories, (categories, element) {
      //     if (!categories.containsKey(element.category)) {
      //       return categories;
      //     }

      //     return categories
      //       ..update(element.category, (value) => value..add(element));
      //   });

      //   print("Category headingItems: $headingItems");

      //   return headingItems.entries
      //       .map((e) => ProductsInHeading(e.key, e.value..sort()))
      //       .toList()
      //     ..sort()
      //     ..where((e) => e.products.length != 0);
      //   break;

      // case FilterTabs.Usage:
      //   final Map<String, List<Products>> allUsage =
      //       Map.fromEntries(TabCategories.usage.map((e) => MapEntry(e, [])));

      //   Map<String, List<Products>> headingItems =
      //       items.fold(allUsage, (usage, element) {
      //     if (!usage.containsKey(element.usage)) {
      //       return usage;
      //     }

      //     return usage..update(element.usage, (value) => value..add(element));
      //   });
      //   print("headingItems: $headingItems");

      //   return headingItems.entries
      //       .map((e) => ProductsInHeading(e.key, e.value..sort()))
      //       .toList()
      //     ..sort()
      //     ..where((e) => e.products.length != 0);
      //   break;
    }
    throw UnsupportedError("Unsupported tab type");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    filteredProducts = products;
    currentProducts = products;
    var productsInHeadings = _getProductsInHeadings(filteredProducts)
        .where((e) => e.products.length != 0)
        .toList();
    return Scaffold(
      body: Container(
          child: DefaultTabController(
        length: _tabDetails.length,
        child: NestedScrollView(
            // physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 8,
                  backgroundColor: Colors.black,
                  expandedHeight: screenAwareSize(200, context),
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.all(4.0),
                      stretchModes: [StretchMode.blurBackground],
                      centerTitle: true,
                      collapseMode: CollapseMode.parallax,
                      title: Card(
                        elevation: 8,
                        color: Colors.white.withOpacity(.85),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Choice Drop',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextSpan(
                                  text: '\nPure Alkaline Water',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      background: Image.asset(
                        'assets/cdVan.png',
                        fit: BoxFit.fill,
                      )),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(TabBar(
                    isScrollable: false,
                    onTap: _changedDropDownItem,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                    ),
                    tabs: const [
                      Tab(
                          icon: Icon(
                            FontAwesomeIcons.home,
                          ),
                          text: "All"),
                      // Tab(
                      //     icon: Icon(FontAwesomeIcons.handHoldingMedical),
                      //     text: "Categories"),
                      // Tab(
                      //   icon: Icon(FontAwesomeIcons.clipboardList),
                      //   text: "Type",
                      // ),
                      // Tab(icon: Icon(FontAwesomeIcons.home), text: "Usage"),
                    ],
                  )),
                  pinned: true,
                ),
              ];
            },
            body: _bodyWidget(productsInHeadings, products)),
      )),
    );
  }

  void _getShippingIndicator(shipType) {
    setState(() {
      switch (shipType) {
        case 'Standard':
          _shippingIconNum = 0;
          break;
        case 'Drop':
          _shippingIconNum = 1;
          break;
        case 'Both':
          _shippingIconNum = 2;
          break;
        default:
      }
    });
  }

  Widget _bodyWidget(productsInHeadings, snapshot) {
    final theme = Theme.of(context);

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: _subSort(productsInHeadings, theme)),
          ),
          Expanded(
            flex: 9,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _currentCat != -1 ? 1 : productsInHeadings.length,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                currentProducts = snapshot;
                var headingTitle = _tabDetails[selectedTab.index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CategoryAndProducts(
                    productsInHeading: _currentCat != -1
                        ? productsInHeadings[_currentCat]
                        : productsInHeadings[index],
                    showHeading: selectedTab != FilterTabs.All,
                    starCount: starCount,
                    filterNum: _currentCat,
                    currentIndex: headingTitle,
                    context: context,
                  ),
                );
              },
            ),
          ),
        ]));
  }

  Widget _subSort(sortList, theme) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _tabDetails[selectedTab.index],
            style: TextStyle(
                fontFamily: theme.textTheme.headline4.fontFamily,
                color: theme.textTheme.headline4.color,
                fontSize: theme.textTheme.headline4.fontSize),
          ),
          Center(
            child: Container(
              height: screenAwareSize(65, context),
              color: Colors.transparent,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: sortList.length,
                  itemBuilder: (context, i) {
                    return _subSortTiles(sortList, i);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subSortTiles(sortList, i) {
    return Container(
      child: InkWell(
        onTap: () {
          setState(() {
            buttonPressed == false
                ? buttonPressed = true
                : buttonPressed = false;
            _resetBtn(buttonPressed, i);
          });
        },
        child: _chipWidget(sortList, i),
      ),
    );
  }

  Widget _chipWidget(sortList, i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        label: Text(
          sortList[i].heading,
          style: TextStyle(
              color: _currentCat != i ? Colors.white : Colors.black,
              fontFamily: 'Roboto-Regular'),
        ),
        backgroundColor: _currentCat != i ? Colors.black : Colors.yellow,
      ),
    );
  }

  void _resetBtn(buttonPressed, i) {
    switch (buttonPressed) {
      case true:
        print('unselected');

        _currentCat = i;
        break;

      case false:
        print('selected');
        _currentCat = i;
        break;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// class DataSearch extends SearchDelegate<String> {
//   DataSearch();
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(FontAwesomeIcons.backspace),
//           onPressed: () {
//             query = "";
//           })
//     ];
//     //Navigate with data
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     //Build icon
//     return IconButton(
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // return
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty
//         ? currentProducts
//         : currentProducts
//             .where((p) => p.name.toLowerCase().startsWith(query) ? true : false)
//             .toList();

//     return ListView.builder(
//       itemBuilder: (context, i) => ListTile(
//           leading: Icon(FontAwesomeIcons.cannabis),
//           title: GestureDetector(
//             onTap: () {
//               fromPreRec = false;
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SelectedProduct(
//                           product: currentProducts[i],
//                           dispensary: selectedDispensary)));
//             },
//             child: Text(suggestionList[i].name,
//                 style: TextStyle(
//                   color: Colors.grey,
//                 )),
//           )),
//       itemCount: suggestionList.length,
//     );
//   }
// }
