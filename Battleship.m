clear, clc;
import Game_Functions.*;

Game = Game_Functions;
%Cheats allows you to see the AI board, 1/0 to toggle
cheats = 0;
while 1
    auto_place(Game, "AI");
    prompt_place(Game, cheats);
    clc
    pPrint(Game, cheats)
    while 1
        y = input("\nInput Column: ");
        x = input("\nInput Row: ");
        while (isempty(y) || isempty(x) || ~(x<=10 && x>=0 && y<=10 && y>=0))
            clc
            fprintf("X and Y must be values 1-10 and not be already hit. \n")
            pPrint(Game, cheats)
            y = input("\nInput Column: ");
            x = input("\nInput Row: ");

        end
        hit(Game, "AI", x, y)
        %prompts player for hit until it is valid
        
        %calls AI hit until a valid coordinate is chosen
        AI_MOVE(Game);
        %Display if a player has won, else print the player board again
        if (check_ships_sunk(Game, "player"))
            clc
            fprintf("AI wins!")
            break
        elseif(check_ships_sunk(Game, "AI"))
            clc
            fprintf("Player wins!")
            break
        else
            clc
            pPrint(Game, cheats)
        end

    end
    %Play again prompt
    if (input(" Play again (y/n)? ", "s")=="y")
        clear(Game);
    else
        clc;
        break;
    end
end