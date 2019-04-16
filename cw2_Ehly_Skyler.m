
%cw2_Ehly_Skyler.m
%Genetic Algorithm to generate the genetic construction for an ant 
%with simulate_ant.m
%The maximum amount of food that can be eaten in this problem is 89

%Variables that determine how the algorithm performs
population_size = 100;
crossover_uniform_prob = .6;
mutation_prob = .8;
number_of_generations = 300;

% generate random population of chromosomes
population = zeros(population_size,30);
temp_chromosome = zeros(1, 30);
for i = 1:population_size
    current_pos = 1;
    for j=1:10
        temp_chromosome(current_pos) = randi([1,4]);
        current_pos = current_pos + 1;
        for k=1:2
            temp_chromosome(current_pos) = randi([0,9]);
            current_pos = current_pos + 1;
        end
        population(i,:) = temp_chromosome;
    end
end
% always have an extra column at end for scores
population = [population zeros(population_size,1)];

% prepare for this array once, so it can be used for rank selection below
% this array has 1 appearing 1 time, 2 appearing 2 times, and so on
rank_size = getranksize(population_size);
rank_selection_prepare = zeros(rank_size,1);
temp_n = 0;
for i = 1:population_size
    for j = 1:i
        temp_n = temp_n + 1;
        rank_selection_prepare(temp_n) = i;
    end
end

% repeat k times to create a new population
for k = 1:number_of_generations
    % evaluate fitness scores and rank them
    for i = 1:population_size
        population_num_array = population(i,1:30);
        population_char_array = arrayfun(@num2str, population_num_array, 'Uniform', false);
        population(i,31) = simulate_ant('muir_world.txt', population_char_array);
    end
    population = sortrows(population,31);
    
    %If it's the first generation, print population
    if (k==1)
        disp(['Initial Population' mat2str(population())]);
    end
    
    % elite, keep 10% or best 2
    population_new = zeros(population_size,30);
    population_new(1:2,:) = population(population_size - 1 : population_size,1:30);
    population_new_num = 2;
    
    % repeat until new population is full
    while (population_new_num < population_size)
        % use rank selection and pick two
        temp_i = rank_selection_prepare(randi([1,rank_size]));
        temp_chromosome_1 = population(temp_i, 1:30);
        temp_i = rank_selection_prepare(randi([1,rank_size]));
        temp_chromosome_2 = population(temp_i, 1:30);
        
        %Uniform crossover
        if (rand < crossover_uniform_prob)
            cross_point_one = randi([1, 27]);
            cross_point_two = randi([cross_point_one + 1, 28]);
            cross_point_three = randi([cross_point_two + 1, 29]);
            cross_part_1a = temp_chromosome_1(1 : cross_point_one);
            cross_part_1b = temp_chromosome_1(cross_point_two + 1 : cross_point_three);
            cross_part_2a = temp_chromosome_2(1 : cross_point_one);
            cross_part_2b = temp_chromosome_2(cross_point_two + 1 : cross_point_three);
            temp_chromosome_1(1 : cross_point_one) = cross_part_2a;
            temp_chromosome_1(cross_point_two + 1 : cross_point_three) = cross_part_2b;
            temp_chromosome_2(1 : cross_point_one) = cross_part_1a;
            temp_chromosome_2(cross_point_two + 1 : cross_point_three) = cross_part_1b;
        end
        
        % Mutation
        if (rand < mutation_prob)
            bit_pos = randi([1, 30]);
            temp_bit_1 = temp_chromosome_1(bit_pos);
            temp_bit_2 = temp_chromosome_2(bit_pos);
            
            % +/- 1 to the selected number making sure that the first
            % digit doesn't exceed 4 and the 2nd and 3rd digits exceed 9
            % for each state. Also make sure that no digits are less than 0
            
            % for chromosome 1
            temp_chromosome_1(bit_pos) = findnewbit(temp_bit_1);
            % for chromosome 2
            temp_chromosome_2(bit_pos) = findnewbit(temp_bit_2);
        end
        population_new_num = population_new_num + 1;
        population_new(population_new_num,:) = temp_chromosome_1;
        if (population_new_num < population_size)
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = temp_chromosome_2;
        end
    end
    
    % replace, last column not updated yet
    population(:,1:30) = population_new;
    disp(['k= ' num2str(k)]);
    disp(['Fitness score= ' num2str(population(population_size, 31))]);
end

% evaluate fitness scores and rank them
for i = 1:population_size
    population_num_array = population(i,1:30);
    population_char_array = arrayfun(@num2str, population_num_array, 'Uniform', false);
    [fitness, trail] = simulate_ant('muir_world.txt', population_char_array);
    population(i,31) = fitness;
end
population = sortrows(population,31);
disp(['population_final: ' mat2str(population())]);

%local methods 
function rank_size = getranksize(population_size)
rank_size = 0;
for i=1:population_size
    rank_size = rank_size + i;
end
end

function new_bit = findnewbit(temp_bit)
if (mod(temp_bit, 3) == 1)
    if (rand < .5)
        new_bit = temp_bit + 1;
    else
        new_bit = temp_bit - 1;
    end
    if (new_bit > 4)
        new_bit = 1;
    elseif (new_bit < 1)
        new_bit = 4;
    end
else
    if (rand < .5)
        new_bit = temp_bit + 1;
    else
        new_bit = temp_bit - 1;
    end
    if (new_bit > 9)
        new_bit = 0;
    elseif (new_bit < 0)
        new_bit = 9;
    end
end
end
