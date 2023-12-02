import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchInput(
      {super.key, required this.searchController, required this.onSearch});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchInput();
  }
}

class _SearchInput extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 50),
        padding: EdgeInsets.only(left: 5, top: 5, right: 20, bottom: 00),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration.collapsed(
                      hintText: "Search by City Name"),
                  onSubmitted: (String city) {
                    widget.onSearch(city);
                  }),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                widget.onSearch(widget.searchController.text);
              },
            ),
          ],
        ));
  }
}
