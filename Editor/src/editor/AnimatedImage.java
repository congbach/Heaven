package editor;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class AnimatedImage extends JLabel implements Runnable {
	
	private static final long serialVersionUID = 1L;
	

	/**
	 * The threads which run the animation
	 */
	private Thread animationThread;
	/**
	 * All the frames images of this
	 */
	private BufferedImage[] framesImages;
	/**
	 * All the frames in the current animation
	 */
	private int[] animFrames;
	/**
	 * The frame rate per second of the animation
	 */
	private int fps;
	/**
	 * Flag to indicate whether repeated is enable
	 */
	private Boolean isRepeated;
	/**
	 * The id of the current animation frame, in the
	 * animFrames array
	 */
	private int currentAnimId;
	
//	/**
//	 * Convenient constructor
//	 * 
//	 * @param	image
//	 * 			is whole images, which contains many small frames images
//	 * @param	frameSize
//	 * 			is the size of each frame image
//	 */
//	public AnimatedImage(BufferedImage image, Dimension frameSize) {
//		
//	}
    
	BufferedImage oneImageFrame;
	/**
	 * Convenient constructor
	 * 
	 * @param	image
	 * 			is whole images, which contains many small frames images
	 * @param	cols
	 * 			is the number of cols of the images
	 * @param	rows
	 * 			is the number of rows of the images
	 */
	public AnimatedImage(BufferedImage image, int cols, int rows) {
//		this(image, new Dimension((int)(image.getWidth() / cols), (int)(image.getHeight() / rows)));
		int frameWidth = image.getWidth() / cols;
        int frameHeight = image.getHeight() / rows;
        setSize(frameWidth, frameHeight);
        int totalFrames = rows * cols;
        framesImages = new BufferedImage[totalFrames];
        
        // X-y position of the original image
        int xPos = 0, yPos = 0, frameId = 0;
        for (int rowId = 0; rowId < rows; rowId++) {
        	for (int colId = 0; colId < cols; colId++) {
        		BufferedImage frameImage =
        			new BufferedImage( frameWidth, frameHeight, BufferedImage.TYPE_INT_ARGB );
                Graphics2D g = frameImage.createGraphics();
                g.drawImage( image, 0, 0, frameWidth, frameHeight,
                		xPos, yPos, xPos + frameWidth, yPos + frameHeight, null );
                framesImages[frameId++] = frameImage;
        		xPos += frameWidth;
        	}
        	xPos = 0;
        	yPos += frameHeight;
        }
	}
	
	/**
	 * Start the animation
	 * 
	 * @param	animatedFrames
	 * 			is the frames in the animation
	 * @param	fps
	 * 			is the frame rate per second
	 * @param	isRepeated
	 * 			indicate whether to repeat the animation when one loop is over
	 */
	public void startAnimation(int[] animatedFrames, int fps, Boolean isRepeated) {
		this.animFrames = animatedFrames;
		this.fps = fps;
		this.isRepeated = isRepeated;
		animationThread = new Thread(this);
		animationThread.start();
	}
	
	/**
	 * Stop the animation
	 */
	public void stopAnimation() {
		animationThread.stop();
	}
	
	@Override
	public void paint(Graphics g) {
		super.paint( g );
		if (animFrames != null && currentAnimId >= 0 && currentAnimId < animFrames.length)
			g.drawImage(framesImages[animFrames[currentAnimId]], 0, 0, null);
		else
			g.drawImage(framesImages[0], 0, 0, null);
	}
	
	@Override
	public void run() {
		while (true) {
			currentAnimId = 0;
			while (currentAnimId < animFrames.length) {
				long time = System.currentTimeMillis();
				repaint();
				currentAnimId++;
				try {
					time += 1000 / fps;
					Thread.sleep( Math.max(0, time - System.currentTimeMillis()) );
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}			
			if (! isRepeated) break;
		}
		
	}

}
