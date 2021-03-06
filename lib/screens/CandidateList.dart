import 'package:cached_network_image/cached_network_image.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcard/tcard.dart';
import 'package:vote_app/constants/style.dart';
import 'package:vote_app/models/candidate_model.dart';
import 'package:vote_app/screens/vote_screen.dart';
import 'package:vote_app/widgets/custom_appBar.dart';

class CandidateScreen extends StatefulWidget {
  final String title;
  final String image;
  const CandidateScreen({required this.title, required this.image,});

  @override
  _CandidateScreenState createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {

  TCardController _tCardController = TCardController();

  late PageController _titlePageController;
  late List<CandidateModel> candidateLists;
  late int index = 0;

  
  Stream fKings= FirebaseFirestore.instance.collection('candidates').doc('Kings').collection('Fresher').snapshots();
  Stream fQueens= FirebaseFirestore.instance.collection('candidates').doc('Queens').collection('Fresher').snapshots();
  Stream wKings= FirebaseFirestore.instance.collection('candidates').doc('Kings').collection('Whole').snapshots();
  Stream wQueens= FirebaseFirestore.instance.collection('candidates').doc('Queens').collection('Whole').snapshots();
  CollectionReference qfKings= FirebaseFirestore.instance.collection('candidates').doc('Kings').collection('Fresher');
  CollectionReference qfQueens= FirebaseFirestore.instance.collection('candidates').doc('Queens').collection('Fresher');
  CollectionReference qwKings= FirebaseFirestore.instance.collection('candidates').doc('Kings').collection('Whole');
  CollectionReference qwQueens= FirebaseFirestore.instance.collection('candidates').doc('Queens').collection('Whole');


  @override
  void initState() { 
    super.initState();
    _titlePageController = PageController();
    fetchAllUsers().then((List<CandidateModel>list) {
      candidateLists = list;
      // return candidateLists;
      setState(() {
        candidateLists = list;
      });
      return candidateLists;
    });
  }
 

  @override
  void dispose() {
    _titlePageController.dispose();
    super.dispose();
  }

  Future<List<CandidateModel>> fetchAllUsers() async {
    QuerySnapshot querySnapshot = await getQuery().get();
    final userList = querySnapshot.docs.map(
      (doc) => CandidateModel(
        age: doc['age'],
        name: doc['name'],
        no: doc['no'],
        year: doc['year'],
        image: doc['image'], 
      )
    ).toList();
    return userList;
  }
  
  getQuery(){
    switch(widget.title){
      case 'Fresher Kings':return qfKings;
      case 'Fresher Queens':return qfQueens;
      case 'Whole Kings' :return qwKings;
      case 'Whole Queens' :return qwQueens;
    }
  }
  getData() {
    switch(widget.title){
      case 'Fresher Kings':return fKings;
      case 'Fresher Queens':return fQueens;
      case 'Whole Kings' :return wKings;
      case 'Whole Queens' :return wQueens;
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight= MediaQuery.of(context).size.height * .75;
    double cardWidth= MediaQuery.of(context).size.width-50;
    double imageHeight= MediaQuery.of(context).size.height * .5;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Object>>(
        stream: getData(),
        builder: (context, snapshot) {
          if(candidateLists.isEmpty){
            return Center(
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.person_search,color: Colors.black,),
                  iconSize: 40.0,
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> CandidateScreen(image: widget.image,title: widget.title,)));
                  },
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(title: '${widget.title}',image: widget.image,),
                TCard(
                  cards: List.generate(
                    candidateLists.length, (index){
                      return ClayContainer(
                        borderRadius: 10.0,
                        color: UIColor.clayColor,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> 
                              VoteScreen(
                                title: widget.title,
                                name: '${candidateLists[index].name}',
                                age: '${candidateLists[index].age}',
                                image: '${candidateLists[index].image}',
                                no: '${candidateLists[index].no}',
                                year: '${candidateLists[index].year}',
                              ))
                            );
                          },
                          child: Column(
                            children: [
                              Hero(
                                tag: '${candidateLists[index].image}+image',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    width: cardWidth,
                                    height: imageHeight,
                                    imageUrl: '${candidateLists[index].image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                // color: Colors.grey.shade300,
                                width: cardWidth,
                                height: MediaQuery.of(context).size.height * .17,
                                child: CandidateTitle(
                                  name: '${candidateLists[index].name}',
                                  age: '${candidateLists[index].age}',
                                  link: '${candidateLists[index].name}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  size: Size(cardWidth, cardHeight),
                  controller: _tCardController,
                  delaySlideFor: 100,
                ),

                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .17,
                //   child: PageView.builder(
                //     itemCount: candidateLists.length,
                //     physics: const NeverScrollableScrollPhysics(),
                //     controller: _titlePageController,
                //     onPageChanged: (value) {
                //       _titlePageController.animateToPage(value,
                //           duration: const Duration(milliseconds: 400),
                //           curve: Curves.fastOutSlowIn);
                //     },
                //     itemBuilder: (context, index) {
                //       return CandidateTitle(
                //         name: '${candidateLists[index].name}',
                //         age: '${candidateLists[index].age}',
                //         link: '${candidateLists[index].name}',
                //       );
                //     },
                //   ),
                // ),
                
              ],
            );
          }
          else{
            return Scaffold(
              body: Column(
                children: [
                  CustomAppBar(title: '${widget.title}',image: widget.image,),
                ],
              ),
            );
          }        
          
        },
      ),
    );
  }
}

class CandidateTitle extends StatelessWidget {
  final String name;
  final String age;
  final String link;

  const CandidateTitle({required this.name, required this.age, required this.link,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Hero(
            tag: name + "title",
            child: Text(
              name.toUpperCase(),
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24.0,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 10.0,),
        Text(
          "AGE: $age",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.brown[400],
              ),
        ),
        // Text(
        //   "Votes: ???",
        //   style: Theme.of(context).textTheme.headline5!.copyWith(
        //         color: Colors.brown[400],
        //       ),
        // ),
        SizedBox(height: 10.0,),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       "Go To fb ",
        //       style: GoogleFonts.poppins(
        //         color: UIColor.primaryColor,
        //         fontSize: 18.0,
        //         fontWeight: FontWeight.normal,
        //       )
        //     ),
        //     SizedBox(width: 15.0,),
        //     Icon(Icons.arrow_forward_ios_sharp,color: UIColor.primaryColor,size:25.0)
        //   ],
        // ),
      ],
    );
  }
}
