import 'package:basic_banking_app/components/card/atmCard.dart';

import 'package:basic_banking_app/components/transactionHistory/transactionHistory.dart';
import 'package:basic_banking_app/constants/constants.dart';
import 'package:basic_banking_app/constants/data/cardData.dart';
import 'package:basic_banking_app/database/databaseHelper.dart';
import 'package:basic_banking_app/screens/addCardDetails.dart';

import 'package:basic_banking_app/screens/transferMoney.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _dbhelper = new DatabaseHelper();
  String userName = "Hello! ";

  DateTime currentTime = DateTime.now();

  List<CardData> _list;

  int current = 0;
  List datas = [
    "Money Transfer",
  ];

  // Handling indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  void initState() {
    _list = CardData.cardDataList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('My Bank'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: mgBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                ],
              ),
            ),
            SizedBox(height: 20),

            //<<<<<<<<<<< ATM Card Section >>>>>>>>>>>>>>//
            Container(
              height: 199,
              child: FutureBuilder(
                initialData: [],
                future: _dbhelper.getUserDetails(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: mgDefaultPadding, right: 6),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => {
                                userName = snapshot.data[index].userName,
                              });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TransferMoney(
                                currentBalance:
                                    snapshot.data[index].totalAmount,
                                currentCustomerId: snapshot.data[index].id,
                                currentUserCardNumebr:
                                    snapshot.data[index].cardNumber,
                                senderName: snapshot.data[index].userName,
                              ),
                            ),
                          );
                        },
                        child: UserATMCard(
                          cardNumber: snapshot.data[index].cardNumber,
                          cardExpiryDate: snapshot.data[index].cardExpiry,
                          totalAmount: snapshot.data[index].totalAmount,
                          gradientColor: _list[index].mgPrimaryGradient,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // <<<<<<<<< Transaction Section >>>>>>>>>>>> //
            Padding(
              padding: const EdgeInsets.only(
                  left: mgDefaultPadding,
                  bottom: 13,
                  top: 29,
                  right: mgDefaultPadding),
              child: Text(
                "Transaction History",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

            Container(
              child: FutureBuilder(
                initialData: [],
                future: _dbhelper.getTransectionDetatils(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: mgDefaultPadding),
                    itemBuilder: (context, index) {
                      return TransactionHistroy(
                        isTransfer: true,
                        customerName: snapshot.data[index].userName,
                        transferAmount: snapshot.data[index].transectionAmount,
                        senderName: snapshot.data[index].senderName,
                        avatar: snapshot.data[index].userName[0],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[700],
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOutCubic);
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, animationTime) {
                    return AddCardDetails();
                  }));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
