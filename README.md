Wrkflux Beta 2
=======

Demo: http://labs.fluxo.art.br/wrkflux/
Download: https://dl.dropboxusercontent.com/u/46079753/Wrkflux.air

Instructions
-------

There is no need to have an account to use Workflux.

However, if you want to save you own workflows, you must register yourself. Your workflows will carry your name and you will be able to edit and delete your own workflows whenever you want.


Initial Screen
-------

If you are not logged in you will see a list of public workflows made by other users. You can browse and open them, but not edit or interact with them.

If you decided to create your own workflow without an account, it will be assigned to an anonymous user. You can edit and itneract with only during the current session. After that you won't be able to edit or delete it.

Create an account or log in to see your own workflows. You can create new ones, edit, and delete them.


Build Mode
-------

Here you can create or edit workflows. They are composed by Flags, Steps, Connections and Tags.

If you are creating a new workflow, give it a title before you start (required).

###FLAGS

Flags are the code you will use to identify the object on top of the structures. They can have a title and a distinct colour.

- Use the button “+” at the bottom to add up to 6 flags.
- Reorder them by dragging a flag up and down on the list.
- Change a flag colour by clicking on the ball.
- Change a flag title editing its label.


###STRUCTURE

Structure is composed by "steps". Each step on the structure can be connected to any other step, so your workflow does not need to be linear. You are free to put them in order and location you want. Do do have a sequence, though. But, dependences are not implemnted in this version.

For each step you can give a title, an abbreviation of the title, and choose its shapes. You have 4 choices: Rectangle, Circle, Pentagon, and Hexagon. They are very loose purpused. For now, step's shape are only a visual clue of a particular step without having any kind of particularity.

- Add a step by dragging the “Green Plus button”. Release the line on the “X” (right bottom corner) to cancel this action.
- Add a connection by dragging a line to another step.
- Click, hold, and drag a step to change its position.
- Drag the step to the “X” on the corner to remove it.
- Mouse over it to see more options. Click on the information (“i”) icon to see more details.

####Details:

- Change its title and abbreviation by editing labels.
- Select its shape (rectangle, circle, pentagon and hexagon).
- Check its connections. You can remove a connection by clicking on the “X” when mouse is over it.


###TAGS

Tags are like post-it. It is a way to annotate your workflow without puting more information on steps.

- Drag “add tag” and place it anywhere on the screen.
- Change label by editing the text inside.
- Change its position by dragging it.

*!!!!! ALL CHANGES MUST BE SAVED (upper left corner) !!!!!*

Though changes made on the workflow happen on the screen, they are queued until you hit save to actually be sent and saved to the database.



Use Mode
-------

###TOKENS

Tokens are the objects that goes on top of you workflow. They are represented by coloured circles. The colours come from the structure's flag definitions. Tokens carry information such as title, description, current flag, and current step. You can expand them to see details and change its flag. You can also follow every change made on a particular token in hte "history log" tab.

- Click on the “Green Plus Button” to add items.
- Give a title, choose the initial step and flag. Description is optional.
- Delete a document dragging it to the “X” at the bottom.
- Move items through the workflow just by click, hold and dragging them. If you release outside a step, it will go back to the original position.
- After change step, an item always goes back to the first flag (white flag, unless changed by the user).
- The list view (upper left corner) shows all items in the workflow, ordered by date (latest item first).
- One click in one item (list or token) to make the token “blink” and pop up a balloon containing its title.
- Double click in one item to open a panel with flag control and detail.
- Change flag by choosing a colour in the flag wheel.
- Check details in the side panel: Title, Step, Flag, Description and Log History.
- Click on the “X” to close.

###GENERAL

- Pinch with two fingers in your trackpad to zoom in and out (App version only).
- Pan with two finger in your trackpad to move the screen when zoomed in  (App version only).

*!!!!! ALL CHANGES HERE ARE AUTOMATICALLY SAVED IN THE DATABASE !!!!!*
