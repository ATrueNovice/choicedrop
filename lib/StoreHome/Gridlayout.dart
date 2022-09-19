import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/SelectedProductPage/SelectedProduct.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CategoryAndProducts extends StatelessWidget {
  final productsInHeading;
  final bool showHeading;
  final int starCount;
  final dynamic currentIndex;
  final dynamic filterNum;
  final dynamic context;

  const CategoryAndProducts(
      {Key key,
      this.productsInHeading,
      this.showHeading,
      this.starCount,
      this.currentIndex,
      this.context,
      this.filterNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      width: itemWidth,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                productsInHeading.heading == "All"
                    ? ''
                    : productsInHeading.heading,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: theme.textTheme.headline3.color,
                    fontSize: theme.textTheme.headline3.fontSize),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.25,
              child: GridView.builder(
                dragStartBehavior: DragStartBehavior.down,
                itemCount: filterNum != -1
                    ? productsInHeading.products.length
                    : productsInHeading.products.length,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 2,
                  childAspectRatio: .5,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  var productMenu = productsInHeading.products;

                  return InkWell(
                    onTap: () {
                      // APIS().getProductSizes(size).then((value))

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectedProduct(
                                    product: productMenu[i],
                                  )));

                      // fromPreRec = false;
                    },
                    child: _buildProductList(
                        productMenu[i].productName,
                        productMenu[i].productImage,
                        productMenu[i].usage,
                        productMenu[i].type,
                        productMenu[i].minimumQuantity,
                        productMenu[i].rating,
                        productMenu[i].prices[0],
                        theme),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget _buildProductList(
      name, image, usage, type, quantity, rating, price, theme) {
    return _productDetailWidget(
        name, image, usage, type, quantity, rating, price, theme);
  }

  Widget _productDetailWidget(
      name, image, usage, type, quantity, rating, price, theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: FadeInImage(
            width: MediaQuery.of(context).size.width,
            height: 125,
            image: NetworkImage(image),
            fit: BoxFit.fill,
            placeholder: const AssetImage('assets/cdLogo.png'),
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                fontFamily: theme.textTheme.headline5.fontFamily,
                color: theme.textTheme.headline5.color,
                fontSize: theme.textTheme.headline5.fontSize),
          ),
        ),
        SizedBox(
          height: screenAwareSize(10, context),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: screenAwareSize(5, context),
                ),
              ],
            ),
            Text(
              'Type: ' + type,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: theme.textTheme.subtitle2.fontFamily,
                  color: theme.textTheme.headline5.color,
                  fontSize: theme.textTheme.subtitle1.fontSize),
            ),
            SizedBox(
              height: screenAwareSize(5, context),
            ),
            Text(
              'Starting At: \$$price',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: theme.textTheme.subtitle2.fontFamily,
                  color: theme.textTheme.headline5.color,
                  fontSize: theme.textTheme.subtitle1.fontSize),
            ),
            SizedBox(
              height: screenAwareSize(5, context),
            ),
            StarRating(
              size: 18.0,
              rating: double.parse(rating),
              color: Colors.orange,
              borderColor: Colors.grey,
              starCount: starCount,
            ),
          ],
        ),
      ],
    );
  }
}
