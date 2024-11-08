import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);
 //공격 메서드
  void attackMonster(Monster monster) {
    int damage = attack - monster.defense;
    damage = damage < 0 ? 0 : damage;
    monster.health -= damage;
    print('$name이 ${monster.name}에게 ${damage}의 피해를 입혔습니다.');
  }
 //방어 메서드
  void defend() {
    health += 5;
    print('$name이 방어하여 체력이 5 증가했습니다.');
  }
//상태 출력 메서드
  void showStatus() {
    print('$name의 체력: $health, 공격력: $attack, 방어력: $defense');
  }
}

class Monster {
  String name;
  int health;
  int attack;
  final int defense = 0;

  Monster(this.name, this.health, int maxAttack) {
    Random random = Random();
    this.attack = random.nextInt(maxAttack);
  }

  void attackCharacter(Character character) {
    int damage = attack - character.defense;
    damage = damage < 0 ? 0 : damage;
    character.health -= damage;
    print('$name이 ${character.name}에게 ${damage}의 피해를 입혔습니다.');
  }

  void showStatus() {
    print('$name의 체력: $health, 공격력: $attack');
  }
}

class Game {
  Character character;
  List<Monster> monsters;
  int defeatedMonsters = 0;
  int monstersToDefeat;

  Game(this.character, this.monsters, this.monstersToDefeat);

  void startGame() {
    print('${character.name}이(가) 게임을 시작합니다.');
    while (character.health > 0 && defeatedMonsters < monstersToDefeat) {
      Monster monster = getRandomMonster();
      print('${monster.name}와 대결을 시작합니다!');
      
      battle(monster);

      if (monster.health <= 0) {
        defeatedMonsters++;
        print('몬스터를 물리쳤습니다! (${defeatedMonsters}개 몬스터 처치)');
        if (defeatedMonsters >= monstersToDefeat) {
          print('게임에서 승리하셨습니다!');
          break;
        }

        print('다음 몬스터와 대결하시겠습니까? (y/n)');
        String? input = stdin.readLineSync();
        if (input?.toLowerCase() != 'y') {
          print('게임을 종료합니다.');
          break;
        }
      }
    }

    if (character.health <= 0) {
      print('게임 오버! ${character.name}의 체력이 0 이하가 되었습니다.');
    }
  }

  void battle(Monster monster) {
    while (monster.health > 0 && character.health > 0) {
      character.showStatus();
      monster.showStatus();

      print('행동을 선택하세요: 1. 공격  2. 방어');
      String? choice = stdin.readLineSync();

      if (choice == '1') {
        character.attackMonster(monster);
      } else if (choice == '2') {
        character.defend();
      } else {
        print('잘못된 입력입니다.');
        continue;
      }

      if (monster.health > 0) {
        monster.attackCharacter(character);
      }
    }
  }

  Monster getRandomMonster() {
    Random random = Random();
    return monsters[random.nextInt(monsters.length)];
  }

  void saveGameResult() {
    print('결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'y') {
      File file = File('result.txt');
      file.writeAsStringSync(
          '캐릭터: ${character.name}, 남은 체력: ${character.health}, 게임 결과: ${character.health > 0 ? "승리" : "패배"}');
      print('게임 결과가 저장되었습니다.');
    }
  }
}

