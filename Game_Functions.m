classdef Game_Functions < handle

    properties
        %ships and their sizes
        pieces = ["carrier", "battleship", "cruiser", "submarine", "destroyer"];
        indexes = [5,4,3,3,2];
        %boards default to empty
        player_board = zeros(10,10);
        AI_board = zeros(10,10);
        player_board_hit = zeros(10, 10);
        AI_board_hit = zeros(10, 10);
    end
    
    methods

        %Gets length of a piece
        function length = getLength(obj, name)
            index = find(obj.pieces(1,:)==name);%find the index of the ship
            if isempty(index) %error if not found
                error("Invalid Piece Name: %s", name)
            end 
            length = obj.indexes(index);%get corresponding length
        end

        %Gets the index of a piece
        function index = getIndex(obj, name)
            index = find(obj.pieces(1,:)==name);%find index of ship
            if isempty(index)
                error("Invalid Piece Name: %s", name)
            end
        end

        %Checks if a piece will not go out of bounds or hit another piece
        function test = can_place_ship(obj, board, piece, direction, point)
            test = true; %Test will be set to false if there is a piece in the way or the ship will go out of bounds
            length = getLength(Game_Functions, piece);
            if (board=="player")%Player Board
                if (direction=="right")%Right
                    if(point(2)+length>10)%If ship will be out of bounds
                        test = false;
                    else
                        for i=(0:length-1)%If ship will intersect another ship
                            if(obj.player_board(point(1),point(2)+i, 1) ~= 0)
                            test = false;
                            end
                        end
                    end
                elseif (direction=="down")%Down
                    if (point(1)+length>10)%If ship will be out of bounds
                        test = false;
                    else
                        for i=(0:length-1)%If ship will intersect another ship
                            if (obj.player_board(point(1)+i,point(2), 1)~=0)
                                test = false;
                            end
                        end
                    end
                else 
                    error("Invalid Direction: %s", direction)
                end
            elseif (board=="AI")%AI Board
                if (direction=="right")%Right
                    if(point(2)+length>10)%If ship will be out of bounds
                        test = false;
                    else
                        for i=(0:length-1) %If ship will intersect another ship   
                            if(obj.AI_board(point(1),point(2)+i, 1) ~= 0)
                                test = false;
                            end
                        end
                    end
                elseif (direction=="down")%Down
                    if (point(1)+length>10)%If ship will be out of bounds
                        test = false;
                    else
                        for i=(0:length-1)%If ship will intersect another ship
                            if (obj.AI_board(point(1)+i,point(2), 1)~=0)
                                test = false;
                            end
                        end
                    end
                else
                    error("Invalid Direction: %s", direction)%if invalid direction
                end
            else
                error("Invalid Player Name: %s", board)%if invalid turn name
            end
        end

    
        %adds a ship to coordinate if possible, else returns false
        function test = add_ship(obj, turn, piece, direction, point)
            test = true;
            if (can_place_ship(obj, turn, piece, direction, point))
                length = getLength(obj, piece);
                if (turn=="player")
                    if (direction=="right")
                        for i=(0:length-1)
                            obj.player_board(point(1), point(2)+i, 1) = getIndex(obj, piece);
                        end
                    elseif(direction=="down")
                        for i=(0:length-1)
                            obj.player_board(point(1)+i, point(2), 1) = getIndex(obj, piece);
                        end
                    end
                elseif (turn=="AI")
                    if (direction=="right")
                        for i=(0:length-1)
                           obj.AI_board(point(1), point(2)+i, 1) = getIndex(obj, piece);
                        end
                    elseif(direction=="down")
                        for i=(0:length-1)
                           obj.AI_board(point(1)+i, point(2), 1) = getIndex(obj, piece);
                        end
                    end
                end
            else
                test = false;%If it can't place ship
            end
        end
    
    end
    methods(Static)

        %returns AI board
        function AIb = getAIBoard(obj)
            AIb = obj.AI_board;
        end
        
        %returns player board
        function pb = getPlayerBoard(obj)
            pb = obj.player_board;
        end
        
        %resets board to default
        function clear(obj)%Clear the two boards
            obj.player_board = zeros(10,10);
            obj.AI_board = zeros(10,10);
            obj.player_board_hit = zeros(10,10);
            obj.AI_board_hit = zeros(10, 10);
        end

        %Prints the player or AI board
        function print(obj, player)
            clc
            if player=="player"
                fprintf("-  1  2  3  4  5  6  7  8  9  10 Y")
                for x=1:10
                    if x<10
                        fprintf("\n%i  ", x)
                    else
                        fprintf("\n0  ")
                    end
                    for y=1:10
                        if obj.player_board(x,y) == 0
                            if obj.player_board_hit(x,y)>0
                                fprintf("-  ");
                            else
                                fprintf(".  ");
                            end
                        elseif obj.player_board(x,y)<0
                            fprintf("S  ");
                        elseif obj.player_board(x,y) > 0
                            if obj.player_board_hit(x, y) > 0
                                fprintf("H  ");
                            else
                                fprintf("%i  ", obj.player_board(x, y))
                            end
                        end
                    end
                end
            else
                fprintf("-  1  2  3  4  5  6  7  8  9  10 Y")
                for x=1:10
                    if x<10
                        fprintf("\n%i  ", x)
                    else
                        fprintf("\n0  ")
                    end
                    for y=1:10
                        if obj.AI_board(x,y) == 0
                            if obj.AI_board_hit(x,y)>0
                                fprintf("-  ");
                            else
                                fprintf(".  ");
                            end
                        elseif obj.AI_board(x,y)<0
                            fprintf("S  ");
                        elseif obj.AI_board(x,y) > 0
                            if obj.AI_board_hit(x, y) > 0
                                fprintf("H  ");
                            else
                                fprintf("%i  ", obj.AI_board(x, y))
                            end
                        end
                    end
                end
            end
            fprintf("\nX\n");
        end
        
        %Prints player view of game
        function pPrint(obj, cheats)
            fprintf("\t\t\tYour Board\t\t\t\t\tYour Opponent's Board\n")
            fprintf("   1  2  3  4  5  6  7  8  9  10  | 1  2  3  4  5  6  7  8  9 10 Y")
            fprintf("\n  ⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝")
                for x=1:10
                    if x<10
                        fprintf("\n%i ⎸ ", x)
                    else
                        fprintf("\n10⎸ ")
                    end
                    for y=1:10
                        if obj.player_board(x,y) == 0
                            if obj.player_board_hit(x,y)>0
                                fprintf("-  ");
                            else
                                fprintf(".  ");
                            end
                        elseif obj.player_board(x,y)<0
                            fprintf("S  ");
                        elseif obj.player_board(x,y) > 0
                            if obj.player_board_hit(x, y) > 0
                                fprintf("H  ");
                            else
                                fprintf("%i  ", obj.player_board(x, y))
                            end
                        end
                    end
                    fprintf("⏐ ")
                    for y=1:10
                        if obj.AI_board(x,y) == 0
                            if obj.AI_board_hit(x,y)>0
                                fprintf("■  ");
                            elseif (cheats == 1)
                                fprintf(".  ");
                            else 
                                fprintf(".  ");
                            end
                        elseif obj.AI_board(x,y)<0
                            fprintf("S  ");
                        elseif obj.AI_board(x,y) > 0
                            if obj.AI_board_hit(x, y) > 0
                                fprintf("H  ");
                            elseif (cheats == 1)
                                fprintf("%i  ", obj.AI_board(x, y))
                            else 
                                fprintf(".  ");
                            end
                        end
                    end
                    if x<10
                        fprintf("⎹ %i", x)
                    else
                        fprintf("⎹10")
                    end
                    
                end
                fprintf("\nX ⌞⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⌟\n")
               
        end
        %Function to call to get player input for locations
        function prompt_place(obj, cheats)
            pieces = ["carrier", "battleship", "cruiser", "submarine", "destroyer"];
            if (input("Randomize pieces (y/n)? ", "s")=="y")
                obj.auto_place(obj, "player")
            else
                for i=1:length(pieces)
                    while 1
                        obj.pPrint(obj, cheats);
                        fprintf("Place %s: \n", pieces(i));
                        if (add_ship(obj, "player", pieces(i), input("right or down: ", "s"), [input("row: "), input("column: ")]))
                            clc
                            break;
                        else
                            clc
                            fprintf("Error: could not place %s at the specified location\n", pieces(i));
                        end
                    end
                end
            end
        end
        
        %Randomly generates piece locations on specified board
        function auto_place(obj, player)
            pieces = ["carrier", "battleship", "cruiser", "submarine", "destroyer"];
            
            for i=1:length(pieces)
                while 1
                    if randi([1,2])==1
                        rStr = "right";
                    else
                        rStr = "down";
                    end
                    rX = randi([1,10]);
                    rY = randi([1,10]);
                    if (add_ship(obj, player, pieces(i), rStr, [rX, rY]))
                        break;
                    end
                end
            end
        end
        
        %checks if coordinate on board has already been attacked
        function test = can_attack(obj, player, x, y) 
               if (x > 10 || x < 1 || y > 10 || y < 1)
                    test = false;
               elseif (player=="player" && obj.player_board_hit(x,y)==0)
                   test=true;
               elseif (player=="AI" && obj.AI_board_hit(x, y)==0)
                   test=true;
               elseif (player~="player" && player~="AI")
                   error("invalid player name: %s", player);
               else
                   test=false;
               end
        end
        
        %attacks coordinate if possible, else returns false
        function test = hit(obj, player, x, y)
            test = true;
            if (obj.can_attack(obj, player, x, y))
               if (player=="player")
                   obj.player_board_hit(x,y)=1;
                   if obj.player_board(x,y) ~= 0 && obj.check_if_sunk(obj, player, obj.player_board(x,y))
                       obj.sink(obj, player, obj.player_board(x, y))
                   end
               
            
               elseif player=="AI"
                   obj.AI_board_hit(x,y)=1;
                   if obj.AI_board(x,y) ~= 0 && obj.check_if_sunk(obj, player, obj.AI_board(x,y))
                       obj.sink(obj, player, obj.AI_board(x, y))
                   end
               end
            else
                test = false;
            end
        end
        
        %checks if a whole piece is sunk
        function test = check_if_sunk(obj, player, piece)
            test = true;
            if (player=="player")
                for i=1:100
                    if (obj.player_board(i)==piece)
                        if (obj.player_board_hit(i)==0)
                            test = false;
                        end
                    end
                end
            else
                for i=1:100
                    if (obj.AI_board(i)==piece)
                        if (obj.AI_board_hit(i)==0)
                            test = false;
                        end
                    end
                end
            end
        end
        
        %marks a ship as sunk by replacing the ship with -1
        function sink(obj, player, piece)
            if (player=="player")
                for i=1:100
                    if (obj.player_board(i)==piece)
                        obj.player_board_hit(i) = 3;
                        obj.player_board(i) = -1;
                    end
                end
            else 
                for i=1:100
                    if (obj.AI_board(i)==piece)
                        obj.AI_board_hit(i) = 3;
                        obj.AI_board(i) = -1;
                    end
                end
            end
        end
        
        %if all ships are sunk then return winner
        function val = check_ships_sunk(obj, player)
            val = true;
            if player=="player"
                for i=1:100
                    if (obj.player_board(i)>0)
                        val=false;
                        break;
                    end
                end
            elseif player=="AI"
                for i=1:100
                    if (obj.AI_board(i)>0)
                        val=false;
                        break;
                    end
                end
            else
                error("Invalid player: %s", player);
            end
        end
        
        %ai functions
        function AI_MOVE(obj)
            hits = 0;
            for i=1:10
                for j=1:10
                    if (obj.player_board_hit(i,j)==1 && obj.player_board(i,j)>0)
                        hits = hits+1;
                    end
                end
            end
            disp(hits)
            quit = false;
            if hits>0
                for i=1:10
                    for j=1:10
                        if (obj.player_board_hit(i,j)==1 && obj.player_board(i,j)>0)
                            if obj.hit(obj, "player", i+1, j)
                                quit = true;
                                break
                            elseif obj.hit(obj, "player", i-1, j)
                                quit = true;
                                break
                            elseif obj.hit(obj,"player", i, j+1)
                                quit = true;
                                break
                            elseif obj.hit(obj, "player", i, j-1)
                                quit = true;
                                break
                            else
                                while ~obj.hit(obj, "player", randi([1,10]), randi([1,10]))
                                    quit = true;
                                end
                            end
                        end
                    end
                    if quit
                        break
                    end
                end
            else
                while ~obj.hit(obj, "player", randi([1,10]), randi([1,10]))
                end
            end
        end
    end
end
