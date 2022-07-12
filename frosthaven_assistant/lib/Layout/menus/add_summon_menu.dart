import 'package:flutter/material.dart';
import 'package:frosthaven_assistant/Model/summon.dart';
import '../../Resource/commands/add_standee_command.dart';
import '../../Resource/enums.dart';
import '../../Resource/game_state.dart';
import '../../services/service_locator.dart';

class AddSummonMenu extends StatefulWidget {
  final Character character;

  const AddSummonMenu({Key? key, required this.character}) : super(key: key);

  @override
  AddSummonMenuState createState() => AddSummonMenuState();
}

class AddSummonMenuState extends State<AddSummonMenu> {
  final GameState _gameState = getIt<GameState>();
  int chosenNr = 1;
  String chosenGfx = "blue";

  final List<SummonModel> _summonList = [];

  @override
  initState() {
    // at the beginning, all items are shown
    super.initState();

    //populate the summon list
    _summonList.addAll(widget.character.characterClass.summons);
    for (var item in widget.character.characterClass.summons) {
      if (item.level <= widget.character.characterState.level.value) {
        _summonList.add(item);
      }
    }
    _summonList.addAll(_gameState.itemSummonData);
  }

  Widget buildGraphicButton(String summonGfx) {
    bool isCurrentlySelected;
    isCurrentlySelected = summonGfx == chosenGfx;
    Color color = Colors.transparent;
    if (isCurrentlySelected) {
      color = Colors.black;
    }
    return SizedBox(
      width: 32,
      height: 32,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: color,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: IconButton(
            onPressed: () {
              if (!isCurrentlySelected) {
                setState(() {
                  chosenGfx = summonGfx;
                });
              }
              //if all selected then pop
              //Navigator.pop(context);
            },
            icon: Image.asset('assets/images/summon/$summonGfx.png'),
            //iconSize: 30,,
          )),
    );
  }

  Widget buildNrButton(int nr) {
    bool isCurrentlySelected;
    isCurrentlySelected = nr == chosenNr;
    Color color = Colors.transparent;
    if (isCurrentlySelected) {
      //color = Colors.black;
    }
    String text = nr.toString();
    return SizedBox(
      width: 32,
      height: 32,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: color,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: TextButton(
            child: Text(
              text,
              style: TextStyle(
                  color: isCurrentlySelected ? Colors.black : Colors.grey),
            ),
            onPressed: () {
              if (!isCurrentlySelected) {
                setState(() {
                  chosenNr = nr;
                });
              }
              //do if last thing
              //Navigator.pop(context);
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336,
      height: 410,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8), BlendMode.dstATop),
          image: AssetImage('assets/images/bg/white_bg.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        const Text("Add Summon", style: TextStyle(fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGraphicButton("blue"),
            buildGraphicButton("green"),
            buildGraphicButton("yellow"),
            buildGraphicButton("orange"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGraphicButton("white"),
            buildGraphicButton("purple"),
            buildGraphicButton("pink"),
            buildGraphicButton("red"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNrButton(1),
            buildNrButton(2),
            buildNrButton(3),
            buildNrButton(4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNrButton(5),
            buildNrButton(6),
            buildNrButton(7),
            buildNrButton(8),
          ],
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _summonList.length,
                itemBuilder: (context, index) {

                  SummonModel model = _summonList[index];
                  String gfx = chosenGfx;
                  bool showNr = true;
                  if (model.gfx.isNotEmpty) {
                    gfx = model.gfx;
                    if(model.standees < 2) {
                      showNr = false;
                    }
                  }



                  return ListTile(
                    leading: Stack(
                      alignment: Alignment.center,
                        children: [
                      Image(
                        height: 30,
                        width: 30,
                        image:
                            AssetImage("assets/images/summon/$gfx.png"),
                      ),
                      if(showNr) Text(
                          chosenNr.toString(),
                          style: const TextStyle(fontSize: 18, color: Colors.white,
                              shadows: [
                                Shadow(offset: Offset(1,1 ),color: Colors.black)
                              ])
                      ),
                    ]),
                    //iconColor: _foundMonsters[index].color,
                    title: Text(_summonList[index].name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
                    onTap: () {
                      setState(() {
                        SummonModel model = _summonList[index];
                        String gfx = chosenGfx;
                        if (model.gfx.isNotEmpty) {
                          gfx = model.gfx;
                        }
                        if(model.standees < 2) {
                          chosenNr = 0; //don't show on monsterbox unless standees are numbered
                        }
                        SummonData summonData = SummonData(
                            chosenNr,
                            model.name,
                            model.health,
                            model.move,
                            model.attack,
                            model.range,
                            gfx);
                        _gameState.action(AddStandeeCommand(
                            chosenNr,
                            null,
                            summonData,
                            widget.character.characterState.summonList,
                            MonsterType.summon));
                      });
                      Navigator.pop(context);
                    });}))
      ]),
    );
  }
}
