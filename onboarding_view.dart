import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/onboarding/welcome_view.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int page = 0;
  PageController? controller = PageController();
  List pageArr = [
    {
      "title": "Uncover the Magic of Books!",
      "sub_title":"Dive into endless stories and knowledge, crafted just for you.",
      "img": "assets/img/on_1.png"
    },
    {
      "title": "Books Just for You",
      "sub_title":"Get book suggestions based on what you like to read.",
      "img": "assets/img/img2.jpg"
    },
    {
      "title": "Add to Your Collection with a Tap!",
      "sub_title":
      "Easily add your favorite books to your cart and shop hassle-free.",
      "img": "assets/img/on_3.png"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller?.addListener(() {
      page = controller?.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index] as Map? ?? {};
              return Container(
                width: media.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                child: Column(
                  children: [
                    Text(
                      pObj["title"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      pObj["sub_title"].toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: TColor.primaryLight, fontSize: 14),
                    ),
                    SizedBox(
                      height: media.width * 0.25,
                    ),
                    Image.asset(
                      pObj["img"].toString(),
                      width: media.width * 0.8,
                      height: media.width * 0.8,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomeView()));

                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: TColor.primary, fontSize: 17,
                              fontWeight: FontWeight.w700),
                        )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pageArr.map((pObj) {
                        var index = pageArr.indexOf(pObj);
              
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: page == index
                                  ? TColor.primary
                                  : TColor.primaryLight,
                              borderRadius: BorderRadius.circular(7.5)),
                        );
                      }).toList(),
                    ),

                    TextButton(
                        onPressed: () {

                          if(page < 2) {
                            page = page + 1;
                            controller?.jumpToPage(page);
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: ( context
                                ) => const WelcomeView()  ));
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: TColor.primary, fontSize: 17, fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.15,
              ),
            ],
          )
        ],
      )),
    );
  }
}
