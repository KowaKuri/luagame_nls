# luagame_nls
A university project in Lua programming language

1	GENERAL INFORMATION

1.1	SYSTEM OVERVIEW
Last:Stand Napoleon is a simple 2D game created in the Löve engine with the usage of the Lua programming language. The application allows to play as a solider from the Napoleonic times against one of the biggest superpowers of this times, on four different maps. 

1.2	SYSTEM CONFIGURATION
Last:Stand Napoleon is a PC game running on the Löve engine. It is compatible with the version 0.10.2. Application does not require the internet connection and can be played fully offline via the executable file. 

1.3	RESOURCES USED
Several assets have been used in the process of the game creation. All backgrounds have been created by the third parties and all copyrights belong to them. 
[Source]
Besides the backgrounds game uses several short music tracks. Those are:
Menu Theme:
•	Adieux des Chasseurs à Cheval de la Garde Impérial aux Lanciers Polonais by author unknown
In-game music:
•	Drum and fife by Richard Beddow 
•	The British Grenadiers fife and drum by author unknown
•	March of the Preobrazhensky Regiment by author unknown
•	Preussens Gloria by Johann Gottfried Piefke
•	La Victoire est a Nous by author unknown
Other in-game sounds like shooting or walking have been taken from the open-source that could be found at: https://opengameart.org/
All sprites and animations have been created manually using applications such as: Adobe Photoshop CC, Paint and Paint 3D. 
The designs on each particular soldier has been inspired by the uniforms of the Polish Legion, French and British Grenadiers, Prussian Landwehr and Russian Infantry from the period of Napoleonic Wars. 

2	GETTING STARTED

2.1	INSTALLATION
To create an executable file on the Windows operating system it is necessary to firstly gather all crucial game files as main.lua, conf.lua and assets used. Then by selecting all the necessary files it is required to create the zip and then rename the ending from .zip to .love what will create a file which can be run with the help of Löve engine. 
To create an executable, we will need to open command line and under the directory in which the file is located type (You may need to run the command as an administrator). After this procedure our game.exe file has been created and we are ready to start the game. 

2.2	SYSTEM MENU
System menu in Last:Stand Napoleon is fairly simple and easy to navigate. In order to start the game, you can press space, what will teleport you directly onto one of the four battlegrounds, chosen by random. If you would like to choose a specific map, you will need to press a corresponding button: F for France, G for Prussia, H for Britain and J for Russia.
Moreover, after finishing the round you will be able to see here your current score and your local best score.

2.3	SETTING
As it was previously mentioned game has four different battlegrounds, each with its unique troops and background music. 

3	HOW TO PLAY?

3.1	CONTROLS
 To control your legionnaire, you can use the arrow keys or wsad, depending how it is more comfortable for you. In order to make a salvo from the gun, you need to press SPACE. 
It is important to mentioned that during your salvo and reload you are unable to move so you will be required to time your shoots precisely to not take damage. 
Escape button will return you to the menu. To leave the game completely you can press the X button on the right top corner of the window with game. 

3.2	HEALTH, ARMY, SCORE AND LEVEL
If your health will drop to zero, you will die, if your army’s health will drop to zero, you will lose. Therefore, it is important to take a good care of those two bars and maintain them at the same trying to kill as many enemies as possible. Besides those two very important statistics, you can spot that they are accompanied by Score and Level. The later is following quite simple logic, the more enemies are appearing on the screen the higher is the level. 
Scores are granted not only when you kill the enemy but also when you will just injure them. Sometimes you will be able to get rid of enemy trooper by a single shot and in some cases, it will take more than that to send the foe to another world. For each injured enemy you are getting 10 points and for each killed enemy you will be getting from 20 to 60 points depending on the level. That means although the enemies that will require two shots are more dangerous and they are making the game harder, you will acquire more points from them. Another nuisance worth mentioning is that injured soldiers are moving much slower. 

3.3	OBJECTIVE
Your objective is to survive as long as it is possible, taking with you as many enemy soldiers as you can, before they will cut out your army or you will fall in glory. En avant, marche!
