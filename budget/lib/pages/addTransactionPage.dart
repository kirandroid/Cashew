import 'package:budget/functions.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/textInput.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/transactionEntry.dart';
import 'package:budget/struct/transactionCategory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:budget/colors.dart';
import 'package:math_expressions/math_expressions.dart';

//TODO
//only show the tags that correspond to selected category
//put recent used tags at the top? when no category selected

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TransactionCategory? selectedCategory;
  double? selectedAmount;
  String? selectedAmountCalculation;

  void setSelectedCategory(TransactionCategory category) {
    setState(() {
      selectedCategory = category;
    });
    return;
  }

  void setSelectedAmount(double amount, String amountCalculation) {
    setState(() {
      selectedAmount = amount;
      selectedAmountCalculation = amountCalculation;
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      openBottomSheet(
        context,
        PopupFramework(
          title: "Select Category",
          child: SelectCategory(
            setSelectedCategory: setSelectedCategory,
            setSelectedAmount: setSelectedAmount,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: Container(),
                backgroundColor: Colors.black,
                floating: false,
                pinned: true,
                expandedHeight: 200.0,
                collapsedHeight: 65,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                  title: TextFont(
                    text: "Add Transaction",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CategoryIcon(
                            category: selectedCategory,
                            size: 50,
                            onTap: () {
                              openBottomSheet(
                                context,
                                PopupFramework(
                                  title: "Select Category",
                                  child: SelectCategory(
                                    setSelectedCategory: setSelectedCategory,
                                    setSelectedAmount: setSelectedAmount,
                                    openSelectAmount: false,
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                openBottomSheet(
                                  context,
                                  PopupFramework(
                                    title: "Enter Amount",
                                    child: SelectAmount(
                                      setSelectedAmount: setSelectedAmount,
                                      amountPassed:
                                          selectedAmountCalculation ?? "",
                                    ),
                                  ),
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 20, top: 20, bottom: 20),
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 350),
                                    child: TextFont(
                                      textAlign: TextAlign.right,
                                      key: ValueKey(selectedAmount),
                                      text: convertToMoney(selectedAmount ?? 0),
                                      fontSize: 33,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextInput(
                      labelText: "Notes",
                    ),
                  ],
                ),
              ),
              SliverFillRemaining()
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: selectedCategory == null
                ? Button(
                    label: "Select Category",
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    fractionScaleHeight: 0.93,
                    fractionScaleWidth: 0.98,
                    onTap: () {
                      openBottomSheet(
                        context,
                        PopupFramework(
                          title: "Select Category",
                          child: SelectCategory(
                            setSelectedCategory: setSelectedCategory,
                            setSelectedAmount: setSelectedAmount,
                          ),
                        ),
                      );
                    },
                  )
                : selectedAmount == null
                    ? Button(
                        label: "Enter Amount",
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        fractionScaleHeight: 0.93,
                        fractionScaleWidth: 0.98,
                        onTap: () {
                          openBottomSheet(
                            context,
                            PopupFramework(
                              title: "Enter Amount",
                              child: SelectAmount(
                                  setSelectedAmount: setSelectedAmount),
                            ),
                          );
                        },
                      )
                    : Button(
                        label: "Add Transaction",
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        fractionScaleHeight: 0.93,
                        fractionScaleWidth: 0.98,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

openBottomSheet(context, child) {
  return showMaterialModalBottomSheet(
    animationCurve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 500),
    backgroundColor: Colors.transparent,
    expand: true,
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: child,
        ),
      ),
    ),
  );
}

class PopupFramework extends StatelessWidget {
  PopupFramework({Key? key, required this.child, this.title}) : super(key: key);
  final Widget child;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:
                Theme.of(context).colorScheme.lightDarkAccent.withOpacity(0.5),
          ),
        ),
        Container(height: 5),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Theme.of(context).colorScheme.lightDarkAccent,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 15),
                  title == null
                      ? Container(height: 5)
                      : TextFont(
                          text: title ?? "",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                  Container(height: 10),
                  child,
                  Container(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectCategory extends StatefulWidget {
  SelectCategory(
      {Key? key,
      required this.setSelectedCategory,
      required this.setSelectedAmount,
      this.openSelectAmount = true})
      : super(key: key);
  final Function(TransactionCategory) setSelectedCategory;
  final Function(double, String) setSelectedAmount;
  final bool openSelectAmount;

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: listCategory()
              .asMap()
              .map(
                (index, category) => MapEntry(
                  index,
                  CategoryIcon(
                    category: category,
                    size: 50,
                    label: true,
                    onTap: () {
                      widget.setSelectedCategory(category);
                      setState(() {
                        selectedIndex = index;
                      });
                      Future.delayed(Duration(milliseconds: 70), () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                        if (widget.openSelectAmount) {
                          openBottomSheet(
                            context,
                            PopupFramework(
                              title: "Enter Amount",
                              child: SelectAmount(
                                  setSelectedAmount: widget.setSelectedAmount),
                            ),
                          );
                        }
                      });
                    },
                    outline: selectedIndex == index,
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}

class SelectAmount extends StatefulWidget {
  SelectAmount(
      {Key? key, required this.setSelectedAmount, this.amountPassed = ""})
      : super(key: key);
  final Function(double, String) setSelectedAmount;
  final String amountPassed;

  @override
  _SelectAmountState createState() => _SelectAmountState();
}

class _SelectAmountState extends State<SelectAmount> {
  String amount = "";

  @override
  void initState() {
    super.initState();
    amount = widget.amountPassed;
  }

  addToAmount(String input) {
    String amountClone = amount;
    if (input == "." &&
        !decimalCheck(operationsWithSpaces(amountClone + "."))) {
    } else if (amount.length == 0 && !includesOperations(input, false)) {
      if (input == "0") {
      } else if (input == ".") {
        setState(() {
          amount += "0" + input;
        });
      } else {
        setState(() {
          amount += input;
        });
      }
    } else if ((!includesOperations(
                amount.substring(amount.length - 1), true) &&
            includesOperations(input, true)) ||
        !includesOperations(input, true)) {
      setState(() {
        amount += input;
      });
    } else if (includesOperations(amount.substring(amount.length - 1), false) &&
        input == ".") {
      setState(() {
        amount += "0" + input;
      });
    } else if (amount.substring(amount.length - 1) == "." &&
        includesOperations(input, false)) {
      setState(() {
        amount = amount.substring(0, amount.length - 1) + input;
      });
    }
    widget.setSelectedAmount(
        (amount == ""
            ? 0
            : includesOperations(amount, false)
                ? calculateResult(amount)
                : double.tryParse(amount) ?? 0),
        amount);
  }

  void removeToAmount() {
    setState(() {
      if (amount.length > 0) {
        amount = amount.substring(0, amount.length - 1);
      }
    });
    widget.setSelectedAmount(
        (amount == ""
            ? 0
            : includesOperations(amount, false)
                ? calculateResult(amount)
                : double.tryParse(amount) ?? 0),
        amount);
  }

  bool includesOperations(String input, bool includeDecimal) {
    List<String> operations = [
      "÷",
      "×",
      "-",
      "+",
      (includeDecimal ? "." : "+")
    ];
    for (String operation in operations) {
      if (input.contains(operation)) {
        print(operation);
        return true;
      }
    }
    return false;
  }

  bool decimalCheck(input) {
    var splitInputs = input.split(" ");
    for (var splitInput in splitInputs) {
      print('.'.allMatches(splitInput));
      if ('.'.allMatches(splitInput).length > 1) {
        return false;
      }
    }
    return true;
  }

  String operationsWithSpaces(String input) {
    return input
        .replaceAll("÷", " ÷ ")
        .replaceAll("×", " × ")
        .replaceAll("-", " - ")
        .replaceAll("+", " + ");
  }

  double calculateResult(input) {
    if (input == "") {
      return 0;
    }
    String changedInput = input;
    if (includesOperations(input.substring(input.length - 1), true)) {
      changedInput = input.substring(0, input.length - 1);
    }
    changedInput = changedInput.replaceAll("÷", "/");
    changedInput = changedInput.replaceAll("×", "*");
    double result = 0;
    try {
      ContextModel cm = ContextModel();
      Parser p = new Parser();
      Expression exp = p.parse(changedInput);
      result = exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {}
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: FractionallySizedBox(
                    key: ValueKey(amount),
                    widthFactor: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: TextFont(
                        text: (includesOperations(amount, false)
                            ? operationsWithSpaces(amount)
                            : ""),
                        textAlign: TextAlign.left,
                        fontSize: 18,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: FractionallySizedBox(
                    key: ValueKey(amount == ""
                        ? getCurrencyString() + "0"
                        : includesOperations(amount, false)
                            ? convertToMoney(calculateResult(amount))
                            : getCurrencyString() + amount),
                    widthFactor: 0.5,
                    child: TextFont(
                      text: amount == ""
                          ? getCurrencyString() + "0"
                          : includesOperations(amount, false)
                              ? convertToMoney(calculateResult(amount))
                              : getCurrencyString() + amount,
                      // text: amount,
                      textAlign: TextAlign.right,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      maxLines: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 10),
          Row(
            children: [
              CalculatorButton(
                label: "1",
                editAmount: () {
                  addToAmount("1");
                },
                topLeft: true,
              ),
              CalculatorButton(
                  label: "2",
                  editAmount: () {
                    addToAmount("2");
                  }),
              CalculatorButton(
                  label: "3",
                  editAmount: () {
                    addToAmount("3");
                  }),
              CalculatorButton(
                label: "÷",
                editAmount: () {
                  addToAmount("÷");
                },
                topRight: true,
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                  label: "4",
                  editAmount: () {
                    addToAmount("4");
                  }),
              CalculatorButton(
                  label: "5",
                  editAmount: () {
                    addToAmount("5");
                  }),
              CalculatorButton(
                  label: "6",
                  editAmount: () {
                    addToAmount("6");
                  }),
              CalculatorButton(
                  label: "×",
                  editAmount: () {
                    addToAmount("×");
                  }),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                  label: "7",
                  editAmount: () {
                    addToAmount("7");
                  }),
              CalculatorButton(
                  label: "8",
                  editAmount: () {
                    addToAmount("8");
                  }),
              CalculatorButton(
                  label: "9",
                  editAmount: () {
                    addToAmount("9");
                  }),
              CalculatorButton(
                  label: "-",
                  editAmount: () {
                    addToAmount("-");
                  }),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                label: ".",
                editAmount: () {
                  addToAmount(".");
                },
                bottomLeft: true,
              ),
              CalculatorButton(
                  label: "0",
                  editAmount: () {
                    addToAmount("0");
                  }),
              CalculatorButton(
                  label: "<",
                  editAmount: () {
                    removeToAmount();
                  }),
              CalculatorButton(
                label: "+",
                editAmount: () {
                  addToAmount("+");
                },
                bottomRight: true,
              ),
            ],
          ),
          Container(height: 15),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: amount != ""
                ? Button(
                    key: Key("addSuccess"),
                    label: "Add Transaction",
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    fractionScaleHeight: 0.93,
                    fractionScaleWidth: 0.91,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  )
                : Button(
                    key: Key("addNoSuccess"),
                    label: "Add Transaction",
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    fractionScaleHeight: 0.93,
                    fractionScaleWidth: 0.91,
                    onTap: () {},
                    color: Colors.grey,
                  ),
          )
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  CalculatorButton({
    Key? key,
    required this.label,
    required this.editAmount,
    this.topRight = false,
    this.topLeft = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  }) : super(key: key);
  final String label;
  final VoidCallback editAmount;
  final bool topRight;
  final bool topLeft;
  final bool bottomLeft;
  final bool bottomRight;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Theme.of(context).colorScheme.white,
        borderRadius: BorderRadius.only(
          topRight: topRight ? Radius.circular(15) : Radius.circular(0),
          topLeft: topLeft ? Radius.circular(15) : Radius.circular(0),
          bottomLeft: bottomLeft ? Radius.circular(15) : Radius.circular(0),
          bottomRight: bottomRight ? Radius.circular(15) : Radius.circular(0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topRight: topRight ? Radius.circular(15) : Radius.circular(0),
            topLeft: topLeft ? Radius.circular(15) : Radius.circular(0),
            bottomLeft: bottomLeft ? Radius.circular(15) : Radius.circular(0),
            bottomRight: bottomRight ? Radius.circular(15) : Radius.circular(0),
          ),
          onTap: editAmount,
          child: Container(
            height: 60,
            child: Center(
              child: TextFont(
                fontSize: 24,
                text: label,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectTag extends StatefulWidget {
  SelectTag({Key? key, this.setSelectedCategory}) : super(key: key);
  final Function(TransactionCategory)? setSelectedCategory;

  @override
  _SelectTagState createState() => _SelectTagState();
}

class _SelectTagState extends State<SelectTag> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: listTag()
              .asMap()
              .map(
                (index, tag) => MapEntry(
                  index,
                  TagIcon(
                    tag: tag,
                    size: 50,
                    onTap: () {},
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}
