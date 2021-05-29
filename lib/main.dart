import 'dart:convert';
import 'package:aursunao/pages/homepage.dart';
import 'package:aursunao/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

const String auth0_domain = 'dev-7dy1ffib.us.auth0.com';
const String auth0_client_id = '03RgsbKVdc5LtEpJpq1b92pc8jkGnDOh';

const String auth0_redirect_uri = 'com.auth0.aursunao://login-callback';
const String auth0_issuer = 'https://$auth0_domain';

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blue, width: 4),
                // shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await loginAction();
              },
              child: Text(
                "Login to AurSunao",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(loginError),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  String name = '';
  String picture = '';
  String userid = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aur Sunao',
      theme: ThemeData(
          // scaffoldBackgroundColor: Colors.deepPurple[100],
          scaffoldBackgroundColor: Colors.white70,
          primarySwatch: Colors.deepPurple,
          fontFamily: "NotoSans"),
      home: Scaffold(
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
                  ? AppHome(
                      name: name, picture: picture, logoutAction: logoutAction)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://$auth0_domain/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          auth0_client_id,
          auth0_redirect_uri,
          issuer: 'https://$auth0_domain',
          scopes: <String>['openid', 'profile', 'offline_access'],
        ),
      );

      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await getUserDetails(result.accessToken);
      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        userid = idToken['sub'].toString();
        name = idToken['name'].toString();
        picture = profile['picture'].toString();
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final TokenResponse response = await appAuth.token(TokenRequest(
        auth0_client_id,
        auth0_redirect_uri,
        issuer: auth0_issuer,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, Object> idToken = parseIdToken(response.idToken);
      final Map<String, Object> profile =
          await getUserDetails(response.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        userid = idToken['sub'].toString();
        name = idToken['name'].toString();
        picture = profile['picture'].toString();
      });
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }
}

class AppHome extends StatefulWidget {
  final String name;
  final String picture;
  final Function logoutAction;
  // final String title;

  const AppHome(
      {Key? key,
      required this.name,
      required this.picture,
      required this.logoutAction})
      : super(key: key);
  // AppHome({Key? key, required this.title}) : super(key: key);

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.menu_rounded),
      //   centerTitle: true,
      //   title: Text(
      //     widget.title,
      //     style: TextStyle(
      //       fontFamily: 'Chewy',
      //       fontSize: 30,
      //     ),
      //   ),
      // ),
      body: Stack(
        children: <Widget>[
          HomePage(),
          SideBar(
            name: widget.name,
            picture: widget.picture,
            logoutAction: widget.logoutAction,
          ),
        ],
      ),
    );
  }
}
