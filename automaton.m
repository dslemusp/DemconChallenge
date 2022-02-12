function automaton(user_input)

% Get input from user
% user_input = input('\n', 's');
input_list = strsplit(strtrim(user_input),' ');

%% Check if input elements are correct
if numel(input_list) < 6
    error('Number of input arguments must be at least 6 (i.e. "automaton_type L G init_start X init_end")');
end

% Check for correct automaton type
automaton_type = input_list{1};
automaton_types = {'A','B','U'};
if ~ismember(automaton_type,automaton_types)
    error('Wrong automaton type on first argument. Use A, B or U');
end

% Get number of cells of the automaton
L = str2double(input_list{2});
% Get number of generation of the automaton
G = str2double(input_list{3});

array = [L G];
type  = {'number of cells of the automaton', 'number of generation of the automaton'};
for i = 1 : length(array)
    check_positive_int(array(i),type{i});
end

% Check for init_start and init_end
if ~strcmp(input_list{4},'init_start')
    error('Fourth argument must be "init_start"');
end

% Check if init_end is after
% Start looking from the 6 position onwards as at least one argument must
% go in between init_start and init_end
init_end_idx = 5 + find(strcmp('init_end',input_list(6:end)));
if isempty(init_end_idx)
    error('"init_end" is not part of the input or there are not elements after init_start');
end

% Get elements between init_start and init_end
initial_pos = str2double(input_list(5:init_end_idx-1));

% Check that all inputs are numbers
check_positive_int(initial_pos,'initial configuration')

% Remove positions that are bigger than the number of cells
initial_pos(initial_pos > L) = [];

% Get rule list for different automaton 
states =  [0 0 0 
           0 0 1 
           0 1 0 
           0 1 1 
           1 0 0 
           1 0 1 
           1 1 0 
           1 1 1];
switch automaton_type
    case 'A'
        new_value = [0 1 0 1 1 1 1 0]';
    case 'B'
        new_value = [0 1 1 0 1 0 1 0]';
    case 'U'
        % Universal automaton
        new_value = str2double(input_list(init_end_idx+1:end))';
    
        % Check for the right length
        if numel(new_value) ~= 8
            error('Wrong number of customized values');
        end
        % Check for either 1 or 0 input
        if ~all((new_value == 1 | new_value == 0))
            error('Wrong rule list!. Only boolean values are allowed for the rule list');
        end
end
rule_list = [states new_value];

% Run automaton 
% Create initial state
current_gen = zeros(1,L);
current_gen(initial_pos) = 1;
% Loop over the generations
for i = 1 : G
    % Print current gen
    printGeneration(current_gen)

    % Initialize new state vector
    new_gen = zeros(1,L);
    % Loop over the cells
    for j = 2 : L+1

        % append zeros at the beggining and end to handle first and last
        % cells
        i_state = [0 current_gen 0];
        % Get current cell and neighbours
        cell_n_nei = i_state(j-1:j+1);
        
        % Get new value according to rule list
        new_gen(j-1) = rule_list(all((rule_list(:,1:3) == cell_n_nei),2),4);

    end
    current_gen = new_gen;
end
% Print last generation
printGeneration(current_gen)
end

function check_positive_int(number,str)
    if any(isnan(number))
        error('Please input a numeric input as %s',str);
    end
    % Check for positive integers
    if any(~(floor(number) == number)) || any(number <= 0)
        error('Please input a positive integer as %s',str);
    end
end