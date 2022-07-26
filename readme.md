# 尼尔机械纪元e结局复刻开发文档
## 一、开发参考
1. [尼尔机械纪元.百度百科](https://baike.baidu.com/item/%E5%B0%BC%E5%B0%94%EF%BC%9A%E6%9C%BA%E6%A2%B0%E7%BA%AA%E5%85%83/18761799?fr=aladdin)
2. [尼尔机械纪元e结局.谢谢你们为我挡子弹以及很抱歉用掉这么多.bilbil](https://www.bilibili.com/video/BV1Ss411H7Aj?spm_id_from=333.337.search-card.all.click&vd_source=f2585a535b99217da5822331c2283fa3)
3. [godot引擎官方文档](https://docs.godotengine.org/zh_CN/latest/index.html)
4. 以及csdn相关文档
5. 张进年制作了游戏音效、BGM为游戏本体original soundtrack
6. 角色贴图、UI绘制参考了游戏本体，是自己画的
## 二、内容梗概
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;尼尔机械纪元e结局，The (E)nd of YoHRa，一直跟随在主角身边的机器人pod具有了灵魂，不想让进行最终决战的两位主角牺牲。以**黑入游戏**的形式对抗整个制作组，修改代码来改变这个悲惨的结局。
本次复刻的内容即为玩家操控骇入的小飞机对抗制作者名单，在本家中飞机战斗非常困难，一个人通关需要约**一个小时**，游戏在角色死亡后会弹出窗口询问是否愿意继续坚持下去改变现实。
并且此时也会有已经成功通关的世界其他玩家的祝福，当坚持再战3次后，其他世界的玩家会化为僚机在玩家身边盘旋，增加输出并且抵挡伤害。当僚机被击中后会消失，此时屏幕会显示僚机本体的存档损坏，在10秒钟后会再产生一架飞机重新加入战斗。
当玩家在僚机的辅助之下成功通关后，世界的规则会被篡改，已经觉醒的pod抓着已经损坏的人造人手臂开始修复。此时游戏会询问玩家是否愿意删除存档来帮助别人。玩家选择完毕后游戏结束，回到标题画面。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在这次的复刻中，只实现了小飞机发射子弹射击，制作组的敌方飞机发射3种不同弹幕并且有两种不同子弹，黄色子弹可以被主角发射的子弹抵消，紫色子弹只能回避。
并且能够记录玩家的死亡次数，当玩家死亡时生成弹窗并且重置玩家位置。弹窗中的文字会从数组中随机抽取。在玩家选择放弃后游戏会自己退出，而选择坚持游戏，那么就会重置玩家的血量并且记录死亡次数+1，当死亡次数达到4次后，玩家身边会有僚机旋转围绕着，并且僚机也能射出子弹。
## 三、代码实现（超链接）
#### [主角](./脚本/主角.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;一开始的设想是主角可以像游戏本体那样自由旋转，但是考虑到纯键盘操作旋转飞机非常难受，所以放弃了这种想法，采用了常见的弹幕射击游戏的操作方法。
并且在实时检测血量的时候根据血量对主角的贴图进行调整。在检测到输入的时候生成子弹，并且开启射击冷却倒计时。在主角死亡后根据不同的情况触发相应的信号，链接其他模块。

#### [僚机本体](./脚本/僚机本体.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本质上是复制了主角的部分代码，一开始想实现僚机环绕的时候是直接拿主角来环绕的，但是发现会出现反复嵌套的情况，所以就新建了一个僚机的对象。并且作为旋转路线的子类使用。
考虑到僚机是在主角死亡并且再战4次才能出现的隐藏角色，所以一开始是被禁用了显示和碰撞的，当主角触发“friends”信号时，才会启用僚机。

#### [僚机生成、旋转](./脚本/僚机生成1.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;僚机旋转这一块卡了很久，网上找到的方法都是followPath2D的节点绘制贴图，然后让节点移动。但是又不想放弃之前做好的僚机，就只能通过在FollowPath2D上找点，让僚机时刻移动到这个点上。但是！
FollowPath2D一个对象只能创建一个点，只能实现一个僚机的移动。妥协的结果就是创建了6个PathFollow2D对象，并且附加基本相同的代码，此处超链接的是1号飞机的代码。
但是在尝试多种方法修复之后，依旧无法解决，僚机产生时射速鬼畜的情况，在没有做僚机隐藏并且召唤的功能的时候都还是很正常，这一点将在后续更新中解决。

#### [可破坏子弹](./脚本/可破坏子弹.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;黄色子弹，打到玩家会造成1点伤害，会因为碰撞到玩家或者玩家的子弹而消失。

#### [不可破坏子弹](./脚本/不可破坏子弹.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;紫色子弹，打到玩家会造成1点伤害，只会因为碰到玩家而消失

#### [主角子弹](./脚本/子弹.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;长方形黄色子弹，碰到子弹或者敌人会消失，造成一点伤害。

#### [敌人](./脚本/enemy1.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;关键在于三种不同的子弹发射方式，原版游戏中是可破坏子弹与不可破坏子弹交替在同一种发射方式中出现，但是尝试了很多次都无法实现，只能让不同子弹在不同发射方式中单独出现。
敌人的贴图用的是方正像素字体，写的是作者名字，不商用应该没什么关系。当时选择做这个复刻一部分原因就是因为不需要怎么画贴图。

#### [敌人生成](./脚本/enemy_Create.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;规划是难度逐渐上升，最后保持不变。敌人的生成延时在一定范围内随机，然后越来越短。但是考虑到机能的限制，弹幕一旦多起来游戏就会卡顿。
也正是因为如此敌人只有一个子弹的发射点，并没有做到原版游戏那样的三个。

[沿着指定路线移动的敌人（废案）](./脚本/enemy2.gd)

[敌人运动指定路线（废案）](./脚本/path.gd)

#### [对话框生成](./脚本/对话框生成.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;对话框其实一开始是隐藏的，当触发对话框显示信号的时候，调整对话框的可见性并且暂停游戏。

#### [对话框内容](./脚本/talks.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;设置对话框的文字，在数组内随机取，但是表示继续战斗的回答都是“否”

#### [对话框交互](./脚本/对话框2.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;是对话框两个按钮的脚本，选“是”就自动关闭游戏，“否”就触发主角再次战斗的信号。

[对话框交互与内容整合（废案，失败了）](./脚本/对话框.gd)

#### [全局变量设置](./脚本/global.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;用来在世界场景中生成对象的自定义函数

#### [游戏场景-主程序](./脚本/场景.gd)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;设置世界对象

## 四、操作方法
1. 移动：WASD
2. 射击：空格、回车
3. 操纵飞机击破制作组名单
