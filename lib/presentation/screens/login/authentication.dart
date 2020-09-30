import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duit_yourself/common/constants/key_cache_constant.dart';
import 'package:duit_yourself/main_route.dart';
import 'package:duit_yourself/presentation/widgets/screen_layouts/menu/bloc/menu_bloc.dart';
import 'package:simple_cache/simple_cache.dart';
import '../../../common/config/injector.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'login_screen.dart';

class Authentications extends StatefulWidget {
  Authentications({Key key}) : super(key: key);

  @override
  State<Authentications> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentications> {
  AuthenticationBloc authenticationBloc;
  SimpleCache simpleCache;
  String cacheData;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    getCacheData();
    if (mounted) {
      authenticationBloc.add(AppStarted());
    }
  }

  @override
  void didUpdateWidget(Authentications oldWidget) {
    super.didUpdateWidget(oldWidget);
    getCacheData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void screenInit(BuildContext context) {
    final query = MediaQuery.of(context).size;
    ScreenUtil.init(context,
        width: query.width, height: query.height, allowFontScaling: true);
  }

  Future getCacheData() async {
    simpleCache = await SimpleCache.getInstance();
    setState(() {
      cacheData = simpleCache.getString(KeyCacheConstants.cacheUsernameKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenInit(context);
    return BlocListener(
      bloc: authenticationBloc,
      listener: (BuildContext context, AuthenticationState state) {
        // if (state is Unauthorized) {
        //   authenticationBloc.add(LoginDenied());
        //   showDialogAlert(context);
        // }
      },
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // if (state is Authenticated) {

          //  MaterialPageRoute(builder: (_)=>MaterialApp(home: Container(color: Blue.darkBlue, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,),));
          // }
        },
        builder: (BuildContext context, AuthenticationState state) {
          if (state is Unauthorized) {
            return LoginScreen();
          }
          if (state is Unauthenticated) {
            if (cacheData != null) {
              return Center(child: CircularProgressIndicator());
            }
            return LoginScreen();
          }
          if (state is Authenticated) {
            return BlocProvider<MenuBloc>(
              create: (BuildContext context) => getIt<MenuBloc>(),
              child: MainRoute(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
