import 'package:final_project_note_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  UserProvider? _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initializing the UserProvider to avoid repeated calls
    _userProvider ??= Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Start listening for the user's authentication state after 3 seconds as defined in UserProvider
        _userProvider!.startAuthListener(context: context);
      }
    });
  }

  @override
  void dispose() {
    // Stop listening for changes when the screen is disposed
    _userProvider!.stopAuthListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade500, Colors.black],
            begin: AlignmentDirectional.centerEnd,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height / 2.5),
            SizedBox(
              width: double.infinity,
              height: 170,
              child: SvgPicture.asset(
                'images/gummy-notebook.svg',  // Assuming this is a logo or illustration
                width: 200,
                height: 200,
              ),
            ),
            Spacer(),
            CircularProgressIndicator(
              color: Colors.white,
              constraints: BoxConstraints(minHeight: 20, minWidth: 20),
              strokeWidth: 3,
            ),
            SizedBox(height: 10),
            // You can add text like "Please wait..." or any relevant information if necessary
            Text(
              S.of(context).pleaseWait, // Translation for the text
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
