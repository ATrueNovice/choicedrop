import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/SelectedProductPage/SelectedProduct.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:choicedrop/StoreHome/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
//Key
  final _homePagehomeScaffoldKey = new GlobalKey<_HomeScreen>();
  Future _setDispensaries;

  bool flipped = false;
//Location
  dynamic products;

  @override
  void initState() {
    //Flip Animation
    // _fbstart();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: APIS.getProducts(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    products = snapshot.data;
                    pOrders = snapshot.data;
                    return _buildSelectionOptions(snapshot.data, themeData);
                  }
              }
            }),
      ),
    );
  }

  Widget _buildSelectionOptions(products, theme) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topBar(),
          SizedBox(
            height: screenAwareSize(15, context),
            width: screenAwareSize(15, context),
          ),
          _buildVendors(products, theme),
          SizedBox(
            height: screenAwareSize(15, context),
            width: screenAwareSize(15, context),
          ),
          _buildCoupon(),
          SizedBox(
            height: screenAwareSize(20, context),
            width: screenAwareSize(15, context),
          ),
          _buildDeals(products, theme)
        ]);
  }

  Widget _topBar() {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 1.75),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 20 + kDefaultPadding,
            ),
            height: MediaQuery.of(context).size.height * 0.25 - 15,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Choice Drop',
                  style: TextStyle(
                      fontSize: screenAwareSize(25, context),
                      fontFamily: 'Roboto-Regular',
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: screenAwareSize(50, context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.blue.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onTap: () {
                        showSearch(context: context, delegate: DataSearch());
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.blue.withOpacity(0.5),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // surffix isn't working properly  with SVG
                        // thats why we use row
                        // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                      ),
                    ),
                  ),
                  // SvgPicture.asset("assets/icons/search.svg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sponsoredDispensary(dispensaries, theme) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Text(
                'Check Out Our Buddies!',
                style: TextStyle(
                    fontFamily: theme.textTheme.headline1.fontFamily,
                    color: theme.textTheme.headline1.color,
                    fontSize: theme.textTheme.headline1.fontSize),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 15.0),
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dispensaries.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    _navigtorFunc(dispensaries[i], context);
                  },

                  //Time issue
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            width: screenAwareSize(200, context),
                            height: screenAwareSize(150, context),
                            // decoration: BoxDecoration(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(18)),
                            //   image: DecorationImage(
                            //       fit: BoxFit.fill,
                            //       image: dispensaries != null
                            //           ? NetworkImage(
                            //               dispensaries[i].dispensaryPhoto,
                            //             )
                            //           : const CircularProgressIndicator()),
                            // ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            dispensaries[i].name,
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headline2.fontFamily,
                                color: theme.textTheme.headline2.color,
                                fontSize: theme.textTheme.headline2.fontSize),
                          ),
                          Text(
                            '${dispensaries[i].address}',
                            style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headline5.fontFamily,
                                color: theme.textTheme.headline5.color,
                                fontSize: theme.textTheme.headline5.fontSize),
                          ),
                        ],
                      ),
                    ]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _navigtorFunc(dispensary, context) {
    // if (hasProfile == true) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               DispensaryHome(dispensary: dispensary, id: dispensary.id)));
    // } else {
    //   _noProfilePopup();

    //   // Navigator.push(
    //   //     context, MaterialPageRoute(builder: (context) => ProfileDetails()));
    // }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: new Text(
            "You Get An 10% Off Your Next Full Order",
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            "When You Take A Selfie With Your Purchase And @ Us On Social Media!",
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildCoupon() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: RaisedButton(
          color: Colors.orange[300],
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onPressed: () {
            _showDialog();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(FontAwesomeIcons.tag, color: Colors.black),
                  radius: screenAwareSize(30, context),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Hey Bud, Here Is A Discount',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      )),
                  Text(
                    'Take 10% Off Your Next Order',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular', color: Colors.white),
                  )
                ],
              ),
              Icon(FontAwesomeIcons.angleRight, color: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendors(products, theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Best Sellers',
              style: TextStyle(
                  fontFamily: theme.textTheme.headline1.fontFamily,
                  color: theme.textTheme.headline1.color,
                  fontSize: theme.textTheme.headline1.fontSize),
            ),
            MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreHome(
                              products: products,
                            )));
              },
              child: Text(
                'More',
                style: TextStyle(
                    fontFamily: theme.textTheme.headline3.fontFamily,
                    color: theme.textTheme.subtitle2.color,
                    fontSize: theme.textTheme.headline3.fontSize),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
      Container(
          padding: EdgeInsets.only(top: 10.0, left: 15.0),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              final product = products[i];

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectedProduct(
                                product: product,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 28.0),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(children: <Widget>[
                      Container(
                        width: screenAwareSize(175, context),
                        height: screenAwareSize(125, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(product.productImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              product.productName,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.headline4.fontFamily,
                                  color: theme.textTheme.headline4.color,
                                  fontSize: theme.textTheme.headline4.fontSize),
                            ),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyText2.fontFamily,
                                  color: theme.textTheme.bodyText2.color,
                                  fontSize: theme.textTheme.bodyText2.fontSize),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ))
    ]);
  }

  Widget _buildDeals(products, theme) {
    var bestProducts =
        products.where((e) => e.category == 'Water Coolers').toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Best Value',
              style: TextStyle(
                  fontFamily: theme.textTheme.headline1.fontFamily,
                  color: theme.textTheme.headline1.color,
                  fontSize: theme.textTheme.headline2.fontSize),
            ),
            MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreHome(
                              products: products,
                            )));
              },
              child: Text(
                'More',
                style: TextStyle(
                    fontFamily: theme.textTheme.headline3.fontFamily,
                    color: theme.textTheme.subtitle2.color,
                    fontSize: theme.textTheme.headline3.fontSize),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
      Container(
          padding: EdgeInsets.only(top: 10.0, left: 10.0),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: bestProducts.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              final product = bestProducts[i];

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectedProduct(
                                product: product,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(children: <Widget>[
                      Container(
                        width: screenAwareSize(200, context),
                        height: screenAwareSize(125, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(product.productImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              product.productName,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.headline4.fontFamily,
                                  color: theme.textTheme.headline4.color,
                                  fontSize: theme.textTheme.headline4.fontSize),
                            ),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyText2.fontFamily,
                                  color: theme.textTheme.bodyText2.color,
                                  fontSize: theme.textTheme.bodyText2.fontSize),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ))
    ]);
  }
}

class DataSearch extends SearchDelegate<String> {
  DataSearch();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(FontAwesomeIcons.backspace),
          onPressed: () {
            query = "";
          })
    ];
    //Navigate with data
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Build icon
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  Widget buildResults(BuildContext context) {
    // return
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? pOrders
        : pOrders
            .where((p) =>
                p.productName.toLowerCase().startsWith(query) ? true : false)
            .toList();

    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
          // leading: Icon(FontAwesomeIcons.water),
          title: GestureDetector(
        onTap: () {
          final prod = suggestionList[i];
          _navigtorFunc(prod, context);
        },
        child: Text(suggestionList[i].productName,
            style: TextStyle(
              color: Colors.grey,
            )),
      )),
      itemCount: suggestionList.length,
    );
  }

  void _navigtorFunc(products, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectedProduct(product: products)));
  }
}
