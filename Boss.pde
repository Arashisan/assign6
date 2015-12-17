// Boss image is "img/enemy2.png" 
class Boss{
    int x = 0;
    int y = 0;
    int type;
    int speed = 2;
    int hp = 5;
    
    PImage bossImg;

    Boss(int x, int y, int type){
        this.x = x;
        this.y = y;
        this.type = type;
        bossImg = loadImage("img/enemy2.png");
    }
    void move() {
        this.x+= speed;  
    }

    void draw()
    {
        image(bossImg, x, y);
    }
    
    boolean isCollideWithFighter()
    {
      if (isHit(this.x,this.y,this.bossImg.width,this.bossImg.height,fighter.x,fighter.y,fighter.fighterImg.width,fighter.fighterImg.height))
          return true;
      return false;
    }
    
    boolean isCollideWithBullet(int i)
    {
      if (isHit(this.x,this.y,this.bossImg.width,this.bossImg.height,bullets[i].x,bullets[i].y,bullets[i].bulletImg.width,bullets[i].bulletImg.height))
              return true;
      return false;
    }
    
    boolean isOutOfBorder()
    {
      if (this.x > width)
          return true;            
      return false;
    }

}
