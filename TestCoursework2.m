iterations = 50;
population_size = 100;
bestfit = 0;
bestpopulation = zeros(population_size,31);
winning_iteration = 0;
current_best = 86;
for i = 1:iterations
    disp(['Iteration: ' num2str(i)]);
    [population, fitness] = cw2_Ehly_Skyler(population_size, .0, .0, .6, .8, 300, 'rank');
    disp(['Fitness: ' num2str(fitness)]);
    if (fitness > bestfit)
        bestfit = fitness;
        bestpopulation = population;
        winning_iteration = i;
        if (fitness > current_best)
            disp('Holy shit new record!');
        end
    end
end
disp(['population_final: ' mat2str(bestpopulation())]); 
disp(['Best Fitness: ' num2str(bestfit)]);
disp(['Winning iteration: ' num2str(winning_iteration)]);