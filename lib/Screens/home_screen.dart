import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:news_roll_out/GlobalData/globalthemeconstats.dart';
import 'package:news_roll_out/GlobalWidgets/global_widget.dart';
import 'package:news_roll_out/Screens/Widgets/shifting_tab.dart';
import 'package:news_roll_out/Screens/bloc/newscontentproviderbloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  List<String> titleList = [];
  NewscontentproviderblocBloc newsctntbloc = NewscontentproviderblocBloc();
  TabController? _shiftingTabController;
  Widget tabBar() => ShiftingTabBar(
        forceUpperCase: false,
        scrollable: false,
        labelFlex: 8,
        controller: _shiftingTabController,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        color: GlobalTheme().backgroundColor,
        tabs: <ShiftingTab>[
          ShiftingTab(
              iconpath:
                  "https://static.wikia.nocookie.net/logopedia/images/3/33/Twenty_Four_News.jpeg/revision/latest?cb=20191228092818",
              text: "Twenty Four news"),
          ShiftingTab(
              iconpath:
                  "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0015/3272/brand.gif?itok=wX2xgEld",
              text: "Manorama News"),
          ShiftingTab(
              iconpath:
                  "https://static.wikia.nocookie.net/logopedia/images/3/33/Twenty_Four_News.jpeg/revision/latest?cb=20191228092818",
              text: "Mix Matches"),
          ShiftingTab(
              iconpath:
                  "https://static.wikia.nocookie.net/logopedia/images/3/33/Twenty_Four_News.jpeg/revision/latest?cb=20191228092818",
              text: "Latest Profiles"),
        ],
      );
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _shiftingTabController?.animateTo(0);
    _shiftingTabController?.addListener(() {
      if (_shiftingTabController!.indexIsChanging) {
        if (_shiftingTabController?.index == 0)
          newsctntbloc.add(newsloaded(type: 'twenty_four'));
        else if (_shiftingTabController?.index == 1) {
          newsctntbloc.add(newsloaded(type: 'manorama'));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _shiftingTabController = TabController(length: 4, vsync: this);
    _controller = AnimationController(vsync: this);
    newsctntbloc = BlocProvider.of<NewscontentproviderblocBloc>(context);
    newsctntbloc.add(newsloaded(type: 'twenty_four'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalTheme().backgroundColor,
        //title: Text('Headlines'),
        bottom: PreferredSize(
            child: Container(
                height: kToolbarHeight,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: tabBar(),
                )),
            preferredSize: Size.fromHeight(50)),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: BlocBuilder<NewscontentproviderblocBloc,
              NewscontentproviderblocState>(
            bloc: newsctntbloc,
            builder: (context, state) {
              print(state);
              if (state is Newscontentproviderblocloaded) {
                print(state.newscontent);
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Text('24 News'),

                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              'Head Lines',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 28, 23, 23)),
                            ),
                          )),
                      Divider(thickness: .8, color: Color(0xFFE4E4E4)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: GlobalWidget().DecorativeContainer(
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                        state.newscontent[1] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(state.newscontent[0].text.trim()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Latest',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 28, 23, 23)),
                            ),
                          )),
                      Divider(thickness: .8, color: Color(0xFFE4E4E4)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.7,
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: GlobalWidget().DecorativeContainer(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(state.newscontent[3] ?? ''),
                                    Text(
                                      state.newscontent[2].text.trim() ?? '',
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 48,
                      ),
                      //Text('Malayala Manorama'),
                      // Image.network(resutimg[1] ?? ''),
                      // Text(resut[1]),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text('Mathrubumi'),
                      // // Image.network(resutimg[2]),
                      // Text(resut[2]),
                    ]);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
