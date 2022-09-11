import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/components/animated_search_bar.dart';
import 'package:amir_optic/components/change_locale_button.dart';
import 'package:amir_optic/components/client_tile.dart';
import 'package:amir_optic/components/loading_indicator.dart';
import 'package:amir_optic/classes/chosen_client.dart';
import 'package:amir_optic/constants/constants.dart';
import 'package:amir_optic/models/client.dart';
import 'package:amir_optic/screens/clients/client_page.dart';
import 'package:amir_optic/screens/clients/add_client_page.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

enum SearchBy {
  id,
  phone,
  name,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchBarController;
  SearchBy searchBy = SearchBy.name;
  bool filterFolderOpen = false;

  @override
  void initState() {
    _searchBarController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (!sizingInformation.isDesktop) {
        kIsSplitedScreen = false;
        return buildSmallScreenBody();
      }

      kIsSplitedScreen = true;
      return buildBigScreebBody();
    });
  }

  Widget buildSmallScreenBody() {
    var homePageNavigatorKey =
        Provider.of<NavigatorsKeys>(context, listen: false)
            .homePageNavigatorKey(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.clients.tr(),
        ),
        leading: IconButton(
            onPressed: () {
              showDialog<void>(
                useRootNavigator: true,
                context: homePageNavigatorKey.currentState!.context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CycleThemeIconButton(),
                              const ChangeLocaleButton(),
                              IconButton(
                                  tooltip: "Sign Out",
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                  },
                                  icon: const Icon(Icons.logout))
                            ]);
                      },
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.settings)),
        actions: [
          PopupMenuButton<SearchBy>(
            icon: const Icon(Icons.filter_alt_rounded),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SearchBy.name,
                child: Text(LocaleKeys.name.tr()),
              ),
              PopupMenuItem(
                value: SearchBy.phone,
                child: Text(LocaleKeys.phone_number.tr()),
              ),
              PopupMenuItem(
                value: SearchBy.id,
                child: Text(LocaleKeys.id.tr()),
              ),
            ],
            onSelected: (value) {
              setState(() {
                searchBy = value;
              });
            },
          ),
        ],
      ),
      body: _smallScreenBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(homePageNavigatorKey.currentState!.context)
              .push(MaterialPageRoute(
            builder: (context) => const AddClientPage(),
          ));
        },
        label: Text(
          LocaleKeys.add_client.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildBigScreebBody() {
    var navigatorsKeys = Provider.of<NavigatorsKeys>(context, listen: false);

    Widget homePage = buildSmallScreenBody();
    Widget clientsPage = Consumer<ChosenClient>(
        builder: (context, chosenClient, child) => chosenClient
                    .selectedClient ==
                null
            ? Scaffold(
                body: Center(child: Text(LocaleKeys.please_choose_client.tr())))
            : ClientPage(
                client: Client(
                  address: chosenClient.selectedClient!.address,
                  firstName: chosenClient.selectedClient!.firstName,
                  lastName: chosenClient.selectedClient!.lastName,
                  comments: chosenClient.selectedClient!.comments,
                  hmo: chosenClient.selectedClient!.hmo,
                  id: chosenClient.selectedClient!.id,
                  phoneNumbers: chosenClient.selectedClient!.phoneNumbers,
                  uid: chosenClient.selectedClient!.uid,
                ),
              ));

    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 1,
          child: Navigator(
            key: navigatorsKeys.homePageNavigatorKey(context),
            pages: [
              MaterialPage(child: homePage),
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
        Flexible(
          flex: 1,
          child: Navigator(
            key: navigatorsKeys.clientPageNavigatorKey(context),
            pages: [MaterialPage(child: clientsPage)],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _smallScreenBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.2,
          ),
          Center(
            child: Text(
              LocaleKeys.clients_searching.tr(),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.amber,
                  ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AnimatedSearchBar(
            textEditingController: _searchBarController,
            onSubmitted: (p0) {
              setState(() {});
            },
            onCloseButton: () {
              setState(() {});
            },
          ),
          const SizedBox(
            height: 40,
          ),
          // The founded users
          _clientsList()
        ],
      ),
    );
  }

  Widget _clientsList() {
    if (_searchBarController.text.isEmpty) {
      return Container();
    }

    late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
    late String noClientsError;

    switch (searchBy) {  
      case SearchBy.name:


        String firstName;
        String lastName;
         firstName = _searchBarController.text.split(" ")[0];
        try{
          lastName =  _searchBarController.text.split(" ")[1];
        } on RangeError{
          lastName = "";
        }
        

        _stream = OnlineDBSerivce.getClientsByNameSnapshots(
            firstName, lastName);
        noClientsError =
            "${LocaleKeys.no_clients_for_name.tr()} ${_searchBarController.text}!";
        break;
      case SearchBy.phone:
        _stream = OnlineDBSerivce.getClientsByPhoneNumbersSnapshots(
            _searchBarController.text);
        noClientsError =
            "${LocaleKeys.no_clients_for_phone.tr()} ${_searchBarController.text}!";

        break;
      case SearchBy.id:
        _stream =
            OnlineDBSerivce.getClientsByIdSnapshots(_searchBarController.text);
        noClientsError =
            "${LocaleKeys.no_clients_for_id.tr()} ${_searchBarController.text}!";

        break;

      default:
        throw Exception("Unkown search by!");
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        var size = MediaQuery.of(context).size;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator(
            title: LocaleKeys.loading_clients.tr(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text(
            noClientsError,
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          );
        }

        return SizedBox(
          width: size.width,
          height: size.height * 0.4,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ClientTile(
                client:
                    Client.fromMap(snapshot.data!.docs.elementAt(index).data()),
              );
            },
          ),
        );
      },
    );
  }
}
