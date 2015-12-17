class GameState
{
	static final int START = 0;
	static final int PLAYING = 1;
	static final int END = 2;
}
class Direction
{
	static final int LEFT = 0;
	static final int RIGHT = 1;
	static final int UP = 2;
	static final int DOWN = 3;
}
class EnemysShowingType
{
	static final int STRAIGHT = 0;
	static final int SLOPE = 1;
	static final int DIAMOND = 2;
	static final int STRONGLINE = 3;
}
class FlightType
{
	static final int FIGHTER = 0;
	static final int ENEMY = 1;
	static final int ENEMYSTRONG = 2;
}

int state = GameState.START;
int currentType = EnemysShowingType.STRAIGHT;
int enemyCount = 8;
int bulletCount = 5;
int bossCount = 5;
int score;
int enemyScore = 20;
int bossScore = 120;
PFont f;
Enemy[] enemys = new Enemy[enemyCount];
Boss[] bosses = new Boss[bossCount];
Bullet[] bullets = new Bullet[bulletCount];
Fighter fighter;
Background bg;
FlameMgr flameMgr;
Treasure treasure;
HPDisplay hpDisplay;

boolean isMovingUp;
boolean isMovingDown;
boolean isMovingLeft;
boolean isMovingRight;

int time;
int wait = 4000;



void setup () {
	size(640, 480);
	flameMgr = new FlameMgr();
	bg = new Background();
	treasure = new Treasure();
	hpDisplay = new HPDisplay();
	fighter = new Fighter(20);
    score = 0;
    f = createFont("Arial",12);
}

void draw()
{
	if (state == GameState.START) {
		bg.draw();	
	}
	else if (state == GameState.PLAYING) {
		bg.draw();
		treasure.draw();
		flameMgr.draw();
		fighter.draw();

		//enemys
		if(millis() - time >= wait){
			addEnemy(currentType++);
			currentType = currentType%4;
		}		
            
            for (int i = 0; i < bossCount; ++i) {
                    if (bosses[i]!= null) {
                            wait = 7000;
                            bosses[i].move();
                            bosses[i].draw();
                            if (bosses[i].isCollideWithFighter()) {
                                      fighter.hpValueChange(-50);
                                      flameMgr.addFlame(bosses[i].x, bosses[i].y);
                                      bosses[i] = null;
                            }
                            else if (bosses[i].isOutOfBorder()) {
                                      bosses[i] = null;
                            }
                            
                            //collide bullet
                            for(int j= 0; j < bulletCount; ++j){
                                if (bullets[j] != null && bosses[i]!= null) {
                                    if (bosses[i].isCollideWithBullet(j)) {
                                      bullets[j] = null;
                                      bosses[i].hp -= 1;
                                      if(bosses[i].hp <= 0){
                                        flameMgr.addFlame(bosses[i].x, bosses[i].y);
                                        scoreChange(bossScore);
                                        bosses[i] = null;
                                      }
                                    }
                                }
                                    
                            }
                    }
            }
            

		for (int i = 0; i < enemyCount; ++i) {
			if (enemys[i]!= null) {
                            wait = 4000;
				enemys[i].move();
				enemys[i].draw();
                            if (enemys[i].isCollideWithFighter()) {
                                    fighter.hpValueChange(-20);
                                    flameMgr.addFlame(enemys[i].x, enemys[i].y);
                                    enemys[i] = null;
                            }
                            else if (enemys[i].isOutOfBorder()) {
                                    enemys[i] = null;
                            }
                            //collide bullet
                            for(int j= 0; j < bulletCount; ++j){
                                if (bullets[j] != null && enemys[i]!= null) {
                                    if (enemys[i].isCollideWithBullet(j)) {
                                      flameMgr.addFlame(enemys[i].x, enemys[i].y);
                                      scoreChange(enemyScore);
                                      enemys[i] = null;
                                      bullets[j] = null;
                                    }
                                }
                            }
			}
		}

            //bullet
            for (int i = 0; i < bulletCount; ++i){
                    if (bullets[i] != null) {
                            bullets[i].move();  
                            bullets[i].draw();
                            if (bullets[i].isOutOfBorder()){
                                    bullets[i] = null;
                            }
                    }
            }
                    
		// 這地方應該加入Fighter 血量顯示UI
            hpDisplay.updateWithFighterHP(fighter.hp);
            
            //show score
            showScore(score);
		
	}
	else if (state == GameState.END) {
		bg.draw();
            score = 0;
	}
}
boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh)
{
	// Collision x-axis?
    boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
    // Collision y-axis?
    boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
    return collisionX && collisionY;
}

void showScore(int i)
{
  textFont(f,26);
  textAlign(LEFT);
  fill(255);
  text("Score:"+i,10,460);
}

void scoreChange(int value)
{
  score += value;
}

void keyPressed(){
  switch(keyCode){
    case UP : isMovingUp = true ;break ;
    case DOWN : isMovingDown = true ; break ;
    case LEFT : isMovingLeft = true ; break ;
    case RIGHT : isMovingRight = true ; break ;
    default :break ;
  }
}
void keyReleased(){
  switch(keyCode){
	case UP : isMovingUp = false ;break ;
    case DOWN : isMovingDown = false ; break ;
    case LEFT : isMovingLeft = false ; break ;
    case RIGHT : isMovingRight = false ; break ;
    default :break ;
  }
  if (key == ' ') {
  	if (state == GameState.PLAYING) {
		fighter.shoot();
	}
  }
  if (key == ENTER) {
    switch(state) {
      case GameState.START:
      case GameState.END:
        state = GameState.PLAYING;
            wait = 4000;
		enemys = new Enemy[enemyCount];
            bosses = new Boss[bossCount];
		flameMgr = new FlameMgr();
		treasure = new Treasure();
		fighter = new Fighter(20);
            currentType = EnemysShowingType.STRAIGHT;
      default : break ;
    }
  }
}
