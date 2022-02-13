import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:project_bouquet_delivery/productpurchase.dart';
import 'billpage.dart';
import 'prdetailspage.dart';
import 'loginpage.dart';
import 'model/config.dart';
import 'model/product.dart';
import 'model/user.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late User user = widget.user;
  List productlist = [];
  String titlecenter = "Loading Cart...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numprd = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      body: productlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    controller: _scrollController,
                    children: List.generate(scrollcount, (index) {
                      return Card(
                          child: InkWell(
                        onTap: () => {_prodDetails(index)},
                        child: Column(
                          children: [
                            Flexible(
                              flex: 6,
                              child: CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl: MyConfig.server +
                                    productlist[index]['cartprimg'],
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          truncateString(productlist[index]
                                                  ['cartprname']
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: resWidth * 0.045,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "RM " +
                                              double.parse(productlist[index]
                                                      ['cartprprice'])
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: resWidth * 0.03,
                                          )),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ));
                    }),
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.user.email == 'na') ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                minimumSize: const Size(200, 30),
                maximumSize: const Size(200, 30),
              ),
              onPressed: () {
                _loginDialog();
              },
              icon: const Icon(Icons.person, size: 20),
              label: const Text("Log in"),
            ),
          ] else if (titlecenter == "Your cart is empty")
            ...[]
          else ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                minimumSize: const Size(200, 30),
                maximumSize: const Size(200, 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BillPage(
                      user: user,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart, size: 20),
              label: const Text("CHECKOUT"),
            ),
          ],
        ],
      ),
    );
  }

  _navigateMainPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Go to Prodcut Page",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Productlist(
                      user: user,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _loadCart() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
        Fluttertoast.showToast(
            msg: "Please log in to view your cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: 14.0);
      });
      return;
    } else {
      String? _email = widget.user.email;
      http.post(Uri.parse(MyConfig.server + "/lab3/loadcartproduct.php"),
          body: {
            "cartemail": _email,
          }).then((response) {
        var data = jsonDecode(response.body);
        print(data);
        if (response.statusCode == 200 && data['status'] == 'success') {
          print(response.body);
          var extractdata = data['data'];
          setState(() {
            productlist = extractdata["products"];
            numprd = productlist.length;
            if (scrollcount >= productlist.length) {
              scrollcount = productlist.length;
            }
          });
        } else {
          setState(() {
            titlecenter = "Your cart is empty";
          });
        }
      });
    }
  }

  void _loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Go to Login Page",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _prodDetails(int index) {
    Product product = Product(
      prid: productlist[index]['prid'],
      primg: productlist[index]['primg'],
      prname: productlist[index]['prname'],
      prdesc: productlist[index]['prdesc'],
      prprice: productlist[index]['prprice'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailsPage(
                  product: product,
                  user: user,
                )));
  }

  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }
}
