import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common.dart';
import '../constant.dart';
import '../stack.dart';

class NextPage extends StatelessWidget {
  final scroll = Get.find<PageController>();
  final scrolling = Get.find<Scrolling>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var isFooter = scrolling.isFooter.value;
        return IgnorePointer(
          ignoring: isFooter ? true : false,
          child: AnimatedOpacity(
            duration: kDuration * 2,
            curve: kCurve,
            opacity: isFooter ? 0 : 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: padded(
                child: SizedBox(
                  width: kFooterHeight,
                  height: kFooterHeight,
                  child: StackWithAllChildrenReceiveEvents(
                    children: [
                      AnimatedContainer(
                        decoration: _buildBoxDecoration(),
                        duration: kDuration * 2,
                        curve: kCurve,
                        child: Material(
                          type: MaterialType.circle,
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () => scroll.animateToPage(
                              scroll.page.toInt() + 1,
                              duration: kDuration,
                              curve: Curves.easeOutQuad,
                            ),
                          ),
                        ),
                      ),
                      _ScrollPropagation(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildBoxDecoration() {
    var isHeader = scrolling.isHeader.value;
    var isFooter = scrolling.isFooter.value;
    var hiding = isHeader || isFooter;
    return BoxDecoration(
      border: Border.all(
        color: hiding ? Colors.transparent : Get.theme.accentColor,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          hiding ? 0 : 45,
        ),
      ),
    );
  }
}

class _ScrollPropagation extends StatelessWidget {
  final scroll = Get.find<PageController>();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (e) {
        if (e is ScrollUpdateNotification) {
          scroll.jumpTo(scroll.offset + e.scrollDelta);
        }
        return true;
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: double.maxFinite,
          width: kFooterHeight,
        ),
      ),
    );
  }
}
