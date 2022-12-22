
A beautiful and animated bottom navigation bar.

Here are some supported style:

###### BottomBarBubble
![DEMO](https://github.com/tuannvm2109/bottom_bar_matu/blob/master/assets/bottom_bar_matu_bubble.gif)

###### BottomBarDoubleBullet
![DEMO](https://github.com/tuannvm2109/bottom_bar_matu/blob/master/assets/bottom_bar_matu_double_bullet.gif)

###### BottomBarLabelSlide
![DEMO](https://github.com/tuannvm2109/bottom_bar_matu/blob/master/assets/bottom_bar_label_slide.gif)

## Usage

###### Simple implementation with Icons.data:

```dart
bottomNavigationBar: BottomBarBubble(
    selectedIndex: _index,
    items: [
        BottomBarItem(iconData: Icons.home),
        BottomBarItem(iconData: Icons.chat),
        BottomBarItem(iconData: Icons.notifications),
        BottomBarItem(iconData: Icons.calendar_month),
        BottomBarItem(iconData: Icons.settings),
    ],
    onSelect: (index) {
      // implement your select function here
    },
),
```

###### Implementation with your custom widget:

```dart
bottomNavigationBar: BottomBarBubble(
    selectedIndex: _index,
    items: [
        BottomBarItem(
          iconBuilder: (color) => Image.asset('assets/ic_alarm.png', color: color, height: 30, width: 30)),
        BottomBarItem(
          iconBuilder: (color) => Image.asset('assets/ic_bill.png', color: color, height: 30, width: 30)),
        BottomBarItem(
          iconBuilder: (color) => Image.asset('assets/ic_box.png', color: color, height: 30, width: 30)),
    ],
    onSelect: (index) {
      // implement your select function here
    },
),
```

## License

```
Copyright (c) 2021 Tuannvm

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
