import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';

class AspectCommunityList extends StatelessWidget {
  const AspectCommunityList(
      {super.key, required this.community, required this.aspect});
  final List<Community> community;
  final Aspect aspect;

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              aspect.name,
              style: titleText2,
            ),
            const SizedBox(
              width: 10,
            ),
            aspectList.getSelectedIcon(aspect.name),
          ],
        ),
        automaticallyImplyLeading: true, // need color
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        child: ListView.builder(
            itemCount: community.length,
            itemBuilder: (context, index) {
              String goalname = community[index].goalName!;
              String communityAspect = community[index].aspect!;
              var aspectList = Provider.of<AspectController>(context);
              List<Aspect> listOfaspect = aspectList.selected;
              int selsectAspectIndex = 0;
              for (int i = 0; i < listOfaspect.length; i++) {
                if (listOfaspect[i].name == communityAspect) {
                  selsectAspectIndex = i;
                }
              }

              Icon aspectIcon = Icon(
                IconData(
                  aspectList.selected[selsectAspectIndex].iconCodePoint,
                  fontFamily:
                      aspectList.selected[selsectAspectIndex].iconFontFamily,
                  fontPackage:
                      aspectList.selected[selsectAspectIndex].iconFontPackage,
                  matchTextDirection:
                      aspectList.selected[selsectAspectIndex].iconDirection,
                ),
              );
              Color aspectColor =
                  Color(aspectList.selected[selsectAspectIndex].color);

              //switch to get the colors .
              bool isAdmin = community[index].founderUserID ==
                  firebaseAuth.currentUser!.uid;
              return GestureDetector(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityHomePage(
                                fromInvite: false,
                                comm: community[index],
                              )));
                }),
                child: ListTile(
                  leading: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: aspectColor,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      aspectIcon.icon,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text('  الهدف : $goalname'),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        community[index].communityName ?? '',
                        style: const TextStyle(
                          color: kBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        community[index].isPrivate ? Icons.lock : Icons.people,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        isAdmin ? 'مشرف' : 'منضم',
                        style: const TextStyle(
                          color: kBlackColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
