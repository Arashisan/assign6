class Bullet{
	int x = 0;
	int y = 0;
    	PImage bulletImg;
	Bullet(int x, int y) {
		this.x = x;
		this.y = y;
            	bulletImg = loadImage("img/shoot.png");
	}
    void move()
    {
            this.x -= 6;            
    }
    
    void draw()
    {
            image(bulletImg,x,y);
    }
    
    boolean isOutOfBorder()
    {
            if (this.x < 0 - this.bulletImg.width)
                  return true;
            return false;
    }
}
