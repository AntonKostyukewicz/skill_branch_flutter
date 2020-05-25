import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/res/styles.dart';
import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage({
    this.photo = '',
    this.altDescription = '',
    this.userName = '',
    this.name = '',
    this.userPhoto = '',
    this.heroTag,
    Key key,
  }) : super(key: key);

  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;

  @override
  State<StatefulWidget> createState() {
    return FullScreenImageState();
  }

}

class FullScreenImageState extends State<FullScreenImage> with TickerProviderStateMixin {

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1500),
        vsync: this
    );
    _playAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.heroTag,
              child: Photo(photoLink: widget.photo),
            ),
            const SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.altDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.h3,
              ),
            ),
            const SizedBox(height: 9),
            PhotoMetaData(
              animationController: _animationController,
              name: widget.name,
              userName: widget.userName,
              photo: widget.userPhoto,
            ),
            const SizedBox(height: 17),
            _buildActionButton(),
          ],
        )
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Photo'),
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: LikeButton()
          ),
          Expanded(
            child: _buildButton('Save'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildButton('Visit'),
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      alignment: Alignment.center,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.dodgerBlue,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: AppStyles.h4.copyWith(color: AppColors.white)
      )
    );
  }

}

class PhotoMetaData extends StatelessWidget {

  PhotoMetaData({
    this.animationController,
    this.userName,
    this.name,
    this.photo,
    Key key
}) : opacityAvatar = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.ease),
      ),
    ),
    opacityName = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.ease),
      ),
    ),
    super(key: key);

  final String userName;
  final String name;
  final String photo;

  final AnimationController animationController;
  final Animation<double> opacityAvatar;
  final Animation<double> opacityName;


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildPhotoMetaData,
      animation: animationController,
    );
  }

  Widget _buildPhotoMetaData(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: opacityAvatar,
                child: child,
              );
            },
            child: UserAvatar(photo),
          ),
          SizedBox(width: 10),
          Opacity(
            opacity: opacityName.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: AppStyles.h1Black,
                ),
                Text("@$userName", style: AppStyles.h5Black.copyWith(color: AppColors.manatee))
              ],
            ),
          ),
        ],
      ),
    );
  }


}